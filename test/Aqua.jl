using Aqua

@testset "Aqua.jl" begin
  Aqua.test_all(
    Oscar;
    ambiguities=false,      # TODO: fix ambiguities
    unbound_args=false,     # TODO: fix unbound type parameters
    undefined_exports=true,
    project_extras=true,
    stale_deps=true,
    deps_compat=true,
    project_toml_formatting=true,
    piracy=false,           # TODO: check the reported methods to be moved upstream
  )
end
