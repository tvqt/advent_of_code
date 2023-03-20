# https://adventofcode.com/2015/day/14

file_path = "2015/data/day_14.txt"
function clean_input(file_path)
    reindeer = []
    for line in readlines(file_path)
        # example line
        # Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.
        line = match(r"(\w+) can fly (\d+) km/s for (\d+) seconds, but then must rest for (\d+) seconds.", line).captures
        name = line[1]
        speed = parse(Int, line[2])
        fly_time = parse(Int, line[3])
        rest_time = parse(Int, line[4])
        out = (name, speed, fly_time, rest_time)
        push!(reindeer, out)
    end
    return reindeer
end
@show input = clean_input(file_path)

function solve(input, part::Int=1, limit::Int=2503)
    reindeer = Dict()
    points = Dict()
    s = 0
    while s < limit
        for (name, speed, fly_time, rest_time) in input
            if s % (fly_time + rest_time) < fly_time
                reindeer[name] = get(reindeer, name, 0) + speed
            end
        end
        # find the maximum distance so far
        max_dist = maximum(values(reindeer))
        # find the reindeer that have the maximum distance
        for (name, dist) in reindeer
            if dist == max_dist
                points[name] = get(points, name, 0) + 1
            end
        end
        s += 1
    end
    if part == 1
        return maximum(values(reindeer))
    else
        return maximum(values(points))
    end
    
end
@info solve(input)


@info solve(input, 2)
