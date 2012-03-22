require 'csv'

module SalesEngine
  class CSVDatabase

    CSV_OPTIONS = {:headers => true, :header_converters => :symbol}

    def initialize(*files)
      load_table_names(*files)
    end

    def table(name)
      @tables.fetch(name.to_s)
    end

    private

    def load_table_names(*files)
      @tables = Hash.new

      files.each do |file|

        if file =~ /([a-z0-9_]+)\.csv$/i
          table_name = $1
        else
          raise "Invalid filename: #{file}\n" +
                "Expected *.csv."
        end

        @tables[table_name] = CSV.read(file,CSV_OPTIONS)
      end
    end
  end
end