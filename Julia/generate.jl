module Generate

export matrix, compress

const possibits = [0x02 ^ x for x = 0:7]
const COMPRESS = true

function random_uint8(uint8)
  return rand(Bool) ? uint8 : 0x0
end

function generate_byte()
  x = 0x00
  for i in 1:length(possibits)
    x = x | random_uint8(possibits[i])
  end
  return x
end

function matrix(si_ze)
  if COMPRESS
    [generate_byte() for x in 1:si_ze, y in 1:si_ze/8]
  else
    [rand(Bool) ? 0x1 : 0x0 for x in 1:si_ze, y in 1:si_ze]
  end
end

function compress_vector(vector)
  x = 0x00
  for i in 1:size(possibits, 1)
    x = x | (vector[i] * possibits[i])
  end
  return x
end

function compress(matrix::Array{Bool, 2})
  if !COMPRESS
    return [x ? 0x1 : 0x0 for x = matrix]
  end

  if size(matrix, 1) % 8 != 0
    return []
  end

  [ compress_vector(matrix[row, (column*8)+1:(column+1)*8])
    for row in 1:size(matrix, 1),
        column in 0:div(size(matrix, 2), 8)-1
  ]
end

end
