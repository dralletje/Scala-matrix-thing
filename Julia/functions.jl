###
#
# Functions :-D
#
module Fn

const t = UInt8 # Change to Uint16 later.. maybe
const v = Array{Float32, 1}
const m = Array{t, 2}

export normalize!, keer!, looklike!

const NULL = 0x00

const bits = [0x02 ^ x for x = 0:7]

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

function normalize!(vector::v)
  m, i = findmax(vector)
  for k=1:length(vector)
    vector[k] = vector[k] / m
  end
  return vector
end

# Mutationing
function keer!(matrix::m, vector::v, newvector::v)
  for i=1:size(matrix, 1)
    newvector[i] = 0.0
    for k=1:size(matrix, 2)
      num = matrix[i, k]

      for bit=1:size(bits, 1)
        if (num & bits[bit]) > NULL
          newvector[i] += vector[(k-1) + bit]
        end
      end
    end
  end

  return (newvector, vector) # Newvector becomes vector, and vector bcomes space for newvector
end

end
