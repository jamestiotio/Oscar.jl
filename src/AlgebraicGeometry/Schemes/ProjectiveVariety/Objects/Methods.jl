########################################################
# (1) Display
########################################################

# detailed printing
function Base.show(io::IO, ::MIME"text/plain", X::AbsProjectiveVariety{<:Field,<:MPolyQuoRing})
    io = pretty(io)
    println(io, "Projective variety")
    print(io, Indent(), "in ")
    println(io, Lowercase(), ambient_space(X))
    print(io, Dedent(), "defined by ")
    print(io, Lowercase(), defining_ideal(X))
end

# one line printing
function Base.show(io::IO, X::AbsProjectiveVariety{<:Field,<:MPolyQuoRing})
  if get(io, :supercompact, false)
    print(io, "Scheme")
  elseif get_attribute(X, :is_empty, false)
    print(io, "Empty projective variety")
  else
    print(io, "V(")
    if isdefined(X.X, :Xred)
      I = vanishing_ideal(X)
    else
      I = fat_ideal(X)
    end
    join(io, gens(I), ",")
    print(io, ")")
  end
end


# Projective space
Base.show(io::IO, ::MIME"text/plain", P::AbsProjectiveVariety{<:Field, <:MPolyDecRing}) = Base.show(io, MIME("text/plain"), underlying_scheme(P))

Base.show(io::IO, P::AbsProjectiveVariety{<:Field, <:MPolyDecRing}) = Base.show(io, underlying_scheme(P))
