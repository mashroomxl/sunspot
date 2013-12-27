module Sunspot
  class DismaxEscaper
    INFIX_CHARS = %w( [ ] { } ( ) : " ).freeze
    PREFIX_CHARS = %w( * ? ).freeze

    INFIX_ESCAPE_REGEXPS = INFIX_CHARS.map { |char| Regexp.new("([^\\\\])#{Regexp.escape(char)}|\\A#{Regexp.escape(char)}") }.freeze
    PREFIX_ESCAPE_REGEXPS = PREFIX_CHARS.map { |char| Regexp.new("\\A#{Regexp.escape(char)}") }.freeze

    def self.escape_keywords(keywords)
      escaped_keywords = keywords.dup

      INFIX_CHARS.each_with_index do |char, idx|
        infix_regexp = INFIX_ESCAPE_REGEXPS[idx]
        escaped_keywords.gsub!(infix_regexp, "\\1\\#{char}")
      end

      PREFIX_CHARS.each_with_index do |char, idx|
        prefix_regexp = PREFIX_ESCAPE_REGEXPS[idx]
        escaped_keywords.gsub!(prefix_regexp, "\\#{char}")
      end

      escaped_keywords
    end

    def self.unescape_term(term)
      unescape_term = term.dup
      unescape_term.gsub!(/\\([:\[\]{}()"])/, "\\1") # unescape [ ] { } ( ) : "
      unescape_term.gsub!(/\A\\\*/, "*") # unescape leading asterisk
      unescape_term.gsub!(/\A\\\?/, "?") # unescape leading question mark
      unescape_term
    end
  end
end
