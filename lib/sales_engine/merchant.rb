require 'sales_engine/model'
require 'sales_engine/item'
require 'sales_engine/invoice'

module SalesEngine

  class Merchant
    include Model

    has_many :items
    has_many :invoices
    field :name, :string

    def revenue(dates=[])
      paid_invoices(dates).sum(&:total_cost)
    end

    def total_items_sold
      paid_invoices.sum(&:item_count)
    end

    def paid_invoices(dates=[])
      dates = Array(dates).map(&:to_date)

      if dates.empty?
        invoices.select(&:paid?)
      else
        invoices.select(&:paid?).select do |i|
          dates.include?(i.created_at.to_date)
        end
      end
    end

    def favorite_customer
      invoices.group_by(&:customer).sort_by{|c,is| -is.size}.first[0]
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

    def self.revenue(dates=[])
      all.map {|m| m.revenue(dates)}.sum
    end

    def self.dates_by_revenue(limit=nil)
      dates = paid_invoices.
        group_by { |i| i.created_at.to_date }.
        sort_by { |d, is| -is.sum(&:total_cost) }.
        select { |d, is| d }

      limit ||= dates.size

      dates.first(limit)
    end
  end
end
