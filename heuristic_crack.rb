#!/usr/bin/env ruby

require File.expand_path('../lib/gentle_brute', __FILE__)

Slop.parse :help => true do
    banner "heuristic_crack [options]"

    on "valid-words", "Returns all valid English-like words and phrases up to 4 characters long" do
        max_length = 4
        b = GentleBrute::BruteForcer.new
        while true
            phrase = b.next_valid_phrase
            break if phrase.length > max_length
            puts phrase
        end
    end

    on_empty do
      puts help
    end
end
