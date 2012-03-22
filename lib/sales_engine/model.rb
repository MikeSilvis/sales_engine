$:.unshift("./")
require 'sales_engine/ext'
require 'sales_engine/csv_db'
require 'bigdecimal'
require 'sales_engine/object_store'

module SalesEngine
  module Model
    def self.included(base)
      base.extend(ModelClassMethods)
    end

    def self.database=(db)
      @db = db
    end

    def self.database
      @db
    end

    def initialize(attributes)
      if attributes
        attributes.each do |attr, value|
          set_attribute(attr, value)
        end
      end
    end

    def to_i
      id
    end

    def set_attribute(attr, value)
      type = self.class.get_type_of(attr)
      casted_value = self.class.type_cast(value, type)

      if attr.to_s.end_with?("_id") && self.class == value.class
        association = attr.gsub(/_id$/, '')
        instance_variable_set("@#{association}", value)
      end

      instance_variable_set("@#{attr}", casted_value)
    end

    def get_attribute(attr)
      instance_variable_get("@#{attr}")
    end

    module ModelClassMethods
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

      def create(attributes)
        now = DateTime.now
        default_attrs = {created_at: now, updated_at: now}
        attributes = default_attrs.merge(attributes)
        object_store << new(attributes)
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
          DateTime.parse(obj)
        when :decimal
          BigDecimal(obj)
        else
          raise "Type '#{type}' unsupported."
        end
      end

      def has_many(attr)
        [name, attr.to_s.deconstantize].join("::").constantize
      end

      def table_name
        name.split("::").last.tableize
      end

      def all
        object_store.items
      end

      def load
        table = Model.database.table(table_name)
        items = table.map { |row| new(row) }
        object_store.merge(items)
      end

      def random
        index = rand * (all.size - 1)
        all[index]
      end

      def find(attr,criteria)
        (@find_cache ||= {})[attr][criteria]
      end

      def method_missing(name, *args)
        name = name.to_s
        if name.start_with?("find_by")
          attr = name.gsub(/^find_by_/,"").to_sym
          object_store.find(attr, args[0]).first
        elsif name.start_with?("find_all_by")
          attr = name.gsub(/^find_all_by_/,"").to_sym
          object_store.find(attr, args[0])
        else
          super(name.to_sym, *args)
        end
      end

    end
  end
end
