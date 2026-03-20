import { scaleAmt, formatQty } from './utils'

export async function copyRecipeText(r, servings, factor) {
  const base = r.servings || 4
  const lines = []
  lines.push(r.name)
  lines.push('By ' + r.author + (r.category ? ' - ' + r.category : ''))
  lines.push(servings !== base ? `Servings: ${servings} (scaled from ${base})` : `Servings: ${servings}`)
  lines.push('')
  lines.push('INGREDIENTS')
  lines.push('------------------------------')
  ;(r.ing_groups || []).forEach(g => {
    if (g.label) lines.push('\n' + g.label.toUpperCase())
    ;(g.items || []).forEach(i => lines.push('  ' + scaleAmt(i.amt, factor) + '  ' + i.item))
  })
  lines.push('')
  lines.push('STEPS')
  lines.push('------------------------------')
  ;(r.steps || []).forEach((s, i) => {
    lines.push(`${i + 1}. ${s.text}`)
    if (s.subs && s.subs.length) s.subs.forEach(b => lines.push('   - ' + b))
  })
  if (r.notes) {
    lines.push('')
    lines.push('NOTES')
    lines.push('------------------------------')
    lines.push(r.notes)
  }
  const text = lines.join('\n')
  try {
    await navigator.clipboard.writeText(text)
  } catch {
    const ta = document.createElement('textarea')
    ta.value = text
    ta.style.cssText = 'position:fixed;opacity:0'
    document.body.appendChild(ta)
    ta.select()
    document.execCommand('copy')
    document.body.removeChild(ta)
  }
}

export async function copyRecipeImage(r, servings, factor) {
  const W = 640, PAD = 40, COL1 = 130
  const C = {
    bg: '#FAF7F2', white: '#FFFFFF', ink: '#1C1A17', muted: '#6B6560',
    faint: '#AEA9A3', accent: '#C4501A', accentLight: '#FAF0EB',
    surface: '#F5F1EB', border: 'rgba(28,26,23,0.12)', borderMed: 'rgba(28,26,23,0.22)',
  }

  function measureH() {
    let y = PAD + 16
    if (r.photo_url) y += 200 + 16
    y += 34 + 22 + 28 + 20
    y += 22 + 16
    ;(r.ing_groups || []).forEach(g => {
      if (g.label) y += 28
      y += (g.items || []).length * 26 + 4
    })
    y += 20 + 20
    ;(r.steps || []).forEach(s => {
      y += Math.ceil(s.text.length * 7.5 / (W - PAD * 2 - 36)) * 22 + 8
      if (s.subs && s.subs.length) y += s.subs.length * 20 + 4
    })
    if (r.notes) y += 20 + 16 + 56
    y += PAD
    return Math.max(y, 400)
  }

  const H = measureH()
  const scale = 2
  const canvas = document.createElement('canvas')
  canvas.width = W * scale
  canvas.height = H * scale
  const ctx = canvas.getContext('2d')
  ctx.scale(scale, scale)

  function rr(x, y, w, h, r2, fill, stroke) {
    ctx.beginPath()
    ctx.moveTo(x + r2, y)
    ctx.lineTo(x + w - r2, y); ctx.quadraticCurveTo(x + w, y, x + w, y + r2)
    ctx.lineTo(x + w, y + h - r2); ctx.quadraticCurveTo(x + w, y + h, x + w - r2, y + h)
    ctx.lineTo(x + r2, y + h); ctx.quadraticCurveTo(x, y + h, x, y + h - r2)
    ctx.lineTo(x, y + r2); ctx.quadraticCurveTo(x, y, x + r2, y)
    ctx.closePath()
    if (fill) { ctx.fillStyle = fill; ctx.fill() }
    if (stroke) { ctx.strokeStyle = stroke; ctx.lineWidth = 0.5; ctx.stroke() }
  }

  function hline(y2, color = C.border, w = 0.5) {
    ctx.beginPath(); ctx.moveTo(PAD, y2); ctx.lineTo(W - PAD, y2)
    ctx.strokeStyle = color; ctx.lineWidth = w; ctx.stroke()
  }

  function wrap(str, x, y2, maxW, font, color, lh) {
    ctx.font = font; ctx.fillStyle = color; ctx.textAlign = 'left'
    const words = str.split(' '); let line = ''; let cy = y2
    words.forEach((w, i) => {
      const test = line ? line + ' ' + w : w
      if (ctx.measureText(test).width > maxW && i > 0) {
        ctx.fillText(line, x, cy); line = w; cy += lh
      } else line = test
    })
    ctx.fillText(line, x, cy)
    return cy + lh
  }

  ctx.fillStyle = C.bg; ctx.fillRect(0, 0, W, H)
  rr(PAD / 2, PAD / 2, W - PAD, H - PAD, 12, C.white, C.border)

  let y = PAD + 16

  const drawContent = () => {
    ctx.font = "500 28px 'DM Serif Display', Georgia, serif"
    ctx.fillStyle = C.ink; ctx.textAlign = 'left'
    ctx.fillText(r.name, PAD, y); y += 34

    ctx.font = "400 13px 'DM Sans', sans-serif"
    ctx.fillStyle = C.muted
    ctx.fillText('By ' + r.author, PAD, y); y += 22

    ctx.font = "500 11px 'DM Sans', sans-serif"
    let tx = PAD
    const drawTag = (label, bg, color) => {
      const tw = ctx.measureText(label).width + 16
      rr(tx, y - 12, tw, 20, 10, bg)
      ctx.fillStyle = color; ctx.textAlign = 'left'
      ctx.fillText(label, tx + 8, y + 2)
      tx += tw + 6
    }
    drawTag(r.category, C.accentLight, C.accent)
    ;(r.tags || []).forEach(t => drawTag(t, C.surface, C.muted))
    y += 28

    hline(y); y += 16

    ctx.font = "600 11px 'DM Sans', sans-serif"; ctx.fillStyle = C.faint; ctx.textAlign = 'left'
    ctx.fillText('INGREDIENTS', PAD, y)
    const base2 = r.servings || 4
    const srvTxt = `Servings: ${servings}${servings !== base2 ? ' (\u00d7' + formatQty(factor) + ')' : ''}`
    ctx.font = "400 12px 'DM Sans', sans-serif"; ctx.fillStyle = C.muted; ctx.textAlign = 'right'
    ctx.fillText(srvTxt, W - PAD, y)
    y += 22

    ;(r.ing_groups || []).forEach(g => {
      if (g.label) {
        ctx.font = "600 13px 'DM Sans', sans-serif"; ctx.fillStyle = C.ink; ctx.textAlign = 'left'
        ctx.fillText(g.label, PAD, y); y += 6
        hline(y, C.borderMed, 1); y += 16
      }
      ;(g.items || []).forEach(item => {
        const scaled = scaleAmt(item.amt, factor)
        ctx.font = "400 14px 'DM Sans', sans-serif"; ctx.textAlign = 'left'
        ctx.fillStyle = scaled !== item.amt ? C.accent : C.muted
        ctx.fillText(scaled, PAD + 10, y)
        ctx.fillStyle = C.ink
        ctx.fillText(item.item, PAD + 10 + COL1, y)
        hline(y + 6); y += 26
      })
      y += 4
    })

    y += 10; hline(y); y += 16

    ctx.font = "600 11px 'DM Sans', sans-serif"; ctx.fillStyle = C.faint; ctx.textAlign = 'left'
    ctx.fillText('STEPS', PAD, y); y += 20

    ;(r.steps || []).forEach((s, i) => {
      ctx.beginPath(); ctx.arc(PAD + 11, y - 4, 11, 0, Math.PI * 2)
      ctx.fillStyle = C.ink; ctx.fill()
      ctx.font = "600 10px 'DM Sans', sans-serif"; ctx.fillStyle = '#fff'; ctx.textAlign = 'center'
      ctx.fillText(i + 1, PAD + 11, y)
      ctx.textAlign = 'left'
      y = wrap(s.text, PAD + 28, y, W - PAD - (PAD + 28) - 4, "400 14px 'DM Sans', sans-serif", C.ink, 22)
      if (s.subs && s.subs.length) {
        s.subs.forEach(b => {
          ctx.beginPath(); ctx.arc(PAD + 36, y - 4, 3, 0, Math.PI * 2)
          ctx.fillStyle = C.accent; ctx.fill()
          y = wrap(b, PAD + 46, y, W - PAD - (PAD + 46) - 4, "400 13px 'DM Sans', sans-serif", C.muted, 20)
        })
        y += 2
      }
      y += 8
    })

    if (r.notes) {
      y += 8; hline(y); y += 16
      ctx.font = "600 11px 'DM Sans', sans-serif"; ctx.fillStyle = C.faint; ctx.textAlign = 'left'
      ctx.fillText('NOTES', PAD, y); y += 18
      const notesH = Math.ceil(r.notes.length * 7 / (W - PAD * 2 - 24)) * 22 + 20
      rr(PAD, y - 10, W - PAD * 2, notesH, 8, C.surface)
      wrap(r.notes, PAD + 12, y + 4, W - PAD * 2 - 24, "400 14px 'DM Sans', sans-serif", C.muted, 22)
    }
  }

  await new Promise(resolve => {
    if (r.photo_url) {
      const img = new Image()
      img.crossOrigin = 'anonymous'
      img.onload = () => {
        const ph = 200
        ctx.save()
        ctx.beginPath()
        ctx.moveTo(PAD / 2 + 12, PAD / 2)
        ctx.lineTo(W - PAD / 2 - 12, PAD / 2); ctx.quadraticCurveTo(W - PAD / 2, PAD / 2, W - PAD / 2, PAD / 2 + 12)
        ctx.lineTo(W - PAD / 2, PAD / 2 + ph); ctx.lineTo(PAD / 2, PAD / 2 + ph)
        ctx.lineTo(PAD / 2, PAD / 2 + 12); ctx.quadraticCurveTo(PAD / 2, PAD / 2, PAD / 2 + 12, PAD / 2)
        ctx.closePath(); ctx.clip()
        const iAR = img.width / img.height, cAR = (W - PAD) / ph
        let sx = 0, sy = 0, sw = img.width, sh = img.height
        if (iAR > cAR) { sw = sh * cAR; sx = (img.width - sw) / 2 }
        else { sh = sw / cAR; sy = (img.height - sh) / 2 }
        ctx.drawImage(img, sx, sy, sw, sh, PAD / 2, PAD / 2, W - PAD, ph)
        ctx.restore()
        y = PAD / 2 + ph + 24
        drawContent(); resolve()
      }
      img.onerror = () => { drawContent(); resolve() }
      img.src = r.photo_url
    } else {
      drawContent(); resolve()
    }
  })

  await new Promise(resolve => {
    canvas.toBlob(async blob => {
      if (!blob) { resolve(); return }
      try {
        await navigator.clipboard.write([new ClipboardItem({ 'image/png': blob })])
      } catch {
        const url = URL.createObjectURL(blob)
        window.open(url)
        setTimeout(() => URL.revokeObjectURL(url), 10000)
      }
      resolve()
    }, 'image/png')
  })
}
