json.array! @products do |product|
  json.id product.id
  json.text "#{product.name} - #{product.code}"
  json.name product.name
  json.code product.code
end