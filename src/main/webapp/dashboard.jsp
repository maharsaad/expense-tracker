<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String loggedInUser = (String) session.getAttribute("loggedInUser");
    if (loggedInUser == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Finance Dashboard</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600;700&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg:#f0f2f5; --surface:#fff; --surface2:#f8fafc; --border:#e2e8f0;
            --text:#0f172a; --muted:#64748b; --light:#94a3b8;
            --green:#059669; --green-l:#d1fae5; --red:#dc2626; --red-l:#fee2e2;
            --orange:#ea580c; --blue:#2563eb; --r:16px;
            --sh:0 1px 3px rgba(0,0,0,.08); --sh2:0 4px 16px rgba(0,0,0,.1);
        }
        *{margin:0;padding:0;box-sizing:border-box;}
        body{font-family:'DM Sans',sans-serif;background:var(--bg);color:var(--text);min-height:100vh;}
        .header{background:var(--surface);padding:1.25rem 2rem;border-bottom:1px solid var(--border);display:flex;justify-content:space-between;align-items:center;position:sticky;top:0;z-index:100;}
        .header h1{font-size:1.25rem;font-weight:600;}
        .header-right{display:flex;align-items:center;gap:1rem;}
        .user-badge{display:flex;align-items:center;gap:.6rem;background:var(--surface2);border:1px solid var(--border);border-radius:50px;padding:.4rem 1rem .4rem .4rem;font-size:.85rem;font-weight:500;}
        .avatar{width:30px;height:30px;border-radius:50%;background:linear-gradient(135deg,#059669,#10b981);display:flex;align-items:center;justify-content:center;color:white;font-size:.75rem;font-weight:700;}
        .logout-btn{background:none;border:1px solid var(--border);border-radius:8px;padding:.5rem 1rem;font-size:.8rem;font-weight:500;color:var(--muted);cursor:pointer;transition:all .2s;}
        .logout-btn:hover{background:var(--red-l);border-color:var(--red);color:var(--red);}
        .main{padding:2rem;max-width:1400px;margin:0 auto;}
        .stats-row{display:grid;grid-template-columns:1fr 1fr 1fr 360px;gap:1.5rem;margin-bottom:1.5rem;}
        .mid-row{display:grid;grid-template-columns:2fr 1fr;gap:1.5rem;margin-bottom:1.5rem;}
        .card{background:var(--surface);border-radius:var(--r);padding:1.5rem;box-shadow:var(--sh);border:1px solid var(--border);transition:transform .2s,box-shadow .2s;}
        .card:hover{transform:translateY(-2px);box-shadow:var(--sh2);}
        .card-label{font-size:.78rem;font-weight:600;color:var(--muted);text-transform:uppercase;letter-spacing:.06em;margin-bottom:.75rem;}
        .stat-amount{font-family:'DM Mono',monospace;font-size:2rem;font-weight:500;margin-bottom:.5rem;}
        .stat-badge{display:inline-flex;align-items:center;gap:.3rem;font-size:.78rem;font-weight:600;padding:.2rem .6rem;border-radius:20px;}
        .badge-green{background:var(--green-l);color:var(--green);}
        .badge-red{background:var(--red-l);color:var(--red);}
        .bank-card{background:linear-gradient(135deg,#0f172a 0%,#1e3a5f 50%,#0f172a 100%);border:none;color:white;position:relative;overflow:hidden;min-height:200px;}
        .bank-card-label{font-size:.72rem;font-weight:600;opacity:.5;text-transform:uppercase;letter-spacing:.08em;margin-bottom:1rem;}
        .chip{width:36px;height:26px;background:linear-gradient(135deg,#fbbf24,#d97706);border-radius:5px;margin-bottom:1.25rem;position:relative;z-index:1;}
        .card-num{font-family:'DM Mono',monospace;font-size:1rem;letter-spacing:.15em;opacity:.85;margin-bottom:1rem;position:relative;z-index:1;}
        .card-owner{font-size:.8rem;font-weight:600;opacity:.7;text-transform:uppercase;letter-spacing:.08em;position:relative;z-index:1;}
        .mastercard-logo{position:absolute;bottom:1.25rem;right:1.25rem;display:flex;z-index:1;}
        .mc-circle{width:28px;height:28px;border-radius:50%;}
        .mc-red{background:#ef4444;}
        .mc-orange{background:#f59e0b;margin-left:-10px;opacity:.85;}
        .chart-wrap{margin-top:1rem;background:var(--surface2);border-radius:10px;padding:1.25rem 1.25rem .5rem;}
        .bars{display:flex;align-items:flex-end;justify-content:space-between;height:180px;gap:6px;}
        .bar-group{display:flex;flex-direction:column;align-items:center;gap:3px;flex:1;}
        .bar-income{background:var(--green);border-radius:4px 4px 0 0;width:100%;min-height:2px;}
        .bar-expense{background:var(--orange);border-radius:4px 4px 0 0;width:100%;min-height:2px;}
        .chart-legend{display:flex;gap:1.5rem;font-size:.78rem;color:var(--muted);}
        .legend-dot{display:inline-block;width:8px;height:8px;border-radius:50%;margin-right:5px;}
        .breakdown-total{font-family:'DM Mono',monospace;font-size:1.6rem;font-weight:500;margin-bottom:1.25rem;}
        .color-strip{height:5px;border-radius:3px;background:linear-gradient(to right,var(--orange),#f59e0b,#eab308,var(--green));margin-bottom:1.25rem;}
        .cat-list{list-style:none;}
        .cat-item{display:flex;justify-content:space-between;align-items:center;padding:.6rem 0;border-bottom:1px solid var(--border);font-size:.875rem;}
        .cat-item:last-child{border-bottom:none;}
        .cat-info{display:flex;align-items:center;gap:.6rem;}
        .cat-dot{width:8px;height:8px;border-radius:50%;}
        .cat-amount{font-family:'DM Mono',monospace;font-size:.85rem;font-weight:500;}
        .transactions-card{margin-bottom:6rem;}
        .tx-title{font-size:1rem;font-weight:600;margin-bottom:1rem;}
        table{width:100%;border-collapse:collapse;}
        th{text-align:left;padding:.75rem 1rem;font-size:.78rem;font-weight:600;color:var(--muted);text-transform:uppercase;letter-spacing:.04em;border-bottom:2px solid var(--border);}
        td{padding:1rem;font-size:.875rem;border-bottom:1px solid var(--surface2);}
        tr:last-child td{border-bottom:none;}
        tr:hover td{background:var(--surface2);}
        .tx-income{font-family:'DM Mono',monospace;font-weight:600;color:var(--green);}
        .tx-expense{font-family:'DM Mono',monospace;font-weight:600;color:var(--red);}
        .status-pill{display:inline-block;padding:.2rem .7rem;border-radius:20px;font-size:.72rem;font-weight:600;background:var(--green-l);color:var(--green);}
        .type-badge{display:inline-flex;align-items:center;gap:.3rem;font-size:.78rem;padding:.2rem .6rem;border-radius:6px;}
        .type-income{background:var(--green-l);color:var(--green);}
        .type-expense{background:var(--red-l);color:var(--red);}
        .empty-state{text-align:center;padding:3rem;color:var(--muted);}
        .empty-state i{font-size:2.5rem;margin-bottom:1rem;opacity:.3;display:block;}
        .fabs{position:fixed;bottom:2rem;right:2rem;display:flex;flex-direction:column;gap:.75rem;z-index:200;}
        .fab-wrap{position:relative;display:flex;align-items:center;}
        .fab{width:52px;height:52px;border-radius:50%;border:none;cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:1.2rem;color:white;box-shadow:0 4px 16px rgba(0,0,0,.2);transition:transform .2s;}
        .fab:hover{transform:scale(1.1);}
        .fab-income{background:var(--green);}
        .fab-expense{background:var(--red);}
        .fab-label{position:absolute;right:65px;white-space:nowrap;background:var(--text);color:white;font-size:.75rem;padding:.3rem .7rem;border-radius:6px;opacity:0;transition:opacity .2s;pointer-events:none;}
        .fab-wrap:hover .fab-label{opacity:1;}
        .modal{display:none;position:fixed;inset:0;background:rgba(0,0,0,.45);z-index:1000;align-items:center;justify-content:center;}
        .modal.open{display:flex;}
        .modal-box{background:var(--surface);border-radius:var(--r);width:460px;max-width:94vw;box-shadow:var(--sh2);animation:popIn .25s ease;}
        @keyframes popIn{from{transform:scale(.95);opacity:0;}to{transform:scale(1);opacity:1;}}
        .modal-head{padding:1.25rem 1.5rem;border-bottom:1px solid var(--border);display:flex;justify-content:space-between;align-items:center;}
        .modal-head h3{font-size:1.1rem;font-weight:600;}
        .close-x{background:none;border:none;font-size:1.4rem;color:var(--muted);cursor:pointer;}
        .modal-body{padding:1.5rem;}
        .field{margin-bottom:1rem;}
        .field label{display:block;font-size:.8rem;font-weight:600;color:var(--muted);margin-bottom:.4rem;text-transform:uppercase;letter-spacing:.04em;}
        .field input,.field select{width:100%;padding:.75rem 1rem;border:1.5px solid var(--border);border-radius:10px;font-size:.9rem;font-family:'DM Sans',sans-serif;background:var(--surface2);color:var(--text);outline:none;transition:border-color .2s;}
        .field input:focus,.field select:focus{border-color:var(--blue);background:white;}
        .modal-foot{padding:1.25rem 1.5rem;border-top:1px solid var(--border);display:flex;justify-content:flex-end;gap:.75rem;}
        .btn{padding:.7rem 1.4rem;border-radius:10px;font-size:.875rem;font-weight:600;font-family:'DM Sans',sans-serif;cursor:pointer;border:none;transition:all .2s;}
        .btn-cancel{background:var(--surface2);color:var(--muted);border:1px solid var(--border);}
        .btn-green{background:var(--green);color:white;}
        .btn-green:hover{background:#047857;}
        .btn-red{background:var(--red);color:white;}
        .btn-red:hover{background:#b91c1c;}
        .notif{position:fixed;top:1.5rem;right:1.5rem;padding:.9rem 1.4rem;border-radius:10px;font-size:.875rem;font-weight:600;color:white;box-shadow:var(--sh2);z-index:2000;animation:slideIn .3s ease;}
        @keyframes slideIn{from{transform:translateX(120%);opacity:0;}to{transform:translateX(0);opacity:1;}}
        .notif-success{background:var(--green);}
        .notif-error{background:var(--red);}
        @media(max-width:1200px){.stats-row{grid-template-columns:1fr 1fr;}.mid-row{grid-template-columns:1fr;}}
        @media(max-width:768px){.stats-row{grid-template-columns:1fr;}.main{padding:1rem;}.header{padding:1rem;}}
    </style>
</head>
<body>

<header class="header">
    <h1>Finance Dashboard</h1>
    <div class="header-right">
        <div class="user-badge">
            <div class="avatar" id="userAvatar"></div>
            <span id="usernameDisplay"></span>
        </div>
        <button class="logout-btn" onclick="logout()">
            <i class="fas fa-sign-out-alt"></i> Logout
        </button>
    </div>
</header>

<main class="main">
    <div class="stats-row">
        <div class="card">
            <div class="card-label">Monthly Income</div>
            <div class="stat-amount" id="totalIncome">$0.00</div>
            <span class="stat-badge badge-green"><i class="fas fa-arrow-up"></i> This month</span>
        </div>
        <div class="card">
            <div class="card-label">Monthly Expenses</div>
            <div class="stat-amount" id="totalExpenses">$0.00</div>
            <span class="stat-badge badge-red"><i class="fas fa-arrow-down"></i> This month</span>
        </div>
        <div class="card">
            <div class="card-label">Net Balance</div>
            <div class="stat-amount" id="netBalance">$0.00</div>
            <span class="stat-badge" id="balanceBadge">Savings</span>
        </div>
        <div class="card bank-card">
            <div class="bank-card-label">My Card</div>
            <div class="chip"></div>
            <div class="card-num">**** **** **** 0015</div>
            <div class="card-owner" id="cardOwner"></div>
            <div class="mastercard-logo">
                <div class="mc-circle mc-red"></div>
                <div class="mc-circle mc-orange"></div>
            </div>
        </div>
    </div>

    <div class="mid-row">
        <div class="card">
            <div style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:.5rem;">
                <div class="card-label">Overview - Last 6 Months</div>
                <div class="chart-legend">
                    <span><span class="legend-dot" style="background:var(--green)"></span>Income</span>
                    <span><span class="legend-dot" style="background:var(--orange)"></span>Expenses</span>
                </div>
            </div>
            <div class="chart-wrap">
                <div class="bars" id="chartBars">
                    <div style="color:var(--muted);font-size:.85rem;padding:1rem;">Loading...</div>
                </div>
                <div style="display:flex;justify-content:space-between;margin-top:4px;" id="chartLabels"></div>
            </div>
        </div>
        <div class="card">
            <div class="card-label">Expenses by Category</div>
            <div class="breakdown-total" id="breakdownTotal">$0.00</div>
            <div class="color-strip"></div>
            <ul class="cat-list" id="catList"></ul>
        </div>
    </div>

    <div class="card transactions-card">
        <div class="tx-title">Recent Transactions</div>
        <table>
            <thead>
            <tr>
                <th>Date</th><th>Type</th><th>Category</th>
                <th>Description</th><th>Amount</th><th>Status</th>
            </tr>
            </thead>
            <tbody id="txBody"></tbody>
        </table>
        <div class="empty-state" id="emptyState" style="display:none;">
            <i class="fas fa-receipt"></i>
            <p>No transactions yet. Use the buttons below to add one!</p>
        </div>
    </div>
</main>

<div class="fabs">
    <div class="fab-wrap">
        <span class="fab-label">Add Income</span>
        <button class="fab fab-income" onclick="openModal('incomeModal')">
            <i class="fas fa-plus"></i>
        </button>
    </div>
    <div class="fab-wrap">
        <span class="fab-label">Add Expense</span>
        <button class="fab fab-expense" onclick="openModal('expenseModal')">
            <i class="fas fa-minus"></i>
        </button>
    </div>
</div>

<div class="modal" id="incomeModal">
    <div class="modal-box">
        <div class="modal-head">
            <h3><i class="fas fa-plus-circle" style="color:var(--green);margin-right:.5rem;"></i>Add Income</h3>
            <button class="close-x" onclick="closeModal('incomeModal')">&times;</button>
        </div>
        <div class="modal-body">
            <div class="field"><label>Amount ($)</label><input type="number" id="incomeAmount" placeholder="0.00" min="0.01" step="0.01"></div>
            <div class="field"><label>Category</label>
                <select id="incomeCategory">
                    <option value="">Select category</option>
                    <option value="Salary">Salary</option>
                    <option value="Freelance">Freelance</option>
                    <option value="Business">Business</option>
                    <option value="Investment">Investment Returns</option>
                    <option value="Other">Other</option>
                </select>
            </div>
            <div class="field"><label>Description</label><input type="text" id="incomeDescription" placeholder="Optional note"></div>
            <div class="field"><label>Date</label><input type="date" id="incomeDate"></div>
        </div>
        <div class="modal-foot">
            <button class="btn btn-cancel" onclick="closeModal('incomeModal')">Cancel</button>
            <button class="btn btn-green" onclick="submitTransaction('income')"><i class="fas fa-check"></i> Add Income</button>
        </div>
    </div>
</div>

<div class="modal" id="expenseModal">
    <div class="modal-box">
        <div class="modal-head">
            <h3><i class="fas fa-minus-circle" style="color:var(--red);margin-right:.5rem;"></i>Add Expense</h3>
            <button class="close-x" onclick="closeModal('expenseModal')">&times;</button>
        </div>
        <div class="modal-body">
            <div class="field"><label>Amount ($)</label><input type="number" id="expenseAmount" placeholder="0.00" min="0.01" step="0.01"></div>
            <div class="field"><label>Category</label>
                <select id="expenseCategory">
                    <option value="">Select category</option>
                    <option value="Food">Food and Health</option>
                    <option value="Entertainment">Entertainment</option>
                    <option value="Shopping">Shopping</option>
                    <option value="Transport">Transport</option>
                    <option value="Utilities">Utilities</option>
                    <option value="Investment">Investment</option>
                    <option value="Other">Other</option>
                </select>
            </div>
            <div class="field"><label>Description</label><input type="text" id="expenseDescription" placeholder="Optional note"></div>
            <div class="field"><label>Date</label><input type="date" id="expenseDate"></div>
        </div>
        <div class="modal-foot">
            <button class="btn btn-cancel" onclick="closeModal('expenseModal')">Cancel</button>
            <button class="btn btn-red" onclick="submitTransaction('expense')"><i class="fas fa-check"></i> Add Expense</button>
        </div>
    </div>
</div>

<script>
    var BASE = '<%=contextPath%>';
    var USERNAME = '<%=loggedInUser%>';
    var today = new Date().toISOString().split('T')[0];

    document.getElementById('userAvatar').textContent = USERNAME.charAt(0).toUpperCase();
    document.getElementById('usernameDisplay').textContent = USERNAME;
    document.getElementById('cardOwner').textContent = USERNAME.toUpperCase();
    document.getElementById('incomeDate').value = today;
    document.getElementById('expenseDate').value = today;

    function openModal(id) {
        document.getElementById(id).classList.add('open');
        document.body.style.overflow = 'hidden';
    }

    function closeModal(id) {
        document.getElementById(id).classList.remove('open');
        document.body.style.overflow = '';
        var inputs = document.getElementById(id).querySelectorAll('input,select');
        for (var i = 0; i < inputs.length; i++) {
            inputs[i].value = inputs[i].type === 'date' ? today : '';
        }
    }

    window.onclick = function(e) {
        if (e.target === document.getElementById('incomeModal')) closeModal('incomeModal');
        if (e.target === document.getElementById('expenseModal')) closeModal('expenseModal');
    };

    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') { closeModal('incomeModal'); closeModal('expenseModal'); }
    });

    function submitTransaction(type) {
        var amount   = parseFloat(document.getElementById(type + 'Amount').value);
        var category = document.getElementById(type + 'Category').value;
        var desc     = document.getElementById(type + 'Description').value;
        var date     = document.getElementById(type + 'Date').value;

        if (!amount || amount <= 0 || !category || !date) {
            showNotif('Please fill in all required fields.', 'error');
            return;
        }

        var params = new URLSearchParams();
        params.append('type',        type);
        params.append('amount',      amount);
        params.append('category',    category);
        params.append('description', desc);
        params.append('date',        date);

        fetch(BASE + '/transaction', { method: 'POST', body: params })
            .then(function(res) { return res.json(); })
            .then(function(data) {
                if (data.status === 'success') {
                    closeModal(type + 'Modal');
                    showNotif(type === 'income' ? 'Income added!' : 'Expense recorded!', 'success');
                    loadData();
                } else {
                    showNotif(data.message || 'Error saving.', 'error');
                }
            })
            .catch(function(err) {
                console.error(err);
                showNotif('Network error - check Tomcat console.', 'error');
            });
    }

    function loadData() {
        fetch(BASE + '/transaction?action=list')
            .then(function(res) { return res.json(); })
            .then(function(data) {
                renderStats(data.summary);
                renderTransactions(data.transactions);
                renderChart(data.monthly);
                renderBreakdown(data.categories);
            })
            .catch(function(err) {
                console.error('Load error:', err);
                document.getElementById('chartBars').innerHTML =
                    '<div style="color:red;padding:1rem;">Failed to load. Check console.</div>';
            });
    }

    function renderStats(s) {
        var income   = s.totalIncome   || 0;
        var expenses = s.totalExpenses || 0;
        var net      = income - expenses;
        document.getElementById('totalIncome').textContent   = fmt(income);
        document.getElementById('totalExpenses').textContent = fmt(expenses);
        document.getElementById('netBalance').textContent    = fmt(net);
        var badge = document.getElementById('balanceBadge');
        badge.textContent = net >= 0 ? 'Positive' : 'Deficit';
        badge.className   = 'stat-badge ' + (net >= 0 ? 'badge-green' : 'badge-red');
    }

    function renderTransactions(txs) {
        var tbody = document.getElementById('txBody');
        var empty = document.getElementById('emptyState');
        if (!txs || txs.length === 0) {
            tbody.innerHTML = '';
            empty.style.display = 'block';
            return;
        }
        empty.style.display = 'none';
        var html = '';
        for (var i = 0; i < txs.length; i++) {
            var t = txs[i];
            var isIncome = t.type === 'income';
            html += '<tr>';
            html += '<td>' + fmtDate(t.date) + '</td>';
            html += '<td><span class="type-badge ' + (isIncome ? 'type-income' : 'type-expense') + '">';
            html += '<i class="fas fa-arrow-' + (isIncome ? 'up' : 'down') + '"></i> ';
            html += (isIncome ? 'Income' : 'Expense') + '</span></td>';
            html += '<td>' + t.category + '</td>';
            html += '<td style="color:var(--muted);font-size:.82rem;">' + (t.description || '-') + '</td>';
            html += '<td class="' + (isIncome ? 'tx-income' : 'tx-expense') + '">';
            html += (isIncome ? '+' : '-') + fmt(Math.abs(t.amount)) + '</td>';
            html += '<td><span class="status-pill">Success</span></td>';
            html += '</tr>';
        }
        tbody.innerHTML = html;
    }

    function renderChart(monthly) {
        var bars   = document.getElementById('chartBars');
        var labels = document.getElementById('chartLabels');
        if (!monthly || monthly.length === 0) {
            bars.innerHTML = '<div style="color:var(--muted);font-size:.85rem;padding:1rem;">No data yet - add some transactions!</div>';
            labels.innerHTML = '';
            return;
        }
        var maxVal = 1;
        for (var i = 0; i < monthly.length; i++) {
            if (monthly[i].income   > maxVal) maxVal = monthly[i].income;
            if (monthly[i].expenses > maxVal) maxVal = monthly[i].expenses;
        }
        var maxH = 150;
        var barsHtml = '';
        var labelsHtml = '';
        for (var i = 0; i < monthly.length; i++) {
            var ih = Math.max(Math.round((monthly[i].income   / maxVal) * maxH), 2);
            var eh = Math.max(Math.round((monthly[i].expenses / maxVal) * maxH), 2);
            barsHtml += '<div class="bar-group">';
            barsHtml += '<div class="bar-income"  style="height:' + ih + 'px"></div>';
            barsHtml += '<div class="bar-expense" style="height:' + eh + 'px"></div>';
            barsHtml += '</div>';
            labelsHtml += '<span style="font-size:.68rem;color:var(--light);flex:1;text-align:center;">' + monthly[i].month + '</span>';
        }
        bars.innerHTML   = barsHtml;
        labels.innerHTML = labelsHtml;
    }

    function renderBreakdown(cats) {
        var colors = {
            'Food':'#ea580c','Entertainment':'#f59e0b','Shopping':'#eab308',
            'Transport':'#3b82f6','Utilities':'#8b5cf6','Investment':'#10b981',
            'Other':'#94a3b8','Salary':'#059669','Freelance':'#06b6d4','Business':'#6366f1'
        };
        var list  = document.getElementById('catList');
        var total = document.getElementById('breakdownTotal');
        if (!cats || cats.length === 0) {
            list.innerHTML = '<li class="cat-item" style="color:var(--muted)">No expense data this month</li>';
            total.textContent = '$0.00';
            return;
        }
        var sum = 0;
        for (var i = 0; i < cats.length; i++) sum += cats[i].total;
        total.textContent = fmt(sum);
        var html = '';
        var limit = cats.length > 6 ? 6 : cats.length;
        for (var i = 0; i < limit; i++) {
            var c = cats[i];
            var color = colors[c.category] || '#94a3b8';
            html += '<li class="cat-item">';
            html += '<div class="cat-info"><div class="cat-dot" style="background:' + color + '"></div><span>' + c.category + '</span></div>';
            html += '<span class="cat-amount">' + fmt(c.total) + '</span>';
            html += '</li>';
        }
        list.innerHTML = html;
    }

    function fmt(n) {
        return '$' + Number(n).toLocaleString('en-US', {minimumFractionDigits:2, maximumFractionDigits:2});
    }

    function fmtDate(d) {
        if (!d) return '-';
        var date = new Date(d);
        var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
        return months[date.getMonth()] + ' ' + date.getDate() + ', ' + date.getFullYear();
    }

    function showNotif(msg, type) {
        var n = document.createElement('div');
        n.className = 'notif notif-' + type;
        n.textContent = msg;
        document.body.appendChild(n);
        setTimeout(function() { n.remove(); }, 3500);
    }

    function logout() {
        var params = new URLSearchParams();
        params.append('action', 'logout');
        fetch(BASE + '/auth', {method:'POST', body:params})
            .then(function() {
                window.location.href = BASE + '/index.jsp';
            });
    }

    loadData();
</script>
</body>
</html>