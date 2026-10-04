# Lebanon Agricultural Directory 2026

Standalone GitHub Pages frontend with Supabase database and administrator authentication.

## Setup

1. Create a free Supabase project.
2. Run `supabase-schema.sql` in its SQL Editor.
3. Create the administrator under Authentication > Users and add that email to `admin_users` using the final SQL line.
4. Copy `config.example.js` values into `config.js` using the project URL and publishable anon key.
5. Import the generated private SQL file from `private/import-pending.sql` in the SQL Editor.
6. Publish this folder to the `devexlynne.github.io` repository.

All imported registrations begin with `pending`. Only `approved` records are exposed by `listings_public`.
