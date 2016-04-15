###
#
# Functions :-D
#
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
      newvector[i] += matrix[k, i]*vector[k]
    end
  end
  return (newvector, vector) # Newvector becomes vector, and vector bcomes space for newvector
end
