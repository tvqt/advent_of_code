# https://adventofcode.com/2019/day/19

file_path = "2019/data/day_19.txt"
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
            program[w] = pop!(input)
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

function deploy_drone(program, x, y)
    return Intcode(program, [x, y], true)[1]
end

function part_1(program)
    count = 0
    for y in 0:49
        for x in 0:49
            d = deploy_drone(program, x, y)
            println(d)
            count += d
        end
    end
    return count
end
#@show part_1(input)

function part_2(program)
    function find_min_and_max(program, previous_min, previous_max, x)
        min_y = previous_min
        max_y = previous_max
        for y in previous_min:previous_max
            d = deploy_drone(program, x, y)
            if d == 1
                min_y = y
                break
            end
        end
        while true
            d = deploy_drone(program, x, max_y)
            if d == 0
                max_y -= 1
                break
            else
                max_y += 1
            end
        end
        return min_y, max_y
    end

 """x = 100 
    min_y, max_y = find_min_and_max(program, 0, 100, x)
    while true
        x += 1
        min_y, max_y = find_min_and_max(program, min_y, max_y, x)
        if max_y - min_y >= 100
            if deploy_drone(program, x-99, max_y-99) == 1
                return (x-99)*10000 + (max_y-99)
            end
        end
    end"""
    # the equation of min_y is y = 0.85x + 0.15
    # the equation of max_y is y = 1.23x - 0.454
    # the equation of max_y - min_y is y = 0.38x - 0.604

end




@show part_2(input)