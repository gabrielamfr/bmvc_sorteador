from bottle import Bottle, run, static_file
import bottle, os
from app.controllers.application import Application

bottle.TEMPLATE_PATH = [os.path.join(os.path.dirname(__file__), 'app', 'views')]

app = Bottle()
ctl = Application()

@app.route('/static/<filepath:path>')
def serve_static(filepath):
    return static_file(filepath, root=os.path.join(os.path.dirname(__file__), 'app', 'static'))

@app.route('/')
def index():
    return ctl.index()

if __name__ == '__main__':
    run(app, host='localhost', port=8080, debug=True)
