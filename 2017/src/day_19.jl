# https://adventofcode.com/2017/day/19

file_path = "2017/data/day_19.txt"

function clean_input(file_path=file_path)
    input = hcat(split.(readlines(file_path), "")...) |> permutedims
    input = input .!= " " 
    letters = Dict()
    for (i, row) in enumerate(readlines(file_path))
        for (j, char) in enumerate(row)
            if char in 'A':'Z'
                letters[CartesianIndex(i, j)] =  char
            end
        end
    end
    return findall(input), letters, CartesianIndex(1, findfirst(input[1, :]))
end

grid, letters, start = clean_input()
directions = Dict("E" => CartesianIndex(0, 1), "W" => CartesianIndex(0, -1), "N" => CartesianIndex(-1, 0), "S" => CartesianIndex(1, 0))

function choo_choo(start)
    current = start
    direction = "S"
    out = ""
    steps = 1
    while true
        current, new_steps, new_out = move_forward(current, direction)
        steps += new_steps
        out *= new_out
        direction = turn(current, direction)
        if direction === nothing
            break
        end
    end
    return out, steps
end

function move_forward(current, direction)
    ls = ""
    steps = 0
    while current + directions[direction] in grid
        current += directions[direction]
        steps += 1
        if current in keys(letters)
            ls *= letters[current]
        end
    end
    return current, steps, ls
end

function turn(current, direction)
    if direction in ["N", "S"]
        if current + directions["E"] in grid
            return "E"
        elseif current + directions["W"] in grid
            return "W"
        else
            return nothing
        end
    elseif direction in ["E", "W"]
        if current + directions["N"] in grid
            return "N"
        elseif current + directions["S"] in grid
            return "S"
        else 
            return nothing
        end
    end
end
@show choo_choo(start)