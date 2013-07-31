module Sunspot
  module Query
    class SpellCheck
      attr_reader :keywords, :options

      def initialize(keywords, options=nil)
        @keywords = keywords
        @options = options
      end

      def to_params
        options_base = { :q => escaped_keywords }
        if options.nil? || options.empty?
          options_base
        else
          options.merge(options_base)
        end
      end

      def to_subquery
        raise NotImplementedError.new
      end

      def escaped_keywords
        @escaped_escaped_keywords ||= Sunspot::DismaxEscaper.escape_keywords(keywords)
      end
    end
  end
end
