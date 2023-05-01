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
        zero_direction = split(input[line+3])[end] == "right." ? 1 : -1
        zero_new_state = input[line+4][end-1]
        if_one = input[line+6][end-1] == '1' ? 1 : 0
        one_direction = split(input[line+7])[end] == "right." ? 1 : -1
        one_new_state = input[line+8][end-1]
        rules[state] = [[if_zero, zero_direction, zero_new_state], [if_one, one_direction, one_new_state]]
    end
    return starting_state, steps, rules
end


state, steps, rules = clean_input();

function new(state, tape, position)
    if position ∉ keys(tape)
        tape[position] = 0
    end
    return rules[state][tape[position]+1]
end

function part_1(state, steps, rules)
    tape = Dict()
    position = 0
    for i in 1:steps
        tape[position], direction, state = new(state, tape, position)
        position += direction
    end
    return sum(values(tape))
end
@show part_1(state, steps, rules)