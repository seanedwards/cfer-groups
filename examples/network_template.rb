require 'cfer/groups'

# A resource group is a collection of interrelated resources.
# This example includes the basic resources to construct a simple VPC.
# The type can be anything you'd like, but must be unique.
# The :: syntax has no specific function, but looks like it fits in with AWS resources.
resource_group 'Cfer::Examples::Network' do |args|

  # Anything created inside the resource group has something prepended to the name.
  # In vpc.rb we can see that this resource group is created with the name "Network"
  # Therefore, this parameter will appear as "NetworkVpcName" in the final template.
  #
  # The `args` is a hash containing all of the properties that were set in vpc.rb
  parameter :VpcName, Default: args[:VpcName]

  # Naming of resources works the same way as parameters.
  # In vpc.rb this resource will be created as `NetworkVPC`
  resource :VPC, 'AWS::EC2::VPC' do
    cidr_block '172.42.0.0/16'

    enable_dns_support true
    enable_dns_hostnames true
    instance_tenancy 'default'

    # The ref() function translates the name into the current scope.
    # If we were to create two networks, say `NetworkA` and `NetworkB`,
    # the ref() function would know to reference `NetworkAVpcName` or `NetworkBVpcName`
    tag :Name, ref(:VpcName)

    # The get_att() function also exists, and works the same way as ref()
  end

  resource :DefaultIGW, 'AWS::EC2::InternetGateway'

  resource :VpcIGW, 'AWS::EC2::VPCGatewayAttachment' do
    vpc_id ref(:VPC)
    internet_gateway_id ref(:DefaultIGW)
  end

  resource :RouteTable, 'AWS::EC2::RouteTable' do
    vpc_id ref(:VPC)
  end

  # args are the preferred way of getting values into your group.
  # They form a hash through the same mechanism that CloudFormation
  # resources use.
  subnet_count = args[:Subnets] || 2
  (1..subnet_count).each do |i|
    resource "Subnet#{i}", 'AWS::EC2::Subnet' do
      availability_zone Fn::select(i, Fn::get_azs(AWS::region))
      cidr_block "172.42.#{i}.0/24"
      vpc_id ref(:VPC)
    end

    resource "SRTA#{i}".to_sym, 'AWS::EC2::SubnetRouteTableAssociation' do
      subnet_id ref("Subnet#{i}")
      route_table_id ref(:RouteTable)
    end

    output "SubnetID#{i}", ref("Subnet#{i}")
  end


  # If you need a scoped name directly, you can use the name_of() function.
  # You can see this is used in the DependsOn attribute of this resource
  # ref(:VpcName) is actually just defined as Fn::ref(name_of(:VpcName))
  resource :DefaultRoute, 'AWS::EC2::Route', DependsOn: [ name_of(:VpcIGW) ] do
    route_table_id ref(:RouteTable)
    gateway_id ref(:DefaultIGW)
    destination_cidr_block '0.0.0.0/0'
  end

  # Outputs are named the same way as everything else. This output will appear in the template as `NetworkVpcId`
  output :VpcId, ref(:VPC)
end
