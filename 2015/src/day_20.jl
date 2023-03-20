# https://adventofcode.com/2015/day/20
using Primes
input = 36000000

function factors(n::Int, part::Int=1)::Int
    factors = Set()
    if n == 4000
        println("here")
    end
    for i in 1:ceil(sqrt(n))
        if n % i == 0
            push!(factors, i)
            push!(factors, n/i)
        end
    end
    if part == 2
        factors = filter(x -> x >= n/50, factors)
        return sum(factors)*11
    else
        return sum(factors)*10
    end
end
@show factors(10)

function part_1(input)
    # create a dictionary with keys from 1 to limit, with values 
    house_number = 0
    presents = 0
    while presents < input
        house_number += 1
        presents = factors(house_number)
    end
    return house_number
end
#@info part_1(input)

function part_2(input)
    # create a dictionary with keys from 1 to limit, with values 
    house_number = 0
    presents = 0
    while presents < input
        house_number += 1
        presents = factors(house_number, 2)
    end
    return house_number
end
@info part_2(input)


