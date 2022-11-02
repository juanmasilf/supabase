import { useState } from 'react'
import { supabase } from '../supabaseClient'

export default function Credentials() {
  const [signMethod, setSignMethod] = useState('up');
  const [loading, setLoading] = useState(false)
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')

  const handleSign = async (e) => {
    e.preventDefault()

    try {
      setLoading(true)
      const { error } =  signMethod === 'up' ? await supabase.auth.signUp({ email, password }) : await supabase.auth.signInWithPassword({ email, password }) ;
      if (error) throw error
    } catch (error) {
      alert(error.error_description || error.message)
    } finally {
      setLoading(false)
    }
  }

  return (
    <>
      <hr />
      <div>
        <div className="radioGroup">
          <input type="radio" id="up" checked={signMethod === 'up'} name="signMethod" value="up"  onChange={(e)=>{setSignMethod(e.target.value)}} /><label htmlFor="html">Sign up</label>
        </div>
        <br />
        <div className="radioGroup">
          <input type="radio" id="in" checked={signMethod === 'in'} name="signMethod" value="in" onChange={(e)=>{setSignMethod(e.target.value)}} /><label htmlFor="css">Sign in</label>
        </div>
      </div>
        <p className="description">
          Sign {signMethod} via email and password
        </p>
        {loading ? (
          'Signing ' + signMethod
        ) : (
          <form onSubmit={handleSign}>
            <label htmlFor="email">Email</label>
            <input
              id="email"
              className="inputField"
              type="email"
              placeholder="Your email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
            />
            <label htmlFor="email">Password</label>
            <input
              id="password"
              className="inputField"
              type="password"
              placeholder="Your password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
            />
            <button className="button block" aria-live="polite">
              Sign {signMethod}
            </button>
          </form>
        )}
    </>
  )
}