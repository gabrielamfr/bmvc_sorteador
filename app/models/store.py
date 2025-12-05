import json
import os
import threading
_lock = threading.Lock()

BASE = os.path.dirname(__file__)
DB_PATH = os.path.normpath(os.path.join(BASE, '..', 'data', 'db.json'))

def _ensure_db():
    try:
        db_dir = os.path.dirname(DB_PATH)
        os.makedirs(db_dir, exist_ok=True)
    except Exception as e:
        raise RuntimeError(f"ERRO CRÍTICO: não foi possível criar o diretório do DB: {db_dir}. Erro: {e}")

    if not os.path.exists(DB_PATH):
        try:
            with open(DB_PATH, 'w', encoding='utf-8') as f:
                json.dump({'users': [], 'sorteios': [], 'draws': []}, f, ensure_ascii=False, indent=2)
        except Exception as e:
            raise RuntimeError(f"ERRO CRÍTICO AO CRIAR DB.JSON: {e}\nO sistema não conseguiu escrever no caminho: {DB_PATH}")

def read_db():
    _ensure_db()
    with _lock:
        with open(DB_PATH, 'r', encoding='utf-8') as f:
            return json.load(f)

def write_db(data):
    _ensure_db()
    with _lock:
        with open(DB_PATH, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)

def add_user(user):
    data = read_db()
    data['users'].append(user)
    write_db(data)

def find_user_by_username(username):
    data = read_db()
    for u in data['users']:
        if u.get('username') == username:
            return u
    return None

def add_sorteio(sorteio):
    data = read_db()
    data['sorteios'].append(sorteio)
    write_db(data)

def update_sorteio(index, sorteio):
    data = read_db()
    data['sorteios'][index] = sorteio
    write_db(data)

def delete_sorteio(index):
    data = read_db()
    data['sorteios'].pop(index)
    write_db(data)

def add_draw(draw):
    data = read_db()
    data.setdefault('draws', [])
    data['draws'].append(draw)
    write_db(data)

def get_draws_by_user(username):
    data = read_db()
    return [d for d in data.get('draws', []) if d.get('user') == username]
