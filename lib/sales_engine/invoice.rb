require 'sales_engine/model'
module SalesEngine

  class Invoice
    include Model

    field :id,            :integer
    field :customer_id,   :integer
    field :merchant_id,   :integer
    field :status,        :string
    field :created_at,    :datetime
    field :updated_at,    :datetime

    def transactions
      Transaction.find("invoice_id", id)
    end

    def invoice_items
      InvoiceItem.find("invoice_id", id)
    end

    def merchant
      Merchant.find("id", merchant_id).first
    end

    def items
      invoice_items.map {|i| i.item}
    end

    def customer
      Customer.find("id", customer_id).first
    end

    def pending?
      !paid?
    end

    def paid?
      transactions.any?(&:successfully_procesed?)
    end

    def total_cost
      items.map(&:total_cost).sum
    end

    def item_count
      items.map(&:quantity).sum
    end

    def charge(attributes)
      attributes[:invoice] = self
      Transaction.create(attributes)
    end

  end

end
