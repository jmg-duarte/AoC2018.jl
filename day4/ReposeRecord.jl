using Dates

TIMESTAMP_REGEX = r"(\[(\d{4})-(\d{2})-(\d{2})\s(\d{2}):(\d{2})\])\s(Guard #(\d+).*|(falls asleep)|(wakes up))"

function count_elements(arr::AbstractArray)
    elems = Dict()
    for elem in arr
        if get(elems, elem, -1) == -1
            elems[elem] = 1
        else
            elems[elem] += 1
        end
    end
    return elems
end

open("input") do file
    log = sort(collect(eachline(file)))

    naps = Dict{String,Int}()
    minutes = Dict{String,AbstractArray{Int,1}}()

    current_guard = nothing
    asleep = 0
    for line in log
        m = match(TIMESTAMP_REGEX, line)
        if m[8] != nothing
            current_guard = m[8]
        elseif m[9] != nothing
            asleep = parse(Int, m[6])
        else m[10] != nothing
            awake = parse(Int, m[6])
            nap_time = awake - asleep
            
            if get(naps, current_guard, -1) == -1
                naps[current_guard] = nap_time
            else
                naps[current_guard] += nap_time
            end

            mins = collect(asleep:(awake-1))
            if get(minutes, current_guard, -1) == -1
                minutes[current_guard] = zeros(60)
            else
                for i in asleep:(awake-1)
                    minutes[current_guard][i+1] += 1
                end
            end
        end
    end

    sleepy_guard = findmax(naps)
    @show sleepy_guard
    glist = []
    mlist = []
    for (k, v) in minutes
        push!(glist, k)
        push!(mlist, v)
    end

    minute_matrix = [mlist[idx][min] for idx in 1:length(mlist), min in 1:60]
    @show size(minute_matrix)
    @show sleeper = findmax(minute_matrix)
    # -1 because o-59 doesnt map to Julia array indexing
    @show (sleeper[2][2]-1) * parse(Int, glist[sleeper[2][1]])
end