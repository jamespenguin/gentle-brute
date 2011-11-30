Encoding.default_external = Encoding.find 'UTF-8'
Encoding.default_internal = Encoding.find 'UTF-8'

require 'bundler'
Bundler.require

puts __FILE__
puts File.expand_path("../gentle_brute", __FILE__)
$:.unshift File.expand_path("../gentle_brute", __FILE__)
require 'gentle_brute/pattern_finder'
require 'gentle_brute/word_analyzer'
require 'gentle_brute/odometer'

module GentleBrute
  class BruteForcer
    # @param [Number] start_length the starthing length of the string to start generating potential words
    # @param [Number] cpa_threshold the minimum character position analysis score neighboring characters must have
    def initialize(start_length=1, cpa_threshold=25)
      @odometer = Odometer.new start_length
      @word_analyser = WordAnalyzer.new cpa_threshold
    end

    # @return [String] the next English-like brute force phrase
    def next_valid_phrase
      while true
        @odometer.increment
        phrase = @odometer.string_for_odometer
        return phrase if @word_analyzer.is_valid_word? phrase
      end
    end
  end
end