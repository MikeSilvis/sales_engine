module SalesEngine

  class Invoice
    attr_accessor :id, :customer_id, :merchant_id, :status, :created_at
    #belong_to :item, merchant
    def transactions
      
    end

    def invoice_items

    end

    def items
      
    end

    def customer

    end
    
  end

end