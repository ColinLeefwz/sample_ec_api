Order.delete_all
User.delete_all
Product.delete_all

# user with password=123123
user = User.create!(name: 'colin', email: 'lilonglongfwz@gmail.com', password: '123123')

# products
product1 = Product.create!(name: 'product1', brand: 'brand1', price: 12_000, stock: 12)
product2 = Product.create!(name: 'product2', brand: 'brand1', price: 11_000, stock: 1)
product3 = Product.create!(name: 'product3', brand: 'brand1', price: 10_000, stock: 2)
product4 = Product.create!(name: 'product4', brand: 'brand1', price: 13_000, stock: 1)

# orders
Order.create!(user: user, product: product1, ready_at: Time.now)
Order.create!(user: user, product: product2, ready_at: Time.now)
Order.create!(user: user, product: product3, ready_at: Time.now)
Order.create!(user: user, product: product4, ready_at: Time.now)
