# https://adventofcode.com/2017/day/18

file_path = "2017/data/day_18.txt"

function clean_input(file_path=file_path)
    out = []
    for line in readlines(file_path)
        line = split(line, " ")
        if line[1] ∈ ["snd", "rcv"]
            push!(out, line)
        elseif line[1] ∈ ["set", "add", "mul", "mod", "jgz"]
            val = try parse(Int, line[3]); catch; line[3]; end
            push!(out, [line[1], line[2], val])
        else
            error("Unknown instruction")
        end
    end
    return out
end
@show input = clean_input()

function solve(input=clean_input())
    jump(x) x == 0 ? 1 : x
    registers = Dict{String, Int}()
    last_sound = 0
    i = 1
    while last_sound == 0
        if input[i][1] == "snd"
            last_sound = registers[input[i][2]]
        elseif input[i][1] == "set"
            registers[input[i][2]+1] = input[i][3] isa Int ? input[i][3] : registers[input[i][3]]
end