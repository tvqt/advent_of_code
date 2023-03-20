# https://adventofcode.com/2015/day/19

file_path = "2015/data/day_19.txt"
file_path2 = "2015/data/day_19_2.txt"
function clean_input(file_path)
    replacements = []
    for line in readlines(file_path)
        from, to = split(line, " => ")
        push!(replacements, (from, to))
    end
    return replacements
end
input = clean_input(file_path)
input2 = read(file_path2, String)

function part_1(input, input2)
    molecules = Set()
    for (from, to) in input
        for i in 1:length(input2)
            if i + length(from) - 1 > length(input2)
                continue
            elseif input2[i:i+length(from)-1] == from
                push!(molecules, input2[1:i-1] * to * input2[i+length(from):end])
            end
        end
    end
    return length(molecules)
end
@show part_1(input, input2)

# I had no luck with Part 2. In a desperate bid for answers, I turned to Reddit for ideas. It turns out the ~intended~ way of solving it is a weird thing about the patterns, which works out to be a relatively simple calculation, shown below. Not entirely sure if I know 100% how this works, but it works, so hey (lol)
@show part_2 = length(split(input2, r"(?=[A-Z])")) - length(findall(r"Ar|Rn", input2)) - 2 * length(findall(r"Y", input2))-1
