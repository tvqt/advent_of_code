# https://adventofcode.com/2015/day/24
using Combinatorics
@show input = [parse(Int, x) for x in readlines("2015/data/day_24.txt")]

function solve(part::Int=1, input::Vector{Int}=input)
    if part == 1
        target = sum(input)/3
    else
        target = sum(input)/4
    end
    out = [collect(combinations(input, n)) for n in 4:10]
    out = vcat(out...)
    out = filter(x -> sum(x) == target, out)
    # get the combiations which sum to the target``
    # get the item in test with the smallest number of items within it
    smallest_group = minimum([length(x) for x in out])
    # get the groups with the smallest number of items
    out = filter(x -> length(x) == smallest_group, out)
    # get the quantum entanglement of each group
    # get the minimum quantum entanglement
    return minimum([prod(x) for x in out])
end
@show solve(1)
#@show solve(2)
