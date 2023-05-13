# Day 2: Bathroom Security
# https://adventofcode.com/2016/day/2

using DelimitedFiles

file_path = "2016/data/day_2.txt"
input = readdlm(file_path, String)

function part_1(input)
    current_position = 5 
    bathroom_code = ""
    for line in input
        for char in line
            if char == 'U' && current_position > 3 # if it asks to move up and we're not on the top row
                current_position = current_position - 3 # move up
            elseif char == 'D' && current_position < 7 # if it asks to move down and we're not on the bottom row
                current_position = current_position + 3 # move down
            elseif char == 'L' && current_position != 1 && current_position != 4 && current_position != 7 # if it asks to move left and we're not on the left column
                current_position = current_position - 1 # move left
            elseif char == 'R' && current_position != 3 && current_position != 6 && current_position != 9 # if it asks to move right and we're not on the right column
                current_position = current_position + 1 # move right
            end
        end
        bathroom_code *= string(current_position) # add the number to the code
    end
    return bathroom_code # return the code
end

function part_2(input)
    current_position = 5 # start at 5 again
    bathroom_code = ""
    for line in input
        for char in line # this part is a bit of a mess to read because, well, it's the rules are a mess, and I can't really do anything about that sorry!! 
            if char == 'U' # if it asks to move up
                if current_position == 3 
                    current_position -= 2
                elseif current_position in 6:8
                    current_position -= 4
                elseif current_position in 10:12
                    current_position -= 4
                elseif current_position == 13
                    current_position -= 2
                end
            elseif char == 'D' # if it asks to move down
                if current_position == 1
                    current_position += 2
                elseif current_position in 2:4
                    current_position += 4
                elseif current_position in 6:8
                    current_position += 4
                elseif current_position == 11
                    current_position += 2
                end
            elseif char == 'L' # if it asks to move left
                if current_position in [3, 4, 6, 7, 8, 9, 11, 12]
                    current_position -= 1
                end
            elseif char == 'R' # if it asks to move right
                if current_position in [2, 3, 5, 6, 7, 8, 10, 11]
                current_position += 1
                end
            end
        end
        if current_position == 10 # convert the number to the correct letter
            bathroom_code *= 'A'
        elseif current_position == 11 # 
            bathroom_code *= 'B'
        elseif current_position == 12
            bathroom_code *= 'C'
        elseif current_position == 13
            bathroom_code *= 'D'
        else
            bathroom_code *= string(current_position)
        end
    end
    return bathroom_code # return the code
end

@show part_1(input)
@show part_2(input)
