# https://adventofcode.com/2015/day/3
# Day 3: Perfectly Spherical Houses in a Vacuum

input = split(readline("2015/data/day_3.txt"),"")

function move(position, direction)
    if direction == "^"
        return (position[1], position[2]+1)
    elseif direction == "v"
        return (position[1], position[2]-1)
    elseif direction == ">"
        return (position[1]+1, position[2])
    elseif direction == "<"
        return (position[1]-1, position[2])
    end
end

function part_1(input)
    position = (0,0)
    visited = []
    push!(visited, position)
    for i in input
        position = move(position, i)
        if !in(position, visited)
            push!(visited, position)
        end
    end
    return length(visited)
end
@show part_1(input)

function part_2(input)
    position = (0,0)
    position2 = (0,0)
    visited = []
    push!(visited, position)
    for i in eachindex(input)
        if i % 2 == 0
            position = move(position, input[i])
            if !in(position, visited)
                push!(visited, position)
            end
        else
            position2 = move(position2, input[i])
            if !in(position2, visited)
                push!(visited, position2)
            end
        end
    end
    return length(visited)

end
@info part_2(input)
