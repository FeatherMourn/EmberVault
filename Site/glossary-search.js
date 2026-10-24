const glossaryInput = document.querySelector('#glossary-query');
const glossaryResults = document.querySelector('#glossary-results');

function escapeHtml(value) {
  return String(value ?? '').replace(/[&<>"']/g, c => ({
    '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;'
  }[c]));
}

async function loadGlossary() {
  const response = await fetch('data/site-index.json');
  if (!response.ok) throw new Error('site index');
  const records = await response.json();
  const stat = document.querySelector('.stats strong');
  if (stat) stat.textContent = records.length;

  function render() {
    const query = (glossaryInput.value || '').trim().toLowerCase();
    const terms = query.split(/\s+/).filter(Boolean);
    const matches = records.map(record => {
      const haystack = [record.title, record.category, record.record_type,
        record.keywords, record.source_path, record.summary].join(' ').toLowerCase();
      const score = terms.reduce((n, term) => n + (haystack.includes(term) ? 1 : 0), 0);
      return { ...record, score };
    }).filter(record => !terms.length || record.score === terms.length)
      .sort((a, b) => b.score - a.score || a.title.localeCompare(b.title));

    glossaryResults.innerHTML = matches.map(record => `
      <a class="glossary-result" href="${escapeHtml(record.url)}">
        <span class="eyebrow">${escapeHtml(record.category)} · ${escapeHtml(record.record_type)}</span>
        <h3>${escapeHtml(record.title)}</h3>
        <p>${escapeHtml(record.summary)}</p>
        <small>${escapeHtml(record.source_path)} · Enshrouded ${escapeHtml(record.game_version)}</small>
        <span class="text-link">Open page →</span>
      </a>`).join('') || '<p class="empty-state">No indexed page matches that search.</p>';
  }

  glossaryInput.addEventListener('input', render);
  render();
}

loadGlossary().catch(error => {
  glossaryResults.innerHTML = '<p class="empty-state">The search index could not be loaded.</p>';
  console.error(error);
});
