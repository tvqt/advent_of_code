file_path = "2019/data/day_5.txt"
input = parse.(Int, split(readline(file_path), ','))


function Intcode(program::Vector{Int}, input=[])
    i = 1
    while i <= length(program)
        # get parameters
        instruction = lpad(program[i], 5, "0")
        opcode = parse(Int, instruction[end-1:end])
        modes = parse.(Int, split(reverse(instruction[1:3]), ""))
        
        if opcode == 1 # add
            println("$(program[i+3]+1), $(interpreter(program, modes[1], i+1)), $(interpreter(program, modes[2], i+2))")
            program[program[i+3]+1] = interpreter(program, modes[1], i+1) + interpreter(program, modes[2], i+2)
            i += 4
        elseif opcode == 2 # multiply
            println("$(program[i+3]+1), $(interpreter(program, modes[1], i+1)), $(interpreter(program, modes[2], i+2))")
            program[program[i+3]+1] = interpreter(program, modes[1], i+1) * interpreter(program, modes[2], i+2)
            i += 4
        elseif opcode == 3 # write
            println("$(program[i+1]+1)")
            program[program[i+1]+1] = pop!(input)
            i += 2
        elseif opcode == 4 # output
            println(interpreter(program, modes[1], i+1))
            i += 2
        elseif opcode == 5 # jump if true
            println("$(interpreter(program, modes[1], i+1)), $(interpreter(program, modes[2], i+2)+1)")
            i = interpreter(program, modes[1], i+1) != 0 ? interpreter(program, modes[2], i+2)+1 : i+3
        elseif opcode == 6 # jump if false
            println("$(interpreter(program, modes[1], i+1)), $(interpreter(program, modes[2], i+2)+1)")
            i = interpreter(program, modes[1], i+1) == 0 ? interpreter(program, modes[2], i+2)+1 : i+3
        elseif opcode == 7 # less than
            program[program[i+3]+1] = interpreter(program, modes[1], i+1) < interpreter(program, modes[2], i+2) ? 1 : 0
            i += 4
        elseif opcode == 8 # greater than
            program[program[i+3]+1] = interpreter(program, modes[1], i+1) == interpreter(program, modes[2], i+2) ? 1 : 0
            i += 4
        elseif opcode == 99 # halt
            return
        else
            throw("Unknown command: $opcode")
        end
    end
end

function interpreter(program, mode, i)
    if mode == 0
        return program[program[i]+1]
    elseif mode == 1
        return program[i]
    end
end


function day_2(program)
    function part_1(program, noun=12, verb=2)
        p = copy(program)
        p[2], p[3] = noun, verb
        p = Intcode(p)
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
@show day_5(input)