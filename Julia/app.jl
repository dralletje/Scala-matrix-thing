const v = Array{Float32, 1}
#const m = BitArray{2}
const m = Array{UInt8, 2}

include("Functions.jl")
include("generate.jl")

@time const matrix = Generate.matrix(2048)::m

const matrix2 = Generate.compress([
  false true  true  true  true  true  true  true ;
  true  false true  true  false false true  false;
  true  true  false true  true  true  true  false;
  true  true  true  false true  false false false;
  true  false true  true  false false true  false;
  true  false true  false false false true  false;
  true  true  true  false true  true  false false;
  true  false false false false false false false;
])

function run(matrix::m)
  vector = fill(1.0f0, (size(matrix, 1)))
  newvector = Array(Float32, size(matrix, 1))

  count = 0
  while true
    (vector, newvector) = Fn.keer!(matrix, vector, newvector)
    Fn.normalize!(vector)
    count += 1

    if count > 200 # Fn.lookslike(vector, newvector, 3)
      #print(count, "\n")
      return vector
    end
  end
end

@time v1 = run(matrix)
#print(sortperm(v1))
