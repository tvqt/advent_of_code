# https://adventofcode.com/2020/day/23

input = "364289715"
input = parse.(Int, split(input, ""))



function round!(input=input)
    current_cup = input[1]
    removed = splice!(input, 2:4)
    destination_cup = destination_cup_finder(current_cup, input)
    destination_index = findfirst(x -> x == destination_cup, input) + 1
    destination_index == length(input) + 1 ? append!(input, removed) : splice!(input, destination_index:0, removed)
    circshift!(input, -1)
end

function destination_cup_finder(current_cup, input)
    destination_cup = current_cup - 1
    while true
        if destination_cup == 0
            return maximum(input)
        elseif destination_cup ∈ input
            return destination_cup
        end
        destination_cup -= 1
    end
end

function crab_cups1(n_rounds=100, input=input)
    for i in 1:n_rounds
        round!(input)
    end
    return join(input[findfirst(x -> x == 1, input) + 1:end], "") * join(input[1:findfirst(x -> x == 1, input) - 1], "")
end
@show crab_cups1()

function crab_cups2(n_rounds=10_000_000, input=input)
    append!(input, 10:1_000_000)
    for i in 1:n_rounds
        round!(input)
    end
    return input[findfirst(x -> x == 1, input) + 1] * input[findfirst(x -> x == 1, input) + 2]
end

@show crab_cups2()