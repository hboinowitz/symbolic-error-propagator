using SymPy

function get_propagated_error_string(f::Sym, error_variables::Vector{Sym}, method::String, 
                                     execute_derivative::Bool = true)

    if !(method in ["lin", "gaussian"]) 
        throw(ArgumentError("Error Propagation Method must be one of `lin` or `gaussian`."))
    end

    index = 1
    num_of_error_variables = length(error_variables)

    error = ""
    if method == "gaussian"
        error = "\\sqrt{"
    end

    for i in error_variables
        if execute_derivative
            derivative = sympy.latex(diff(f, i))
        else
            derivative = sympy.latex(sympy.Derivative(f, i))
        end

        if method == "gaussian"
            error *= "\\left($(derivative)\\cdot\\Delta $(sympy.latex(i))\\right)^2"
        else
            error *= "\\left|$(derivative)\\right|\\cdot\\Delta $(sympy.latex(i))"
        end

        if index < num_of_error_variables
            error *= " + "
        end
        if index == num_of_error_variables && method == "gaussian"
            error *= "}"
        end
        index += 1
    end
    return error
end

function get_propagated_error_function(f::Sym, error_variables::Vector{Sym}, 
                                      errors::Vector{Sym}, method::String, execute_derivative::Bool = true)
    
    if !(method in ["lin", "gaussian"]) 
        throw(ArgumentError("Error Propagation Method must be one of `lin` or `gaussian`."))
    end

    index = 1
    @vars error
    error = 0

    for i in error_variables
        if execute_derivative
            derivative = diff(f, i)
        else
            derivative = sympy.Derivative(f, i)
        end

        if method == "gaussian"
            error += (derivative * errors[index]) ^ 2
        else
            error += (derivative * errors[index])
        end
        index += 1
    end

    if method == "gaussian"
        return sympy.sqrt(error)
    end
    
    return error
end