# https://adventofcode.com/2020/day/10
file_path = "2020/data/day_10.txt"
input = sort([parse(Int, x) for x in readlines(file_path)])
@show (input)

function part_1(input=input)
    joltage = 0
    one_diff = 0
    three_diff = 0
    for i in input
        diff = i - joltage
        if diff == 1
            one_diff += 1
        elseif diff == 3
            three_diff += 1
        end
        joltage = i
    end
    three_diff += 1
    return one_diff * three_diff

end
@info part_1(input)

function part_2(input=input)
    input = [0; input; maximum(input) + 3]
    n = length(input)
    dp = zeros(Int, n)
    dp[1] = 1
    for i in 2:n
        for j in 1:i-1
            if input[i] - input[j] <= 3
                dp[i] += dp[j]
            end
        end
    end
    return dp[n]
end
@show part_2(input)

