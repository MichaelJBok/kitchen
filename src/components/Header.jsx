import styles from './Header.module.css'

export default function Header({ view, setView, wantCount }) {
  return (
    <header className={styles.header}>
      <h1 className={styles.title}>The Kitchen</h1>
      <div className={styles.tabs}>
        <button
          className={`${styles.tab} ${view === 'recipes' ? styles.active : ''}`}
          onClick={() => setView('recipes')}
        >
          Recipes
        </button>
        <button
          className={`${styles.tab} ${view === 'list' ? styles.active : ''}`}
          onClick={() => setView('list')}
        >
          List
          {wantCount > 0 && <span className={styles.badge}>{wantCount}</span>}
        </button>
      </div>
    </header>
  )
}
