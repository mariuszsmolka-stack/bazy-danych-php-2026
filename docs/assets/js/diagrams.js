// Biblioteka lokalna jest ładowana przed tym skryptem przez defer.
(async () => {
  const figury = document.querySelectorAll('.lesson-diagram');
  if (!figury.length) return;
  try {
    if (!window.mermaid) throw new Error('Nie załadowano biblioteki Mermaid.');
    window.mermaid.initialize({ startOnLoad: false, securityLevel: 'strict', theme: 'neutral', suppressErrorRendering: true,
      flowchart: { htmlLabels: false, useMaxWidth: true } });
  } catch (blad) {
    console.warn('Nie udało się uruchomić diagramów; pozostawiono schematy tekstowe.', blad);
    return;
  }
  for (const [indeks, figura] of Array.from(figury).entries()) {
    const zrodlo = figura.querySelector('.mermaid-source');
    const schemat = figura.querySelector('.diagram-fallback');
    const diagram = document.createElement('div');
    diagram.className = 'diagram-rendered';
    try {
      if (!zrodlo) throw new Error('Brak źródła diagramu.');
      zrodlo.hidden = true;
      const { svg } = await window.mermaid.render(`lesson-flow-${indeks}`, zrodlo.textContent.trim());
      diagram.innerHTML = svg;
      if (!diagram.querySelector('svg')) throw new Error('Nie wygenerowano SVG.');
      figura.insertBefore(diagram, zrodlo);
      if (schemat) schemat.hidden = true;
    } catch (blad) {
      diagram.remove();
      if (schemat) schemat.hidden = false;
      console.warn(`Nie udało się wyświetlić diagramu ${indeks + 1}; pozostawiono schemat tekstowy.`, blad);
    }
  }
})();
