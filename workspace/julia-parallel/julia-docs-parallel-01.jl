# File: julia-docs-parallel-01.jl
# Date:     Sat Jul  6 15:13:26 +08 2019
# Modified: 
# =========================================================
"""


https://pkg.julialang.org/docs/julia/THl1k/1.1.1/manual/methods.html
https://pkg.julialang.org/docs/julia/THl1k/1.1.1/manual/functions.html
https://docs.julialang.org/en/v1/manual/parallel-computing/index.html

The different levels of parallelism offered by Julia. We can divide them in three main categories :

    Julia Coroutines (Green Threading) = Tasks
    Multi-Threading
    Multi-Core or Distributed Processing

Since we are iterating through lots of modules, I am using import instead of using to prevent clashes between the exported names.

A definition of one possible behavior for a function is called a method.

Recall from Functions that a function is an object that maps a tuple of arguments to a return value, or throws an exception if no appropriate value can be returned. It is common for the same conceptual function or operation to be implemented quite differently for different types of arguments: adding two integers is very different from adding two floating-point numbers, both of which are distinct from adding an integer to a floating-point number. 


"""

# =========================================================
using Dates 
print(Dates.time(), " Current date today() = ", Dates.today(), "\n")
print(Dates.time(), " Current date time now: ", Dates.now(), "\n")
print(Dates.time(), " Bismillah from WRY in Julia script. \n\n") 
# =========================================================

using InteractiveUtils
import InteractiveUtils
show(versioninfo());
println("\n");
println("\n names(InteractiveUtils) = \n", names(InteractiveUtils));
println("\n varinfo(InteractiveUtils) = \n", varinfo(InteractiveUtils));
println("\n typeof(InteractiveUtils) = \n", typeof(InteractiveUtils));

#using Base
import Base
println("\n names(Base) = \n", names(Base));
println("\n varinfo(Base) = \n", varinfo(Base));
println("\n typeof(Base) = \n", typeof(Base));

import Core
#using Core
println("\n names(Core) = \n", names(Core));
println("\n varinfo(Core) = \n", varinfo(Core));
println("\n typeof(Core) = \n", typeof(Core));

import LinearAlgebra
println("\n names(LinearAlgebra) = \n", names(LinearAlgebra));
println("\n varinfo(LinearAlgebra) = \n", varinfo(LinearAlgebra));
println("\n typeof(LinearAlgebra) = \n", typeof(LinearAlgebra));

import Pkg
println("\n names(Pkg) = \n", names(Pkg));
println("\n varinfo(Pkg) = \n", varinfo(Pkg));
println("\n typeof(Pkg) = \n", typeof(Pkg));

using PyPlot
println("\n names(PyPlot) = \n", names(PyPlot));
println("\n varinfo(PyPlot) = \n", varinfo(PyPlot));
println("\n typeof(PyPlot) = \n", typeof(PyPlot));

## using Plots 
import Plots  # (import to prevent clashes between the identifiers exported names.)
println("\n names(Plots) = \n", names(Plots));
println("\n varinfo(Plots) = \n", varinfo(Plots));
println("\n typeof(Plots) = \n", typeof(Plots));

# =========================================================
print("\n\n", Dates.time(), " Alhamdulillah from WRY in Julia script. \n\n") 
# =========================================================

"""
EXECUTION

julia> varinfo()
name                    size summary
–––––––––––––––– ––––––––––– –––––––
Base                         Module 
Core                         Module 
InteractiveUtils 163.926 KiB Module 
Main                         Module 

julia> versioninfo()
Julia Version 1.1.1
Commit 55e36cc308 (2019-05-16 04:10 UTC)
Platform Info:
  OS: Linux (x86_64-pc-linux-gnu)
  CPU: Intel(R) Core(TM) i5-3380M CPU @ 2.90GHz
  WORD_SIZE: 64
  LIBM: libopenlibm
  LLVM: libLLVM-6.0.1 (ORCJIT, ivybridge)

julia> using Pkg
julia> Pkg.update()
  Updating registry at `~/.julia/registries/General`
  Updating git-repo `https://github.com/JuliaRegistries/General.git`
  Updating git-repo `https://github.com/probcomp/Gen`
 Resolving package versions...
 Installed Plots ────────── v0.25.3
 Installed DataStructures ─ v0.17.0
 Installed HDF5 ─────────── v0.12.0
 Installed DiffEqBase ───── v5.13.0
 Installed IterTools ────── v1.2.0
 Installed DelayDiffEq ──── v5.6.0
 Installed HTTP ─────────── v0.8.4
  Updating `~/.julia/environments/v1.1/Project.toml`
  [864edb3b] ↑ DataStructures v0.15.0 ⇒ v0.17.0
  [f67ccb44] ↑ HDF5 v0.11.1 ⇒ v0.12.0
  [91a5bcdd] ↑ Plots v0.25.2 ⇒ v0.25.3
  Updating `~/.julia/environments/v1.1/Manifest.toml`
  [864edb3b] ↑ DataStructures v0.15.0 ⇒ v0.17.0
  [bcd4f6db] ↑ DelayDiffEq v5.4.1 ⇒ v5.6.0
  [2b5f629d] ↑ DiffEqBase v5.12.0 ⇒ v5.13.0
  [f67ccb44] ↑ HDF5 v0.11.1 ⇒ v0.12.0
  [cd3eb016] ↑ HTTP v0.8.3 ⇒ v0.8.4
  [c8e1da08] ↑ IterTools v1.1.1 ⇒ v1.2.0
  [91a5bcdd] ↑ Plots v0.25.2 ⇒ v0.25.3
  [1fd47b50] ↓ QuadGK v2.1.0 ⇒ v2.0.3
  Building HDF5 ─→ `~/.julia/packages/HDF5/Y9Znv/deps/build.log`
  Building Plots → `~/.julia/packages/Plots/FQOz1/deps/build.log`

julia> Pkg.status()

julia> Pkg.installed()
Dict{String,Union{Nothing, VersionNumber}} with 120 entries:

julia> varinfo(Base)
name                            size summary                                      
–––––––––––––––––––––––– ––––––––––– –––––––––––––––––––––––––––––––––––––––––––––
!                            0 bytes typeof(!)             
....
....
@MIME_str                    0 bytes getfield(Base, Symbol("#@MIME_str"))         
@__DIR__                     0 bytes getfield(Base, Symbol("#@__DIR__"))          
@__FILE__                    0 bytes getfield(Base, Symbol("#@__FILE__"))         
@__LINE__                    0 bytes getfield(Base, Symbol("#@__LINE__"))         
@__MODULE__                  0 bytes getfield(Base, Symbol("#@__MODULE__"))       
@__dot__                     0 bytes getfield(Base.Broadcast, Symbol("#@__dot__"))
@allocated                   0 bytes getfield(Base, Symbol("#@allocated"))        
@assert                      0 bytes getfield(Base, Symbol("#@assert"))           
@async                       0 bytes getfield(Base, Symbol("#@async"))            
@b_str                       0 bytes getfield(Base, Symbol("#@b_str"))            
@big_str                     0 bytes getfield(Core, Symbol("#@big_str"))          
@boundscheck                 0 bytes getfield(Base, Symbol("#@boundscheck"))      
@cfunction                   0 bytes getfield(Base, Symbol("#@cfunction"))        
@cmd                         0 bytes getfield(Core, Symbol("#@cmd"))              
@debug                       0 bytes getfield(Base.CoreLogging, Symbol("#@debug"))
@deprecate                   0 bytes getfield(Base, Symbol("#@deprecate"))        
@doc                         0 bytes getfield(Core, Symbol("#@doc"))              
@elapsed                     0 bytes getfield(Base, Symbol("#@elapsed"))          
@enum                        0 bytes getfield(Base.Enums, Symbol("#@enum"))       
@error                       0 bytes getfield(Base.CoreLogging, Symbol("#@error"))
@eval                        0 bytes getfield(Base, Symbol("#@eval"))             
@evalpoly                    0 bytes getfield(Base.Math, Symbol("#@evalpoly"))    
@fastmath                    0 bytes getfield(Base.FastMath, Symbol("#@fastmath"))
@generated                   0 bytes getfield(Base, Symbol("#@generated"))        
@gensym                      0 bytes getfield(Base, Symbol("#@gensym"))           
@goto                        0 bytes getfield(Base, Symbol("#@goto"))             
@html_str                    0 bytes getfield(Base.Docs, Symbol("#@html_str"))    
@inbounds                    0 bytes getfield(Base, Symbol("#@inbounds"))         
@info                        0 bytes getfield(Base.CoreLogging, Symbol("#@info")) 
@inline                      0 bytes getfield(Base, Symbol("#@inline"))           
@int128_str                  0 bytes getfield(Core, Symbol("#@int128_str"))       
@isdefined                   0 bytes getfield(Base, Symbol("#@isdefined"))        
@label                       0 bytes getfield(Base, Symbol("#@label"))            
@macroexpand                 0 bytes getfield(Base, Symbol("#@macroexpand"))      
@macroexpand1                0 bytes getfield(Base, Symbol("#@macroexpand1"))     
@noinline                    0 bytes getfield(Base, Symbol("#@noinline"))         
@nospecialize                0 bytes getfield(Base, Symbol("#@nospecialize"))     
@polly                       0 bytes getfield(Base, Symbol("#@polly"))            
@r_str                       0 bytes getfield(Base, Symbol("#@r_str"))            
@raw_str                     0 bytes getfield(Base, Symbol("#@raw_str"))          
@s_str                       0 bytes getfield(Base, Symbol("#@s_str"))            
@show                        0 bytes getfield(Base, Symbol("#@show"))             
@simd                        0 bytes getfield(Base.SimdLoop, Symbol("#@simd"))    
@specialize                  0 bytes getfield(Base, Symbol("#@specialize"))       
@static                      0 bytes getfield(Base, Symbol("#@static"))           
@sync                        0 bytes getfield(Base, Symbol("#@sync"))             
@task                        0 bytes getfield(Base, Symbol("#@task"))             
@text_str                    0 bytes getfield(Base.Docs, Symbol("#@text_str"))    
@threadcall                  0 bytes getfield(Base, Symbol("#@threadcall"))       
@time                        0 bytes getfield(Base, Symbol("#@time"))             
@timed                       0 bytes getfield(Base, Symbol("#@timed"))            
@timev                       0 bytes getfield(Base, Symbol("#@timev"))            
@uint128_str                 0 bytes getfield(Core, Symbol("#@uint128_str"))      
@v_str                       0 bytes getfield(Base, Symbol("#@v_str"))            
@view                        0 bytes getfield(Base, Symbol("#@view"))             
@views                       0 bytes getfield(Base, Symbol("#@views"))            
@warn                        0 bytes getfield(Base.CoreLogging, Symbol("#@warn")) 
ARGS                        40 bytes 0-element Array{String,1}        
....
....

julia> names(Base)
880-element Array{Symbol,1}:
 :!   
 :!=  

julia> names(Core)
97-element Array{Symbol,1}:
 :<:            
 :(===)         
 :AbstractArray 
 :AbstractChar  
 :AbstractFloat 
 :AbstractString
 :Any           
 :ArgumentError 
 :Array         
 :AssertionError
 :Bool          
 :BoundsError   
 :Char          
 :Core          
 :Cvoid         
 :DataType      
 :DenseArray    
 :DivideError   
 :DomainError   
 :ErrorException
 ⋮              
 :Vararg        
 :VecElement    
 :WeakRef       
 :applicable    
 :eval          
 :fieldtype     
 :getfield      
 :ifelse        
 :invoke        
 :isa           
 :isdefined     
 :nfields       
 :nothing       
 :setfield!     
 :throw         
 :tuple         
 :typeassert    
 :typeof        
 :undef         

julia> varinfo(Core)
name                     size summary           
––––––––––––––––––– ––––––––– ––––––––––––––––––
<:                    0 bytes typeof(<:)        
===                   0 bytes typeof(===)       
AbstractArray        80 bytes UnionAll          
AbstractChar        172 bytes DataType          
AbstractFloat       172 bytes DataType          
AbstractString      172 bytes DataType          
Any                 172 bytes DataType          
ArgumentError       188 bytes DataType          
Array                80 bytes UnionAll          
AssertionError      188 bytes DataType          
Bool                172 bytes DataType          
BoundsError         196 bytes DataType          
Char                172 bytes DataType          
Core                          Module            
Cvoid               172 bytes DataType      

julia> varinfo(Main)
name                    size summary                  
–––––––––––––––– ––––––––––– –––––––––––––––––––––––––
Base                         Module                   
Core                         Module                   
InteractiveUtils 170.614 KiB Module                   
Main                         Module                   
ans                 80 bytes 5-element Array{Symbol,1}

julia> names(InteractiveUtils)
22-element Array{Symbol,1}:
 Symbol("@code_llvm")    
 Symbol("@code_lowered") 
 Symbol("@code_native")  
 Symbol("@code_typed")   
 Symbol("@code_warntype")
 Symbol("@edit")         
 Symbol("@functionloc")  
 Symbol("@less")         
 Symbol("@which")        
 :InteractiveUtils       
 :apropos                
 :clipboard              
 :code_llvm              
 :code_native            
 :code_warntype          
 :edit                   
 :less                   
 :methodswith            
 :peakflops              
 :subtypes               
 :varinfo                
 :versioninfo            

julia> varinfo(InteractiveUtils)
name                    size summary                                              
–––––––––––––––– ––––––––––– –––––––––––––––––––––––––––––––––––––––––––––––––––––
@code_llvm           0 bytes getfield(InteractiveUtils, Symbol("#@code_llvm"))    
@code_lowered        0 bytes getfield(InteractiveUtils, Symbol("#@code_lowered")) 
@code_native         0 bytes getfield(InteractiveUtils, Symbol("#@code_native"))  
@code_typed          0 bytes getfield(InteractiveUtils, Symbol("#@code_typed"))   
@code_warntype       0 bytes getfield(InteractiveUtils, Symbol("#@code_warntype"))
@edit                0 bytes getfield(InteractiveUtils, Symbol("#@edit"))         
@functionloc         0 bytes getfield(InteractiveUtils, Symbol("#@functionloc"))  
@less                0 bytes getfield(InteractiveUtils, Symbol("#@less"))         
@which               0 bytes getfield(InteractiveUtils, Symbol("#@which"))        
InteractiveUtils 170.614 KiB Module                                               
apropos              0 bytes typeof(apropos)                                      
clipboard            0 bytes typeof(clipboard)                                    
code_llvm            0 bytes typeof(code_llvm)                                    
code_native          0 bytes typeof(code_native)                                  
code_warntype        0 bytes typeof(code_warntype)                                
edit                 0 bytes typeof(edit)                                         
less                 0 bytes typeof(less)                                         
methodswith          0 bytes typeof(methodswith)                                  
peakflops            0 bytes typeof(peakflops)                                    
subtypes             0 bytes typeof(subtypes)                                     
varinfo              0 bytes typeof(varinfo)                                      
versioninfo          0 bytes typeof(versioninfo)                                  

julia> 

wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-parallel# julia julia-docs-parallel-01.jl > Results-julia-docs-parallel-01.txt
┌ Warning: You are using Matplotlib 1.5.1, which is no longer officialy supported by the Plots community. To ensure smooth Plots.jl integration update your Matplotlib library to a version >= 2.0.0
└ @ Plots ~/.julia/packages/Plots/FQOz1/src/backends/pyplot.jl:31
WARNING: using Plots.grid in module Main conflicts with an existing identifier.
WARNING: using Plots.scatter in module Main conflicts with an existing identifier.
WARNING: using Plots.bar in module Main conflicts with an existing identifier.
WARNING: using Plots.quiver in module Main conflicts with an existing identifier.
WARNING: using Plots.barh in module Main conflicts with an existing identifier.
WARNING: using Plots.spy in module Main conflicts with an existing identifier.
WARNING: using Plots.contourf in module Main conflicts with an existing identifier.
WARNING: using Plots.text in module Main conflicts with an existing identifier.
WARNING: using Plots.pie in module Main conflicts with an existing identifier.
WARNING: using Plots.contour in module Main conflicts with an existing identifier.
WARNING: using Plots.twinx in module Main conflicts with an existing identifier.
WARNING: using Plots.savefig in module Main conflicts with an existing identifier.
WARNING: using Plots.hexbin in module Main conflicts with an existing identifier.
WARNING: using Plots.arrow in module Main conflicts with an existing identifier.
WARNING: using Plots.plot in module Main conflicts with an existing identifier.
WARNING: using Plots.boxplot in module Main conflicts with an existing identifier.
wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-parallel# 

wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-parallel# sudo pip3 install --upgrade matplotlib
....
....
wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-parallel# sudo pip install --upgrade matplotlib
....
....
wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-parallel# python3
Python 3.5.2 (default, Nov 12 2018, 13:43:14) 
[GCC 5.4.0 20160609] on linux
Type "help", "copyright", "credits" or "license" for more information.

>>> import matplotlib
>>> matplotlib.__version__
'3.0.3'
>>> 
>>> exit()
wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-parallel# 
wruslan@HPEliteBk8470p-ub1604-64b:~/Documents/julia-parallel# python2
Python 2.7.12 (default, Nov 12 2018, 14:36:49) 
[GCC 5.4.0 20160609] on linux2
Type "help", "copyright", "credits" or "license" for more information.

>>> import matplotlib
>>> matplotlib.__version__
'2.2.4'
>>> exit()

"""
# =========================================================

