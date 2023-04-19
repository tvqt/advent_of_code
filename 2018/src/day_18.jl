# Day 18: Settlers of The North Pole
# https://adventofcode.com/2018/day/18

using StatsBase

file_path = "2018/data/day_18.txt"

clean_input(file_path=file_path) = permutedims(hcat(split.(readlines(file_path),"")...))
input = clean_input()

function neighbours(c, i=input)
    n =  [c[1]-1, c[2]-1], [c[1]-1, c[2]], [c[1]-1, c[2]+1], [c[1], c[2]-1], [c[1], c[2]+1], [c[1]+1, c[2]-1], [c[1]+1, c[2]], [c[1]+1, c[2]+1]
    return filter(x -> x[1] > 0 && x[2] > 0 && x[1] <= size(i)[1] && x[2] <= size(i)[2], n)
end

tree_neighbours(c, i=input) = filter(x -> i[x[1], x[2]] == "|", neighbours(c))
lumberyard_neighbours(c, i=input) = filter(x -> i[x[1], x[2]] == "#", neighbours(c))
open_neighbours(c, i=input) = filter(x -> i[x[1], x[2]] == ".", neighbours(c))

function step(i)
    new_input = copy(i)
    for r in axes(i, 1)
        for c in axes(i, 2)
            if i[r, c] == "."
                if length(tree_neighbours([r, c], i)) >= 3
                    new_input[r, c] = "|"
                end
            elseif i[r, c] == "|"
                if length(lumberyard_neighbours([r, c], i)) >= 3
                    new_input[r, c] = "#"
                end
            elseif i[r, c] == "#"
                if length(lumberyard_neighbours([r, c], i)) >= 1 && length(tree_neighbours([r, c], i)) >= 1
                    new_input[r, c] = "#"
                else
                    new_input[r, c] = "."
                end
            end
        end
    end
    return new_input
end

function resource_value(input)
    d = countmap(vcat(input...))
    return d["|"] * d["#"]
end


function solve(i=input, p1=10, p2=1000000000)
    history = []
    p1 = nothing
    n = 0
    old = nothing
    while true
        n += 1
        i = step(i)
        if resource_value(i) in history && old in history[1:end-1] # resource values are fairly unique, so we only need to check for two repeating values
            period_start = findfirst(x -> x == resource_value(i), history)
            period = length(history) - period_start + 1
            final_offset = (p2 - period_start + 1) % period
            return p1, history[final_offset + period_start - 1]
        else
            push!(history, resource_value(i))
        end
        if n == 10
            p1 = resource_value(i)
        end
        old = resource_value(i)
    end
end
@show solve()
