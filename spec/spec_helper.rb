require 'simplecov'
require 'sales_engine/model'
require 'sales_engine/customer'
require 'sales_engine/merchant'

files = [
         "./data/customers.csv", 
         "./data/invoices.csv", 
         "./data/transactions.csv", 
         "./data/merchants.csv",
         "./data/items.csv",
         "./data/invoice_items.csv"
        ]
include SalesEngine
Model.database = CSVDatabase.new(*files)
Customer.load
Invoice.load
Transaction.load
Merchant.load
Item.load
InvoiceItems.load