# Day 14: Chocolate Charts
# https://adventofcode.com/2018/day/14

num_recipes = 047801
input = [3, 7]

elf_index = Dict(1 => 1, 2 => 2)

new_recipes(elf1, elf2) = [parse(Int, c) for c in string(input[elf1] + input[elf2])]
new_current(elf, elfval) = (elf + elfval + 1) > length(input) ? (elf + elfval + 1) % length(input) : elf + elfval + 1

function step_(elf1, elf2)
    append!(input, new_recipes(elf1, elf2)) # add new recipes
    elf_index[1], elf_index[2] = new_current(elf1, input[elf1]), new_current(elf2, input[elf2]) # update elf positions
end

function solve(num_recipes=num_recipes, input=input)
    p1 = nothing
    while true
        step_(elf_index[1], elf_index[2])
        if length(input) > 7  # check for part 2 pattern
            if input[end-6:end] == [0, 4, 7, 8, 0, 1, 0]
                return p1, length(input) - 7
            end
        end
        if length(input) == num_recipes + 10 # check for part 1
            p1 = parse(Int, join(input[num_recipes+1:num_recipes+10]))
        end
    end
end

@show solve()