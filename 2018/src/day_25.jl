# https://adventofcode.com/2018/day/25

file_path = "2018/data/day_25.txt"

input = [parse.(Int, split(line, ",")) for line in readlines(file_path)]

manhattan_distance(p1, p2) = sum(abs.(p1 .- p2))

in_constellation(point, constellation) = any((manhattan_distance(point, p) <= 3) for p in constellation)

constellations = []
function part_1(input)
    for point in input
        if point ∉ vcat(constellations...)
            push!(constellations, [point])
            while true
            end
        end
    end
                
            
    
    
    length(constellations)
end

function rotate_clockwise(input)
    out = []
    for scanner in input
        push!(out, (scanner[2], -scanner[1], scanner[3]))
    end
    return out
end

test = [(3,4,5)]


