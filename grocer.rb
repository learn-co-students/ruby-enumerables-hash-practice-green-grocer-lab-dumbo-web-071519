def consolidate_cart(cart)
  newHash = {}
  cart.each do |item|
    if newHash[item.keys[0]]
      newHash[item.keys[0]][:count] += 1
    else
      newHash[item.keys[0]] = {
        count: 1,
        price: item.values[0][:price],
        clearance: item.values[0][:clearance]
      }
    end
  end
  newHash
end
        

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    if cart.keys.include? coupon[:item]
      if cart[coupon[:item]][:count] >= coupon[:num]
        addedCouponName = "#{coupon[:item]} W/COUPON"
        if cart[addedCouponName]
          cart[addedCouponName][:count] += coupon[:num]
        else
          cart[addedCouponName] = {
            count: coupon[:num],
            price: coupon[:cost]/coupon[:num],
            clearance: cart[coupon[:item]][:clearance]
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
  organizedCart = consolidate_cart(cart)
  couponedCart = apply_coupons(organizedCart, coupons)
  clearancedCart = apply_clearance(couponedCart)
  
  total = 0.00
  clearancedCart.keys.each do |item|
    total += clearancedCart[item][:price]*clearancedCart[item][:count]
  end
  total > 100.00 ? (total * 0.90).round :
  total
end
