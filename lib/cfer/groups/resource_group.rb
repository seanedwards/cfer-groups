module Cfer
  module Groups
    module ResourceGroup
      attr_reader :stack

      def initialize(name, type, stack, **options, &block)
        @group_name = name
        @resource_type = type
        options = { DependsOn: [] }.merge(options)

        super name, "AWS::CloudFormation::WaitConditionHandle", stack, options do
          self.instance_exec &block if block
          self[:Metadata] = {
            Type: type,
            Properties: self[:Properties]
          }
        end

        Docile.dsl_eval self, self[:Properties] do
          self.instance_exec self[:Properties], &self.class.block if self.class.block
        end
        self[:Properties] = {}
      end

      def resource(name, type, options = {}, &block)
        rc_name = name_of(name)
        self[:DependsOn] << rc_name

        group = self
        rc = @stack.resource rc_name, type, options do
          self.cfer_resource_group = group
          self.instance_eval &block
        end

        if self[:Tags]
          self[:Tags].each do |t|
            rc.tag t["Key"], t["Value"]
          end
        end

        rc
      end

      def output(name, value, options = {})
        stack.output name_of(name), value, options
      end

      def name_of(name)
        "#{@group_name}#{name}"
      end

      def ref(obj)
        Cfer::Core::Functions::Fn::ref name_of(obj)
      end

      def parameter(name, options = {})
        stack.parameter name_of(name), options
      end

      def get_att(obj, att)
        Cfer::Core::Functions::Fn::get_att name_of(obj), att
      end
    end

  end
end

