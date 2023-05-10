# https://adventofcode.com/2019/day/16
using Profile
@profile begin
    file_path = "2019/data/day_16.txt"

    clean_input(file_path::String=file_path)::Vector{Int64} = parse.(Int, split(readline(file_path), ""))
    repeating_pattern(n, length) = repeat(repeat([0, 1, 0, -1], inner=n), length÷(4n) + 1)[2:length+1]
    fft_phase(input) = map(i -> fft(input, i), 1:length(input))

    function fft(input::Vector{Int64}, n::Int) # apply fft_ to each element of input
        pattern = repeating_pattern(n, length(input))
        return abs(sum(input .* pattern) % 10)
    end


    function fft_phases(input::Vector{Int64}, n::Int64)
        for i in 1:n
            input = fft_phase(input)
        end
        return join(input)
    end
    

    # Part 2
    function part_2(input::Vector{Int64}, n)
        offset = parse(Int, join(input[1:7]))
        input = repeat(input, 10000)
        input = input[offset+1:end]
        for i in 1:n
            input = cumsum(input)
            input = map(x -> abs(x % 10), input)
        end
        return join(input[1:8])
    end
    @show parse(Int,fft_phases(clean_input(), 100)[1:8])
    test = fft_phases(clean_input(), 2)
    repeated = repeat(clean_input(),10)
    test2 = fft_phases(repeated, 2)
end
Profile.print()