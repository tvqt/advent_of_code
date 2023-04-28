# https://adventofcode.com/2019/day/25

file_path = "2019/data/day_25.txt"
input = parse.(Int, split(readline(file_path), ','))

function Intcode(program::Vector{Int}, input=[], silent=false, i=1, relative_base=0)
    history = []
    while i <= length(program)
        w, a, b = 0, 0, 0
        # get parameters
        instruction = lpad(program[i], 5, "0")
        opcode = parse(Int, instruction[end-1:end])
        modes = parse.(Int, split(reverse(instruction[1:3]), ""))
        if opcode in [1, 2, 3, 7, 8]
            w, program = opcode != 3 ? interpreter(program, modes[3], i+3, relative_base, true) : interpreter(program, modes[1], i+1, relative_base, true)
        end
        if opcode in [1, 2, 4, 5, 6, 7, 8, 9]
            a, program = interpreter(program, modes[1], i+1, relative_base)
        end
        if opcode in [1, 2, 5, 6, 7, 8]
            b, program = interpreter(program, modes[2], i+2, relative_base)
        end

        if opcode == 1 # add
            program[w] = a + b
            i += 4
        elseif opcode == 2 # multiply
            program[w] = a * b
            i += 4
        elseif opcode == 3 # write
            if length(input) == 0
                return program, i, relative_base, history
            end
            program[w] = popfirst!(input)
            i += 2
        elseif opcode == 4 # output
            !silent ? println(a) : nothing
            push!(history, a)
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
            return history
        else
            throw("Unknown command: $opcode")
        end
    end
end

function interpreter(program::Vector{Int}, mode, i, relative_base, value=false)
    if mode in [0,2] # 
        if mode == 0
            w = program[i]+1
        else
            w = program[i]+1+relative_base
        end
        if w > length(program)
            program = vcat(program, zeros(Int, w-length(program)))
        end
        return value ? (w, program) : (program[w], program)
    elseif mode == 1 # immediate mode
        if value
            throw("Immediate mode does not support writing")
        end
        return program[i], program
    else
        throw("Unknown mode: $mode")
    end
end
"north", , "east", "west"
directions = Dict(
    "north" => [110, 111, 114, 116, 104],
    "south" => [115, 111, 117, 116, 104],
 "east" => [101, 97, 115, 116],
 "west" => [119, 101, 115, 116]
)

function day_25()