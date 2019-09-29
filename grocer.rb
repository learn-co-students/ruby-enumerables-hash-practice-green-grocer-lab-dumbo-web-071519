def consolidate_cart(cart)
  # code here
  #count each instance of an item 
  #return hash with item and count
  myHash = {}
  #puts "CONSOLIDATE 1 #{cart}"
  cart.each do |hash| 
    #puts "CONSOLIDATE 2 #{hash}"
    hash.each do |key, value|
    #puts "CONSOLIDATE 3 : the hash key is #{key} and the value is #{value}"
      if myHash.key?(key)
        myHash[key][:count] += 1
      else
        myHash[key] = value
        myHash[key][:count] = 1
      end
    end
  end
  return myHash
end

#def findSaleItem(key, value, coupons)
#  #puts coupons
#  if value[:clearance] == true
#      return coupons.select{|hash| hash[:item] == key}
#  end
#end

def apply_coupons(cart, coupons)

  coupons.each do |coupon|
    productName = coupon[:item]
    if cart.key?(productName)
      #puts "EXISTS"
      product = cart.select{|item| item == productName}
      
      name = productName + " W/COUPON"
      saleInfo = {} #product[productName]
      if cart.key?(name)
        saleInfo = cart[name]
      else

        salePrice = coupon[:cost] / coupon[:num]
        saleQuantity = coupon[:num]
        numInCart = cart[productName][:count]
        
        saleInfo[:price] = salePrice
        #puts '%.2f' % saleInfo[:price]
        #puts saleInfo[:price]
        saleInfo[:clearance] = cart[productName][:clearance]
        saleInfo[:count] = saleQuantity

        if numInCart > saleQuantity
          saleMultiplyer = numInCart/saleQuantity.to_i
          saleInfo[:count] = saleQuantity * saleMultiplyer
        elsif numInCart < saleQuantity
            saleInfo[:count] = 0
        end
        cart[productName][:count] = numInCart % saleQuantity
      end
      
      cart[name] = saleInfo
    end
   end
  return cart
end

def apply_clearance(cart)
  # code here
  cart.each do |product, productInfo|
    if productInfo[:clearance] == true
      price = productInfo[:price]
      clearance = 0.8
      clearancePrice = price * clearance
      productInfo[:price] = clearancePrice.round(2)
    end
  end
  return cart
end

def checkout(cart, coupons)
  # code here
  total = 0
  consolidated_cart =consolidate_cart(cart)
  finalCart = apply_clearance(apply_coupons(consolidated_cart, coupons))
  finalCart.each do |item, value|
    #puts item
    #puts value
    itemTotal = value[:price] * value[:count]
    total += itemTotal
  end
  if total > 100
    discount = total*0.1
    total = total - discount
  end
  #puts finalCart
  return total
end
