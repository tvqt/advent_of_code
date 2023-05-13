# https://adventofcode.com/2022/day/15

file_path = "2022/data/day_15.txt"

function clean_input(file_path::String=file_path)::Vector{Vector{Int}}
    out = []
    for line in readlines(file_path)
        push!(out, [parse.(Int, x) for x in match(r"Sensor at x=(?<x>\d+), y=(?<y>\d+): closest beacon is at x=(?<bx>[-\d]+), y=(?<by>[-\d]+)", line).captures])
    end
    return out
end

function manhattan_distance(x1::Int, y1::Int, x2::Int, y2::Int)::Int
    return abs(x1 - x2) + abs(y1 - y2)
end

function sensor_map(map_dict::Dict{CartesianIndex, Int}, line::Vector{Int})::Dict{CartesianIndex, Int}
    x, y, bx, by = line
    man_dist = manhattan_distance(x, y, bx, by)
    for i in -man_dist:man_dist
        [map_dict[coord] = 1 for coord in collect(CartesianIndices((x- man_dist - abs(i):x+man_dist - abs(i), y+i:y+i)))]
    end
    return map_dict
end
function sensor_map_all(input::Vector{Vector{Int}})::Int
    map_dict = Dict{CartesianIndex, Int}()
    [map_dict = sensor_map(map_dict, line) for line in input]

    #remove all keyvalue pairs where key  is bx, by
    [delete!(map_dict, CartesianIndex(line[3], line[4])) for line in input]
    #filter dict to only include keys where y = 10
    map_dict = filter(x -> x.first[2] == 2000000, map_dict)
    return length(map_dict)
end

function sensor_map_cheese(map_dict::Dict{CartesianIndex, Int}, line::Vector{Int},row::Int)::Dict{CartesianIndex, Int}
    x, y, bx, by = line
    man_dist = manhattan_distance(x, y, bx, by)
    if row ∈ y-man_dist:y+man_dist
        mr::Int = (man_dist - abs(row - y))
        [map_dict[coord] = 1 for coord in collect(CartesianIndices((x-mr:x+mr, row:row)))]
    end
    return map_dict
end

function sensor_map_all_cheese(input::Vector{Vector{Int}},row::Int)::Dict{CartesianIndex, Int}
    map_dict = Dict{CartesianIndex, Int}()
    [map_dict = sensor_map_cheese(map_dict, line,row) for line in input]

    #remove all keyvalue pairs where key  is bx, by
    [delete!(map_dict, CartesianIndex(line[3], line[4])) for line in input]
    #print the keys of the map, sorted
    #[println(x) for x in sort(collect(keys(map_dict)))]

    return map_dict
end

input = clean_input()
#out = sensor_map_all_cheese(input, 2000000)
#@show length(out)

#filter out so that x and y are greater than or equal to 0, and less than or equal to 4000000
#@show p2 = [x[1] * 4000000 + x[2] for x in collect(keys(out))]
####B######################

#########S#######S#
#regex which matches on positive and negative numbers
# examples of matches:
# 1
# -1

function sensor_map_cheese2(map_dict::Dict{CartesianIndex, Int}, line::Vector{Int})::Dict{CartesianIndex, Int}
    x, y, bx, by = line
    man_dist = manhattan_distance(x, y, bx, by)
    #add to map_dict the four lines that are the edges of the sensor's range
    UR = [CartesianIndex(x, y) + CartesianIndex(a,man_dist-a) for a in 0:man_dist]
    DR = [CartesianIndex(x, y) + CartesianIndex(a,a-man_dist) for a in 0:man_dist]
    UL = [CartesianIndex(x, y) + CartesianIndex(a-man_dist,a) for a in 0:man_dist]
    DL = [CartesianIndex(x, y) + CartesianIndex(-a,x-man_dist) for a in 0:man_dist]
    if row ∈ y-man_dist:y+man_dist
        mr::Int = (man_dist - abs(row - y))
        [map_dict[coord] = 1 for coord in collect(CartesianIndices((x-mr:x+mr, row:row)))]
    end
    return map_dict
end
@show sensor_map_cheese2(Dict{CartesianIndex, Int}(), input[1] )

function sensor_map_cheese2(map_set::Set{CartesianIndex{2}}, line::Vector{Int})::Set{CartesianIndex{2}}
    x, y, bx, by = line
    man_dist = manhattan_distance(x, y, bx, by)
    #add to map_dict the four lines that are the edges of the sensor's range
    union!(map_set, [CartesianIndex(x, y) + CartesianIndex(a,man_dist-a) for a in 0:man_dist])
    union!(map_set, [CartesianIndex(x, y) + CartesianIndex(a,a-man_dist) for a in 0:man_dist])
    union!(map_set, [CartesianIndex(x, y) + CartesianIndex(a-man_dist,a) for a in 0:man_dist])
    union!(map_set, [CartesianIndex(x, y) + CartesianIndex(-a,x-man_dist) for a in 0:man_dist])
    return map_set
end
@show sensor_map_cheese2(Set{CartesianIndex{2}}(), input[1] )