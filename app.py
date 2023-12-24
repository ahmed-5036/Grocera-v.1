from flask import Flask, request, jsonify, abort, session
from flask_mail import Mail, Message
import mysql.connector
import bcrypt
import uuid

app = Flask(__name__)
app.secret_key = 'supersecretkey'

# MySQL database configuration
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': 'root',
    'database': 'grocery_store',
    'raise_on_warnings': True,
}

# email configuration
app.config['MAIL_SERVER'] = 'smtp.gmail.com'
app.config['MAIL_PORT'] = 587
app.config['MAIL_USE_TLS'] = True
app.config['MAIL_USE_SSL'] = False
app.config['MAIL_USERNAME'] = 'grocerystore33@gmail.com'
app.config['MAIL_PASSWORD'] = '3just_2023'

mail = Mail(app)
# Create a MySQL connection and cursor
connection = mysql.connector.connect(**db_config)
cursor = connection.cursor()

# Create the users table
cursor.execute("""
    CREATE TABLE IF NOT EXISTS users (
        email VARCHAR(255) PRIMARY KEY,
        password VARCHAR(255) NOT NULL,
        first_name VARCHAR(255) NOT NULL,
        last_name VARCHAR(255) NOT NULL,
        date_of_birth DATE,
        address VARCHAR(255) NOT NULL,
        user_token VARCHAR(255) UNIQUE NOT NULL,
        otp INT,
        otp_expiration TIMESTAMP,
        otp_change_allowed BOOLEAN DEFAULT FALSE
    )
""")

# Create the products table
cursor.execute("""
    CREATE TABLE IF NOT EXISTS products (
        product_id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        brand VARCHAR(255) NOT NULL,
        price DECIMAL(10, 2) NOT NULL,
        nationality VARCHAR(255),
        expiry_date DATE,
        product_image VARCHAR(255)
    )
""")

# Create the shopping_carts table
cursor.execute("""
    CREATE TABLE IF NOT EXISTS shopping_carts (
        cart_id INT AUTO_INCREMENT PRIMARY KEY,
        user_id VARCHAR(255) UNIQUE,
        FOREIGN KEY (user_id) REFERENCES users(email)
    )
""")

# Create the cart_items table
cursor.execute("""
    CREATE TABLE IF NOT EXISTS cart_items (
        cart_item_id INT AUTO_INCREMENT PRIMARY KEY,
        cart_id INT,
        product_id INT,
        quantity INT NOT NULL,
        FOREIGN KEY (cart_id) REFERENCES shopping_carts(cart_id),
        FOREIGN KEY (product_id) REFERENCES products(product_id)
    )
""")

# Create the orders table
cursor.execute("""
    CREATE TABLE IF NOT EXISTS orders (
        order_id INT AUTO_INCREMENT PRIMARY KEY,
        user_id VARCHAR(255),
        order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(email)
    )
""")

# Create the order_details table
cursor.execute("""
    CREATE TABLE IF NOT EXISTS order_details (
        order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
        order_id INT,
        product_id INT,
        quantity INT NOT NULL,
        total_cost DECIMAL(10, 2) NOT NULL,
        FOREIGN KEY (order_id) REFERENCES orders(order_id),
        FOREIGN KEY (product_id) REFERENCES products(product_id)
    )
""")

# Commit changes to the database
connection.commit()

# Close the cursor and database connection
cursor.close()
connection.close()

# Registration Endpoint
@app.route('/api/register', methods=['POST'])
def register():
    data = request.json
    email = data.get('email')
    password = data.get('password')
    first_name = data.get('first name')
    last_name = data.get('last name')
    address = data.get('address')
    birthdate = data.get('birthdate')
    usertoken = str(uuid.uuid4())

    connection = mysql.connector.connect(**db_config)
    cursor = connection.cursor()

    try:
        cursor.execute("SELECT * FROM users WHERE email = %s", (email,))
        user = cursor.fetchone()

        if user:
            return jsonify({'error': 'Email is already registered'}), 400

        hashed_password = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())

        cursor.execute("""
            INSERT INTO users (email, password, first_name, last_name, address, birthdate, usertoken)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """, (email, hashed_password, first_name, last_name, address, birthdate, usertoken))

        connection.commit()
        return jsonify({'message': 'Registration successful! Please check your email for verification.'}), 201

    finally:
        cursor.close()
        connection.close()

# Login Endpoint
@app.route('/api/login', methods=['POST'])
def login():
    data = request.json
    email = data.get('email')
    password = data.get('password')

    connection = mysql.connector.connect(**db_config)
    cursor = connection.cursor()

    try:
        cursor.execute("SELECT * FROM users WHERE email = %s", (email,))
        user = cursor.fetchone()

        if user and bcrypt.checkpw(password.encode('utf-8'), user[1].encode('utf-8')):
            return jsonify({'message': 'Login successful!', 'body': user[6]}), 200
        else:
            return jsonify({'error': 'Invalid email or password'}), 401

    finally:
        cursor.close()
        connection.close()
if __name__ == '__main__':
    app.run(debug=True)
