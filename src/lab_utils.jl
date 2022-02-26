using DataFrames
using CSV
using SymPy

function load_csv_to_DataFrame(path::String)
    return DataFrame(CSV.File(path))
end


function apply_function_to_measured_data(measured_data::DataFrame, function_::Sym, variable_names::Vector{String},  
                                        error_variable_symbols::Vector{Sym}, error_symbols::Vector{Sym},
                                        non_error_variable_symbols::Vector{Sym})

    function to_apply(variables ...)
        local_function_ = function_
        num_of_error_variables = length(error_variable_symbols)

        for (index, variable_value) in enumerate(variables)
            if index <= 2 * num_of_error_variables 
                if index % 2 == 1
                    local_function_ = local_function_(error_variable_symbols[div(index,2) + 1] => variable_value)
                end
            else
                local_function_ = (
                        local_function_(non_error_variable_symbols[index - (2 * num_of_error_variables)] 
                                            => variable_value)
                )
            end
        end

        return float(local_function_.evalf())
    end
    
    return transform(measured_data, variable_names => ByRow(to_apply) => ["f"])
end


function apply_error_function_to_measured_data(measured_data::DataFrame, function_::Sym, 
                                            variable_names::Vector{String},  
                                            error_variable_symbols::Vector{Sym}, error_symbols::Vector{Sym},
                                            non_error_variable_symbols::Vector{Sym})
    error_function = get_propagated_error_function(function_, error_variable_symbols, error_symbols, "lin")

    function to_apply(variables ...)
        local_error_function = error_function
        num_of_error_variables = length(error_variable_symbols)

        for (index, variable_value) in enumerate(variables)
            if index <= 2 * num_of_error_variables
                if index % 2 == 1
                    local_error_function = local_error_function(error_variable_symbols[div(index,2) + 1] => variable_value)
                else 
                    local_error_function = local_error_function(error_symbols[div(index,2)] => variable_value)
                end
            else
                local_error_function = (
                    local_error_function(non_error_variable_symbols[index - (2 * num_of_error_variables)] 
                                        => variable_value)
                )
            end
        end

        return float(local_error_function.evalf())
    end

    return transform(measured_data, variable_names => ByRow(to_apply) => ["df"]) 
end

function apply_to_measured_data(measured_data::DataFrame, function_::Sym, 
                                variable_names::Vector{String},  
                                error_variable_symbols::Vector{Sym}, error_symbols::Vector{Sym},
                                non_error_variable_symbols::Vector{Sym})
    # Calculate f for the given parameters
    measured_data = apply_function_to_measured_data(measured_data, function_, variable_names, error_variable_symbols, error_symbols, non_error_variable_symbols)
    
    # Calculate ∆f for the given parameters
    measured_data = apply_error_function_to_measured_data(measured_data, function_, variable_names, error_variable_symbols, error_symbols, non_error_variable_symbols)

    return measured_data
end