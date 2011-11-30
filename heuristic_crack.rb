#!/usr/bin/env ruby

require File.expand_path('../lib/gentle_brute', __FILE__)

Slop.parse :help => true do
    banner "heuristic_crack [options]"

    on "valid-words-for=", "Generate all valid English-like words and phraes of a given length" do | length |
        length = length.to_i
        start_time = Time.now.to_f

        puts "[+] Generating valid words with a length #{length} characters."
        words = []
        b = GentleBrute::BruteForcer.new(start_length=length)
        print "\r[+] Words generated: #{words.length}"
        while true
            phrase = b.next_valid_phrase
            break if phrase.length > length
            words << phrase
            print "\r[+] Words generated: #{words.length}"
        end
        puts ", Finished!"
        puts "-" * 60

        puts "[+] Generated #{words.length} potential passphrases"
        chars = ('a'..'z').to_a + ["'"]
        potential_combinations = chars.length ** length
        puts "[+] There are #{potential_combinations} total potential combinations for the length you provided"
        percent = 100 - ((words.length * 100)/potential_combinations)
        puts "[+] Gentle-Brute reduced the number of hashes you would need to try by #{percent}%"
        puts "-" * 50

        puts "[+] Saved generated words to the file, words-#{length}.txt"
        File.open("words-#{length}.txt", "w") { |f| f.write words.join "\n" }

        puts "[+] Total time: #{Time.now.to_f-start_time}"
    end

    on "rebuild-cpa-tables=", "Build the character position analysis tables file with a specific wordlist" do | arg |
        c = GentleBrute::CPAAnalyzer.new
        c.build_cpa_tables arg
    end

    on "test" do
        c = GentleBrute::CPAAnalyzer.new
    end

    on_empty do
      puts help
    end
end
