-- FUNCTION: pharmacy.f_isdataexists_srv(text, text, text, numeric, numeric)

-- DROP FUNCTION IF EXISTS pharmacy.f_isdataexists_srv(text, text, text, numeric, numeric);

CREATE OR REPLACE FUNCTION pharmacy.f_isdataexists_srv(
	iv_itemcode text,
	iv_storecode text,
	iv_batchcode text DEFAULT NULL::text,
	iv_purprice numeric DEFAULT NULL::numeric,
	iv_mrprice numeric DEFAULT NULL::numeric)
    RETURNS character varying
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE SECURITY DEFINER PARALLEL UNSAFE
AS $BODY$
 declare v_output numeric := 0 ; 
 
begin set
search_path to pharmacy ;

raise notice 'Inside function pharmacy.f_isdataexists_srv Started @10';
raise notice ' @74 iv_itemcode = %',iv_itemcode;
raise notice ' @74 iv_storecode = %',iv_storecode;
raise notice ' @74 iv_batchcode = %',iv_batchcode;
raise notice ' @74 iv_purprice = %',iv_purprice;
raise notice ' @74 iv_mrprice = %',iv_mrprice;

v_output := 0 ;

if iv_batchcode is null then

raise notice 'If case for when batchcode is null';

select
	count (1) into
	strict v_output
from
	pharmacy.itemstore i
where
	i.itemcode = iv_itemcode
	and i.storecode = iv_storecode ;
	
else
raise notice 'else case for when batchcode is not null';

select
	count (1) into
	strict v_output
from
	pharmacy.qoh q
where
	q.itemcode = iv_itemcode
	and q.storecode = iv_storecode
	and q.batchcode = iv_batchcode ;
	

if v_output > 0 then 

raise notice '@44';

if iv_purprice is not null
or iv_mrprice is not null then

raise notice '@49';
select
	count (1) into
	strict v_output
from
	pharmacy.qoh q
where
	q.itemcode = iv_itemcode
	and q.storecode = iv_storecode
	and q.batchcode = iv_batchcode
	and q.purchaseprice = iv_purprice
	and q.mrp = iv_mrprice ;
else
raise notice '@62';
select
	count (1) into
	strict v_output
from
	pharmacy.qoh q
where
	q.itemcode = iv_itemcode
	and q.storecode = iv_storecode
	and q.batchcode = iv_batchcode ;
end if ;

raise notice ' @74 v_output = %',v_output;

if v_output = 0 then v_output := -1 ;
end if ;
end if ;
end if ;

raise notice 'Inside function pharmacy.f_isdataexists_srv Ended v_output = %',v_output;

return v_output ;

exception
when others then v_output := 0 ;

return v_output ;
end ;

$BODY$;

ALTER FUNCTION pharmacy.f_isdataexists_srv(text, text, text, numeric, numeric)
    OWNER TO "AHAzApolloNSKPrdRGNL";

GRANT EXECUTE ON FUNCTION pharmacy.f_isdataexists_srv(text, text, text, numeric, numeric) TO "AHAzApolloNSKPrdRGNL";

GRANT EXECUTE ON FUNCTION pharmacy.f_isdataexists_srv(text, text, text, numeric, numeric) TO PUBLIC;

GRANT EXECUTE ON FUNCTION pharmacy.f_isdataexists_srv(text, text, text, numeric, numeric) TO billing_nprod;

GRANT EXECUTE ON FUNCTION pharmacy.f_isdataexists_srv(text, text, text, numeric, numeric) TO digital_nprod;

GRANT EXECUTE ON FUNCTION pharmacy.f_isdataexists_srv(text, text, text, numeric, numeric) TO execute_sps;

GRANT EXECUTE ON FUNCTION pharmacy.f_isdataexists_srv(text, text, text, numeric, numeric) TO l2_117357;

GRANT EXECUTE ON FUNCTION pharmacy.f_isdataexists_srv(text, text, text, numeric, numeric) TO l2support_nprod;

GRANT EXECUTE ON FUNCTION pharmacy.f_isdataexists_srv(text, text, text, numeric, numeric) TO l3_926317;

GRANT EXECUTE ON FUNCTION pharmacy.f_isdataexists_srv(text, text, text, numeric, numeric) TO l3_927139;

GRANT EXECUTE ON FUNCTION pharmacy.f_isdataexists_srv(text, text, text, numeric, numeric) TO mm_nprod;

GRANT EXECUTE ON FUNCTION pharmacy.f_isdataexists_srv(text, text, text, numeric, numeric) TO pharmacy_nprod;

GRANT EXECUTE ON FUNCTION pharmacy.f_isdataexists_srv(text, text, text, numeric, numeric) TO wards_nprod;

