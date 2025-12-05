function abrirAba(event, target){
    try{ if (event && typeof event.preventDefault === 'function') event.preventDefault(); }catch(e){}
    document.querySelectorAll('.aba-link').forEach(b => b.classList.remove('active'));
    if (event && event.currentTarget) {
        event.currentTarget.classList.add('active');
    } else {
        var map = {
            'sorteio-numeros': 'Sorteio por Números',
            'sorteio-nomes': 'Sorteio por Nomes',
            'grafico': 'Gráfico e Estatísticas',
            'grafico': 'Gráfico e Estatísticas'
        };
        var label = map[target];
        if (label) {
            document.querySelectorAll('.aba-link').forEach(b => {
                if ((b.textContent||'').trim().toLowerCase() === label.trim().toLowerCase()) b.classList.add('active');
            });
        }
    }
    document.querySelectorAll('.aba-conteudo').forEach(c => c.classList.remove('active'));
    var contentId = target;
    var contentEl = document.getElementById(contentId);
    if (contentEl) contentEl.classList.add('active');
    if (target === 'sorteio-numeros') {
        if (typeof showTabById === 'function') showTabById('tab_numeros');
        if (typeof syncActiveButtons === 'function') syncActiveButtons('Por Números');
    } else if (target === 'sorteio-nomes') {
        if (typeof showTabById === 'function') showTabById('tab_nomes');
        if (typeof syncActiveButtons === 'function') syncActiveButtons('Por Nomes');
    } else {
        if (typeof showTabById === 'function') showTabById('tab_graficos');
        if (typeof syncActiveButtons === 'function') syncActiveButtons('Gráfico e Estatísticas');
    }
}

function parseItems(text){
    if (!text) return [];
    return text.split(',').map(s => s.trim()).filter(Boolean);
}

function pushHistory(kind, vencedor){
    if (typeof vencedor === 'undefined' || vencedor === null) return;
    const key = 'sorteio_history_' + (kind || 'default');
    try {
        const raw = localStorage.getItem(key);
        const arr = raw ? JSON.parse(raw) : [];
        arr.push({ value: vencedor, date: new Date().toISOString() });
        localStorage.setItem(key, JSON.stringify(arr));
    } catch(e){}
}

function renderHistory(){
    const map = {
        numeros: 'sorteio_history_numeros',
        default: 'sorteio_history_default'
    };
    Object.keys(map).forEach(k => {
        const el = document.getElementById('hist_' + k);
        if (!el) return;
        const raw = localStorage.getItem(map[k]);
        const arr = raw ? JSON.parse(raw) : [];
        el.innerHTML = '';
        arr.slice(-20).reverse().forEach(it => {
            const li = document.createElement('li');
            let d = '';
            try { d = new Date(it.date).toLocaleString('pt-BR'); } catch(e){}
            li.textContent = it.value + ' (' + d + ')';
            el.appendChild(li);
        });
    });
}

async function runNumberDraw(){
    const minEl = document.getElementById('num_min');
    const maxEl = document.getElementById('num_max');
    const countEl = document.getElementById('num_count');
    const outEl = document.getElementById('resultado_numeros');
    if (!minEl || !maxEl || !countEl || !outEl) return;
    const min = parseInt(minEl.value,10);
    const max = parseInt(maxEl.value,10);
    const count = parseInt(countEl.value,10);
    if (isNaN(min) || isNaN(max) || isNaN(count) || min>max || count<=0) {
        outEl.innerText = 'Valores inválidos.';
        return;
    }
    try {
        const resp = await fetch('/draw/numbers', {
            method: 'POST',
            headers: {'Content-Type':'application/json'},
            body: JSON.stringify({min, max, count})
        });
        if (resp.ok) {
            const data = await resp.json();
            if (data && Array.isArray(data.winners)) {
                outEl.innerHTML = '<p><strong>Vencedores:</strong> ' + data.winners.map(w=>String(w)).join(', ') + '</p>';
                data.winners.forEach(w => pushHistory('numeros', w));
                renderHistory();
                return;
            }
        }
    } catch(e){}
    const pool = [];
    for (let i = min; i <= max; i++) pool.push(i);
    const winners = [];
    for (let k = 0; k < count && pool.length > 0; k++) {
        const idx = Math.floor(Math.random() * pool.length);
        winners.push(pool[idx]);
        pool.splice(idx,1);
    }
    outEl.innerHTML = '<p><strong>Vencedores:</strong> ' + winners.map(w=>String(w)).join(', ') + '</p>';
    winners.forEach(w => pushHistory('numeros', w));
    renderHistory();
}

async function runListDraw(){
    const listEl = document.getElementById('names_input');
    const countEl = document.getElementById('names_count');
    const outEl = document.getElementById('resultado_nomes');
    if (!listEl || !countEl || !outEl) return;
    const arr = parseItems(listEl.value);
    const count = parseInt(countEl.value,10);
    if (!Array.isArray(arr) || arr.length===0 || isNaN(count) || count<=0) {
        outEl.innerText = 'Valores inválidos.';
        return;
    }
    try {
        const resp = await fetch('/draw/names', {
            method: 'POST',
            headers: {'Content-Type':'application/json'},
            body: JSON.stringify({ items: arr, count })
        });
        if (resp.ok) {
            const data = await resp.json();
            if (data && Array.isArray(data.winners)) {
                outEl.innerHTML = '<p><strong>Vencedores:</strong> ' + data.winners.map(w=>String(w)).join(', ') + '</p>';
                data.winners.forEach(w => pushHistory('default', w));
                renderHistory();
                return;
            }
        }
    } catch(e){}
    const pool = arr.slice();
    const winners = [];
    for (let k=0;k<count && pool.length>0;k++){
        const idx = Math.floor(Math.random()*pool.length);
        winners.push(pool[idx]);
        pool.splice(idx,1);
    }
    outEl.innerHTML = '<p><strong>Vencedores:</strong> ' + winners.join(', ') + '</p>';
    winners.forEach(w => pushHistory('default', w));
    renderHistory();
}

function renderCharts(){
    const canvas = document.getElementById('chart_canvas');
    const msgEl = document.getElementById('chart_msg');
    const summaryEl = document.getElementById('chart_summary');
    if (!canvas || !canvas.getContext) {
        if (msgEl) msgEl.innerText = 'Canvas não disponível.';
        return;
    }
    const ctx = canvas.getContext('2d');
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    const rawNames = localStorage.getItem('sorteio_history_default');
    const names = rawNames ? JSON.parse(rawNames) : [];
    const rawNums = localStorage.getItem('sorteio_history_numeros');
    const nums = rawNums ? JSON.parse(rawNums) : [];
    const countMap = {};
    names.forEach(it => { countMap[String(it.value)] = (countMap[String(it.value)] || 0) + 1; });
    nums.forEach(it => { countMap[String(it.value)] = (countMap[String(it.value)] || 0) + 1; });
    const entries = Object.entries(countMap).sort((a,b)=>b[1]-a[1]).slice(0,10);
    if (entries.length===0) {
        if (msgEl) msgEl.innerText = 'Sem dados para mostrar no gráfico.';
        if (summaryEl) summaryEl.innerHTML = '<div>Sem registros</div>';
        return;
    }
    const padding = 40;
    const w = canvas.width - padding*2;
    const h = canvas.height - padding*2;
    const maxCount = entries[0][1];
    const barWidth = w / entries.length;
    ctx.fillStyle = '#ffa500';
    entries.forEach((it, i) => {
        const label = it[0];
        const ct = it[1];
        const barHeight = (ct / maxCount) * h;
        const x = padding + i * barWidth;
        const y = canvas.height - padding - barHeight;
        ctx.fillRect(x, y, barWidth*0.8, barHeight);
    });
    if (summaryEl){
        summaryEl.innerHTML = entries.map(e=>'<div>'+e[0]+': '+e[1]+'</div>').join('');
    }
}

function hideAllTabs(){
    document.querySelectorAll('.tabcontent').forEach(s => s.style.display = 'none');
}

function showTabById(id){
    if (!id) return;
    hideAllTabs();
    var el = document.getElementById(id);
    if (el) el.style.display = 'block';
    if (id === 'tab_graficos') renderCharts();
    renderHistory();
}

function syncActiveButtons(labelText){
    document.querySelectorAll('.inner-tab').forEach(b => b.classList.remove('active'));
    document.querySelectorAll('.inner-tab').forEach(b => {
        if ((b.textContent||'').trim().toLowerCase() === (labelText||'').trim().toLowerCase()) b.classList.add('active');
    });
    document.querySelectorAll('header nav a').forEach(a => {
        a.classList.remove('active');
        if ((a.textContent||'').trim().toLowerCase() === (labelText||'').trim().toLowerCase()) a.classList.add('active');
    });
}

document.addEventListener('DOMContentLoaded', function(){
    renderHistory();
});
