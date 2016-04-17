const t = UInt8 # Change to Uint16 later.. maybe
const v = Array{Float32, 1}
const m = Array{t, 2}

include("Functions.jl")
include("generate.jl")

@time matrix = Generate.matrix(20000)::m

@time matrix2 = Generate.compress([
  false true  true  true  true  true  true  true ;
  true  false true  true  false false true  false;
  true  true  false true  false true  false false;
  true  true  true  false true  false false false;
  true  false false true  false false true  false;
  true  false true  false false false true  false;
  true  true  false false true  true  false false;
  true  false false false false false false false;
])

function things(matrix::m)
  si_ze = size(matrix, 1)
  vector = [1.0f0 for x=1:si_ze]::v
  newvector = Array(Float32, si_ze)

  count = 0
  while true
    (vector, newvector) = Fn.keer!(matrix, vector, newvector)
    Fn.normalize!(vector)

    count += 1
    if count > 3 #Fn.lookslike(vector, newvector)
      #return map(x -> round(x, 2), vector)
      return vector
    end
  end
end

@time v1 = things(matrix)
