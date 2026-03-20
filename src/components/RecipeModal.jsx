import { useState } from 'react'
import { supabase } from '../lib/supabase'
import { resizeImage } from '../lib/utils'
import styles from './RecipeModal.module.css'

const CATEGORIES = ['Bread','Breakfast','Burger & Sandwich','Chili & Stew','Condiment','Dessert','Mexican','Pasta','Pizza','Salad','Sauce & Dip','Other']

const AUTOFILL_PROMPT = `Extract this recipe and return ONLY valid JSON (no markdown, no backticks):
{
  "name":"...",
  "category":"...",
  "author":"",
  "tags":[],
  "servings":4,
  "ing_groups":[{"label":"Group name or empty string","items":[{"amt":"...","item":"..."}]}],
  "steps":[{"text":"Main step text","subs":["optional sub-point"]}],
  "notes":"..."
}
Group ingredients logically (e.g. Marinade, Sauce, Dredge). Steps may have subs for sub-points or detail.`

export default function RecipeModal({ recipe, onSaved, onClose }) {
  const isEdit = !!recipe
  const [name, setName] = useState(recipe?.name || '')
  const [category, setCategory] = useState(recipe?.category || '')
  const [author, setAuthor] = useState(recipe?.author || '')
  const [servings, setServings] = useState(recipe?.servings || 4)
  const [tags, setTags] = useState(recipe?.tags?.join(', ') || '')
  const [notes, setNotes] = useState(recipe?.notes || '')
  const [photoPreview, setPhotoPreview] = useState(recipe?.photo_url || null)
  const [photoBlob, setPhotoBlob] = useState(null) // new file to upload
  const [photoCleared, setPhotoCleared] = useState(false)
  const [ingGroups, setIngGroups] = useState(
    recipe?.ing_groups?.length ? recipe.ing_groups : [{ label: '', items: [{ amt: '', item: '' }] }]
  )
  const [steps, setSteps] = useState(
    recipe?.steps?.length ? recipe.steps : [{ text: '', subs: [] }]
  )
  const [aiTab, setAiTab] = useState('text')
  const [aiText, setAiText] = useState('')
  const [aiPhotoBlob, setAiPhotoBlob] = useState(null)
  const [aiPhotoPreview, setAiPhotoPreview] = useState(null)
  const [aiStatus, setAiStatus] = useState('')
  const [aiLoading, setAiLoading] = useState(false)
  const [saving, setSaving] = useState(false)

  // ── Photo handlers ──────────────────────────────────────────────
  async function handleRecipePhoto(e) {
    const file = e.target.files[0]
    if (!file) return
    const blob = await resizeImage(file)
    setPhotoBlob(blob)
    setPhotoPreview(URL.createObjectURL(blob))
    setPhotoCleared(false)
  }

  function clearRecipePhoto() {
    setPhotoBlob(null)
    setPhotoPreview(null)
    setPhotoCleared(true)
  }

  async function handleAiPhoto(e) {
    const file = e.target.files[0]
    if (!file) return
    const blob = await resizeImage(file)
    setAiPhotoBlob(blob)
    setAiPhotoPreview(URL.createObjectURL(blob))
    // Auto-populate recipe photo if not set
    if (!photoPreview) {
      setPhotoBlob(blob)
      setPhotoPreview(URL.createObjectURL(blob))
    }
  }

  // ── AI Autofill ─────────────────────────────────────────────────
  async function runAutofill() {
    setAiLoading(true)
    setAiStatus('Thinking…')
    let messages
    if (aiTab === 'text') {
      if (!aiText.trim()) { setAiStatus('Paste some text first.'); setAiLoading(false); return }
      messages = [{ role: 'user', content: AUTOFILL_PROMPT + '\n\nRecipe text:\n' + aiText }]
    } else {
      if (!aiPhotoBlob) { setAiStatus('Upload a photo first.'); setAiLoading(false); return }
      const b64 = await blobToBase64(aiPhotoBlob)
      messages = [{ role: 'user', content: [
        { type: 'image', source: { type: 'base64', media_type: 'image/jpeg', data: b64 } },
        { type: 'text', text: AUTOFILL_PROMPT }
      ]}]
    }
    try {
      const res = await fetch('/api/autofill', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ messages }),
      })
      const data = await res.json()
      const text = (data.content || []).map(b => b.text || '').join('').replace(/```json|```/g, '').trim()
      const parsed = JSON.parse(text)
      if (parsed.name) setName(parsed.name)
      if (parsed.category) setCategory(parsed.category)
      if (parsed.author) setAuthor(parsed.author)
      if (parsed.servings) setServings(parsed.servings)
      if (parsed.tags) setTags(parsed.tags.join(', '))
      if (parsed.ing_groups?.length) setIngGroups(parsed.ing_groups)
      if (parsed.steps?.length) setSteps(parsed.steps)
      if (parsed.notes) setNotes(parsed.notes)
      setAiStatus('Done! Review and save.')
    } catch (err) {
      setAiStatus('Error — check input and try again.')
    }
    setAiLoading(false)
  }

  // ── Save ────────────────────────────────────────────────────────
  async function save() {
    if (!name.trim()) { alert('Please enter a recipe name.'); return }
    const validGroups = ingGroups.filter(g => g.items.some(i => i.item.trim()))
    if (!validGroups.length) { alert('Add at least one ingredient.'); return }
    const validSteps = steps.filter(s => s.text.trim())
    if (!validSteps.length) { alert('Add at least one step.'); return }
    setSaving(true)

    let photo_url = recipe?.photo_url || null
    let photo_path = recipe?.photo_path || null

    // Delete old photo if cleared or replaced
    if ((photoCleared || photoBlob) && recipe?.photo_path) {
      await supabase.storage.from('recipe-photos').remove([recipe.photo_path])
      photo_url = null
      photo_path = null
    }

    // Upload new photo
    if (photoBlob) {
      const ext = 'jpg'
      const path = `${Date.now()}.${ext}`
      const { error } = await supabase.storage.from('recipe-photos').upload(path, photoBlob, { contentType: 'image/jpeg' })
      if (!error) {
        const { data: urlData } = supabase.storage.from('recipe-photos').getPublicUrl(path)
        photo_url = urlData.publicUrl
        photo_path = path
      }
    }

    const payload = {
      name: name.trim(),
      category,
      author: author.trim(),
      servings: Number(servings) || 4,
      tags: tags.split(',').map(t => t.trim()).filter(Boolean),
      ing_groups: validGroups,
      steps: validSteps,
      notes: notes.trim(),
      photo_url,
      photo_path,
    }

    if (isEdit) {
      await supabase.from('dishes').update(payload).eq('id', recipe.id)
    } else {
      await supabase.from('dishes').insert([payload])
    }

    setSaving(false)
    onSaved()
  }

  // ── Ingredient group editor ─────────────────────────────────────
  function updateGroup(gi, key, val) {
    setIngGroups(prev => prev.map((g, i) => i === gi ? { ...g, [key]: val } : g))
  }
  function updateItem(gi, ii, key, val) {
    setIngGroups(prev => prev.map((g, i) => i !== gi ? g : {
      ...g, items: g.items.map((item, j) => j === ii ? { ...item, [key]: val } : item)
    }))
  }
  function addItem(gi) {
    setIngGroups(prev => prev.map((g, i) => i === gi ? { ...g, items: [...g.items, { amt: '', item: '' }] } : g))
  }
  function removeItem(gi, ii) {
    setIngGroups(prev => prev.map((g, i) => i !== gi ? g : { ...g, items: g.items.filter((_, j) => j !== ii) }))
  }
  function addGroup() { setIngGroups(prev => [...prev, { label: '', items: [{ amt: '', item: '' }] }]) }
  function removeGroup(gi) { setIngGroups(prev => prev.filter((_, i) => i !== gi)) }

  // ── Step editor ─────────────────────────────────────────────────
  function updateStep(si, key, val) {
    setSteps(prev => prev.map((s, i) => i === si ? { ...s, [key]: val } : s))
  }
  function addSub(si) {
    setSteps(prev => prev.map((s, i) => i === si ? { ...s, subs: [...(s.subs || []), ''] } : s))
  }
  function updateSub(si, bi, val) {
    setSteps(prev => prev.map((s, i) => i !== si ? s : { ...s, subs: s.subs.map((b, j) => j === bi ? val : b) }))
  }
  function removeSub(si, bi) {
    setSteps(prev => prev.map((s, i) => i !== si ? s : { ...s, subs: s.subs.filter((_, j) => j !== bi) }))
  }
  function addStep() { setSteps(prev => [...prev, { text: '', subs: [] }]) }
  function removeStep(si) { setSteps(prev => prev.filter((_, i) => i !== si)) }

  return (
    <div className={styles.overlay} onClick={e => e.target === e.currentTarget && onClose()}>
      <div className={styles.modal}>
        <div className={styles.header}>
          <h2>{isEdit ? 'Edit Recipe' : 'Add Recipe'}</h2>
          <button className={styles.closeBtn} onClick={onClose}>×</button>
        </div>

        {/* Photo */}
        <div className={styles.formRow}>
          <label>Recipe Photo (optional)</label>
          <div className={styles.photoArea} onClick={() => document.getElementById('recipe-photo-input').click()}>
            <input type="file" id="recipe-photo-input" accept="image/*" style={{ display: 'none' }} onChange={handleRecipePhoto}/>
            {photoPreview
              ? <img src={photoPreview} className={styles.photoPreview} alt="preview"/>
              : <div className={styles.photoPlaceholder}><span>＋</span> Click to add a photo</div>
            }
            {photoPreview && (
              <button className={styles.photoClear} onClick={e => { e.stopPropagation(); clearRecipePhoto() }}>Remove</button>
            )}
          </div>
        </div>

        {/* AI Autofill */}
        <div className={styles.aiSection}>
          <div className={styles.aiLabel}>AI Autofill</div>
          <div className={styles.aiTabs}>
            <button className={`${styles.aiTab} ${aiTab === 'text' ? styles.aiTabActive : ''}`} onClick={() => setAiTab('text')}>Paste text</button>
            <button className={`${styles.aiTab} ${aiTab === 'photo' ? styles.aiTabActive : ''}`} onClick={() => setAiTab('photo')}>Photo / Camera</button>
          </div>
          {aiTab === 'text' ? (
            <textarea className={styles.aiTextarea} placeholder="Paste a recipe, instructions, or notes…" value={aiText} onChange={e => setAiText(e.target.value)}/>
          ) : (
            <div className={styles.cameraArea} onClick={() => document.getElementById('ai-photo-input').click()}>
              <input type="file" id="ai-photo-input" accept="image/*" capture="environment" style={{ display: 'none' }} onChange={handleAiPhoto}/>
              {aiPhotoPreview
                ? <img src={aiPhotoPreview} className={styles.cameraPreview} alt="recipe card"/>
                : <div className={styles.cameraPlaceholder}>
                    <div className={styles.cameraIcon}>📷</div>
                    <div>Tap to open camera or choose photo</div>
                    <div className={styles.cameraHint}>Opens rear camera on mobile</div>
                  </div>
              }
              {aiPhotoPreview && (
                <button className={styles.photoClear} onClick={e => { e.stopPropagation(); setAiPhotoBlob(null); setAiPhotoPreview(null) }}>Remove</button>
              )}
            </div>
          )}
          <div className={styles.aiActions}>
            <button className={styles.aiRunBtn} onClick={runAutofill} disabled={aiLoading}>
              {aiLoading ? 'Thinking…' : 'Autofill from AI'}
            </button>
            {aiStatus && <span className={styles.aiStatus}>{aiStatus}</span>}
          </div>
        </div>

        {/* Basic fields */}
        <div className={styles.formRow}><label>Recipe Name</label><input value={name} onChange={e => setName(e.target.value)} placeholder="e.g. Grandma's Apple Pie"/></div>
        <div className={styles.grid3}>
          <div className={styles.formRow}><label>Category</label>
            <select value={category} onChange={e => setCategory(e.target.value)}>
              <option value="">Select…</option>
              {CATEGORIES.map(c => <option key={c}>{c}</option>)}
            </select>
          </div>
          <div className={styles.formRow}><label>Made by</label><input value={author} onChange={e => setAuthor(e.target.value)} placeholder="e.g. Grandma Rose"/></div>
          <div className={styles.formRow}><label>Base servings</label><input type="number" min="1" value={servings} onChange={e => setServings(e.target.value)}/></div>
        </div>
        <div className={styles.formRow}><label>Tags (comma separated)</label><input value={tags} onChange={e => setTags(e.target.value)} placeholder="e.g. vegetarian, quick, comfort food"/></div>

        {/* Ingredient groups */}
        <div>
          <div className={styles.sectionLabel}>Ingredient Groups</div>
          {ingGroups.map((g, gi) => (
            <div key={gi} className={styles.ingBlock}>
              <div className={styles.ingBlockTop}>
                <input className={styles.groupNameInput} placeholder="Group name (e.g. Sauce) — leave blank for no header" value={g.label} onChange={e => updateGroup(gi, 'label', e.target.value)}/>
                {ingGroups.length > 1 && <button className={styles.iconBtn} onClick={() => removeGroup(gi)}>×</button>}
              </div>
              {g.items.map((item, ii) => (
                <div key={ii} className={styles.ingRow}>
                  <input className={styles.amtInput} placeholder="Amount" value={item.amt} onChange={e => updateItem(gi, ii, 'amt', e.target.value)}/>
                  <input className={styles.nameInput} placeholder="Ingredient" value={item.item} onChange={e => updateItem(gi, ii, 'item', e.target.value)}/>
                  {g.items.length > 1 && <button className={styles.iconBtn} onClick={() => removeItem(gi, ii)}>×</button>}
                </div>
              ))}
              <button className={styles.addRowBtn} onClick={() => addItem(gi)}>+ Add ingredient</button>
            </div>
          ))}
          <button className={styles.addBlockBtn} onClick={addGroup}>+ Add ingredient group</button>
        </div>

        {/* Steps */}
        <div>
          <div className={styles.sectionLabel}>Steps</div>
          {steps.map((s, si) => (
            <div key={si} className={styles.stepBlock}>
              <div className={styles.stepBlockTop}>
                <div className={styles.stepNumBadge}>{si + 1}</div>
                <textarea className={styles.stepInput} placeholder="Step instruction…" value={s.text} onChange={e => updateStep(si, 'text', e.target.value)}/>
                {steps.length > 1 && <button className={styles.iconBtn} onClick={() => removeStep(si)}>×</button>}
              </div>
              <div className={styles.stepSubs}>
                {(s.subs || []).map((b, bi) => (
                  <div key={bi} className={styles.subRow}>
                    <span className={styles.subBullet}>•</span>
                    <input className={styles.subInput} placeholder="Sub-point detail…" value={b} onChange={e => updateSub(si, bi, e.target.value)}/>
                    <button className={styles.iconBtn} onClick={() => removeSub(si, bi)}>×</button>
                  </div>
                ))}
                <button className={styles.addSubBtn} onClick={() => addSub(si)}>+ Add sub-point</button>
              </div>
            </div>
          ))}
          <button className={styles.addBlockBtn} onClick={addStep}>+ Add step</button>
        </div>

        <div className={styles.formRow}><label>Notes (optional)</label><input value={notes} onChange={e => setNotes(e.target.value)} placeholder="Tips, variations, links…"/></div>

        <div className={styles.footer}>
          <button className={styles.cancelBtn} onClick={onClose}>Cancel</button>
          <button className={styles.saveBtn} onClick={save} disabled={saving}>{saving ? 'Saving…' : 'Save Recipe'}</button>
        </div>
      </div>
    </div>
  )
}

function blobToBase64(blob) {
  return new Promise(resolve => {
    const reader = new FileReader()
    reader.onload = e => resolve(e.target.result.split(',')[1])
    reader.readAsDataURL(blob)
  })
}
