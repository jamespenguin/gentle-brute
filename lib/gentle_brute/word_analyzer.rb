module GentleBrute
  class WordAnalyzer
    def initialize(cpa_threshold)
      @suffixes = File.read(File.expand_path('../resources/suffixes', __FILE__)).split "\n"
      @vowels = ['a', 'e', 'i', 'o', 'u']
      @chars = ('a'..'z').to_a + ["'"]
      @punctuation = ["!", "?", ".", ","]
      @cpa_threshold = cpa_threshold
      @cpa_analyzer = CPAAnalyzer.new
    end

    # Test whether or not a given word follows the rules of English-like words
    # @param [String] word the word to test for validity
    # @return [Boolean] whether or not the word passed all the validation tests
    def is_valid_word? word
      return false if word.empty? # Empty words are not valid words
      word.downcase! # ignore mixed casing
      return is_valid_phrase? word if word.include? " " # If it's a phrase, test it as a phrase
      length = word.length

      # The only valid single letter words are 'a' and 'i'
      return false if length == 1 and word != "i" and word != "a"

      # The word must contain at least one vowel
      return false if not has_vowel? word

      # Validate Character Position Analysis Scores
      return false if not passes_neighbor_tests? word

      # The word must conform to proper apostrophe usage rules
      return false if not uses_valid_apostrophes? word

      # Does the word follow proper suffix patterns?
      return false if not follows_proper_suffix_patterns? word

      # Does the word contain triple char patterns?
      return false if word.length > 5 and not passes_direct_patterns_test? word

      # The word is (probably) valid!
      true
    end

    # Test whether or not a given phrase follows the rules of English-like phrases
    # @param [String] phrase the phrase to test for validity
    # @return [Boolean] whether or not the phrase passed all the validation tests
    def is_valid_phrase? phrase
      # Does the phrase start or end with a space?
      return false if phrase =~ /^ /
      return false if phrase =~ / $/
      return false if phrase.include? "-" and phrase.include? "_"
      return false if phrase.include? "   "
  
      phrases = phrase.split "  "
      phrases.each do | phrase_ |
        return false if not passes_phrase_pattern_test? phrase_
        phrase_.split(" ").each do | word |
          return false if not is_valid_word? word
        end
      end
  
      true
    end

    ### Begin Phrase Testing Functions ###
    
    def passes_phrase_pattern_test? phrase
      pattern_data = PatternFinder.patterns_in_strintg phrase
      return true if pattern_data == nil
      return false if pattern_data[3] > 3
      true
    end

    ### Begin Word Testing Functions ###

    # Test whether or not a given word has at least one vowel
    # @param [String] word the word to test
    # @return [Boolean] whether or not the word passed the test
    def has_vowel? word
      @vowels.any? { |vowel| word.include? vowel }
    end

    # Test whether or not a given word follows proper apostrophe usage rules
    # @param [String] word the word to test
    # @return [Boolean] whether or not the word passed the test
    def uses_valid_apostrophes? word
      if word.include? "'"
        index = word.index "'"
        return false if length-1 != word.tr("'", "").length
        return false if index != length-1 and index != length-2
        return false if word[-1] != 's' and word[-2] != 's'
      end
      true
    end

    # Test whether or not a given word follows proper suffix usage patterns
    # @param [String] word the word to test
    # @return [Boolean] whether or not the word passed the test
    def follows_proper_suffix_patterns? word
      @suffixes.each do | suffix |
        next if not word =~ /#{suffix}$/
        return true if word.length == suffix.length
        index = (suffix.length * -1) - 1
        return false if word[index] == suffix[0]
      end
      true
    end

    # Verify a given word does not have any illegal character patterns
    # @param [String] word the word to test
    # @return [Boolean] whether or not the word passed the test
    def passes_direct_patterns_test? word
      pattern_data = PatternFinder.patterns_in_strintg word
      return true if not pattern_data
      return false if pattern_data[3] > 2
      true
    end

    # Verify a given word has all the required CPA neighbor scores
    # @param [String] word the word to test
    # @return [Boolean] whether or not the word passed the test
    def passes_neighbor_tests? word
      length = word.length
      for i in 0...length
        char = word[i]
        char_r = word[i+1]
        char_rr = word[i+2]
        return false if char == char_r and char == char_rr
        return false if char == char_r and length == 2
        return false if not @chars.include? char
  
        if char_r
          begin
            if i == 0
              return false if @cpa_analyzer.get_starter_neighbor_score(char, char_r)[0] == 0
            elsif i == length-3
              return false if @cpa_analyzer.get_ender_neighbor_score(char, char_r)[0] == 0
            end
            score = @cpa_analyzer.get_neighbor_score(char, char_r)
            return false if score[0] < @cpa_threshold
          rescue
          end
        end
  
        if char_rr
          begin
            if i == 0
              return false if  @cpa_analyzer.get_starter_neighbor_score(char, char_rr)[1] == 0
            elsif i == length-3
              return false if @cpa_analyzer.get_ender_neighbor_score(char, char_rr)[1] == 0
            end
            score = @cpa_analyzer.get_neighbor_score(char, char_rr)
            return false if score[1] < @cpa_threshold
          rescue
          end
        end
      end
  
      true
    end
  end
end