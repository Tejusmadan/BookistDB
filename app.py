from flask import Flask, render_template,  jsonify, request, redirect, session
from flask_mysqldb import MySQL
from pymysql import IntegrityError

from flask_cors import CORS
from datetime import datetime, timedelta
import random

app = Flask(__name__, static_url_path='/static', static_folder='static')

app.secret_key = 'your_secret_key'  # Set a secret key for session management
CORS(app, supports_credentials=True)
CORS(app, resources={r"/api/*": {"origins": "*"}})



# MySQL configurations
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'root'
app.config['MYSQL_DB'] = 'bookist'

mysql = MySQL(app)


@app.route('/login', methods=['GET', 'POST'])
def login():
    if session.get("login"):
        return redirect("/another_page")
    else:
        if request.method == 'POST':
            print("A post request has been made to this URL")
            username = request.form["username"]
            password = request.form["password"]
            
            
            cursor = mysql.connection.cursor()
            cursor.execute(f"SELECT blocked FROM customer WHERE username = '{username}'")
            blocked = cursor.fetchone()

            if blocked and blocked[0]:
                return jsonify({'message': 'Your account is blocked. Please contact support.'}), 401

            cursor.execute("SELECT * FROM customer WHERE username = %s AND password = %s", (username, password))
            user = cursor.fetchone()

            cursor.execute("SELECT * FROM Manager WHERE manager_id = %s AND password = %s", (username, password))
            manager = cursor.fetchone()

            if user:
                session['login'] = True
                session['username'] = username
                session['password'] = password
                session['type'] = 'customer'
                return redirect("http://localhost:3000/")
            elif manager:
                session['login'] = True
                session['username'] = username
                session['password'] = password
                session['type'] = 'manager'
                return redirect("http://localhost:3000/")
            else:
                # Insert login attempt into the database
                cursor.execute("INSERT INTO login_attempts (username, successful) VALUES (%s, %s)", (username, False))
                mysql.connection.commit()
                
                # Check if the account is blocked
                cursor.execute(f"SELECT blocked FROM customer WHERE username = '{username}'")
                blocked = cursor.fetchone()

                cursor.close()

                if blocked and blocked[0]:
                    return jsonify({'message': 'Your account is blocked. Please contact support.'}), 401
                else:
                    return jsonify({'message': 'Invalid username or password'}), 401

        return render_template("/login/index.html")
    
@app.route('/another_page')
def dothis():
    if(session.get("login")):
        return jsonify(session.get("login"))
    else:
        return "wrong page"

@app.route('/login2', methods = ['GET','POST'])
def newf():
    return render_template("/another/login2.html")

@app.route('/endpoint', methods = ['GET','POST', 'OPTIONS'])
def newf1():
    if(request.method == 'POST'):
        print("Post has been made")
    if(request.method ==  "GET"):
        cursor = mysql.connection.cursor()
        cursor.execute("SELECT Customer.Username, Order_tracking.status FROM Customer LEFT JOIN Order_tracking ON Customer.Customer_id = Order_tracking.placed_by WHERE Order_tracking.status IS NOT NULL")
        user1 = cursor.fetchall()
        cursor.close()
        return jsonify(user1)
    return "Hello"

@app.route('/search', methods = ['GET','POST', 'OPTIONS'])
def query_example():
    if(request.method =='GET'):
        param = request.args.get('query')
        print(param)
        try:
            cursor = mysql.connection.cursor()
            cursor.execute(f"SELECT * FROM book, store_inventory, Store where book.book_id = store_inventory.book_id AND store_inventory.store_id = store.Store_id AND store_inventory.quantity > 0 AND (book.title LIKE '%{param}%' OR  book.Author like '%{param}%' OR book.Genre like '%{param}%' OR book.Description LIKE '%{param}%' or (SELECT Name from store where store.store_id = store_inventory.store_id) like '%{param}%')")
            user2 = cursor.fetchall()
            cursor.close()
            return jsonify(user2)
        except Exception as e:
            # Handle exceptions gracefully
            return {"error": str(e)}
    return {"data":"pyss"}

@app.route('/buyhandler', methods=['GET', 'POST', 'OPTIONS'])
def buyh():
    if request.method == 'POST':
        if not session.get('login'):
            return jsonify({'message': 'User not authenticated. Please log in.'}), 401
        if (session.get('type') == "customer"):

            try:
                cursor = mysql.connection.cursor()
                cursor.execute("INSERT INTO purchases (book_id, store_id, quantity) VALUES (%s, %s, %s)", (request.json.get('9'), request.json.get('13'), request.json.get('quantity')))
                mysql.connection.commit()

                print(request.json.get('13'))
                # Establish connection and cursor
                cursor = mysql.connection.cursor()

                # Define the SQL query with subquery and parameterization
                query = """
                INSERT INTO Order_tracking (status, location, eta, date_placed, placed_by, delivered_by)
                VALUES (%s, %s, %s, CURRENT_TIMESTAMP, (SELECT Customer_id FROM customer WHERE username = %s AND password = %s), (SELECT Agent_id FROM delivery_agent WHERE store_id = %s LIMIT 1))
                """
                current_timestamp = datetime.now()
                random_eta = current_timestamp + timedelta(minutes=random.randint(0, 20))

                # Extract data from the request
                data = (
                    'Processing', 
                    'Warehouse A', 
                    random_eta,  # ETA (adjust as needed)
                    session.get('username'), 
                    session.get('password'), 
                    request.json.get('13')  # Assuming store_id is in the JSON request
                )

                # Execute the query with data
                cursor.execute(query, data)
                order_id = cursor.lastrowid

                # Insert ordered items
                ordered_items_query = """
                INSERT INTO Ordered_items (book_id, quantity, store_id, order_id)
                VALUES (%s, %s, %s, %s)
                """
                ordered_items_data = (request.json.get('9'), request.json.get('quantity'), request.json.get('13'), order_id)
                cursor.execute(ordered_items_query, ordered_items_data)
                
                cursor.execute(f"UPDATE Store_inventory SET quantity = quantity - {request.json.get('quantity')} WHERE store_id = {request.json.get('13')} AND book_id = '{request.json.get('9')}'")

                # Commit the transaction
                mysql.connection.commit()

                # Close cursor
                cursor.close()
                print("Success")
                return jsonify({'message': 'Success'}), 200
            except IntegrityError as e:
                    # Catch the SQLSTATE '45000' error raised by the trigger
                if e.args[0] == 1644:
                    return jsonify({'error': 'Insufficient stock for purchase'}), 400
                else:
                    # Handle other IntegrityError exceptions
                    return jsonify({'error': str(e)}), 500
            except Exception as e:
                # Rollback if there's any error
                print(f"Error: {e}")
                mysql.connection.rollback()
                return jsonify({'message': 'Error occurred'}), 500
    return "Hello"


@app.route('/orderdat', methods=['GET', 'POST', 'OPTIONS'])
def orderdat():
    if request.method == 'GET':
        if session.get("login"):
            if(session.get('type') == "customer"):
                try:
                    cursor = mysql.connection.cursor()
                    cursor.execute(f"""
                        SELECT DISTINCT * 
                        FROM customer 
                        JOIN order_tracking ON order_tracking.placed_by = customer.Customer_id 
                        JOIN ordered_items ON order_tracking.order_id = ordered_items.order_id 
                        WHERE username = '{session.get("username")}' AND password = '{session.get("password")}' 
                        ORDER BY ordered_items.order_id ASC
                    """)

                    columns = [col[0] for col in cursor.description]  # Get column names
                    data = cursor.fetchall()  # Fetch data

                    cursor.close()

                    # Combine column names and data into a list of dictionaries
                    orders = [{columns[i]: row[i] for i in range(len(columns))} for row in data]

                    # Return data as JSON
                    return jsonify({'columns': columns, 'orders': orders})
                except Exception as e:
                    return {"error": str(e)}
    return {"No session": "error"}


@app.route('/inventorydat', methods=['GET', 'POST', 'OPTIONS'])
def inventorydat():
    if request.method == 'GET':
        if session.get("login"):
            if(session.get('type') == "manager"):
                try:
                    cursor = mysql.connection.cursor()
                    cursor.execute(f"""
                        SELECT * 
                        FROM store_inventory JOIN store ON store_inventory.store_id = store.store_id
                        JOIN book ON store_inventory.book_id = book.book_id
                        WHERE store_inventory.store_id = (SELECT store_id from manager WHERE manager_id ={session.get('username')})
                    """)

                    data = cursor.fetchall()  

                    return jsonify(data)
                except Exception as e:
                    return {"error": str(e)}
    return {"No session": "error"}


@app.route('/logouthandler', methods=['GET', 'POST', 'OPTIONS'])
def logouthandler():
    if request.method == 'POST':
        if not session.get('login'):
            return jsonify({'message': 'User not authenticated. Please log in.'}), 401
        if (session.get('login')):
            session['username'] = None;
            session['password'] = None;
            session['type'] = None;
            session['login'] = False;
            return "loggedout"
    return "unauthorized"

@app.route('/getsession', methods=['GET', 'POST', 'OPTIONS'])
def sessiondat():
    if request.method == 'GET':
        if session.get("login"):
            if(session.get('type') == "manager"):
                return {'type':'manager'};
            else:
                return {'type':'customer'};
    return {"No session": "error"}

if __name__ == "__main__":
    app.run(debug = True)