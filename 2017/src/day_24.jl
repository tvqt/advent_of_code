# Day 24: Electromagnetic Moat
# https://adventofcode.com/2017/day/24
using QuickHeaps

file_path = "2017/data/day_24.txt"

input = [parse.(Int, split(line, "/")) for line in readlines(file_path)]
    
function solve(input=input)
    best, longest, longest_score = 0, 0, 0
    starts = [sort(x) for x in input if x[1] == 0 || x[2] == 0]
    
    frontier::Vector{Tuple{Vector{Vector{Int}}, Int}} = []
    [push!(frontier, ([s], s[end])) for s in starts]

    strength_so_far = Dict{Tuple{Vector{Vector{Int}}, Int}, Int}()
    [strength_so_far[[s], s[end]] = sum(s) for s in starts]

    while !isempty(frontier)
        bridge, last = pop!(frontier)
        options = [x for x in input if last in x && x ∉ bridge]

        if isempty(options)
            if sum(vcat(bridge...)) > best
                best = sum(vcat(bridge...))
            end
            if length(bridge) >= longest
                longest = length(bridge)
                longest_score = max(longest_score, sum(vcat(bridge...)))
            end
        end

        for option in options
            new_bridge = push!(copy(bridge), option)
            new_last = option[1] == last ? option[2] : option[1]
            score = sum(vcat(new_bridge...))
            if (new_bridge, new_last) ∉ keys(strength_so_far) || strength_so_far[new_bridge, new_last] < score
                strength_so_far[new_bridge, new_last] = score
                if (new_bridge, new_last) ∉ frontier
                    push!(frontier, (new_bridge, new_last))
                end
            end
        end
    end
    return best, longest_score
end
@show solve()