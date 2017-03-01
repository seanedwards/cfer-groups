require 'cfer/groups/version'
require 'cfer/groups/stack'
require 'cfer/groups/resource'
require 'cfer/groups/resource_group'

Cfer::Core::Stack.extend_stack do
  include Cfer::Groups::Stack
end

