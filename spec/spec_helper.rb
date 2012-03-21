require 'simplecov'
require 'sales_engine/model'
require 'sales_engine/customer'

files = ["./data/customers.csv", "./data/invoices.csv", "./data/transactions.csv", "./data/merchants.csv"]
include SalesEngine
Model.database = CSVDatabase.new(*files)
Customer.load
Invoice.load
Transaction.load
Merchant.load