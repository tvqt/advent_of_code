# https://adventofcode.com/2016/day/6
using StatsBase
file_path = "2016/data/day_6.txt"

function part_1(file_path::String)
    line_length = length(readlines(file_path)[1])
    return join([(findmax(countmap(join([x[i] for x in readlines(file_path)])))[2]) for i in 1:line_length])
end

function part_2(file_path::String)
    line_length = length(readlines(file_path)[1])
    return join([(findmin(countmap(join([x[i] for x in readlines(file_path)])))[2]) for i in 1:line_length])
end
@info part_1(file_path)

@info part_2(file_path)
