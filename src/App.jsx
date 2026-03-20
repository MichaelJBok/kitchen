import { useState, useEffect, useCallback } from 'react'
import { supabase } from './lib/supabase'
import Gate from './components/Gate'
import Header from './components/Header'
import RecipesGrid from './components/RecipesGrid'
import RecipeDetail from './components/RecipeDetail'
import ShoppingList from './components/ShoppingList'
import RecipeModal from './components/RecipeModal'
import styles from './App.module.css'

export default function App() {
  const [authed, setAuthed] = useState(false)
  const [view, setView] = useState('recipes') // 'recipes' | 'detail' | 'list'
  const [recipes, setRecipes] = useState([])
  const [loading, setLoading] = useState(true)
  const [search, setSearch] = useState('')
  const [catFilter, setCatFilter] = useState('')
  const [activeRecipeId, setActiveRecipeId] = useState(null)
  const [modalOpen, setModalOpen] = useState(false)
  const [editingRecipe, setEditingRecipe] = useState(null)
  const [servings, setServings] = useState({}) // { [id]: number }

  useEffect(() => {
    if (authed) fetchRecipes()
  }, [authed])

  async function fetchRecipes() {
    setLoading(true)
    const { data, error } = await supabase
      .from('dishes')
      .select('*')
      .order('created_at', { ascending: false })
    if (!error) setRecipes(data || [])
    setLoading(false)
  }

  const getServings = useCallback((recipe) => {
    return servings[recipe.id] ?? (recipe.servings || 4)
  }, [servings])

  const setRecipeServings = useCallback((id, val) => {
    setServings(prev => ({ ...prev, [id]: Math.max(1, val) }))
  }, [])

  const toggleWant = useCallback(async (recipe) => {
    const updated = !recipe.want_try
    setRecipes(prev => prev.map(r => r.id === recipe.id ? { ...r, want_try: updated } : r))
    await supabase.from('dishes').update({ want_try: updated }).eq('id', recipe.id)
  }, [])

  const openDetail = useCallback((id) => {
    setActiveRecipeId(id)
    setView('detail')
  }, [])

  const openModal = useCallback((recipe = null) => {
    setEditingRecipe(recipe)
    setModalOpen(true)
  }, [])

  const closeModal = useCallback(() => {
    setModalOpen(false)
    setEditingRecipe(null)
  }, [])

  const onSaved = useCallback(async () => {
    await fetchRecipes()
    closeModal()
  }, [])

  const onDeleted = useCallback(async (id) => {
    setRecipes(prev => prev.filter(r => r.id !== id))
    setView('recipes')
  }, [])

  const filteredRecipes = recipes.filter(r => {
    const q = search.toLowerCase()
    const matchQ = !q || r.name.toLowerCase().includes(q) ||
      r.author.toLowerCase().includes(q) ||
      (r.tags || []).some(t => t.toLowerCase().includes(q))
    const matchC = !catFilter || r.category === catFilter
    return matchQ && matchC
  })

  const activeRecipe = recipes.find(r => r.id === activeRecipeId) || null

  if (!authed) return <Gate onAuth={() => setAuthed(true)} />

  return (
    <div className={styles.app}>
      <Header
        view={view}
        setView={setView}
        wantCount={recipes.filter(r => r.want_try).length}
      />

      {view === 'recipes' && (
        <RecipesGrid
          recipes={filteredRecipes}
          loading={loading}
          search={search}
          setSearch={setSearch}
          catFilter={catFilter}
          setCatFilter={setCatFilter}
          onOpenDetail={openDetail}
          onToggleWant={toggleWant}
          onAddRecipe={() => openModal()}
        />
      )}

      {view === 'detail' && activeRecipe && (
        <RecipeDetail
          recipe={activeRecipe}
          servings={getServings(activeRecipe)}
          setServings={(v) => setRecipeServings(activeRecipe.id, v)}
          onBack={() => setView('recipes')}
          onEdit={() => openModal(activeRecipe)}
          onToggleWant={() => toggleWant(activeRecipe)}
          onDeleted={onDeleted}
        />
      )}

      {view === 'list' && (
        <ShoppingList
          recipes={recipes.filter(r => r.want_try)}
          getServings={getServings}
          onToggleWant={toggleWant}
        />
      )}

      {modalOpen && (
        <RecipeModal
          recipe={editingRecipe}
          onSaved={onSaved}
          onClose={closeModal}
        />
      )}
    </div>
  )
}
