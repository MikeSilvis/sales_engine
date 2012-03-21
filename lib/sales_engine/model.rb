$:.unshift("./")
require 'sales_engine/ext'
require 'sales_engine/csv_db'

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
      instance_variable_set("@#{attr}", value)
    end

    module ModelClassMethods
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
        @all = table.map { |row| new(row) }
      end
    end
  end
end


class Customer
  include SalesEngine::Model

  def full_name
    first + last
  end
end

SalesEngine::Model.database = SalesEngine::CSVDatabase.new("../data/customers.csv")

Customer.load
puts Customer.all.inspect