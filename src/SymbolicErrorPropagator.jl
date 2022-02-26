module SymbolicErrorPropagator
    include("error_propagator.jl")
    export get_propagated_error_string
    export get_propagated_error_function
    include("latex_utils.jl")
    export enclose
    include("lab_utils.jl")
    export load_csv_to_DataFrame
    export apply_to_measured_data
end
