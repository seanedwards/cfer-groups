module Cfer
  module Groups
    module Resource
      extend Forwardable
      attr_accessor :cfer_resource_group
      def_delegators :cfer_resource_group, :name_of, :ref, :get_att
    end
  end
end

