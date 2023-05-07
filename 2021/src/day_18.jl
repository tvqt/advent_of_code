# https://adventofcode.com/2021/day/18
using Combinatorics
input = readlines("2021/data/day_18.txt")

snailfish_add(a, b) = "[$a,$b]"

function prev_and_next(num)
    prev = findall(r"\d+", num[1])
    length(prev) == 0 ? (nothing, findfirst(r"\d+", num[3])) : (prev[end], findfirst(r"\d+", num[3]))
end

function snailfish_change(num, index, n)
    if index === nothing
        return num
    end
    num, o = join([num[1:index[1]-1], num[index[end]+1:end]]), parse(Int, num[index])
    o += n
    return join([num[1:index[1]-1], string(o), num[index[1]:end]])
end


find_depth(num, index) = count(x->x == '[', num[1:index]) - count(x->x == ']', num[1:index])

function snailfish_reduce(num)
    while true
        pairs = findall(r"(\d+),(\d+)", num)
        if isempty(pairs) 
            return snailfish_split(num)
        end
        for p in pairs
            depth = find_depth(num, p[1])
            if depth > 4
                a, b = parse.(Int, split(num[p], ","))
                num = [num[1:p[1]-2], num[p], num[p[end]+2:end]]
                prev_ind, next_ind = prev_and_next(num)
                num[1] = snailfish_change(num[1], prev_ind, a)
                num[3] = snailfish_change(num[3], next_ind, b)
                num = join([num[1], "0", num[3]])
                break
            end
            if p == pairs[end]
                return snailfish_split(num)
            end
        end
    end
end

function snailfish_split(num)
    two_digit_nums = findall(r"(\d\d+)(?=[,\]])", num)
    if isempty(two_digit_nums)
        return num
    end
    n = parse(Int, num[two_digit_nums[1]])
    n = "[$(convert(Int, floor(n/2))),$(convert(Int, ceil(n/2)))]"
    num = [num[1:two_digit_nums[1][1]-1], num[two_digit_nums[1][end]+1:end]]

    num = join([num[1], n, num[2]])
    if count(x->x == '[', num) != count(x->x == ']', num)
        throw(DomainError("Unbalanced brackets"))
    end
    return snailfish_reduce(num)
end

function snailfish_sum(input)
    sum = input[1]
    for i in input[2:end]
        sum = snailfish_reduce(snailfish_add(sum, i))
        println(sum)
    end
    return snailfish_magnitude(sum)
end

function snailfish_magnitude(num)
    while true
        p = findfirst(r"(\d+),(\d+)", num)
        if p === nothing
            return parse(Int, num)
        end
        a, b = parse.(Int, split(num[p], ","))  
        num = [num[1:p[1]-2], num[p[end]+2:end]]
        num = join([num[1], (a*3)+ (b*2), num[2]])
    end
end
@show snailfish_sum(input)

function part_2(input)
    best = 0
    snailfish_combs = combinations(input, 2)
    for i in snailfish_combs
        best = max(best, snailfish_magnitude(snailfish_reduce(snailfish_add(i[1], i[2]))))
        best = max(best, snailfish_magnitude(snailfish_reduce(snailfish_add(i[2], i[1]))))
    end
    return best
end

@show part_2(input)  
