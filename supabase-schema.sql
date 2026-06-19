-- ============================================================
--  Family Line — Supabase schema
--  Run this once in: Supabase Dashboard → SQL Editor → New query → Run
-- ============================================================
-- Model: one shared, authless table. Everyone can read AND write
-- (the "shared Google Sheet, use it politely" model). Security comes
-- from the link being private to the family, not from auth.
-- ============================================================

create extension if not exists "pgcrypto";

create table if not exists public.items (
  id          uuid primary key default gen_random_uuid(),
  owner_id    text not null,                 -- m1..m7 (family member)
  title_en    text default '',
  title_cn    text default '',
  price       text default '',
  shop        text default '',
  link        text default '',
  image       text default '',
  priority    boolean default false,
  claimed_by  text,                          -- m1..m7 or null
  created_at  timestamptz not null default now()
);

create index if not exists items_owner_idx on public.items (owner_id);
create index if not exists items_created_idx on public.items (created_at);

-- ---------- Row Level Security: anon read + write ----------
alter table public.items enable row level security;

drop policy if exists "anon read"   on public.items;
drop policy if exists "anon insert" on public.items;
drop policy if exists "anon update" on public.items;
drop policy if exists "anon delete" on public.items;

create policy "anon read"   on public.items for select using (true);
create policy "anon insert" on public.items for insert with check (true);
create policy "anon update" on public.items for update using (true) with check (true);
create policy "anon delete" on public.items for delete using (true);

-- ---------- Realtime ----------
-- So claims/edits push live to everyone's open page.
alter publication supabase_realtime add table public.items;

-- ============================================================
--  Seed data (the 20 sample wishes from the prototype).
--  Safe to skip if you'd rather start empty — just don't run
--  this block. Re-running it duplicates rows.
-- ============================================================
insert into public.items (owner_id, title_en, title_cn, price, shop, link, image, priority, claimed_by) values
  ('m1','LEGO Train Set','乐高火车套装','$89','lego.com','https://www.lego.com','https://picsum.photos/seed/legotrain/600/400',true,'m2'),
  ('m1','Noise-Cancelling Headphones','降噪耳机','$199','sony.com','https://www.sony.com','',false,null),
  ('m1','Watercolor Paint Set','水彩颜料套装','$34','blick.com','https://www.dickblick.com','',false,'m4'),
  ('m1','Trail Running Shoes','越野跑鞋','$120','nike.com','https://www.nike.com','',true,null),
  ('m1','Dumpling Cookbook','饺子食谱书','$25','amazon.com','https://www.amazon.com','',false,null),
  ('m2','Silk Scarf','真丝丝巾','$60','uniqlo.com','https://www.uniqlo.com','https://picsum.photos/seed/silkscarf/600/400',true,'m1'),
  ('m2','Tea Gift Box','茶叶礼盒','$45','teabox.com','https://www.teabox.com','',false,null),
  ('m2','Garden Gloves','园艺手套','$18','amazon.com','https://www.amazon.com','',false,'m5'),
  ('m2','Reading Lamp','阅读灯','$52','ikea.com','https://www.ikea.com','',false,null),
  ('m3','Fishing Rod','钓鱼竿','$75','cabelas.com','https://www.cabelas.com','',false,null),
  ('m3','Leather Wallet','真皮钱包','$40','coach.com','https://www.coach.com','',false,'m1'),
  ('m3','Whiskey Glasses','威士忌酒杯','$30','amazon.com','https://www.amazon.com','',true,null),
  ('m4','Yoga Mat','瑜伽垫','$35','lululemon.com','https://www.lululemon.com','',false,null),
  ('m4','Cookbook Stand','食谱支架','$22','amazon.com','https://www.amazon.com','',false,'m2'),
  ('m5','Scented Candle Set','香薰蜡烛套装','$28','diptyque.com','https://www.diptyqueparis.com','',true,'m3'),
  ('m5','Travel Backpack','旅行背包','$95','patagonia.com','https://www.patagonia.com','https://picsum.photos/seed/backpack/600/400',false,null),
  ('m6','Calligraphy Brush Set','毛笔套装','$48','amazon.com','https://www.amazon.com','',false,null),
  ('m6','Reading Glasses','老花镜','$20','warbyparker.com','https://www.warbyparker.com','',true,'m7'),
  ('m7','Bonsai Tree','盆景','$65','bonsaiboy.com','https://www.bonsaiboy.com','https://picsum.photos/seed/bonsai/600/400',false,null),
  ('m7','Wool Sweater','羊毛衫','$80','uniqlo.com','https://www.uniqlo.com','',false,null);
