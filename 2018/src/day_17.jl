# Day 17: Reservoir Research
# https://adventofcode.com/2018/day/17

file_path = "2018/data/day_17.txt"

function clean_input(file_path=file_path)
    out = Dict()
    for line in readlines(file_path)
        var1, var1val, var2, var2val1, var2val2 = match(r"(\w+)=(\d+), (\w+)=(\d+)..(\d+)", line).captures
        range = collect(parse(Int, var2val1):parse(Int, var2val2))
        var1 == "x" ? [out[CartesianIndex(parse(Int, var1val), y)] = '#' for y in range] : [out[CartesianIndex(x, parse(Int, var1val))] = '#' for x in range]
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



function print_map(grid)
    min_x, max_x = minimum([x[1] for x in keys(grid)]), maximum([x[1] for x in keys(grid)])
    min_y, max_y = minimum([x[2] for x in keys(grid)]), maximum([x[2] for x in keys(grid)])
    for y in min_y:max_y
        for x in min_x:max_x
            if CartesianIndex(x, y) ∈ keys(grid)
                print(grid[CartesianIndex(x, y)])
            else
                print('.')
            end
        end
        println()
    end
end





function waterfall_new(grid, location, start=CartesianIndex(500, 0))
    if location === nothing
        location = start
    end
    upper_limit = maximum(grid)[1][2]
    while true
        #print_map_subsection(location, grid)
        if location + dirs["R"] + dirs["D"] ∈ keys(grid) && grid[location + dirs["R"] + dirs["D"] ] == '|' && location + dirs["D"] ∉ keys(grid)
            println("here")
        elseif location + dirs["L"] + dirs["D"] ∈ keys(grid) && grid[location + dirs["L"] + dirs["D"] ] == '|' && location + dirs["D"] ∉ keys(grid)
            println("here")
        end
        if location[2] == upper_limit 
            grid[location] = '|'
            break
        end
        if location + dirs["D"] ∉ keys(grid)
            grid[location + dirs["D"]] = '|'
            location += dirs["D"]
        elseif grid[location + dirs["D"]] == '|'
            break
        elseif grid[location + dirs["D"]] in ['#', '~']
            left, left_edge = water_spread_new(grid, location, dirs["L"])
            right, right_edge = water_spread_new(grid, location, dirs["R"])
            if left && right
                for x in left_edge[1]:right_edge[1]
                    grid[CartesianIndex(x, location[2])] = '~'
                end
                location -= dirs["D"]
            else
                for x in left_edge[1]:right_edge[1]
                    grid[CartesianIndex(x, location[2])] = '|'
                end
                break
            end
        end
    end
    return grid
end
function print_map_subsection(location, grid)
    min_x, max_x = location[1] -75, location[1] + 75
    min_y, max_y = location[2] - 10, location[2] + 10
    for y in min_y:max_y
        for x in min_x:max_x
            if CartesianIndex(x, y) ∈ keys(grid)
                print(grid[CartesianIndex(x, y)])
            else
                print('.')
            end
        end
        println()
    end
end

function water_spread_new(grid, location, direction)
    while true
        location += direction
        if location ∈ keys(grid) && grid[location] == '#'
            return true, location - direction
        elseif location + dirs["D"] ∉ keys(grid)
            grid = waterfall_new(grid, location)
            if grid[location + dirs["D"]] == '|'
                return false, location
            end
        elseif location + dirs["D"] ∈ keys(grid) && grid[location + dirs["D"]] == '|'
            return false, location
        end
    end
end
lower_limit = minimum([x[2] for x in keys(clean_input())])
map = waterfall_new(clean_input(), nothing, CartesianIndex(500, 0))
println(length([k for (k, v) in map if k[2] >= lower_limit && v in ['~', '|']]))
println(length([k for (k, v) in map if k[2] >= lower_limit && v == '~']))