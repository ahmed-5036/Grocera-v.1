from flask import Flask, render_template, request, redirect, url_for, flash, session
import mysql.connector

app = Flask(__name__)
app.secret_key = 'supersecretkey'

# MySQL configuration
db = mysql.connector.connect(
    host='localhost',
    user='root',
    password='root',
    database='grocery_store'
)
cursor = db.cursor()

# Create tables if not exists
cursor.execute('''
    CREATE TABLE IF NOT EXISTS users (
        email VARCHAR(100) PRIMARY KEY,
        password VARCHAR(255) NOT NULL
    )
''')

db.commit()

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

if __name__ == '__main__':
    app.run(debug=True)
