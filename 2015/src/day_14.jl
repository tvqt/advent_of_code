# Day 14: Reindeer Olympics
# https://adventofcode.com/2015/day/14

file_path = "2015/data/day_14.txt"
function clean_input(file_path) # read in the file and parse the integers
    reindeer = []
    for line in readlines(file_path)
        line = match(r"(\w+) can fly (\d+) km/s for (\d+) seconds, but then must rest for (\d+) seconds.", line).captures # parse the line
        name = line[1]
        speed = parse(Int, line[2])
        fly_time = parse(Int, line[3])
        rest_time = parse(Int, line[4])
        out = (name, speed, fly_time, rest_time)
        push!(reindeer, out)
    end
    return reindeer # return the array of integers
end
input = clean_input(file_path)

function solve(input, limit::Int=2503)
    reindeer = Dict() # create a dictionary to store the reindeer and their distances
    points = Dict() # create a dictionary to store the reindeer and their points
    s = 0 # create a variable to store the second
    while s < limit # loop through all the seconds
        for (name, speed, fly_time, rest_time) in input # loop through all the reindeer
            if s % (fly_time + rest_time) < fly_time # if the reindeer is flying
                reindeer[name] = get(reindeer, name, 0) + speed # add the speed to the distance
            end
        end
        max_dist = maximum(values(reindeer)) # find the maximum distance so far
        for (name, dist) in reindeer # loop through all the reindeer
            if dist == max_dist # if the distance is the maximum distance
                points[name] = get(points, name, 0) + 1 # add a point to the reindeer
            end
        end
        s += 1 # increment the second
    end
    return maximum(values(reindeer)), maximum(values(points)) # return the maximum distance
end
@info solve(input)