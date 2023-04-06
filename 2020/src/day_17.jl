# Day 17: Conway Cubes
# https://adventofcode.com/2020/day/17

file_path = "2020/data/day_17.txt"

function clean_input(file_path=file_path) # parse the input into a set of active cubes
    out = Set()
    for (i, line) in enumerate(readlines(file_path))
        for (j, char) in enumerate(line)
            if char == '#'
                push!(out, CartesianIndex(i,j,0))
            end
        end
    end
    return out
end

function neighbours(actives, cube, part1=true) # return the number of active cubes around the cube at (i,j,k)
    n = 0
    directions = part1 ? collect(CartesianIndices((-1:1, -1:1, -1:1))) : collect(CartesianIndices((-1:1, -1:1, -1:1, -1:1))) # collect all the directions around the cube, including diagonals. If part 2, include the 4th dimension
    for dir in directions
        condition = part1 ? !(dir[1] == 0 && dir[2] == 0 && dir[3] == 0) &&  (CartesianIndex(dir[1] + cube[1], dir[2] + cube[2], dir[3] + cube[3]) in actives) : !(dir[1] == 0 && dir[2] == 0 && dir[3] == 0 && dir[4] == 0) &&  (CartesianIndex(dir[1] + cube[1], dir[2] + cube[2], dir[3] + cube[3], dir[4] + cube[4]) in actives) # make sure we're not looking at the cube itself, and that the cube is active 
        if condition
            n += 1
        end
    end
    return n
end

check(cube, actives, part1) = cube in actives ? neighbours(actives, cube, part1) in (2,3) : neighbours(actives, cube, part1) == 3 

function solve(part1=true, input=clean_input(), runs=6)
    neighbs = part1 ? collect(CartesianIndices((-1:1, -1:1, -1:1))) : collect(CartesianIndices((-1:1, -1:1, -1:1, -1:1)))
    input = part1 ? input : Set([CartesianIndex(cube[1], cube[2], cube[3], 0) for cube in input])         # add a fourth dimension to all cubes in the input
    
    for run in 1:runs
        new_actives = Set()
        for cube in input
            for dir in neighbs
                new_cube = part1 ? CartesianIndex(dir[1] + cube[1], dir[2] + cube[2], dir[3] + cube[3]) : CartesianIndex(dir[1] + cube[1], dir[2] + cube[2], dir[3] + cube[3], dir[4] + cube[4])
                if check(new_cube, input, part1)
                    push!(new_actives, new_cube)
                end
            end
        end
        input = new_actives
    end
    return length(input)
end
@show solve()
@show solve(false) # part2