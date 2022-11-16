// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

import { serve } from "https://deno.land/std@0.131.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.0.0'



serve(async (req: Request) => {
        // Create a Supabase client with the Auth context of the logged in user.
        const supabaseClient = createClient(
          // Supabase API URL - env var exported by default.
          Deno.env.get('SUPABASE_URL') ?? '',
          // Supabase API ANON KEY - env var exported by default.
          Deno.env.get('SUPABASE_ANON_KEY') ?? '',
          // Create client with Auth context of the user that called the function.
          // This way your row-level-security (RLS) policies are applied.
          { global: { headers: { Authorization: req.headers.get('Authorization')! } } }
        )
        // Now we can get the session or user object
        const {
          data: { user },
        } = await supabaseClient.auth.getUser()
    
        // And we can run queries in the context of our authenticated user
        const { data, error } = await supabaseClient.from('foods').insert({title: `${user?.email} food 1`, description: 'Food 1', owner_id: user?.id,});
        if (error) throw error
        return new Response(JSON.stringify(data))
})

// To invoke:
// curl -i --location --request POST 'http://localhost:54321/functions/v1/' \
//   --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24ifQ.625_WdcF3KHqz5amU0x2X5WWHP-OEs_4qj0ssLNHzTs' \
//   --header 'Content-Type: application/json' \
//   --data '{"name":"Functions"}'
