import { useState, useEffect } from 'react'
import { supabase } from './supabaseClient'

const UserSearch = ({ session, setOnAccount }) => {
  const [loading, setLoading] = useState(false)
  const [text, setText] = useState(null)
  const [users, setUsers] = useState([]);
  const [quote, setQuote] = useState(null);
  const [searches, setSearches] = useState(null);
  const [username, setUsername] = useState(null);

  useEffect(() => {
    const getInitialSearches = async () => {
      const {data} = await supabase
        .from('profiles')
        .select(`searches, username`)
        .eq('id', session.user.id)
        .single();
      console.log(data);
      setSearches(data.searches);
      setUsername(data.username);
    };
    getInitialSearches();

  }, []);

  const getQuote = async () => {
    const {data} = await supabase.rpc('talk_to_kanye', {name: username});
    setQuote(data);
  }

  const updateSearches = async () => {
    const {data} = await supabase.rpc('number_of_searches');
    console.log(data);
    setSearches(data);
  }

  const searchUsers = async (e) => {
    e.preventDefault()
    try {
      setLoading(true)
      if(!text) {
        setUsers([]);
        return;
      }
      getQuote();
      const { data, error } = await supabase.from('profiles').select().textSearch('username', `'${text}'`)
      if (error) {
        throw error
      }
      setUsers(data);
      updateSearches();
    } catch (error) {
      alert(error.message)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div aria-live="polite">
        <>
        { quote ? (
          <div className="quote">
            <p>{quote}</p>
            <span>- Kanye West</span>
          </div>
        ) : (
          <p>Search users and get a quote from Kanye West!</p>
        )}
        {searches !== null && (
          `Searched ${searches} times.`
        )}
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