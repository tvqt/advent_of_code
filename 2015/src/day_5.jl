# https://adventofcode.com/2015/day/5
# Day 5: Doesn't He Have Intern-Elves For This? 


input = readlines("2015/data/day_5.txt")

function check_repeating_letters(s::String, n::Int)::Bool
    # check if there are n repeating letters in a row
    current_count = 1
    max_count = 1
    current_char = s[1]

    for i in 2:length(s) # start at 2 because we already checked the first character
        if s[i] == current_char
            current_count += 1
        else
            if current_count > max_count
                max_count = current_count
            end
            current_char = s[i]
            current_count = 1
        end
    end

    if current_count > max_count
        max_count = current_count
    end

    return max_count >= n
end

# function which returns the largest number of repeating letters


function part_1(input)
    function three_vowels(s::String)::Bool # check if there are at least 3 vowels
        vowels = ['a', 'e', 'i', 'o', 'u']
        vowel_count = 0
        for i in s
            if i ∈ vowels
                vowel_count += 1
            end
        end
        return vowel_count >= 3
    end

    function no_bad_strings(s::String)::Bool # check if there are any bad strings
        bad_strings = ["ab", "cd", "pq", "xy"]
        for i in bad_strings
            if occursin(i, s)
                return false
            end
        end
        return true
    end
    count1 = 0
    for i in eachindex(input) # check if the string has at least 3 vowels, at least 1 letter that repeats twice in a row, and no bad strings
        if three_vowels(input[i]) && check_repeating_letters(input[i], 2) && no_bad_strings(input[i])
            count1 += 1 # if all conditions are met, increment the counter
        end
    end
return count1 # return the number of strings that meet the conditions
end
@show part_1(input)


function part_2(input) # check if there is a pair of letters that repeats, and if there is a letter that repeats with a letter in between
    count2 = 0
    function patterns(s::String) # check if there is a pair of letters that repeats
        for i in 1:length(s)-2
            if occursin(s[i:i+1], s[i+2:end]) || occursin(reverse(s[i:i+1]), s[i+2:end])
                return true
            end
        end
        return false
    end

    function repeating_between_letter(s::String) # check if there is a letter that repeats with a letter in between
        match_vals = match(r"(.)(.)\1", s)
        return !isnothing(match_vals)
    end

    for i in eachindex(input) # check if the string has a pair of letters that repeats, and if there is a letter that repeats with a letter in between
        group_val = check_repeating_letters(input[i], 2) || patterns(input[i])
        if repeating_between_letter(input[i]) && group_val && !check_repeating_letters(input[i], 3)
            count2 += 1
        end
    end
    return count2 # return the number of strings that meet the conditions
end
@show (part_2(input))
