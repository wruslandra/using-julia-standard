# File: julia-controlsystems-01.jl
# Date:     Fri Jul  5 08:07:34 +08 2019
# Modified: 
# ========================================================
# https://pkg.julialang.org/docs/ControlSystemIdentification/FH1SZ/0.1.5/

using Dates 
print(Dates.time(), " Current date today() = ", Dates.today(), "\n")
print(Dates.time(), " Current date time now: ", Dates.now(), "\n")
print(Dates.time(), " Bismillah from WRY in Julia script. \n") 

print(Dates.time(), " Running (1). \n")
# ==========================================================
using Plots
using ControlSystemIdentification, ControlSystems, Random, LinearAlgebra

function ⟂(x)
    u,s,v = svd(x)
    u*v
end

function generate_system(nx,ny,nu)
    U,S  = ⟂(randn(nx,nx)), diagm(0=>0.2 .+ 0.5rand(nx))
    A    = S*U
    B   = randn(nx,nu)
    C   = randn(ny,nx)
    sys = ss(A,B,C,0,1)
end

Random.seed!(1)
T   = 1000                      # Number of time steps
nx  = 3                         # Number of poles in the true system
nu  = 1                         # Number of control inputs
ny  = 1                         # Number of outputs
x0  = randn(nx)                 # Initial state

print(Dates.time(), " Running (2). # Simulate system \n")
# ==========================================================
sim(sys,u,x0=x0) = lsim(sys, u', 1:T, x0=x0)[1]' # Helper function
sys = generate_system(nx,nu,ny)
u   = randn(nu,T)               # Generate random input
y   = sim(sys, u, x0)           # Simulate system

print(Dates.time(), " Running (3). # Plot prediction and true output \n")
# ===================================================
sysh,x0h,opt = pem(y, u, nx=nx, focus=:prediction) # Estimate model
yh = predict(sysh, y, u, x0h)   # Predict using estimated model
plot([y; yh]', lab=["y" "ŷ"])   # Plot prediction and true output

# We can also simulate the system with colored noise, necessitating estimating also noise models.

σu = 0.1 # Noise variances
σy = 0.1

sysn = generate_system(nx,nu,ny)             # Noise system
un   = u + sim(sysn, σu*randn(size(u)),0*x0) # Input + load disturbance
y    = sim(sys, un, x0)
yn   = y + sim(sysn, σy*randn(size(u)),0*x0) # Output + measurement noise

# The system now has 3nx poles, nx for the system dynamics, 
# and nx for each noise model, we indicated this to the main estimation function pem:

print(Dates.time(), " Running (4). # Plot Compare true output (without noise) to prediction \n")
# =====================================================
sysh,x0h,opt = pem(yn,un,nx=3nx, focus=:prediction)
yh           = predict(sysh, yn, un, x0h) # Form prediction
plot([y; yh]', lab=["y" "ŷ"])             # Compare true output (without noise) to prediction

# =========================================================
print(Dates.time(), " Alhamdulillah from WRY in Julia script. \n")
# =========================================================

"""
EXECUTION



"""
# =========================================================

