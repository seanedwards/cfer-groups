require "cfer/groups/version"

Cfer::Core::Stack.extend_stack do
  def resource_group(type, **options, &block)
    Cfer::Core::Resource.extend_resource(type) do
      class << self;
        attr_accessor :block
      end
      @block = block
      include Cfer::Groups::ResourceGroup
    end
  end
end

module Cfer
  module Groups
    module Resource
      attr_accessor :group

      def name_of(obj)
        self.group.name_of(obj)
      end

      def ref(obj)
        Cfer::Core::Functions::Fn::ref name_of(obj)
      end

      def get_att(obj, att)
        Cfer::Core::Functions::Fn::get_att name_of(obj), att
      end
    end

    module ResourceGroup

      def initialize(name, type, stack, **options, &block)
        super(name, "Custom::#{type}", stack, options, &block)
      end

      def post_block
        self[:DependsOn] ||= []
        Docile.dsl_eval(self, self[:Properties], &self.class.block)
      end

      def resource(name, type, options = {}, &block)
        group = self
        resource_name = name_of(name)
        @stack.resource resource_name, type, options do
          extend Cfer::Groups::Resource
          self.group = group
          Docile.dsl_eval(self, &block) if block
        end
        self[:DependsOn] << resource_name
      end

      def parameter(name, options = {})
        @stack.parameter name_of(name), options
      end

      def output(name, value, options = {})
        @stack.output name_of(name), value, options
      end

      def parameters
        @stack.parameters
      end

      def name_of(name)
        "#{@name}#{name}"
      end
    end

  end
end
