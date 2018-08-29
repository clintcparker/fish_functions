# Defined in - @ line 1
function belvedere --description 'Scaffolder for DNC apps. Usage: belvedere [NAME OF APP]'
	# set the name
    set -l name $argv[1]

    # make the new directory
    if test (mkdir $name)
        return 1
    end

    # move into that directory
    cd $name

    # download and save the .gitignore
    curl https://raw.githubusercontent.com/github/gitignore/master/VisualStudio.gitignore >>.gitignore
    
    # append the .gitignore
    echo -e '\n# Weird Azure Stuff \nDashboard - Microsoft Azure.html\nDashboard - Microsoft Azure_files/' >>.gitignore
    
    # create the class library
    dotnet new classlib --name "$name-core"
    
    # create the CLI
    dotnet new console --name "$name-cli"
    dotnet add $name-cli/*.csproj reference $name-core/
    
    # create the web app
    dotnet new razor --name $name-web
    dotnet add $name-web/*.csproj reference $name-core
    
    # create the test project
    dotnet new mstest --name $name-tests
    dotnet add $name-tests/*.csproj reference $name-core
    dotnet add $name-tests/*.csproj reference $name-web
    
    # create the solution
    dotnet new sln --name $name
    dotnet sln $name.sln add **/*.csproj

    # create the README
    echo "# $name" >> README.md
    set -l dni (dotnet --info)
    set -l dncvers $dni[2]
    set -l aspncvers (string replace -r "\[.*\]" ""  (string match -ir ".*aspnetcore.*" $dni))[1]
    echo "Built with DotNetCore $dncvers and $aspncvers" >> README.md

    git init
    git add .
    git commit -m "initial commit to $name"

    #return to the parent directory
    cd ..

end
