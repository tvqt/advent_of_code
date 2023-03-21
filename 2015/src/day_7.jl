# Day 7: Some Assembly Required
# https://adventofcode.com/2015/day/7

file_path = "2015/data/day_7.txt"

function clean_input(file_path=file_path)
    out = Dict()
    for line in readlines(file_path)
        line = split(line, " -> ")
        equation = split(line[1], " ")
        variables = filter(x -> x ∉ ["AND", "OR", "NOT", "LSHIFT", "RSHIFT"], equation)
        operation = filter(x -> x ∈ ["AND", "OR", "NOT", "LSHIFT", "RSHIFT"], equation)
        operation = isempty(operation) ? "ASSIGN" : operation[1]
        out[line[2]] = operation, variables
    end
    return out
end

isnumber(x) = try parse(Int, x); true catch; false end
varval(x, out) = isnumber(x) ? parse(Int, x) : out[x]

function solve(input=input, b=0)
    out = Dict()
    if b != 0
        out["b"] = b
    end
    while "a" ∉ keys(out)
        # filter instructions to only those where all variables are in out or are numbers
        instructions = filter(x -> all(y -> y ∈ keys(out) || isnumber(y), x[2][2]), copy(input))
        # filter out keys from input that are already in out
        instructions = filter(x -> x[1] ∉ keys(out), instructions)
        for (key, (operation, variables)) in instructions
            if operation == "ASSIGN"
                out[key] = varval(variables[1], out)
            elseif operation == "NOT"
                out[key] = ~varval(variables[1], out)
            elseif operation == "AND"
                out[key] = varval(variables[1], out) & varval(variables[2], out)
            elseif operation == "OR"
                out[key] = varval(variables[1], out) | varval(variables[2], out)
            elseif operation == "LSHIFT"
                out[key] = varval(variables[1], out) << varval(variables[2], out)
            elseif operation == "RSHIFT"
                out[key] = varval(variables[1], out) >> varval(variables[2], out)
            else
                error("Unknown operation: $operation")
            end
        end

    end
    return out["a"]
end

input = clean_input()

@show part1 = solve(input)
@show part2 = solve(input, part1)
