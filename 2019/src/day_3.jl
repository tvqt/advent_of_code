# https://adventofcode.com/2019/day/3
using DelimitedFiles
file_path = "2019/data/day_3.txt"

function clean_input(file_path=file_path)
    out = []
    for wire in eachline(file_path)
        wire_vec = []
        for instruction in split(wire, ',')
            push!(wire_vec, (instruction[1], parse(Int, instruction[2:end])))
        end
        push!(out, wire_vec)
    end
    return out
end
input =  clean_input()
function grid_dimensions(input)
    x_min, x_max, y_min, y_max, x, y = 0, 0, 0, 0, 0, 0
    for wire in input
        for (direction, distance) in wire
            if direction == 'U'
                y += distance
            elseif direction == 'D'
                y -= distance
            elseif direction == 'R'
                x += distance
            elseif direction == 'L'
                x -= distance
            end
            x_min = min(x_min, x)
            x_max = max(x_max, x)
            y_min = min(y_min, y)
            y_max = max(y_max, y)
        end
    end
    return (x_min, x_max, y_min, y_max)
end

function wire_history(wire)
    x, y, distance_travelled = 0, 0, 0
    history = Dict()
    for (direction, distance) in wire
        if direction == 'U'
            for d in 1:distance
                distance_travelled  += 1
                y += 1
                if (x, y) in keys(history)
                    history[(x, y)] = min(history[(x, y)], distance_travelled)
                else
                    history[(x, y)] = distance_travelled
                end
            end
        elseif direction == 'D'
            for d in 1:distance
                distance_travelled  += 1
                y -= 1
                if (x, y) in keys(history)
                    history[(x, y)] = min(history[(x, y)], distance_travelled)
                else
                    history[(x, y)] = distance_travelled
                end
            end
        elseif direction == 'R'
            for d in 1:distance
                distance_travelled  += 1
                x += 1
                if (x, y) in keys(history)
                    history[(x, y)] = min(history[(x, y)], distance_travelled)
                else
                    history[(x, y)] = distance_travelled
                end
            end
        elseif direction == 'L'
            for d in 1:distance
                distance_travelled  += 1
                x -= 1
                if (x, y) in keys(history)
                    history[(x, y)] = min(history[(x, y)], distance_travelled)
                else
                    history[(x, y)] = distance_travelled
                end
            end
        end
        
                
    end
    return history
end

function wire_histories(input)
    out = []
    for wire in input
        push!(out, wire_history(wire))
    end
    return out
end

# find the intersection of the two wires
function intersections(wire_histories)
    intersection_dict = Dict()
    for (x, y) in keys(wire_histories[1])
        
        if (x, y) in keys(wire_histories[2])
            intersection_dict[(x, y)] = wire_histories[1][(x, y)] + wire_histories[2][(x, y)]
        end
    end
    return minimum([sum(k) for k in keys(intersection_dict)]), minimum(values(intersection_dict))
    
end
@show intersections(wire_histories(input))