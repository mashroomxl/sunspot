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
      def extended_results!(value=true)
        key_str = 'spellcheck.extendedResults'
        key_sym = key_str.intern
        if @query.options.has_key?(key_str)
          @query.options[key_str] = value
        else
          @query.options[key_sym] = value
        end
        self
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
          count = (results['suggestions'].length - 4) / 2
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
      # the index. Otherwise return Solr's suggested collation.
      #
      # Solr's suggested collation is more liberal, replacing even terms that
      # are present in the index. This may not be useful if only one term is
      # misspelled and preventing useful results.
      #
      # Mix and match in your views for a blend of strict and liberal collations.
      def collation(*terms)
        if results['suggestions'] && results['suggestions'].length > 2
          collation = terms.join(" ").dup if terms
      
          # If we are given a query string, tokenize it and strictly replace
          # the terms that aren't present in the index
          if terms.present?
            terms.each do |term|
              if (suggestions[term]||{})['origFreq'] == 0
                collation[term] = suggestion_for(term)
              end
            end
          end
      
          # If no query was given, or all terms are present in the index,
          # return Solr's suggested collation.
          if terms.length == 0
            collation = results['suggestions'][-1]
          end
        
          collation
        else
          nil
        end
      end
    end
  end
end