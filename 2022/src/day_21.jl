# https://adventofcode.com/2022/day/21

file_path = "2022/data/day_21.txt"
function clean_input(file_path=file_path)
    good = Dict()
    bad = Dict()
    for line in readlines(file_path)
        variable, values_ = match(r"(.+): (.+)", line).captures
        if length(split(values_)) == 1
            good[variable] = parse(Int, values_)
        else
            bad[variable] = split(values_)
        end
    end
    return good, bad
end

good, bad = clean_input()

function get_value(value="root", humn=nothing, good=copy(good), bad=copy(bad))
    if humn !== nothing
        good["humn"] = humn
    end
    if value in keys(good)
        return good[value]
    else
        values = [get_value(v, nothing, good, bad) for v in [bad[value][1], bad[value][3]]]
        if bad[value][2] == "*"
            return values[1] * values[2]
        elseif bad[value][2] == "+"
            return values[1] + values[2]
        elseif bad[value][2] == "-"
            return values[1] - values[2]
        elseif bad[value][2] == "/"
            return values[1] / values[2]
        end
    end
end

function part_2()
    cgdh, qhpl, diff = 0, 1, 10000000000000
    humn, step = 0, 10000000000000

    while cgdh != qhpl
        humn += step
        cgdh = get_value("cgdh", humn)
        qhpl = get_value("qhpl", humn)
        new_diff = max(cgdh, qhpl) - min(cgdh, qhpl)
        if  new_diff > diff
            step = floor(-step / 10)
            humn -= step
        end
        diff = new_diff
    end
    return BigInt(humn)
end
@show part_2()