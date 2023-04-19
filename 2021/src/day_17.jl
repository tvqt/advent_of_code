# https://adventofcode.com/2021/day/17
file_path = "2021/data/day_17.txt"
min_x, max_x, min_y, max_y = parse.(Int, match(r"target area: x=(\d+)..(\d+), y=(-?\d+)..(-?\d+)", readline(file_path)).captures)

@show p1 = (-min_y + 1)* ((-min_y + 1)+1) ÷ 2   