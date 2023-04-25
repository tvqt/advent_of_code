file_path = "2019/data/day_2.txt"
input = parse.(Int, split(readline(file_path), ','))


function Intcode(program::Vector{Int})
    i = 1
    while i <= length(program)
        if program[i] == 1 # add
            program[program[i+3]+1] = program[program[i+1]+1] + program[program[i+2]+1]
            i += 4
        elseif program[i] == 2 # multiply
            program[program[i+3]+1] = program[program[i+1]+1] * program[program[i+2]+1]
            i += 4
        elseif program[i] == 99 # halt
            return program
        end
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
@show day_2(input)
