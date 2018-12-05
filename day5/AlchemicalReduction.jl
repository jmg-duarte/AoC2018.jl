function collapse!(polymer::AbstractArray{Char})
    for i in 1:(length(polymer) - 1)
        if (polymer[i] == lowercase(polymer[i + 1]) && islowercase(polymer[i]) && isuppercase(polymer[i + 1])) || (polymer[i] == uppercase(polymer[i + 1]) && islowercase(polymer[i + 1]) && isuppercase(polymer[i]))
            # @show (polymer[i], polymer[i+1])
            deleteat!(polymer, i)
            return (deleteat!(polymer, i), true)
        end
    end
    return (polymer, false)
end

function collapse(polymer::String)
    return replace(polymer, r"(aA)|(Aa)|(bB)|(Bb)|(cC)|(Cc)|(dD)|(Dd)|(eE)|(Ee)|(fF)|(Ff)|(gG)|(Gg)|(hH)|(Hh)|(iI)|(Ii)|(jJ)|(Jj)|(kK)|(Kk)|(lL)|(Ll)|(mM)|(Mm)|(nN)|(Nn)|(oO)|(Oo)|(pP)|(Pp)|(qQ)|(Qq)|(rR)|(Rr)|(sS)|(Ss)|(tT)|(Tt)|(uU)|(Uu)|(vV)|(Vv)|(wW)|(Ww)|(xX)|(Xx)|(yY)|(Yy)|(zZ)|(Zz)" => "")
end

function react_naive(polymer::String)
    poly, cont = collapse!(collect(polymer))
    while cont
        # @show index += 1
        poly, cont = collapse!(poly)
    end
    res = chomp(join(poly))
    @show length(res)
    return res
end


function react(polymer::String)
    poly_str = collapse(polymer)
    while poly_str != polymer
        polymer = poly_str
        poly_str = collapse(poly_str)
    end
    res = chomp(poly_str)
    @show length(res)
    return chomp(res)
end

function improve_polymer(polymer::String)
    min = typemax(Int)
    for c in 'a':'z'
        poly = react(replace(polymer, Regex("$c|$(uppercase(c))") => ""))
        if length(poly) < min
            min = length(poly)
        end
    end
    @show min
end

path = "input"
polymer = open(path) do file
    read(file, String)
end

@time improve_polymer(polymer)