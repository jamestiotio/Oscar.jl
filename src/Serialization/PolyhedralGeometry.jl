using JSON

function bigobject_to_dict(bo::Polymake.BigObject)
    serialized = Polymake.call_function(Symbol("Core::Serializer"), :serialize, bo)
    jsonstr = Polymake.call_function(:common, :encode_json, serialized)
    return JSON.parse(jsonstr)
end

function save_internal(s::SerializerState, p::Polymake.BigObject)
    return bigobject_to_dict(p)
end

function load_internal(s::DeserializerState, ::Type{Polymake.BigObject}, dict::Dict)
    bigobject = Polymake.call_function(:common, :deserialize_json_string, json(dict))
    return bigobject
end


##############################################################################
@registerSerializationType(LinearProgram{QQFieldElem})

function save_internal(s::SerializerState, lp::LinearProgram)
    lpcoeffs = lp.polymake_lp.LINEAR_OBJECTIVE
    serialized = Polymake.call_function(Symbol("Core::Serializer"), :serialize, lpcoeffs)
    jsonstr = Polymake.call_function(:common, :encode_json, serialized)
    return Dict(
        :feasible_region => save_type_dispatch(s, lp.feasible_region),
        :convention => lp.convention,
        :lpcoeffs => JSON.parse(jsonstr)
    )
end

function load_internal(s::DeserializerState, ::Type{LinearProgram{T}}, dict::Dict) where T
    fr = load_type_dispatch(s, Polyhedron{T}, dict[:feasible_region])
    conv = dict[:convention]
    lpcoeffs = Polymake.call_function(:common, :deserialize_json_string, json(dict[:lpcoeffs]))
    all = Polymake._lookup_multi(pm_object(fr), "LP")
    index = 0
    for i in 1:length(all)
        if all[i].LINEAR_OBJECTIVE == lpcoeffs
            index = i
            break
        end
    end
    lp = Polymake._lookup_multi(pm_object(fr), "LP", index-1)
    return LinearProgram{T}(fr, lp, Symbol(conv))
end

##############################################################################
@registerSerializationType(MixedIntegerLinearProgram{QQFieldElem})

function save_internal(s::SerializerState, milp::MixedIntegerLinearProgram)
    milp_coeffs = milp.polymake_milp.LINEAR_OBJECTIVE
    int_vars = milp.polymake_milp.INTEGER_VARIABLES
    coeffs_serialized = Polymake.call_function(
        Symbol("Core::Serializer"), :serialize, milp_coeffs)
    int_vars_serialized = Polymake.call_function(
        Symbol("Core::Serializer"), :serialize, int_vars)
    coeffs_jsonstr = Polymake.call_function(:common, :encode_json, coeffs_serialized)
    int_vars_jsonstr = Polymake.call_function(:common, :encode_json, int_vars_serialized)
    return Dict(
        :feasible_region => save_type_dispatch(s, milp.feasible_region),
        :convention => milp.convention,
        :milp_coeffs => JSON.parse(coeffs_jsonstr),
        :int_vars => JSON.parse(int_vars_jsonstr)
    )
end

function load_internal(s::DeserializerState, ::Type{MixedIntegerLinearProgram{T}}, dict::Dict) where T
    fr = load_type_dispatch(s, Polyhedron{T}, dict[:feasible_region])
    conv = dict[:convention]
    milp_coeffs = Polymake.call_function(
        :common,
        :deserialize_json_string,
        json(dict[:milp_coeffs])
    )
    int_vars = Polymake.call_function(
        :common,
        :deserialize_json_string,
        json(dict[:int_vars])
    )

    all = Polymake._lookup_multi(pm_object(fr), "MILP")
    index = 0
    for i in 1:length(all)
        if all[i].LINEAR_OBJECTIVE == milp_coeffs && all[i].INTEGER_VARIABLES == int_vars
            index = i
            break
        end
    end
    lp = Polymake._lookup_multi(pm_object(fr), "MILP", index-1)
    return MixedIntegerLinearProgram{T}(fr, lp, Symbol(conv))
end

# use generic serialization for the other types:
@registerSerializationType(Cone{QQFieldElem})
save_internal(s::SerializerState, obj::Cone) = save_internal_generic(s, obj)
load_internal(s::DeserializerState, ::Type{T}, dict::Dict) where T <: Cone = load_internal_generic(s, T, dict)

@registerSerializationType(PolyhedralComplex{QQFieldElem})
save_internal(s::SerializerState, obj::PolyhedralComplex) = save_internal_generic(s, obj)
load_internal(s::DeserializerState, ::Type{T}, dict::Dict) where T <: PolyhedralComplex = load_internal_generic(s, T, dict)

@registerSerializationType(Polyhedron{QQFieldElem})
save_internal(s::SerializerState, obj::Polyhedron) = save_internal_generic(s, obj)
load_internal(s::DeserializerState, ::Type{T}, dict::Dict) where T <: Polyhedron = load_internal_generic(s, T, dict)

@registerSerializationType(PolyhedralFan{QQFieldElem})
save_internal(s::SerializerState, obj::PolyhedralFan) = save_internal_generic(s, obj)
load_internal(s::DeserializerState, ::Type{T}, dict::Dict) where T <: PolyhedralFan = load_internal_generic(s, T, dict)

@registerSerializationType(SubdivisionOfPoints{QQFieldElem})
save_internal(s::SerializerState, obj::SubdivisionOfPoints) = save_internal_generic(s, obj)
load_internal(s::DeserializerState, ::Type{T}, dict::Dict) where T <: SubdivisionOfPoints = load_internal_generic(s, T, dict)
