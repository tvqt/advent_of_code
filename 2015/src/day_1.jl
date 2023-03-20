# https://adventofcode.com/2015/day/1
# Day 1: Not Quite Lisp

input = read("2015/data/day_1.txt", String)

function part_1(input)
    # get the number of matches for each character, and subtract the number of ) from the number of (
    return length(findall("(", input)) - length(findall(")", input))
end
@info part_1(input)

function part_2(input)
    # initialise the level at 0
    level = 0
    for (i, c) in enumerate(input)
        # loop through the string, and add 1 to the level if we see a (, and subtract 1 if we see a )
        if c == '('
            level += 1
        elseif c == ')'
            level -= 1
        end
        # if the level is -1, we've reached the basement, so return the index
        if level == -1
            return i
        end
    end
end
@info part_2(input)
