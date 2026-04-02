import { useState } from 'react'
import { supabase } from '../lib/supabase'
import { scaleAmt, formatQty } from '../lib/utils'
import { copyRecipeText, copyRecipeImage } from '../lib/share'
import styles from './RecipeDetail.module.css'

function Lightbox({ src, onClose }) {
  return (
    <div className={styles.lightboxOverlay} onClick={onClose}>
      <img className={styles.lightboxImg} src={src} alt="Full size" onClick={e => e.stopPropagation()} />
      <button className={styles.lightboxClose} onClick={onClose}>×</button>
    </div>
  )
}

export default function RecipeDetail({ recipe: r, servings, setServings, onBack, onEdit, onToggleWant, onDeleted }) {
  const [copyTextLabel, setCopyTextLabel] = useState('Copy text')
  const [copyImgLabel, setCopyImgLabel] = useState('Copy image')
  const [deleting, setDeleting] = useState(false)
  const [lightboxSrc, setLightboxSrc] = useState(null)

  const base = r.servings || 4
  const factor = servings / base

  async function handleCopyText() {
    await copyRecipeText(r, servings, factor)
    setCopyTextLabel('Copied!')
    setTimeout(() => setCopyTextLabel('Copy text'), 2000)
  }

  async function handleCopyImage() {
    setCopyImgLabel('Generating…')
    await copyRecipeImage(r, servings, factor)
    setCopyImgLabel('Copied!')
    setTimeout(() => setCopyImgLabel('Copy image'), 2000)
  }

  async function handleDelete() {
    if (!confirm(`Delete "${r.name}"? This cannot be undone.`)) return
    setDeleting(true)
    if (r.photo_path) {
      await supabase.storage.from('recipe-photos').remove([r.photo_path])
    }
    await supabase.from('dishes').delete().eq('id', r.id)
    onDeleted(r.id)
  }

  return (
    <div className={styles.container}>
      {lightboxSrc && <Lightbox src={lightboxSrc} onClose={() => setLightboxSrc(null)} />}

      {r.photo_url && (
        <img
          className={styles.hero}
          src={r.photo_url}
          alt={r.name}
          onClick={() => setLightboxSrc(r.photo_url)}
        />
      )}

      <div className={styles.inner}>
        <button className={styles.backBtn} onClick={onBack}>
          <svg width="15" height="15" viewBox="0 0 15 15" fill="none">
            <path d="M9 3 L4.5 7.5 L9 12" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"/>
          </svg>
          Back to recipes
        </button>

        <div className={styles.titleRow}>
          <div>
            <h1 className={styles.title}>{r.name}</h1>
            <div className={styles.meta}>By {r.author}</div>
            <div className={styles.tags}>
              <span className={`${styles.tag} ${styles.tagCat}`}>{r.category}</span>
              {(r.tags || []).map(t => <span key={t} className={styles.tag}>{t}</span>)}
            </div>
          </div>
          <div className={styles.actions}>
            <button className={styles.btnSec} onClick={onEdit}>Edit</button>
            <button className={styles.btnSec} onClick={handleCopyText}>{copyTextLabel}</button>
            <button className={styles.btnSec} onClick={handleCopyImage}>{copyImgLabel}</button>
            <button className={`${styles.wantBtn} ${r.want_try ? styles.wantActive : ''}`} onClick={onToggleWant}>★</button>
          </div>
        </div>

        <div className={styles.section}>
          <div className={styles.sectionHeader}>
            <div className={styles.sectionLabel}>Ingredients</div>
            <div className={styles.servingsRow}>
              <span className={styles.servingsHint}>Servings</span>
              <div className={styles.stepper}>
                <button className={styles.stepBtn} onClick={() => setServings(servings - 1)} disabled={servings <= 1}>−</button>
                <span className={styles.stepVal}>
                  {servings}
                  {servings !== base && <span className={styles.scaleBadge}>&nbsp;×{formatQty(factor)}</span>}
                </span>
                <button className={styles.stepBtn} onClick={() => setServings(servings + 1)}>+</button>
              </div>
            </div>
          </div>

          {(r.ing_groups || []).map((g, gi) => (
            <div key={gi} className={styles.ingGroup}>
              {g.label && <div className={styles.ingGroupHeader}>{g.label}</div>}
              <ul className={styles.ingList}>
                {(g.items || []).map((item, ii) => {
                  const scaled = scaleAmt(item.amt, factor)
                  return (
                    <li key={ii} className={styles.ingItem}>
                      <span className={`${styles.ingAmt} ${scaled !== item.amt ? styles.scaled : ''}`}>{scaled}</span>
                      <span>{item.item}</span>
                    </li>
                  )
                })}
              </ul>
            </div>
          ))}
        </div>

        <div className={styles.section}>
          <div className={styles.sectionLabel}>Steps</div>
          <ol className={styles.stepsList}>
            {(r.steps || []).map((s, i) => (
              <li key={i} className={styles.stepItem}>
                <div className={styles.stepNum}>{i + 1}</div>
                <div className={styles.stepBody}>
                  <div className={styles.stepText}>{s.text}</div>
                  {s.subs && s.subs.length > 0 && (
                    <ul className={styles.stepSubs}>
                      {s.subs.map((b, bi) => <li key={bi}>{b}</li>)}
                    </ul>
                  )}
                </div>
              </li>
            ))}
          </ol>
        </div>

        {r.notes && (
          <div className={styles.section}>
            <div className={styles.sectionLabel}>Notes</div>
            <div className={styles.notesBox}>{r.notes}</div>
          </div>
        )}

        <div className={styles.deleteRow}>
          <button className={styles.deleteBtn} onClick={handleDelete} disabled={deleting}>
            {deleting ? 'Deleting…' : 'Delete recipe'}
          </button>
        </div>
      </div>
    </div>
  )
}
