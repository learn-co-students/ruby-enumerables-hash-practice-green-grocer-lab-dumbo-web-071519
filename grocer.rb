def consolidate_cart(cart)
  # code here
 cart_obj = cart.reduce({}) do |memo, item|
    if memo.key?(item.keys[0])
      memo[item.keys[0]][:count] += 1
    else
      memo[item.keys[0]] = item.values[0]
      memo[item.keys[0]][:count] = 1
    end
  memo
  end
  return cart_obj
end

def apply_coupons(cart, coupons)
  if (coupons != [])
    coupon_hash = coupons.reduce({}) do |memo, hash|
      current = hash[:item]
      if memo.key?(current)
        memo[current][:coupon_count] += 1
      else
        memo[current] = {
          cost: hash[:cost],
          num: hash[:num],
          coupon_count: 1
        }
      end
      memo
    end
    coupon_hash.each do |(key, value)|
      if cart.key?(key)
        #save key to variable
        key_to_change = key
        #save price by dividing cost by number of items
        price = value[:cost] / value[:num]
        #get new key tpo push to cart hash
        new_key = "#{key} W/COUPON"
        #get amount of qualifying items by dividing number of items in cart by number of items coupon applies to
        qualifying_coupon_applications = cart[key_to_change][:count]/ value[:num]
        leftover = cart[key_to_change][:count] % value[:num]
        if qualifying_coupon_applications < 1
          break
        else
          # Check this method out in the future
          cart[new_key] = {
            clearance: cart[key_to_change][:clearance],
            price: price,
            count: cart[key_to_change][:count] - leftover
          }
          #cart[new_key][:count] = qualifying_coupon_applications * value[:coupon_count]
          cart[key_to_change][:count] = leftover
        end
      end
    end
  end
  #puts coupon_hash
  #***memo[key] = value
return cart
end


def apply_clearance(cart)
  # code here
  clearance_cart = cart.each do |(key, value)|
    if(value[:clearance])
     value[:price] = (value[:price] * (0.800)).round(2)
    end
  end
  return clearance_cart
end

def checkout(cart, coupons)
  # code here
  consolidated = consolidate_cart(cart)
  coupons_applied = apply_coupons(consolidated, coupons)
  clearance_applied = apply_clearance(coupons_applied)
  sub_total = clearance_applied.reduce(0) do |memo, (key, value)|
    memo += (value[:price] * value [:count]).round(2)
    memo
  end
  if sub_total > 100
    final_total = (sub_total * 0.90).round(2)
  else
    final_total = sub_total
  end
  return final_total
end

=begin
items =	[
		{"AVOCADO" => {:price => 3.00, :clearance => true}},
    {"AVOCADO" => {:price => 3.00, :clearance => true}},
		{"KALE" => {:price => 3.00, :clearance => false}},
		{"BLACK_BEANS" => {:price => 2.50, :clearance => false}},
		{"ALMONDS" => {:price => 9.00, :clearance => false}},
		{"TEMPEH" => {:price => 3.00, :clearance => true}},
		{"CHEESE" => {:price => 6.50, :clearance => false}},
		{"BEER" => {:price => 13.00, :clearance => false}},
		{"PEANUTBUTTER" => {:price => 3.00, :clearance => true}},
		{"BEETS" => {:price => 2.50, :clearance => false}}
	]
  coupons = [
  		{:item => "AVOCADO", :num => 2, :cost => 5.00},
  		{:item => "AVOCADO", :num => 2, :cost => 5.00},
  		{:item => "BEER", :num => 2, :cost => 20.00},
    ]


 checkout(items, coupons)
=end
