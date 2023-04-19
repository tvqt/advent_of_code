# https://adventofcode.com/2018/day/16

samples_file_path = "2018/data/day_16_1.txt"

function clean_input(file_path=samples_file_path)
    before = []
    instructions = []
    after = []
    for line in 1:4:length(readlines(file_path))
        push!(before, parse.(Int, match(r"Before: \[(\d+), (\d+), (\d+), (\d+)\]", readlines(file_path)[line]).captures))
        push!(instructions, parse.(Int, split(readlines(file_path)[line+1])))
        push!(after, parse.(Int, match(r"After:  \[(\d+), (\d+), (\d+), (\d+)\]", readlines(file_path)[line+2]).captures))
    end
    return before, instructions, after
end

before, instructions, after = clean_input()

function addr(a, b, c, registers)
    registers[c+1] = registers[a+1] + registers[b+1]
    return registers
end

function addi(a, b, c, registers)
    registers[c+1] = registers[a+1] + b
    return registers
end

function mulr(a, b, c, registers)
    registers[c+1] = registers[a+1] * registers[b+1]
    return registers
end

function muli(a, b, c, registers)
    registers[c+1] = registers[a+1] * b
    return registers
end

function banr(a, b, c, registers)
    registers[c+1] = registers[a+1] & registers[b+1]
    return registers
end

function bani(a, b, c, registers)
    registers[c+1] = registers[a+1] & b
    return registers
end

function borr(a, b, c, registers)
    registers[c+1] = registers[a+1] | registers[b+1]
    return registers
end

function bori(a, b, c, registers)
    registers[c+1] = registers[a+1] | b
    return registers
end

function setr(a, b, c, registers)
    registers[c+1] = registers[a+1]
    return registers
end

function seti(a, b, c, registers)
    registers[c+1] = a
    return registers
end

function gtir(a, b, c, registers)
    registers[c+1] = a > registers[b+1] ? 1 : 0
    return registers
end

function gtri(a, b, c, registers)
    registers[c+1] = registers[a+1] > b ? 1 : 0
    return registers
end

function gtrr(a, b, c, registers)
    registers[c+1] = registers[a+1] > registers[b+1] ? 1 : 0
    return registers
end

function eqir(a, b, c, registers)
    registers[c+1] = a == registers[b+1] ? 1 : 0
    return registers
end

function eqri(a, b, c, registers)
    registers[c+1] = registers[a+1] == b ? 1 : 0
    return registers
end

function eqrr(a, b, c, registers)
    registers[c+1] = registers[a+1] == registers[b+1] ? 1 : 0
    return registers
end

function test_input(b, i, a)
    functions = [addr, addi, mulr, muli, banr, bani, borr, bori, setr, seti, gtir, gtri, gtrr, eqir, eqri, eqrr]
    working = []
    for fun in functions
        if fun(i[2], i[3], i[4], copy(b)) == a
            push!(working, fun)
        end
    end
    return working
end

function part_1(before=before, instructions=instructions, after=after)
    count = 0
    for i in eachindex(before)
        if length(test_input(before[i], instructions[i], after[i])) >= 3
            count += 1
        end
    end
    return count
end


function function_map(before=before, instructions=instructions, after=after)
    out = Dict{Int, Function}()
    while length(out) < 16
        for i in eachindex(before)
            working = test_input(before[i], instructions[i], after[i])
            if length(setdiff(working, values(out))) == 1
                out[instructions[i][1]] = setdiff(working, values(out))[1]
            end
        end
    end
    return out
end

functions = function_map()

file_path2 = "2018/data/day_16_2.txt"
clean_input2(file_path=file_path2) = [parse.(Int, x) for x in split.(readlines(file_path2))]

instructions2 = clean_input2()

function part_2(instructions=instructions2, functions=functions)
    registers = [0, 0, 0, 0]
    for i in instructions
        registers = functions[i[1]](i[2], i[3], i[4], registers)
    end
    return registers[1]
end

@show part_2()