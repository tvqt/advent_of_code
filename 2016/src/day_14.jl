# Day 14: One-Time Pad
# https://adventofcode.com/2016/day/14

using MD5
input = "jlmsuwbz"

hashes = Dict() # cache hashes
stretch_hashes = Dict() # cache stretched hashes

function hash!(n::Int, hashes=hashes, input=input)::String # returns a hash
    if haskey(hashes, n)
        return hashes[n]
    end
    h = bytes2hex(md5(input * string(n)))
    hashes[n] = h
    return h
end


function stretch_hash!(n::Int, stretch_hashes=stretch_hashes, limit=2016)::String # returns a stretched hash
    if haskey(stretch_hashes, n)
        return stretch_hashes[n]
    end
    h = hash!(n)
    for i in 1:limit
        h = bytes2hex(md5(h))
    end
    stretch_hashes[n] = h
    return h
end

function find_triplet(h::String)::Tuple # checks if there's a triple repeating character in a hash e.g. 'aaa'
    for i in 1:length(h)-2
        if h[i] == h[i+1] == h[i+2]
            return true, h[i]
        end
    end
    return false, nothing
end

function find_quintet(h::String,c::Char)::Bool # as above, but with a quintet e.g. 'aaaaa'
    for i in 1:length(h)-4
        if c == h[i] == h[i+1] == h[i+2] == h[i+3] == h[i+4]
            return true
        end
    end
    return false
end

function check_stream(n::Int, c::Char, stretch=false, hashes=hashes, stretch_hashes=stretch_hashes ) # checks the next 1000 hashes for a quintet
    for i in n+1:n+1001
        h = stretch ? stretch_hash!(i) : hash!(i)
        if find_quintet(h, c)
            return i
        end
    end
    return nothing
end

function solve(stretch=false, n=64, hashes=hashes, stretch_hashes=stretch_hashes)::Int # solves both parts
    keys = []
    i = 0
    while length(keys) < n
        i += 1
        h = stretch ? stretch_hash!(i) : hash!(i)
        found, c = find_triplet(h)
        if found
            if check_stream(i, c, stretch) !== nothing
                push!(keys, i)
            end
        end
    end
    return keys[end]
end
@show solve()
@show solve(true)