# https://adventofcode.com/2017/day/23

using Primes

file_path = "2017/data/day_23.txt"

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

function get_value(val)
    if typeof(val) == Int
        return val
    else
        return registry[val]
    end
end

function part_1(input=clean_input())
    i = 1
    mul_count = 0
    global registry = Dict("a" => 0, "b" => 0, "c" => 0, "d" => 0, "e" => 0, "f" => 0, "g" => 0, "h" => 0)
    while i <= length(input)
        if input[i][1] == "set"
            registry[input[i][2]] = get_value(input[i][3])
        elseif input[i][1] == "sub"
            registry[input[i][2]] -= get_value(input[i][3])
        elseif input[i][1] == "mul"
            registry[input[i][2]] *= get_value(input[i][3])
            mul_count += 1
        elseif input[i][1] == "jnz"
            if get_value(input[i][2]) != 0
                i += get_value(input[i][3])
                continue
            end
        end
        i += 1
    end
    return mul_count
end
@show part_1()

# for the sequence of numbers from 106700, 106700+17, 106700+ (17 * 2) etc. to 123701, how many are not prime?
p2 = sum([!isprime(x) for x in 106700:17:123701])

# decrypted code
# probably a bad idea to run, but hey, be my guest

a = part2 ? 1 : 0
b = 67
c = 67

if a != 0
    b = 100b + 100000  # 106700
    c = b + 17000
end

for b in b:17:c+1
    f = 1
    d = 2
    while d < b  # first integer
        e = 2
        while e < b # second integer
            if (d * e) == b  # if the first and second integers multiply to b (i.e., if the number is not prime)
                f = 0 # set f to 0
            end
            e += 1
        end
        d += 1
    end
    if f == 0 # if f is 0, then b is not prime
        h += 1 # increment h
    end

end