include_template 'network_template.rb'

# This is the creation of the resource group. From this statement, cfer will generate
# a handful of resources, with names all prefixed with `Network`.
#
# You can create as many instances of 'Cfer::Examples::Network' as you'd like,
# with different names.
resource :Network, 'Cfer::Examples::Network' do
  vpc_name "my-network"
  subnets 3
end

# Resource groups will also insert an extra CloudFormation wait condition handle
# into your template. It's a wait condition handle because that's the only CFN
# resource that does nothing on its own.
#
# This resource has a couple of properties:
#
# * It depend on every resource defined inside the group, so if the resource named
#   "Network" is finished, you know that everything inside the "Network" group is
#   also finished.
#
# * It includes all of the properties that you specified in your template in the
#   resource metadata. This has no technical value, but it makes it easier to debug
#   your resource groups with `cfer generate`
#
# The custom resource for this invocation looks like this:
#
# "Network": {
#   "Type": "AWS::CloudFormation::WaitConditionHandle",
#   "Properties": {
#   },
#   "DependsOn": [
#     "NetworkVPC",
#     "NetworkDefaultIGW",
#     "NetworkVpcIGW",
#     "NetworkRouteTable",
#     "NetworkSubnet1",
#     "NetworkSRTA1",
#     "NetworkSubnet2",
#     "NetworkSRTA2",
#     "NetworkSubnet3",
#     "NetworkSRTA3",
#     "NetworkDefaultRoute"
#   ],
#   "Metadata": {
#     "Type": "Cfer::Examples::Network",
#     "Properties": {
#       "VpcName": "my-network",
#       "Subnets": 3
#     }
#   }
# }

