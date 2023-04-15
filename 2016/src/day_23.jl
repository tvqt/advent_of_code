# https://adventofcode.com/2016/day/23

file_path = "2016/data/day_23.txt"

function clean_input(file_path=file_path)
    a = string.(collect('a':'z'))
    out = []
    for line in split.(readlines(file_path))
        if line[1] in ["jnz", "cpy"]
            if line[2] in a
                n2 = Symbol(line[2])
            else
                n2 = parse(Int, line[2])
            end
            if line[3] in a
                n3 = Symbol(line[3])
            else
                n3 = parse(Int, line[3])
            end
            push!(out, (line[1], n2, n3))
        elseif line[1] in ["inc", "dec", "tgl"]
            if line[2] in a
                n2 = Symbol(line[2])
            else
                n2 = parse(Int, line[2])
            end
            push!(out, (line[1], n2))
        else
            throw("Unknown instruction: $(line[1])")
        end
    end 
    return out
end

@show input = clean_input()

function part_1(input)
    nothing
end
@info part_1(input)

function part_2(input)
    nothing
end
@info part_2(input)
