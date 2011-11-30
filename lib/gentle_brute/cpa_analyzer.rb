module GentleBrute
  class CPAAnalyzer
    NEIGHBORS_PATH = File.expand_path('../resources/neighbors.json', __FILE__)

    def initialize
      build_cpa_tables if not File.exists? NEIGHBORS_PATH
      lattices = JSON.parse File.open(NEIGHBORS_PATH).read
      @starters = lattices["starters"]
      @neighbors = lattices["neighbors"]
      @enders = lattices["enders"]
    end

    # Analyze a dictionary word list ('lib/gentle_brute/resources/dictionary') for repetition patterns
    # @param [String] dictionary_path path to dictionary word list file
    def build_cpa_tables(dictionary_path=File.expand_path("../resources/dictionary", __FILE__))
      # Create empty pattern occurce lattices
      lattice = Hash.new { |h, k| h[k] = {} }
      starter_lattice = Hash.new { |h, k| h[k] = {} }
      ender_lattice = Hash.new { |h, k| h[k] = {} }
      chars = ('a'..'z').to_a
      chars.each do | char |
        chars.each do | char2 |
          lattice[char][char2] = [0, 0]
          starter_lattice[char][char2] = [0, 0]
          ender_lattice[char][char2] = [0, 0]
        end
      end

      # Analyze each wrod in dictionary list
      words = open(dictionary_path)
      words.each_line do | word |
        word.chomp!
        word.downcase!
        for i in 0..word.length
          char = word[i] # current char
          char_r = word[i+1] # char one index to the right of the current char
          char_rr = word[i+2] # char two indicies to the right of the current char
          begin
            starter_lattice[char][char_r][0] += 1 if char_r and i == 0
            starter_lattice[char][char_rr][1] += 1 if char_rr and i == 0
            ender_lattice[char][char_r][0] += 1 if char_r and i == word.length-3
            ender_lattice[char][char_rr][1] += 1 if char_rr and i == word.length-3
            lattice[char][char_r][0] += 1 if char_r
            lattice[char][char_rr][1] += 1 if char_rr
          rescue
            break
          end
        end
      end

      # Write neighbors file
      output_lattice = {"starters" => starter_lattice,
                        "neighbors" => lattice,
                        "enders" => ender_lattice}
      File.open(NEIGHBORS_PATH, "w") {|f| f.write output_lattice.to_json }
    end

    def get_starter_neighbor_score(char, char2)
      @starters[char][char2]
    end
  
    def get_neighbor_score(char, char2)
      @neighbors[char][char2]
    end
  
    def get_ender_neighbor_score(char, char2)
      @enders[char][char2]
    end
  end
end
