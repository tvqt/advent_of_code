# https://adventofcode.com/2017/day/25

file_path = "2017/data/day_25.txt"

function clean_input(f=file_path)
    input = readlines(f)
    starting_state = input[1][end-1]
    steps = parse(Int, split(input[2])[end-1])
    rules = Dict()
    for line in 4:10:length(input)
        state = input[line][end-1]
        if_zero = input[line+2][end-1] == '1' ? 1 : 0
        zero_direction = input[line+3][end-3] == 'g' ? 1 : -1
        zero_new_state = input[line+4][end-1]
        if_one = input[line+6][end-1] == '1' ? 1 : 0
        one_direction = input[line+7][end-3] == 'g' ? 1 : -1
        one_new_state = input[line+8][end-1]
        rules[state] = [[if_zero, zero_direction, zero_new_state], [if_one, one_direction, one_new_state]]
    end
    return starting_state, steps, rules
end


state, steps, rules = clean_input();

function turing_machine(state, steps, rules)
    tape = [0]
    position = 1
    for i in 1:steps
        tape[position] = rules[state][tape[position]+1][1]
        old_state = state
        state = rules[state][tape[position]+1][3]
        if rules[old_state][tape[position]+1][2] == 1
            position += 1
            if position > length(tape)
                push!(tape, 0)
            end
        else
            position -= 1
            if position == 0
                pushfirst!(tape, 0)
                position = 1
            end
        end
    end
    return sum(tape)
end
@show turing_machine(state, steps, rules)