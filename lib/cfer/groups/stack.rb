module Cfer
  module Groups
    module Stack
      def resource_group(type, validation = {}, &block)
        Cfer::Core::Resource.extend_resource(type) do
          class << self;
            attr_accessor :block
            attr_accessor :validation
          end
          @block = block
          @validation = validation
          include Cfer::Groups::ResourceGroup
        end
      end
      module_function :resource_group
    end
  end
end

