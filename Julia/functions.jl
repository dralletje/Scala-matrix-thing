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

function lookslike(vec1::v, vec2::v, digits)
  if length(vec1) !== length(vec2)
    return false
  end

  for i = 1:length(vec1)
    if !is(round(vec1[i], digits), round(vec2[i], digits))
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

function compressed_keer!(matrix::m, vector::v, newvector::v)
  for column = 1:size(matrix, 2)
    for row = 1:size(matrix, 1)
      num = matrix[row, column]

      for bit = 1:8
        x = (num & 0x1)
        newvector[row] += x*vector[column + bit - 1]
        num = num >>> 1
      end
    end
  end
end

function uncompressed_keer!(matrix::m, vector::v, newvector::v)
  for column = 1:size(matrix, 2)
    for row = 1:size(matrix, 1)
      newvector[row] += matrix[row, column]*vector[column]
    end
  end
end

# Mutationing
function keer!(matrix::m, vector::v, newvector::v)
  x_size = size(matrix, 1)
  y_size = size(matrix, 2)
  is_compressed = y_size != x_size

  for i=1:x_size
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
