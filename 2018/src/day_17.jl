# Day 17: Reservoir Research
# https://adventofcode.com/2018/day/17

file_path = "2018/data/day_17.txt"

function clean_input(file_path=file_path)
    out = Dict()
    for line in readlines(file_path)
        var1, var1val, var2, var2val1, var2val2 = match(r"(\w+)=(\d+), (\w+)=(\d+)..(\d+)", line).captures
        range = collect(parse(Int, var2val1):parse(Int, var2val2))
        var1 == "x" ? [out[CartesianIndex(parse(Int, var1val), y)] = false for y in range] : [out[CartesianIndex(x, parse(Int, var1val))] = false for x in range]
    end
    return out
end

dirs = Dict("L" => CartesianIndex(-1, 0), "R" => CartesianIndex(1, 0), "D" => CartesianIndex(0, 1))

function waterfall!(grid, water_location, upper_bound)
    
    while water_location + dirs["D"] ∉ keys(grid)  || water_location + dirs["D"] != false # while the water hasn't hit the bottom, keep going down, to find the place the falling water eventually hits
        grid[water_location] = true
        if water_location[2] == upper_bound
            return grid
        end
        water_location += dirs["D"]
    end
    grid[water_location] = true
    done_spreading = false
    while !done_spreading
        if length(grid) >= 30000
            println(length(grid))
        end
        grid, left = water_spread(grid, water_location + dirs["L"], "L", upper_bound) # spead the water left
        grid, right = water_spread(grid, water_location + dirs["R"], "R", upper_bound) # spread the water right
        if !(left && right) # if left and/or the right didn't hit a wall (ie. they hit a hole which eventually lead to the bottomless pit), they we stop spreading, and return the grid
            done_spreading = true
        else
            water_location -= dirs["D"] # if both the left and the right hit walls, we can continue spreading upwards
        end
    end
    return grid
end

function water_spread(grid, water_location, direction, upper_bound) # direction is a string, either "L" or "R". Spreading the water left and right
    
    dir = dirs[direction]
    while water_location ∉ keys(grid) # while the water hasn't hit a wall
        grid[water_location] = true
        water_location += dir
        if water_location + dirs["D"] ∉ keys(grid) # if the water has found  a hole, it needs to fall downwards, hence waterfall being called here
            grid = waterfall!(grid, water_location, upper_bound)
            if water_location + dir ∉ keys(grid) # if, after the waterfall, the water hasn't filled up the space we were flowing into, it's a hole, so return the grid and false to indicate that we should stop spreading
                return grid, false 
            end
        end
    end
    return grid, true # if the water has hit a wall, return the grid and true to indicate that we should continue spreading upwards
end







function solve(i)
    clay = length(deepcopy(i))
    upper_bound = maximum(i)[1][2]
    lower_bound = minimum(i)[1][2]
    final = waterfall!(deepcopy(i), CartesianIndex(500, 0), upper_bound)
    water = length(i) - clay - 1
    return water
end
@show solve(clean_input())
