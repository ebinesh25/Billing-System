json.extract! bill, :id, :customer_email, :customer_amount, :created_at, :updated_at
json.url bill_url(bill, format: :json)
