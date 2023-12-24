from flask import Flask, render_template, request, redirect, url_for, flash, session
import mysql.connector

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

# Routes for login, sign up, and forgot password
@app.route('/')
def index():
    return 'Welcome to the grocery store app!'

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']

        # Check if email is already taken
        cursor.execute('SELECT * FROM users WHERE email=%s', (email,))
        user = cursor.fetchone()

        if user:
            flash('Email already exists. Please choose a different one.', 'error')
        else:
            # Create a new user
            cursor.execute('INSERT INTO users (email, password) VALUES (%s, %s)', (email, password))
            db.commit()
            flash('Account created successfully. Please log in.', 'success')
            return redirect(url_for('login'))

    return render_template('signup.html')
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']

        cursor.execute('SELECT * FROM users WHERE email=%s AND password=%s', (email, password))
        user = cursor.fetchone()

        if user:
            session['user_email'] = email
            flash('Login successful!', 'success')
            return redirect(url_for('index'))
        else:
            flash('Invalid email or password. Please try again.', 'error')

    return render_template('login.html')
if __name__ == '__main__':
    app.run(debug=True)
