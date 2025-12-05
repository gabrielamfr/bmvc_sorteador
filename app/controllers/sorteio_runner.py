from bottle import request, response
from app.controllers.auth_controller import current_username
from app.models.store import add_draw
import random, datetime

def run_draw_api():
    username = current_username()
    if not username:
        response.status = 401
        return {'ok': False, 'message': 'Você precisa estar autenticado para realizar sorteios.'}

    tipo = request.forms.get('tipo')

    try:
        if tipo == 'numbers':
            minimo = int(request.forms.get('numero_min') or 1)
            maximo = int(request.forms.get('numero_max') or 1)
            count  = int(request.forms.get('count')      or 1)

            pool = list(range(minimo, maximo + 1))
            if count > len(pool):
                winners = [random.choice(pool) for _ in range(count)]
            else:
                winners = random.sample(pool, count)

        else:
            items_raw = request.forms.get('items') or ''
            items = [i.strip() for i in items_raw.split(',') if i.strip()]
            count = int(request.forms.get('count') or 1)

            if count > len(items):
                winners = [random.choice(items) for _ in range(count)]
            else:
                winners = random.sample(items, count)

        winners = [str(w) for w in winners]

        draw_record = {
            'user': username,
            'timestamp': datetime.datetime.utcnow().isoformat() + 'Z',
            'winners': winners,
            'params': {
                'tipo': tipo,
                'count': count
            }
        }

        add_draw(draw_record)

        return {'ok': True, 'winners': winners, 'message': 'Sorteio realizado com sucesso.'}

    except Exception as e:
        response.status = 500
        return {'ok': False, 'message': str(e)}


def get_user_draws_api():
    username = current_username()
    if not username:
        response.status = 401
        return {'ok': False, 'message': 'Você precisa estar autenticado para ver seu histórico.'}

    from app.models.store import get_draws_by_user
    draws = get_draws_by_user(username)

    return {'ok': True, 'draws': draws}
