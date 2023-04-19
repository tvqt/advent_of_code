# https://adventofcode.com/2016/day/19

num_elves = 3014603

input(elves=num_elves) = collect(1:elves)

function steal_one!(elf, input=input(), part1=false)
    if part1
        println("$(input[elf]) stealing from $(input[elf + 1 > length(input) ? 1 : elf + 1]), $(length(input)) elves left")
        elf + 1 > length(input) ? splice!(input, 1) : splice!(input, elf + 1)
    else
        jump = elf + div(length(input), 2) > length(input) ? elf + div(length(input), 2) - length(input) : elf + div(length(input), 2)
        #println("$(input[elf]) stealing from $(input[jump]), $(length(input)) elves left")
        splice!(input, jump)
    end
end

function solve(part1=false, input=input())
    elf = 1
    while length(input) > 1
        steal_one!(elf, input, part1)
        elf = elf + 1 > length(input) ? 1 : elf + 1
    end
    return input
end

#@show solve(input)
#@show solve(false)

part_1_fast(num_elves=num_elves) = 2 * (num_elves - 2^floor(Int, log2(num_elves))) + 1

function part_2_fast(n=num_elves)::Int
    a = 2
    while a < n
        a =  3a - 2 
    end
    b = (a+2)/3
    r = n - b + 1
    if r >= b  
        r = 2r - 9
    end
    return r
end



@show part_1_fast()
@show part_2_fast()