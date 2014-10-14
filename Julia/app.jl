const si_ze = 7000
const t = Uint8 # Change to Uint16 later.. maybe
const v = Array{Float64, 1}
const m = Array{t, 2}

function things()
  const matrix = [randbool() ? 0x1 : 0x0 for x=1:si_ze, y=1:si_ze]::m
  vector = [1.0 for x=1:si_ze]::v

  oldvector = Array(Float64, 1)
  count = 0
  while true
    oldvector = vector
    vector = normalize(keer(matrix, vector))
    count += 1

    if lookslike(vector, oldvector)
      println(count)
      return map(x -> round(x, 2), vector)
    end
  end
end

function lookslike(vec1::v, vec2::v)
  if length(vec1) !== length(vec2)
    return false
  end

  for i = 1:length(vec1)
    if !is(round(vec1[i], 2), round(vec2[i], 2))
       return false
    end
  end
  return true
end

function normalize(vector::v)
  m, i = findmax(vector)
  map(x -> x/m, vector)
end

function keer(matrix::m, row::Integer, vector::v)
  sum([matrix[i, row]*vector[i] for i=1:size(matrix, 2)])
end

function keer(matrix::m, vector::v)
  [keer(matrix, i, vector) for i=1:size(matrix, 1)]
end

@time things()
#@time value = [things() for i=1:5]
#println(value)
