module Cfer
  module Groups
    module Resource
      attr_accessor :group

      def name_of(obj)
        self.group.name_of(obj)
      end

      def ref(obj)
        self.group.ref(obj)
      end

      def get_att(obj, att)
        self.group.get_att(obj, att)
      end
    end
  end
end

