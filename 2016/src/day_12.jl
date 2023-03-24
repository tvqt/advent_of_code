# https://adventofcode.com/2015/day/23

file_path = "2016/data/day_12.txt"
function clean_input(file_path)
    out = []
    for line in readlines(file_path)
        line = split(line, " ")
        if line[1] == "cpy"
            line = Meta.parse("$(line[3]) = copy($(line[2])); i += 1")
        elseif line[1] == "inc"
            line = Meta.parse("$(line[2]) += 1; i += 1")
        elseif line[1] == "dec"
            line = Meta.parse("$(line[2]) -= 1; i += 1")
        elseif line[1] == "jnz"
            line = Meta.parse("if $(line[2]) != 0; i += $(line[3]); else; i += 1; end")
        end
        push!(out, line)
    end
    return out
end
input = clean_input(file_path)
function solve(part=1, input=input)
    global a = 0
    global b = 0
    global c = 0
    global d = 0
    global i = 1
    while i <= length(input)
        eval(input[i])
    end
    return a
end

function parsed(part=1)
    a = 1
    b = 1
    d = 26 
    if part == 2
        c = 7
        d += c
    end
    for i in 1:d
        c = a
        a += b
        b = c
    end
    a += 12* 16
    return a
end



@show parsed(2)
