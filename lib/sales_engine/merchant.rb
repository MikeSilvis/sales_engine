require 'sales_engine/model'
require 'sales_engine/item'
require 'sales_engine/invoice'

module SalesEngine

  class Merchant
    include Model

    field :id,          :integer
    field :name,        :string
    field :created_at,  :datetime
    field :updated_at,  :datetime

    def items
      Item.find("merchant_id", id)
    end

    def invoices
      Invoice.find("merchant_id",id)
    end

    def revenue(date=nil)
      date = date.to_date if date
      paid_invoices(date).sum(&:total_cost)
    end

    def total_items_sold
      paid_invoices.sum(&:item_count)
    end

    def paid_invoices(date=nil)
      date = date.to_date if date

      if date
        invoices.select(&:paid?).select {|i| i.date == date}
      else
        invoices.select(&:paid?)
      end
    end

    def favorite_customer
      invoices.group_by(&:customer).sort_by{|c,is| -is.size}[0]
    end

    def customers_with_pending_invoices
      invoices.select(&:pending?).map(&:customer)
    end

    def self.most_revenue(count)
      all.sort_by { |m| -m.revenue }.first(count)
    end

    def self.most_items(count)
      all.sort_by { |m| -m.total_items_sold }.first(count)
    end

    def self.revenue(date)
      all.map {|m| m.revenue(date)}.sum
    end

  end

end
