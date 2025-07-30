import os
import requests
from flask import Flask, jsonify, request
import time

app = Flask(__name__)

start_time = time.time()

DUMMY_USERNAME = os.getenv("DUMMY_USERNAME")
DUMMY_PASSWORD = os.getenv("DUMMY_PASSWORD")
MAX_UPTIME_MINS = os.getenv("MAX_UPTIME_MINS")

#Validate env vars
if not all ([DUMMY_USERNAME, DUMMY_PASSWORD, MAX_UPTIME_MINS]):
    print("Required Variables to be set via environment")
    exit(1)

#get bear_token
auth_response = requests.post("https://dummyjson.com/auth/login", json={
    "username": DUMMY_USERNAME,
    "password": DUMMY_PASSWORD
})   
auth_response.raise_for_status()
token = auth_response.json().get("token")
headers = {"Authorization" : f"Bearer {token}"}

@app.route("/api/products", methods=["GET"])
def get_products():
    limit = request.args.get("limit", 30)
    skip = request.args.get("skip", 0)

    try:
        limit = int(limit)
        skip = int(skip)
    except ValueError:
        return jsonify({"error": "invalid query params"}), 400

    res = requests.get("https://dummyjson.com/products", headers=headers, params={"limit": limit, "skip": skip})
    res.raise_for_status()
    data = res.json()
    products = [{"id": p["id"], "title": p["title"], "description": p["description"]}
                for p in data.get("products", [])]
    return jsonify(products)

@app.route("/api/products/<id>", methods=["GET"])    
def get_product(id):
    if not id.isdigit():
        return jsonify({"error": "invalid value for id"}), 400
    res = requests.get("https://dummyjson.com/products/{id}", headers=headers)
    if res.status_code == 404:
        return jsonify({"error": "not found"}), 404
    res.raise_for_status()
    product = res.json()
    return jsonify(product)

@app.route("/api/health", methods=["GET"])
def health_check():
    uptime_minutes = (time.time) - start_time / 60
    if uptime_minutes < float(MAX_UPTIME_MINS):
        return jsonify({"health": "ok"}), 200
    else
        return jsonify({"health": "degraded"}), 500
    

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
