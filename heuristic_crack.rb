#!/usr/bin/env ruby

require File.expand_path('../lib/gentle_brute', __FILE__)

Slop.parse :help => true do
    banner "heuristic_crack [options]"

    on "valid-words", "Returns all valid English-like words and phrases up to 4 characters long" do
        b = GentleBrute::BruteForcer
        while true
            puts b.next_valid_phrase
        end
    end

    on_empty do
      puts help
    end
end
