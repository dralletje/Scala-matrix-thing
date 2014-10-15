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

function normalize(vector::v)
  m, i = findmax(vector)
  map(x -> x/m, vector)
end

function normalize!(vector::v)
  @time m, i = findmax(vector)
  println("Findmax\n")
  for k=1:length(vector)
    vector[k] = vector[k] / m
  end
  println("Map\n")
  return vector
end

function keer(matrix::m, row::Integer, vector::v)
  sum([matrix[i, row]*vector[i] for i=1:size(matrix, 2)])
end

function keer(matrix::m, vector::v)
  [keer(matrix, i, vector) for i=1:size(matrix, 1)]
end

# Mutationing
function keer!(matrix::m, vector::v, newvector::v)
  #println("\n=========")
  for i=1:size(matrix, 1)
    newvector[i] = 0.0
    #println(@sprintf "New row: %d" newvector[i])
    for k=1:size(matrix, 2)
      #println(newvector[i])
      #println(@sprintf "Doing %f * %f" matrix[k, i] vector[i])
      newvector[i] += vector[k]*matrix[k, i]
      #println(newvector[i])
    end
  end
  return (newvector, vector) # Newvector becomes vector, and vector bcomes space for newvector
end
