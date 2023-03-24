# 2016 Day 1: No Time for a Taxicab
# https://adventofcode.com/2016/day/1

file_path = "2016/data/day_1.txt"
input = split(read(file_path, String), ", ")

function new_direction(my_dir::Int, turn::Char) # returns a new direction
    if turn == 'R'
        my_dir += 90
    elseif turn == 'L'
        my_dir -= 90
    end
    return (360+ my_dir) % 360
end

function move(my_pos::CartesianIndex, my_dir::Int, steps::Int) # returns a new position
    if my_dir == 0
        return my_pos += CartesianIndex(0, steps)
    elseif my_dir == 90
        return my_pos += CartesianIndex(steps, 0)
    elseif my_dir == 180
        return my_pos -= CartesianIndex(0, steps)
    elseif my_dir == 270
        return my_pos -= CartesianIndex(steps, 0)
    end
end 

function check_range(prev_position, position) # returns a range of positions between two points
    if position[1] - prev_position[1] < 0 || position[2] - prev_position[2] < 0 # Julia doesn't like negative steps, so we have to reverse the range in a weird way
        return reverse(collect(position:prev_position))[2:end]
    else
        return collect(prev_position:position)[2:end]
    end
end

function history_checker(history, prev_position, position) # checks if a position has been visited before
    for j in check_range(prev_position, position)
        if j in history
            return j, history
        end
        push!(history, j)
    end
    return nothing, history
end
function solve(input=input) # solves both parts
    position = CartesianIndex(0,0)
    my_direction = 0
    history = Set()
    visited_twice = nothing
    for i in input
        my_direction = new_direction(my_direction, i[1])
        prev_position = position
        position = move(position, my_direction, parse(Int, i[2:end]))
        if visited_twice === nothing
            visited_twice, history = history_checker(history, prev_position, position)
        end
    end
    return abs(position[1]) + abs(position[2]), abs(visited_twice[1]) + abs(visited_twice[2]) # get the manhattan distance of the final position and the first position visited twice
end


@show solve()
