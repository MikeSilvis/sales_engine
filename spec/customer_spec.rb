require 'sales_engine/customer'
require 'sales_engine/model'

gem 'fabrication'
require 'fabrication'
puts Fabricate

describe Customer do
  let(:customers) do
    Customer.all
  end
  let(:customer) do
    Customer.find_by_first_name("Mike")
  end
  context "Call random method" do
    it "should hit method missing" do
      lambda {Customer.garbage}.should raise_error(NoMethodError)
    end
  end
  context "#find a random customer" do
    it "Should find a random customer" do
      Customer.random.should be_a Customer
    end
  end

  context "#find_by" do
    context "#find_by" do
      it "#find_by_fautly_values" do
        expect do
          Customer.find_by_garbage("Mike")
        end.should raise_error
      end

      it "#find_by_first_name" do
        Customer.find_by_first_name("Mike").should_not be_nil
      end
      it "#find_by_faulty_name" do
        Customer.find_by_first_name("Garbage").should be_nil
      end
    end

    context "#find_all_by" do
      it "#find_all_by_fautly_values" do
        expect do
          Customer.find_all_by_garbage("Mike")
        end.should raise_error
      end
      it "#find_all_by_first_name" do
        Customer.find_all_by_first_name("Mike").should_not be_nil
      end
      it "#find_all_by_faulty_name" do
        Customer.find_by_first_name("Garbage").should be_nil
      end
    end
  end

  context "field types" do
    it "should have integer id" do
      customer.id.should be_kind_of Integer
    end

    it "should have string first_name" do
      customer.first_name.should be_kind_of String
    end

    it "should have string last_name" do
      customer.last_name.should be_kind_of String
    end

    it "should have datetime created_at" do
      customer.created_at.should be_kind_of DateTime
    end

    it "should have datetime created_at" do
      customer.updated_at.should be_kind_of DateTime
    end
  end

  context "Business Intelligence (Acording to Jeff...)" do
    it "#transactions" do
      customer.transactions
    end
    it "#invoices" do
      customer.invoices
    end
    it "#favorite_merchant" do
      customer.favorite_merchant.name.should == "Fritsch-Blanda"
    end
  end
end
