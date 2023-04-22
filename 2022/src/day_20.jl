# https://adventofcode.com/2022/day/20

using OffsetArrays
file_path = "2022/data/day_20.txt"

input = OffsetVector(parse.(Int, readlines(file_path)), -1)

function part_1(input=input)
    original = copy(input)
    for (i, n) in enumerate(input)
        if i == 1
            input[i] = n + 3
        else
            input[i] = input[i-1] + n + 1
        end
    end
end
@show part_1()