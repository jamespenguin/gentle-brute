module GentleBrute
  class Odometer
    def initialize(start_length=1, heuristic=true)
      @letters = ('a'..'z').to_a
      @chars = @letters + [" ", "'"]
      @odometer = Array.new(start_length, 0)
      @heuristic = heuristic
      @cpa_analyzer = CPAAnalyzer.new
    end

    def has_triple_char_pattern?
      return false if not @heuristic
      indexes = []
      odometer_length = @odometer.length
      (odometer_length-1).downto 0 do | i |
        index = @odometer[i]
        if indexes.length > 0
          char1 = @chars[index] # figure out what char the current index is
          char2 = @chars[@odometer[indexes[0]]] # get the char of our first element in the indexes list
          indexes = [] if char1 != char2
        end
        indexes << i
        break if indexes.length == 3
      end
      return false if indexes.length < 3
      true
    end

    #def break_up_triplet_patterns
    #  return if not @heuristic
    #
    #  word = string_for_odometer
    #  pattern_data = PatternFinder.patterns_in_strintg word
    #  return if pattern_data == nil
    #  return if pattern_data[3] < 3
    #
    #  index = pattern_data[4][1]
    #  index.downto 0 do | i |
    #    element = @odometer[i]
    #    element += 1
    #    if element != @chars.length
    #      @odometer[i] = element
    #      break
    #    end
    #    @odometer[i] = 0
    #    @odometer << 0 if i == 0
    #  end
    #
    #  break_up_triplet_patterns      
    #end

    def rotate_out_bad_start_pairs
      return if not @heuristic
      return if @odometer.length < 3

      char1 = @chars[@odometer[0]]
      char2 = @chars[@odometer[1]]
      char3 = @chars[@odometer[2]]
      return if not @letters.include? char1
      return if not @letters.include? char2
      return if not @letters.include? char3
    
      if @cpa_analyzer.get_starter_neighbor_score(char1, char3)[1] == 0
        2.downto 0 do | i |
          element = @odometer[i]
          element += 1
          if element != @chars.length
            @odometer[i] = element
            break
          end
          @odometer[i] = 0
          @odometer << 0 if i == 0
        end
        rotate_out_bad_start_pairs
      end
    
      if @cpa_analyzer.get_starter_neighbor_score(char1, char2)[0] == 0
        1.downto 0 do | i |
          element = @odometer[i]
          element += 1
          if element != @chars.length
            @odometer[i] = element
            break
          end
          @odometer[i] = 0
          @odometer << 0 if i == 0
        end
        rotate_out_bad_start_pairs
      end
    end

    def rotate_out_bad_end_pairs
      return if not @heuristic
    
      return if @odometer.length < 3
    
      char1 = @chars[@odometer[-1]]
      char2 = @chars[@odometer[-2]]
      char3 = @chars[@odometer[-3]]
      return if not @letters.include? char1
      return if not @letters.include? char2
      return if not @letters.include? char3
    
      last = @odometer.length-1
    
      if @cpa_analyzer.get_ender_neighbor_score(char1, char3)[1] == 0
        last.downto 0 do | i |
          element = @odometer[i]
          element += 1
          if element != @chars.length
            @odometer[i] = element
            break
          end
          @odometer[i] = 0
          @odometer << 0 if i == 0
        end
        rotate_out_bad_end_pairs
      end
    
      if @cpa_analyzer.get_ender_neighbor_score(char1, char2)[0] == 0
        last.downto 0 do | i |
          element = @odometer[i]
          element += 1
          if element != @chars.length
            @odometer[i] = element
            break
          end
          @odometer[i] = 0
          @odometer << 0 if i == 0
        end
        rotate_out_bad_end_pairs
      end
    end

    # Increment the odometer
    # @param [Number] total_steps the number of steps to increment the odometer by (default is 1)
    def increment(total_steps=1)
      steps_taken = 0
      while steps_taken < total_steps
        odometer_length = @odometer.length
        (odometer_length-1).downto 0 do | i |
          element = @odometer[i]
          element += 1
          if element != @chars.length
            @odometer[i] = element
            break
          end
          @odometer[i] = 0
          @odometer << 0 if i == 0
        end
        rotate_out_bad_end_pairs
        rotate_out_bad_start_pairs
        next if has_triple_char_pattern?
        steps_taken += 1
      end
    end

    # @return [String] string representation of the odometer, with character indexes mapped to their respective characters
    def string_for_odometer
      return @odometer.map {|i| @chars[i]}.join ""
    end

    def to_s
      string_for_odometer
    end
  end
end
