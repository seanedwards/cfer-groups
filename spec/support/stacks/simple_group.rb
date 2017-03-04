
resource_group 'Cfer::Groups::SimpleGroup' do |args|
  resource :Test, 'Cfer::TestResource' do
    test_property args[:TestValue]
  end
end


resource :TestResource, 'Cfer::Groups::SimpleGroup' do
  test_value 1234
end

