from app import app
from flask import render_template, request
import psycopg2

@app.route('/', methods = ['GET'])
def entry():
   return render_template('entry.html')

@app.route('/guestbook', methods = ['POST', 'GET'])
def guestbook():
    if request.method == 'POST':

        conn = psycopg2.connect("dbname=%s user=%s host=%s port=%s password=%s" % (
            app.config['DBNAME'],
            app.config['USER'],
            app.config['HOST'],
            app.config['PORT'],
            app.config['PASSWORD']))

        cur = conn.cursor()
        cur.execute('INSERT INTO Users (name, email, comments) VALUES (%s, %s, %s)', (
            request.form['name'], 
            request.form['email'], 
            request.form['comments']))
        conn.commit()

        cur.execute("SELECT name,email,comments from Users;")
        fetch = cur.fetchall()
        conn.close()
        users = [{'name': i[0], 'email': i[1], 'comments':i[2]} for i in fetch]

        return render_template("guestbook.html",data = users)
        