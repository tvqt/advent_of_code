# https://adventofcode.com/2016/day/25

file_path = "2016/data/day_25.txt"

inc(x) = x+1
dec(x) = x-1
jnz(x, y, i) = x ≠ 0 ? i + y : i + 1
cpy(x, r) = get_value(x, r)
out(x) = x
get_value(value, registry) = typeof(value) == Int ? value : registry[value]


function clean_input(f=file_path)
    out::Vector{Any} = []
    for line in split.(readlines(f))
        l::Vector{Any} = [getfield(Main, Symbol(line[1]))]
        push!(l, (try( parse(Int, line[2]) ); catch; line[2]; end))
        if length(line) == 3
            push!(l, (try( parse(Int, line[3]) ); catch; line[3]; end))
        end
        push!(out, l)
    end
    return out
end

function run_program(value, input=clean_input())
    history = []
    i = 1
    value = 0
    len = 0
    registry = Dict("a" => 7, "b" => 0, "c" => 0, "d" => 0)
    registry["a"] = value
    while i <= length(input)
        if input[i][1] == out
            println("here")
            if get_value(input[i][2], registry) != value
                return false
            else
                value = 1 - value
                len += 1
                if len == 100
                    return true
                end
            end
        end
        if i + 5 <= length(input) && input[i:i+5] == [[cpy, 282, "b"], [inc, "d"], [dec, "b"], [jnz, "b", -2], [dec, "c"], [jnz, "c", -5]]
            println("jump one")
            registry["d"] += 282registry["c"] 
            registry["c"] = 0
            registry["b"] = 0
            i += 6
            continue
        elseif i + 11 <= length(input) && input[i:i+11] == [[cpy, "d", "a"], [jnz, 0, 0], [cpy, "a", "b"], [cpy, 0, "a"], [cpy, 2, "c"], [jnz, "b", 2], [jnz, 1, 6], [dec, "b"], [dec, "c"], [jnz, "c", -4], [inc, "a"], [jnz, 1, -7]]
            println("jump two")
            registry["a"] = registry["d"] ÷ 2
            registry["b"] = 0
            registry["c"] = 0
            i += 12
        end
        println(input[i])
        if input[i][1] == out
            push!(history, get_value(input[i][2], registry))
            i += 1
        elseif length(input[i]) == 2
            registry[input[i][2]] = input[i][1](registry[input[i][2]]); i += 1
        elseif input[i][1] == jnz
            i = input[i][1](get_value(input[i][2], registry), get_value(input[i][3], registry), i)
        elseif input[i][1] == cpy
            registry[input[i][3]] = input[i][1](input[i][2], registry); i += 1
        end
        if length(history) > 5 && (history[end-4:end] == [0, 1, 0, 1, 0] || history[end-4:end] == [1, 0, 1, 0, 1])
            return true
        end
    end
end
@show run_program(7)

function part_1()
    value = 1
    while true
        if run_program(value)
            return value
        end
        value += 1
    end
end
@show part_1()