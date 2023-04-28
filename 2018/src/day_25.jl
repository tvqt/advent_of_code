# https://adventofcode.com/2018/day/25

file_path = "2018/data/day_25.txt"

input = [parse.(Int, split(line, ",")) for line in readlines(file_path)]

manhattan_distance(p1, p2) = sum(abs.(p1 .- p2))


constellations = []
function one_constellation(input)
    constellation = Set([popfirst!(input)])
    while true
        connected = [x for x in input if any(manhattan_distance(x, y) <= 3 for y in constellation)]
        if isempty(connected)
            return constellation, input
        end
        push!(constellation, connected...)
        input = setdiff(input, connected)
    end
end


function part_1(input)
    constellations = 0
    while !isempty(input)
        _, input = one_constellation(input)
        constellations += 1
    end
    return constellations
end
@show part_1(input)




