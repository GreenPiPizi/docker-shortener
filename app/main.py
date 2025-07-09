import os
import string
import random
from flask import Flask, request, jsonify, redirect
from redis import Redis

app = Flask(__name__)

# Initialize Redis connection
redis_host = os.environ.get('REDIS_HOST', 'redis')
redis = Redis(host=redis_host, port=6379, db=0, decode_responses=True)

def generate_short_code(length=6):
    while True:
        code = ''.join(random.choices(string.ascii_letters + string.digits, k=length))
        if not redis.exists(code):
            return code
        
@app.route('/', methods=['POST'])
def create_short_url():
    data = request.get_json()
    if not data or 'url' not in data:
        return jsonify({"error" : "URL not provided"}), 400
    
    long_url = data['url']
    short_code = generate_short_code()

    redis.set(short_code, long_url)
    
    short_url = request.host_url + short_code
    return jsonify({"short_url" : short_url})

@app.route('/<short_code>', methods=['GET'])
def redirect_to_long_url(short_code):
    long_url = redis.get(short_code)

    if long_url:
        return redirect(long_url, code=302)
    else:
        return jsonify({"error": "Short URL not found"}), 404
    
if __name__ == '__main__':
    app.run(host='0.0.0.0' , port = 5000)