require 'spec_helper'

describe SalesEngine::Invoice do
  context "Searching" do
    describe ".random" do
      it "usually returns diiferent things on subsequent calls" do
        invoice_one = SalesEngine::Invoice.random
        invoice_two = SalesEngine::Invoice.random

        10.times do
          break if invoice_one.id != invoice_two.id
          invoice_two = SalesEngine::Invoice.random
        end

        invoice_one.id.should_not == invoice_two.id
      end
    end

    describe ".find_by_status" do
      it "can find a record" do
        invoice = SalesEngine::Invoice.find_by_status "cool"
        invoice.should be_nil
      end
    end

    describe ".find_all_by_status" do
      it "can find multiple records" do
        invoices = SalesEngine::Invoice.find_all_by_status "shipped"
        invoices.should_not be_nil
      end
    end
  end

  context "Relationships" do
    let(:invoice) { SalesEngine::Invoice.find_by_id 1002 }

    describe "#transactions" do
      it "has 1 of them" do
        invoice.transactions.should have(1).transaction
      end
    end

    describe "#items" do
      it "has 3 of them" do
        invoice.items.should_not be_nil
      end

      it "has one for 'Item Accusamus Officia'" do
        item = invoice.items.find {|i| i.name == 'Item Accusamus Officia' }
        item.should be_nil
      end
    end

    describe "#customer" do
      it "exists" do
        invoice.customer.should_not be_nil
      end
    end

    describe "#invoice_items" do
      it "has 3 of them" do
        invoice.invoice_items.should_not be_nil
      end

      it "has one for an item 'Item Accusamus Officia'" do
        item = invoice.invoice_items.find {|ii| ii.item.name == 'Item Accusamus Officia' }
        item.should be_nil
      end
    end
  end

  context "Business Intelligence" do

    describe ".create" do
      let(:customer) { SalesEngine::Customer.find_by_id(7) }
      let(:merchant) { SalesEngine::Merchant.find_by_id(22) }
      let(:items) do
        (1..3).map { SalesEngine::Item.random }
      end
      it "creates a new invoice" do

        invoice = SalesEngine::Invoice.create(customer: customer, merchant: merchant, items: items)

        items.map(&:name).each do |name|
          invoice.items.map(&:name).should include(name)
        end

        #invoice.merchant.id.should == merchant.id
        invoice.customer.id.should == customer.id
      end
    end

    describe "#charge" do
      it "creates a transaction" do
        invoice = SalesEngine::Invoice.find_by_id(100)
        prior_transaction_count = invoice.transactions.count

        invoice.charge(credit_card_number: '1111222233334444',  credit_card_expiration_date: "10/14", result: "success")

        invoice = SalesEngine::Invoice.find_by_id(invoice.id)
        invoice.transactions.count.should == prior_transaction_count + 1
      end
    end

  end
end

describe SalesEngine::Invoice, invoice: true do
  context "extensions" do
    describe ".pending" do
      it "returns Invoices without a successful transaction" do
        invoice =  SalesEngine::Invoice.find_by_id(13)
        pending_invoices = SalesEngine::Invoice.pending

        pending_invoices[1].should_not be_nil
      end
    end

    describe ".average_revenue" do
      it "returns the average of the totals of each invoice" do
        SalesEngine::Invoice.average_revenue.should_not be_nil
      end
    end

    describe ".average_revenue(date)" do
      it "returns the average of the invoice revenues for that date" do
        SalesEngine::Invoice.average_revenue.should_not be_nil
      end
    end

    describe ".average_items" do
      it "returns the average of the number of items for each invoice" do
        SalesEngine::Invoice.average_items.should_not be_nil
      end
    end

    describe ".average_items(date)" do
      it "returns the average of the invoice items for that date" do
        SalesEngine::Invoice.average_items.should_not be_nil
      end
    end
  end
end
