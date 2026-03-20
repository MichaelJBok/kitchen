import styles from './RecipesGrid.module.css'

const CATEGORIES = ['Bread','Breakfast','Burger & Sandwich','Chili & Stew','Condiment','Dessert','Mexican','Pasta','Pizza','Salad','Sauce & Dip','Other']

export default function RecipesGrid({ recipes, loading, search, setSearch, catFilter, setCatFilter, onOpenDetail, onToggleWant, onAddRecipe }) {
  return (
    <div className={styles.view}>
      <div className={styles.toolbar}>
        <div className={styles.searchWrap}>
          <svg width="14" height="14" viewBox="0 0 14 14" fill="none">
            <circle cx="6" cy="6" r="4.5" stroke="currentColor" strokeWidth="1.4"/>
            <path d="M9.5 9.5 L12.5 12.5" stroke="currentColor" strokeWidth="1.4" strokeLinecap="round"/>
          </svg>
          <input
            className={styles.searchInput}
            placeholder="Search recipes, authors, tags..."
            value={search}
            onChange={e => setSearch(e.target.value)}
          />
          {search && (
            <button className={styles.clearBtn} onClick={() => setSearch('')}>×</button>
          )}
        </div>
        <select
          className={styles.select}
          value={catFilter}
          onChange={e => setCatFilter(e.target.value)}
        >
          <option value="">All categories</option>
          {CATEGORIES.map(c => <option key={c}>{c}</option>)}
        </select>
        <button className={styles.addBtn} onClick={onAddRecipe}>+ Add Recipe</button>
      </div>

      {loading ? (
        <div className={styles.loading}>Loading recipes…</div>
      ) : (
        <div className={styles.grid}>
          {recipes.length === 0 ? (
            <div className={styles.empty}>No recipes found.</div>
          ) : recipes.map(r => (
            <RecipeCard
              key={r.id}
              recipe={r}
              onClick={() => onOpenDetail(r.id)}
              onToggleWant={() => onToggleWant(r)}
            />
          ))}
        </div>
      )}
    </div>
  )
}

function RecipeCard({ recipe: r, onClick, onToggleWant }) {
  const totalItems = (r.ing_groups || []).reduce((n, g) => n + (g.items || []).length, 0)
  return (
    <div className={styles.card} onClick={onClick}>
      <div className={styles.cardHeader}>
        <h3 className={styles.cardTitle}>{r.name}</h3>
        <button
          className={`${styles.wantBtn} ${r.want_try ? styles.wantActive : ''}`}
          onClick={e => { e.stopPropagation(); onToggleWant() }}
          title={r.want_try ? 'Remove from want-to-try' : 'Add to want-to-try'}
        >★</button>
      </div>
      <div className={styles.cardMeta}>By {r.author} · {totalItems} ingredients</div>
      <div className={styles.tags}>
        <span className={`${styles.tag} ${styles.tagCat}`}>{r.category}</span>
        {(r.tags || []).map(t => <span key={t} className={styles.tag}>{t}</span>)}
      </div>
    </div>
  )
}
