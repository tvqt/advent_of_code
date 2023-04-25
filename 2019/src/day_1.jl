# https://adventofcode.com/2019/day/1
# Day 1: The Tyranny of the Rocket Equation    

input = readlines("2019/data/day_1.txt")
@show typeof(input)

function part_1(input::Vector{String})::BigInt
    sum(floor(parse(Int, input[i])/3)-2 for i in eachindex(input))
end
@show part_1(input)

function part_2(input::Vector{String})::BigInt
    fuel_total = 0
    for module_ in input
        marginal_fuel = floor(parse(Int, module_)/3)-2
        module_total = 0
        while marginal_fuel > 0
            module_total += marginal_fuel
            marginal_fuel = floor(marginal_fuel/3)-2
        end
        println("a module of mass $(module_) requires $(module_total) fuel")
        fuel_total += module_total
    end

    return fuel_total
end
@show part_2(input)
