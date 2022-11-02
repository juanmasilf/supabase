import { useState } from 'react'
import Credentials from './Credentials';
import MagicLink from './MagicLink';

export default function Auth() {
  const [signIn, setSignIn] = useState('credentials');

  return (
    <div className="row flex-center flex">
      <div className="col-6 form-widget" aria-live="polite">
        <h1 className="header">Supabase + React</h1>
        <div>
          <p>Please select your favorite sign in method:</p>
          <div className="radioGroup">
            <input type="radio" id="credentials" checked={signIn === 'credentials'} name="signin" value="credentials"  onChange={(e)=>{setSignIn(e.target.value)}} /><label htmlFor="html">Credentials</label>
          </div>
          <br />
          <div className="radioGroup">
            <input type="radio" id="magiclink" checked={signIn === 'magiclink'} name="signin" value="magiclink" onChange={(e)=>{setSignIn(e.target.value)}} /><label htmlFor="css">Magic Link</label>
          </div>
        </div>
        { signIn === 'credentials' && (
          <Credentials />
        )}
        { signIn === 'magiclink' && (
          <MagicLink />
        )}
      </div>
    </div>
  )
}