# Day 17: Spinlock
# https://adventofcode.com/2017/day/17

input = 337

function spinlock_step(state::Vector{Int}, step::Int, new_value::Int)::Vector{Int}
    circshift!(state, -step-1)
    return pushfirst!(state, new_value)
end

function spinlock(step::Int, n::Int)::Vector{Int}
    state = [0]
    for i in 1:n
        state = spinlock_step(state, step, i)
    end
    return state
end

@show spinlock(input, 2017)[2]
p2 =  spinlock(input, 50_000_000)
# get the value after 0
@show p2[findfirst(p2, 0) + 1]
