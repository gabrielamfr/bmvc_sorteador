from app.models.store import add_user, read_db

db = read_db()
exists = any(u.get('username') == 'admin' for u in db.get('users', []))

if not exists:
    add_user({'username':'admin','password':'admin123'})
    print('Usuário admin criado: admin / admin123')
else:
    print('Usuário admin já existe')
