from bottle import request, template, redirect
from app.models.store import read_db, add_sorteio, update_sorteio, delete_sorteio
from app.controllers.auth_controller import SESSIONS

def require_login(func):
    def wrapper(*args, **kwargs):
        sid = request.get_cookie('session_id')
        if not sid or sid not in SESSIONS:
            return redirect('/login')
        return func(*args, **kwargs)
    return wrapper

@require_login
def admin_index():
    data = read_db()
    return template('admin', sorteios=data.get('sorteios', []))

@require_login
def create_sorteio():
    titulo = request.forms.get('titulo')
    descricao = request.forms.get('descricao') or ''
    sorteio = {'titulo': titulo, 'descricao': descricao}
    add_sorteio(sorteio)
    redirect('/admin')

@require_login
def delete_sorteio_route(id):
    try:
        idx = int(id)
        delete_sorteio(idx)
    except:
        pass
    redirect('/admin')
