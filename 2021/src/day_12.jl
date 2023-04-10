# https://adventofcode.com/2021/day/12
using StatsBase
file_path = "2021/data/day_12.txt"

function clean_input(file_path=file_path)
    neighbours = Dict{String, Vector{String}}()
    for line in readlines(file_path)
        line = split(line, "-")
        line[1] ∈ keys(neighbours) ? push!(neighbours[line[1]], line[2]) : neighbours[line[1]] = [line[2]]
        if line[1] != "start"
            line[2] ∈ keys(neighbours) ? push!(neighbours[line[2]], line[1]) : neighbours[line[2]] = [line[1]]
        end
    end
    return neighbours
end
@show clean_input()



function available_neighbours(node, cave_dict, path, small_caves, part1)
    small_cave_visits = part1 ? 1 : 2
    # filter small_cave_visit_counts to those with value >= small_cave_visits
    bad_small_caves = [k for (k,v) in countmap(filter(x -> x ∈ small_caves, path)) if v >= small_cave_visits]
    return filter(x -> x ∉ bad_small_caves, cave_dict[node])
end
    

function solve(part1=true, cave_dict=clean_input())
    n_paths = 0
    paths = Set([[["start"], []]])
    small_caves = filter(x -> lowercase(x) == x && x ∉ ["start","end"] , keys(cave_dict))
    while !isempty(paths)
        println(length(paths))
        path, visited_small_caves = pop!(paths)
        node = path[end]
        if node == "end"
            n_paths += 1
        else
            for neighbour in available_neighbours(node, cave_dict,path, small_caves, part1)
                if neighbour ∈ small_caves
                    push!(paths, [[path; neighbour], [visited_small_caves; neighbour]])
                else
                    push!(paths, [[path; neighbour], visited_small_caves])
                end
            end
        end
    end
    return n_paths
end
@show solve(false)