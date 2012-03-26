require 'sales_engine/model'
require 'sales_engine/invoice'
require 'sales_engine/transaction'
require 'sales_engine/merchant'

module SalesEngine
  class Customer
    include SalesEngine::Model

    has_many :invoices
    field :first_name, :string
    field :last_name,  :string

    def transactions
      invoices.map do |i|
        i.transactions
      end.flatten
    end

    def favorite_merchant
      invoices.group_by { |i| i.merchant }.
               max_by{ |m,is| is.sum { |i| i.transactions.count }}[0]
    end

    def days_since_activity
      raise "Not implemented"
    end

    def pending_invoices
      raise "Not implemented"
    end

    def self.most_items
      raise "Not implemented"
    end

    def self.most_revenue
      raise "Not implemented"
    end
  end
end
