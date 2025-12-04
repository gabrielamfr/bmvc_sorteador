% rebase('layout.tpl', titulo='Sorteador')

<div class="aba-numeros">
    <h2>Sorteio por Números</h2>
    <p>Digite o intervalo de números para o sorteio.</p>
    
    <label for="titulo_sorteio_numeros">Título do Sorteio:</label><br>
    <input id="titulo_sorteio_numeros" type="text" placeholder="Ex: Sorteio Rifa 2025"><br><br>

    <label for="numero_min">Número mínimo:</label><br>
    <input id="numero_min" type="number" min="0" value="1"><br><br>

    <label for="numero_max">Número máximo:</label><br>
    <input id="numero_max" type="number" min="1" value="100"><br><br>

    <label for="quantidade_numeros">Quantos números sortear?</label><br>
    <input id="quantidade_numeros" type="number" min="1" value="1"><br><br>

    <button id="btn_sortear_numeros">Sortear Números</button>
    <button id="btn_clear_numeros">Limpar</button>

    <h3>Resultado</h3>
    <div id="resultado_numeros" aria-live="polite"></div>
</div>
    <h3>Últimos vencedores</h3>
    <ul id="history_list_numeros" class="history-list"></ul>


<script id="template-nomes" type="text/template">
    <h2>Sorteio por Nomes</h2>
    <p>Digite nomes separados por vírgula.</p>
    
    <label for="titulo_sorteio_nomes">Título do Sorteio:</label><br>
    <input id="titulo_sorteio_nomes" type="text" placeholder="Ex: Sorteio da Turma"><br><br>

    <label for="input_items">Nomes:</label><br>
    <textarea id="input_items" rows="3" placeholder="ex: João, Maria, Pedro"></textarea><br><br>

    <label for="input_count">Quantos sortear por vez?</label><br>
    <input id="input_count" type="number" min="1" value="1"><br><br>

    <button id="btn_sortear">Sortear Nomes</button>
    <button id="btn_clear">Limpar histórico</button>

    <h3>Resultado</h3>
    <div id="resultado_box" aria-live="polite"></div>

    <h3>Histórico (últimos vencedores)</h3>
    <ul id="history_list"></ul>
</script>

<script id="template-grafico" type="text/template">
    <h2>Gráfico de Frequência</h2>
    <p>Visualização simples dos itens mais sorteados</p>

    <div id="grafico_simples">
    </div>

    <div id="estatisticas">
        <h3>Estatísticas</h3>
        <div id="dados_estatisticas"></div>
    </div>
</script>

