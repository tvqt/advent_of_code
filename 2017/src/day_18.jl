# https://adventofcode.com/2017/day/18

file_path = "2017/data/day_18.txt"

function clean_input(file_path=file_path)::Vector{Vector{Any}}
    out = []
    for line in readlines(file_path)
        line = split(line, " ")
        if line[1] ∈ ["snd", "rcv"]
            push!(out, line)
        else
            vars = []
            for var in line[2:end]
                var = occursin(r"\d+", var) ? parse(Int, var) : var
                push!(vars, var)
            end
            push!(out, [line[1], vars...])
        end

    end
    return out
end
clean_input()
function get_value(r, val)
    if typeof(val) == Int
        return val
    else
        return r[val]
    end
end


function machine(part2=false, queue=[], n=1, r = Dict("a" => 0, "b"=> 0, "f"=> 0, "i"=> 0, "p"=> 0), input=clean_input())
    last_sound = 0
    out = []
    while true
        #println("$r, $n, $last_sound, $(input[n])")
        if input[n] == ["jgz", "a", 3]
            println("here")
        end
        if input[n][1] == "snd"
            if part2
                push!(out, get_value(r, input[n][2]))
            else    
                last_sound = get_value(r, input[n][2])
            end
        elseif input[n][1] == "set"
            r[input[n][2]] = get_value(r, input[n][3])
        elseif input[n][1] == "add"
            r[input[n][2]] += get_value(r, input[n][3])
        elseif input[n][1] == "mul"
            r[input[n][2]] *= get_value(r, input[n][3])
        elseif input[n][1] == "mod"
            r[input[n][2]] %= get_value(r, input[n][3])
        elseif input[n][1] == "rcv"
            if part2
                if isempty(queue)
                    return r, n, out
                else
                    r[input[n][2]] = popfirst!(queue)
                end
            else
                return last_sound
            end
        elseif input[n][1] == "jgz"
            if get_value(r, input[n][2]) > 0
                n += get_value(r, input[n][3])
                continue
            end
        end
        n += 1
    end
end

function part_2()
    p1_sends = 0
    n1, n2 = 1, 1
    out1, out2 = [], []
    r1, r2 = Dict("a" => 0, "b"=> 0, "f"=> 0, "i"=> 0, "p"=> 0), Dict("a" => 0, "b"=> 0, "f"=> 0, "i"=> 0, "p"=> 1)
    while true
        println(p1_sends)
        r1, n1, out1 = machine(true, out2, n1, r1)
        r2, n2, out2 = machine(true, out1, n2, r2)
        if isempty(out1) && isempty(out2)
            break
        end
        p1_sends += length(out2)
    end
    return p1_sends
end
@show part_2()
