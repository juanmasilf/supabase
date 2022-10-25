import './index.css'
import { useState, useEffect } from 'react'
import { supabase } from './supabaseClient'
import Auth from './auth/Auth'
import Account from './Account'
import UserSearch from './UserSearch'

export default function App() {
  const [session, setSession] = useState(null)
  const [onAccount, setOnAccount] = useState(false);

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
      ) : onAccount ? 
        <Account key={session.user.id} session={session} setOnAccount={setOnAccount} /> : 
        <UserSearch setOnAccount={setOnAccount} />
      }
    </div>
  )
}