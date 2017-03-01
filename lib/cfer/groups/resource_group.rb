module Cfer
  module Groups
    module ResourceGroup

      def initialize(name, type, stack, **options, &block)
        @resource_type = type
        super(name, "AWS::CloudFormation::WaitConditionHandle", stack, options, &block)
      end

      def post_block
        @properties = self[:Properties]
        @tags = self[:Properties][:Tags]
        self[:Properties] = {}
        self[:DependsOn] ||= []

        self[:Metadata] = {
          Type: @resource_type,
          Properties: @properties
        }

        Docile.dsl_eval(self, @properties, &self.class.block)
      end

      def resource(name, type, options = {}, &block)
        group = self
        tags = @tags
        resource_name = name_of(name)
        @stack.resource resource_name, type, options do
          extend Cfer::Groups::Resource
          self.group = group
          if tags
            tags.each do |t|
              tag t["Key"], t["Value"]
            end
          end
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

      def ref(obj)
        Cfer::Core::Functions::Fn::ref name_of(obj)
      end

      def get_att(obj, att)
        Cfer::Core::Functions::Fn::get_att name_of(obj), att
      end
    end

  end
end

