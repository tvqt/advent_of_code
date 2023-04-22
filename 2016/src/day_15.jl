# Day 15: Timing is Everything
# https://adventofcode.com/2016/day/15

# I don't know if I totally totally understand this one, but hey, it works! Shout out to Reddit for helping me with this one. 

using Nemo

file_path = "2016/data/day_15.txt"

function clean_input(file_path=file_path)
    nums = Array{Int, 1}()
    rems = Array{Int, 1}()
    for line in readlines(file_path)
        disc, num, rem = match(r"Disc #(\d+) has (\d+) positions; at time=0, it is at position (\d+).", line).captures
        push!(nums, parse(Int, num))
        push!(rems, parse(Int, rem))
    end
    return nums, rems
end

nums, rems = clean_input()
rems = -rems - collect(1:length(nums))
@show crt(rems[1:end-1], nums[1:end-1])
@show crt(rems, nums)