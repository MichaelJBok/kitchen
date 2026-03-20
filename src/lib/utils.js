export function parseQty(s) {
  s = s.trim()
  const mixed = /^(\d+)\s+(\d+)\/(\d+)$/.exec(s)
  if (mixed) return +mixed[1] + +mixed[2] / +mixed[3]
  const frac = /^(\d+)\/(\d+)$/.exec(s)
  if (frac) return +frac[1] / +frac[2]
  const n = parseFloat(s)
  return isNaN(n) ? null : n
}

export function formatQty(n) {
  if (n === Math.round(n)) return String(Math.round(n))
  const fracs = [[1,8],[1,4],[1,3],[3,8],[1,2],[5,8],[2,3],[3,4],[7,8]]
  for (const [a, b] of fracs) {
    const w = Math.floor(n), r = n - w
    if (Math.abs(r - a/b) < 0.04) return w > 0 ? `${w} ${a}/${b}` : `${a}/${b}`
  }
  return parseFloat(n.toFixed(2)).toString()
}

export function scaleAmt(s, factor) {
  if (factor === 1) return s
  const m = s.match(/^(\d+\s+\d+\/\d+|\d+\/\d+|\d*\.?\d+)\s*(.*)$/)
  if (!m) return s
  const q = parseQty(m[1])
  if (q === null) return s
  return formatQty(q * factor) + (m[2] ? ' ' + m[2] : '')
}

export function resizeImage(file) {
  return new Promise((resolve) => {
    const reader = new FileReader()
    reader.onload = (ev) => {
      const img = new Image()
      img.onload = () => {
        let w = img.width, h = img.height
        if (w > 1200) { h = Math.round(h * 1200 / w); w = 1200 }
        if (h > 900) { w = Math.round(w * 900 / h); h = 900 }
        const canvas = document.createElement('canvas')
        canvas.width = w; canvas.height = h
        canvas.getContext('2d').drawImage(img, 0, 0, w, h)
        canvas.toBlob((blob) => resolve(blob), 'image/jpeg', 0.82)
      }
      img.src = ev.target.result
    }
    reader.readAsDataURL(file)
  })
}
