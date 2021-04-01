# File: julia-codes-01.jl
# Date:     Fri Jul  5 09:28:51 +08 2019
# Modified: 
# ========================================================
"""
https://en.wikibooks.org/wiki/Introducing_Julia/Modules_and_packages
Julia code is organized into files, modules, and packages. 

(1) Files containing Julia code use the .jl file extension.

(2) Modules = Related functions and other definitions can be grouped together and stored in modules.
	module MyModule
	    in between these lines you can put functions, type definitions, constants, and so on. 
	end

(3) Packages = One or more modules can be stored in a package, where each Julia package is, by convention, named with a ".jl" suffix. 

After installation, to start using functions and definitions from the module, you tell Julia to make the code available to your current session, 
with the using or import statements, which accept the names of one or more installed modules: 

"""

# ========================================================
using Dates 
print(Dates.time(), " Current date today() = ", Dates.today(), "\n")
print(Dates.time(), " Current date time now: ", Dates.now(), "\n")
print(Dates.time(), " Bismillah from WRY in Julia script. \n") 


# =========================================================
"""

"""
# =========================================================

