<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Sorteador</title>
    <link rel="stylesheet" href="/static/css/style.css">
    <style>
        .tabcontent {
            display: none;
        }
        #tab_numeros {
            display: block;
        }
        .aba-link.active {
            background-color: #e67e22 !important;
            color: white !important;
            font-weight: bold;
        }
        .btn-limpar {
            background-color: #e74c3c;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 13px;
            margin-left: 10px;
        }
        .btn-limpar:hover {
            background-color: #c0392b;
        }
        .historico-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <header class="site-header">
        <h1>Sorteador</h1>
        <nav>
            <a href="/">Início</a>
            % if username:
                <span> | Usuário: <strong>{{username}}</strong> |
                    <a href="/logout">Sair</a>
                </span>
            % else:
                <span> | <a href="/login">Entrar</a></span>
            % end
        </nav>
    </header>

    <main class="container">
        <div class="abas">
            <button class="aba-link active" onclick="mostrarAba('numeros')">
                Sorteio por Números
            </button>
            <button class="aba-link" onclick="mostrarAba('nomes')">
                Sorteio por Nomes
            </button>
            <button class="aba-link" onclick="mostrarAba('grafico')">
                Gráfico e Estatísticas
            </button>
        </div>

        <section id="tab_numeros" class="tabcontent">
            <h2>Sorteio por Números</h2>

            <div style="display:flex; gap:20px; flex-wrap:wrap; align-items:flex-start;">
                <div style="min-width:200px;">
                    <label>Nome do sorteio (opcional):</label><br>
                    <input id="nome_sorteio_numeros" type="text" placeholder="Ex: Sorteio de números" style="width:100%;"><br><br>

                    <label>Valor mínimo:</label><br>
                    <input id="min" type="number" value="1" style="width:100%;"><br><br>

                    <label>Valor máximo:</label><br>
                    <input id="max" type="number" value="100" style="width:100%;"><br><br>

                    <label>Quantidade de vencedores:</label><br>
                    <input id="count" type="number" value="1" style="width:100%;"><br><br>

                    % if username:
                        <button onclick="runNumberDraw()">Sortear</button>
                    % else:
                        <button disabled title="Faça login para sortear">Sortear (faça login)</button>
                    % end
                </div>

                <div style="flex:1;">
                    <div id="resultado_numeros" style="margin-top:5px; padding:8px; border:1px solid #ddd; border-radius:6px; min-height:48px;"></div>

                    <div class="historico-header">
                        <h3 style="margin:0;">Histórico (Números)</h3>
                        <button class="btn-limpar" onclick="limparHistorico('numeros')" title="Limpar histórico de números">
                            🗑️ Limpar
                        </button>
                    </div>
                    <ul id="hist_numeros" style="max-height:200px; overflow:auto; padding-left:18px; margin-top:0;"></ul>
                </div>
            </div>
        </section>

        <section id="tab_nomes" class="tabcontent">
            <h2>Sorteio por Nomes</h2>

            <div style="display:flex; gap:20px; flex-wrap:wrap;">
                <div style="flex:1; min-width:320px;">
                    <label>Nome do sorteio (opcional):</label><br>
                    <input id="nome_sorteio_nomes" type="text" placeholder="Ex: Sorteio de amigo secreto" style="width:100%;"><br><br>

                    <label>Insira nomes separados por vírgula:</label><br>
                    <textarea id="items_list" rows="8" style="width:100%;"></textarea><br><br>

                    <label>Quantidade de vencedores:</label><br>
                    <input id="count_list" type="number" value="1" style="width:120px;"><br><br>

                    % if username:
                        <button onclick="runListDraw()">Sortear</button>
                    % else:
                        <button disabled title="Faça login para sortear">Sortear (faça login)</button>
                    % end
                </div>

                <div style="flex:1; min-width:280px;">
                    <div id="resultado_lista" style="margin-top:5px; padding:8px; border:1px solid #ddd; border-radius:6px; min-height:48px;"></div>

                    <div class="historico-header">
                        <h3 style="margin:0;">Histórico (Nomes)</h3>
                        <button class="btn-limpar" onclick="limparHistorico('nomes')" title="Limpar histórico de nomes">
                            🗑️ Limpar
                        </button>
                    </div>
                    <ul id="hist_default" style="max-height:300px; overflow:auto; padding-left:18px; margin-top:0;"></ul>
                </div>
            </div>
        </section>

        <section id="tab_grafico" class="tabcontent">
            <h2>Gráficos e Estatísticas</h2>

            <div style="display:flex; gap:20px; flex-wrap:wrap; align-items:flex-start;">
                <div style="flex:1; min-width:320px;">
                    <canvas id="chart_canvas" width="700" height="320" style="border:1px solid #eee; border-radius:6px;"></canvas>
                    <div id="chart_message" style="margin-top:8px; color:#666;"></div>
                </div>

                <div style="width:260px;">
                    <div class="historico-header">
                        <h4 style="margin:0;">Resumo</h4>
                        <button class="btn-limpar" onclick="limparTodoHistorico()" title="Limpar todo o histórico">
                            🗑️ Limpar Tudo
                        </button>
                    </div>
                    <div id="chart_summary" style="font-size:14px; color:#333; margin-top:10px;"></div>
                    <hr>
                    <button onclick="renderCharts()">Atualizar gráfico</button>
                    
                    <div style="margin-top:20px; padding:15px; background:#f8f9fa; border-radius:6px;">
                        <h4 style="margin-top:0;">Limpar Histórico</h4>
                        <p style="font-size:13px; color:#666; margin-bottom:10px;">
                            Selecione o que deseja limpar:
                        </p>
                        <button class="btn-limpar" onclick="limparHistorico('numeros')" style="width:100%; margin-bottom:5px;">
                            🗑️ Limpar Histórico de Números
                        </button>
                        <button class="btn-limpar" onclick="limparHistorico('nomes')" style="width:100%; margin-bottom:5px;">
                            🗑️ Limpar Histórico de Nomes
                        </button>
                        <button class="btn-limpar" onclick="limparTodoHistorico()" style="width:100%; background:#c0392b;">
                            🗑️ Limpar Todo o Histórico
                        </button>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <footer class="site-footer">
        <p>© 2025 - Projeto BMVC Sorteador (Arthur e Gabriela)</p>
    </footer>

    <script>
    function mostrarAba(abaId) {
        console.log('Mostrando aba:', abaId);
        
        document.querySelectorAll('.aba-link').forEach(btn => {
            btn.classList.remove('active');
        });
        
        event.target.classList.add('active');
        
        document.querySelectorAll('.tabcontent').forEach(aba => {
            aba.style.display = 'none';
        });
        
        const abaSelecionada = document.getElementById('tab_' + abaId);
        if (abaSelecionada) {
            abaSelecionada.style.display = 'block';
            
            if (abaId === 'grafico') {
                setTimeout(renderCharts, 50);
            }
        }
    }
    
    function limparHistorico(tipo) {
        const confirmar = confirm(`Tem certeza que deseja limpar o histórico de ${tipo === 'numeros' ? 'números' : 'nomes'}?\nEsta ação não pode ser desfeita.`);
        
        if (confirmar) {
            const chave = tipo === 'numeros' ? 'sorteio_history_numeros' : 'sorteio_history_default';
            localStorage.removeItem(chave);
            
            renderHistory();
            
            if (document.getElementById('tab_grafico').style.display === 'block') {
                renderCharts();
            }
            
            alert(`Histórico de ${tipo === 'numeros' ? 'números' : 'nomes'} limpo com sucesso!`);
            
            console.log(`Histórico ${tipo} limpo.`);
        }
    }
    
    function limparTodoHistorico() {
        const confirmar = confirm('Tem certeza que deseja limpar TODO o histórico?\nEsta ação apagará todos os dados de sorteios e não pode ser desfeita.');
        
        if (confirmar) {
            localStorage.removeItem('sorteio_history_numeros');
            localStorage.removeItem('sorteio_history_default');
            
            renderHistory();
            
            if (document.getElementById('tab_grafico').style.display === 'block') {
                renderCharts();
            }
            
            alert('Todo o histórico foi limpo com sucesso!');
            
            console.log('Todo o histórico foi limpo.');
        }
    }
    
    function pushHistory(kind, vencedor, nomeSorteio = '') {
        if (typeof vencedor === 'undefined' || vencedor === null || vencedor === '') {
            console.warn('Tentativa de salvar valor inválido no histórico:', vencedor);
            return;
        }
        
        const key = 'sorteio_history_' + (kind || 'default');
        try {
            const raw = localStorage.getItem(key);
            const arr = raw ? JSON.parse(raw) : [];
            arr.push({
                valor: String(vencedor).trim(),
                nome: nomeSorteio.trim() || 'Sorteio sem nome'
            });
            localStorage.setItem(key, JSON.stringify(arr));
        } catch(e) {
            console.error('Erro ao salvar histórico:', e);
        }
    }
    
    function renderHistory() {
        const numerosEl = document.getElementById('hist_numeros');
        if (numerosEl) {
            const raw = localStorage.getItem('sorteio_history_numeros');
            const arr = raw ? JSON.parse(raw) : [];
            numerosEl.innerHTML = '';
            
            if (arr.length === 0) {
                const li = document.createElement('li');
                li.textContent = 'Nenhum sorteio realizado ainda.';
                li.style.color = '#666';
                li.style.fontStyle = 'italic';
                numerosEl.appendChild(li);
            } else {
                arr.slice(-20).reverse().forEach(item => {
                    const li = document.createElement('li');
                    let texto = item.valor;
                    if (item.nome && item.nome !== 'Sorteio sem nome') {
                        texto = `${item.nome}: ${item.valor}`;
                    }
                    li.textContent = texto;
                    numerosEl.appendChild(li);
                });
            }
        }
        
        const nomesEl = document.getElementById('hist_default');
        if (nomesEl) {
            const raw = localStorage.getItem('sorteio_history_default');
            const arr = raw ? JSON.parse(raw) : [];
            nomesEl.innerHTML = '';
            
            if (arr.length === 0) {
                const li = document.createElement('li');
                li.textContent = 'Nenhum sorteio realizado ainda.';
                li.style.color = '#666';
                li.style.fontStyle = 'italic';
                nomesEl.appendChild(li);
            } else {
                arr.slice(-20).reverse().forEach(item => {
                    const li = document.createElement('li');
                    let texto = item.valor;
                    if (item.nome && item.nome !== 'Sorteio sem nome') {
                        texto = `${item.nome}: ${item.valor}`;
                    }
                    li.textContent = texto;
                    nomesEl.appendChild(li);
                });
            }
        }
    }
    
    function runNumberDraw() {
        const min = parseInt(document.getElementById('min').value);
        const max = parseInt(document.getElementById('max').value);
        const count = parseInt(document.getElementById('count').value);
        const nomeSorteio = document.getElementById('nome_sorteio_numeros').value.trim();
        const outEl = document.getElementById('resultado_numeros');
        
        if (isNaN(min) || isNaN(max) || isNaN(count) || min > max || count <= 0) {
            outEl.innerText = 'Valores inválidos.';
            return;
        }
        
        const pool = [];
        for (let i = min; i <= max; i++) pool.push(i);
        const winners = [];
        
        if (count > pool.length) {
            for (let k = 0; k < count; k++) {
                const idx = Math.floor(Math.random() * pool.length);
                winners.push(pool[idx]);
            }
        } else {
            const tempPool = [...pool];
            for (let k = 0; k < count; k++) {
                const idx = Math.floor(Math.random() * tempPool.length);
                winners.push(tempPool[idx]);
                tempPool.splice(idx, 1);
            }
        }
        
        let resultadoTexto = `<p><strong>Vencedores:</strong> ${winners.join(', ')}</p>`;
        if (nomeSorteio) {
            resultadoTexto = `<p><strong>${nomeSorteio}</strong></p>` + resultadoTexto;
        }
        outEl.innerHTML = resultadoTexto;
        
        winners.forEach(w => {
            if (w !== undefined && w !== null && w !== '') {
                pushHistory('numeros', w, nomeSorteio);
            }
        });
        renderHistory();
        
        document.getElementById('nome_sorteio_numeros').value = '';
    }
    
    function runListDraw() {
        const itemsText = document.getElementById('items_list').value;
        const count = parseInt(document.getElementById('count_list').value);
        const nomeSorteio = document.getElementById('nome_sorteio_nomes').value.trim();
        const outEl = document.getElementById('resultado_lista');
        
        const items = itemsText.split(',').map(s => s.trim()).filter(Boolean);
        
        if (items.length === 0 || isNaN(count) || count <= 0) {
            outEl.innerText = 'Valores inválidos.';
            return;
        }
        
        const winners = [];
        
        if (count > items.length) {
            for (let k = 0; k < count; k++) {
                const idx = Math.floor(Math.random() * items.length);
                winners.push(items[idx]);
            }
        } else {
            const tempItems = [...items];
            for (let k = 0; k < count; k++) {
                const idx = Math.floor(Math.random() * tempItems.length);
                winners.push(tempItems[idx]);
                tempItems.splice(idx, 1);
            }
        }
        
        let resultadoTexto = `<p><strong>Vencedores:</strong> ${winners.join(', ')}</p>`;
        if (nomeSorteio) {
            resultadoTexto = `<p><strong>${nomeSorteio}</strong></p>` + resultadoTexto;
        }
        outEl.innerHTML = resultadoTexto;
        
        winners.forEach(w => {
            if (w !== undefined && w !== null && w !== '') {
                pushHistory('default', w, nomeSorteio);
            }
        });
        renderHistory();
        
        document.getElementById('nome_sorteio_nomes').value = '';
    }
    
    function renderCharts() {
        console.log('Renderizando gráficos...');
        
        const canvas = document.getElementById('chart_canvas');
        if (!canvas) {
            console.error('Canvas não encontrado!');
            return;
        }
        
        const ctx = canvas.getContext('2d');
        if (!ctx) {
            console.error('Contexto 2D não disponível!');
            return;
        }
        
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        
        const rawNames = localStorage.getItem('sorteio_history_default');
        const names = rawNames ? JSON.parse(rawNames) : [];
        const rawNums = localStorage.getItem('sorteio_history_numeros');
        const nums = rawNums ? JSON.parse(rawNums) : [];
        
        const countMap = {};
        
        names.forEach(item => { 
            if (item && item.valor && item.valor !== 'undefined' && item.valor !== 'null') {
                const valor = String(item.valor).trim();
                if (valor) {
                    countMap[valor] = (countMap[valor] || 0) + 1;
                }
            }
        });
        
        nums.forEach(item => { 
            if (item && item.valor && item.valor !== 'undefined' && item.valor !== 'null') {
                const valor = String(item.valor).trim();
                if (valor) {
                    countMap[valor] = (countMap[valor] || 0) + 1;
                }
            }
        });
        
        Object.keys(countMap).forEach(key => {
            if (!key || key === 'undefined' || key === 'null' || key === '') {
                delete countMap[key];
            }
        });
        
        const entries = Object.entries(countMap).sort((a,b) => b[1] - a[1]).slice(0,10);
        
        if (entries.length === 0) {
            const msgEl = document.getElementById('chart_message');
            const summaryEl = document.getElementById('chart_summary');
            if (msgEl) {
                msgEl.innerHTML = '<div style="background:#fff3cd; padding:10px; border-radius:5px; border:1px solid #ffeaa7;">' +
                                 '<strong>⚠️ Sem dados ainda</strong><br>' +
                                 'Faça alguns sorteios para ver o gráfico.' +
                                 '</div>';
            }
            if (summaryEl) {
                summaryEl.innerHTML = '<div style="color:#666; padding:10px; background:#f8f9fa; border-radius:5px;">' +
                                     'Nenhum dado disponível. Os históricos estão vazios.' +
                                     '</div>';
            }
            
            ctx.fillStyle = '#999';
            ctx.font = 'bold 20px Arial';
            ctx.textAlign = 'center';
            ctx.fillText('📊', canvas.width / 2, canvas.height / 2 - 20);
            ctx.font = '16px Arial';
            ctx.fillText('Aguardando dados...', canvas.width / 2, canvas.height / 2 + 10);
            return;
        }
        
        const padding = 60;
        const w = canvas.width - padding * 2;
        const h = canvas.height - padding * 2;
        const maxCount = entries[0][1];
        const barWidth = w / entries.length;
        
        ctx.fillStyle = '#333';
        ctx.font = 'bold 18px Arial';
        ctx.textAlign = 'center';
        ctx.fillText('📈 Top 10 Mais Sorteados', canvas.width / 2, 30);
        
        entries.forEach((it, i) => {
            const label = it[0];
            const ct = it[1];
            const barHeight = (ct / maxCount) * h;
            const x = padding + i * barWidth;
            const y = canvas.height - padding - barHeight;
            
            const colors = ['#e67e22', '#3498db', '#2ecc71', '#9b59b6', '#f1c40f', '#e74c3c', '#1abc9c', '#34495e', '#d35400', '#16a085'];
            ctx.fillStyle = colors[i % colors.length];
            ctx.fillRect(x + 5, y, barWidth * 0.8, barHeight);
            
            ctx.fillStyle = '#333';
            ctx.font = 'bold 12px Arial';
            ctx.textAlign = 'center';
            ctx.fillText(ct, x + 5 + (barWidth * 0.8) / 2, y - 8);
            
            ctx.font = '11px Arial';
            ctx.fillText(label, x + 5 + (barWidth * 0.8) / 2, canvas.height - padding + 15);
        });
        
        const summaryEl = document.getElementById('chart_summary');
        if (summaryEl) {
            let html = '<div style="margin-bottom:10px; font-weight:bold; color:#333;">🏆 Ranking:</div>';
            entries.forEach((e, index) => {
                const emoji = index === 0 ? '🥇' : index === 1 ? '🥈' : index === 2 ? '🥉' : '🔸';
                const colors = ['#e67e22', '#3498db', '#2ecc71', '#9b59b6', '#f1c40f', '#e74c3c', '#1abc9c', '#34495e', '#d35400', '#16a085'];
                html += `<div style="margin:6px 0; padding:6px; background:${colors[index]}10; border-radius:4px; border-left:3px solid ${colors[index]};">` +
                       `${emoji} <strong>${e[0]}</strong> - ${e[1]} vez${e[1] > 1 ? 'es' : ''}` +
                       `</div>`;
            });
            summaryEl.innerHTML = html;
        }
        
        const msgEl = document.getElementById('chart_message');
        if (msgEl) {
            const total = Object.values(countMap).reduce((a, b) => a + b, 0);
            const unique = Object.keys(countMap).length;
            msgEl.innerHTML = '<div style="background:#e8f4fd; padding:10px; border-radius:5px;">' +
                             '<strong>📊 Estatísticas Gerais:</strong><br>' +
                             `Total de sorteios: <strong>${total}</strong><br>` +
                             `Itens únicos sorteados: <strong>${unique}</strong>` +
                             '</div>';
        }
        
        console.log('Gráfico renderizado com sucesso! Entradas:', entries);
    }
    
    document.addEventListener('DOMContentLoaded', function() {
        console.log('Sistema de sorteio inicializado!');
        renderHistory();
    });
    </script>
</body>
</html>