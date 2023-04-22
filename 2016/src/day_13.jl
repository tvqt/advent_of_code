# Day 13: A Maze of Twisty Little Cubicles
# https://adventofcode.com/2016/day/13

using AStarSearch
using StatsBase
input = 1358

function space(x, y, input=input) 
    bin = countmap(string(((x*x + 3*x + 2*x*y + y + y*y) + input), base=2))
    return first(values(filter(x->x[1] == '1', bin))) % 2 == 0
end

function neighbours(xy, input=input)
    neighbs = [CartesianIndex(xy[1] + 1, xy[2]), CartesianIndex(xy[1] - 1, xy[2]), CartesianIndex(xy[1], xy[2] + 1), CartesianIndex(xy[1], xy[2] - 1)]
    return [neighb for neighb in neighbs if neighb[1] >= 0 && neighb[2] >= 0 && space(neighb[1], neighb[2])]
end

function part_1()
    start = CartesianIndex(1, 1)
    goal = CartesianIndex(31, 39)
    return astar(neighbours, start, goal).cost
end
@show part_1()

function part_2(limit=50)
    steps = 0
    start = CartesianIndex(1, 1)
    reachable_in_x_steps = Set([start])
    queue = Set([(start, steps)])
    visited = Set()
    while length(queue) > 0
        current_location, steps = pop!(queue)
        push!(visited, current_location)
        if steps > limit
            continue
        end
        for area in neighbours(current_location)
            push!(reachable_in_x_steps, area)
            if area ∉ visited
                push!(queue, Tuple{CartesianIndex{2}, Int64}([area, steps + 1]))
            end
            push!(visited, area)
        end
    end
    return length(reachable_in_x_steps)
end
@show part_2()
