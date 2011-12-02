Gentle-Brute
============
One of the major drawbacks to using a brute force attack to crack a password, is that it can literally take billions of years (if not more) to try all of the possible permuations of a user's password.  One way to cut down on this, is to skip trying passwords that would be unlikely for a target user to have.  (Things like 'aaaaaa', 'asdf7777772dn', etc)  Gentle-Brute is a Ruby gem designed to generate only "English-like" words and phrases for more heuristic brute force password cracking attacks.  An English-like word is a sequence of characters that may not necessarilly be an _actual_ English word, but still adheres to the "rules" of English words.  By only using these kinds of words and phrases when attempting to crack a password with brute force, it's possible to greatly reduce amount of time it takes to find a matching hash.

What are the "Rules" of English-like words and phrases?
-------------------------------------------------------
This will come later.

Installation
------------

### Rubygems

    gem install gentle_brute

### Github

    git clone git@github.com:jamespenguin/gentle-brute.git
    gem build gentle_brute.gemspec
    gem install gentle_brute-<version>.gem

Usage
-----

Gentle-Brute includes a handy dandy pre-written application (GentleBrute) for crackng MD5 hashes, or you can write your own custom password cracking programs.

### Using GentleBrute
    ~/GentleBrute --help
    GentleBrute [options]
    
    options:
        
            --word-list                Generate a word list of valid English-like words and phrases for a given length
            --cross-compare-crack      Cross compare brute force cracking times for a given md5 hash between GentleBrute, and regular brute forcing.
            --validate                 Test whether a given word or phrase is considered valid
            --crack-md5                Crack a single MD5 password hash
            --crack-md5-list           Crack a series of MD5 password hashes in a given file
            --rainbow-table            Build MD5 hash rainbow table
        -h, --help                     Print this help message

### Writing Your Own Password Cracker
```ruby
require 'digest/md5'
require 'gentle_brute'

target_hash = '58e53d1324eef6265fdb97b08ed9aadf'

b = GentleBrute::BruteForcer.new
while true
  phrase = b.next_valid_phrase
  attempt_hash = Digest::MD5.hexdigest(phrase)
  puts "Password is #{phrase}" if attempt_hash == target_hash
  break if attempt_hash == target_hash
end
```

Is there really a big difference in speed?
------------------------------------------

You bet there is!

![comparison image](http://i694.photobucket.com/albums/vv305/jamespenguin1/science3-1.png)

But does it really work?
------------------------

See for yourself!

    gem install gentle_brute
    wget https://raw.github.com/jamespenguin/gentle-brute/master/passwords.txt
    GentleBrute --crack-md5-list passwords.txt

![super hax](http://i694.photobucket.com/albums/vv305/jamespenguin1/color.png)