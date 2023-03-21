# Day 11: Corporate Policy
# https://adventofcode.com/2015/day/11

input1 = "hepxcrrq"
input2 = "hepxxyzz"


function solver(input::String)::String
    if input[end-4] > 'x' || input[end-4:end] == "xxyzz"
        return join(input[1:2] * (input[3] +1 ) * "aabcc")
    else
        return join(input[1:4] * (input[4]) * (input[4] + 1) * (input[4] + 2) * (input[4] + 2))
    end
end
@show solver(input1)
@show solver(input2)