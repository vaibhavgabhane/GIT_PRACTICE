CREATE OR REPLACE FUNCTION billing.f_ipbill_tpacustname(iv_ipno character varying, iv_locationid character varying)
 RETURNS character varying
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$ declare v_customername varchar ( 1004 ) ; 

 v_customercount numeric ; 

 m record ; 
 
 n record;

 

begin set search_path to billing ; 

 select count ( 1 )into strict v_customercount from payerauthorization pa where pa.patientidentificationno = iv_ipno and pa.locationid = iv_locationid and coalesce ( pa.preference, 1 )= 1 ; 

 if ( v_customercount > 0 )then for m in ( select distinct c.customername from payerauthorization pa, crm.Vwr_customers c where pa.payerid = c.customerid and pa.patientidentificationno = iv_ipno and pa.locationid = iv_locationid and c.customertypeid = 29 and coalesce ( pa.preference, 1 )= 1 order by c.customername )loop if ( v_customername is not null )then v_customername := v_customername || ',' || m.customername ; 

 else v_customername := m.customername ; 

 end if ; 

 end loop ; 

 end if ; 

 return ( v_customername ) ; 

 end ; 

 $function$
;
