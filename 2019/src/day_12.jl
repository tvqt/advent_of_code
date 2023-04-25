# https://adventofcode.com/2019/day/12
using Combinatorics
file_path = "2019/data/day_12.txt"

function clean_input(file_path=file_path)
    out = []
    for line in eachline(file_path)
        linedict = Dict()
        # parse lines like
        # <x=-19, y=-4, z=2>
        # <x=9, y=8, z=-16>
        x, y, z = match(r"<x=(?<x>-?\d+), y=(?<y>-?\d+), z=(?<z>-?\d+)>", line).captures
        linedict["x"], linedict["y"], linedict["z"] = parse(Int, x), parse(Int, y), parse(Int, z)
        linedict["vx"], linedict["vy"], linedict["vz"] = 0, 0, 0
        push!(out, linedict)
    end
    return out
end
@show input = clean_input()

function part_1(input=input, steps=1000)

    function gravity_pair(m1, m2, input=input)
        if input[m1]["x"] < input[m2]["x"]
            input[m1]["vx"] += 1
            input[m2]["vx"] -= 1
        elseif input[m1]["x"] > input[m2]["x"]
            input[m1]["vx"] -= 1
            input[m2]["vx"] += 1
        end
        if input[m1]["y"] < input[m2]["y"]
            input[m1]["vy"] += 1
            input[m2]["vy"] -= 1
        elseif input[m1]["y"] > input[m2]["y"]
            input[m1]["vy"] -= 1
            input[m2]["vy"] += 1
        end
        if input[m1]["z"] < input[m2]["z"]
            input[m1]["vz"] += 1
            input[m2]["vz"] -= 1
        elseif input[m1]["z"] > input[m2]["z"]
            input[m1]["vz"] -= 1
            input[m2]["vz"] += 1
        end
        return input
    end

    function add_velocity(input=input)
        for moon in input
            moon["x"] += moon["vx"]
            moon["y"] += moon["vy"]
            moon["z"] += moon["vz"]
        end
        return input
    end

    function energy(input=input)
        total = 0
        for moon in input
            pot = abs(moon["x"]) + abs(moon["y"]) + abs(moon["z"])
            kin = abs(moon["vx"]) + abs(moon["vy"]) + abs(moon["vz"])
            total += pot * kin
        end
        return total
    end

    total_energy = 0
    step = 0
    initial_state = deepcopy(input)
    repeating_periods = [[0, 0, 0] for i in 1:length(input)]

    function repeating_check(input=input, initial_state=initial_state, repeating_periods=repeating_periods)
        for (i, moon) in enumerate(input)
            if any(x -> x == 0, repeating_periods[i])
                if moon["x"] == initial_state[i]["x"] && moon["vx"] == initial_state[i]["vx"] && repeating_periods[i][1] == 0
                    repeating_periods[i][1] = step
                    println("x repeat for planet $i at step $step")
                end
                if moon["y"] == initial_state[i]["y"] && moon["vy"] == initial_state[i]["vy"] && repeating_periods[i][2] == 0
                    repeating_periods[i][2] = step
                    println("y repeat for planet $i at step $step")
                end
                if moon["z"] == initial_state[i]["z"] && moon["vz"] == initial_state[i]["vz"] && repeating_periods[i][3] == 0
                    repeating_periods[i][3] = step
                    println("z repeat for planet $i at step $step")
                end
            end
        end
        return repeating_periods
    end



    while true
        for moonpair in combinations(1:length(input), 2)
            input = gravity_pair(moonpair[1], moonpair[2]) 
        end
        input = add_velocity(input)
        step += 1
        if step == steps
            total_energy = energy(input)
        end
        repeating_periods = repeating_check(input)
        if all([all(x -> x != 0, y) for y in repeating_periods])
            return total_energy, lcm(vcat(repeating_periods...))
        end
    end 
end
@show part_1(input, 1000)

function part_2(input)
    nothing
end
@info part_2(input)
