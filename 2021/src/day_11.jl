# Day 11: Dumbo Octopus
# https://adventofcode.com/2021/day/11

file_path = "2021/data/day_11.txt"

function clean_input(file_path=file_path)
    # find the size of the matrix
    input = readlines(file_path)
    mat = zeros(Int, length(input), length(input[1]))
    for (row, line) in enumerate(input)
        line = parse.(Int, split(line, ""))
        mat[row, :] = line
    end
    return mat
end
input = clean_input()

flash_spillover!(coord, input=clean_input()) = [try input[coord] += 1; catch; nothing; end for coord in collect(CartesianIndices((coord[1]-1:coord[1]+1, coord[2]-1:coord[2]+1)))]


function step(input=clean_input())
    # increase every value by 1
    input .+= 1
    flashes=Set{CartesianIndex{2}}()

    while length(setdiff(findall(x->x>9, input), flashes)) != 0     # while there are still values greater than 9 that haven't flashed yet
        coord = first(setdiff(findall(x->x>9, input), flashes))     # find the first coord that is greater than 9
        if coord ∉ flashes                                          # check it hasn't flashed already
            flash_spillover!(coord, input)
            push!(flashes, coord)                                   # add it to flashes
        end
    end

    [input[coord] = 0 for coord in flashes]                         # set all the coords that have flashed to 0
    return input, length(flashes), length(flashes) == length(input)
end

function solve(steps=100, input=clean_input())
    total_flashes = 0
    s = 0
    all_flashing = false
    while !all_flashing
        s += 1
        input, flashes, all_flashing = step(input)
        if s <= steps
            total_flashes += flashes
        end
    end
    return total_flashes, s
end

@show solve()