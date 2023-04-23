# Day 20: Particle Swarm
# https://adventofcode.com/2017/day/20

using StatsBase: countmap
file_path = "2017/data/day_20.txt"

clean_input(file_path=file_path)::Vector{Vector{Int}} = [[i-1, parse.(Int, match(r"p=<(-?\d+),(-?\d+),(-?\d+)>, v=<(-?\d+),(-?\d+),(-?\d+)>, a=<(-?\d+),(-?\d+),(-?\d+)>", line).captures)...] for (i, line) in enumerate(readlines(file_path))]


# I got (what I thought was the correct) answer simulating it, but it wasn't correct. After looking at Reddit, and then at somebody else's solution, I realised the lines were zero indexed, and my original solution was (almost) right all along. Here is another one line solution I found on Reddit.
@time (sort(clean_input(), by=x->(sum(abs.(x[8:10])), sum(abs.(x[5:7])), sum(abs.(x[2:4]))))[1][1])



function tick(input::Vector{Vector{Int}})::Vector{Vector{Int}}
    for i in eachindex(input)
        input[i][5:7] .+= input[i][8:10]
        input[i][2:4] .+= input[i][5:7]
    end
    locations = Set([p[2:4] for p in input])
    if length(locations) < length(input) # if there are any collisions
        location_counts = countmap([p[2:4] for p in input])
        filter!(p->location_counts[p[2:4]] == 1, input)
    end
    return input
end

function part_2(input=clean_input())
    history = []
    while true
        input = tick(input)
        if length(history) > 9  && all(history[end-9:end] .== length(input))
            return length(input)
        end
        push!(history, length(input))
    end
end
@time part_2()