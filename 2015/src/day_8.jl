# Day 8: Matchsticks
# https://adventofcode.com/2015/day/8

file_path = "2015/data/day_8.txt"
input = readlines(file_path)
unescaped_length(line) = length(unescape_string(line)) -2
backslashes(line) = length(findall( "\\", line)) + length(line) + length(findall( "\"", line)) +2

a = sum([length(x) for x in input])
b = sum([unescaped_length(x) for x in input])
c = sum([backslashes(x) for x in input])
println(a-b)
println(c-a)