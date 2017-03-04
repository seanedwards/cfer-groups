
resource_group 'Cfer::Groups::InnerGroup' do |args|
  parameter :Parameter
  resource :Root, 'Cfer::TestResource' do
    test_reference ref(:Parameter)
    test_property args[:TestProperty]
  end
  output :Output, "OutputValue"
end

resource_group 'Cfer::Groups::OuterGroup' do |args|
  resource :Inner, 'Cfer::Groups::InnerGroup' do
    test_property args[:TestValue]
  end
end


resource :Outer, 'Cfer::Groups::OuterGroup' do
  test_value 1234
end

