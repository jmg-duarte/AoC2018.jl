CLAIM_REGEX = r"#([0-9]+)\s@\s([0-9]+),([0-9]+):\s([0-9]+)x([0-9]+)"

function load_fabric_set(path::String)
    claims = Array{Tuple{Int, Int, Int, Int}, 1}()
    fabric = [Int[] for i = 1:1000, j = 1:1000]

    open(path) do file
        for line in eachline(file)
            m = match(CLAIM_REGEX, line)
            id = parse(Int, m[1])
            x = parse(Int, m[2]) + 1
            y = parse(Int, m[3]) + 1
            width = parse(Int, m[4])
            height = parse(Int, m[5])

            push!(claims, (x, y, width, height))

            for i in x:(x + width - 1)
                for j in y:(y + height - 1)
                    push!(fabric[j,i], id)
                end
            end
        end
    end

    #@show length(claims)
    @show count(x->length(x) > 1, fabric)
    
    for (i, c) in enumerate(claims)
        x, y, w, h = c
        count = w * h
        for i in x:(x+w-1)
            for j in y:(y+h-1)
                if length(fabric[j, i]) == 1
                    count -= 1
                end
            end
        end
        if count == 0
            @show i, c
            break
        end
    end
    
    return fabric
end

load_fabric_set("input")