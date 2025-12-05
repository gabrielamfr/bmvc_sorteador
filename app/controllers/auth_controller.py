from bottle import request, response, template, redirect
import uuid
from app.models.store import add_user, find_user_by_username, read_db

SESSIONS = {}

def login_get():
    return template('login', error=None)

def login_post():
    username = request.forms.get('username')
    password = request.forms.get('password')
    user = find_user_by_username(username)
    if user and user.get('password') == password:
        sid = str(uuid.uuid4())
        SESSIONS[sid] = username
        response.set_cookie('session_id', sid, path='/')
        redirect('/')
    else:
        return template('login', error='Usuário ou senha inválidos')

def logout():
    sid = request.get_cookie('session_id')
    if sid and sid in SESSIONS:
        SESSIONS.pop(sid, None)
    response.set_cookie('session_id', '', expires=0, path='/')
    redirect('/')
    
from bottle import request as _request

def current_username(req=None):
    req = req or _request
    sid = req.get_cookie('session_id')
    if sid and sid in SESSIONS:
        return SESSIONS[sid]
    return None
