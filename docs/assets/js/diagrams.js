// Błąd biblioteki nie blokuje lekcji: pozostaje czytelny schemat tekstowy.
const figures = document.querySelectorAll('.lesson-diagram');
if (figures.length) {
  try {
    const { default: mermaid } = await import('https://cdn.jsdelivr.net/npm/mermaid@11.12.0/dist/mermaid.esm.min.mjs');
    mermaid.initialize({ startOnLoad: false, securityLevel: 'strict', theme: 'neutral',
      flowchart: { htmlLabels: false, useMaxWidth: true } });
    for (const [index, figure] of Array.from(figures).entries()) {
      const source = figure.querySelector('.mermaid-source');
      const { svg } = await mermaid.render(`lesson-flow-${index}`, source.textContent.trim());
      const diagram = document.createElement('div');
      diagram.className = 'diagram-rendered';
      diagram.innerHTML = svg;
      figure.insertBefore(diagram, source);
      figure.querySelector('.diagram-fallback').hidden = true;
    }
  } catch (error) {
    console.warn('Nie udało się wyświetlić diagramu; pozostawiono schemat tekstowy.', error);
  }
}
