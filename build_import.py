import json, re, sys
from pathlib import Path
import openpyxl

source=Path(sys.argv[1]); out=Path(__file__).parent/'private'/'import-pending.sql'; out.parent.mkdir(exist_ok=True)
wb=openpyxl.load_workbook(source,data_only=True,read_only=True); rows=list(wb.active.values); headers=rows[0]
keys=['created_at','name','business_types','description','year_established','employees','governorate','district','town','address','map_url','multiple_locations','contact_name','position','phone','whatsapp','email','website','facebook','instagram','products_services','crops','details','logo_url','main_photo_url','additional_photos','works_directly','delivery','service_outside','areas_served','online_available','store_url','accuracy_confirmation','consent']
arrays={'business_types','products_services','crops','additional_photos','areas_served'}
def clean(v):
 if v is None:return None
 if isinstance(v,float) and v.is_integer():return str(int(v))
 return str(v).strip()
def arr(v): return [x.strip() for x in clean(v).split(',') if x.strip()] if clean(v) else []
def q(v): return "null" if v is None else "'"+str(v).replace("'","''")+"'"
cols=keys+['status']; statements=[]
for row in rows[1:]:
 d={k:(arr(v) if k in arrays else clean(v)) for k,v in zip(keys,row)}; d['status']='pending'
 vals=[]
 for k in cols:
  v=d[k]
  vals.append("ARRAY["+','.join(q(x) for x in v)+"]::text[]" if k in arrays else q(v))
 statements.append('insert into public.listings ('+','.join(cols)+') values ('+','.join(vals)+');')
out.write_text('-- Private import: 40 registrations, all pending. Do not commit this file.\n'+'\n'.join(statements),encoding='utf-8')
print(f'Wrote {len(statements)} pending registrations to {out}')
