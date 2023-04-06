# https://adventofcode.com/2020/day/13
earliest_time = 1002392
file_path = "2020/data/day_13.txt"
input = [parse(Int, n) for n in (filter(x -> x != "x", split(read(file_path, String), ",")))]
@show input
# filter out the "x"s

function part_1(input)
    for i in earliest_time:earliest_time+maximum(input)
        for bus in input
            if i % bus == 0
                return bus * (i - earliest_time)
            end
        end
    end
end
@show part_1(input)

function solve(file_path=file_path)
    input = split(read(file_path, String), ",")
    # Initialize variables
    timestamp = 0
    lcm = 1

    # Iterate over each bus id and its offset
    for (offset, bus_id) in enumerate(input)
        if bus_id == "x"
            continue
        end

        # Find the next timestamp that satisfies the current bus id's constraints
        while (timestamp + offset) % parse(Int, bus_id) != 0
            timestamp += lcm
        end

        # Update the least common multiple of the bus ids seen so far
        lcm = lcm * parse(Int, bus_id) ÷ gcd(lcm, parse(Int, bus_id))
    end

    return timestamp
end

function solve_buses(buses::Vector{Union{Int,Nothing}}, congruences::Vector{Tuple{Int,Int}})::Int
    # Compute the product of all the bus IDs
    M = prod([b for b in buses if b != "x"])
    
    # Compute the solution using the Chinese Remainder Theorem
    t = 0
    for (offset, bus_id) in congruences
        if bus_id == nothing
            continue
        end
        r = -offset % bus_id
        Mi = M ÷ bus_id
        ti = invmod(Mi, bus_id)
        t += r * Mi * ti
    end
    return t % M
    end
    
    

@show BigInt(solve(file_path))
