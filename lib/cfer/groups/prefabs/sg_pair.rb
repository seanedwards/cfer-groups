require 'cfer/groups'

Cfer::Groups::Stack::resource_group 'Cfer::Prefabs::SecurityGroupPair',
  Ports: HashValidator.many('numeric') do |args|
  ports = args[:Ports]

  resource :ClientSG, 'AWS::EC2::SecurityGroup' do
    group_description args[:ClientGroupDescription] if args[:ClientGroupDescription]
    vpc_id args[:VpcId]
  end

  resource :ServerSG, 'AWS::EC2::SecurityGroup' do
    group_description args[:ServerGroupDescription] if args[:ServerGroupDescription]
    vpc_id args[:VpcId]
  end

  ports.each do |port|
    resource :ServerSGClientIngress, 'AWS::EC2::SecurityGroupIngress' do
      group_id ref(:ServerSG)
      ip_protocol 'tcp'
      from_port port
      to_port port
      source_security_group_id ref(:ClientSG)
    end
  end

end
