create extension if not exists pgcrypto;
create table if not exists public.admin_users(email text primary key);
create table if not exists public.listings(
 id uuid primary key default gen_random_uuid(), name text not null, business_types text[] not null default '{}', description text,
 year_established text, employees text, governorate text, district text, town text, address text, map_url text, multiple_locations text,
 contact_name text, position text, phone text, whatsapp text, email text, website text, facebook text, instagram text,
 products_services text[] not null default '{}', crops text[] not null default '{}', details text, logo_url text, main_photo_url text,
 additional_photos text[] not null default '{}', works_directly text, delivery text, service_outside text, areas_served text[], online_available text,
 store_url text, accuracy_confirmation text, consent text, status text not null default 'pending' check(status in('pending','approved','rejected','archived')),
 verified boolean not null default false, reviewer_notes text not null default '', created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
alter table public.listings enable row level security; alter table public.admin_users enable row level security;
create or replace function public.is_admin() returns boolean language sql security definer stable set search_path=public as $$select exists(select 1 from admin_users where lower(email)=lower(coalesce(auth.jwt()->>'email','')))$$;
drop policy if exists "admins read listings" on public.listings; create policy "admins read listings" on public.listings for select to authenticated using(public.is_admin());
drop policy if exists "admins update listings" on public.listings; create policy "admins update listings" on public.listings for update to authenticated using(public.is_admin()) with check(public.is_admin());
create or replace view public.listings_public with(security_invoker=false) as select id,name,business_types,description,governorate,district,town,map_url,phone,whatsapp,email,website,facebook,instagram,products_services,crops,details,verified from public.listings where status='approved' and consent is not null;
grant select on public.listings_public to anon,authenticated; revoke all on public.listings from anon;
-- After creating the admin in Authentication > Users, replace the email below and run it once:
-- insert into public.admin_users(email) values ('YOUR_ADMIN_EMAIL') on conflict do nothing;
