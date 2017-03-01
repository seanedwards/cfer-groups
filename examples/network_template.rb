require 'cfer/groups'

resource_group 'Cfer::Examples::Network' do |args|
  parameter :VpcName, Default: args[:VpcName]
  resource :VPC, 'AWS::EC2::VPC' do
    cidr_block '172.42.0.0/16'

    enable_dns_support true
    enable_dns_hostnames true
    instance_tenancy 'default'

    tag :Name, ref(:VpcName)
  end

  resource :DefaultIGW, 'AWS::EC2::InternetGateway'

  resource :VpcIGW, 'AWS::EC2::VPCGatewayAttachment' do
    vpc_id ref(:VPC)
    internet_gateway_id ref(:DefaultIGW)
  end

  resource :RouteTable, 'AWS::EC2::RouteTable' do
    vpc_id ref(:VPC)
  end

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

  resource :DefaultRoute, 'AWS::EC2::Route', DependsOn: [ name_of(:VpcIGW) ] do
    route_table_id ref(:RouteTable)
    gateway_id ref(:DefaultIGW)
    destination_cidr_block '0.0.0.0/0'
  end

  output :VpcId, ref(:VPC)
end
