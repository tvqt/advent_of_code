# https://adventofcode.com/2022/day/24
using QuickHeaps
file_path = "2022/data/day_24.txt"

function clean_input(file_path=file_path)
    input = hcat(split.(readlines(file_path), "")...) |> permutedims
    out = input .== "#"
    blizzards = []
    for (i, row) in enumerate(readlines(file_path))
        for (j, char) in enumerate(row)
            if char in ['<', '>', '^', 'v']
                push!(blizzards, CartesianIndex(i, j) => char)
            end
        end
    end
    return out, blizzards
end

grid, b =  clean_input()

function neighbours(locations, blizzards, i_range, j_range, ends)
    out = Set()
    new_blizzards = new_state(blizzards, i_range, j_range)
    for coords in locations
        for n in surrounding_tiles(coords, i_range, j_range, ends)
            if n in [x[1] for x in new_blizzards]
                continue
            end
            push!(out, n)
        end
    end
    return out, new_blizzards
end

function surrounding_tiles(coords, i_range, j_range, ends)
    n = [coords + x for x in [CartesianIndex(-1, 0), CartesianIndex(1, 0), CartesianIndex(0, -1), CartesianIndex(0, 1), CartesianIndex(0, 0)]]
    return filter(x -> (x[1] ∈ i_range && x[2] ∈ j_range) || x in ends, n)
end

function new_state(blizzards, i_range, j_range)
    directions = Dict('<' => CartesianIndex(0, -1), '>' => CartesianIndex(0, 1), '^' => CartesianIndex(-1, 0), 'v' => CartesianIndex(1, 0))
    out = []
    for (coords, char) in blizzards
        if char == '<' && coords[2]  == j_range[1]
            push!(out, CartesianIndex(coords[1], j_range[end]) => char)
        elseif char == '>' && coords[2] == j_range[end]
            push!(out, CartesianIndex(coords[1], j_range[1]) => char)
        elseif char == '^' && coords[1] == i_range[1]
            push!(out, CartesianIndex(i_range[end], coords[2]) => char)
        elseif char == 'v' && coords[1] == i_range[end]
            push!(out, CartesianIndex(i_range[1], coords[2]) => char)
        else
            push!(out, coords + directions[char] => char)
        end
    end
    return out
end

function manhattan_distance(a, b)
    return abs(a[1] - b[1]) + abs(a[2] - b[2])
end

function solve(grid, blizzards, start=CartesianIndex(1,2), goal=CartesianIndex(size(grid, 1), size(grid, 2) -1), times=0, running_total=0)
    min_i, max_i = extrema(axes(grid, 1))
    min_j, max_j = extrema(axes(grid, 2))
    i_range, j_range = min_i + 1:max_i-1, min_j + 1:max_j - 1
    locations = Set([start])
    blizzards
    steps = 1
    while !isempty(queue)
        if isempty(locations)
            throw(ErrorException("No locations"))
        end
        #println("$(length(locations))")
        #debug(grid, blizzards, locations)
        if goal in locations
            if times == 0
                println(steps)
            elseif times ==2
                return running_total + steps
            end
            return solve(grid, blizzards, goal, start, times + 1, steps+running_total)
        end
        steps += 1
        locations, blizzards =  neighbours(locations, blizzards, i_range, j_range, [start, goal])
    end
end


function debug(grid, blizzards, locations)
    out = fill(".", size(grid)...)
    for c in CartesianIndices(grid)
        if grid[c]
            out[c] = "#"
        end
    end

    for (coords, char) in blizzards
        out[coords] = string(char)
    end
    for coords in locations
        out[coords] = "O"
    end
    
    for y in 1:size(grid, 1)
        for x in 1:size(grid, 2)
            print(out[CartesianIndex(y, x)])
        end
        println()
    end
end

@show solve(grid, b)
