# Day 17: Spinlock
# https://adventofcode.com/2017/day/17

input = 337

function spinlock_step(state::Vector{Int}, step::Int, new_value::Int)::Vector{Int}
    circshift!(state, -step-1)
    return pushfirst!(state, new_value)
end

function spinlock(step::Int, n::Int)::Vector{Int}
    state = [0]
    old = 0
    position = 1
    for i in 1:n
        state = spinlock_step(state, step, i)
    end
    return state
end

function part_2(step::Int, n::Int)::Int
    next_to_zero = 1
    position = 1
    len= 2
    for i in 1:n
        position = mod1(position + step, i) + 1
        if position == 2
            next_to_zero = i
        end
    end
    return next_to_zero
end

@show spinlock(input, 2017)[2]
p2 =  part_2(input, 50_000_000)
# get the value after 0
@show p2
