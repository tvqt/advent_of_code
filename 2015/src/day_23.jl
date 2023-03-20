# https://adventofcode.com/2015/day/23

file_path = "2015/data/day_23.txt"
function clean_input(file_path)
    out = []
    for line in readlines(file_path)
        line = split(line, ",")
        if length(line) == 2
            jump = parse(Int, line[2])
            condition = split(line[1], " ")
            if  condition[1] == "jie"
                line = Meta.parse("if $(condition[2]) % 2 == 0; i += $jump; else; i += 1; end")
            elseif condition[1] == "jio"
                line = Meta.parse("if $(condition[2]) == 1; i += $jump; else; i += 1; end")
            end
        else
            line = split(line[1], " ")
            if line[1] == "hlf"
                line = Meta.parse("$(line[2]) /= 2; i += 1")
            elseif line[1] == "tpl"
                line = Meta.parse("$(line[2]) *= 3; i += 1")
            elseif line[1] == "inc"
                line = Meta.parse("$(line[2]) += 1; i += 1")
            elseif line[1] == "jmp"
                line = Meta.parse("i += $(line[2])")
            end
        end
        push!(out, line)
    end
    return out
end
input = clean_input(file_path)
function solve(part=1, input=input)
    part == 1 ? (global a = 0) : global a = 1
    global b = 0
    global i = 1
    while i <= length(input)
        eval(input[i])
    end
    return b
end
@show solve(1)
@show solve(2)