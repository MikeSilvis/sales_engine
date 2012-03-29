require 'bigdecimal'
require 'bigdecimal/util'

lib    = File.expand_path("../", __FILE__)
rbglob = File.join(lib, "**/*.rb")
Dir.glob(rbglob) { |file| require file }

module SalesEngine
  EXTENSIONS = %w(customer invoice merchant)
  FILES = [
             "./data/customers.csv",
             "./data/invoices.csv",
             "./data/transactions.csv",
             "./data/merchants.csv",
             "./data/items.csv",
             "./data/invoice_items.csv"
            ]

  def self.startup
    Model.database = CSVDatabase.new(files)
    load_files
  end

  def self.klasses
    [Customer, Invoice, Transaction, Merchant, Item, InvoiceItem]
  end

  def self.load_files
    klasses.each do |klass|
      klass.send("load")
    end
  end

  def self.files
    FILES
  end

end
