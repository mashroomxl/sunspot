module Sunspot
  module Search
    # 
    # TODO write something here
    #
    class SpellCheck < AbstractSearch
      def initialize(connection, query, request_handler=nil)
        @connection, @query = connection, query
        @request_handler = request_handler || :spell
      end

      #
      # adds option spellcheck.extendedResults with given value to spellcheck's
      # query options. it takes care of the key type (string / symbole).
      #
      def extended_results!
        self.extended_results = true
        self
      end

      def not_extended_results!
        self.extended_results = false
        self
      end

      def extended_results=(value)
        safe_set_query_option('spellcheck.extendedResults', value)
      end

      # 
      # TODO write something here
      #
      def correctly_spelled?
        index = results['suggestions'].find_index('correctlySpelled')
        if index
          results['suggestions'][index + 1]
        else
          nil
        end
      end

      #
      # see: https://github.com/sunspot/sunspot/pull/43
      #
      # Used the code from this pull request and made custom modifications.
      #

      # Return the raw spellcheck block from the Solr response
      def results
        @results ||= @solr_result['spellcheck'] || {}
      end
      
      # Reformat the oddly-formatted spellcheck suggestion array into a
      # more useful hash.
      #
      # Original: [term, suggestion, term, suggestion, ..., "correctlySpelled", bool, "collation", str]
      # Returns: { term => suggestion, term => suggestion }
      def suggestions
        if @suggestions.nil?
          @suggestions = {}
          length_subtrahend = collation_given? ? 4 : 2
          count = (results['suggestions'].length - length_subtrahend) / 2
          (0..(count - 1)).each do |i|
            term = results['suggestions'][i * 2]
            suggestion = results['suggestions'][(i * 2) + 1]
            @suggestions[term] = suggestion
          end
        end
        @suggestions
      end
      
      # Return the suggestion with the single highest frequency.
      # Requires the extended results format.
      def suggestion_for(term)
        suggestions[term]['suggestion'].sort_by do |suggestion|
          suggestion['freq']
        end.last['word']
      end
      
      # Provide a collated query. If the user provides a query string,
      # tokenize it on whitespace and replace terms strictly not present in
      # the index. Otherwise build collation from given suggestions.
      #
      # Solr's suggested collation is more liberal, replacing even terms that
      # are present in the index. This may not be useful if only one term is
      # misspelled and preventing useful results.
      #
      # Mix and match in your views for a blend of strict and liberal collations.
      def collation(*terms)
        length_comparator = collation_given? ? 2 : 1
        if results['suggestions'] && results['suggestions'].length > length_comparator
          terms = suggestions.keys if terms.length == 0
          collation = terms.join(" ")

          # tokenize the query string and strictly replace the terms
          # that aren't present in the index.
          terms.each do |term|
            if (suggestions[term]||{})['origFreq'] == 0
              collation[term] = suggestion_for(term)
            end
          end

          collation
        else
          nil
        end
      end

    protected

      def collation_given?
        results['suggestions'][-2] == 'collation'
      end

      def safe_set_query_option(key, value)
        key_str = key.to_s
        key_sym = key_str.intern
        if @query.options.has_key?(key_str)
          @query.options[key_str] = value
          key_str
        else
          @query.options[key_sym] = value
          key_sym
        end
      end
    end
  end
end