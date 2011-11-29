module GentleBrute
  module PatternFinder
    module_function

    # Analyzes a given string for different patterns
    # @param [String] string the string to analyze
    # @return [Array] a whole bunch of patterns :s
    def patterns_in_strintg string
      pattern_string = ""
      pattern_length = 0
      pattern_count  = 0
      pattern_bounds = []
      patterns = {}
  
      for i in 0...string.length
        (string.length-1).downto i do | ii |
          slice = string[i..ii]
          slice_length = slice.length
          slice2 = string[i+slice_length..ii+slice_length]
          if slice == slice2
            if not patterns.has_key? slice
              patterns[slice] = {}
              patterns[slice]["count"] = 1
              patterns[slice]["start"] = i
            else
              patterns[slice]["count"] += 1
            end
          end
        end
      end
  
      return nil if patterns == {}
  
      highest_count = 0
      patterns.keys.reverse.each do | key |
        if patterns[key]["count"] > highest_count
          pattern_string = key
          highest_count = patterns[key]["count"]
        end
      end
  
      start = patterns[pattern_string]["start"]
      index = start
      length = pattern_string.length
      pattern_length = length
      pattern_count += 1
  
      while true
        slice = string[index...index+length]
        slice2 = string[index+length...index+(length*2)]
        break if slice != slice2
  
        pattern_bounds = [start, index+(length*2)-1]
        pattern_length += length
        pattern_count += 1
  
        index += length
      end
      full_pattern = pattern_string * pattern_count
  
      [pattern_string, full_pattern, pattern_length, pattern_count, pattern_bounds]
    end
  end
end