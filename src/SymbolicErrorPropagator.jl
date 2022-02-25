module SymbolicErrorPropagator
    include("error_propagator.jl")
    export get_propagated_error_string
    export get_propagated_error_function
    include("latex_utils.jl")
    export enclose
end
