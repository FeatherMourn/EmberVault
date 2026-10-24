(function(){
  const source=document.querySelector('.report-source');
  if(!source)return;
  const lead=document.querySelector('.case-file .lead code');
  const filename=lead?lead.textContent:'research-record';
  const shell=document.createElement('div'); shell.className='editor-shell';
  const bar=document.createElement('div'); bar.className='editor-bar';
  bar.innerHTML='<span class="editor-dot"></span><span class="editor-dot amber"></span><span class="editor-dot green"></span><span class="editor-file">'+filename.replace(/[<>&"']/g,'')+'</span><span class="editor-state">READ ONLY</span>';
  source.parentNode.insertBefore(shell,source); shell.appendChild(bar); shell.appendChild(source);
  const text=source.textContent.replace(/\r\n/g,'\n'); source.textContent='';
  text.split('\n').forEach(function(line){const span=document.createElement('span');span.className='code-line';span.textContent=line||' ';source.appendChild(span);});
})();
