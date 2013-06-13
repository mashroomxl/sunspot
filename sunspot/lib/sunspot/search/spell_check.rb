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
      
      # Build a coallation based on the given keywords from the query and the
      # received suggestions. Using the start and end offsets to replace the
      # misspelled words.
      #
      # Give a block to setup the collation variable, e.g to downcase the
      # keywords before.
      def collation
        length_comparator = collation_given? ? 2 : 1
        if results['suggestions'] && results['suggestions'].length > length_comparator
          if block_given?
            collation = yield query.keywords
          else
            collation = query.keywords
          end

          suggestions.each do |term, term_data|
            if term_data['origFreq'] == 0
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