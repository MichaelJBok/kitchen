import { useState } from 'react'
import styles from './Gate.module.css'

export default function Gate({ onAuth }) {
  const [value, setValue] = useState('')
  const [error, setError] = useState('')

  function check() {
    if (value.trim().toLowerCase() === (import.meta.env.VITE_PASSPHRASE || 'kitchen')) {
      onAuth()
    } else {
      setError('Incorrect passphrase.')
    }
  }

  return (
    <div className={styles.gate}>
      <div className={styles.logo}>
        <svg width="30" height="30" viewBox="0 0 30 30" fill="none">
          <circle cx="15" cy="15" r="15" fill="#C4501A"/>
          <path d="M9 21 Q15 9 21 21" stroke="white" strokeWidth="2" fill="none" strokeLinecap="round"/>
          <circle cx="15" cy="10" r="2" fill="white"/>
        </svg>
        <h1>The Kitchen</h1>
      </div>
      <p>Enter the passphrase to continue</p>
      <input
        type="password"
        placeholder="passphrase"
        value={value}
        autoComplete="off"
        onChange={e => { setValue(e.target.value); setError('') }}
        onKeyDown={e => e.key === 'Enter' && check()}
      />
      <div className={styles.err}>{error}</div>
      <button onClick={check}>Enter</button>
    </div>
  )
}
