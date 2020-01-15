def consolidate_cart(cart)
   cart_0 = cart.reduce({}) do |memo, item|
     if memo.key?(item.keys[0])
       memo[item.keys[0]][:count] += 1
     else
       memo[item.keys[0]] = item.values[0]
       memo[item.keys[0]][:count] = 1
     end
    memo
   end
  cart_0
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
 cart
end

def apply_clearance(cart)
  clearance_cart = cart.each do |(key, value)|
    if(value[:clearance])
     value[:price] = (value[:price] * (0.800)).round(2)
    end
  end
clearance_cart
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
total
end
