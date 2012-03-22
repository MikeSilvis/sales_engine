require 'sales_engine/model'
require 'sales_engine/invoice'
require 'sales_engine/transaction'
require 'sales_engine/merchant'

module SalesEngine
  class Customer
    include SalesEngine::Model

    field :id,          :integer
    field :first_name,  :string
    field :last_name,   :string
    field :created_at,  :datetime
    field :updated_at,  :datetime

    def invoices
      SalesEngine::Invoice.find("customer_id", id)
    end

    def transactions
      invoices.map do |i|
        i.transactions
      end.flatten
    end

    def favorite_merchant
      invoices.group_by { |i| i.merchant }.
               max_by{ |m,is| is.map(&:transactions).flatten.size }[0]
    end

    def days_since_activity

    end

    def pending_invoices

    end

    def self.most_items

    end

    def self.most_revenue

    end

  end


end
