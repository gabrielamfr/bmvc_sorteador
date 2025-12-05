<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{{titulo}}</title>
    <link rel="stylesheet" href="/static/css/style.css">
</head>
<body>
    <header class="site-header">
        <h1>Sorteador</h1>
        <nav>
            <a href="/">Início</a>
        </nav>
    </header>

    <main class="container">
        <div class="abas">
            <button class="aba-link active" id="btn-numeros" onclick="mostrarAba('numeros')">
                Sorteio por Números
            </button>
            <button class="aba-link" id="btn-nomes" onclick="mostrarAba('nomes')">
                Sorteio por Nomes
            </button>
            <button class="aba-link" id="btn-grafico" onclick="mostrarAba('grafico')">
                Gráfico e Estatísticas
            </button>
        </div>

        <div id="conteudo-dinamico">
            <!-- O conteúdo será carregado aqui -->
        </div>
    </main>

    <footer class="site-footer">
        <p>© 2025 - Projeto BMVC Sorteador (Arthur e Gabriela)</p>
    </footer>

    <script>
    function mostrarAba(aba) {
        document.querySelectorAll('.aba-link').forEach(b => b.classList.remove('active'));
         document.getElementById('btn-' + aba).classList.add('active');
        
        if (document.getElementById('tab_numeros')) {
            document.querySelectorAll('.tabcontent').forEach(s => s.style.display = 'none');
            document.getElementById('tab_' + aba).style.display = 'block';
            
            if (aba === 'grafico' && typeof renderCharts === 'function') {
                renderCharts();
            }
        }
    }
    document.addEventListener('DOMContentLoaded', function() {
        mostrarAba('numeros');
    });
    </script>
    <script src="/static/js/script.js"></script>
</body>
</html>