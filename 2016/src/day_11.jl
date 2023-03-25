# Day 11: Radioisotope Thermoelectric Generators
# https://adventofcode.com/2016/day/11
using AStarSearch
using Combinatorics

file_path = "2016/data/day_11.txt"

function clean_input(file_path=file_path)
    building = Dict{Int, Vector{Vector{String}}}()
    for (floor, line) in enumerate(readlines(file_path))
        line = match(r"The \w+ floor contains (.*)", line).captures
        line = replace(line[1], r"\.|-compatible| a |a |nothing relevant" => "")
        line = split(line, r", and|, | and|,")
        if line == [""]
            building[floor] = []
            continue
        end
        for item in line
            item = split(item, " ")
            if floor in keys(building)
                push!(building[floor], item)
            else
                building[floor] = [item]
            end
        end
    end
    return [1, building]
end 

function valid_floors(floor::Int, building)::Vector{Int}
    if sum([length(x) for x in 1:floor-1]) == 0
        return [floor+1]
    elseif floor == 1
        return [2]
    elseif floor == 4
        return [3]
    else
        return [floor-1, floor+1]
    end
end

corresponding_item(item) = item[2] == "generator" ? [item[1], "microchip"] : [item[1], "generator"]
corresponding_pair(item1, item2) = item1[1] == item2[1] 

function valid_item(item, floor, building::Dict{Int, Vector{Vector{String}}})::Bool
    generators = [item for item in building[floor] if item[2] == "generator"]
    microchips = [item for item in building[floor] if item[2] == "microchip"]
    if corresponding_item(item) in building[floor]
        return true
    elseif (item[2] == "generator" && length(microchips) == 0) || (item[2] == "microchip" && length(generators) == 0)
            return true
    elseif item[2] == "generator"
            return all([corresponding_item(item) in building[floor] for item in generators])
    elseif item[2] == "microchip"
        return all([corresponding_item(item) in building[floor] for item in microchips])
    end
end

    


function valid_pairs(fromfloor, tofloor, building::Dict{Int, Vector{Vector{String}}})::Set{Vector{Vector{String}}}
    good_pairs = Set{Vector{Vector{String}}}()
    for pair1 in combinations(valid_items_floor(fromfloor, tofloor, building),2)
        if pair1[1][2] == pair1[2][2]
            push!(good_pairs, pair1)
        end
    end
    for pair2 in combinations(building[fromfloor], 2)
        if corresponding_pair(pair2[1], pair2[2])
            push!(good_pairs, pair2)
        end
    end
    return good_pairs
end

function valid_states_pair(state)
    valid_states = []
    for tofloor in valid_floors(state[1], state[2])
        for pair in valid_pairs(state[1], tofloor, state[2])
            new_state = deepcopy(state)
            new_state[1] = tofloor
            push!(new_state[2][tofloor], pair[1])
            if pair[2] !== nothing
                push!(new_state[2][tofloor], pair[2])
            end
            # remove item from old floor
            new_state[2][state[1]] = filter(x -> x != pair[1], new_state[2][state[1]])
            if pair[2] !== nothing
                new_state[2][state[1]] = filter(x -> x != pair[2], new_state[2][state[1]])
            end
            push!(valid_states, new_state)
        end
    end
    return valid_states
end

function valid_items_floor(fromfloor,tofloor,building::Dict{Int, Vector{Vector{String}}})::Vector{Vector{String}}
    return filter(item -> valid_item(item, tofloor, building), building[fromfloor])
end


function valid_states(state)
    valid_states = []
    for tofloor in valid_floors(state[1], state[2])
        for item in valid_items_floor(state[1], tofloor, state[2])
            new_state = deepcopy(state)
            new_state[1] = tofloor
            push!(new_state[2][tofloor], item)
            # remove item from old floor
            new_state[2][state[1]] = filter(x -> x != item, new_state[2][state[1]])
            push!(valid_states, new_state)
        end
    end
    return valid_states
end


function solve(input=input)
    goal = [4, Dict(
        1 => [],
        2 => [],
        3 => [],
        4 => vcat(values(input)...))]
    return astar(valid_states_pair,input, goal)
end

@show input = clean_input()

@show solve()


