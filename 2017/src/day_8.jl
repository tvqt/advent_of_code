# https://adventofcode.com/2017/day/8

file_path = "2017/data/day_8.txt"

function clean_input(file_path=file_path)
    out = []
    register = Dict()
    for line in readlines(file_path)
        line = split(line, " if ")
        eq = split(replace(line[1], "inc" => "+", "dec" => "-"), " ")
        if eq[1] ∉ keys(register)
            register[eq[1]] = 0
        end
        cond = split(line[2], " ")
        if cond[1] ∉ keys(register)
            register[cond[1]] = 0
        end
        cond = "register[\"" * cond[1] * "\"] " * cond[2] * " " * cond[3]
        eq = "register[\"" * eq[1] * "\"] = register[\"" * eq[1] * "\"] "* eq[2] * " " * eq[3]
        push!(out, [cond, eq])
    end
    return out, register
end

function solve(input=clean_input())
    max_during = 0
    instructions = input[1]
    global register = copy(input[2])
    for (condition, instruction) in instructions
        if eval(Meta.parse(condition))
            eval(Meta.parse(instruction))
            if maximum(values(register)) > max_during
                max_during = maximum(values(register))
            end
        end
    end
    return maximum(values(register)), max_during

end

@show solve()