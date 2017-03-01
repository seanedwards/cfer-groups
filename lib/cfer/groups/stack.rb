module Cfer
  module Groups
    module Stack
      def resource_group(type, &block)
        Cfer::Core::Resource.extend_resource(type) do
          class << self;
            attr_accessor :block
          end
          @block = block
          include Cfer::Groups::ResourceGroup
        end
      end
      module_function :resource_group
    end
  end
end

