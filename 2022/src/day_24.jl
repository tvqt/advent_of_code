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

grid, blizzards =  clean_input()

function neighbours(state, history, min_i, max_i, min_j, max_j, grid)
    out = []
    new = new_state(state, min_i, max_i, min_j, max_j)
    blizzard_locations = [coords for (coords, char) in new]
    options = setdiff(surrounding_tiles(state[1], min_i, max_i, min_j, max_j, grid), blizzard_locations)
    for option in options
        if (option, grid) ∉ history
            push!(out, (option, new))
        end
    end
    return out
end

function surrounding_tiles(coords, min_i, max_i, min_j, max_j, grid)
    n = [coords + x for x in [CartesianIndex(-1, 0), CartesianIndex(1, 0), CartesianIndex(0, -1), CartesianIndex(0, 1), CartesianIndex(0, 0)]]
    return filter(x -> x[1] >= min_i && x[1] <= max_i && x[2] >= min_j && x[2] <= max_j && grid[x[1], x[2]] == false, n)
end

function new_state(state::Tuple{CartesianIndex{2}, Vector{Any}}, min_i, max_i, min_j, max_j)
    directions = Dict('<' => CartesianIndex(0, -1), '>' => CartesianIndex(0, 1), '^' => CartesianIndex(-1, 0), 'v' => CartesianIndex(1, 0))
    out = []
    for (coords, char) in state[2]
        if char == '<' && coords[2] < min_j
            push!(out, CartesianIndex(coords[1], max_j) => char)
        elseif char == '>' && coords[2] > max_j
            push!(out, CartesianIndex(coords[1], min_j) => char)
        elseif char == '^' && coords[1] < min_i
            push!(out, CartesianIndex(max_i, coords[2]) => char)
        elseif char == 'v' && coords[1] > max_i
            push!(out, CartesianIndex(min_i, coords[2]) => char)
        else
            push!(out, coords + directions[char] => char)
        end
    end
    return out
end

function manhattan_distance(a, b)
    return abs(a[1] - b[1]) + abs(a[2] - b[2])
end

function solve(input=clean_input(), start=CartesianIndex(1,2), goal=CartesianIndex(27, 126))
    grid, blizzards = input
    min_i, max_i = extrema(axes(grid, 1))
    min_j, max_j = extrema(axes(grid, 2))
    min_i, min_j, max_i, max_j = min_i + 1, min_j + 1, max_i - 1, max_j - 1
    history = Set()
    queue = Dict((start, blizzards) => 0)
    steps = 1
    while !isempty(queue)
        state, steps = pop!(queue)
        println("$(state[1])")
        if state[1] == goal
            return steps
        end
        push!(history, state)
        steps += 1
        for neighbour in neighbours(state, history, min_i, max_i, min_j, max_j, grid)
            queue[neighbour] = steps
        end
    end

end
@show solve()
