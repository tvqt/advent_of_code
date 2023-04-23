# https://adventofcode.com/2021/day/18
using JSON
input = JSON.parse.(readlines("2021/data/day_18.txt"))

snailfish_add(a, b) = [a, b]
function snailfish_reduce(num, depth=0)
    if length(num) == 2 && typeof(num[1]) == Int && typeof(num[2]) == Int # pair!
        if depth == 4 
            return true, "explode!"
        end
    end
    ten_or_greater = findall(x -> x >= 10, num)
    for i in ten_or_greater
        return true, "split!"
    end
    if typeof(num[1]) != Int
        keep_going, num[1], left, right = snailfish_reduce(num[1], depth+1)
        return keep_going, num
    end
    return false, num
end

function traverse(pairs)
    keep_going = true
    while keep_going
        keep_going, val = snailfish_reduce(pairs)
    end
end

