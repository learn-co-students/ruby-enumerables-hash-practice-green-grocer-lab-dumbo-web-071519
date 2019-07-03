def consolidate_cart(cart)
 
  ### using reduce to return a single hash of all items
  cart.reduce({}) { |memo, item|
    ### using each to acess all of the inner hash
    item.each { |(key, value)|
      memo[key] = value
      ### if count doesn't already exist, add it and set it to one
      if !memo[key][:count]
        memo[key][:count] = 1 
      ### if count does exist, accumilated it by one
      else
        memo[key][:count] += 1
      end
    }
    memo
  }
end

def apply_coupons(cart, coupons)
  coupons.each { |coupon|
  
    ### variable setup for readablity 
    item_name = coupon[:item]
    
    ### if this coupon can be applied AND we have enough items for it to apply
    if cart.keys.include?(item_name) && (cart[item_name][:count] >= coupon[:num])
      
      ### if we already used the same coupon, update existing hash
      if cart["#{item_name} W/COUPON"]
        cart["#{item_name} W/COUPON"][:count] += coupon[:num]
      ### if this is our first time using, create a new hash
      else
        cart["#{item_name} W/COUPON"] = {
          count: coupon[:num],
          price: coupon[:cost]/coupon[:num].to_f,
          clearance: cart[item_name][:clearance]
        }
      end
      
      ### update the count in our cart now that a coupon is applied
      cart[item_name][:count] -= coupon[:num]
    end
  }
  cart
end

def apply_clearance(cart)
  cart.keys.each {|item|
    if cart[item][:clearance]
      cart[item][:price] = (cart[item][:price]*0.8).round(2)
    end
  }
  cart
end

def checkout(cart, coupons)
  ### calls all respective functions
  checkout_cart = consolidate_cart(cart)
  checkout_cart = apply_coupons(checkout_cart, coupons)
  checkout_cart = apply_clearance(checkout_cart)
  ### uses reduce to find total
  total_price = checkout_cart.reduce(0) {|total, (key, value)|
    total += checkout_cart[key][:price] * checkout_cart[key][:count]
  }
  ### if the toal price is over $100, applies 10% coupon, else returns same value
  total_price = total_price > 100.0 ? total_price*0.9 : total_price
end
