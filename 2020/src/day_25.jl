# Day 25: Combo Breaker
# https://adventofcode.com/2020/day/25

card, door = 12320657, 9659666

transformation(value, subject_number) = subject_number * value % 20201227

function handshake(subject_number, loop_size)
    value = 1
    for _ in 1:loop_size
        value = transformation(value, subject_number)
    end
    return value
end

function part_1(a, b)
    loop_size, value, subject_number = 1, 1, 7
    while true
        value = transformation(value, subject_number)
        value == a  && return handshake(b, loop_size)
        loop_size += 1
    end
end

@show part_1(card, door)