require 'sales_engine/model'
module SalesEngine

  class Invoice
    include Model
    attr_accessor :id, :customer_id, :merchant_id, :status, :created_at
    #belong_to :item, merchant

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
    
  end

end