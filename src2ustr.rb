#!/usr/bin/env ruby
# src2str.rb
# This program allows compiling resources into c-powered string
# You need ruby to run this program
# Usage:
# ./src2ustr.rb <infile> <outfile> <varname>

def charToUnicode(char)
  if char.class != ::String
    fail TypeError, "Expecting string as argument, got #{char.class}"
  end
  if char.size != 1
    fail TypeError, "Size of char-string must be 1. Got #{char.size}"
  end

  u = char.unpack('U*').map{ |i| "\\u" + i.to_s(16).rjust(4, '0') }.join

  u[2, u.size]
end

def strToUnicode(str)
  result = []

  str.each_char do |c|
    result << charToUnicode(c)
  end

  result
end

data = File.read(ARGV[0])

arr = strToUnicode(data)

raw = ""

arr.each do |i|
  raw << "\\u" + i.upcase
end

# Modify next lines to make it generate code for other language
out = <<-CPP
// This file is basically packed #{ARGV[0]}. 
const char* #{ARGV[2]} = "#{raw}";
CPP

if File.exists? ARGV[1]
  File.delete ARGV[1]
end
File.open ARGV[1], 'w' do |file|
  file.write(out)
end
