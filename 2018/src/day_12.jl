
file_path = "2018/data/day_12.txt"
state = "#..#.#..##......###...###"

function clean_input(file_path=file_path)
    out = Dict()
    for line in readlines(file_path)
        line = split(line, " => ")
        out[line[1]] = line[2]
    end
    return out
end

function update_state(state, base)
    if state[1:3] != "..."
        state = "..."*state
        base -= 3
    end
    if state[end-2:end] != "..."
        state = state*"..."
    end
    return state, base
end


function step_(state, rules, base=0)
    out = ""
    for i in 3:length(state)-2
        out*=state[i-2:i+2] in keys(rules) ? rules[state[i-2:i+2]] : "."
    end
    base += 2
    return update_state(out, base)
end

function solve(state, rules, n=20)
    base = 0
    state, base = update_state(state, base)
    for i in 1:n
        state, base = step_(state, rules, base)
        println(state, base)
    end
    return state, base
end
test = solve(state, clean_input())
[i for (i, x) in enumerate(test) if x == '#'] .+ 0