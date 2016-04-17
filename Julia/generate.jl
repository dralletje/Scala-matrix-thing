module Generate

export matrix, compress

# "00000001" to "10000000"
const possibits = [0x02 ^ x for x = 0:7]

# Switch to easily compare 8-per-byte and 1-per-byte
const COMPRESS = true

# Return 0x0 or the thing you pass in
function zero_or(uint8)
  return rand(Bool) ? uint8 : 0x0
end

# Generate 1 byte (8 bits) of randomness
function generate_byte()
  x = 0x00
  for i in 1:length(possibits)
    x = x | zero_or(possibits[i])
  end
  return x
end

# Generate a random matrix
function matrix(si_ze)
  if COMPRESS
    # Either with /8 the width, 8 values inside one byte
    [generate_byte() for x in 1:si_ze, y in 1:si_ze/8]
  else
    # Or just using a UInt8 for every value
    [rand(Bool) ? 0x1 : 0x0 for x in 1:si_ze, y in 1:si_ze]
  end
end

# Take an Array{Bool, 2} and turn it into a Array{UInt8, 2} with 8 values packed
# in every UInt8
function compress(matrix::Array{Bool, 2})
  if !COMPRESS
    return [x ? 0x1 : 0x0 for x = matrix]
  end

  if size(matrix, 1) % 8 != 0
    return []
  end

  [ compress(vec(matrix[row, (column*8)+1:(column+1)*8]))
    for row in 1:size(matrix, 1),
        # Only 1/8'th of the column required
        column in 0:div(size(matrix, 2), 8)-1
  ]
end

# Take an Array{Bool, 1} with length 8 and turn it into one UInt8 representing the same bits
function compress(vector::Array{Bool, 1})
  x = 0x00
  for i in 1:length(possibits)
    # True = 0x1 and false = 0x0 so we can just multiply
    x = x | (vector[i] * possibits[i])
  end
  return x
end

end
