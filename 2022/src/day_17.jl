# https://adventofcode.com/2022/day/17
file_path = "2022/data/day_17.txt"
input = split(readline(file_path),"")


shapes = "—","+", "⅃", "|", "□"

shape_matrices= Matrix{Bool}([0 0 1 1 1 1 0]), 
                Matrix{Bool}([0 0 0 1 0 0 0; 0 0 1 1 1 0 0; 0 0 0 1 0 0 0 ]),
                Matrix{Bool}([0 0 0 0 1 0 0; 0 0 0 0 1 0 0; 0 0 1 1 1 0 0]),
                Matrix{Bool}([0 0 1 0 0 0 0; 0 0 1 0 0 0 0; 0 0 1 0 0 0 0; 0 0 1 0 0 0 0]),
                Matrix{Bool}([0 0 1 1 0 0 0; 0 0 1 1 0 0 0])
shape_matrices = Dict(zip(shapes, shape_matrices))

shape_offsets = [[0,0], [0, 1], [0, 2], [0, 3]],
                [[0,0], [0, 1], [1, 1], [-1, 1],[0, 2]],
                [[0,0], [0, 1], [0, 2], [-1,2], [-2, 2]],
                [[0,0], [1, 0], [2, 0], [3, 0]],
                [[0,0], [0, 1], [1, 0], [1, 1]]
shape_offsets = Dict(zip(shapes, shape_offsets))

initial_shape_positions =  [[1, 3],
                            [2, 3],
                            [3, 3],
                            [1, 3],
                            [1, 3]]
initial_shape_positions = Dict(zip(shapes, initial_shape_positions))

max_row = Dict(s => maximum([o[1] for o in shape_offsets[s]]) for s in shapes)

function shape_in_direction(direction, shape_offsets=shape_offsets) # returns a dictionary of shape to offsets in a particular direction
    out = Dict()
    if direction == "above"
        dir = [-1, 0]
    elseif direction == "below"
        dir = [1, 0]
    elseif direction == "left"
        dir = [0, -1]
    elseif direction == "right"
        dir = [0, 1]
    end
    for (shape, offsets) in shape_offsets
        out[shape] = setdiff([o + dir for o in offsets], offsets)
    end
    return out
end

shape_left, shape_right, shape_above, shape_below = shape_in_direction("left"), shape_in_direction("right"), shape_in_direction("above"), shape_in_direction("below")

chamber = zeros(Bool, 3, 7)

function highest_rock(chamber) # returns the index of the highest rock in the chamber
    for i in reverse(axes(chamber, 1))
        if !any(chamber[i, :])
            return i+1
        end
    end
end

function add_new_height(chamber, clearance=3) # adds a new height to the chamber, if the highest rock is within clearance of the top
    highest = highest_rock(chamber)
    if highest < clearance + 1
        return vcat(zeros(Bool, clearance - highest + 1, 7), chamber)
    elseif highest == clearance + 1
        return chamber
    elseif highest > clearance + 1
        return chamber[highest-clearance:end, :]
    end
end

function add_shape(chamber, shape) # adds a shape to the chamber
    chamber = add_new_height(chamber)
    return vcat(shape_matrices[shape], chamber)
end


function against_wall(shape, shape_position, push_index) # returns true if the shape is against the wall
    return input[push_index] == ">" ? (shape_position + shape_offsets[shape][end])[2] == 7 : shape_position[2] == 1 
end



function push_rock(chamber, shape, shape_position, push_index) # pushes the rock in the direction of the push_index
    right = input[push_index] == ">"
    pushing_into_rock = right ? any([chamber[c...] for c in [shape_position + o for o in shape_right[shape]]]) : any([chamber[c...] for c in [shape_position + o for o in shape_left[shape]]])
    if pushing_into_rock
        return shape_position
    end
    shape_position[2] = right ? shape_position[2] + 1 : shape_position[2] - 1
    [chamber[c...] = true for c in [shape_position + o for o in shape_offsets[shape]]]
    return shape_position
end

function rock_resting(chamber, shape, shape_position) # returns true if the rock is resting on another rock
    return  any([(shape_position + o)[1] == size(chamber)[1] for o in shape_offsets[shape]]) || any([chamber[c...] for c in [shape_position + o for o in shape_below[shape]]])
end

function step(chamber, shape, shape_position, push_index, half_step, need_new_shape=false)
    if !half_step
        if !rock_resting(chamber, shape, shape_position) 
            shape_position = move_rock_down(chamber, shape, shape_position)
        else
            return shape_position, true, shape_position[1] + max_row[shape]
        end
    end
    #display([i == 1 ? "⬛️" : "⬜️" for i in chamber])
    if !against_wall(shape, shape_position, push_index)
        shape_position = push_rock(chamber, shape, shape_position, push_index)
    end
    #display([i == 1 ? "⬛️" : "⬜️" for i in chamber])
    
    return shape_position, need_new_shape, nothing
end

function run(num_rocks=2022, chamber=chamber, shapes=shapes, input=input)
    history = []
    rocks_stopped = 0
    shape_index = 0
    need_new_shape = true
    push_index = 0
    height = 0
    while rocks_stopped < num_rocks
        if need_new_shape
            shape_index = shape_index == length(shapes) ? 1 : shape_index + 1
            global shape = shapes[shape_index]
            chamber = add_shape(chamber, shape)
            global shape_position = copy(initial_shape_positions[shape])
            need_new_shape = false
            global half_step = true
        end
        push_index = push_index == length(input) ? 1 : push_index + 1
        shape_position, need_new_shape, fall = step(chamber, shape, shape_position, push_index, half_step)
        half_step = false
        if need_new_shape
            rocks_stopped += 1
            push_index = push_index == 1 ? length(input) : push_index - 1
        end
        seen = check_sequence(fall, history)
        if seen[1]
            initial_height = history[seen[2]-1][2][1]
            pattern_height = highest_rock(chamber) - initial_height
            pattern_times = (num_rocks - seen[2][2]) ÷ (rocks_stopped - seen[2][2])
            pattern_remainder = (num_rocks - seen[2][2]) % (rocks_stopped - seen[2][2])
            total = pattern_height * pattern_times + highest_rock(chamber) - pattern_remainder
            break
        else
            push!(history, fall => (highest_rock(chamber), rocks_stopped))
        end
    end
    println(sum(chamber))
    return size(chamber)[1] - highest_rock(chamber) + 1
end

function check_sequence(value, history)
    if value ∉ history
        return false, nothing
    end
    for i in 1:length(history)-4
        if history[i][1] == value && history[end-2][1] == value && history[i+2][1] == history[end-1][1] && history[i+3][1] == history[end][1]
            return true, i-3
        end
    end
    return false, nothing
end
@show run(2022)


function remove_old_rock(chamber, shape, shape_position) # 
    [chamber[c...] = false for c in [shape_position + o for o in shape_offsets[shape]]]
        
    return chamber
end

function move_rock_down(chamber, shape, shape_position)
    remove_old_rock(chamber, shape, shape_position)
    shape_position = shape_position + [1, 0]
    [chamber[c...] = true for c in [shape_position + o for o in shape_offsets[shape]]]
    return shape_position
end