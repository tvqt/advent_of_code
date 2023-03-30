# Day 8: Two-Factor Authentication
# https://adventofcode.com/2016/day/8

file_path = "2016/data/day_8.txt"

function clean_input(file_path)
    out = []
    for line in readlines(file_path)
        line = split(line, " ")
        if line[1] == "rect"
            rect_int = split(line[2], "x")
            rect_val = (parse(Int, rect_int[1]), parse(Int, rect_int[2]))
            push!(out, ("rect", rect_val[1], rect_val[2]))
        elseif line[1] == "rotate"
            #rotate row y=3 by 27
            rotate_int = split(line[3], "=")
            rotate_index = parse(Int, rotate_int[2])
            rotate_val = parse(Int, line[5])
            push!(out, ("rotate", line[2], rotate_index, rotate_val))
        end
    end
    return out
end

input = clean_input(file_path)

function solve(input, nrow, ncol)
    screen = zeros(Bool, nrow, ncol)
    function rect(screen, x, y)
        for y_i in 1:y
            for x_i in 1:x
                screen[x_i, y_i] = true
            end
        end
        return screen
    end

    function rotate_col(screen, rotated_row, rotated_amount)
        row = screen[rotated_row+1, :]
        row = circshift(row, rotated_amount)
        screen[rotated_row+1, :] = row
        return screen
    end

    function rotate_row(screen, rotated_col, rotated_amount)
        col = screen[:, rotated_col+1]
        col = circshift(col, rotated_amount)
        screen[:, rotated_col+1] = col
        return screen
    end
    
    for (command, args...) in input
        if command == "rect"
            screen = rect(screen, args[1], args[2])
        elseif command == "rotate"
            if args[1] == "row"
                screen = rotate_row(screen, args[2], args[3])
            elseif args[1] == "column"
                screen = rotate_col(screen, args[2], args[3])
            end
        end
    end
    
    return sum(screen), transpose(screen)
end

emoji_replace(x) = x ? "⬛️" : "⬜️"

function print_screen(screen)
    for row in 1:size(screen, 1)
        for col in 1:size(screen, 2)
            print(emoji_replace(screen[row, col]))
        end
        println()
    end
end

p1, p2 = solve(input, 50, 6)
@show p1
print_screen(p2)