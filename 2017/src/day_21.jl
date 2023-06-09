# https://adventofcode.com/2017/day/21

rules_path = "2017/data/day_21_1.txt"
grid_path = "2017/data/day_21_2.txt"

function clean_input(file_path=rules_path)
    out = Dict()
    for line in readlines(file_path)
        k, v = split(line, " => ")
        k, v = [hcat(split.(split(x, "/"),"")...) |> permutedims for x in [k, v]]
        k, v = [x .== "#" for x in [k, v]]
        [out[grid] = v  for grid in all_transformations(k)]
    end
    return out
end

function all_transformations(grid)
    out = all_rotations(grid)
    horizontal_flip = flip_horizontally(grid)
    push!(out, all_rotations(horizontal_flip)...)
    vertical_flip = flip_vertically(grid)
    push!(out, all_rotations(vertical_flip)...)
    both_flips = flip_horizontally(vertical_flip)
    push!(out, all_rotations(both_flips)...)
    return out
end

function flip_horizontally(grid)
    reverse(grid, dims=1)
end

function flip_vertically(grid)
    reverse(grid, dims=2)
end

function all_rotations(grid)
    out = [grid]
    for i in 1:3
        push!(out, rotate(out[end]))
    end
    return out
end

function rotate(grid)
    grid = permutedims(grid)
    grid = reverse(grid, dims=1)
end



function step(grid::BitMatrix)::BitMatrix
    if size(grid)[1] % 2 == 0
        new_grid = zeros(Bool, size(grid)[1] * 3 ÷ 2, size(grid)[2] * 3 ÷ 2)
        for i in 1:2:size(grid)[1]
            for j in 1:2:size(grid)[2]
                new_grid[i*3÷2:i*3÷2+2, j*3÷2:j*3÷2+2] = rules[grid[i:i+1, j:j+1]]
            end
        end
    elseif size(grid)[1] % 3 == 0
        new_grid = zeros(Bool, size(grid)[1] * 4 ÷ 3, size(grid)[2] * 4 ÷ 3)
        for i in 1:3:size(grid)[1]
            for j in 1:3:size(grid)[2]
                new_grid[i*4÷3:i*4÷3+3, j*4÷3:j*4÷3+3] = rules[grid[i:i+2, j:j+2]]
            end
        end
        
    end
    return new_grid
end

function solve(grid::BitMatrix, n=5)
    for i in 1:n
        grid = step(grid)
    end
    return sum(grid)
end

rules = clean_input()
starting_grid = permutedims(hcat(split.(readlines(grid_path),"")...))
starting_grid = starting_grid .== "#"

@show solve(starting_grid, 5)
@show solve(starting_grid, 18)