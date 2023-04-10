# Day 24: Lobby Layout
# https://adventofcode.com/2020/day/24

file_path = "2020/data/day_24.txt"

function clean_input(file_path=file_path)::Vector{Vector{String}}
    out::Vector{Vector{String}} = []
    for line in readlines(file_path)
        push!(out, split(replace(line, "se" => " se ", "sw" => " sw ", "nw" => " nw ", "ne" => " ne ", "e" => " e ", "w" => " w ")))
    end
    return out
end

function move(coords, move_direction)::Vector{Int} # takes a vector of 3 coordinates and a move direction and returns the new coordinates
    if move_direction == "ne"
        coords[1] += 1
        coords[2] -= 1
    elseif move_direction == "e"
        coords[1] += 1
        coords[3] -= 1
    elseif move_direction == "se"
        coords[2] += 1
        coords[3] -= 1
    elseif move_direction == "sw"
        coords[1] -= 1
        coords[2] += 1
    elseif move_direction == "w"
        coords[1] -= 1
        coords[3] += 1
    elseif move_direction == "nw"
        coords[2] -= 1
        coords[3] += 1
    end
    return coords
end

function part_1(part1=true, input=clean_input()) # part1=true returns the number of black tiles, part1=false returns the set of black tiles
    black_tiles = Set{Vector{Int}}()
    for line in input
        coords = [0,0,0]
        [coords = move(coords, move_direction) for move_direction in line]
        coords in black_tiles ? delete!(black_tiles, coords) : push!(black_tiles, coords)
    end
    return part1 ? length(black_tiles) : black_tiles
end


function neighbours(coords, input)::Set{Vector{Int}} # returns the set of neighbours of a tile
    out = Set{Vector{Int}}()
    for move_direction in ["ne", "e", "se", "sw", "w", "nw"]
        new_coords = move(copy(coords), move_direction)
        push!(out, new_coords)
    end
    return out
end

function black_check(coords, input)::Bool # returns true if a tile should be black, 
    on = sum([neighbour in input ? 1 : 0 for neighbour in neighbours(coords, input)])
    if coords in input
        return !(on == 0 || on > 2)
    elseif coords ∉ input
        return on == 2
    end
end

function candidate_tiles(input)::Set{Vector{Int}} # returns the set of tiles that could change colour
    candidate_tiles = Set{Vector{Int}}()
    for coords in input
        [push!(candidate_tiles, neighbour) for neighbour in neighbours(coords, input)]
    end
    return candidate_tiles
end

function part_2(days=100, input=part_1(false))::Int # returns the number of black tiles after `days` days
    for i in 1:days
        new_input = Set{Vector{Int}}()
        for coords in candidate_tiles(input)
            for neighbour in neighbours(coords, input)
                if black_check(neighbour, input)
                    push!(new_input, neighbour)
                end
            end
        end
        input = new_input
    end
    return length(input)

end

@show part_1()
@show part_2()
