<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Login - Sorteador</title>
    <link rel="stylesheet" href="/static/css/style.css">
    <style>
        .login-container {
            max-width: 400px;
            margin: 50px auto;
            padding: 30px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .login-container h2 {
            margin-top: 0;
            color: #e67e22;
            text-align: center;
        }
        .login-container label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
        }
        .login-container input {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .login-container button {
            width: 100%;
            padding: 12px;
            background: #e67e22;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
        .login-container button:hover {
            background: #d35400;
        }
        .error-message {
            color: #e74c3c;
            background: #ffeaea;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 20px;
            text-align: center;
        }
        .back-link {
            text-align: center;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <header class="site-header">
        <h1>Sorteador</h1>
        <nav>
            <a href="/">Início</a>
        </nav>
    </header>

    <main class="container">
        <div class="login-container">
            <h2>Área restrita — Login</h2>
            
            % if error:
            <div class="error-message">{{error}}</div>
            % end
            
            <form method="post" action="/login">
                <label>Usuário:</label>
                <input name="username" required>
                
                <label>Senha:</label>
                <input type="password" name="password" required>
                
                <button type="submit">Entrar</button>
            </form>
            
            <div class="back-link">
                <a href="/">← Voltar para a página inicial</a>
            </div>
        </div>
    </main>

    <footer class="site-footer">
        <p>© 2025 - Projeto BMVC Sorteador (Arthur e Gabriela)</p>
    </footer>
</body>
</html>