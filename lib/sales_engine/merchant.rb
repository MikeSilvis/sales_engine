require 'sales_engine/model'
require 'sales_engine/item'
require 'sales_engine/invoice'

module SalesEngine

  class Merchant
    include Model

    ## Has_many :invoices, :items
    attr_accessor :id, :name, :created_at, :updated_at
    def self.most_revenue

    end

    def self.most_items

    end

    def self.revenue(date)

    end

    def revenue

    end

    def favorite_customer

    end

    def customers_with_pending_invoices

    end

    def items
        Item.find("merchant_id", id)
    end

    def invoices
        Invoice.find("merchant_id",id)
    end

  end

end