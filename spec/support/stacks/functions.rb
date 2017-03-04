
resource_group 'Cfer::Groups::SimpleGroup' do |args|
  resource :TestA, 'Cfer::TestResource' do
    test_property args[:TestValue]
  end
  resource :TestB, 'Cfer::TestResource' do
    test_a ref(:TestA)
    test_att get_att(:TestA, "TestAtt")
    test_name name_of(:TestA)
  end
end


resource :TestResource, 'Cfer::Groups::SimpleGroup' do
  test_value 1234
end

