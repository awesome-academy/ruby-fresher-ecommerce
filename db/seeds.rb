User.create!(
  name: "Sample User",
  email: "test-user@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  role: 1,
  activated: true,
  activated_at: Time.zone.now
)

30.times do |n|
  name = Faker::Name.name
  email = "user-email#{n + 1}@rails.com"
  password = "123456"
  User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now
  )
end

Category.create!(
  title: "Demo",
  father_id: nil
)

@no_of_product = 30
@no_of_product.times do |n|
  Product.create!(
    name: Faker::Device.unique.model_name,
    manufacturer: Faker::Device.manufacturer,
    detail: "Product #{n + 1} detail",
    quantity: Faker::Number.within(range: 5..20),
    price: Faker::Number.within(range: 10..30) * 1000000,
    category_id: 1
  )
end

30.times do |n|
  DeliveryAddress.create!(
    name: Faker::Name.unique.name,
    phone: Faker::PhoneNumber.phone_number,
    address: Faker::Address.full_address,
    user_id: User.all.ids.sample
  )
end

5.times do |n|
  DeliveryAddress.create!(
    name: Faker::Name.unique.name,
    phone: Faker::PhoneNumber.phone_number,
    address: Faker::Address.full_address,
    user_id: 1
  )
end

def fake_order_for_user user
  order = Order.new(
    status: Faker::Number.within(range: 0..4),
    created_at: Faker::Time.between(from: DateTime.now - 100, to: DateTime.now),
    delivery_address_id: user.delivery_addresses.sample.id,
    user_id: user.id
  )
  total = 0
  Faker::Number.within(range: 1..6).times do |n|
    detail = order.order_details.build(
      product_id: Faker::Number.within(range: 1..@no_of_product),
      quantity: Faker::Number.within(range: 1..3),
      price: Faker::Number.within(range: 10..30) * 1000000
    )
    total += detail.quantity * detail.price
  end
  order.shipping = Settings.order.shipping_cost_default
  total += order.shipping
  order.total = total
  order.note = "note"
  order.save
end

7.times do |n|
  fake_order_for_user(User.find_by id: 1)
end

40.times do |n|
  user = User.all.sample
  next unless user.delivery_addresses.count > 0

  fake_order_for_user user
end
