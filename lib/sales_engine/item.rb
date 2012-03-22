require 'sales_engine/model'

module SalesEngine
  class Item
    include SalesEngine::Model

    field :id,           :integer
    field :name,         :string
    field :description,  :string
    field :unit_price,   :decimal
    field :merchant_id,  :integer
    field :created_at,   :datetime
    field :updated_at,   :datetime

    def self.most_revenue(limit)

    end

    def self.most_items(limit)

    end

    def best_day

    end

    def invoice_item
      InvoiceItem.find("item_id", id)
    end

    def merchant
      Merchant.find("id", merchant_id)
    end

  end

end
