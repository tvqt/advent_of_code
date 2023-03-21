# Day 8: Matchsticks
# https://adventofcode.com/2015/day/8

file_path = "2015/data/day_8.txt"
input = readlines(file_path) # read the input
unescaped_length(line) = length(unescape_string(line)) - 2 # unescape the string and subtract 2 for the quotes
backslashes(line) = length(findall( "\\", line)) + length(line) + length(findall( "\"", line)) +2 # count the number of backslashes and quotes and add 2 for the quotes

a = sum([length(x) for x in input]) # sum the lengths of the strings
b = sum([unescaped_length(x) for x in input]) # sum the lengths of the unescaped strings
c = sum([backslashes(x) for x in input]) # sum the lengths of the escaped strings
println("Part 1: $(a-b)")
println("Part 2: $(c-a)")