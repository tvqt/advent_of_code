# Day 16: Dragon Checksum
# https://adventofcode.com/2016/day/16

input = "00111101111101000"

length1 = 272
length2 = 35651584

dragon_curve(input, target_length) = while length(input) < target_length; input = dragon_creator(input); end; return checksum(input[1:target_length])
dragon_creator(input) = input * "0" * replace(reverse(input), '0' => '1', '1' => '0') 
checksum(input) = while length(input) % 2 == 0; input = replace(input, r"00|11" => "1", r"01|10" => "0"); end; return input

@show dragon_curve(input, length1)
@show dragon_curve(input, length2)