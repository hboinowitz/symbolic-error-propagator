using SymPy

function get_propagated_error_string(f::Sym, error_variables::Vector{Sym}, gaussian::Bool)
    index = 1
    num_of_error_variables = length(error_variables)

    error = ""
    if gaussian
        error = "\\sqrt{"
    end

    for i in error_variables
        if gaussian
            error *= "\\left($(sympy.latex(diff(f, i)))\\cdot\\Delta $(sympy.latex(i))\\right)^2"
        else
            error *= "\\left|$(sympy.latex(diff(f, i)))\\right|\\cdot\\Delta $(sympy.latex(i))\\right"
        end

        if index < num_of_error_variables
            error *= " + "
        end
        if index == num_of_error_variables && gaussian
            error *= "}"
        end
        index += 1
    end
    return error
end

function get_propagated_error_function(f::Sym, error_variables::Vector{Sym}, 
                                      errors::Vector{Sym}, gaussian::Bool)
    index = 1

    @vars error
    error = 0

    for i in error_variables
        if gaussian
            error += (sympy.Derivative(f, i) * errors[index]) ^ 2
        else
            error += (sympy.Derivative(f, i) * errors[index])
        end
        index += 1
    end
    if gaussian
        return sympy.sqrt(error)
    end
    return error
end