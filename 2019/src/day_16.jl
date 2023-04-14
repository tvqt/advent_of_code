# https://adventofcode.com/2019/day/16
file_path = "2019/data/day_16.txt"

clean_input(file_path=file_path) = parse.(Int, split(readline(file_path), ""))

repeating_pattern(n, length) = repeat(repeat([0, 1, 0, -1], inner=n), length÷(4n) + 1)[2:length+1]

test = [1,2,3,4,5,6,7,8]
function fft(input, n) # apply fft_ to each element of input
    pattern = repeating_pattern(n, length(input))
    return abs(sum(input .* pattern) % 10)
end

fft_phase(input) = map(i -> fft(input, i), 1:length(input))

function fft_phases(input, n)
    for i in 1:n
        input = fft_phase(input)
    end
    return join(input)
end
 
@show fft_phases(clean_input(), 100)[1:8]

# Part 2
function part_2(input, n)
    offset = parse(Int, join(input[1:7]))
    input = repeat(input, 10000)
    input = input[offset+1:end]
    for i in 1:n
        input = cumsum(input)
        input = map(x -> abs(x % 10), input)
    end
    return join(input[1:8])
end
@show part_2(clean_input(), 100)

