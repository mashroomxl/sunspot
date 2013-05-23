module Sunspot
  module Query
    class SpellCheck
      attr_reader :keywords, :options

      def initialize(keywords, options=nil)
        @keywords = keywords
        @options = options
      end

      def to_params
        options_base = { :q => keywords }
        if options.nil? || options.empty?
          options_base
        else
          options.merge(options_base)
        end
      end

      def to_subquery
        raise NotImplementedError.new
      end
    end
  end
end
