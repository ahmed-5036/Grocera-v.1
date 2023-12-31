from flask import Flask, request, jsonify, abort
from flask_cors import CORS
from flask_mail import Mail, Message
import mysql.connector
import bcrypt
import uuid
import random
from datetime import datetime, timedelta
from flask_apscheduler import APScheduler

app = Flask(__name__)
CORS(app=app)

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
app.config['MAIL_PASSWORD'] = 'bwxm ptvn fdrc oqie'
app.config['MAIL_DEFAULT_SENDER'] = 'grocerystore33@gmail.com'

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
        birthdate DATE,
        address VARCHAR(255) NOT NULL,
        usertoken VARCHAR(255) UNIQUE NOT NULL,
        otp INT,
        otp_expiration TIMESTAMP,
        otp_change_allowed BOOLEAN DEFAULT FALSE
    );
""")

# Create the brands table
cursor.execute("""
    CREATE TABLE IF NOT EXISTS brands (
        brand_name VARCHAR(255) PRIMARY KEY,
        brand_image VARCHAR(255)
    );
""")

# Create the products table
cursor.execute("""
    CREATE TABLE IF NOT EXISTS products (
        product_id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        brand_name VARCHAR(255) NOT NULL,
        price DECIMAL(10, 2) NOT NULL,
        expiry_date DATE,
        product_image VARCHAR(255),
        discount_percentage DECIMAL(5, 2) DEFAULT NULL,
        is_national BOOLEAN DEFAULT FALSE,
        num_of_buyers INT DEFAULT 0,
        FOREIGN KEY (brand_name) REFERENCES brands(brand_name)
    );
""")

# Create the shopping_carts table
cursor.execute("""
    CREATE TABLE IF NOT EXISTS shopping_carts (
        cart_id INT AUTO_INCREMENT PRIMARY KEY,
        user_id VARCHAR(255) UNIQUE,
        FOREIGN KEY (user_id) REFERENCES users(email)
    );
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
    );
""")

# Create the orders table
cursor.execute("""
    CREATE TABLE IF NOT EXISTS orders (
        order_id INT AUTO_INCREMENT PRIMARY KEY,
        user_id VARCHAR(255),
        order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(email)
    );
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
    );
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
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """, (email, hashed_password, first_name, last_name, address, birthdate, usertoken))

        # Create a new shopping cart for the user
        cursor.execute("""
                    INSERT INTO shopping_carts (user_id)
                    VALUES (%s)
                """, (email,))

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


# Forgot Password Endpoint
@app.route('/api/forgot_password', methods=['POST'])
def forgot_password():
    data = request.json
    email = data.get('email')

    connection = mysql.connector.connect(**db_config)
    cursor = connection.cursor()

    try:
        cursor.execute("SELECT * FROM users WHERE email = %s", (email,))
        user = cursor.fetchone()

        if user:
            # Generate a random 6-digit OTP
            otp = str(random.randint(100000, 999999))

            # Calculate the OTP expiration time (e.g., 15 minutes from now)
            otp_expiration = datetime.now() + timedelta(minutes=15)

            # Save the OTP and its expiration time in the database
            cursor.execute("""
                UPDATE users
                SET otp = %s, otp_expiration = %s
                WHERE email = %s
            """, (otp, otp_expiration, email))
            connection.commit()

            # Send the password reset email with the OTP
            send_password_reset_email(email, otp)

            return jsonify({'message': 'Password reset email sent. Please check your email.'}), 200
        else:
            return jsonify({'error': 'Email not found. Please enter a valid email address.'}), 404

    finally:
        cursor.close()
        connection.close()

# Enter OTP Endpoint
@app.route('/api/enter_otp/<email>', methods=['POST'])
def enter_otp(email):
    data = request.json
    entered_otp = data.get('otp')

    connection = mysql.connector.connect(**db_config)
    cursor = connection.cursor()

    try:
        cursor.execute("SELECT * FROM users WHERE email = %s", (email,))
        user = cursor.fetchone()

        if user:
            # Check if the entered OTP matches the one stored in the database
            if entered_otp == user[7] and datetime.now() < user[8]:
                # OTP is valid
                cursor.execute("""
                                UPDATE users
                                SET otp_change_allowed = TRUE
                                WHERE email = %s
                            """, (email, ))
                connection.commit()
                return jsonify({'message': 'OTP verification successful!'}), 201
            else:
                # OTP is either incorrect or expired
                abort(401, 'Invalid or expired OTP. Please try again.')

        else:
            # User not found
            abort(404, 'User not found. Please enter a valid email address.')

    finally:
        cursor.close()
        connection.close()

# Reset Password Endpoint
@app.route('/api/reset_password/<email>', methods=['POST'])
def reset_password(email):
    data = request.json
    new_password = data.get('new_password')

    connection = mysql.connector.connect(**db_config)
    cursor = connection.cursor()

    try:
        cursor.execute("SELECT * FROM users WHERE email = %s", (email,))
        user = cursor.fetchone()

        if user and user[9]:
            hashed_password = bcrypt.hashpw(new_password.encode('utf-8'), bcrypt.gensalt())
            cursor.execute("""
                UPDATE users SET password = %s, otp_change_allowed = FALSE WHERE email = %s
            """, (hashed_password, user[0]))
            connection.commit()

            return jsonify({'message': 'Password reset successful! You can now log in.'}), 203
        else:
            return jsonify({'error': 'Invalid or expired reset token. Please request a new password reset.'}), 401

    finally:
        cursor.close()
        connection.close()

# Expiry Discounts Endpoint
@app.route('/api/expiry_discounts', methods=['GET'])
def expiry_discounts():
    try:
        connection = mysql.connector.connect(**db_config)
        cursor = connection.cursor(dictionary=True)
        # Retrieve items with discounts
        cursor.execute("""
            SELECT * FROM products WHERE discount_percentage IS NOT NULL;
        """)
        discounted_items = cursor.fetchall()

        return jsonify({'expiry_discounts': discounted_items})

    except mysql.connector.Error as err:
        print(f"Database error: {err}")
        return jsonify({'error': 'Internal server error'}), 500

    finally:
        cursor.close()
        connection.close()

# National Products Endpoint
@app.route('/api/national_products', methods=['GET'])
def national_products():
    try:
        connection = mysql.connector.connect(**db_config)
        cursor = connection.cursor(dictionary=True)
        # Retrieve national products
        cursor.execute("""
            SELECT p.*, COUNT(DISTINCT o.user_id) AS user_count
            FROM products p
            LEFT JOIN order_details od ON p.product_id = od.product_id
            LEFT JOIN orders o ON od.order_id = o.order_id
            WHERE p.is_national = TRUE AND o.order_date >= NOW() - INTERVAL 24 HOUR
            GROUP BY p.product_id;
        """)
        national_items = cursor.fetchall()

        return jsonify({'national_products': national_items})

    except mysql.connector.Error as err:
        print(f"Database error: {err}")
        return jsonify({'error': 'Internal server error'}), 500

    finally:
        cursor.close()
        connection.close()

# Add a new route to retrieve all brands
@app.route('/api/brands', methods=['GET'])
def get_brands():
    try:
        connection = mysql.connector.connect(**db_config)
        cursor = connection.cursor(dictionary=True)
        cursor.execute("""
            SELECT * FROM brands;
        """)
        brands = cursor.fetchall()

        return jsonify({'brands': brands})

    except mysql.connector.Error as err:
        print(f"Database error: {err}")
        return jsonify({'error': 'Internal server error'}), 500

    finally:
        cursor.close()
        connection.close()

# Products by Brand Endpoint
@app.route('/api/brands/<brand>', methods=['GET'])
def get_products_by_brand(brand):
    try:
        connection = mysql.connector.connect(**db_config)
        cursor = connection.cursor(dictionary=True)
        # Retrieve products from the specified brand and count users who bought each product in the last 24 hours
        cursor.execute("""
                SELECT p.*, COUNT(DISTINCT o.user_id) AS user_count
                FROM products p
                LEFT JOIN order_details od ON p.product_id = od.product_id
                LEFT JOIN orders o ON od.order_id = o.order_id
                WHERE p.brand_name = %s AND o.order_date >= NOW() - INTERVAL 24 HOUR
                GROUP BY p.product_id;
            """, (brand,))
        products = cursor.fetchall()

        if not products:
            return jsonify({'error': f'No products found for brand: {brand}'}), 404

        return jsonify({'products': products})

    except mysql.connector.Error as err:
        print(f"Database error: {err}")
        return jsonify({'error': 'Internal server error'}), 500

    finally:
        cursor.close()
        connection.close()


# All Products Endpoint
@app.route('/api/all_products', methods=['GET'])
def get_all_products():
    try:
        connection = mysql.connector.connect(**db_config)
        cursor = connection.cursor(dictionary=True)
        # Retrieve all products and count users who bought each product in the last 24 hours
        cursor.execute("""
            SELECT p.*, COUNT(DISTINCT o.user_id) AS user_count
            FROM products p
            LEFT JOIN order_details od ON p.product_id = od.product_id
            LEFT JOIN orders o ON od.order_id = o.order_id
            WHERE o.order_date >= NOW() - INTERVAL 24 HOUR
            GROUP BY p.product_id;
        """)

        products = cursor.fetchall()

        return jsonify({'all_products': products})

    except mysql.connector.Error as err:
        print(f"Database error: {err}")
        return jsonify({'error': 'Internal server error'}), 500

    finally:
        cursor.close()
        connection.close()

@app.route('/api/most_bought_items', methods=['GET'])
def most_bought_items():
    try:
        connection = mysql.connector.connect(**db_config)
        cursor = connection.cursor(dictionary=True)
        # Retrieve the 10 most bought items in the last 24 hours
        cursor.execute("""
            SELECT p.*, COUNT(DISTINCT o.user_id) AS user_count
            FROM products p
            LEFT JOIN order_details od ON p.product_id = od.product_id
            LEFT JOIN orders o ON od.order_id = o.order_id
            WHERE o.order_date >= NOW() - INTERVAL 24 HOUR
            GROUP BY p.product_id
            ORDER BY user_count DESC
            LIMIT 10;
        """)

        most_bought_items = cursor.fetchall()

        if not most_bought_items:
            return jsonify({'error': 'No data found'}), 404

        return jsonify({'most_bought_items': most_bought_items})

    except mysql.connector.Error as err:
        print(f"Database error: {err}")
        return jsonify({'error': 'Internal server error'}), 500

    finally:
        cursor.close()
        connection.close()

@app.route('/api/filter', methods=['GET'])
def filter_products():
    try:
        connection = mysql.connector.connect(**db_config)
        cursor = connection.cursor(dictionary=True)

        # Get filter parameters from the query string
        brand = request.args.get('brand')
        min_price = request.args.get('min_price')
        max_price = request.args.get('max_price')
        is_national = request.args.get('is_national')

        # Build the SQL query based on the filter parameters
        query = """
            SELECT p.*, COUNT(DISTINCT o.user_id) AS user_count
            FROM products p
            LEFT JOIN order_details od ON p.product_id = od.product_id
            LEFT JOIN orders o ON od.order_id = o.order_id
            WHERE o.order_date >= NOW() - INTERVAL 24 HOUR
        """

        if brand:
            query += f" AND p.brand_name = '{brand}'"

        if min_price:
            query += f" AND p.price >= {min_price}"

        if max_price:
            query += f" AND p.price <= {max_price}"

        if is_national:
            is_national_bool = is_national.lower() == 'true'
            query += f" AND p.is_national = {is_national_bool}"

        query += " GROUP BY p.product_id;"

        # Execute the SQL query
        cursor.execute(query)
        filtered_products = cursor.fetchall()

        if not filtered_products:
            return jsonify({'error': 'No products found with the given filters'}), 404

        # Return the result as JSON
        return jsonify({'filtered_products': filtered_products})

    except mysql.connector.Error as err:
        print(f"Database error: {err}")
        return jsonify({'error': 'Internal server error'}), 500

    finally:
        cursor.close()
        connection.close()


# Add to Cart Endpoint
@app.route('/api/add_to_cart', methods=['POST'])
def add_to_cart():
    try:
        connection = mysql.connector.connect(**db_config)
        cursor = connection.cursor(dictionary=True)

        data = request.json
        user_id = data.get('user_id')
        product_id = data.get('product_id')
        quantity = data.get('quantity')

        # Check if the user has an existing shopping cart
        cursor.execute("SELECT * FROM shopping_carts WHERE user_id = %s", (user_id,))
        shopping_cart = cursor.fetchone()

        if not shopping_cart:
            # Create a new shopping cart for the user
            cursor.execute("INSERT INTO shopping_carts (user_id) VALUES (%s)", (user_id,))
            connection.commit()

        # Get the shopping cart ID
        cursor.execute("SELECT * FROM shopping_carts WHERE user_id = %s", (user_id,))
        shopping_cart = cursor.fetchone()
        cart_id = shopping_cart['cart_id']

        # Add the product to the cart or update the quantity if it already exists
        cursor.execute("""
            INSERT INTO cart_items (cart_id, product_id, quantity)
            VALUES (%s, %s, %s)
            ON DUPLICATE KEY UPDATE quantity = quantity + VALUES(quantity);
        """, (cart_id, product_id, quantity))

        connection.commit()

        return jsonify({'message': 'Product added to cart successfully'}), 200

    except mysql.connector.Error as err:
        print(f"Database error: {err}")
        return jsonify({'error': 'Internal server error'}), 500

    finally:
        cursor.close()
        connection.close()

@app.route('/api/remove_from_cart', methods=['POST'])
def remove_from_cart():
    try:
        connection = mysql.connector.connect(**db_config)
        cursor = connection.cursor()

        data = request.json
        user_email = data.get('user_email')
        product_id = data.get('product_id')

        # Check if the user and product exist
        cursor.execute("SELECT * FROM users WHERE email = %s", (user_email,))
        user = cursor.fetchone()

        cursor.execute("SELECT * FROM products WHERE product_id = %s", (product_id,))
        product = cursor.fetchone()

        if not user or not product:
            return jsonify({'error': 'User or product not found'}), 404

        # Check if the product is in the cart
        cursor.execute("""
            SELECT * FROM cart_items
            WHERE cart_id = (SELECT cart_id FROM shopping_carts WHERE user_id = %s)
            AND product_id = %s
        """, (user_email, product_id))
        existing_item = cursor.fetchone()

        if existing_item:
            # Remove the item from the cart
            cursor.execute("""
                DELETE FROM cart_items
                WHERE cart_item_id = %s
            """, (existing_item[0],))

            connection.commit()
            return jsonify({'message': 'Item removed from the cart successfully'}), 200
        else:
            return jsonify({'error': 'Item not found in the cart'}), 404

    except mysql.connector.Error as err:
        print(f"Database error: {err}")
        return jsonify({'error': 'Internal server error'}), 500

    finally:
        cursor.close()
        connection.close()

# Add a new route for payment simulation
@app.route('/api/payment', methods=['POST'])
def simulate_payment():
    try:
        connection = mysql.connector.connect(**db_config)
        cursor = connection.cursor()

        data = request.json
        email = data.get('email')

        # Retrieve the user's shopping cart items
        cursor.execute("""
            SELECT ci.product_id, ci.quantity, p.price
            FROM cart_items ci
            JOIN products p ON ci.product_id = p.product_id
            WHERE ci.cart_id = (SELECT cart_id FROM shopping_carts WHERE user_id = %s)
        """, (email,))
        cart_items = cursor.fetchall()

        if not cart_items:
            return jsonify({'error': 'Shopping cart is empty'}), 400

        total_cost = sum(item['quantity'] * item['price'] for item in cart_items)

        # Create a new order
        cursor.execute("""
            INSERT INTO orders (user_id)
            VALUES (%s)
        """, (email,))
        order_id = cursor.lastrowid

        # Create order_details for each item in the shopping cart
        for item in cart_items:
            cursor.execute("""
                INSERT INTO order_details (order_id, product_id, quantity, total_cost)
                VALUES (%s, %s, %s, %s)
            """, (order_id, item['product_id'], item['quantity'], item['quantity'] * item['price']))

        # Clear the user's shopping cart
        cursor.execute("""
            DELETE FROM cart_items
            WHERE cart_id = (SELECT cart_id FROM shopping_carts WHERE user_id = %s)
        """, (email,))

        connection.commit()

        return jsonify({'message': 'Payment successful! Order created.'}), 201

    except mysql.connector.Error as err:
        print(f"Database error: {err}")
        return jsonify({'error': 'Internal server error'}), 500

    finally:
        cursor.close()
        connection.close()


def send_password_reset_email(email, otp):
    msg = Message('Password Reset - OTP', recipients=[email])
    msg.body = f'reset password otp is: {otp}'
    mail.send(msg)

scheduler = APScheduler()
def update_discounts():
    try:
        connection = mysql.connector.connect(**db_config)
        cursor = connection.cursor()
        # Check if discounts are already generated
        cursor.execute("""
            SELECT COUNT(*) FROM products WHERE discount_percentage IS NOT NULL;
        """)
        discounts_generated = cursor.fetchone()[0]

        if not discounts_generated:
            # Retrieve near-to-expire items
            cursor.execute("""
                SELECT * FROM products
                WHERE expiry_date >= CURDATE() AND expiry_date <= CURDATE() + INTERVAL 7 DAY;
            """)
            near_to_expire_items = cursor.fetchall()

            # Assign random discounts to near-to-expire items and store in the database
            for item in near_to_expire_items:
                discount_percentage = random.uniform(5, 20)  # Random discount between 5% and 20%

                # Store the discount information in the database
                cursor.execute("""
                    UPDATE products
                    SET discount_percentage = %s
                    WHERE product_id = %s;
                """, (discount_percentage, item[0]))
                connection.commit()
        print("Updating discounts...")

    except mysql.connector.Error as err:
        print(f"Database error: {err}")
        return jsonify({'error': 'Internal server error'}), 500

    finally:
        cursor.close()
        connection.close()

# Configure the scheduler
app.config['SCHEDULER_API_ENABLED'] = True
app.config['JOBS'] = [
    {
        'id': 'my_job',
        'func': update_discounts,
        'trigger': 'interval',
        'seconds': 3600,
    }
]

# Start the scheduler when the app starts
scheduler.init_app(app)
scheduler.start()

if __name__ == '__main__':
    app.run(debug=True)
