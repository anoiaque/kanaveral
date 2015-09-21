module Kanaveral
  module Extensions
    refine String do
      def camelize
        split('_'.freeze).map(&:capitalize).join
      end
    end
  end
end