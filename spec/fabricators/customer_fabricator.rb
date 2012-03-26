Fabricator(:fake_customer, :class => "SalesEngine::Customer") do
  first_name  { Faker::Name.first_name }
  last_name { Faker::Name.last_name }
end