# Day 12: Rain Risk
# https://adventofcode.com/2020/day/12

file_path = "2020/data/day_12.txt"

function part1(file_path=file_path)
    coords = Dict('N' => CartesianIndex(0, 1),
                  'S' => CartesianIndex(0, -1),
                  'E' => CartesianIndex(1, 0),
                  'W' => CartesianIndex(-1, 0))

    current_location = CartesianIndex(0, 0)
    current_direction = 'E'

    for line in readlines(file_path)
        instruction = line[1]
        amount = parse(Int, line[2:end])

        if instruction in ['N', 'S', 'E', 'W']
            current_location += amount * coords[instruction]
        elseif instruction == 'F'
            current_location += amount * coords[current_direction]
        elseif instruction == 'L'
            for i in 1:amount ÷ 90
                current_direction = left1(current_direction)
            end
        elseif instruction == 'R'
            for i in 1:amount ÷ 90
                current_direction = right1(current_direction)
            end
        end
    end
    return abs(current_location[1]) + abs(current_location[2])
end

function left1(current_direction)
    if current_direction == 'N'
        return 'W'
    elseif current_direction == 'S'
        return 'E'
    elseif current_direction == 'E'
        return 'N'
    elseif current_direction == 'W'
        return 'S'
    end
end
function right1(current_direction)
    if current_direction == 'N'
        return 'E'
    elseif current_direction == 'S'
        return 'W'
    elseif current_direction == 'E'
        return 'S'
    elseif current_direction == 'W'
        return 'N'
    end
end


@show part1(file_path)

function part2(file_path=file_path)

    coords = Dict('N' => CartesianIndex(0, 1),
                  'S' => CartesianIndex(0, -1),
                  'E' => CartesianIndex(1, 0),
                  'W' => CartesianIndex(-1, 0))
                  
    current_location = CartesianIndex(0, 0)
    waypoint = CartesianIndex(10, 1)
    current_direction = 'E'

    for line in readlines(file_path)
        instruction = line[1]
        amount = parse(Int, line[2:end])

        if instruction in ['N', 'S', 'E', 'W']
            waypoint += amount * coords[instruction]
        elseif instruction == 'F'
            current_location += amount * waypoint
        elseif instruction == 'L'
            for i in 1:amount ÷ 90
                waypoint = left2(waypoint)
            end
        elseif instruction == 'R'
            for i in 1:amount ÷ 90
                waypoint = right2(waypoint)
            end
        end
    end
    return abs(current_location[1]) + abs(current_location[2])
end



right2(waypoint) = CartesianIndex(waypoint[2],-waypoint[1])


left2(waypoint) = CartesianIndex(-waypoint[2],waypoint[1])

@show part2(file_path)