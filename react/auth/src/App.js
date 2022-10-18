import './index.css'
import { useState, useEffect } from 'react'
import { supabase } from './supabaseClient'
import Auth from './auth/Auth'

export default function App() {
  const [session, setSession] = useState(null)

  useEffect(() => {
    supabase.auth.getSession().then(({ data: { session } }) => {
      setSession(session)
    });

    supabase.auth.onAuthStateChange(async (event, session) => {
      if (event === "PASSWORD_RECOVERY") {
        const newPassword = prompt("What would you like your new password to be?");
        const { data, error } = await supabase.auth
          .updateUser({ password: newPassword })
          
        if (data) alert("Password updated successfully!")
        if (error) alert("There was an error updating your password.")
      }
      setSession(session);
    });
  }, [])

  return (
    <div className="container" style={{ padding: '50px 0 100px 0' }}>
      {!session ? (
        <Auth />
      ) : (
        <>
        <p>Hi {session.user.email}</p>
        <button
          type="button"
          className="button block"
          onClick={() => supabase.auth.resetPasswordForEmail(session.user.email)}
        >
          Reset Password
        </button>
        <hr />
        <button
          type="button"
          className="button block"
          onClick={() => supabase.auth.signOut()}
        >
          Sign Out
        </button>
        </>
      )}
    </div>
  )
}