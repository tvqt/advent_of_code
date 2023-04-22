# https://adventofcode.com/2022/day/22

map_path = "2022/data/day_22_1.txt"
instructions_path = "2022/data/day_22_2.txt"
instructions = split(readline(instructions_path),r"(?<=[a-zA-Z])(?=[0-9])|(?<=[0-9])(?=[a-zA-Z])")

function clean_map(file_path=map_path)
    width = maximum([length(x) for x in split.(readlines(map_path),"")])
    out = zeros(Int, width, length(readlines(file_path)))
    out .= -1
    for (row, line) in enumerate(split.(readlines(map_path),""))
        out[1:length(line), row] = [x == "#" ? 1 : x == "." ? 0 : -1 for x in line]
    end
    return permutedims(out)
end
input = clean_map()


function solve(part1=true, map=input, instructions=instructions)
    location = CartesianIndex(1, findfirst(x -> x == 0, map[1, :]))
    direction = "E"

    for instruction in instructions
        if instruction in ["L", "R"]
            direction = new_direction(direction, instruction)
            #println("turned, now facing $direction")
        else
            moving = true
            distance = parse(Int, instruction)
            travelled = 0
            while moving
                map, location, moving = part1 ? move_forward(map, location, direction) : move_forward2(map, location, direction)
                travelled += 1
                println("$(location[1]), $(location[2])")
                if travelled == distance
                    moving = false
                end
                #println(location)
            end
        end
    end
    if direction == "E"
        facing = 0
    elseif direction == "S"
        facing = 1
    elseif direction == "W"
        facing = 2
    elseif direction == "N"
        facing = 3
    end
    return (location[1] * 1000) + (location[2] * 4) + facing
        
end


function new_direction(direction, turn)
    if direction == "N"
        if turn == "L"
            return "W"
        elseif turn == "R"
            return "E"
        end
    elseif direction == "S" 
        if turn == "L"
            return "E"
        elseif turn == "R"
            return "W"
        end
    elseif direction == "W"
        if turn == "L"
            return "S"
        elseif turn == "R"
            return "N"
        end
    elseif direction == "E"
        if turn == "L"
            return "N"
        elseif turn == "R"
            return "S"
        end
    end
end

function move_forward(map, location, direction)
    dirs = Dict("N" => CartesianIndex(-1, 0), "S" => CartesianIndex(1, 0), "W" => CartesianIndex(0, -1), "E" => CartesianIndex(0, 1))
    new_location = location + dirs[direction]
    if new_location ∉ CartesianIndices(map) || map[new_location] == -1 # if we're at the edge of the map
        if direction == "E"
            new_location = CartesianIndex(location[1], findfirst(x -> x != -1, map[location[1], :]))
        elseif direction == "W"
            new_location = CartesianIndex(location[1], findlast(x -> x != -1, map[location[1], :]))
        elseif direction == "N"
            new_location = CartesianIndex(findlast(x -> x != -1, map[:, location[2]]), location[2])
        elseif direction == "S"
            new_location = CartesianIndex(findfirst(x -> x != -1, map[:, location[2]]), location[2])
        end
        if map[new_location] == 1
            return map, location, false
        end
    elseif map[new_location] == 1
        return map, location, false
    end
    return map, new_location, true
end

function move_forward2(map, location, direction)
    dirs = Dict("N" => CartesianIndex(-1, 0), "S" => CartesianIndex(1, 0), "W" => CartesianIndex(0, -1), "E" => CartesianIndex(0, 1))
    new_location = location + dirs[direction]
    if new_location ∉ CartesianIndices(map) || map[new_location] == -1 # if we're at the edge of the map
        if direction == "N"
            if location[2] in 1:50
                direction = "E"
                new_location = CartesianIndex(location[2] + 50, location[1]-50)
            elseif location[2] in 51:100
                direction = "E"
                new_location = CartesianIndex(location[2] + 100, location[1])
            elseif location[2] in 101:150
                new_location = CartesianIndex(location[1]+199, location[2] - 100)
            end
        elseif direction == "E"
            if location[1] in 1:50
                direction = "W"
                new_location = CartesianIndex(151-location[1], location[2]-50)
            elseif location[1] in 51:100
                direction = "N"
                new_location = CartesianIndex(location[2] + 50, location[1]-50)
            elseif location[1] in 101:150
                direction = "W"
                new_location = CartesianIndex(151-location[1], location[2]+50)
            elseif location[1] in 151:200
                direction = "N"
                new_location = CartesianIndex(location[2]+100, location[1]-100)
            end
        elseif direction == "W"
            if location[1] in 1:50
                direction = "E"
                new_location = CartesianIndex(151-location[1], location[2]-50)
            elseif location[1] in 51:100
                direction = "S"
                new_location = CartesianIndex(location[2] - 50, location[1]+50)
            elseif location[1] in 101:150
                direction = "E"
                new_location = CartesianIndex(151-location[1], location[2]+50)
            elseif location[1] in 151:200
                direction == "S"
                new_location = CartesianIndex(location[2], location[1] - 100)
            end
        
        elseif direction == "S"
            if location[2] in 1:50
                new_location = CartesianIndex(1, location[2]+100)
            elseif location[2] in 51:100
                direction = "W"
                new_location = CartesianIndex(location[2]+100, location[1]-100)
            elseif location[2] in 101:150
                direction = "W"
                new_location = CartesianIndex(location[2] - 50, location[1]+50)
            end
        end
        if map[new_location] == 1
            return map, location, false
        end
    elseif map[new_location] == 1
        return map, location, false
    end
    return map, new_location, true
end

function cube_sides(map)
    cube_size = 50
    out = Dict()
    cube_name = 'a'
    for col in 1:cube_size:size(map)[2]
        for row in 1:cube_size:size(map)[1]
            if !all(input[row:row+cube_size-1, col:col+cube_size-1] .== -1)
                out[cube_name] = input[row:row+cube_size-1, col:col+cube_size-1]
                cube_name += 1
            end
            
        end
    end
    return out
end

@show solve(false)