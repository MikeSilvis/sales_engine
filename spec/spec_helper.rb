require 'bundler'
Bundler.require

require 'faker'
require 'simplecov'
require 'sales_engine/model'
require 'sales_engine/customer'
require 'sales_engine/merchant'
require 'sales_engine/invoice_item'
require 'sales_engine/transaction'
require 'sales_engine/invoice'
require 'sales_engine'

include SalesEngine

SalesEngine.startup
