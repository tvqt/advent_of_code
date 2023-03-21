# https://adventofcode.com/2015/day/4
# Day 4: The Ideal Stocking Stuffer

using MD5


function part_1(input)
    # Find the lowest positive integer (no leading zeroes) that, when appended to the input, produces an MD5 hash that starts with five zeroes.
    n = 0
    while true
        n += 1
        if bytes2hex(md5("$input$n"))[1:5] == "00000"
            return n
        end
    end
end

function part_2(input)
    # Find the lowest positive integer (no leading zeroes) that, when appended to the input, produces an MD5 hash that starts with six zeroes.
    n = 0
    while true
        n += 1
        if bytes2hex(md5("$input$n"))[1:6] == "000000"
            return n
        end
    end
end

input = readline("2015/data/day_4.txt")

@show part_1(input)
@show part_2(input)
