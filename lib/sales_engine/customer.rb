require 'sales_engine/model'
require 'sales_engine/invoice'
require 'sales_engine/transaction'
require 'sales_engine/merchant'

module SalesEngine
  class Customer
    include Model

    has_many :invoices
    field :first_name, :string
    field :last_name,  :string

    def transactions
      @transactions ||= invoices.map(&:transactions).flatten
    end

    def favorite_merchant
      @favorite_merchant ||= invoices.group_by { |i| i.merchant }.
                         max_by{ |m,is| is.sum { |i| i.transactions.count }}[0]
    end

    def days_since_activity
      last_day = invoices.map(&:transactions).flatten.map(&:created_at).max
      days = DateTime.now - last_day
      @days_since_activity ||= days.to_i
    end

    def pending_invoices
      @pending_invoices ||= invoices.select do |invoice|
        invoice.transactions.all?(&:unsuccessfull?)
      end
    end

    def self.most_items
      @most_items ||= Customer.all.sort_by(&:items_bought).last
    end

    def self.most_revenue
      @most_revenue ||= Customer.all.sort_by(&:total_cost).last
    end

    def items_bought
      @items_bought ||= invoices.sum(&:item_count)
    end

    def total_cost
      @total_cost ||= invoices.sum(&:total_cost)
    end

  end
end
