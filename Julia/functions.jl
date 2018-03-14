###
#
# Functions :-D
#
module Fn

const v = Array{Float32, 1}
const m = Array{UInt8, 2}

export normalize!, multiply!, looklike!

## Compare two vectors with their values rounded
# Because I want to stop iterating when the vectors
# are pretty close, so I 'know' we are close as well
function lookslike(vec1::v, vec2::v, digits)
  if length(vec1) !== length(vec2)
    return false
  end

  for i in 1:length(vec1)
    if round(vec1[i], digits) !== round(vec2[i], digits)
      return false
    end
  end
  return true
end

# Normalize a vector: Get all their values between 0 and 1, yet preserving
# their relative sizes
function normalize!(vector::v)
  m, i = findmax(vector)
  for k in 1:length(vector)
    @inbounds vector[k] = vector[k] / m
  end
  return vector
end

# The real thing: Will apply the vector to the compressed matrix,
# accumulating the result in a new vector.
# This loop is the only thing really taking time in this program,
# minor performance fixes will result in hugely faster runs.
function compressed_multiply!(matrix::m, vector::v, newvector::v)
  # Loop over every field in the matrix
  @inbounds for column in 1:size(matrix, 2)
    for row in 1:size(matrix, 1)
      # Take the number from the matrix
      num = matrix[row, column]
      # Now loop over the bits, as every UInt8 contains 8 actual columns
      for bit in 1:8
        # Put the result in new vector
        newvector[row] += ((num >>> bit) & 0x1)*vector[column + bit - 1]
      end
    end
  end
end

# Only used to compare performance, this one
function uncompressed_multiply!(matrix::m, vector::v, newvector::v)
  for column in 1:size(matrix, 2)
    for row in 1:size(matrix, 1)
      @inbounds newvector[row] += matrix[row, column]*vector[column]
    end
  end
end

# Will call `compressed_multiply` and `uncompressed_multiply` depending on the
# matrix it gets in.
function multiply!(matrix::m, vector::v, newvector::v)
  # Determine whether or not the matrix is compressed
  is_compressed = size(matrix, 2) != size(matrix, 1)

  # Intialize the new vector with zeros
  fill!(newvector, 0.0)

  # Call the function you need to call!
  if is_compressed
    compressed_multiply!(matrix, vector, newvector)
  else
    uncompressed_multiply!(matrix, vector, newvector)
  end

  # Newvector becomes vector, and vector bcomes space for newvector
  return (newvector, vector)
end

end
