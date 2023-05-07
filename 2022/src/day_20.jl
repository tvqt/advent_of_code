# https://adventofcode.com/2022/day/20

file_path = "2022/data/day_20.txt"

input = parse.(Int, readlines(file_path))

function mixer(input=input)
    original = copy(input)
    #println(input)
    for o_n in original
        if o_n == 0
            continue
        end
        i = findfirst(x-> x==o_n, input)
        if o_n == 253
            println("here")
        end
        a = splice!(input, i)
        new_i = i + a 
        if new_i < 1
            new_i = mod1(length(input) + new_i, length(input))
        elseif new_i == 1
            new_i = length(input)
        elseif new_i > length(input)
            new_i = mod1(new_i, length(input))
        end
        println("src: $i, dest: $new_i, node: $o_n")
        insert!(input, new_i, a)
        #println(input)
    end
    return input
end

function part_1()
    out = 0
    mixed = mixer()
    i = findfirst(x-> x==0, mixed)    
    return sum([(mixed[(i+n) % length(mixed)]) for n in [1000, 2000, 3000]])
end

@show part_1()
Coverage.collect()