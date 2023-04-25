# https://adventofcode.com/2019/day/9

file_path = "2019/data/day_9.txt"
input = parse.(Int, split(readline(file_path), ','))

function Intcode(program::Vector{Int}, input=[])
    i = 1
    relative_base = 0
    while i <= length(program)
        w, a, b = 0, 0, 0
        vals = []
        # get parameters
        instruction = lpad(program[i], 5, "0")
        opcode = parse(Int, instruction[end-1:end])
        modes = parse.(Int, split(reverse(instruction[1:3]), ""))
        if instruction == "01102"
            println("here")
        end
        if opcode in [1, 2, 3, 7, 8]
            w = opcode != 3 ? interpreter(program, modes[3], i+3, relative_base, true) : interpreter(program, modes[1], i+1, relative_base, true)
            push!(vals, w)
        end
        if opcode in [1, 2, 4, 5, 6, 7, 8, 9]
            a = interpreter(program, modes[1], i+1, relative_base)
            push!(vals, a)
        end
        if opcode in [1, 2, 5, 6, 7, 8]
            b = interpreter(program, modes[2], i+2, relative_base)
            push!(vals, b)
        end
        if w > length(program)
            program = vcat(program, zeros(Int, w-length(program)))
        end
        if opcode == 1 # add
            program[w] = a + b
            i += 4
        elseif opcode == 2 # multiply
            program[w] = a * b
            i += 4
        elseif opcode == 3 # write
            program[w] = pop!(input)
            i += 2
        elseif opcode == 4 # output
            println(a)
            i += 2
        elseif opcode == 5 # jump if true
            #println("$(a), $(b+1)")
            i = a != 0 ? b+1 : i+3
        elseif opcode == 6 # jump if false
            i = a == 0 ? b+1 : i+3
        elseif opcode == 7 # less than
            program[w] = a < b ? 1 : 0
            i += 4
        elseif opcode == 8 # greater than
            program[w] = a == b ? 1 : 0
            i += 4
        elseif opcode == 9 # relative base offset
            relative_base += a
            i += 2
        elseif opcode == 99 # halt
            return
        else
            throw("Unknown command: $opcode")
        end
    end
end

function interpreter(program::Vector{Int}, mode, i, relative_base, value=false)
    if mode == 0 # position mode
        w = program[i]+1
        return value ? w : program[w]
    elseif mode == 1 # immediate mode
        if value
            throw("Immediate mode does not support writing")
        end
        return program[i]
    elseif mode == 2 # relative mode
        w = program[i]+1+relative_base
        return value ? w : program[w]
    else
        throw("Unknown mode: $mode")
    end
end


function day_2(program)
    function part_1(program, noun=12, verb=2)
        p = copy(program)
        p[2], p[3] = noun, verb
        Intcode(p)
        return p[1]
    end

    function part_2(program)
        for noun in 0:99
            for verb in 0:99
                if part_1(program, noun, verb) == 19690720
                    return 100noun + verb
                end
            end
        end
    end
    part_1(program),part_2(program)
end


function day_5(program, input=[1,5])
    Intcode(copy(program), [input[1]])
    Intcode(copy(program), [input[2]])
end

function day_9(program, input=[1, 2])
    Intcode(copy(program), [input[1]])
    Intcode(copy(program), [input[2]])
end
day_9(input)