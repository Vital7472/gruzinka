// Загрузка общих компонентов
async function loadComponent(id, url) {
    const response = await fetch(url);
    const html = await response.text();
    document.getElementById(id).innerHTML = html;
}

// Загрузка пользовательских ссылок
async function loadCustomLinks() {
    const response = await fetch('custom-links.json');
    const links = await response.json();
    const container = document.getElementById('custom-links');
    
    links.forEach(link => {
        const button = document.createElement('button');
        button.className = 'btn btn-success btn-lg btn-block w-100 mb-3';
        button.textContent = link.text;
        button.onclick = () => window.location.href = link.url;
        container.appendChild(button);
    });
}

// Инициализация страницы
async function initPage() {
    await Promise.all([
        loadComponent('header', 'header.html'),
        loadComponent('footer', 'footer.html'),
        loadComponent('carousel', 'carousel.html'),
        loadCustomLinks()
    ]);
}

window.onload = initPage;
