#!/usr/bin/env ruby

require 'digest/md5'
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

        puts "[+] Total time spent: #{Time.now.to_f-start_time}"
    end

    on "rebuild-cpa-tables=", "Build the character position analysis tables file with a specific wordlist" do | arg |
        c = GentleBrute::CPAAnalyzer.new
        c.build_cpa_tables arg
    end

    on "cross-compare-crack=", "Cross compare brute force cracking times for a given md5 hash between GentleBrute, and regular brute forcing." do | target_hash |
        start_length = 6
        puts "[+] Attempting to crack hash using Gentle-Brute"
        start_time = Time.now.to_f
        b = GentleBrute::BruteForcer.new(start_length)
        puts
        puts "  Phrase | MD5 Hash (Phrase)                | MD5 Hash (Target)"
        puts "  " + ("-" * 75)
        while true
            phrase = b.next_valid_phrase
            attempt_hash = Digest::MD5.hexdigest(phrase)
            output_phrase = phrase
            while output_phrase.length < 8
                output_phrase = " " + output_phrase
            end
            line = "#{output_phrase} | #{attempt_hash} | #{target_hash}"
            print "\r#{line}"
            break if attempt_hash == target_hash
        end
        time_difference = Time.now.to_f - start_time
        puts
        puts
        puts "[+] Crack Succeeded in #{time_difference.round(8)} seconds"
        puts "-" * 75

        puts "[+] Attempting to crack hash using standard brute forcing"
        start_time = Time.now.to_f
        odometer = GentleBrute::Odometer.new(start_length, heuristic=false)
        puts
        puts "  Phrase | MD5 Hash (Phrase)                | MD5 Hash (Target)"
        puts "  " + ("-" * 75)
        while true
            odometer.increment
            phrase = odometer.string_for_odometer
            attempt_hash = Digest::MD5.hexdigest(phrase)
            output_phrase = phrase
            while output_phrase.length < 8
                output_phrase = " " + output_phrase
            end
            line = "#{output_phrase} | #{attempt_hash} | #{target_hash}"
            print "\r#{line}"
            break if attempt_hash == target_hash
        end
        time_difference1 = Time.now.to_f - start_time
        puts
        puts
        puts "[+] Crack Succeeded in #{time_difference1.round(8)} seconds"
        puts "-" * 75
        puts "[+] GentleBrute was #{(time_difference1-time_difference).round(8)} seconds faster"
        percent = 100 - ((time_difference*100)/time_difference1)
        puts "[+] That's a speed improvement of %d%% compared to standard brute forcing!" % percent
    end

    on_empty do
      puts help
    end
end
