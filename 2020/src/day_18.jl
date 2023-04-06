# Day 18: Operation Order
# https://adventofcode.com/2020/day/18

file_path = "2020/data/day_18.txt"

function unnest(line, part1=true) # unnest parentheses
    if !contains(line, "(") # if there are no more parentheses, evaluate the line
        return evaluate(line, part1)
    end

    nesting_level = 0
    out = ""
    unnested_bit = ""

    for char in line
        if char == '(' # keep track of the nesting level
            if nesting_level != 0
                unnested_bit *= char # if we're already in a nested parentheses, add the char to the unnested bit
            end
            nesting_level += 1
        elseif char == ')' # keep track of the nesting level
            nesting_level -= 1
            if nesting_level == 0 # if we're back at the top level, evaluate the unnested bit and add it to the output
                out *= unnest(unnested_bit, part1) # recursively evaluate the unnested bit
                unnested_bit = ""
            else
                unnested_bit *= char # if we're still in a nested parentheses, add the char to the unnested bit
            end
        elseif nesting_level == 0 # if we're not in a parentheses, add the char to the output
            out *= char
        elseif nesting_level > 0 # if we're in a parentheses, add the char to the unnested bit
            unnested_bit *= char
        end
    end
    return evaluate(out, part1)
end

evaluate(line, part1=true) = part1 ? evaluate1(line) : evaluate2(line)

function evaluate1(line)
    line = split(line, " ")
    out = parse(Int, line[1])
    for i in 1:2:length(line)-2
        if line[i+1] == "+"
            out += parse(Int, line[i+2])
        elseif line[i+1] == "*"
            out *= parse(Int, line[i+2])
        end
    end
    return string(out)
end
evaluate2(line) = string(eval(Meta.parse(evaluate_addition(line))))

function evaluate_addition(line)
    line = split(line, " ")
    # get the index of all "+" signs
    i =1
    while findfirst(x -> x == "+", line) !== nothing
        f = findfirst(x -> x == "+", line)
        line[f-1] = string(parse(Int, line[f-1]) + parse(Int, line[f+1]))
        splice!(line, (f:f+1))
    end
    return join(line)
end

solve(part1=true, input=readlines(file_path)) = sum(parse.(Int, unnest.(input, part1)))

@show solve()
@show solve(false)