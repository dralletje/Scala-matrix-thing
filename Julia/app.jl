const si_ze = 10000
const t = Uint8 # Change to Uint16 later.. maybe
const v = Array{Float32, 1}
const m = Array{t, 2}

@time const matrix = [randbool() ? 0x1 : 0x0 for x=1:si_ze, y=1:si_ze]::m

import functions.jl

function things(matrix::m)
  vector = [1.0f0 for x=1:si_ze]::v

  oldvector = Array(Float32, 1)
  count = 0
  while true
    oldvector = vector
    vector = normalize(keer(matrix, vector))
    count += 1

    if count > 3 # lookslike(vector, oldvector)
      println(count)
      return map(x -> round(x, 2), vector)
    end
  end
end

function things2(matrix::m)
  vector = [1.0f0 for x=1:si_ze]::v
  newvector = Array(Float32, si_ze)

  count = 0
  while true
    println("\n=====")
    @time (vector, newvector) = keer!(matrix, vector, newvector)
    @time normalize!(vector)
    count += 1

    if count > 3 # lookslike(vector, newvector)
      println(count)
      return map(x -> round(x, 2), vector)
    end
  end
end

#

function small(matrix::m)
  vector = [1.0f0 for x=1:si_ze]::v
  vector = normalize(keer(matrix, vector))
  return vector
end

function small2(matrix::m)
  vector = [1.0f0 for x=1:si_ze]::v
  newvector = Array(Float32, si_ze)
  @time (vector, newvector) = keer!(matrix, vector, newvector)
  println("Calc\n")
  @time normalize!(vector)
  println("Normalize\n")
  return vector
end

@time v1 = small(matrix)
@time v2 = small2(matrix)

println("\n")
println(v1 == v2)
#@time [things() for i=1:5]
