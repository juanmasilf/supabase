import { useState } from 'react'
import { supabase } from './supabaseClient'

const UserSearch = ({ setOnAccount }) => {
  const [loading, setLoading] = useState(false)
  const [text, setText] = useState(null)
  const [users, setUsers] = useState([]);

  const searchUsers = async (e) => {
    e.preventDefault()

    try {
      setLoading(true)
      if(!text) {
        setUsers([]);
        return;
      }
      const { data, error } = await supabase.from('profiles').select().textSearch('username', `'${text}'`)
      if (error) {
        throw error
      }
      setUsers(data);
    } catch (error) {
      alert(error.message)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div aria-live="polite">
        <>
        <form onSubmit={searchUsers} className="form-widget">
          <div>
            <label htmlFor="search">Search Users by Username</label>
            <input
              id="search"
              type="text"
              value={text || ''}
              onChange={(e) => setText(e.target.value)}
            />
          </div>
          <div>
            <button className="button primary block" disabled={loading}>
              Search Users
            </button>
          </div>
        </form>
        {loading ? (
          'Searching ...'
        ) : users.length > 0 ? (
          <ol>
            {users.map(user => (
              <li key={user.id}>
                <div className="user">
                  <span>{user.username}</span>
                  <span>{user.website}</span>
                  <span>{user.updated_at}</span>
                </div>
              </li>
            ))}
            </ol>
          ) : (
          <p>No data</p>
          )}
        </>
      <br />
      <br />
      <button
        type="button"
        className="button block"
        onClick={() => setOnAccount(true)}
      >
        My Account
      </button>
      <button
        type="button"
        className="button block"
        onClick={() => supabase.auth.signOut()}
      >
        Sign Out
      </button>
    </div>
  )
}

export default UserSearch