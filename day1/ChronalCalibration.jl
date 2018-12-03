function simple(input::String)
    frequency = 0
    open(input) do file
        for line in eachline(file)
            shift = parse(Int, line)
            frequency += shift
            println(frequency)
        end
    end
    return frequency
end

function repeat(input::String)
    s_freq = readlines(input)
    len = length(s_freq)
    i_freq = zeros(Int, len)
    
    for (i, line) in enumerate(s_freq)
        i_freq[i] = parse(Int, line)
    end
    
    freq_set = Set()
    start_freq_value = 0
    i = 0
    while true
        start_freq_value += i_freq[(i % len) + 1]
        i += 1
        if start_freq_value in freq_set
            return start_freq_value
        else
            push!(freq_set, start_freq_value)
        end
    end
end

@show repeat("input")