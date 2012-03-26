Fabricator(:customer) do
  Customer.find_by_first_name("Mike")
end