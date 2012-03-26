Fabricator(:item) do
  name { Faker::Name.name } 
  description { Faker::Lorem.sentence(10) } 
  unit_price 23432
end