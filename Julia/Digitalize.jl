module Digitalize

function create()
  return Dict(
    "options" => Dict{AbstractString, Array{AbstractString, 1}}(),
    "prohibit" => Dict{AbstractString, }
end

function addIndex(builder, name, items)
  builder["options"][name] = items
end

function build_entries(builder)

end

end
