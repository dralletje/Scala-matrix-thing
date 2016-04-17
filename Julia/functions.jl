###
#
# Functions :-D
#
module Fn

const v = Array{Float32, 1}
#const m = BitArray{2}
const m = Array{UInt8, 2}

export normalize!, keer!, looklike!

const NULL = 0x00

const bits = [0x02 ^ x for x = 0:7]

function lookslike(vec1::v, vec2::v, digits)
  if length(vec1) !== length(vec2)
    return false
  end

  for i in 1:length(vec1)
    if !is(round(vec1[i], digits), round(vec2[i], digits))
      return false
    end
  end
  return true
end

function normalize!(vector::v)
  m, i = findmax(vector)
  for k in 1:length(vector)
    @inbounds vector[k] = vector[k] / m
  end
  return vector
end

function compressed_keer!(matrix::m, vector::v, newvector::v)
  @inbounds for column in 1:size(matrix, 2)
    for row in 1:size(matrix, 1)
      num = matrix[row, column]

      for bit in 1:8
        newvector[row] += ((num >>> bit) & 0x1)*vector[column + bit - 1]
      end
    end
  end
end

function uncompressed_keer!(matrix::m, vector::v, newvector::v)
  for column in 1:size(matrix, 2)
    for row in 1:size(matrix, 1)
      @inbounds newvector[row] += matrix[row, column]*vector[column]
    end
  end
end

# Mutationing
function keer!(matrix::m, vector::v, newvector::v)
  is_compressed = size(matrix, 2) != size(matrix, 1)

  for i in 1:size(matrix, 1)
    newvector[i] = 0.0
  end

  if is_compressed
    compressed_keer!(matrix, vector, newvector)
  else
    uncompressed_keer!(matrix, vector, newvector)
  end

  return (newvector, vector) # Newvector becomes vector, and vector bcomes space for newvector
end

end
