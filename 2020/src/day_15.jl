# Day 15: Rambunctious Recitation
# https://adventofcode.com/2020/day/15

file_path = "2020/data/day_15.txt"

input = parse.(Int, split(readline(file_path),","))

function solve(n, input=input)
    last_spoken = Dict() # create a dictionary of the last time a number was spoken

    for (i, x) in enumerate(input[1:end-1]) # add all but the last number in the input to the dictionary
        last_spoken[x] = i 
    end
    last = input[end] # set the last number in the input as the last number spoken
    for i in length(input):n-1 # loop through the rest of the numbers 
        if last in keys(last_spoken)
            age = i - last_spoken[last]
        else
            age = 0
        end
        last_spoken[last] = i
        last = age
    end
    return last
end

@show solve(2020)
@show solve(30000000)