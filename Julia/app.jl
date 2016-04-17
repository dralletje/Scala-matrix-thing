const t = UInt8 # Change to Uint16 later.. maybe
const v = Array{Float32, 1}
const m = Array{t, 2}

include("Functions.jl")
include("generate.jl")

@time matrix = Generate.matrix(5000)::m

@time matrix2 = Generate.compress([
  false true  true  true  true  true  true  true ;
  true  false true  true  false false true  false;
  true  true  false true  true  true  true  false;
  true  true  true  false true  false false false;
  true  false true  true  false false true  false;
  true  false true  false false false true  false;
  true  true  true  false true  true  false false;
  true  false false false false false false false;
])

function things(matrix::m)
  vector = fill(1.0f0, (size(matrix, 1)))
  newvector = Array(Float32, size(matrix, 1))

  count = 0
  while true
    (vector, newvector) = Fn.keer!(matrix, vector, newvector)

    Fn.normalize!(vector)

    count += 1

    looklike = Fn.lookslike(vector, newvector, 3)
    if looklike
      print(count, "\n")
      return vector
    end
  end
end

@time v1 = things(matrix)
