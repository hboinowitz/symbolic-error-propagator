function enclose(raw_string::String; inline::Bool=false, numbered::Bool=true)
    if inline
        return "\$$(raw_string)\$"
    else
        return "\\begin{equation$(numbered ? '*' : "")}\n\t$(raw_string)\n\\end{equation$(numbered ? '*' : "")}"
    end
end