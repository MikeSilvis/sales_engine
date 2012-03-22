require 'sales_engine/model'

module SalesEngine
  class InvoiceItem
    include SalesEngine::Model

    field :id,          :integer
    field :item_id,     :integer
    field :invoice_id,  :integer
    field :quantity,    :integer
    field :unit_price,  :decimal
    field :created_at,  :datetime
    field :updated_at,  :datetime

    def invoice
      Invoice.find("id", invoice_id).first
    end

    def item
      Item.find("id", item_id).first
    end

    def total_cost
      unit_price * quantity
    end

    def self.paid
      all.select {|item| item.invoice.paid?}
    end

  end


end
