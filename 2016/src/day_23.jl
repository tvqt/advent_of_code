# Day 23: Safe Cracking
# https://adventofcode.com/2016/day/23

# I really hate the reverse engineering assembly problems

file_path = "2016/data/day_23.txt"

inc(x) = x+1
dec(x) = x-1
jnz(x, y, i) = x ≠ 0 ? i + y : i + 1
cpy(x, r) = get_value(x, r)
get_value(value, registry) = typeof(value) == Int ? value : registry[value]

function tgl(fun)
    fun == inc && return dec
    fun == dec && return inc
    fun == tgl && return inc
    fun == jnz && return cpy
    fun == cpy && return jnz
end

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





function solve(part1=true, input=clean_input())
    i = 1
    registry = Dict("a" => 7, "b" => 0, "c" => 0, "d" => 0)
    registry["a"] = part1 ? 7 : 12
    while i <= length(input)
        if i + 8 <= length(input) && input[i:i+8] == [[cpy, "b", "c"], [inc, "a"], [dec, "c"], [jnz, "c", -2], [dec, "d"], [jnz, "d", -5], [dec, "b"], [cpy, "b", "c"], [cpy, "c", "d"]]
            println("jump one")
            registry["a"] += registry["b"] * registry["d"]
            registry["b"] -= 1
            registry["d"] = registry["b"] -1
            registry["c"] = registry["b"] +1
            i += 9
            continue
        elseif i + 2 <= length(input) && input[i:i+2] == [[dec, "d"], [inc, "c"], [jnz, "d", -2]]
            println("jump two")
            registry["c"] += registry["d"]
            registry["d"] = 0
            i += 3
            continue
        elseif i + 4 <= length(input) && input[i:i+4] == [[inc, "a"], [dec, "d"], [jnz, "d", -2], [dec, "c"], [jnz, "c", -5]]
            println("jump three")
            return registry["a"] + (registry["c"] * registry["d"])
        elseif i + 2 <= length(input) && input[i:i+2] == [[inc, "a"], [inc, "d"], [jnz, "d", -2]] && registry["d"] < 0
            println("jump four")
            registry["a"] += registry["d"]
            registry["d"] = 0
            i += 3
            continue
        elseif i + 2 <= length(input) && input[i:i+2] == [[inc, "a"], [dec, "d"], [jnz, "d", -2]] && registry["d"] > 0
            println("jump five")
            registry["a"] += registry["d"]
            registry["d"] = 0
            i += 3
            continue
        end

        println(input[i])
        if input[i][2:end] == [95, "d"]
            println("hi")
        end
        if input[i][1] == tgl
            val = i + registry[input[i][2]]
            if 1 <= val <= length(input)
                input[val][1] = tgl(input[val][1])
            end
            i += 1
        elseif length(input[i]) == 2
            registry[input[i][2]] = input[i][1](registry[input[i][2]]); i += 1
        elseif input[i][1] == jnz
            i = input[i][1](get_value(input[i][2], registry), get_value(input[i][3], registry), i)
        elseif input[i][1] == cpy
            registry[input[i][3]] = input[i][1](input[i][2], registry); i += 1
        end
    end
    return registry["a"]
end
@show solve()
@show solve(false)