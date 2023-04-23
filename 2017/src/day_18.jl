# https://adventofcode.com/2017/day/18

file_path = "2017/data/day_18.txt"

function clean_input(file_path=file_path)::Vector{Vector{Any}}
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


function solve(input)
    n = 1
    r = Dict('a' => 0, 'b' => 0, 'f' => 0, 'i' => 0, 'p' => 0)
    last_sound = 0
    while true
        println("$r, $n, $last_sound, $(input[n])")
        if input[n][1] == "snd"
            last_sound = r[input[n][2]]
        elseif input[n][1] == "set"
            r[input[n][2]] = input[n][3]
        elseif input[n][1] == "add"
            r[input[n][2]] += input[n][3]
        elseif input[n][1] == "mul"
            r[input[n][2]] *= input[n][3]
        elseif input[n][1] == "mod"
            r[input[n][2]] %= input[n][3]
        elseif input[n][1] == "rcv"
            if r[input[n][2]] != 0
                return last_sound
            end
        elseif input[n][1] == "jgz"
            if r[input[n][2]] > 0
                n += input[n][3]
                continue
            end
        else
            error("Unknown instruction")
        end
        n += 1
    end
end
@show solve(input)