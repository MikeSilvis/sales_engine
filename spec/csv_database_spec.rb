require 'sales_engine/csv_database'
include SalesEngine

describe CSVDatabase do
  let(:data_dir) { "data" }

  let(:tables) do
     %w(customers invoice_items invoices items merchants transactions)
  end

  let(:files) do
    tables.map do |table|
      File.join(data_dir, table + ".csv")
    end
  end

  let(:database) do
    CSVDatabase.new(files)
  end

  it "should have all the tables" do
    tables.each do |table|
      database.table(table).should_not be_nil
    end
  end

  it "should not accept non-csv files" do
    expect do
      CSVDatabase.new("foo", "bar", "baz")
    end.should raise_exception
  end
end
