const searchInputs=[document.querySelector('#report-search'),document.querySelector('#report-filter')].filter(Boolean);
const indexHeading=document.querySelector('.record-column .section-heading h2');
const sort=document.querySelector('#report-sort');
const recordsEl=document.querySelector('#report-records');
const inspector=document.querySelector('#report-inspector');
let records=[];
if(indexHeading)indexHeading.textContent='Reports A–Z';
const filterLabel=document.querySelector('#report-filter')?.closest('label');
if(filterLabel)filterLabel.firstChild.textContent='Keyword search';
const heroSearch=document.querySelector('#report-search');
if(heroSearch)heroSearch.placeholder='Search report content...';
const filterSearch=document.querySelector('#report-filter');
if(filterSearch)filterSearch.placeholder='Search report content...';
function escapeHtml(value){return String(value??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]))}
function renderError(){recordsEl.innerHTML='<p class="empty-state">The report index could not load. Open this site through a local web server so the report index can be read.</p>';document.querySelector('#report-count').textContent='Index unavailable'}
function setSearch(value,source){searchInputs.forEach(input=>{if(input!==source)input.value=value})}
function render(){const q=(searchInputs[0]?.value||'').toLowerCase().trim();let list=records.filter(x=>(x.title+' '+x.text+' '+x.source).toLowerCase().includes(q));list.sort((a,b)=>sort.value==='za'?a.title.localeCompare(b.title)*-1:a.title.localeCompare(b.title));document.querySelector('#report-count').textContent=`${list.length} reports`;recordsEl.innerHTML=list.map(x=>`<article class="archive-record" data-report-index="${records.indexOf(x)}"><span class="eyebrow">Source report</span><h3>${escapeHtml(x.title)}</h3><p>${escapeHtml(x.text)}</p><div class="record-meta"><span>${escapeHtml(x.source)}</span></div></article>`).join('')||'<p class="empty-state">No reports match this keyword.</p>';recordsEl.querySelectorAll('[data-report-index]').forEach(el=>el.addEventListener('click',()=>inspect(Number(el.dataset.reportIndex))));if(list.length)inspect(records.indexOf(list[0]))}
function inspect(index){const x=records[index];if(!x)return;recordsEl.querySelectorAll('.archive-record').forEach(el=>el.classList.toggle('selected',Number(el.dataset.reportIndex)===index));inspector.innerHTML=`<p class="eyebrow">Source report</p><h2>${escapeHtml(x.title)}</h2><p>${escapeHtml(x.text)}</p><p><strong>Source</strong><br><code>${escapeHtml(x.source)}</code></p><p><a class="primary-action" href="${escapeHtml(x.url)}">Open full report →</a></p>`}
searchInputs.forEach(input=>input.addEventListener('input',()=>{setSearch(input.value,input);render()}));
sort.addEventListener('change',render);
fetch('data/report-index.json').then(r=>{if(!r.ok)throw new Error('index');return r.json()}).then(data=>{records=data;render()}).catch(renderError);
