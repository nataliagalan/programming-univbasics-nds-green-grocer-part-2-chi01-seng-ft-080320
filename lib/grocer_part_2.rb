require_relative './part_1_solution.rb'
require 'pry'

def apply_coupons(cart, coupons)
  # cart = [{:item=>"AVOCADO", :price=>3.0, :clearance=>true, :count=>2}]
  # coupons = [{:item=>"AVOCADO", :num=>2, :cost=>5.0}]

  coupons_index = 0

  while coupons_index < coupons.size do #coupons.size = 1
    current_coupon = coupons[coupons_index] #assign the value of current_coupon to each coupon (coupon at x index)
    applicable_for_discount = find_item_by_name_in_collection( current_coupon[:item], cart )
      if ( applicable_for_discount[:count] / current_coupon[:num] >= 1 ) #if <count per item> div by <coupon num> is greater than or equal to 1
        cart.push( {:item => "#{current_coupon[:item]} W/COUPON",     #then add this HASH to cart ARRAY. Update item name to "NAME W/COUPON"
                    :price => (current_coupon[:cost] / current_coupon[:num]).round(2), #update price by dividing <coupon cost> by <coupon num> and round that to nearest 2 decimal digits
                    :clearance => applicable_for_discount[:clearance], #update clearance state
                    :count => applicable_for_discount[:count] - (applicable_for_discount[:count] % current_coupon[:num])} ) #subtract the remainder of <item count> / <coupon num> from <item count>
                                                                                                                            #in order to update count and only show price per individual item
        applicable_for_discount[:count] %= current_coupon[:num] #makes applicable_for_discount[:count] = remainder of operation
      end
    coupons_index += 1
  end
  cart #returns updated cart array
end

def apply_clearance(cart)
  cart_index = 0
  ready_for_checkout = []

  while cart_index < cart.size do
    current_item = cart[cart_index]
    if (current_item[:clearance])
      current_item[:price] = current_item[:price] - ( current_item[:price] * 0.20 )
    end
    ready_for_checkout.push( current_item )
    cart_index += 1
    binding.pry
  end
  ready_for_checkout #returns a new Array where every unique item in the original is present but with its price reduced by 20% if its :clearance value is true
end


def checkout(cart, coupons)
  checkout = consolidate_cart( cart )
  checkout = apply_coupons( checkout, coupons )
  checkout = apply_clearance( checkout )

  index = 0
  grand_total = 0

  while index < checkout.size do
    current_item_total = checkout[index][:price] * checkout[index][:count]
    current_item_total.round(2)
    grand_total += current_item_total
    index += 1
  end
  if ( grand_total > 100 )
    grand_total *= 0.90
  end
  grand_total
end
