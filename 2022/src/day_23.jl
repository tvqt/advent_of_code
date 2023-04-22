# https://adventofcode.com/2022/day/23

using StatsBase

file_path = "2022/data/day_23.txt"

function clean_input(file_path=file_path)
    out = Dict()
    input = hcat(split.(readlines(file_path),"")...) |> permutedims
    input = input .== "#"
    return findall(x -> x, input)
end

function neighbours(row, col)
    # return all eight neighbours of a given CartesianIndex
    return Dict("N" => CartesianIndex(row - 1, col),
                "NE" => CartesianIndex(row - 1, col + 1),
                "E" => CartesianIndex(row, col + 1),
                "SE" => CartesianIndex(row + 1, col + 1),
                "S" => CartesianIndex(row + 1, col),
                "SW" => CartesianIndex(row + 1, col - 1),
                "W" => CartesianIndex(row, col - 1),
                "NW" => CartesianIndex(row - 1, col - 1))
end

function elf_round(elves, directions)
    new = Dict()
    out = Set()
    moved = false
    # first half
    for elf in elves
        neighbs = neighbours(elf[1], elf[2])
        if all(x -> x ∉ elves, values(neighbs))
            push!(out, elf)
            continue
        end
        dir_index = 1
        new_location = nothing
        while true
            if dir_index > length(directions)
                break
            end
            direction = directions[dir_index]
            if dir_possible(direction, neighbs, elves)
                #println("$elf is going $direction")
                new_location = neighbs[direction]
                break
            end
            dir_index += 1
        end
        if new_location === nothing
            push!(out, elf)
        else
            moved = true
            new[elf] = new_location
        end
    end
    
    # get the number of appearances for each destination in new
    while true
        counts_ = countmap(vcat(values(new)..., out...))
        # get all destinations in counts which appear more than once
        multiple = [x[1] for x in counts_ if x[2] > 1]
        if length(multiple) == 0
            break
        end
        overlapping = [x[1] for x in new if x[2] in multiple]
        push!(out, overlapping...)
        # remove keys(multiple) from new
        filter!(x -> x[1] ∉ overlapping, new)
    end
    if !isempty(new)
        push!(out, values(new)...)
    end
    @assert length(out) == length(elves)
    return out, moved
end

function dir_possible(dir, neighbs, elves)
    if dir == "N"
        return all([x ∉ elves for x in [neighbs["N"], neighbs["NE"], neighbs["NW"]]])
    elseif dir == "S"
        return all([x ∉ elves for x in [neighbs["S"], neighbs["SE"], neighbs["SW"]]])
    elseif dir == "E"
        return all([x ∉ elves for x in [neighbs["E"], neighbs["NE"], neighbs["SE"]]])
    elseif dir == "W"
        return all([x ∉ elves for x in [neighbs["W"], neighbs["NW"], neighbs["SW"]]])
    end
end
function solve(rounds = 10, input = clean_input())
    directions = ["N", "S", "W", "E"]
    p1 = nothing
    round_ = 0
    moving = true
    while moving
        round_ += 1
        input, moving = elf_round(input, directions)
        circshift!(directions, -1)
        if round_ == 10
            p1 = squarescore(input)
        end
    end
    return p1, round_
end

function squarescore(elves)
    (min_i, min_j), (max_i, max_j) = [(x[1], x[2]) for x in extrema(elves)]
    dims = (max_i - min_i + 1, max_j - min_j + 1)
    mat = zeros(Bool, dims...)
    for elf in elves
        mat[elf.I[1] - min_i + 1, elf.I[2] - min_j + 1] = true
    end
    # display mat, but replace true with X and false with . do not show quotation marks
    #for i in 1:size(mat, 1)
    #    for j in 1:size(mat, 2)
    #        if mat[i, j]
    #            print("#")
    #        else
    #            print(".")
    #        end
    #    end
    #    println()
    #end

    return (max_i - min_i + 1) * (max_j - min_j + 1) - length(elves)
end
@show solve()
