# Day 24: It Hangs in the Balance
# https://adventofcode.com/2015/day/24

using Combinatorics

input = [parse(Int, x) for x in readlines("2015/data/day_24.txt")]

function solve(part::Int=1, input::Vector{Int}=input)
    if part == 1 # part 1
        target = sum(input)/3
    else # part 2
        target = sum(input)/4
    end
    out = [collect(combinations(input, n)) for n in 4:10] # get all combinations of 4 to 10 items
    out = vcat(out...) # flatten the array
    out = filter(x -> sum(x) == target, out) # get the combiations which sum to the target
    smallest_group = minimum([length(x) for x in out]) # get the smallest group size
    out = filter(x -> length(x) == smallest_group, out) # get the smallest groups
    return minimum([prod(x) for x in out]) # return the smallest product
end
@show solve(1)
@show solve(2)
