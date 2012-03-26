$:.unshift("./")
require 'bigdecimal'
require 'date'

require 'sales_engine/object_store'
require 'sales_engine/ext'
require 'sales_engine/csv_database'

module SalesEngine
  module Model
    def self.included(base)
      base.extend(ModelClassMethods)
      base.field(:id,         :integer)
      base.field(:created_at, :datetime)
      base.field(:updated_at, :datetime)
    end

    def self.database=(db)
      @db = db
    end

    def self.database
      @db
    end

    def initialize(attributes=nil)
      if attributes
        attributes.each do |attr, value|
          set_attribute(attr, value, false)
        end
      end
    end

    def to_i
      id
    end

    def ==(comparison_object)
      super ||
        comparison_object.instance_of?(self.class) &&
        !id.nil? &&
        comparison_object.id == id
    end

    alias :eql? :==

    def hash
      id.hash
    end

    def set_attribute(attr, value, save_object=true)
      type = self.class.get_type_of(attr)
      casted_value = self.class.type_cast(value, type)

      if attr.to_s.end_with?("_id") && self.class == value.class
        association = attr.gsub(/_id$/, '')
        instance_variable_set("@#{association}", value)
      end

      instance_variable_set("@#{attr}", casted_value)

      save if save_object
    end

    def save
      now = DateTime.now

      if id.nil?
        set_attribute(:id, self.class.next_id, false)
      end

      if created_at.nil?
        set_attribute(:created_at, now, false)
      end

      set_attribute(:updated_at, now, false)

      self.class.object_store.update(self)
    end

    def get_attribute(attr)
      instance_variable_get("@#{attr}")
    end

    module ModelClassMethods

      def next_id
        if all.size > 0
          all.max_by {|record| record.id}.id + 1
        else
          0
        end
      end

      def create(attributes=nil)
        record = new(attributes)
        record.save

        record
      end

      def field(name, type)
        name = name.to_s
        set_type_of(name, type)

        define_method(name) do
          get_attribute(name)
        end

        define_method(name+"=") do |value|
          set_attribute(name, value)
        end
      end

      def has_many(association, options={})
        if options[:through]
          class_eval(<<-CODE, __FILE__, __LINE__ + 1)
            def #{association}
              #{options.fetch(:through)}.map(&:#{association})
            end
          CODE
        else
          association    = association.to_s
          model_constant = [name.deconstantize, association.depluralize.camelize].join("::")
          belongs_to_id  = "#{table_name.depluralize}_id"

          class_eval(<<-CODE, __FILE__, __LINE__ + 1)
            def #{association}
              #{model_constant}.find_all_by_#{belongs_to_id}(id)
            end
          CODE
        end
      end

      def has_one(association)
        association    = association.to_s
        model_constant = [name.deconstantize, association.camelize].join("::")
        belongs_to_id  = "#{table_name.depluralize}_id"

        class_eval(<<-CODE, __FILE__, __LINE__ + 1)
          def #{association}
            #{model_constant}.find_by_#{belongs_to_id}(id)
          end
        CODE
      end

      def belongs_to(association)
        association    = association.to_s
        model_constant = [name.deconstantize, association.camelize].join("::")
        belongs_to_id  = "#{association}_id"

        field(belongs_to_id, :integer)
        class_eval(<<-CODE, __FILE__, __LINE__ + 1)
          def #{association}
            #{model_constant}.find_by_id(#{belongs_to_id})
          end
        CODE
      end

      def delete_all
        object_store.clear
      end

      def object_store
        @object_store ||= ObjectStore.new
      end

      def get_type_of(attr)
        (@attr_types ||= {})[attr.to_sym]
      end

      def set_type_of(attr, value)
        (@attr_types ||= {})[attr.to_sym] = value
      end

      def type_cast(obj, type)
        return obj unless type

        case type.to_sym
        when :string
          obj.to_s
        when :integer
          obj.to_i
        when :datetime
          obj.is_a?(DateTime) ? obj : DateTime.parse(obj.to_s)
        when :decimal
          obj.is_a?(BigDecimal) ? obj : BigDecimal(obj)
        else
          raise "Type '#{type}' unsupported."
        end
      end

      def all
        object_store.items
      end

      def load
        table = Model.database.table(table_name)
        table.each do |row|
          create(row)
        end
      end

      def random
        index = rand * (all.size - 1)
        all[index]
      end

      def find(attr, criteria)
        object_store.find_indexed(attr, criteria)
      end

      def table_name
        name.split("::").last.tableize
      end

      def method_missing(name, *args)
        name = name.to_s
        if name.start_with?("find_by_")
          attribute   = name.gsub(/^find_by_/,"")
          finder_name = "find_all_by_#{attribute}"

          define_singleton_method(finder_name) do |target_value|
            find(attribute, target_value).first
          end

          send(finder_name, args[0])

        elsif name.start_with?("find_all_by_")
          attribute   = name.gsub(/^find_all_by_/,"")
          finder_name = "find_all_by_#{attribute}"

          define_singleton_method(finder_name) do |target_value|
            find(attribute, target_value)
          end

          send(finder_name, args[0])
        else
          super(name.to_sym, *args)
        end
      end
    end
  end
end
