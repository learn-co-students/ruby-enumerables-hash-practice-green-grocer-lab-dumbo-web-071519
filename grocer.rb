def consolidate_cart(cart)
  hash ={}
  array.each do |item|
    if hash [item.keys[0]]
      hash[item.keys[0]] [:count] += 1
      else new_hash[item.keys[0]] = {
      count: 1, 
      price: item.values[0] [:price],
      clearance: item.values[0] [:clearance]
    }
end

def apply_coupons(cart, coupons)
    coupons.each do |coupon|
    if cart.keys.include? coupon[:item]
      if cart[coupon[:item]][:count] >= coupon[:num]
      sale_item = "#{coupon[:item]} W/COUPON"
      if cart[sale_item]
        cart[sale_item] [:count] += coupon[:num]
      else cart[sale_item] = {
        price: coupon[:cost] / coupon[:num],
        clearance: cart[coupon[:item]][:clearance],
        count: coupon[:num]
      }
    end
    cart[coupon[:item]][:count] -= coupon[:num]
    end
  end
end
cart
end

def apply_clearance(cart)
  cart.keys.each do |item|
    if cart[item][:clearance]
      cart[item][:price] = (cart[item][:price]*0.80).round(2)
    end 
  end 
  cart
end

def checkout(cart, coupons)
  console = consolidate_cart(cart)
  coupons_app = apply_coupons(console, coupons)
  discount_app = apply_clearance(coupons_app)
  
  total = 0.0 
  discount_app.keys.each do |item|
    total += discount_app[item][:price]*discount_app[item][:count]
  end
  total > 100.00 (total * 0.90).round : total 
end
