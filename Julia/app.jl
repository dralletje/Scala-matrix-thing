const si_ze = 20000
const t = Uint8 # Change to Uint16 later.. maybe
const v = Array{Float32, 1}
const m = Array{t, 2}

@time const matrix = [randbool() ? 0x1 : 0x0 for x=1:si_ze, y=1:si_ze]::m

import functions.jl


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
