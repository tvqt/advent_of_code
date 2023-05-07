# Day 19: Go With The Flow
# https://adventofcode.com/2018/day/19

file_path ="2018/data/day_19.txt"
registers = [0, 0, 0, 0, 0, 0]
addr(a, b, c, registers) = (registers[c+1] = registers[a+1] + registers[b+1]; return registers);
addi(a, b, c, registers) = (registers[c+1] = registers[a+1] + b; return registers);
mulr(a, b, c, registers) = (registers[c+1] = registers[a+1] * registers[b+1]; return registers);
muli(a, b, c, registers) = (registers[c+1] = registers[a+1] * b; return registers);
banr(a, b, c, registers) = (registers[c+1] = registers[a+1] & registers[b+1]) ; return registers;
bani(a, b, c, registers) = (registers[c+1] = registers[a+1] & b; return registers);
borr(a, b, c, registers) = (registers[c+1] = registers[a+1] | registers[b+1]; return registers);
bori(a, b, c, registers) = (registers[c+1] = registers[a+1] | b; return registers);
setr(a, b, c, registers) = (registers[c+1] = registers[a+1]; return registers);
seti(a, b, c, registers) = (registers[c+1] = a; registers)
gtir(a, b, c, registers) = (registers[c+1] = a > registers[b+1] ? 1 : 0; return registers);
gtri(a, b, c, registers) = (registers[c+1] = registers[a+1] > b ? 1 : 0; return registers);
gtrr(a, b, c, registers) = (registers[c+1] = registers[a+1] > registers[b+1] ? 1 : 0; return registers);
eqir(a, b, c, registers) = (registers[c+1] = a == registers[b+1] ? 1 : 0; return registers);
eqri(a, b, c, registers) = (registers[c+1] = registers[a+1] == b ? 1 : 0; return registers);
eqrr(a, b, c, registers) = (registers[c+1] = registers[a+1] == registers[b+1] ? 1 : 0; return registers);

function clean_input(f=file_path)
    [(getfield(Main, Symbol(line[1])), parse(Int, line[2]), parse(Int, line[3]), parse(Int, line[4])) for line in split.(readlines(f)[2:end])]
end


function run_machine(part2=false, input = clean_input(), registers=registers)
    ip_register = parse(Int, readline(file_path)[end])
    ip = 0
    registers[1] = part2 ? 1 : 0
    while ip < length(input)
        if ip == 7
            println("ip: $ip, $registers")
        end
        println("$registers, $ip, $(input[ip+1])")
        registers = input[ip+1][1](input[ip+1][2], input[ip+1][3], input[ip+1][4], registers)
        registers[ip_register + 1] += 1
        ip = registers[ip_register+1] 
    end
    registers[ip_register+1] -= 1
    return registers[1]
end
# the first part just finds the sum of the factors of the number in register 2
#for me, that was 892
# for the second part, it does a lot more multiplication to the number in register 2, but still carries out the same process to the multiplied number

function solve(n)
    sum([i for i in 1:n if n % i == 0])
end
@show solve(892)
@show solve(10551292)

# input decoded
a = 1
#jump to chunk one

# chunk two
e = 1
b times
    c = 1
    b times
        if e*c == b
            a += e
        end
        c += 1
    end
    e += 11
end
i *= i

# chunk one
d = 22d + 56
b = 209b^2 + 836b + 836 + d

if part 1
    # jump to chunk two
elseif part 2
    # jump to chunk three

# chunk three
d = i
d *= i
d += i
d *= i
d *= 14
d *= i
b += d
a = 0
i = 0
