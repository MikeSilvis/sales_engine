require 'bigdecimal'
require 'date'

require_relative 'object_store'
require_relative 'ext'
require_relative 'csv_database'

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
          send("#{attr}=", value)
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

    def get_attribute(attr)
      instance_variable_get("@#{attr}")
    end

    # TODO: This super sucks.
    def set_attribute(attribute, value, save_object=true)
      attribute = attribute.to_s
      type = self.class.get_type_of(attribute)
      casted_value = self.class.type_cast(value, type)

      if attribute.end_with?("_id") && value.is_a?(Model)
        set_belongs_to_assoc(attribute, value)
      #elsif value.is_a?(Model)
        #id_field = value.class.table_name.depluralize + "_id"
        #set_attribute(id_field, value.id)
      end

      instance_variable_set("@#{attribute}", casted_value)

      save if save_object
    end

    def set_belongs_to_assoc(attribute, value)
      association = attribute.gsub(/_id$/, '')
      instance_variable_set("@#{association}", value)
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

        define_attribute_get(name)
        define_attribute_set(name)
        define_finders(name)
      end

      def define_attribute_set(attribute)
        define_method(attribute+"=") do |value|
          set_attribute(attribute, value)
        end
      end

      def define_attribute_get(attribute)
        define_method(attribute) do
          get_attribute(attribute)
        end
      end

      def define_finders(attribute)
        define_singleton_method("find_by_#{attribute}") do |target_value|
          find(attribute, target_value).first
        end
        define_singleton_method("find_all_by_#{attribute}") do |target_value|
          find(attribute, target_value)
        end
      end

      def has_many(association, options={})
        association = association.to_s

        if options[:through]
          class_eval(<<-CODE, __FILE__, __LINE__ + 1)
            def #{association}
              #{options.fetch(:through)}.map(&:#{association.depluralize})
            end
          CODE
        else
          model_constant =
              [name.deconstantize, association.depluralize.camelize].join("::")
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

          def #{association}=(model)
            set_attribute("#{belongs_to_id}", model.id)
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
        when :string   then obj.to_s
        when :integer  then obj.to_i
        when :datetime
          obj.is_a?(DateTime) ? obj : DateTime.parse(obj.to_s) rescue nil
        when :decimal
          obj.is_a?(BigDecimal) ? obj : BigDecimal(obj.to_s) / 100
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
    end
  end
end
