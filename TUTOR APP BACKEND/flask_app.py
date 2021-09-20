import os
from flask import Flask, json, request, jsonify
import logging
from firebase_admin import credentials, firestore, initialize_app
import re

from flask_cors import CORS

# Initialize Flask app
app = Flask(__name__)
CORS(app)
cors = CORS(app, resource={
    r"/*":{
        "origins":"*"
    }
})

# Initialize Firestore DB
cred = credentials.Certificate('key.json')
default_app = initialize_app(cred)
db = firestore.client()
student_ref = db.collection('Student')

@app.route('/student/add', methods=['POST'])
def create():
    # app.logger.info(json.loads(request.get_data()))
    payload = json.loads(request.get_data())
    try:
        id = payload['id']
        std = int(float(payload['Class']))
        # app.logger.info(std)
        if (std>0) and (std<13):
            student_ref.document(id).set(payload)
            # app.logger.info("inserted record", payload)
            return jsonify({"success": True}), 200
        else:
            return ("Class invalid")
    except Exception as e:
        app.logger.error(e)
        return f"An Error Occured: {e}"

@app.route('/student/list', methods=['GET'])
def read():
    try:
        # Check if ID was passed to URL query
        todo_id = request.args.get('id')
        if todo_id:
            todo = student_ref.document(todo_id).get()
            return jsonify(todo.to_dict()), 200
        else:
            all_todos = [doc.to_dict() for doc in student_ref.stream()]
            return jsonify(all_todos), 200
    except Exception as e:
        return f"An Error Occured: {e}"

@app.route('/student/getNameById', methods=['GET'])
def readById():
    try:
        # Check if ID was passed to URL query
        todo_id = request.args.get('id')
        if todo_id:
            todo = student_ref.document(todo_id).get()
            return jsonify(todo.to_dict()), 200
        else:
            all_todos = [doc.to_dict() for doc in student_ref.stream()]
            return jsonify(all_todos), 200
    except Exception as e:
        return f"An Error Occured: {e}"


@app.route('/student/update', methods=['POST', 'PUT'])
def update():
    try:
        id = request.json['id']
        student_ref.document(id).update(request.json)
        return jsonify({"success": True}), 200
    except Exception as e:
        return f"An Error Occured: {e}"

@app.route('/student/delete', methods=['GET', 'DELETE'])
def delete():
    try:
        # Check for ID in URL query
        todo_id = request.args.get('id')
        student_ref.document(todo_id).delete()
        return jsonify({"success": True}), 200
    except Exception as e:
        return f"An Error Occured: {e}"

# =========================================== TEACHER APP ===========
teacher_ref = db.collection('Teacher')

@app.route('/teacher/add', methods=['POST'])
def create():
    # app.logger.info(json.loads(request.get_data()))
    payload = json.loads(request.get_data())
    try:
        id = payload['id']
        std = (payload['Class'])
        classes = re.findall("(-?\d+)",std)
        maximum = max(int (i) for i in classes)
        minimum = min(int (i) for i in classes)
            #     # app.logger.info(std)
        app.logger.info("inserted record", payload)
        if (maximum<13)and(minimum>0):
            teacher_ref.document(id).set(payload)
        else:
            return ("Class invalid")
        return jsonify({"success": True}), 200
    except Exception as e:
        app.logger.error(e)
        return f"An Error Occured: {e}"

@app.route('/teacher/list', methods=['GET'])
def read():
    try:
        # Check if ID was passed to URL query
        todo_id = request.args.get('id')
        if todo_id:
            todo = teacher_ref.document(todo_id).get()
            return jsonify(todo.to_dict()), 200
        else:
            all_todos = [doc.to_dict() for doc in teacher_ref.stream()]
            return jsonify(all_todos), 200
    except Exception as e:
        return f"An Error Occured: {e}"

@app.route('/teacher/update', methods=['POST', 'PUT'])
def update():
    try:
        id = request.json['id']
        teacher_ref.document(id).update(request.json)
        return jsonify({"success": True}), 200
    except Exception as e:
        return f"An Error Occured: {e}"

@app.route('/teacher/delete', methods=['GET', 'DELETE'])
def delete():
    try:
        # Check for ID in URL query
        todo_id = request.args.get('id')
        teacher_ref.document(todo_id).delete()
        return jsonify({"success": True}), 200
    except Exception as e:
        return f"An Error Occured: {e}"


port = int(os.environ.get('PORT', 8080))
if __name__ == '__main__':
    app.run(threaded=True, host='0.0.0.0', port=port, debug=True)




