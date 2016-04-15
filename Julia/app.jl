const si_ze = 10000
const t = UInt8 # Change to Uint16 later.. maybe
const v = Array{Float32, 1}
const m = Array{t, 2}

@time const matrix = [rand(Bool) ? 0x1 : 0x0 for x=1:si_ze, y=1:si_ze]::m

function make_small(matrix::m)
  const s = ceil(size(matrix, 1) / 8)
  function reducetonum(x, y, m)
    for i=1:8
      matrix
    end
  end
  const satrix = [reducetonum(x, y, matrix) for x=1:s, y=1:s]
end

include("Functions.jl")


function things(matrix::m)
  vector = [1.0f0 for x=1:si_ze]::v
  newvector = Array(Float32, si_ze)

  count = 0
  while true
    (vector, newvector) = keer!(matrix, vector, newvector)
    normalize!(vector)
    count += 1

    if count > 3 # lookslike(vector, newvector)
      println(count)
      return map(x -> round(x, 2), vector)
    end
  end
end

@time v1 = things(matrix)
