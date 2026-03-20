import { useState } from 'react'
import { scaleAmt } from '../lib/utils'
import styles from './ShoppingList.module.css'

export default function ShoppingList({ recipes, getServings, onToggleWant }) {
  const [checked, setChecked] = useState({})

  // Aggregate ingredients across all want-to-try recipes
  const agg = {}
  recipes.forEach(r => {
    const factor = getServings(r) / (r.servings || 4)
    ;(r.ing_groups || []).forEach(g => {
      ;(g.items || []).forEach(i => {
        const key = i.item.toLowerCase().replace(/[,()]/g, '').trim()
        if (!agg[key]) agg[key] = { item: i.item, entries: [] }
        agg[key].entries.push({ amt: scaleAmt(i.amt, factor), recipe: r.name })
      })
    })
  })

  const toggle = (key) => setChecked(prev => ({ ...prev, [key]: !prev[key] }))

  return (
    <div className={styles.view}>
      <h2 className={styles.heading}>Shopping List</h2>
      <p className={styles.sub}>Ingredients from your want-to-try recipes</p>

      {recipes.length === 0 ? (
        <div className={styles.empty}>
          No recipes starred yet.<br />Tap ★ on a recipe to add it here.
        </div>
      ) : (
        <>
          <div className={styles.wantSection}>
            <div className={styles.label}>Want to try ({recipes.length})</div>
            {recipes.map(r => (
              <div key={r.id} className={styles.wantRow}>
                <span className={styles.wantName}>{r.name}</span>
                <button className={styles.removeBtn} onClick={() => onToggleWant(r)}>×</button>
              </div>
            ))}
          </div>

          <div className={styles.label} style={{ marginTop: 24, marginBottom: 8 }}>Shopping list</div>
          {Object.entries(agg).map(([key, { item, entries }]) => (
            <div
              key={key}
              className={`${styles.shopItem} ${checked[key] ? styles.checkedItem : ''}`}
            >
              <input
                type="checkbox"
                checked={!!checked[key]}
                onChange={() => toggle(key)}
              />
              <span className={styles.shopName}>{item}</span>
              <span className={styles.shopFrom}>
                {entries.map(e => `${e.amt} (${e.recipe})`).join(' + ')}
              </span>
            </div>
          ))}
        </>
      )}
    </div>
  )
}
