# Day 19: Medicine for Rudolph
# https://adventofcode.com/2015/day/19

file_path = "2015/data/day_19.txt"
file_path2 = "2015/data/day_19_2.txt"

function clean_input(file_path)
    replacements = []
    for line in readlines(file_path)
        from, to = split(line, " => ")
        push!(replacements, (from, to))
    end
    return replacements # return a list of tuples
end
input = clean_input(file_path)
input2 = read(file_path2, String)

function part_1(input, input2)
    molecules = Set() # use a set to avoid duplicates
    for (from, to) in input # loop over the replacements
        for i in eachindex(input2) # loop over the input
            if i + length(from) - 1 > length(input2) # if the index + length(from) -1 is greater than the length of the input,
                continue # skip to the next iteration
            elseif input2[i:i+length(from)-1] == from # if the substring of the input matches the from string
                push!(molecules, input2[1:i-1] * to * input2[i+length(from):end]) # push the new molecule to the set
            end
        end
    end
    return length(molecules) # return the length of the set
end
@show part_1(input, input2)

# I had no luck with Part 2. In a desperate bid for answers, I turned to Reddit for ideas. It turns out the ~intended~ way of solving it is a weird thing about the patterns, which works out to be a relatively simple calculation, shown below. Not entirely sure if I know 100% how this works, but it works, so yeah, whatever (lol)
@show part_2 = length(split(input2, r"(?=[A-Z])")) - length(findall(r"Ar|Rn", input2)) - 2 * length(findall(r"Y", input2))-1
