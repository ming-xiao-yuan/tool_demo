import os
from flask import Flask

app = Flask(__name__)


@app.route('/',  methods=["GET"])
def base_route():
    return '<h1>Hello LOG6370E, I am instance {}!</h1>'.format(os.environ['INSTANCE_ID_EC2'])

@app.route('/first_url', methods=["GET"])
def first_url_route():
    return '<h1>I am still {} Here is my first url!</h1>'.format(os.environ['INSTANCE_ID_EC2'])

@app.route('/second_url',  methods=["GET"])
def hello_route():
    return '<h1>I am still {} Here is my SECOND url!</h1>'.format(os.environ['INSTANCE_ID_EC2'])

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

