# https://adventofcode.com/2019/day/7

file_path = "2019/data/day_7.txt"
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

function day_07(program)
    function run_acs(program, inputs)
        programs = [copy(program) for _ in 1:5]
        i_s = [1 for _ in 1:5]
        relative_bases = [0 for _ in 1:5]
        output = 0
        n = 1
        while true
            output = Intcode(programs[n], [inputs[n], output], true, i_s[n], relative_bases[n])
            if length(output) == 1
                return output[1]
            else
                i_s[n] = output[2]
                relative_bases[n] = output[3]
                output = output[end][1]
                println("[$output]")
            end

            n  = n == length(inputs) ? 1 : n+1
        end
        return output
    end
    #maximum(run_acs(program, [a,b,c,d,e]) for a in 0:4, b in 0:4, c in 0:4, d in 0:4, e in 0:4 if length(unique([a,b,c,d,e])) == 5)
    run_acs(program, [5,6,7,8,9])
end
@show day_07(input)