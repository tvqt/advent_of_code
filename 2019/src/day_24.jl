# https://adventofcode.com/2019/day/24

file_path ="2019/data/day_24.txt"

clean_input(file_path=file_path) = hcat([split(line, "") for line in readlines(file_path)]...) .== "#"

neighbours1(row, col, input=input) = filter(x->x[1] > 0 && x[2] > 0 && x[1] <= size(input, 1) && x[2] <= size(input, 2), [CartesianIndex(row + 1, col), CartesianIndex(row - 1, col), CartesianIndex(row, col + 1), CartesianIndex(row, col - 1)])

living_neighbours(row, col, input) = sum(input[neighbours(row, col, input)])
    
bug_life(row, col, input) = (input[row, col] && (living_neighbours(row, col, input) == 1)) || (!input[row, col] && (living_neighbours(row, col, input) in (1, 2)))

function step(input=input)
    output = copy(input)
    return [output[row, col] = bug_life(row, col, input) for row in 1:size(input, 1), col in 1:size(input, 2)]
end



function biodiversity(input=input) 
    return sum([x ? 2^(i - 1) : 0 for (i, x) in enumerate(reshape(input, :))])
end

function part_1(input=clean_input())
    seen = Set()
    while true
        input = step(input)
        
        bio = biodiversity(input)
        if bio in seen
            return bio
        else
            push!(seen, bio)
        end
    end
end

@show solve()

