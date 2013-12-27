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
        if @escaped_escaped_keywords.nil?
          @escaped_escaped_keywords = keywords.dup
          @escaped_escaped_keywords.gsub!(/([^\\])\:|\A\:/, "\\1\\:") # escape colons
          @escaped_escaped_keywords.gsub!(/([^\\])\"|\A\"/, "\\1\\\"") # escape quotation mark
          @escaped_escaped_keywords.gsub!(/\A\*/, "\\\*") # escape leading asterisk
          @escaped_escaped_keywords.gsub!(/\A\?/, "\\\?") # escape leading question mark
        end
        @escaped_escaped_keywords
      end
    end
  end
end
