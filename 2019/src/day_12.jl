# https://adventofcode.com/2019/day/12
using Combinatorics
file_path = "2019/data/day_12.txt"

function clean_input(file_path=file_path) # read input file and return a list of lists of integers
    out = [parse.(Int, match(r"<x=(?<x>-?\d+), y=(?<y>-?\d+), z=(?<z>-?\d+)>", line).captures) for line in readlines(file_path)]
    return [x[1] for x in out], [x[2] for x in out], [x[3] for x in out]
end

function gravity_pair_dir(m, v) # calculate velocity change in one particular coordinate direction (x, y, or z). m is the location, v is the velocity
    for i in combinations(eachindex(m), 2)
        v[i[1]], v[i[2]] = gravity_pair_two(m[i[1]], m[i[2]], v[i[1]], v[i[2]])
    end
    return v
end

gravity_pair_two(m1, m2, v1, v2) = m1 < m2 ? (v1 +1, v2 -1) : m1 > m2 ? (v1 -1, v2 +1) : (v1, v2) # velocity change from one particular interaction
gravity_pair(m3, v3) = [gravity_pair_dir(m, v) for (m, v) in zip(m3, v3)] # velocity change from all interactions
add_velocity_dir(m, v) = [m[i] + v[i] for i in eachindex(m)] # add velocity change to location in one particular coordinate direction
add_velocity(m3, v3) = [add_velocity_dir(m, v) for (m, v) in zip(m3, v3)] # add velocity change to location in all coordinate directions
energy(input, v) = sum([sum(abs.([x[i] for x in input])) * sum(abs.([x[i] for x in v])) for i in eachindex(input[1])])  # total energy of the system
repeating_check(input, initial, repeating, step, v) = [repeating[i] = repeating[i] != 0 ? repeating[i] : input[i] == initial[i] ? step + 1 : 0 for i in eachindex(input)] # check if the system has returned to its initial state

function solve(input = clean_input(), steps=1000) # solve part 1 and 2
    v = [[0 for _ in eachindex(input[1])] for _ in 1:3]
    total_energy = 0
    step = 0
    initial_state = deepcopy(input)
    repeating = [0,0,0]
    while true
        v = gravity_pair(input, v)
        input = add_velocity(input, v)
        step += 1
        if step == steps
            total_energy = energy(input, v)
        end
        repeating = repeating_check(input, initial_state, repeating, step, v)
        if all(repeating .!= 0)
            return total_energy, lcm(repeating...)
        end
    end 
end
@show solve()

