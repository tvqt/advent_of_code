# https://adventofcode.com/2017/day/15

A = 591
B = 393

function judge(A, B, n, part=1)
    count = 0
    for i in 1:n
        A = next_factor(A, 'A', part)
        B = next_factor(B, 'B', part)
        if A % 65536 == B % 65536
            count += 1
        end
    end
    return count
end


function next_factor(factor, generator, part=1)
    nf(f, g) = generator == 'A' ? (16807 * f) % 2147483647 : (48271 * f) % 2147483647
    modulus = generator == 'A' ? 4 : 8
    factor = nf(factor, generator)

    if part == 2
        while factor % modulus != 0
            factor = nf(factor, generator)
        end
    end
    return factor
end

@show judge(A, B, 40000000)
@show judge(A, B, 5000000, 2)