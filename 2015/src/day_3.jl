# https://adventofcode.com/2015/day/3
# Day 3: Perfectly Spherical Houses in a Vacuum

input = split(readline("2015/data/day_3.txt"),"")

function move(position, direction) # move in a direction
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
    visited = Set([(0,0)])
    for i in input # for each directive
        position = move(position, i) # move in that direction
        push!(visited, position) # add the new position to the set
    end
    return length(visited) # return the length of the set
end
@show part_1(input)

function part_2(input)
    position = (0,0) # santa's position
    position2 = (0,0) # robo-santa's position
    visited = Set([(0,0)])
    for i in eachindex(input) # for each directive
        if i % 2 == 0 # if even
            position = move(position, input[i]) # move santa
            push!(visited, position) # add the new position to the set
        else
            position2 = move(position2, input[i]) # move robo-santa
            push!(visited, position2) # add the new position to the set
        end
    end
    return length(visited) # return the length of the set

end
@show part_2(input)
