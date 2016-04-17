const v = Array{Float32, 1}
const m = Array{UInt8, 2}

include("Functions.jl")
include("generate.jl")

# This will generate a random matrix (compressed) with a specified size
#const matrix = Generate.matrix(2048)::m

# Take a custom matrix and compress it into awesomness
const matrix = Generate.compress([
  false true  true  true  true  true  true  true ;
  true  false true  true  false false true  false;
  true  true  false true  true  true  true  false;
  true  true  true  false true  false false false;
  true  false true  true  false false true  false;
  true  false true  false false false true  false;
  true  true  true  false true  true  false false;
  true  false false false false false false false;
])

# Put in a matrix, get out a ranked vector
function run(matrix::m)
  # Fill a vector with 1.0f0
  vector = fill(1.0f0, size(matrix, 1))
  # Leave the other one valueless (will be filled in multiply!)
  newvector = Array(Float32, size(matrix, 1))

  # Count the amount of cycles, just for myself
  count = 0
  while true
    # Calculate the new rank vector, and recycle the space of the other one
    (vector, newvector) = Fn.multiply!(matrix, vector, newvector)
    # Normalize the rank vector
    Fn.normalize!(vector)
    # Keep track of the count
    count += 1

    # Look if the vectors are kind of equal
    if Fn.lookslike(vector, newvector, 3)
      # If so, feel free to return it
      print("Count: ", count, "\n")
      return vector
    end
  end
end

# Run it
v1 = run(matrix)

# Show the ranks
print(sortperm(v1, rev=true), "\n")
