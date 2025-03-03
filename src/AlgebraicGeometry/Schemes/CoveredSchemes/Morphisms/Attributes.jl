
########################################################################
# Interface for AbsCoveredSchemeMorphism                               #
########################################################################
### essential getters 
function domain(f::AbsCoveredSchemeMorphism)::CoveredScheme
  return domain(underlying_morphism(f))
end

function codomain(f::AbsCoveredSchemeMorphism)::CoveredScheme
  return codomain(underlying_morphism(f))
end

@doc raw"""
    covering_morphism(f::AbsCoveredSchemeMorphism) -> CoveringMorphism

Given a morphism `f` between two covered schemes `X` and `Y`, return the
morphism between coverings of `X` and `Y` defining `f`.

# Examples
```jldoctest
julia> P, (x, y, z) = graded_polynomial_ring(QQ, [:x, :y, :z]);

julia> Y = variety(ideal([x^3-y^2*z]))
Projective variety
  in projective 2-space over QQ with coordinates [x, y, z]
defined by ideal(x^3 - y^2*z)

julia> Ycov = covered_scheme(Y)
Scheme
  over rational field
with default covering
  described by patches
    1: spec of quotient of multivariate polynomial ring
    2: spec of quotient of multivariate polynomial ring
    3: spec of quotient of multivariate polynomial ring
  in the coordinate(s)
    1: [(y//x), (z//x)]
    2: [(x//y), (z//y)]
    3: [(x//z), (y//z)]

julia> I, s = singular_locus(Ycov)
(Scheme over QQ covered with 1 patch, Morphism: scheme over QQ covered with 1 patch -> scheme over QQ covered with 3 patches)

julia> covering_morphism(s)
Morphism
  from covering with 1 patch
    1a: [(x//z), (y//z)]   spec of quotient of multivariate polynomial ring
  to   covering with 3 patches
    1b: [(y//x), (z//x)]   spec of quotient of multivariate polynomial ring
    2b: [(x//y), (z//y)]   spec of quotient of multivariate polynomial ring
    3b: [(x//z), (y//z)]   spec of quotient of multivariate polynomial ring
given by the pullback function
  1a -> 3b
    (x//z) -> 0
    (y//z) -> 0
```
"""
function covering_morphism(f::AbsCoveredSchemeMorphism)::CoveringMorphism
  return covering_morphism(underlying_morphism(f))
end

### generically derived getters
domain_covering(f::AbsCoveredSchemeMorphism) = domain(covering_morphism(f))
codomain_covering(f::AbsCoveredSchemeMorphism) = codomain(covering_morphism(f))
getindex(f::AbsCoveredSchemeMorphism, U::Spec) = covering_morphism(f)[U]

########################################################################
# Basic getters for CoveredSchemeMorphism                              #
########################################################################
domain(f::CoveredSchemeMorphism) = f.X
codomain(f::CoveredSchemeMorphism) = f.Y
covering_morphism(f::CoveredSchemeMorphism) = f.f

@doc raw"""
    isomorphism_on_open_subsets(f::AbsCoveredSchemeMorphism)

For a birational morphism ``f : X → Y`` of `AbsCoveredScheme`s this 
returns an isomorphism of affine schemes ``fᵣₑₛ : U → V`` which is 
the restriction of ``f`` to two dense open subsets ``U ⊂ X`` and 
``V ⊂ Y``.
"""
function isomorphism_on_open_subsets(f::AbsCoveredSchemeMorphism)
  if !has_attribute(f, :iso_on_open_subset)
    is_birational(f) # Should compute and store the attribute
  end
  return get_attribute(f, :iso_on_open_subset)::AbsSpecMor
end

@attr AbsCoveredSchemeMorphism function inverse(f::AbsCoveredSchemeMorphism)
  error("method not implemented")
end
