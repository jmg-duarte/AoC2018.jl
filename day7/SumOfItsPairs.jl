using DataStructures

STEP_REGEX = r".*\s([A-Z])\s.*\s([A-Z])\s.*"

function flatten_to_set(arr::AbstractArray{AbstractArray{N,1},1}) where N
    s = Set()
    for a in arr
        for elem in a
            push!(s, elem)
        end
    end 
    return s
end

function findfirst(arr::AbstractArray{String,1}, elem::String)
    for (i, v) in enumerate(arr)
        if isequal(v, elem)
            return i
        end
    end
    return -1
end


function load_deps(path::String)
    successors = Dict{Char,AbstractArray{String,1}}()
    ancestors = Dict{Char,Int}()

    open(path) do file
        for line in eachline(file)
            m = match(STEP_REGEX, line)
            
            if get(successors, m[1], -1) == -1
                successors[m[1]] = [m[2]]
            else
                push!(successors[m[1]], m[2])
            end

            if get(ancestors, m[2], -1) == -1
                ancestors[m[2]] = 1
            else
                ancestors[m[2]] += 1  
            end
        end
    end

    @show ancestors 

    for (k, v) in successors
        sort!(v)
    end
    
    zero = []
    start = [v for v in setdiff(Set(collect(keys(successors))), Set(collect(keys(ancestors))))]
    time = 0
    while !isempty(start)
        sort!(start)
        current_node = popfirst!(start)
        push!(zero, current_node)

        if get(successors, current_node, -1) != -1
            while !isempty(successors[current_node])
                next_node = popfirst!(successors[current_node])
                ancestors[next_node] -= 1
                if ancestors[next_node] == 0
                    push!(start, next_node)
                end
            end
        end
        time += 1
    end
    
    @show join(zero)

    done = []

    return zero
end

function load_deps2(path::String)
    times = Dict(zip([c for c in 'A':'Z'], [60 + i for i in 0:25]))
    lines = []
    steps = Set()

    open(path) do file
        for line in eachline(file)
            m = match(STEP_REGEX, line)
            push!(lines, (m[1], m[2]))

            push!(steps, m[1])
            push!(steps, m[2])
        end
    end

    @show steps

    t = 0
    workers = [0 for _ in 1:5]
    work = ["_nothing" for _ in 1:5]
    while !isempty(steps) || any([w > 0 for w in workers])
        candidate = [s for s in steps if all([b != s for (_, b) in lines])]
        sort!(candidate)

        for i in 1:5
            workers[i] = max(workers[i] - 1, 0)
            if workers[i] == 0
                # @show i, work[i]
                if work[i] != "_nothing"
                    lines = [(a, b) for (a, b) in lines if a != work[i]]
                end

                if !isempty(candidate)
                    n = popfirst!(candidate)
                    workers[i] = times[n[1]]
                    work[i] = n
                    delete!(steps, n)
                end
            end
        end
        t += 1
    
    end
    @show t

end

load_deps2("input")