# https://adventofcode.com/2019/day/8
using StatsBase
file_path = "2019/data/day_8.txt"

function solve(file_path=file_path)
    min_zeros = Inf
    out = 0
    input = readline(file_path)
    final_image = [2 for i in 1:25*6]
    for layer in 1:25*6:length(input)
        if countmap(input[layer:layer+25*6-1])['0'] < min_zeros
            min_zeros = countmap(input[layer:layer+25*6-1])['0']
            out = countmap(input[layer:layer+25*6-1])['1'] * countmap(input[layer:layer+25*6-1])['2']
        end
        for (i, pixel) in enumerate(input[layer:layer+25*6-1])
            if pixel != '2'  && final_image[i] == 2
                final_image[i] = parse(Int, pixel)
            end
        end
    end    
    println("Part 1: ", out)  
    println("Part 2:") 
    for i in 1:6
        prout = join(final_image[(i-1)*25+1:i*25])
        println(replace(prout, "0" =>"⬜️", "1" =>"⬛️"))
    end
end
solve()
