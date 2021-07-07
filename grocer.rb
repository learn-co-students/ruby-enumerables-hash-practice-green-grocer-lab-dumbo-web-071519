def consolidate_cart(cart)
  new_hash = {}
  cart.map{|i| 
   i.each{|key, value|
     if new_hash[key]
       new_hash[key][:count] += 1
     else
       new_hash[key] = value
       new_hash[key][:count] = 1
     end }}
 new_hash
end

def apply_coupons(cart, coupons)
 if coupons.length!=0
   for i in coupons
     if cart.include?(i[:item]) && cart[i[:item]][:count] >= i[:num]
       cart[i[:item] + " W/COUPON"] = {price: i[:cost]/i[:num]}
       cart[i[:item] + " W/COUPON"][:clearance] = cart[i[:item]][:clearance]
       cart[i[:item] + " W/COUPON"][:count] = cart[i[:item]][:count] / i[:num] * i[:num]
       cart[i[:item]][:count] -= cart[i[:item] + " W/COUPON"][:count]
     end
   end
 end
 return cart
end


def apply_clearance(cart)
 cart.each {|key, value|
   if value[:clearance]
     cart[key][:price] = cart[key][:price] - cart[key][:price] * 20 / 100
   end }
 cart
end

def checkout(cart, coupons)
  total = 0
  consolidate = consolidate_cart(cart)
  after_coupons = apply_coupons(consolidate,coupons)
  after_discounts = apply_clearance(after_coupons)
  after_discounts.each{|key,value| total += value[:price] * value[:count]}
  if total > 100
    total = total - total * 10 / 100
  end
  return total
end
