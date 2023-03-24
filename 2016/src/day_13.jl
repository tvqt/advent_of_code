# Day 13: A Maze of Twisty Little Cubicles
# https://adventofcode.com/2016/day/13

using AStarSearch
using StatsBase
input = 1358

function wall_or_space(x, y, input=input) 
    bin = countmap(string(((x*x + 3*x + 2*x*y + y + y*y) + input), base=2))
    return first(values(filter(x->x[1] == '1', bin))) % 2 == 0 ? "." : "#"
end

function neighbours(xy, input=input)
    neighbs = [CartesianIndex(xy[1] + 1, xy[2]), CartesianIndex(xy[1] - 1, xy[2]), CartesianIndex(xy[1], xy[2] + 1), CartesianIndex(xy[1], xy[2] - 1)]
    return [neighb for neighb in neighbs if neighb[1] >= 0 && neighb[2] >= 0 && wall_or_space(neighb[1], neighb[2]) == "."]
end

function part_1(input=input)
    start = CartesianIndex(1, 1)
    goal = CartesianIndex(31, 39)
    return astar(neighbours, start, goal).cost
end
@show part_1(input)

function part_2(input)
    steps = 0
    start = CartesianIndex(1, 1)
    places = Set([start])
    unexhausted_areas = Set([(start, steps)])
    exhausted_areas = Set()
    while length(unexhausted_areas) > 0
        current_location, steps = pop!(unexhausted_areas)
        push!(exhausted_areas, current_location)
        if steps == 51
            continue
        end
        for area in  neighbours(current_location)
            if area ∉ places
                push!(places, area)
            end
            if area ∉ exhausted_areas
                push!(unexhausted_areas, Tuple{CartesianIndex{2}, Int64}([area, steps + 1]))
            end
        end
    end
    return length(places)
end
@info part_2(input)
