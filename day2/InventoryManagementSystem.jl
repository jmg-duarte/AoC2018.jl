function count_repetitions(str::String)
    repetitions = Dict{Char,Integer}()
    for char in collect(str)
        if haskey(repetitions, char)
            repetitions[char] += 1
        else
            repetitions[char] = 1
        end
    end    
    return repetitions
end

function count_repetitions(arr::Array)
    repetitions = Dict{Char,Integer}()
    for char in arr
        if haskey(repetitions, char)
            repetitions[char] += 1
        else
            repetitions[char] = 1
        end
    end    
    return repetitions
end

function sum_repetitions(input::Dict{Char,Integer})
    res = zeros(Integer, 3)
    for (k, v) in input
        res[v] += 1
    end
    return res
end

function compare(s1::String, s2::String)
    res = []
    for (c1, c2) in zip(s1, s2)
        if c1 == c2 
            push!(res, c1)
        end
    end
    return res
end

function checksum(path::String)
    open(path) do file
        two_c = 0
        three_c = 0
        for line in eachline(file)
            rep_dict = count_repetitions(line)
            sum = sum_repetitions(rep_dict)
            
            if sum[2] > 0 
                two_c += 1
            end
    
            if sum[3] > 0
                three_c += 1
            end
    
        end
        # @show two_c * three_c
        return two_c * three_c
    end
end

function matcher(path::String)
    lines = []
    open(path) do file
        for line in eachline(file)
            push!(lines, line)
        end
    end

    pairs = []
    @time for i in 1:length(lines)
        for j in i:length(lines)
            l1 = lines[i]
            l2 = lines[j]

            eq = join(compare(l1, l2))

            if length(eq) == (length(l1) - 1) 
                push!(pairs, eq)
            end
        end
    end

    @show pairs
    return lines
end

matcher("input")

