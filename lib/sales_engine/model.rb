$:.unshift("./")
require 'sales_engine/ext'
require 'sales_engine/csv_db'
require 'bigdecimal'

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

    def set_attribute(attr, value)
      type = self.class.get_type_of(attr)
      casted_value = self.class.type_cast(value, type)
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
        @all ||= []
      end

      def load
        table = Model.database.table(table_name)
        @all  = table.map { |row| new(row) }
      end

      def random
        all.sort_by{ rand }.first
      end

      def find(attr,criteria)
        all.select { |k| k.send(attr) == criteria }
      end

      def method_missing(name,*args)
        name = name.to_s
        if name.start_with?("find_by")
          attr = name.gsub(/^find_by_/,"").to_sym
          find(attr,args[0]).first if instance_methods.include? attr
        elsif name.start_with?("find_all_by")
          attr = name.gsub(/^find_all_by_/,"").to_sym
          find(attr,args[0]) if instance_methods.include? attr
        else
          super(name.to_sym, *args)
        end
      end

    end
  end
end
