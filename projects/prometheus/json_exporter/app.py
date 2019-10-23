import os
from flask import Flask, request, Response
import prometheus_client
import random
from random import randrange

app = Flask(__name__)

# metrics collector for porometheus client
@app.route('/metrics/')
def metrics():
    return Response(prometheus_client.generate_latest(), mimetype=CONTENT_TYPE_LATEST)


# random API endpoint for generating metrics
@app.route("/generate_metrics", methods=['POST'])
def generate_random_values():
    if request.method == 'POST':
        output = str(random.random())
        print output
    return (output)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=2345, debug=True, threaded=True)
    
