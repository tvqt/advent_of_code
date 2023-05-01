# https://adventofcode.com/2016/day/25

# Shoutout to Reddit, and u/thomastc for a hand with this one. The first chunk was fine for me, but the second chunk wasn't returning the right answer, for reasons that were (and are) entirely mysterious to me
file_path = "2016/data/day_25.txt"


# Original solution, before seeing Reddit
function clean_input(f=file_path)::Array{Array{Any,1},1}
    input = split.(readlines(f))
    out = []
    for line in input
        if length(line) == 2
            push!(out, line)
        elseif length(line) == 3
            vars = []
            for var in line[2:end]
                if occursin(r"\d+", var)
                    push!(vars, parse(Int, var))
                else
                    push!(vars, var)
                end
            end
            push!(out, [line[1], vars...])
        end
    end
    return out
end

#@show input = clean_input()

# edited, after seeing Reddit
function run_code(n, input=input, requiredlen=10)
    old = nothing
    len = 0
    registry = Dict("a" => n, "b" => 0, "c" => 0, "d" => 0)
    i = 1
    while i <= length(input)
        if i+7 <= length(input) && input[i:i+1] == [Any["cpy", "a", "d"], 
                                                    Any["cpy", 9, "c"], 
                                                    Any["cpy", 282, "b"], 
                                                    Any["inc", "d"],
                                                    Any["dec", "b"],
                                                    Any["jnz", "b", -2],
                                                    Any["dec", "c"],
                                                    Any["jnz", "c", -5]]
            #println("jump one")
            registry["d"] = registry["a"] +  282registry["c"]
            registry["b"] = 0
            registry["c"] = 0
            i += 8
            continue
        elseif i+9 <= length(input) && input[i:i+3] == [Any["cpy", "a", "b"],
                                                        Any["cpy", 0, "a"],
                                                        ["cpy", 2, "c"],
                                                        ["jnz", "b", 2],
                                                        ["jnz", 1, 6],
                                                        ["dec", "b"],
                                                        ["dec", "c"],
                                                        ["jnz", "c", -4],
                                                        ["inc", "a"],
                                                        ["jnz", 1, -7]]
            #println("jump two")
            registry["b"] = registry["d"]
            registry["a"] = floor(Int, registry["a"] / 2)
            registry["c"] = 2 - (registry["b"] % 2)
            i += 10
            continue
        end
        #println(input[i])
        if input[i][1] == "cpy"
            if input[i][2] isa Int
                registry[input[i][3]] = input[i][2]
            else
                registry[input[i][3]] = registry[input[i][2]]
            end
        elseif input[i][1] == "inc"
            registry[input[i][2]] += 1
        elseif input[i][1] == "dec"
            registry[input[i][2]] -= 1
        elseif input[i][1] == "jnz"
            if input[i][2] isa Int
                if input[i][2] != 0
                    i += input[i][3]
                    continue
                end
            elseif registry[input[i][2]] != 0
                i += input[i][3]
                continue
            end
        elseif input[i][1] == "out"
            println(registry[input[i][2]])
            if old !== nothing
                if abs(old - 1)  == registry[input[i][2]]
                    len += 1
                else
                    return false
                end
            end
            old = registry[input[i][2]]
            if len == requiredlen
                return true
            end

        end
        i += 1
    end
end

# simplified version of the program, from Reddit
function simplified(a, n)
    d = a + n
    val = 0
    len = 0
    if a == 192
        println("d = $d")
    end
    while true 
        a = d
        while a != 0 
            b = a % 2
            a = floor(a/2)
            if b == val
                len += 1
            else
                return false
            end
            val = 1 - val
            if len == 10
                return true
            end
        end
    end
end
    


new_in(f=file_path) = parse(Int, split(readlines(f)[3])[2]) * parse(Int, split(readlines(f)[2])[2])
@show new_in()

function part_1(n)
    i = 1
    while true
        println(i)
        if simplified(i, n)
            return i
        end
        i += 1
    end
end
@show part_1(new_in())