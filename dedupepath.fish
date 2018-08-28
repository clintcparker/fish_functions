# de-dupe $fish_function_path
function dedupepath --description 'de-dupe $fish_function_path'
	set -l new_fun
    for val in $fish_function_path
        if not contains $val $new_fun
            set new_fun $new_fun $val
        end
    end
    set -gx fish_function_path $new_fun
end
