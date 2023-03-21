# Day 20: Infinite Elves and Infinite Houses
# https://adventofcode.com/2015/day/20

using Primes

input = 36000000 # input

function factors(n::Int, part::Int=1)::Int # function to calculate the factors of a number
    factors = Set()
    for i in 1:ceil(sqrt(n))
        if n % i == 0
            push!(factors, i)
            push!(factors, n/i)
        end
    end
    if part == 2
        factors = filter(x -> x >= n/50, factors) # filter out factors which are less than 50
        return sum(factors)*11 # return the sum of the factors multiplied by 11
    else # part 1
        return sum(factors)*10 # return the sum of the factors multiplied by 10
    end
end

function part_1(input)
    house_number = 0
    presents = 0
    while presents < input # loop until the number of presents is greater than the input
        house_number += 1 # increment the house number
        presents = factors(house_number) # get the number of presents for the current house number
    end
    return house_number # return the house number
end
@show part_1(input)

function part_2(input)
    house_number = 0
    presents = 0
    while presents < input # loop until the number of presents is greater than the input
        house_number += 1 # increment the house number
        presents = factors(house_number, 2) # get the number of presents for the current house number
    end
    return house_number # return the house number
end
@show part_2(input)


