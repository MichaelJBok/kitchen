import styles from './RecipesGrid.module.css'

const DEFAULT_CATEGORIES = ['Bread','Breakfast','Burger & Sandwich','Chili & Stew','Condiment','Dessert','Mexican','Pasta','Pizza','Salad','Sauce & Dip','Other']
const DEFAULT_COURSES = ['Main','Side','Appetizer','Condiment','Dessert','Drink']

export default function RecipesGrid({ recipes, loading, search, setSearch, catFilter, setCatFilter, courseFilter, setCourseFilter, onOpenDetail, onToggleWant, onAddRecipe }) {
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
          {[...new Set([...DEFAULT_CATEGORIES, ...recipes.map(r => r.category).filter(Boolean)])].sort().map(c => <option key={c}>{c}</option>)}
        </select>
        <select
          className={styles.select}
          value={courseFilter}
          onChange={e => setCourseFilter(e.target.value)}
        >
          <option value="">All courses</option>
          {[...new Set([...DEFAULT_COURSES, ...recipes.map(r => r.course).filter(Boolean)])].sort().map(c => <option key={c}>{c}</option>)}
        </select>
        <button className={styles.addBtn} onClick={onAddRecipe}>+ Add Recipe</button>
      </div>

      {loading ? (
        <div className={styles.loading}>Loading recipes…</div>
      ) : recipes.length === 0 ? (
        <div className={styles.empty}>No recipes found.</div>
      ) : courseFilter ? (
        <div className={styles.grid}>
          {recipes.map(r => (
            <RecipeCard
              key={r.id}
              recipe={r}
              onClick={() => onOpenDetail(r.id)}
              onToggleWant={() => onToggleWant(r)}
            />
          ))}
        </div>
      ) : (
        groupByCourse(recipes).map(([course, group]) => (
          <div key={course} className={styles.courseSection}>
            <div className={styles.courseHeader}>
              <span className={styles.courseDot} data-course={course}/>
              <h2 className={styles.courseTitle}>{course}</h2>
              <span className={styles.courseCount}>{group.length}</span>
              <span className={styles.courseLine}/>
            </div>
            <div className={styles.grid}>
              {group.map(r => (
                <RecipeCard
                  key={r.id}
                  recipe={r}
                  onClick={() => onOpenDetail(r.id)}
                  onToggleWant={() => onToggleWant(r)}
                />
              ))}
            </div>
          </div>
        ))
      )}
    </div>
  )
}

function groupByCourse(recipes) {
  const groups = new Map()
  recipes.forEach(r => {
    const key = r.course || 'No Course'
    if (!groups.has(key)) groups.set(key, [])
    groups.get(key).push(r)
  })
  const extras = [...groups.keys()].filter(k => !DEFAULT_COURSES.includes(k) && k !== 'No Course').sort()
  const orderedKeys = [
    ...DEFAULT_COURSES.filter(c => groups.has(c)),
    ...extras,
    ...(groups.has('No Course') ? ['No Course'] : []),
  ]
  return orderedKeys.map(k => [k, groups.get(k)])
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
        {r.course && <span className={`${styles.tag} ${styles.tagCourse}`}>{r.course}</span>}
        {(r.tags || []).map(t => <span key={t} className={styles.tag}>{t}</span>)}
      </div>
    </div>
  )
}
