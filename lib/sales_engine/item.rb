require 'sales_engine/model'

module SalesEngine
  class Item
    include SalesEngine::Model

    has_many :invoice_items
    has_many :invoices, :through => :invoice_items
    field :name,         :string
    field :description,  :string
    field :unit_price,   :decimal
    field :merchant_id,  :integer

    def invoice_item
      InvoiceItem.find("item_id", id)
    end

    def merchant
      Merchant.find("id", merchant_id)
    end

    def best_day
      InvoiceItem.paid.
        select { |invoice_item| invoice_item.item == self }.
        group_by { |invoice_item| invoice_item.invoice.created_at }.
        sort_by { |date, invoice_items| -invoice_items.sum(&:total_cost) }.
        first
    end

    def self.most_revenue(limit)
      InvoiceItem.paid.
        group_by(&:item).
        sort_by { |item, invoice_items| -invoice_items.sum(&:total_cost) }.
        map { |item, invoice_items| item }.
        first(limit)
    end

    def self.most_items(limit)
      InvoiceItem.paid.
        group_by(&:item).
        sort_by { |item, invoice_items| -invoice_items.sum(&:quantity) }.
        map { |item, invoice_items| item }.
        first(limit)
    end

  end

end
