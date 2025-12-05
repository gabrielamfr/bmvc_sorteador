<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Admin - Sorteador</title>
    <link rel="stylesheet" href="/static/css/style.css">
    <style>
        .admin-container {
            max-width: 800px;
            margin: 30px auto;
            padding: 20px;
        }
        .admin-section {
            background: white;
            padding: 20px;
            margin-bottom: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.06);
        }
        .admin-section h3 {
            color: #e67e22;
            border-bottom: 2px solid #f0f0f0;
            padding-bottom: 10px;
            margin-top: 0;
        }
        .sorteio-item {
            background: #f8f9fa;
            padding: 15px;
            margin-bottom: 10px;
            border-radius: 4px;
            border-left: 4px solid #e67e22;
        }
        .sorteio-item strong {
            display: block;
            margin-bottom: 5px;
            color: #333;
        }
        .logout-link {
            float: right;
            color: #e67e22;
            text-decoration: none;
        }
        .logout-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <header class="site-header">
        <h1>Sorteador</h1>
        <nav>
            <a href="/">Início</a>
            <a href="/logout" class="logout-link">Sair</a>
        </nav>
    </header>

    <main class="container">
        <div class="admin-container">
            <div class="admin-section">
                <h2>Painel Admin</h2>
                
                <h3>Criar novo sorteio</h3>
                <form method="post" action="/admin/create">
                    <label>Título:</label><br>
                    <input name="titulo" required style="width: 100%; padding: 8px; margin-bottom: 10px;"><br>
                    
                    <label>Descrição:</label><br>
                    <textarea name="descricao" style="width: 100%; padding: 8px; height: 80px; margin-bottom: 15px;"></textarea><br>
                    
                    <button type="submit">Criar</button>
                </form>
            </div>
            
            <div class="admin-section">
                <h3>Sorteios cadastrados</h3>
                
                % if not sorteios:
                    <p>Nenhum sorteio cadastrado.</p>
                % else:
                    % for i, s in enumerate(sorteios):
                    <div class="sorteio-item">
                        <strong>{{s['titulo']}}</strong>
                        <span>{{s.get('descricao','')}}</span>
                        <a href="/admin/delete/{{i}}" style="float:right; color:#e74c3c;">Excluir</a>
                    </div>
                    % end
                % end
            </div>
        </div>
    </main>

    <footer class="site-footer">
        <p>© 2025 - Projeto BMVC Sorteador (Arthur e Gabriela)</p>
    </footer>
</body>
</html>
