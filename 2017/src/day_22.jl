# https://adventofcode.com/2017/day/22

file_path = "2017/data/day_22.txt"

# 0 = up, 1 = right, 2 = down, 3 = left
dirs = [CartesianIndex(-1, 0), CartesianIndex(0, 1), CartesianIndex(1, 0), CartesianIndex(0, -1)]
clean_input()::Vector{CartesianIndex{2}} = findall(permutedims(hcat(split.(readlines(file_path), "")...)) .== "#")


function step_1(pos::CartesianIndex{2}, direction::Int, network::Vector{CartesianIndex{2}})::Tuple{CartesianIndex{2}, Int, Bool, Vector{CartesianIndex{2}}}
    infection = findfirst(x-> x == pos, network)
    direction = infection !== nothing ? turn_1(direction, "R") : turn_1(direction, "L")
    infection !== nothing ? deleteat!(network, infection) : push!(network, pos)
    pos = move_forward(pos, direction)
    return pos, direction, infection === nothing, network
end

move_forward(pos, direction) = pos + dirs[direction + 1]
neighbours(pos) = [pos + c for c in dirs]
turn_1(direction, turn) = turn == "R" ? (direction + 1) % 4 : (direction + 3) % 4

function solve(part1=true, input=clean_input())::Int
    bursts = part1 ? 10000 : 10000000
    pos = maximum(input) + minimum(input) 
    pos = CartesianIndex(pos[1] ÷ 2, pos[2] ÷ 2)
    direction = 0
    total_infections = 0
    input = part1 ? input : Dict{CartesianIndex{2}, String}(zip(input, fill("C", length(input))))
    for _ in 1:bursts
        pos, direction, infection, input = part1 ? step_1(pos, direction, input) : step_2(pos, direction, input)
        infection && (total_infections += 1)
    end
    return total_infections
end


function step_2(pos::CartesianIndex{2}, direction::Int, network::Dict{CartesianIndex{2}, String})::Tuple{CartesianIndex{2}, Int, Bool, Dict{CartesianIndex{2}, String}}
    infection = pos in keys(network) ? network[pos] : "C"
    direction = turn_2(direction, infection)
    if infection == "F"
        delete!(network, pos)
    else
        network[pos] = next_status(infection)
    end
    pos = move_forward(pos, direction)

    return pos, direction, infection == "W", network
end

next_status(status) = status == "C" ? "W" : status == "W" ? "I" : "F"

function turn_2(direction::Int, node_status::String)::Int
    if node_status == "C"
        return turn_1(direction, "L")
    elseif node_status == "W"
        return direction
    elseif node_status == "I"
        return turn_1(direction, "R")
    elseif node_status == "F"
        return turn_1(turn_1(direction, "R"), "R")
    end
end



@show solve()
@show solve(false)