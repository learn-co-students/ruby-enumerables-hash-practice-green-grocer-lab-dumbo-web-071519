require 'pry'

def consolidate_cart(cart)
  # code here
  result = {}   #return a new array with item count
  
  cart.each do |item_hash|  #iterate through cart to search for duplicates  
    item_hash.each do |product, info|   #use .each loop to access hash information
      if result[product]
        result[product][:count] += 1    #create count and edit as deemed necessary
      else
        result[product] = info
        result[product][:count] = 1
      end
    end
  end
  result
end

def apply_coupons(cart, coupons)
  # code here
  result = {}
  
  cart.each do |item_hash, info|  #iterate through the cart items
  
    coupons.each do |coupon|      #iterate with coupons information
    
      if item_hash == coupon[:item] && info[:count] >= coupon[:num]
        info[:count] = info[:count] - coupon[:num]
        
        if result["#{item_hash} W/COUPON"]
          result["#{item_hash} W/COUPON"][:count] += coupon[:num]
        else
        result["#{item_hash} W/COUPON"] = {:price => (coupon[:cost] / coupon[:num]), :clearance => info[:clearance], :count => coupon[:num]}
        end
        
      end
      
    end
    
    result[item_hash] = info
  end
  
  print result
  result
end

def apply_clearance(cart)
  
  discount = 0.20
  
  cart.each do |product, info|
    
    if cart[product][:clearance] == true
      
      cart[product][:price] -= cart[product][:price] * discount
    end
    
  end

end


# The `checkout` method will need to utilize all the previous methods we've
# written. It consolidates the cart, applies coupons, and applies discounts. Then,
# it totals the cost of the entire cart, accounting for each item and their
# prices, and returns this value.

# When writing this method, make sure to address each step in the proper order:

# - Consolidate the cart array into a hash

# - Apply coupon discounts if the proper number of items are present

# - Apply 20% discount if items are on clearance

# In addition to coupons and clearance, our grocer store offers a deal for
# customers buying lots of items: if, after all coupons and discounts, the cart's
# total is over $100, the customer gets an additional 10% off. Apply this
# discount when appropriate.
def checkout(cart, coupons)
  
  total = 0
  
  #binding.pry
  cart = consolidate_cart(cart)
  #binding.pry
  if cart.length == 1
    cart = apply_coupons(cart, coupons)
    cart_clearance = apply_clearance(cart)
    if cart_clearance.length > 1
      cart_clearance.each do |items, details|
        if details[:count] >=1
          total += (details[:price]*details[:count])
        end
      end
    else
      cart_clearance.each do |item, details|
        total += (details[:price]*details[:count])
      end
    end
  else
    cart = apply_coupons(cart, coupons)
    cart_clearance = apply_clearance(cart)
    cart_clearance.each do |item, details|
      total += (details[:price]*details[:count])
    end
  end
  
  #binding.pry
  if total > 100
    total = total*(0.90)
  end
  total
end
