
file_path = "2018/data/day_12.txt"

state = "##...#...###.#.#..#...##.###..###....#.#.###.#..#....#..#......##..###.##..#.##..##..#..#.##.####.##"
state = split(state, "") .== "#"

function clean_input(file_path=file_path)
    out = Dict{BitVector, Bool}()
    for line in readlines(file_path)
        line = split(line, " => ")
        out[split(line[1], "") .== "#"] = line[2] .== "#"
    end
    return out
end

function pot_step(state::BitVector, rules::Dict{BitVector, Bool})::BitVector
    state = vcat([0, 0, 0], state, [0, 0, 0])
    out = copy(state)
    for i in 3:length(state)-2
        if state[i-2:i+2] ∈ keys(rules)
            out[i] = rules[state[i-2:i+2]]
        else
            out[i] = 0
        end
    end
    return out[3:end-2]
end 

function solve(n=20, state=state, rules=clean_input(), old=nothing)
    for k in 1:n
        state = pot_step(state, rules)
        val = [(i-1-k) for (i, p) in enumerate(state) if p]
        if old !== nothing
            if length(val) == length(old) && all((val-old) .== 1)  && val[1] >= 3
                return sum(val) + (n-k)*length(val)
            end
        end
        old = val

    end
    # state starts at state[1] = pot 0, but each time we run pot step, we add 1 extra pot onto the left edge of the line, so after n steps, we have n extra pots on the left edge, so we need to subtract n from the index of each pot that is true, and then sum them up
    return sum((i-1-n) for (i, p) in enumerate(state) if p)
end
@show solve(20), solve(50000000000)
