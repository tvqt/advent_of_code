# https://adventofcode.com/2021/day/25
file_path = "2021/data/day_25.txt"

input = permutedims(hcat(split.(readlines(file_path), "")...))

function step(grid)
    moved = false
    new_grid = copy(grid)
    east_facing = findall(x -> x == ">", grid)
    for cucumber in east_facing
        if cucumber + CartesianIndex(0, 1) in CartesianIndices(grid)
            if grid[cucumber + CartesianIndex(0, 1)] == "."
                moved = true
                new_grid[cucumber + CartesianIndex(0, 1)] = ">"
                new_grid[cucumber] = "."
            end
        else # loop back around
            if grid[CartesianIndex(cucumber[1], 1)] == "."
                moved = true
                new_grid[CartesianIndex(cucumber[1], 1)] = ">"
                new_grid[cucumber] = "."
            end
        end
    end
    grid = copy(new_grid)
    south_facing = findall(x -> x == "v", grid)
    for cucumber in south_facing
        if cucumber + CartesianIndex(1, 0) in CartesianIndices(grid)
            if grid[cucumber + CartesianIndex(1, 0)] == "."
                moved = true
                new_grid[cucumber + CartesianIndex(1, 0)] = "v"
                new_grid[cucumber] = "."
            end
        else # loop back around
            if grid[CartesianIndex(1, cucumber[2])] == "."
                moved = true
                new_grid[CartesianIndex(1, cucumber[2])] = "v"
                new_grid[cucumber] = "."
            end
        end
    end
    return new_grid, moved
end

function part_1(input)
    i = 1
    while true
        input, moved = step(input)
        #display(input)
        if !moved
            break
        end
        i += 1
    end
    return i
end
@show part_1(input)

