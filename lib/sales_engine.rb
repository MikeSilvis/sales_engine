module SalesEngine

  def self.startup
    files = [
             "./data/customers.csv",
             "./data/invoices.csv",
             "./data/transactions.csv",
             "./data/merchants.csv",
             "./data/items.csv",
             "./data/invoice_items.csv"
            ]

    Model.database = CSVDatabase.new(files)
    Customer.load
    Invoice.load
    Transaction.load
    Merchant.load
    Item.load
    InvoiceItem.load
  end

end
