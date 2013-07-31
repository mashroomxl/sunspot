module Sunspot

  class DismaxEscaper
    def self.escape_keywords(keywords)
      # escape [ ] { } ( ) : "
      escaped_escaped_keywords ||= keywords.gsub(/([:\[\]{}()"])/, "\\\\\\1")
      escaped_escaped_keywords
    end

    def self.unescape_term(term)
      term.gsub(/\\([:\[\]{}()"])/, "\\1")
    end
  end
end
