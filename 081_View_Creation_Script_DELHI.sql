--region specific views with depndencies on other schema or DB objects


CREATE OR REPLACE VIEW pharmacy.vw_session_for_pharma
AS SELECT pg_stat_activity.application_name AS program,
    pg_stat_activity.pid AS audsid
   FROM pg_stat_activity
  WHERE pg_stat_activity.pid = pg_backend_pid();
  
CREATE OR REPLACE VIEW billing.vw_session_for_billing
AS SELECT pg_stat_activity.application_name AS program,
    pg_stat_activity.pid AS audsid
   FROM pg_stat_activity
  WHERE pg_stat_activity.pid = pg_backend_pid();

CREATE OR REPLACE VIEW mm.vw_session_for_mm
AS SELECT pg_stat_activity.application_name AS program,
    pg_stat_activity.pid AS audsid
   FROM pg_stat_activity
  WHERE pg_stat_activity.pid = pg_backend_pid();

CREATE OR REPLACE VIEW HR.MV_EMPLOYEE_MAIN_DETAILS
(EMPLOYEEID,EMPLOYEECODE,TITLEID,FIRSTNAME,MIDDLENAME,LASTNAME,GENDERID,DOB,MARITALSTATUSID,BIRTHCOUNTRYID,NATIONALITYID,PHYSICALLYHANDICAPPED,SUPERVISORID,COMPANYID,LOCATIONID,DEPARTMENTID,COSTCENTERID,MAINCOSTCENTERID,PAYROLLACCOUNTINGAREAID,EMPLOYEELEVELID,EMPLOYEECATEGORYID,EMPLOYEETYPEID,DESIGNATIONID,GRADEID,LAST_SALARY,ADDRESS_TYPE,EMPLOYMENTSTATUSID,STATUS,CREATEDBY,CREATEDDATE,UPDATEDBY,UPDATEDDATE,FLEXIFIELD1,FLEXIFIELD2,PRESENTEMPLOYEEID,LOGINID,SPECIALITYID,EMAILID,CALENDARPRIVILEGES,SCHEDULABLE,SPECIALIZEDSERVICES,PROCESSED_FLAG,TRANSFERSTATUS)
AS
select EMPLOYEEID,EMPLOYEECODE,TITLEID,FIRSTNAME,MIDDLENAME,LASTNAME,GENDERID,DOB,MARITALSTATUSID,
BIRTHCOUNTRYID,NATIONALITYID,PHYSICALLYHANDICAPPED,SUPERVISORID,COMPANYID,LOCATIONID,DEPARTMENTID,
COSTCENTERID,MAINCOSTCENTERID,PAYROLLACCOUNTINGAREAID,EMPLOYEELEVELID,EMPLOYEECATEGORYID,
EMPLOYEETYPEID,DESIGNATIONID,GRADEID,LAST_SALARY,ADDRESS_TYPE,EMPLOYMENTSTATUSID,STATUS,CREATEDBY,
CREATEDDATE,UPDATEDBY,UPDATEDDATE,FLEXIFIELD1,FLEXIFIELD2,PRESENTEMPLOYEEID,LOGINID,SPECIALITYID,
EMAILID,CALENDARPRIVILEGES,SCHEDULABLE,SPECIALIZEDSERVICES,PROCESSED_FLAG,TRANSFERSTATUS from
hr.employee_main_details emd 
where exists
(select 1 from ehis.vwr_coa_struct_details csd 
where chartid=emd.locationid 
and (((csd.parentid in('10100','15100','90000','10300','10310','10000','10330','10320','10340','15500','13000','14100','10500'))
AND Current_database() IN ('ehischn'))
OR (csd.parentid='10400'
AND Current_database() IN ('ehisbbs'))
OR ((csd.parentid in ('10370', '10600', '10350', '10390')
AND Current_database() IN ('ehisblr')))
OR ((csd.parentid='17100'
AND Current_database() IN ('ahsag')))
OR ((csd.parentid='10700'
AND Current_database() IN ('ahdel')))
OR ((csd.parentid in ('10200', '10900', '12100', '30000', '10360', '50100', '50500', '16000', '50700', '17000', '17050','19100','17200')
and emd.locationid not in ('12102', '10381')
AND Current_database() IN ('ehishyd')))
OR ((csd.parentid='10800'
AND Current_database() IN ('ehisaghl')))
OR ((csd.parentid in ('10550', '11000', '11200')
AND Current_database() IN ('ehismum')))
OR ((csd.parentid in ('10200', '10900', '12100', '30000', '10360', '50100', '50500', '16000','50700','17000')
AND Current_database() IN ('ehisnsk'))))
);

CREATE OR REPLACE VIEW ADT.ADMITTINGDOCTOR
(ADMITTINGDOCTORID,ADMITTINGDOCTORCODE,ADMITTINGDOCTORNAME,SPECIALIZATION)
AS
select
	emd.employeeid ADMITTINGDOCTORID,
	emd.employeeid ADMITTINGDOCTORCODE,
	EMD.FIRSTNAME || ' ' || EMD.MIDDLENAME || ' ' || EMD.LASTNAME ADMITTINGDOCTORNAME,
	emd.specialityid specialization
from
	hr.mv_employee_main_details EMD
inner join hr.vwr_employee_structure_details ESD
    on
	EMD.EMPLOYEECATEGORYID = ESD.EMP_DTL_ID
where
	(EMD.STATUS = 1)
	and (ESD.EMP_DTL_ID in
             (
	select
		d.emprefernceid
	from
		hr.empstructcodemapping d
	where
		d.empstructname in ('DOCTORS', 'CONSULTANTS')));

CREATE OR REPLACE VIEW ADT.ADMITTINGDOCTOR1
(ADMITTINGDOCTORID,ADMITTINGDOCTORCODE,ADMITTINGDOCTORNAME,SPECIALIZATION)
AS
SELECT emd.employeeid ADMITTINGDOCTORID,emd.employeeid ADMITTINGDOCTORCODE,
    EMD.FIRSTNAME||' '||EMD.MIDDLENAME||' '||EMD.LASTNAME ADMITTINGDOCTORNAME,
    emd.specialityid specialization
    FROM hr.mv_employee_main_details EMD
    --INNER JOIN hr.vwr_employee_structure_details ESD
    --ON EMD.EMPLOYEECATEGORYID=ESD.EMP_DTL_ID
    WHERE (EMD.STATUS=1)
    AND EMD.EMPLOYEECATEGORYID=75;

CREATE OR REPLACE VIEW ADT.CLINICALREVIEWDETAILS
(CLINICALREVIEWID,PATIENTIDENTIFIERNO,UHID,REVIEWTYPE,REVIEWSTATUS,CREATEDBY,CREATEDDATE)
AS
SELECT CLINICALREVIEWID,PATIENTIDENTIFIERNO,UHID,
REVIEWTYPE,REVIEWSTATUS,CREATEDBY,CREATEDDATE FROM CRM.Clinicalreviewdetails;

CREATE OR REPLACE VIEW ADT.CUSTOMERS
(CUSTOMERID,CUSTOMERCATEGORYID,CUSTOMERTYPEID,CUSTOMERNAME,LOCATIONID,STATUSID,ESTABLISHEDDATE,TITLEID,FIRSTNAME,MIDDLENAME,LASTNAME,GENDERID,DATEOFBIRTH,WEDDINGANNIVERSARY,MCIREGISTRATIONNO,RANK,PAN,PARENTCOMPANY,INDUSTRYTYPE,INDUSTRYSUBTYPE,TOTALNOOFEMPLOYEES,TPANAME,INSURANCECOMPANYNAME,REGISTEREDNO,NOOFBENIFICIARIES,IRDANO,HEALTHCAREFECILITATOR,CREATEDBY,CREATEDDATE,UPDATEDBY,UPDATEDDATE,ASSIGNEDOWNER,AVERAGEAGE,PRIMARYOWNER,STATEGOVTREGNO,CUSTOMERCODE,QUALIFICATION,SPECIALIZATION)
AS
SELECT CUSTOMERID,CUSTOMERCATEGORYID,CUSTOMERTYPEID,CUSTOMERNAME,LOCATIONID,STATUSID,ESTABLISHEDDATE,TITLEID,
  FIRSTNAME,MIDDLENAME,LASTNAME,GENDERID,DATEOFBIRTH,WEDDINGANNIVERSARY,MCIREGISTRATIONNO,RANK,PAN,
  PARENTCOMPANY,INDUSTRYTYPE,INDUSTRYSUBTYPE,TOTALNOOFEMPLOYEES,TPANAME,INSURANCECOMPANYNAME,REGISTEREDNO,
  NOOFBENIFICIARIES,IRDANO,HEALTHCAREFECILITATOR,CREATEDBY,CREATEDDATE,UPDATEDBY,UPDATEDDATE,ASSIGNEDOWNER,
  AVERAGEAGE,PRIMARYOWNER,STATEGOVTREGNO,CUSTOMERCODE,QUALIFICATION,SPECIALIZATION fROM crm.vwr_customers;

CREATE OR REPLACE VIEW AHC.DIAGNOSISMASTER
(DIAGNOSISID,DIAGNOSISNAME,DIAGNOSISDESCRIPTION,ICDCODE,STATUS,CREATEDBY,CREATEDDATE)
AS
select DIAGNOSISID,DIAGNOSISNAME,DIAGNOSISDESCRIPTION,ICDCODE,STATUS,CREATEDBY,CREATEDDATE
    from wards.diagnosismaster;

CREATE OR REPLACE VIEW AHC.DQSCHEDULEDPATIENTS
(AHCID,SCHEDULEDDATE)
AS
SELECT DISTINCT AHCID,SCHEDULEDDATE
FROM
(
SELECT     AHCID, pv.visitdate AS ScheduledDate
FROM         AHC.Patientvisits pv
where (pv.visitdate::date=current_date or pv.visitdate::date=(current_date-1) or pv.visitdate::date=(current_date-2))
GROUP BY visitdate, AHCID
UNION
SELECT     AHCID, pv.visitdate AS ScheduledDate
FROM         AHC.PatientAdditionalvisits pv
where (pv.visitdate::date=current_date or pv.visitdate::date=(current_date-1) or pv.visitdate::date=(current_date-2))
GROUP BY visitdate, AHCID
) T;

CREATE OR REPLACE VIEW AHC.PATIENTDQVISITCOUNTER
(AHCID,LOCATIONID,VISITID,COUNTERID)
AS
SELECT AP.AHCID,AP.LOCATIONID,PVD.VISITID, VC.COUNTERID
  FROM AHC.AHCPATIENT AP
  JOIN AHC.PATIENTPACKAGE PP
    ON AP.AHCID = PP.AHCID
  JOIN AHC.PATIENTVISITS PV
    ON AP.AHCID = PV.AHCID
 INNER JOIN AHC.PATIENTVISITDETAIL PVD
    ON PVD.AHCID = AP.AHCID
   AND PVD.LOCATION = AP.LOCATIONID
 INNER JOIN AHC.VISITCOUNTER VC
    ON VC.VISITID = PVD.VISITID
/* WHERE PVD.INVESTIGATIONTYPEID = 161*/
 and vc.visitcounterstatus = 1
/* and PV.VISITDATE::date=Current_date*/
   AND NOT EXISTS (SELECT NULL
          FROM AHC.PATIENTVISITCOUNTER PVC
         WHERE PVC.VISITID = PVD.VISITID
           AND PVC.STATUS = 1
           AND PVC.AHCID = AP.AHCID)
UNION
SELECT AP.AHCID,AP.LOCATIONID,PVC.VISITID, PVC.COUNTERID
  FROM AHC.AHCPATIENT AP
  JOIN AHC.PATIENTPACKAGE PP
    ON AP.AHCID = PP.AHCID

 INNER JOIN AHC.PATIENTVISITCOUNTER PVC
    ON PVC.AHCID = AP.AHCID
 WHERE PVC.STATUS = 1;
 
CREATE OR REPLACE VIEW AHC.SCHEDULEDAHCPATIENTS
(AHCID,SCHEDULEDDATE,VISITSTATUS)
AS
select distinct AHCID,ScheduledDate,visitstatus
from(
SELECT distinct  AHCID, pv.visitdate AS ScheduledDate,pv.visitstatus
FROM         AHC.Patientvisits pv
UNION
SELECT  distinct   AHCID, pav.visitdate AS ScheduledDate,pav.visitstatus
FROM         AHC.PatientAdditionalvisits pav) pnt
GROUP BY ScheduledDate, AHCID,visitstatus;

CREATE OR REPLACE VIEW AHC.SCHEDULEDPATIENTS
(AHCID,SCHEDULEDDATE,VISITSTATUS)
AS
SELECT     AHCID, pv.visitdate::date AS ScheduledDate,pv.visitstatus
FROM         AHC.Patientvisits pv
where (pv.visitdate::date=current_date or pv.visitdate::date=(current_date+1) or pv.visitdate::date=(current_date-1))
GROUP BY visitdate, AHCID,visitstatus
UNION
SELECT     AHCID, pv.visitdate::date AS ScheduledDate,pv.visitstatus
FROM         AHC.PatientAdditionalvisits pv
where (pv.visitdate::date=current_date or pv.visitdate::date=(current_date+1) or pv.visitdate::date=(current_date-1))
GROUP BY visitdate, AHCID,visitstatus;

CREATE OR REPLACE VIEW AHC.VMISSINGGTT
(PACKAGEID,GTTCOUNT)
AS
select distinct pv.packageid,(select count(1) from billing.vw_packageiteminclusiondetails pid
where pid.packageid=pv.packageid and pid.serviceid in (268,269,4545) and pid.locationid='10201')
as gttcount from AHC.packagevisits pv
order by pv.packageid asc;

CREATE OR REPLACE VIEW BILLING.AHCPACKAGES
(PACKAGESERVICETIME,APPLICABLETOAGEGROUPFROM,APPLICABLETOAGEGROUPTO,APPLICABLEORGANIZATIONS,STARTDATE,EXPIRYDATE,FROMDATE,TODATE,ACTUALCOST,DISCOUNT,PACKAGECATEGORYID,APPROVALDOCUMENT,CONFIRMATIONFROMCRM,PATIENTEDUCATIONMATERIALFILENA,PATIENTEDUCATIONMATERIALFILETY,PATIENTEDUCATIONMATERIALFILEPA,LOCATIONID,PACKAGESTATUSID,REASONFORACTIVATION,REASONFORDEACTIVATION,STATUS,PACKAGEID,PACKAGECODE,PACKAGENAME,PACKAGEDESCRIPTION,PACKAGEAMOUNT,AMOUNTCURRENCY,BREAKFASTNEEDED,PACKAGETYPE,APPLICABLETOGENDER,SERVICETYPEID,SERVICETYPENAME,TOTALCOST,DEPTID)
AS
select
0 PACKAGESERVICETIME,
0 APPLICABLETOAGEGROUPFROM,
0 APPLICABLETOAGEGROUPTO,
'' APPLICABLEORGANIZATIONS,
sm.effectivefrom STARTDATE,
sm.effectiveto EXPIRYDATE,
NULL FROMDATE,
NULL TODATE,
0 ACTUALCOST,
0 DISCOUNT,
--1000 TOTALCOST,
NULL PACKAGECATEGORYID,
NULL APPROVALDOCUMENT,
NULL CONFIRMATIONFROMCRM,
NULL PATIENTEDUCATIONMATERIALFILENA,
NULL PATIENTEDUCATIONMATERIALFILETY,
NULL PATIENTEDUCATIONMATERIALFILEPA,
sm.locationid LOCATIONID,
NULL PACKAGESTATUSID,
NULL REASONFORACTIVATION,
NULL REASONFORDEACTIVATION,
(case upper(sm.servicestatus) when 'ACTIVE' then 1 when 'INACTIVE' then 0 end) STATUS,
sm.serviceid PACKAGEID,
sm.servicecode PACKAGECODE,
sm.servicename PACKAGENAME,
sm.servicedescription PACKAGEDESCRIPTION,
--NTD.FINALTariff PACKAGEAMOUNT,
1000 PACKAGEAMOUNT,
NULL AMOUNTCURRENCY,
NULL BREAKFASTNEEDED,
lov.lovdetaildescription PACKAGETYPE,
NULL APPLICABLETOGENDER,
sm.servicetypeid ServiceTypeID,
st.servicetypename ServiceTypeName,
1000 TOTALCOST,
sm.deptid Deptid
--NTD.FINALTariff TOTALCOST
from BILLING.vw_servicemaster sm
left Outer Join billing.vwr_servicetype st on sm.servicetypeid=st.servicetypeid
left Outer Join billing.vwr_lovdetail lov On Lov.Lovdetailid=sm.packagetypeid
--Left Outer Join newtemplatetariffDetails Ntd On sm.serviceid=ntd.ServiceId
where st.servicetypeid in (141,142);

CREATE OR REPLACE VIEW SECURITYTEST_64.LOCATIONMASTER
(LOCATIONID,LOCATIONCODE,LOCATIONNAME,DESCRIPTION,PARENTID,STATUS,LEVELMASTERID)
AS
SELECT
chartid as LocationID,
leveldetailcode as LocationCode,
leveldetailname as LocationName,
description,
parentid,
status,
levelmasterid
FROM ehis.vwr_coa_struct_details
WHERE ((
(Current_database() IN ('ehisbbs'))--, 'AHSAG', 'EHISCHN', 'AHDEL', 'EHISHYD', 'EHISAGHL', 'EHISMUM','EHISNSK'))
AND parentid in ('10100','10400'))
OR ( (Current_database() = 'ehisblr') AND parentid in ('10370','10600','10350','10390'))
OR ((Current_database() = 'ahsag') AND parentid in ('17100') )
OR ((Current_database() = 'ehischn') AND parentid in ('10100', '15100', '90000', '10300', '10310', '10000', '10330', '10320','10340', '15500', '50700','13000','14100','10500')) 
OR ((Current_database() = 'ahdel') AND parentid in ('10700')) 
OR ((Current_database() = 'ehishyd') AND parentid in ('10200','10900','12100','30000','10360','50100','50500','16000','50700','17000','17050','19100','17200')) 
OR ((Current_database() = 'ehisaghl') AND parentid in ('10800')) 
OR ((Current_database() = 'ehismum') AND parentid in ('10550','11000','11200')) 
OR ((Current_database() = 'ehisnsk') AND parentid in ('12100','10200')));

CREATE OR REPLACE VIEW BILLING.CODESYSTEMMASTER_NEW
(CODESYSTEMID,SERVICEID,SYSTEMCODE,SYSTEMCODENAME,SUBCODE,STATUS,LOCATIONID,CREATEDBY,CREATEDDATE,UPDATEDBY,UPDATEDDATE)
AS
SELECT CODESYSTEMID,SERVICEID,SYSTEMCODE,SYSTEMCODENAME,SUBCODE,STATUS,LOCATIONID,CREATEDBY,CREATEDDATE,UPDATEDBY,UPDATEDDATE
  FROM BILLING.VW_CODESYSTEMMASTER CODESYSTEMMASTER
  where CODESYSTEMMASTER.LOCATIONID IN(select l.LocationID from securitytest_64.locationmaster l
                                       );

CREATE OR REPLACE VIEW BILLING.CUSTOMERS
(CUSTOMERID,CUSTOMERNAME,CUSTOMERCATEGORYID,CUSTOMERCATEGORYNAME,CUSTOMERTYPEID,CUSTOMERTYPENAME,TITLEID,TITLE,FIRSTNAME,MIDDLENAME,LASTNAME)
AS
SELECT CustomerID,
CustomerName,
CM.CustomerCategoryId, CustomerCategoryName,
cm.CustomerTypeID,CustomerTypeName,
cm.TitleID,TM.TITLEType as Title ,
FirstName,
MiddleName,
LastName
FROM crm.vwr_customers CM
Join crm.vwr_customercategorymaster CCM ON CCM.CUSTOMERCATEGORYID=CM.Customercategoryid
JOIN crm.vwr_customertypemaster CTM ON CTM.CUSTOMERTYPEID=CM.CUSTOMERTYPEID
--LEFT OUTER JOIN crm.vwr_statusmaster SM  ON CM.Statusid=SM.Statusid
LEFT OUTER JOIN ehis.vwr_titlemaster TM ON TM.TITLEID=CM.Titleid;

CREATE OR REPLACE VIEW BILLING.GENDER_NEW
(GENDER,FROMAGE,TOAGE,CREATEDBY,CREATEDDATE,UPDATEDBY,UPDATEDDATE,GENDERID,SERVICEID,LOCATIONID)
AS
SELECT GENDER.GENDER      GENDER,
       GENDER.FROMAGE     FROMAGE,
       GENDER.TOAGE       TOAGE,
       GENDER.CREATEDBY   CREATEDBY,
       GENDER.CREATEDDATE CREATEDDATE,
       GENDER.UPDATEDBY   UPDATEDBY,
       GENDER.UPDATEDDATE UPDATEDDATE,
       GENDER.GENDERID    GENDERID,
       GENDER.SERVICEID   SERVICEID,
       GENDER.LOCATIONID  LOCATIONID
  FROM BILLING.VW_GENDER GENDER
  WHERE GENDER.LOCATIONID  IN(select l.LocationID from securitytest_64.locationmaster l);

CREATE OR REPLACE VIEW BILLING.IPPATIENT_DETAILS_VU
(INPATIENTNO,UHID,ADMISSIONDATE,STATUSNAME,DISCHARGEDATE,BEDID,ROOM,WARD,SERVICEID,SERVICENAME,SERVICETYPENAME,CREATEDDATE)
AS
SELECT ipm.Inpatientno,
       ipm.uhid,
       to_char(ipm.Dateofadmission, 'DD-MON-YYYY') AS ADMISSIONDATE,
       psm.statusname,
       to_char(ad.dischargeinitiateddatetime, 'DD-MON-YYYY') AS dischargedate,
       BM.Bedid,
       LD.LEVELDETAILNAME AS ROOM,
       LD1.LEVELDETAILNAME AS WARD,
       srd.serviceid,
       srd.servicename,
       srt.servicetypename as servicetypename,
       srd.createddate
  FROM adt.inpatientmaster           ipm,
       adt.patientstatusmaster       psm,
       wards.admissiondetails        ad,
       adt.BEDMASTER                 BM,
       adt.LEVELDETAIL               LD,
       adt.LEVELDETAIL               LD1,
       Billing.Servicerequest        sr,
       billing.servicerequestdetails srd,
       billing.vwr_servicetype           srt
 where psm.statusid = ipm.status
   and ad.admissionno = ipm.admissionno
   and BM.BEDID = IPM.BEDID
   and LD.LEVELDETAILID = BM.LEVELDETAILID
   and LD1.LEVELDETAILID = LD.PARENTLEVELID
   AND ld1.levelno = 6
   and sr.patientidentifierno = ipm.inpatientno
   and srd.requestid = sr.requestid
   and srt.servicetypeid = srd.servicetypeid
   and ipm.activestatus = 0
   AND ipm.status IN (7, 8, 9)
   AND (ipm.Dateofadmission::date) BETWEEN (current_date - 13) and (current_date)

union all

SELECT ipm.Inpatientno,
       ipm.uhid,
       to_char(ipm.Dateofadmission, 'DD-MON-YYYY') AS ADMISSIONDATE,
       psm.statusname,
       to_char(ad.dischargeinitiateddatetime, 'DD-MON-YYYY') AS
dischargedate,
       BM.Bedid,
       LD.LEVELDETAILNAME AS ROOM,
       LD1.LEVELDETAILNAME AS WARD,
       osrd.itemid,
       osrd.ITEMNAME as CONSUMABLE,
       srt.servicetypename as servicetypename,
       osrd.createddate
  FROM adt.inpatientmaster                ipm,
       adt.patientstatusmaster            psm,
       wards.admissiondetails             ad,
       adt.BEDMASTER                      BM,
       adt.LEVELDETAIL                    LD,
       adt.LEVELDETAIL                    LD1,
       Billing.Servicerequest             sr,
       billing.otherservicerequestdetails osrd,
       billing.vwr_servicetype                srt
 where psm.statusid = ipm.status
   and ad.admissionno = ipm.admissionno
   and BM.BEDID = IPM.BEDID
   and LD.LEVELDETAILID = BM.LEVELDETAILID
   and LD1.LEVELDETAILID = LD.PARENTLEVELID
   AND ld1.levelno = 6
   and sr.patientidentifierno = ipm.inpatientno
   and osrd.requestid = sr.requestid
   and srt.servicetypeid = osrd.servicetypeid
   and osrd.servicetypeid in (181, 182, 183)
   and osrd.SERVICESTATUS <> 'CANCELLED'
   and ipm.activestatus = 0
   AND ipm.status IN (7, 8, 9)
   AND (ipm.Dateofadmission::date) BETWEEN (current_date - 13) AND
       (current_date)

union all

  SELECT ipm.Inpatientno,
       ipm.uhid,
       to_char(ipm.Dateofadmission, 'DD-MON-YYYY') AS ADMISSIONDATE,
       psm.statusname,
       to_char(ad.dischargeinitiateddatetime, 'DD-MON-YYYY') AS
dischargedate,
       BM.Bedid,
       LD.LEVELDETAILNAME AS ROOM,
       LD1.LEVELDETAILNAME AS WARD,
       osrd.itemid,
       osrd.ITEMNAME as Pharmacy,
       srt.servicetypename as servicetypename,
       osrd.createddate
  FROM adt.inpatientmaster                ipm,
       adt.patientstatusmaster            psm,
       wards.admissiondetails             ad,
       adt.BEDMASTER                      BM,
       adt.LEVELDETAIL                    LD,
       adt.LEVELDETAIL                    LD1,
       Billing.Servicerequest             sr,
       billing.otherservicerequestdetails osrd,
       billing.vwr_servicetype                srt
 where psm.statusid = ipm.status
   and ad.admissionno = ipm.admissionno
   and BM.BEDID = IPM.BEDID
   and LD.LEVELDETAILID = BM.LEVELDETAILID
   and LD1.LEVELDETAILID = LD.PARENTLEVELID
   AND ld1.levelno = 6
   and sr.patientidentifierno = ipm.inpatientno
   and osrd.requestid = sr.requestid
   and srt.servicetypeid = osrd.servicetypeid
   and osrd.servicetypeid in (300, 301, 302, 303)
   and osrd.SERVICESTATUS <> 'CANCELLED'
   and ipm.activestatus = 0
   AND ipm.status IN (7, 8, 9)
   AND (ipm.Dateofadmission::date) BETWEEN (current_date - 13) AND (current_date)

 union

 SELECT ipm.Inpatientno,
       ipm.uhid,
       to_char(ipm.Dateofadmission, 'DD-MON-YYYY') AS ADMISSIONDATE,
       psm.statusname,
       to_char(ad.dischargeinitiateddatetime, 'DD-MON-YYYY') AS dischargedate,
       BM.Bedid,
       LD.LEVELDETAILNAME AS ROOM,
       LD1.LEVELDETAILNAME AS WARD,
       srd.serviceid,
       srd.servicename,
       srt.servicetypename as servicetypename,
       srd.createddate
  FROM adt.inpatientmaster           ipm,
       adt.patientstatusmaster       psm,
       wards.admissiondetails        ad,
       adt.BEDMASTER                 BM,
       adt.LEVELDETAIL               LD,
       adt.LEVELDETAIL               LD1,
       Billing.Servicerequest        sr,
       billing.servicerequestdetails srd,
       billing.vwr_servicetype           srt
 where psm.statusid = ipm.status
   and ad.admissionno = ipm.admissionno
   and BM.BEDID = IPM.BEDID
   and LD.LEVELDETAILID = BM.LEVELDETAILID
   and LD1.LEVELDETAILID = LD.PARENTLEVELID
   AND ld1.levelno = 6
   and sr.patientidentifierno = ipm.inpatientno
   and srd.requestid = sr.requestid
   and srt.servicetypeid = srd.servicetypeid
   and ipm.activestatus = 0
   AND ipm.status IN (7, 8, 9)
   AND (ipm.Dateofadmission::date) BETWEEN (current_date - 13) AND
       (current_date)

union all

SELECT ipm.Inpatientno,
       ipm.uhid,
       to_char(ipm.Dateofadmission, 'DD-MON-YYYY') AS ADMISSIONDATE,
       psm.statusname,
       to_char(ad.dischargeinitiateddatetime, 'DD-MON-YYYY') AS
dischargedate,
       BM.Bedid,
       LD.LEVELDETAILNAME AS ROOM,
       LD1.LEVELDETAILNAME AS WARD,
       osrd.itemid,
       osrd.ITEMNAME as CONSUMABLE,
       srt.servicetypename as servicetypename,
       osrd.createddate
  FROM adt.inpatientmaster                ipm,
       adt.patientstatusmaster            psm,
       wards.admissiondetails             ad,
       adt.BEDMASTER                      BM,
       adt.LEVELDETAIL                    LD,
       adt.LEVELDETAIL                    LD1,
       Billing.Servicerequest             sr,
       billing.otherservicerequestdetails osrd,
       billing.vwr_servicetype                srt
 where psm.statusid = ipm.status
   and ad.admissionno = ipm.admissionno
   and BM.BEDID = IPM.BEDID
   and LD.LEVELDETAILID = BM.LEVELDETAILID
   and LD1.LEVELDETAILID = LD.PARENTLEVELID
   AND ld1.levelno = 6
   and sr.patientidentifierno = ipm.inpatientno
   and osrd.requestid = sr.requestid
   and srt.servicetypeid = osrd.servicetypeid
   and osrd.servicetypeid in (181, 182, 183)
   and osrd.SERVICESTATUS <> 'CANCELLED'
   and ipm.activestatus = 0
   AND ipm.status IN (7, 8, 9)
   AND (ipm.Dateofadmission::date) BETWEEN (current_date - 13) AND
       (current_date)

union all

  SELECT ipm.Inpatientno,
       ipm.uhid,
       to_char(ipm.Dateofadmission, 'DD-MON-YYYY') AS ADMISSIONDATE,
       psm.statusname,
       to_char(ad.dischargeinitiateddatetime, 'DD-MON-YYYY') AS
dischargedate,
       BM.Bedid,
       LD.LEVELDETAILNAME AS ROOM,
       LD1.LEVELDETAILNAME AS WARD,
       osrd.itemid,
       osrd.ITEMNAME as Pharmacy,
       srt.servicetypename as servicetypename,
       osrd.createddate
  FROM adt.inpatientmaster                ipm,
       adt.patientstatusmaster            psm,
       wards.admissiondetails             ad,
       adt.BEDMASTER                      BM,
       adt.LEVELDETAIL                    LD,
       adt.LEVELDETAIL                    LD1,
       Billing.Servicerequest             sr,
       billing.otherservicerequestdetails osrd,
       billing.vwr_servicetype                srt
 where psm.statusid = ipm.status
   and ad.admissionno = ipm.admissionno
   and BM.BEDID = IPM.BEDID
   and LD.LEVELDETAILID = BM.LEVELDETAILID
   and LD1.LEVELDETAILID = LD.PARENTLEVELID
   AND ld1.levelno = 6
   and sr.patientidentifierno = ipm.inpatientno
   and osrd.requestid = sr.requestid
   and srt.servicetypeid = osrd.servicetypeid
   and osrd.servicetypeid in (300, 301, 302, 303)
   and osrd.SERVICESTATUS <> 'CANCELLED'
   and ipm.activestatus = 0
   AND ipm.status IN (7, 8, 9)
   AND (ipm.Dateofadmission::date) BETWEEN (current_date - 13) AND
       (current_date)

  union

   SELECT ipm.Inpatientno,
       ipm.uhid,
       to_char(ipm.Dateofadmission, 'DD-MON-YYYY') AS ADMISSIONDATE,
       psm.statusname,
       to_char(ad.dischargeinitiateddatetime, 'DD-MON-YYYY') AS dischargedate,
       BM.Bedid,
       LD.LEVELDETAILNAME AS ROOM,
       LD1.LEVELDETAILNAME AS WARD,
       srd.serviceid,
       srd.servicename,
       srt.servicetypename as servicetypename,
       srd.createddate
  FROM adt.inpatientmaster           ipm,
       adt.patientstatusmaster       psm,
       wards.admissiondetails        ad,
       adt.BEDMASTER                 BM,
       adt.LEVELDETAIL               LD,
       adt.LEVELDETAIL               LD1,
       Billing.Servicerequest        sr,
       billing.servicerequestdetails srd,
       billing.vwr_servicetype           srt
 where psm.statusid = ipm.status
   and ad.admissionno = ipm.admissionno
   and BM.BEDID = IPM.BEDID
   and LD.LEVELDETAILID = BM.LEVELDETAILID
   and LD1.LEVELDETAILID = LD.PARENTLEVELID
   AND ld1.levelno = 6
   and sr.patientidentifierno = ipm.inpatientno
   and srd.requestid = sr.requestid
   and srt.servicetypeid = srd.servicetypeid
   and ipm.activestatus = 1
   AND (ipm.Dateofadmission::date) BETWEEN (current_date - 13) AND
       (current_date)

union all

SELECT ipm.Inpatientno,
       ipm.uhid,
       to_char(ipm.Dateofadmission, 'DD-MON-YYYY') AS ADMISSIONDATE,
       psm.statusname,
       to_char(ad.dischargeinitiateddatetime, 'DD-MON-YYYY') AS
dischargedate,
       BM.Bedid,
       LD.LEVELDETAILNAME AS ROOM,
       LD1.LEVELDETAILNAME AS WARD,
       osrd.itemid,
       osrd.ITEMNAME as CONSUMABLE,
       srt.servicetypename as servicetypename,
       osrd.createddate
  FROM adt.inpatientmaster                ipm,
       adt.patientstatusmaster            psm,
       wards.admissiondetails             ad,
       adt.BEDMASTER                      BM,
       adt.LEVELDETAIL                    LD,
       adt.LEVELDETAIL                    LD1,
       Billing.Servicerequest             sr,
       billing.otherservicerequestdetails osrd,
       billing.vwr_servicetype                srt
 where psm.statusid = ipm.status
   and ad.admissionno = ipm.admissionno
   and BM.BEDID = IPM.BEDID
   and LD.LEVELDETAILID = BM.LEVELDETAILID
   and LD1.LEVELDETAILID = LD.PARENTLEVELID
   AND ld1.levelno = 6
   and sr.patientidentifierno = ipm.inpatientno
   and osrd.requestid = sr.requestid
   and srt.servicetypeid = osrd.servicetypeid
   and osrd.servicetypeid in (181, 182, 183)
   and osrd.SERVICESTATUS <> 'CANCELLED'
   and ipm.activestatus = 1
   AND (ipm.Dateofadmission::date) BETWEEN (current_date - 13) AND
       (current_date)

union all

  SELECT ipm.Inpatientno,
       ipm.uhid,
       to_char(ipm.Dateofadmission, 'DD-MON-YYYY') AS ADMISSIONDATE,
       psm.statusname,
       to_char(ad.dischargeinitiateddatetime, 'DD-MON-YYYY') AS
dischargedate,
       BM.Bedid,
       LD.LEVELDETAILNAME AS ROOM,
       LD1.LEVELDETAILNAME AS WARD,
       osrd.itemid,
       osrd.ITEMNAME as Pharmacy,
       srt.servicetypename as servicetypename,
       osrd.createddate
  FROM adt.inpatientmaster                ipm,
       adt.patientstatusmaster            psm,
       wards.admissiondetails             ad,
       adt.BEDMASTER                      BM,
       adt.LEVELDETAIL                    LD,
       adt.LEVELDETAIL                    LD1,
       Billing.Servicerequest             sr,
       billing.otherservicerequestdetails osrd,
       billing.vwr_servicetype                srt
 where psm.statusid = ipm.status
   and ad.admissionno = ipm.admissionno
   and BM.BEDID = IPM.BEDID
   and LD.LEVELDETAILID = BM.LEVELDETAILID
   and LD1.LEVELDETAILID = LD.PARENTLEVELID
   AND ld1.levelno = 6
   and sr.patientidentifierno = ipm.inpatientno
   and osrd.requestid = sr.requestid
   and srt.servicetypeid = osrd.servicetypeid
   and osrd.servicetypeid in (300, 301, 302, 303)
   and osrd.SERVICESTATUS <> 'CANCELLED'
   and ipm.activestatus = 1
   AND (ipm.Dateofadmission::date) BETWEEN (current_date - 13) AND
       (current_date)

 union

 SELECT ipm.Inpatientno,
       ipm.uhid,
       to_char(ipm.Dateofadmission, 'DD-MON-YYYY') AS ADMISSIONDATE,
       psm.statusname,
       to_char(ad.dischargeinitiateddatetime, 'DD-MON-YYYY') AS dischargedate,
       BM.Bedid,
       LD.LEVELDETAILNAME AS ROOM,
       LD1.LEVELDETAILNAME AS WARD,
       srd.serviceid,
       srd.servicename,
       srt.servicetypename as servicetypename,
       srd.createddate
  FROM adt.inpatientmaster           ipm,
       adt.patientstatusmaster       psm,
       wards.admissiondetails        ad,
       adt.BEDMASTER                 BM,
       adt.LEVELDETAIL               LD,
       adt.LEVELDETAIL               LD1,
       Billing.Servicerequest        sr,
       billing.servicerequestdetails srd,
       billing.vwr_servicetype           srt
 where psm.statusid = ipm.status
   and ad.admissionno = ipm.admissionno
   and BM.BEDID = IPM.BEDID
   and LD.LEVELDETAILID = BM.LEVELDETAILID
   and LD1.LEVELDETAILID = LD.PARENTLEVELID
   AND ld1.levelno = 6
   and sr.patientidentifierno = ipm.inpatientno
   and srd.requestid = sr.requestid
   and srt.servicetypeid = srd.servicetypeid
   and ipm.activestatus =1
   AND (ipm.Dateofadmission::date) BETWEEN (current_date - 13) AND
       (current_date)

union all

SELECT ipm.Inpatientno,
       ipm.uhid,
       to_char(ipm.Dateofadmission, 'DD-MON-YYYY') AS ADMISSIONDATE,
       psm.statusname,
       to_char(ad.dischargeinitiateddatetime, 'DD-MON-YYYY') AS
dischargedate,
       BM.Bedid,
       LD.LEVELDETAILNAME AS ROOM,
       LD1.LEVELDETAILNAME AS WARD,
       osrd.itemid,
       osrd.ITEMNAME as CONSUMABLE,
       srt.servicetypename as servicetypename,
       osrd.createddate
  FROM adt.inpatientmaster                ipm,
       adt.patientstatusmaster            psm,
       wards.admissiondetails             ad,
       adt.BEDMASTER                      BM,
       adt.LEVELDETAIL                    LD,
       adt.LEVELDETAIL                    LD1,
       Billing.Servicerequest             sr,
       billing.otherservicerequestdetails osrd,
       billing.vwr_servicetype                srt
 where psm.statusid = ipm.status
   and ad.admissionno = ipm.admissionno
   and BM.BEDID = IPM.BEDID
   and LD.LEVELDETAILID = BM.LEVELDETAILID
   and LD1.LEVELDETAILID = LD.PARENTLEVELID
   AND ld1.levelno = 6
   and sr.patientidentifierno = ipm.inpatientno
   and osrd.requestid = sr.requestid
   and srt.servicetypeid = osrd.servicetypeid
   and osrd.servicetypeid in (181, 182, 183)
   and osrd.SERVICESTATUS <> 'CANCELLED'
   and ipm.activestatus =1
   AND (ipm.Dateofadmission::date) BETWEEN (current_date - 13) AND
       (current_date)

union all

  SELECT ipm.Inpatientno,
       ipm.uhid,
       to_char(ipm.Dateofadmission, 'DD-MON-YYYY') AS ADMISSIONDATE,
       psm.statusname,
       to_char(ad.dischargeinitiateddatetime, 'DD-MON-YYYY') AS
dischargedate,
       BM.Bedid,
       LD.LEVELDETAILNAME AS ROOM,
       LD1.LEVELDETAILNAME AS WARD,
       osrd.itemid,
       osrd.ITEMNAME as Pharmacy,
       srt.servicetypename as servicetypename,
       osrd.createddate
  FROM adt.inpatientmaster                ipm,
       adt.patientstatusmaster            psm,
       wards.admissiondetails             ad,
       adt.BEDMASTER                      BM,
       adt.LEVELDETAIL                    LD,
       adt.LEVELDETAIL                    LD1,
       Billing.Servicerequest             sr,
       billing.otherservicerequestdetails osrd,
       billing.vwr_servicetype                srt
 where psm.statusid = ipm.status
   and ad.admissionno = ipm.admissionno
   and BM.BEDID = IPM.BEDID
   and LD.LEVELDETAILID = BM.LEVELDETAILID
   and LD1.LEVELDETAILID = LD.PARENTLEVELID
   AND ld1.levelno = 6
   and sr.patientidentifierno = ipm.inpatientno
   and osrd.requestid = sr.requestid
   and srt.servicetypeid = osrd.servicetypeid
   and osrd.servicetypeid in (300, 301, 302, 303)
   and osrd.SERVICESTATUS <> 'CANCELLED'
   and ipm.activestatus = 1
   AND (ipm.Dateofadmission::date) BETWEEN (current_date - 13) AND
       (current_date);

CREATE OR REPLACE VIEW BILLING.LOCATIONMASTER
(CHARTID,LEVELDETAILNAME)
AS
select c.chartid, c.leveldetailname
  from ehis.vwr_coa_struct_details c
 where c.parentid = '10200';

CREATE OR REPLACE VIEW BILLING.PACKAGEAPPLICABILITY
(PACKAGEID,GENDERID,FROMAGE,TOAGE)
AS
SELECT
SERVICEID packageid,
GENDERID genderid,
FROMAGE fromage,
TOAGE toage
FROM BILLING.VW_GENDER
ORDER BY SERVICEID;

CREATE OR REPLACE VIEW BILLING.PACKAGECONSULTATION
(PACKAGEID,CONSULTATIONID,CONSULTATIONCODE,CONSULTATIONNAME,LOCATIONID,STATUS,DEPARTMENTID,SUBDEPARTMENTID,SERVICETYPEID)
AS
SELECT
PD.PACKAGEID PACKAGEID,
PD.SERVICEID CONSULTATIONID,
sm.SERVICECode CONSULTATIONCode,
sm.SERVICEName CONSULTATIONName,
sm.locationid LocationID,
(case upper(sm.servicestatus) when 'ACTIVE' THEN 1 when 'INACTIVE' then 0 end) STATUS,
sm.deptid DepartmentID,
sm.subdeptid SubDepartmentID,
sm.servicetypeid ServiceTypeID
FROM
BILLING.VW_PACKAGEITEMINCLUSIONDETAILS PD
LEFT OUTER JOIN BILLING.VW_SERVICEMASTER SM ON SM.Serviceid=PD.serviceid AND SM.LOCATIONID=PD.LOCATIONID
LEFT OUTER JOIN billing.vwr_servicetype ST ON ST.Servicetypeid=sm.Servicetypeid
WHERE UPPER(ST.SERVICETYPENAME)='CONSULTATION' or UPPER(ST.SERVICETYPENAME)='FOOD AND BEVERAGES'
  or upper(st.servicetypename) ='PROFILE' or upper(st.servicetypename)='ROUTINE MEDICAL CHECKUP'
  or sm.serviceid in(2125)
   or upper(st.servicetypename) ='PHYSIOTHERAPY'
  --or sm.serviceid in(1515)
  and st.servicetypeid in(141,142,11,345,2)
ORDER BY PD.PACKAGEID;

CREATE OR REPLACE VIEW BILLING.PACKAGEMASTER
(PACKAGESERVICETIME,APPLICABLETOAGEGROUPFROM,APPLICABLETOAGEGROUPTO,APPLICABLEORGANIZATIONS,STARTDATE,EXPIRYDATE,FROMDATE,TODATE,ACTUALCOST,DISCOUNT,PACKAGECATEGORYID,APPROVALDOCUMENT,CONFIRMATIONFROMCRM,PATIENTEDUCATIONMATERIALFILENA,PATIENTEDUCATIONMATERIALFILETY,PATIENTEDUCATIONMATERIALFILEPA,LOCATIONID,PACKAGESTATUSID,REASONFORACTIVATION,REASONFORDEACTIVATION,STATUS,PACKAGEID,PACKAGECODE,PACKAGENAME,PACKAGEDESCRIPTION,PACKAGEAMOUNT,AMOUNTCURRENCY,BREAKFASTNEEDED,PACKAGETYPE,APPLICABLETOGENDER,SERVICETYPEID,SERVICETYPENAME,TOTALCOST,DEPTID)
AS
select
0 PACKAGESERVICETIME,
0 APPLICABLETOAGEGROUPFROM,
0 APPLICABLETOAGEGROUPTO,
'' APPLICABLEORGANIZATIONS,
sm.effectivefrom STARTDATE,
sm.effectiveto EXPIRYDATE,
NULL FROMDATE,
NULL TODATE,
0 ACTUALCOST,
0 DISCOUNT,
--1000 TOTALCOST,
NULL PACKAGECATEGORYID,
NULL APPROVALDOCUMENT,
NULL CONFIRMATIONFROMCRM,
NULL PATIENTEDUCATIONMATERIALFILENA,
NULL PATIENTEDUCATIONMATERIALFILETY,
NULL PATIENTEDUCATIONMATERIALFILEPA,
sm.locationid LOCATIONID,
NULL PACKAGESTATUSID,
NULL REASONFORACTIVATION,
NULL REASONFORDEACTIVATION,
(case upper(sm.servicestatus) when 'ACTIVE' then 1 when 'INACTIVE' then 0 end) STATUS,
sm.serviceid PACKAGEID,
sm.servicecode PACKAGECODE,
sm.servicename PACKAGENAME,
sm.servicedescription PACKAGEDESCRIPTION,
--NTD.FINALTariff PACKAGEAMOUNT,
1000 PACKAGEAMOUNT,
NULL AMOUNTCURRENCY,
NULL BREAKFASTNEEDED,
lov.lovdetaildescription PACKAGETYPE,
NULL APPLICABLETOGENDER,
sm.servicetypeid ServiceTypeID,
st.servicetypename ServiceTypeName,
1000 TOTALCOST,
sm.deptid Deptid
--NTD.FINALTariff TOTALCOST
from BILLING.vw_servicemaster sm
left Outer Join billing.vwr_servicetype st on sm.servicetypeid=st.servicetypeid
left Outer Join billing.vwr_lovdetail lov On Lov.Lovdetailid=sm.packagetypeid
--Left Outer Join BILLING.newtemplatetariffDetails Ntd On sm.serviceid=ntd.ServiceId
where st.servicetypeid in (141,142);

CREATE OR REPLACE VIEW BILLING.PACKAGETEST
(PACKAGEID,TESTID,TESTCODE,TESTNAME,LOCATIONID,ALTERNATETESTID,ALTERNATETESTCODE,ALTERNATETESTNAME,STATUS,DEPARTMENTID,SUBDEPARTMENTID,SERVICETYPEID)
AS
SELECT
PD.PACKAGEID PACKAGEID,
PD.SERVICEID TESTID,
sm.SERVICECode TESTCode,
sm.SERVICEName TESTName,
sm.locationid LocationID,
pd.subsituteitemid AlternateTestID,
sm1.servicecode AlternateTestCode,
sm1.servicename AlternateTestName,
(case upper(sm.servicestatus) when 'ACTIVE' THEN 1 when 'INACTIVE' then 0 end) STATUS,
sm.deptid DepartmentID,
sm.subdeptid SubDepartmentID,
sm.servicetypeid ServiceTypeID
FROM
BILLING.VW_PACKAGEITEMINCLUSIONDETAILS PD
LEFT OUTER JOIN BILLING.VW_SERVICEMASTER SM ON SM.Serviceid=PD.serviceid AND SM.LOCATIONID=PD.LOCATIONID
LEFT OUTER JOIN BILLING.VW_SERVICEMASTER SM1 ON SM1.Serviceid=PD.Subsituteitemid AND SM1.LOCATIONID=PD.LOCATIONID
LEFT OUTER JOIN billing.vwr_servicetype ST ON ST.Servicetypeid=sm.Servicetypeid
WHERE UPPER(ST.SERVICETYPENAME)='INVESTIGATION' OR UPPER(ST.SERVICETYPENAME)='INVESTIGATIVE PROCEDURE'
ORDER BY PD.PACKAGEID;

CREATE OR REPLACE VIEW BILLING.PATIENTCONDITONAPPLICABIL_NW
(PATIENTCONDTIONAPPLICABILITYID,SERVICEID,LOCATIONID,APPLICABILITYID,VERSIONNO,CREATEDBY,CREATEDDATE,UPDATEDBY,UPDATEDDATE,PATIENTCONDITION)
AS
SELECT PATIENTCONDTIONAPPLICABILITYID,SERVICEID,LOCATIONID,APPLICABILITYID,VERSIONNO,CREATEDBY,CREATEDDATE,UPDATEDBY,UPDATEDDATE,PATIENTCONDITION FROM BILLING.VW_PATIENTCONDITONAPPLICABILITY PATIENTCONDITONAPPLICABILITY
where PATIENTCONDITONAPPLICABILITY.LOCATIONID IN(select l.LocationID from securitytest_64.locationmaster l
                                                );

CREATE OR REPLACE VIEW BILLING.SERVICEAPPLICABILITY_NEW
(SERVICEAPPLICABILITYID,APPLICABILITYID,SERVICECODE,SERVICEID,LOCATIONID,CREATEDBY,CREATEDDATE,UPDATEDBY,UPDATEDDATE)
AS
SELECT SERVICEAPPLICABILITYID,APPLICABILITYID,SERVICECODE,SERVICEID,LOCATIONID,CREATEDBY,CREATEDDATE,UPDATEDBY,UPDATEDDATE FROM BILLING.VW_SERVICEAPPLICABILITY SERVICEAPPLICABILITY
WHERE SERVICEAPPLICABILITY.LOCATIONID IN(select l.LocationID from securitytest_64.locationmaster l
                                         );

CREATE OR REPLACE VIEW BILLING.SERVICEMASTER_NEW
(SERVICEID,SERVICECODE,SERVICENAME,SERVICEDESCRIPTION,SERVICETYPEID,SERVICECATEGORYID,DEPTID,SUBDEPTID,BASEDON,SCHUDELABLE,RESOURESREQUIRED,EFFECTIVEFROM,EFFECTIVETO,RESTORABLE,SERVICESTATUS,UOMID,SERVICEMODEL,SERVICEPROVIDERTYPE,SERVICEPROVIDERNAME,PARTNERDESCRIPTION,DEPOSITEAPPLICABLE,APPROVALREQUIREDFORBUFFER,PEMREQUIRED,CONSENTREQUIRED,COSTDEFINITIONID,FINANCIALVERSIONNO,NONFINANCIALVERSIONNO,BILLABLE,NATUREOFBILLING,BILLABLETYPE,DISCOUNTABLE,DEPOSITEAMOUNT,DEPOSITEPERCENTAGE,REFUNDABLE,REFUNDPERIOD,REFUNDAMOUNT,REFUNDPERCENT,AUTHORIZATIONREQUIRED,TAXABLE,VERSIONNO,EQUIPMENT,CLINICAL,AVAILABLEONINTERNET,FACILITY,MAXDISCOUNTPERCENT,HIGHVALUESERVICES,DISCOUNTLIMIT,DISCOUNTDESCRIPTION,DISCOUNTAPPLICABLE,EPISODECOUNT,DEPOSITTARIFFAMOUNT,DEPOSITTARIFFPERCENTAGE,NONFINANCIALVERSIONCONTROL,TOTALBASEPRICE,DEPENDENTSERVICE,CHILD,DATACENTERFLAG,COMPANYID,LOCATIONID,UPDATEDBY,UPDATEDATE,CREATEDDATE,CREATEDBY,PREREQUISITEREQUIRED,PATIENTTYPEID,ISCOMPOSITESERVICE,DISCOUNTTYPE,DEPOSITETYPE,MATERIAL,ADJUSTABLEAMOUNT,STARTBEFORE,MAXNOOFDAYS,PACKAGETYPEID,ISPACKAGEDEFINED,VISIBLE,GRACEPERIOD,CODIFICATIONREQUIRED,GENDERAPPLICABILITY,ITEMCODE,REFUNDTYPE,REFUNDPERIODTYPE,ISNONAPOLLOSERVICE,SERVICEALIAS,ISFREQUENTLYUSED,ISEDITABLE)
AS
SELECT SERVICEMASTER.SERVICEID                  SERVICEID,
       SERVICEMASTER.SERVICECODE                SERVICECODE,
       SERVICEMASTER.SERVICENAME                SERVICENAME,
       SERVICEMASTER.SERVICEDESCRIPTION         SERVICEDESCRIPTION,
       SERVICEMASTER.SERVICETYPEID              SERVICETYPEID,
       SERVICEMASTER.SERVICECATEGORYID          SERVICECATEGORYID,
       SERVICEMASTER.DEPTID                     DEPTID,
       SERVICEMASTER.SUBDEPTID                  SUBDEPTID,
       SERVICEMASTER.BASEDON                    BASEDON,
       SERVICEMASTER.SCHUDELABLE                SCHUDELABLE,
       SERVICEMASTER.RESOURESREQUIRED           RESOURESREQUIRED,
       SERVICEMASTER.EFFECTIVEFROM              EFFECTIVEFROM,
       SERVICEMASTER.EFFECTIVETO                EFFECTIVETO,
       SERVICEMASTER.RESTORABLE                 RESTORABLE,
       SERVICEMASTER.SERVICESTATUS              SERVICESTATUS,
       SERVICEMASTER.UOMID                      UOMID,
       SERVICEMASTER.SERVICEMODEL               SERVICEMODEL,
       SERVICEMASTER.SERVICEPROVIDERTYPE        SERVICEPROVIDERTYPE,
       SERVICEMASTER.SERVICEPROVIDERNAME        SERVICEPROVIDERNAME,
       SERVICEMASTER.PARTNERDESCRIPTION         PARTNERDESCRIPTION,
       SERVICEMASTER.DEPOSITEAPPLICABLE         DEPOSITEAPPLICABLE,
       SERVICEMASTER.APPROVALREQUIREDFORBUFFER  APPROVALREQUIREDFORBUFFER,
       SERVICEMASTER.PEMREQUIRED                PEMREQUIRED,
       SERVICEMASTER.CONSENTREQUIRED            CONSENTREQUIRED,
       SERVICEMASTER.COSTDEFINITIONID           COSTDEFINITIONID,
       SERVICEMASTER.FINANCIALVERSIONNO         FINANCIALVERSIONNO,
       SERVICEMASTER.NONFINANCIALVERSIONNO      NONFINANCIALVERSIONNO,
       SERVICEMASTER.BILLABLE                   BILLABLE,
       SERVICEMASTER.NATUREOFBILLING            NATUREOFBILLING,
       SERVICEMASTER.BILLABLETYPE               BILLABLETYPE,
       SERVICEMASTER.DISCOUNTABLE               DISCOUNTABLE,
       SERVICEMASTER.DEPOSITEAMOUNT             DEPOSITEAMOUNT,
       SERVICEMASTER.DEPOSITEPERCENTAGE         DEPOSITEPERCENTAGE,
       SERVICEMASTER.REFUNDABLE                 REFUNDABLE,
       SERVICEMASTER.REFUNDPERIOD               REFUNDPERIOD,
       SERVICEMASTER.REFUNDAMOUNT               REFUNDAMOUNT,
       SERVICEMASTER.REFUNDPERCENT              REFUNDPERCENT,
       SERVICEMASTER.AUTHORIZATIONREQUIRED      AUTHORIZATIONREQUIRED,
       SERVICEMASTER.TAXABLE                    TAXABLE,
       SERVICEMASTER.VERSIONNO                  VERSIONNO,
       SERVICEMASTER.EQUIPMENT                  EQUIPMENT,
       SERVICEMASTER.CLINICAL                   CLINICAL,
       SERVICEMASTER.AVAILABLEONINTERNET        AVAILABLEONINTERNET,
       SERVICEMASTER.FACILITY                   FACILITY,
       SERVICEMASTER.MAXDISCOUNTPERCENT         MAXDISCOUNTPERCENT,
       SERVICEMASTER.HIGHVALUESERVICES          HIGHVALUESERVICES,
       SERVICEMASTER.DISCOUNTLIMIT              DISCOUNTLIMIT,
       SERVICEMASTER.DISCOUNTDESCRIPTION        DISCOUNTDESCRIPTION,
       SERVICEMASTER.DISCOUNTAPPLICABLE         DISCOUNTAPPLICABLE,
       SERVICEMASTER.EPISODECOUNT               EPISODECOUNT,
       SERVICEMASTER.DEPOSITTARIFFAMOUNT        DEPOSITTARIFFAMOUNT,
       SERVICEMASTER.DEPOSITTARIFFPERCENTAGE    DEPOSITTARIFFPERCENTAGE,
       SERVICEMASTER.NONFINANCIALVERSIONCONTROL NONFINANCIALVERSIONCONTROL,
       SERVICEMASTER.TOTALBASEPRICE             TOTALBASEPRICE,
       SERVICEMASTER.DEPENDENTSERVICE           DEPENDENTSERVICE,
       SERVICEMASTER.CHILD                      CHILD,
       SERVICEMASTER.DATACENTERFLAG             DATACENTERFLAG,
       SERVICEMASTER.COMPANYID                  COMPANYID,
       SERVICEMASTER.LOCATIONID                 LOCATIONID,
       SERVICEMASTER.UPDATEDBY                  UPDATEDBY,
       SERVICEMASTER.UPDATEDATE                 UPDATEDATE,
       SERVICEMASTER.CREATEDDATE                CREATEDDATE,
       SERVICEMASTER.CREATEDBY                  CREATEDBY,
       SERVICEMASTER.PREREQUISITEREQUIRED       PREREQUISITEREQUIRED,
       SERVICEMASTER.PATIENTTYPEID              PATIENTTYPEID,
       SERVICEMASTER.ISCOMPOSITESERVICE         ISCOMPOSITESERVICE,
       SERVICEMASTER.DISCOUNTTYPE               DISCOUNTTYPE,
       SERVICEMASTER.DEPOSITETYPE               DEPOSITETYPE,
       SERVICEMASTER.MATERIAL                   MATERIAL,
       SERVICEMASTER.ADJUSTABLEAMOUNT           ADJUSTABLEAMOUNT,
       SERVICEMASTER.STARTBEFORE                STARTBEFORE,
       SERVICEMASTER.MAXNOOFDAYS                MAXNOOFDAYS,
       SERVICEMASTER.PACKAGETYPEID              PACKAGETYPEID,
       SERVICEMASTER.ISPACKAGEDEFINED           ISPACKAGEDEFINED,
       SERVICEMASTER.VISIBLE                    VISIBLE,
       SERVICEMASTER.GRACEPERIOD                GRACEPERIOD,
       SERVICEMASTER.CODIFICATIONREQUIRED       CODIFICATIONREQUIRED,
       SERVICEMASTER.GENDERAPPLICABILITY        GENDERAPPLICABILITY,
       SERVICEMASTER.ITEMCODE                   ITEMCODE,
       SERVICEMASTER.REFUNDTYPE                 REFUNDTYPE,
       SERVICEMASTER.REFUNDPERIODTYPE           REFUNDPERIODTYPE,
       SERVICEMASTER.ISNONAPOLLOSERVICE         ISNONAPOLLOSERVICE,
       SERVICEMASTER.SERVICEALIAS               SERVICEALIAS,
       SERVICEMASTER.ISFREQUENTLYUSED           ISFREQUENTLYUSED,
       SERVICEMASTER.ISEDITABLE                 ISEDITABLE
  FROM BILLING.VW_SERVICEMASTER SERVICEMASTER
  WHERE SERVICEMASTER.Locationid IN(select l.LocationID from securitytest_64.locationmaster l
                                    );

CREATE OR REPLACE VIEW BILLING.USERMASTER
(USERID,EMPLOYEEID,EMPLOYEECODE,TITLEID,FIRSTNAME,MIDDLENAME,LASTNAME,GENDERID,DOB,MARITALSTATUSID,BIRTHCOUNTRYID,NATIONALITYID,PHYSICALLYHANDICAPPED,SUPERVISORID,COMPANYID,LOCATIONID,DEPARTMENTID,COSTCENTERID,MAINCOSTCENTERID,PAYROLLACCOUNTINGAREAID,EMPLOYEELEVELID,EMPLOYEECATEGORYID,EMPLOYEETYPEID,DESIGNATIONID,GRADEID,LAST_SALARY,ADDRESS_TYPE,EMPLOYMENTSTATUSID,STATUS,CREATEDBY,CREATEDDATE,UPDATEDBY,UPDATEDDATE,FLEXIFIELD1,FLEXIFIELD2,PRESENTEMPLOYEEID,LOGINID,SPECIALITYID,EMAILID,CALENDARPRIVILEGES,SCHEDULABLE,SPECIALIZEDSERVICES)
AS
select EMPLOYEEID as USERID,EMPLOYEEID,EMPLOYEECODE,TITLEID,FIRSTNAME,MIDDLENAME,LASTNAME,
GENDERID,DOB,MARITALSTATUSID,BIRTHCOUNTRYID,NATIONALITYID,PHYSICALLYHANDICAPPED,
SUPERVISORID,COMPANYID,LOCATIONID,DEPARTMENTID,COSTCENTERID,MAINCOSTCENTERID,
PAYROLLACCOUNTINGAREAID,EMPLOYEELEVELID,EMPLOYEECATEGORYID,EMPLOYEETYPEID,
DESIGNATIONID,GRADEID,LAST_SALARY,ADDRESS_TYPE,EMPLOYMENTSTATUSID,
STATUS,CREATEDBY,CREATEDDATE,UPDATEDBY,UPDATEDDATE,FLEXIFIELD1,
FLEXIFIELD2,PRESENTEMPLOYEEID,LOGINID,SPECIALITYID,EMAILID,
CALENDARPRIVILEGES,SCHEDULABLE,SPECIALIZEDSERVICES from hr.mv_employee_main_details;

CREATE OR REPLACE VIEW CRM.EMPLOYEES
(EMPLOYEEID,FIRSTNAME,LASTNAME,DEPARTMENTID)
AS
SELECt EMp.Employeeid,EMP.Firstname ,EMP.Lastname , EMP.Departmentid
FROM HR.mv_Employee_Main_Details EMP;

CREATE OR REPLACE VIEW EHIS.CONSUMABLES
(CONSUMABLEID,CONSUMABLENAME,CONSUMABLECODE,STATUS,UPDATEDDATE)
AS
SELECt SEQNUMBER as CONSUMABLEID,ITEMSHORTDESC as CONSUMABLENAME,ITEMCODE AS CONSUMABLECODE,1 AS STATUS,CREATIONDATE AS UPDATEDDATE
FROM pharmacy.vwr_itemcompany IC
where itemtype=2
and itemcategory in (10,11)
and itemsubcategory1 in (746,784,783,23,110,116,124,128,125)
and IC.Itemshortdesc is not null;

create or replace  view EHIS.ITEMCOMPANY_PHARMA 
as
SELECT ITEMCOMPANY.ISCONSIGNMENTITEM   ISCONSIGNMENTITEM,
       ITEMCOMPANY.VARIANTALLOWED      VARIANTALLOWED,
       ITEMCOMPANY.ISHAZARDOUS         ISHAZARDOUS,
       ITEMCOMPANY.ISINCLUSEDINCOSTING ISINCLUSEDINCOSTING,
       ITEMCOMPANY.VEDANALYSIS         VEDANALYSIS,
       ITEMCOMPANY.ITEMCLASSIFICATION  ITEMCLASSIFICATION,
       ITEMCOMPANY.ITEMCATEGORY        ITEMCATEGORY,
       ITEMCOMPANY.ITEMSUBCATEGORY1    ITEMSUBCATEGORY1,
       ITEMCOMPANY.ITEMSUBCATEGORY2    ITEMSUBCATEGORY2,
       ITEMCOMPANY.ITEMSUBCATEGORY3    ITEMSUBCATEGORY3,
       ITEMCOMPANY.ITEMSTORAGETYPE     ITEMSTORAGETYPE,
       ITEMCOMPANY.UNITWEIGHT          UNITWEIGHT,
       ITEMCOMPANY.WEIGHTUOM           WEIGHTUOM,
       ITEMCOMPANY.UNITVOLUME          UNITVOLUME,
       ITEMCOMPANY.VOLUMEUOM           VOLUMEUOM,
       ITEMCOMPANY.LOOKUPID            LOOKUPID,
       ITEMCOMPANY.SEQNUMBER           SEQNUMBER,
       ITEMCOMPANY.ITEMTYPE            ITEMTYPE,
       ITEMCOMPANY.ITEMCODE            ITEMCODE,
       ITEMCOMPANY.ITEMSHORTDESC       ITEMSHORTDESC,
       ITEMCOMPANY.ITEMLONGDESC        ITEMLONGDESC,
       ITEMCOMPANY.FLEXIFIELD1         FLEXIFIELD1,
       ITEMCOMPANY.FLEXIFIELD2         FLEXIFIELD2,
       ITEMCOMPANY.FLEXIFIELD3         FLEXIFIELD3,
       ITEMCOMPANY.FLEXIFIELD4         FLEXIFIELD4,
       ITEMCOMPANY.FLEXIFIELD5         FLEXIFIELD5,
       ITEMCOMPANY.BARCODE             BARCODE,
       ITEMCOMPANY.BIS                 BIS,
       ITEMCOMPANY.LEGACYITEMCODE      LEGACYITEMCODE,
       ITEMCOMPANY.REUSABLEITEM        REUSABLEITEM,
       ITEMCOMPANY.CREATIONDATE        CREATIONDATE,
       ITEMCOMPANY.ITEMDESCNEW         ITEMDESCNEW,
       ITEMCOMPANY.ITEMBRIEFDESC       ITEMBRIEFDESC,
       ITEMCOMPANY.GENERICNAME         GENERICNAME
  FROM pharmacy.vwr_itemcompany itemcompany;

CREATE OR REPLACE VIEW EHIS.MEDICINES
(MEDICINEID,MEDICINENAME,MEDICINECODE,STATUS,UPDATEDDATE)
AS
SELECT SEQNUMBER as MEDICINEID,ITEMSHORTDESC as MEDICINENAME,ITEMCODE AS MEDICINECODE,1 as STATUS,CREATIONDATE AS UPDATEDDATE
FROM EHIS.ITEMCOMPANY_PHARMA IP
where 
( (Current_database() IN ('ehisblr', 'ahsag', 'ehischn', 'ahdel', 'ehishyd', 'ehisaghl', 'ehismum','ehisnsk')) AND 
  (itemtype=3
and itemcategory in (2,16,27,28)
and itemsubcategory1 in (23,59,67,68,83,87)
and IP.Itemshortdesc is not null ) )
OR ( (Current_database() = 'ehisbbs') AND
     (IP.ITEMSHORTDESC LIKE '%DISPRIN%' OR IP.ITEMSHORTDESC LIKE'%SORBITRATE%' OR
      IP.ITEMSHORTDESC LIKE '%ATROPINE%' OR IP.ITEMSHORTDESC LIKE '%ADRENALINE%' OR
      IP.ITEMSHORTDESC LIKE '%CORDARONE%' OR IP.ITEMSHORTDESC LIKE '%BETADINE%' OR
      IP.ITEMSHORTDESC LIKE '%NEOSPORIN%' OR IP.ITEMSHORTDESC LIKE '%VOVERAN%' OR
      IP.ITEMSHORTDESC LIKE '%ZOFER%' OR IP.ITEMSHORTDESC LIKE '%DUOLIN%' OR
      IP.ITEMSHORTDESC LIKE '%ASTHALIN%' OR IP.ITEMSHORTDESC LIKE '%SILVEREX%'
      OR IP.ITEMCODE IN('O230001','O2T0001','DOP0002','DOB0011','HYD0009','DEC0013','ADR0010','ATR0009','NIT0017',
      'HYD0009','XYL0012','LAS0002','RAN0009','MAN0009')
      ) )
order by ITEMSHORTDESC;

CREATE OR REPLACE VIEW EHIS.PATIENT
(REGISTRATIONID,PREREGISTRATIONNO,EMERGENCYNO,UHID,LOCATIONID,CORPORATEEMPLOYEEID,CORPORATEID,REFFERALDOCTORID,REFFERALENTITYID,EMPLOYEEID,RECRUITMENTID,EMPLOYEEREFERRALID,RELATIONSHIPCODE,CAMPID,CAMPNAME,CAMPTYPE,CAMPREGISTRATIONID,BATCHID,TITLE,FIRSTNAME,MIDDLENAME,LASTNAME,SUFIX,EDUCATIONALQUALIFICATION,OTHERDEGREE,BIRTHDATE,BIRTHTIME,FATHERNAME,SPOUSENAME,MOTHERMAIDENNAME,GAURDIANNAME,BIRTHPLACE,APPROXIMATE,AGE,AGETYPE,AGECATEGORY,GENDER,MARITALSTATUS,RELIGION,RACE,ETHNICGROUP,EMPLOYMENTSTATUS,MONTHLYINCOME,PRIMARYLANGUAGE,TRANSLATORREQUIRED,TRANSLATORNAME,CITIZENSHIP,LITERATE,FINANCIALSTATUS,EMOTIONALBARRIERS,PATIENTTYPE,DISABILITY,DISABLEDPERSONCODE,DISABLEDPERSONIDENTIFIER,IDENTIFICATIONMARK1,IDENTIFICATIONMARK2,SOCIALSECURITYNUMBER,POSSESSPASSPORT,DIABETIC,ALLERGIC,BLOODGROUP,RHFACTOR,DONOR,DONORTYPE,ORGANTYPE,DONORCODE,PAYMENTFORREGISTRATION,PAYMENTCURRENCY,PAYMENTMETHOD,REFERENCENO,CREATEDBY,CREATEDDATE,HOWDOYOUCOMETOKNOWABOUTUS,PREFERREDMODEOFCONTACT,WANTALERTSONHOSPITALPROMOTIONS,FILETYPE,STATUS,BUSINESS,PREFERREDLOCATION,PRIVACYSTATUS,CUSTOMERSTATUS,ALIASNAME,STARTDATE,ENDDATE,NOOFISSUES,UPDATEDBY,UPDATEDDATE,FLEXIFIELD1,FLEXIFIELD2,FLEXIFIELD3,FLEXIFIELD4,FILENAME,FILEPATH,EMAILID,CANCELLATIONDATE,REASONFORCANCELLATION,BABYOF,REASONFORREISSUE,COUNTERNO,SHIFTNO,DRAFT,TEMPDRAFTID,ISMLCCASE,MLCCASENO,ISHYPERTENSION,HAVECOMMUNICABLEDISEASE,PATIENTPREFERENCE,FOODPREFERENCE,DIABETICTYPE,DEATHDATETIME,EMPLOYEERELATION,EVENTID,EVENTNAME,EVENTTYPE,CURRENTSTATUS,LASTTRANSACTION,REASONFORFREE,OLDUHID,REFERRALPATIENTUHID,MOTHERSUHID)
AS
select REGISTRATIONID,PREREGISTRATIONNO,EMERGENCYNO,UHID,LOCATIONID,CORPORATEEMPLOYEEID,CORPORATEID,REFFERALDOCTORID,REFFERALENTITYID,EMPLOYEEID,RECRUITMENTID,EMPLOYEEREFERRALID,RELATIONSHIPCODE,CAMPID,CAMPNAME,CAMPTYPE,CAMPREGISTRATIONID,BATCHID,TITLE,FIRSTNAME,MIDDLENAME,LASTNAME,SUFIX,EDUCATIONALQUALIFICATION,OTHERDEGREE,BIRTHDATE,BIRTHTIME,FATHERNAME,SPOUSENAME,MOTHERMAIDENNAME,GAURDIANNAME,BIRTHPLACE,APPROXIMATE,AGE,AGETYPE,AGECATEGORY,GENDER,MARITALSTATUS,RELIGION,RACE,ETHNICGROUP,EMPLOYMENTSTATUS,MONTHLYINCOME,PRIMARYLANGUAGE,TRANSLATORREQUIRED,TRANSLATORNAME,CITIZENSHIP,LITERATE,FINANCIALSTATUS,EMOTIONALBARRIERS,PATIENTTYPE,DISABILITY,DISABLEDPERSONCODE,DISABLEDPERSONIDENTIFIER,IDENTIFICATIONMARK1,IDENTIFICATIONMARK2,SOCIALSECURITYNUMBER,POSSESSPASSPORT,DIABETIC,ALLERGIC,BLOODGROUP,RHFACTOR,DONOR,DONORTYPE,ORGANTYPE,DONORCODE,PAYMENTFORREGISTRATION,PAYMENTCURRENCY,PAYMENTMETHOD,REFERENCENO,CREATEDBY,CREATEDDATE,HOWDOYOUCOMETOKNOWABOUTUS,PREFERREDMODEOFCONTACT,WANTALERTSONHOSPITALPROMOTIONS,FILETYPE,STATUS,BUSINESS,PREFERREDLOCATION,PRIVACYSTATUS,CUSTOMERSTATUS,ALIASNAME,STARTDATE,ENDDATE,NOOFISSUES,UPDATEDBY,UPDATEDDATE,FLEXIFIELD1,FLEXIFIELD2,FLEXIFIELD3,FLEXIFIELD4,FILENAME,FILEPATH,EMAILID,CANCELLATIONDATE,REASONFORCANCELLATION,BABYOF,REASONFORREISSUE,COUNTERNO,SHIFTNO,DRAFT,TEMPDRAFTID,ISMLCCASE,MLCCASENO,ISHYPERTENSION,HAVECOMMUNICABLEDISEASE,PATIENTPREFERENCE,FOODPREFERENCE,DIABETICTYPE,DEATHDATETIME,EMPLOYEERELATION,EVENTID,EVENTNAME,EVENTTYPE,CURRENTSTATUS,LASTTRANSACTION,REASONFORFREE,OLDUHID,REFERRALPATIENTUHID,MOTHERSUHID
    from registration.patient;

CREATE OR REPLACE VIEW EHIS.VW_HCMLOCATION
(CHARTID,LEVELDETAILNAME,HCM_VALUE)
AS
SELECT CHARTID,LEVELDETAILNAME,HCM_VALUE
 FROM ehis.vwr_coa_struct_details  WHERE LEVELMASTERID=3865;

CREATE OR REPLACE VIEW FB.FB_MV_DIETSERVINGDETAIL
(DIETSERVINGID,DIETSLIPID,SERVICETIMEID,SERVICEDATE,FOODITEMCATEGORY,TOTALBILL,STATUS,CREATEDDATE,CREATEDBY,UPDATEDBY,UPDATEDDATE,DIETSLIPNO,DISPATCHED,FNBSERVICEID,ACKNOWLEDGED,ACKNOWLEDGEDDATE,ACKNOWLEDGEDBY,TYPEOFDIET,ORDERTYPE,PROCESSFLOWTRANSID,CONSUMPTIONDECLARATION)
AS
select DIETSERVINGID,DIETSLIPID,SERVICETIMEID,SERVICEDATE,FOODITEMCATEGORY,TOTALBILL,STATUS,CREATEDDATE,CREATEDBY,UPDATEDBY,UPDATEDDATE,DIETSLIPNO,DISPATCHED,FNBSERVICEID,ACKNOWLEDGED,ACKNOWLEDGEDDATE,ACKNOWLEDGEDBY,TYPEOFDIET,ORDERTYPE,PROCESSFLOWTRANSID,CONSUMPTIONDECLARATION
from fb.fb_dietservingdetail dsd
where dsd.status =1 and dsd.servicedate::date >= current_date;

CREATE OR REPLACE VIEW FB.FB_MV_DIETSLIP
(DIETSLIPID,DIETPREPARATIONID,UHID,SERVICENO,PATIENTNAME,AGE,GENDERID,LOCATIONID,BUILDINGID,BLOCKID,FLOORID,BEDCATEGORY,WARDNAME,ROOMNO,BEDNUMBER,DIABETIC,CONSULTANTNAME,PATIENTTYPE,STARTTIME,ENDTIME,STATUS,CREATEDDATE,CREATEDBY,UPDATEDBY,UPDATEDDATE,REQUESTTYPE,LOCATION,RELEASESTATUS,MEALTYPEID,DIETTYPEID,DIETINITIATIONID,DIETINFOONIPDISCHARGE,BEDCODE)
AS
select ds.DIETSLIPID,ds.DIETPREPARATIONID,ds.UHID,ds.SERVICENO,ds.PATIENTNAME,ds.AGE,ds.GENDERID,ds.LOCATIONID,ds.BUILDINGID,ds.BLOCKID,ds.FLOORID,ds.BEDCATEGORY,ds.WARDNAME,ds.ROOMNO,ds.BEDNUMBER,ds.DIABETIC,ds.CONSULTANTNAME,ds.PATIENTTYPE,ds.STARTTIME,ds.ENDTIME,ds.STATUS,ds.CREATEDDATE,ds.CREATEDBY,ds.UPDATEDBY,ds.UPDATEDDATE,ds.REQUESTTYPE,ds.LOCATION,ds.RELEASESTATUS,ds.MEALTYPEID,ds.DIETTYPEID,ds.DIETINITIATIONID,ds.DIETINFOONIPDISCHARGE,ds.BEDCODE
      from fb.fb_dietslip ds
     where exists (
select dsd.dietslipid
              from fb.fb_mv_dietservingdetail DSD
             where ds.dietslipid = dsd.dietslipid);

CREATE OR REPLACE VIEW FB.FB_MV_TRANSDIETRESTRICTION
(DIETRESTRICTIONID,UHID,IPNO,DIETINITIATIONID,DIETRESTRICTIONS,ACTIVITYNAME,DATENTIME,LOGIN,LOCATION,STATUS,SERVICEID,CREATEDON,UPDATEDON)
AS
select DIETRESTRICTIONID,UHID,IPNO,DIETINITIATIONID,DIETRESTRICTIONS,ACTIVITYNAME,DATENTIME,LOGIN,LOCATION,STATUS,SERVICEID,CREATEDON,UPDATEDON
from fb.FB_TRANSDIETRESTRICTION dr
where dr.status =1;

CREATE OR REPLACE VIEW FB.PROCESSFLOWTRANSACTION
(PROCESFLOWTRANSID,PROCESSFLOWID,ACTIVITYID,SERVICEID,BUSINESSTRANSKEY)
AS
select PFT.PROCESFLOWTRANSID,
PFT.PROCESSFLOWID,
PFT.Activityid,
PFT.SERVICEID,
PFT1.BUSINESSTRANSKEY
from PROCESS.PROCESSFLOWTRANS PFT
inner JOIN PROCESS.PROCESSFLOWTRANS PFT1 
ON PFT.Procesflowtransid = PFT1.Nexttransid
WHERE PFT.COMPLETED='N'
and PFT1.COMPLETED='Y';

CREATE OR REPLACE VIEW FB.PROCESSFLOWTRANSACTION_PERF
(PROCESFLOWTRANSID,PROCESSFLOWID,ACTIVITYID,SERVICEID,BUSINESSTRANSKEY)
AS
select PFT.PROCESFLOWTRANSID,
PFT.PROCESSFLOWID,
PFT.Activityid,
PFT.SERVICEID,
PFT1.BUSINESSTRANSKEY
from PROCESS.PROCESSFLOWTRANS PFT
inner JOIN PROCESS.PROCESSFLOWTRANS PFT1
ON PFT.Procesflowtransid = PFT1.Nexttransid
WHERE PFT.COMPLETED='N'
and PFT1.COMPLETED='Y'
and PFT.createdon = current_date
and PFT1.businesstranskey  is not null
and   PFT.processflowid in (4, 3,421,501,522);

CREATE OR REPLACE VIEW FB.PROCESSFLOWTRANSACTION_TMP
(PROCESFLOWTRANSID,PROCESSFLOWID,ACTIVITYID,SERVICEID,BUSINESSTRANSKEY)
AS
select PFT.PROCESFLOWTRANSID,
PFT.PROCESSFLOWID,
PFT.Activityid,
PFT.SERVICEID,
PFT1.BUSINESSTRANSKEY
from PROCESS.PROCESSFLOWTRANS PFT
inner JOIN PROCESS.PROCESSFLOWTRANS PFT1 
ON PFT.Procesflowtransid = PFT1.Nexttransid
WHERE PFT.COMPLETED='N'
and PFT1.COMPLETED='Y'
and pft.activityid=11;

CREATE OR REPLACE VIEW HL7.HL7_VIEW_NOTIFY
(BUSINESSEVENTID,TRANSACTIONID,TRANSACTION_DATE,SEQUENCENUMBER,STATUS,TABLE_NAME1,COLUMN_NAME1,VALUE1,TABLE_NAME2,COLUMN_NAME2,VALUE2,TABLE_NAME3,COLUMN_NAME3,VALUE3,TABLE_NAME4,COLUMN_NAME4,VALUE4,ADDTNAL_CONDN)
AS
SELECT HL7_TRA_NOTIFY.BUSINESSEVENTID, TRANSACTIONID, TRANSACTION_DATE
          , SEQUENCENUMBER, STATUS, TABLE_NAME1, COLUMN_NAME1, VALUE1
          , TABLE_NAME2, COLUMN_NAME2, VALUE2
          , TABLE_NAME3, COLUMN_NAME3, VALUE3
          , TABLE_NAME4, COLUMN_NAME4, VALUE4
          , ADDTNAL_CONDN
         FROM HL7.HL7_TRA_NOTIFY,HL7.HL7_MAP_BUSINESSEVENTS,HL7.HL7_CFG_APPMAPPING
         WHERE HL7_MAP_BUSINESSEVENTS.BUSINESSEVENTID = HL7_TRA_NOTIFY.BUSINESSEVENTID
           AND HL7_MAP_BUSINESSEVENTS.ACTIVATEYN = 1
         AND HL7_CFG_APPMAPPING.APPMAPPINGID = HL7_MAP_BUSINESSEVENTS.APPMAPPINGID
           AND HL7_CFG_APPMAPPING.DELETEYN = 0
         AND UPPER(STATUS) = UPPER('New')
         AND 25 >= (SELECT COUNT(HL7_TRA_NOTIFY.BUSINESSEVENTID) FROM HL7.HL7_TRA_NOTIFY,HL7.HL7_MAP_BUSINESSEVENTS,HL7.HL7_CFG_APPMAPPING
         WHERE HL7_MAP_BUSINESSEVENTS.BUSINESSEVENTID = HL7_TRA_NOTIFY.BUSINESSEVENTID
           AND HL7_MAP_BUSINESSEVENTS.ACTIVATEYN = 1
         AND HL7_CFG_APPMAPPING.APPMAPPINGID = HL7_MAP_BUSINESSEVENTS.APPMAPPINGID
           AND HL7_CFG_APPMAPPING.DELETEYN = 0
         AND UPPER(STATUS) = UPPER('New'))
         ORDER BY SEQUENCENUMBER;

CREATE OR REPLACE VIEW HR.Vwr_EMPLOYEE_AUXILIARY_DETAILS
(EMP_AUX_ID,MADIAN_NAME_OTHER_NAME,MARRIAGE_DATE,SPOUSE_NAME,SPOUSE_DOB,CITIZENSHIP_ID,RELIGION_ID,CASTE_ID,BLOOD_GROUP_ID,SOCIALSECUIRETYNUMBER,PH_DESCRIPTION,IDENTIFICATION_MARK1,IDENTIFICATION_MARK2,EXPAT,COTRACTEMPLOYEE,BARGAINABLE_STATUS,UPLOAD_FILE_NAME,UPLOAD_FILE_TYPE,UPLOAD_FILE_PATH,EMP_ID,CONTRACT_FROM,CONTRACT_TO,UNDER_BOND,PAN_NUMBER,DRIVING_DETAILS,AWARDS_REWARDS,UNION_MEMBER,VACCINATION_DETAILS,INTENSHIP_INSTITUTE_DETAILS,FELLOWSHIP_INSTITUTE_DETAILS,REGISTRATION_DETAILS,MEDICAL_LICENSE,PROF_MEMBERSHIP_DETAILS,INSURANCE_CARRIER_DETAILS,PENDING_PROFL_LIABLITY_CLAIMS,PUBLIC_HEALTH_INSTITUTION,OTHER_DETAILS,BOND_DETAILS,PF_DETAILS,UPDATEDBY,UPDATEDDATE,DATEOFJOINING,DATEOFLEAVING,DATEOFAPOINTMENT,PROBATIONSTARTDATE,PROBATIONENDDATE,DATEOFCONFIRMATION,LASTPROMOTIONDATE,DUERETIREMENTDATE,ACTUALRETIREMENTDATE,LASTINCREMENTDATE,DUEINCREMENTDATE,ACTUALINCREMENTDATE,SUSPENSIONFROMDATE,SUSPENSIONTODATE,DATEOFRESIGNATIONTENDERED,DATEOFSEPERATION,FATHERNAME,FATHERDOB,MOTHERNAME,MOTHERDOB,CONTRACTDESCRIPTION,UHID,PHTYPE,RHTYPE,STOPPAYMENT,PFNUMBER,PAYROLLPROCESSDATE,RESIGNATION_RFLID,TRIALSTARTDATE,TRIALENDDATE)
AS
select EMP_AUX_ID,MADIAN_NAME_OTHER_NAME,MARRIAGE_DATE,SPOUSE_NAME,SPOUSE_DOB,CITIZENSHIP_ID,RELIGION_ID,CASTE_ID,BLOOD_GROUP_ID,SOCIALSECUIRETYNUMBER,PH_DESCRIPTION,IDENTIFICATION_MARK1,IDENTIFICATION_MARK2,EXPAT,COTRACTEMPLOYEE,BARGAINABLE_STATUS,UPLOAD_FILE_NAME,UPLOAD_FILE_TYPE,UPLOAD_FILE_PATH,EMP_ID,CONTRACT_FROM,CONTRACT_TO,UNDER_BOND,PAN_NUMBER,DRIVING_DETAILS,AWARDS_REWARDS,UNION_MEMBER,VACCINATION_DETAILS,INTENSHIP_INSTITUTE_DETAILS,FELLOWSHIP_INSTITUTE_DETAILS,REGISTRATION_DETAILS,MEDICAL_LICENSE,PROF_MEMBERSHIP_DETAILS,INSURANCE_CARRIER_DETAILS,PENDING_PROFL_LIABLITY_CLAIMS,PUBLIC_HEALTH_INSTITUTION,OTHER_DETAILS,BOND_DETAILS,PF_DETAILS,UPDATEDBY,UPDATEDDATE,DATEOFJOINING,DATEOFLEAVING,DATEOFAPOINTMENT,PROBATIONSTARTDATE,PROBATIONENDDATE,DATEOFCONFIRMATION,LASTPROMOTIONDATE,DUERETIREMENTDATE,ACTUALRETIREMENTDATE,LASTINCREMENTDATE,DUEINCREMENTDATE,ACTUALINCREMENTDATE,SUSPENSIONFROMDATE,SUSPENSIONTODATE,DATEOFRESIGNATIONTENDERED,DATEOFSEPERATION,FATHERNAME,FATHERDOB,MOTHERNAME,MOTHERDOB,CONTRACTDESCRIPTION,UHID,PHTYPE,RHTYPE,STOPPAYMENT,PFNUMBER,PAYROLLPROCESSDATE,RESIGNATION_RFLID,TRIALSTARTDATE,TRIALENDDATE from 
hr.employee_auxiliary_details emd
where emp_id  in (select employeeid from hr.mv_employee_main_details );

CREATE OR REPLACE VIEW HR.EMPLOYEE_MAIN_DETAILS_REP
(EMPLOYEEID)
AS
select Employeeid from HR.mv_employee_main_details emd;

CREATE OR REPLACE VIEW LAB.VW_LI_MACHINE_TESTMASTER_NEW
(MST_EQUIPMENT_ID,EQP_PARAM_REF_CD,EQP_NAME,EQP_PARAM_CD,TESTID,PARAMETERID,DEPARTMENT_ID,IS_CALCULATED)
AS
select DISTINCT
emp.mst_equipment_id ,emp.eqp_param_ref_cd,ed.EQP_NAME
,emp.EQP_PARAM_CD
,tm.testid, pmmc.parameterid
,''DEPARTMENT_ID,'0'"IS_CALCULATED"
from
LAB.testmaster tm
inner join LAB.testparameter tp on tm.testid = tp.testid
inner join LAB.parametermastermainclone pmmc on tp.parameterid= pmmc.parameterid
inner join LAB.parametermastermaindetailclone pmdc on pmmc.parameterid= pmdc.parameterid
inner join LABEQUIP.lab_link_param llp on pmdc.parameterdetailid= llp.parameterdetailid
inner join LABEQUIP.ei_mst_link_param emp on llp.mst_link_param_id= emp.mst_link_param_id
inner join LABEQUIP.ei_mst_equipments_master em on emp.mst_equipment_id= em.MST_EQP_MASTER_ID
inner join labequip.ei_mst_equipment_details ed on em.EQP_DETAILS_ID=ed.MST_EQP_DETAILS_ID
where llp.IsActive=1
and tm.locationid IN ('10101','11001','11002')
and pmmc.locationid IN ('10101','11001','11002')
and pmdc.locationid IN ('10101','11001','11002')
and tp.status=1
and pmmc.status=1
and pmdc.status=1;

create or replace view LAB.VW_MIC_CUL_TEST
as
SELECT DISTINCT (SELECT TT.TITLETYPE
                   FROM ehis.vwr_titlemaster TT
                  WHERE TT.TITLEID = RP.TITLE::numeric) || ' ' || RP.FIRSTNAME || ' ' ||
                RP.MIDDLENAME || ' ' || RP.LASTNAME PATIENTNAME,
                EL.LOVDETAILDESCRIPTION GENDER,
                TRUNC(public.months_between(current_date, RP.BIRTHDATE) / 12) AGE,
                RR.UHID,
                (CASE
                  WHEN RR.PATIENTSERVICE = 'IP' THEN
                   AD.IPNUMBER
                  ELSE
                   'NA'
                END) IPNUMBER,
                LDS.LEVELDETAILNAME AS WARD_NAME,
                RR.LRN,
                (CASE
                  WHEN RR.PATIENTSERVICE = 'IP' THEN
                   ((SELECT TT.TITLETYPE
                       FROM ehis.vwr_titlemaster TT
                      WHERE TT.TITLEID = ED1.TITLEID) || '' ||
                   ED1.FIRSTNAME || ' ' || ED1.MIDDLENAME || ' ' ||
                   ED1.LASTNAME)
                  ELSE
                   (case
					when PB.PRIMARYDOCTORID = 0 then 
					CUST.CUSTOMERNAME
					else ED.FIRSTNAME || ' ' || ED.MIDDLENAME || ' ' || ED.LASTNAME
					end)
                END) REFERRINGDOCTOR,
                SMC.SPECIMENID AS SAMPLEID,
                SMC.SPECIMENNAME SAMPLENAME,
                RT.TESTID,
                TM.TESTNAME,
                RT.SIN SINID,
                RT.SAMPLECOLLECTEDTIME,
                RT.SAMPLEPREPARETIME,
                RR.REQUESTEDDATE REQUESTEDDATE,
                RR.PATIENTSERVICENO,
                RR.PATIENTSERVICE,
                RT.LOCATIONID,
                RP.Birthdate,
                (case
                     when rr.patientservice='IP' and ipm.activestatus=1 then lds.leveldetailname ||'/'||bnm.bedcode
                     when rr.patientservice='OP'  then 'OP'
			         when rr.patientservice='AHC' then 'AHC'
                     else 'Discharged' end) wardAndBedNo,  
                '0' AS FLAG
  FROM LAB.REQUESTTESTS RT
 INNER JOIN LAB.RAISEREQUEST RR
    ON RT.LRN = RR.LRN
 INNER JOIN REGISTRATION.PATIENT RP
    ON RP.UHID = RR.UHID
 INNER JOIN ehis.vwr_lovdetail EL
    ON RP.GENDER::numeric = EL.LOVDETAILID
 INNER JOIN LAB.TESTMASTER TM
    ON RT.TESTID = TM.TESTID
   AND RT.LOCATIONID = TM.LOCATIONID
 INNER JOIN LAB.METHODOLOGY_LINK ML
    ON ML.METHODOLOGYLINKID = TM.METHODOLOGYLINKID
 INNER JOIN LAB.LOVDETAIL LD
    ON LD.LOVDETAILID = ML.TYPEOFMETHODOLOGY

 INNER JOIN LAB.SPECIMENMASTERCLONE SMC
    ON SMC.SPECIMENID = RT.SAMPLETYPE
   AND SMC.LOCATIONID = RT.LOCATIONID
  LEFT JOIN BILLING.PATIENTBILL PB
    ON (PB.PATIENTIDENTIFIERNUMBER = RR.PATIENTSERVICENO AND
       PB.LOCATIONID = RR.LOCATIONID)
  LEFT JOIN HR.MV_EMPLOYEE_MAIN_DETAILS ED
    ON ED.EMPLOYEEID = PB.PRIMARYDOCTORID
  LEFT OUTER JOIN crm.vwr_customers CUST
    ON (CUST.CUSTOMERID = PB.REFFERALDOCTORID)
  LEFT JOIN WARDS.ADMISSIONDETAILS AD
    ON AD.IPNUMBER = RR.PATIENTSERVICENO
   AND AD.LOCATIONID = RR.LOCATIONID
  LEFT JOIN HR.MV_EMPLOYEE_MAIN_DETAILS ED1
    ON AD.DOCTORNAME::numeric = ED1.EMPLOYEEID

  LEFT OUTER JOIN ADT.INPATIENTMASTER IPM
    ON IPM.INPATIENTNO = AD.IPNUMBER
   AND IPM.LOCATIONID = AD.LOCATIONID::numeric

  LEFT OUTER JOIN ADT.BEDADMISSION BAD
    ON BAD.INPATIENTID = IPM.INPATIENTID
   AND BAD.STATUS = 1
   AND BAD.CURRENTLYOCCUPIED = 1

  LEFT OUTER JOIN ADT.BEDMASTER BNM
    ON BNM.BEDID = BAD.BEDID
   AND BNM.STATUS = 1

  LEFT OUTER JOIN ADT.LevelDetail LDS
    ON LDS.LEVELDETAILID = BNM.LEVELDETAILID
   AND LDS.STATUS = 1

  LEFT OUTER JOIN ADT.LevelMaster LM
    ON LM.LEVELNO = lds.Levelno

 WHERE RT.TESTSTATUS = 1
   AND RT.BILLINGSTATUS = 1
   AND SMC.STATUS = 1
   AND RT.PREPARESAMPLE = 'Y'
   AND RT.SAMPLEVERIFY = 'N'
   AND RT.SAMPLECOLLECTED = 'Y'
   AND RT.PROCESSING = 'N'
   AND TM.STATUS = 1
   AND RT.DEPARTMENTID = 254
   AND ML.TYPEOFMETHODOLOGY = '354'
   AND (RT.CREATEDDATE::date) >= (current_date - 15);

CREATE OR REPLACE VIEW LABEQUIP.VW_EI_MACHINEMASTER
(MST_EQP_MASTER_ID,EQP_NAME)
AS
SELECT em.mst_eqp_master_id, ed.eqp_name
FROM LABEQUIP.EI_MST_EQUIPMENT_DETAILS ED, LABEQUIP.EI_MST_EQUIPMENTS_MASTER EM
 WHERE ed.mst_eqp_details_id = em.eqp_details_id;

CREATE OR REPLACE VIEW LABEQUIP.VW_LI_MACHINE_TESTMASTER
(MACHINE_ID,MACHINE_TESTID,MACHINE_TESTNAME,LIS_TESTID,LIS_PARAMETERID,DEPARTMENT_ID,IS_CALCULATED,MST_EQUIPMENT_ID,EQP_PARAM_CD)
AS
SELECT DISTINCT EMP.MST_EQUIPMENT_ID MACHINE_ID,
                EMP.EQP_PARAM_REF_CD MACHINE_TESTID,
                EMP.EQP_PARAM_CD MACHINE_TESTNAME,
                TM.TESTID LIS_TESTID,
                PMMC.PARAMETERID LIS_PARAMETERID,
                '' DEPARTMENT_ID,
                '0' IS_CALCULATED,
                EMP.MST_EQUIPMENT_ID MST_EQUIPMENT_ID,
                EMP.EQP_PARAM_CD     EQP_PARAM_CD
  FROM LAB.TESTMASTER TM
 INNER JOIN LAB.TESTPARAMETER TP ON TM.TESTID = TP.TESTID
                                AND TM.LOCATIONID = TP.LOCATIONID --CL
 INNER JOIN LAB.PARAMETERMASTERMAINCLONE PMMC ON TP.PARAMETERID =
                                                 PMMC.PARAMETERID
 INNER JOIN LAB.PARAMETERMASTERMAINDETAILCLONE PMDC ON PMMC.PARAMETERID =
                                                       PMDC.PARAMETERID
 INNER JOIN LAB.LAB_LINK_PARAM LLP ON PMDC.PARAMETERDETAILID =
                                      LLP.PARAMETERDETAILID
 INNER JOIN LAB.EI_MST_LINK_PARAM EMP ON LLP.MST_LINK_PARAM_ID =
                                         EMP.MST_LINK_PARAM_ID
 INNER JOIN LABEQUIP.LI_MACHINEMASTER LM ON EMP.MST_EQUIPMENT_ID =
                                            LM.MACHINE_ID::numeric 
 WHERE LLP.ISACTIVE = 1
   AND EMP.ISACTIVE = 1
   AND TM.STATUS = TP.STATUS
   AND TM.STATUS = 1
   AND TP.STATUS = PMMC.STATUS
   AND TP.STATUS = 1
   AND PMDC.STATUS = 1
   AND TM.LOCATIONID IN ('10701', '10702')
   AND PMMC.LOCATIONID IN ('10701', '10702')
   AND PMDC.LOCATIONID IN ('10701', '10702')
   AND PMDC.APPROVED = 'Y' --CL
   AND TP.LOCATIONID IN ('10701', '10702') --CL
   AND EMP.MST_EQUIPMENT_ID <> 25
UNION ALL
SELECT DISTINCT EMP.MST_EQUIPMENT_ID MACHINE_ID,
                EMP.EQP_PARAM_REF_CD MACHINE_TESTID,
                EMP.EQP_PARAM_CD MACHINE_TESTNAME,
                TM.TESTID LIS_TESTID,
                PMMC.PARAMETERID LIS_PARAMETERID,
                '' DEPARTMENT_ID,
                '0' IS_CALCULATED,
                EMP.MST_EQUIPMENT_ID MST_EQUIPMENT_ID,
                EMP.EQP_PARAM_CD     EQP_PARAM_CD
  FROM LAB.TESTMASTER TM
 INNER JOIN LAB.TESTPARAMETER TP ON TM.TESTID = TP.TESTID
                                AND TM.LOCATIONID = TP.LOCATIONID --CL
 INNER JOIN LAB.PARAMETERMASTERMAINCLONE PMMC ON TP.PARAMETERID =
                                                 PMMC.PARAMETERID
 INNER JOIN LAB.PARAMETERMASTERMAINDETAILCLONE PMDC ON PMMC.PARAMETERID =
                                                       PMDC.PARAMETERID
 INNER JOIN LABEQUIP.LAB_LINK_PARAM LLP1 ON PMDC.PARAMETERDETAILID =
                                            LLP1.PARAMETERDETAILID
 INNER JOIN LAB.EI_MST_LINK_PARAM EMP ON LLP1.MST_LINK_PARAM_ID =
                                         EMP.MST_LINK_PARAM_ID
 INNER JOIN LABEQUIP.LI_MACHINEMASTER LM ON EMP.MST_EQUIPMENT_ID =
                                            LM.MACHINE_ID::numeric 
 WHERE LLP1.ISACTIVE = 1
   AND EMP.ISACTIVE = 1
   AND TM.STATUS = TP.STATUS
   AND TM.APPROVED = 'Y' --CL
   AND TP.STATUS = PMMC.STATUS
   AND PMDC.STATUS = 1
   AND PMDC.APPROVED = 'Y' --CL
   AND TM.LOCATIONID IN ('10701', '10702')
   AND TM.STATUS = 1
   AND PMMC.LOCATIONID IN ('10701', '10702')
   AND PMMC.STATUS = 1
   AND PMDC.LOCATIONID IN ('10701', '10702')
   AND PMDC.STATUS = 1
   AND LLP1.TESTID = TP.TESTID
   AND TP.LOCATIONID IN ('10701', '10702') --CL
   AND EMP.MST_EQUIPMENT_ID = 25;

CREATE OR REPLACE VIEW LABEQUIP.VW_LI_MACHINE_TESTMASTER_AHIL
(MST_EQUIPMENT_ID,EQP_PARAM_REF_CD,EQP_NAME,EQP_PARAM_CD,TESTID,PARAMETERID,DEPARTMENT_ID,IS_CALCULATED,EQP_TEST_NAME)
AS
select DISTINCT
emp.mst_equipment_id ,emp.eqp_param_ref_cd,ed.EQP_NAME
,emp.EQP_PARAM_CD
,tm.testid, pmmc.parameterid
,''DEPARTMENT_ID,
coalesce(emp.eqp_test_id,'0') IS_CALCULATED,
emp.eqp_test_name
from
LAB.testmaster tm
inner join LAB.testparameter tp on tm.testid = tp.testid
inner join LAB.parametermastermainclone pmmc on tp.parameterid= pmmc.parameterid
inner join LAB.parametermastermaindetailclone pmdc on pmmc.parameterid= pmdc.parameterid
inner join LABEQUIP.lab_link_param llp on pmdc.parameterdetailid= llp.parameterdetailid
inner join LABEQUIP.ei_mst_link_param emp on llp.mst_link_param_id= emp.mst_link_param_id
inner join LABEQUIP.ei_mst_equipments_master em on emp.mst_equipment_id= em.MST_EQP_MASTER_ID
inner join labequip.ei_mst_equipment_details ed on em.EQP_DETAILS_ID=ed.MST_EQP_DETAILS_ID
WHERE 
((Current_database() IN ('ehischn','ehisbbs','ehisblr','ahdel','ehishyd','ehisaghl','ehisnsk'))
AND
llp.IsActive=1
and tm.locationid IN ('10501')
and tm.locationid = pmmc.locationid
and tm.locationid = pmdc.locationid
--and ed.eqp_name like '%AHIL%'
and ed.mst_eqp_details_id between 265 and 275
and tp.status=1
and pmmc.status=1
and pmdc.status=1
)

UNION ALL

select DISTINCT
emp.mst_equipment_id ,emp.eqp_param_ref_cd,ed.EQP_NAME
,emp.EQP_PARAM_CD
,tm.testid, pmmc.parameterid
,''DEPARTMENT_ID,
coalesce(emp.eqp_test_id,'0') IS_CALCULATED,
emp.eqp_test_name
from
LAB.testmaster tm
inner join LAB.testparameter tp on tm.testid = tp.testid
inner join LAB.parametermastermainclone pmmc on tp.parameterid= pmmc.parameterid
inner join LAB.parametermastermaindetailclone pmdc on pmmc.parameterid= pmdc.parameterid
inner join LABEQUIP.lab_link_param llp on pmdc.parameterdetailid= llp.parameterdetailid
inner join LABEQUIP.ei_mst_link_param emp on llp.mst_link_param_id= emp.mst_link_param_id
inner join LABEQUIP.ei_mst_equipments_master em on emp.mst_equipment_id= em.MST_EQP_MASTER_ID
inner join labequip.ei_mst_equipment_details ed on em.EQP_DETAILS_ID=ed.MST_EQP_DETAILS_ID
WHERE

( (Current_database() = 'ahsag') 
AND llp.IsActive=1
and tm.locationid IN ('17101')
and tm.locationid = pmmc.locationid
and tm.locationid = pmdc.locationid
--and ed.eqp_name like '%AHIL%'
--and ed.mst_eqp_details_id in (21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,40,41, 42,43,44,45,46,47,48,49,50)
and tp.status=1
and pmmc.status=1
and pmdc.status=1
)

UNION ALL

select DISTINCT
emp.mst_equipment_id ,emp.eqp_param_ref_cd,ed.EQP_NAME
,emp.EQP_PARAM_CD
,tm.testid, pmmc.parameterid
,''DEPARTMENT_ID,
coalesce(emp.eqp_test_id,'0') IS_CALCULATED,
emp.eqp_test_name
from
LAB.testmaster tm
inner join LAB.testparameter tp on tm.testid = tp.testid
inner join LAB.parametermastermainclone pmmc on tp.parameterid= pmmc.parameterid
inner join LAB.parametermastermaindetailclone pmdc on pmmc.parameterid= pmdc.parameterid
inner join LABEQUIP.lab_link_param llp on pmdc.parameterdetailid= llp.parameterdetailid
inner join LABEQUIP.ei_mst_link_param emp on llp.mst_link_param_id= emp.mst_link_param_id
inner join LABEQUIP.ei_mst_equipments_master em on emp.mst_equipment_id= em.MST_EQP_MASTER_ID
inner join labequip.ei_mst_equipment_details ed on em.EQP_DETAILS_ID=ed.MST_EQP_DETAILS_ID
WHERE
( (Current_database() = 'ehismum') 
AND llp.IsActive=1
and tm.locationid IN ('11001','11002','11201')
and tm.locationid = pmmc.locationid 
and tm.locationid = pmdc.locationid 
--and ed.eqp_name like '%AHIL%'
and ed.mst_eqp_details_id in (21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,40,41, 42,43,44,45,46,47,48,49,50)
and tp.status=1
and pmmc.status=1
and pmdc.status=1
);

CREATE OR REPLACE VIEW LABEQUIP.VW_LI_MACHINE_TESTMASTER_BB
(MST_EQUIPMENT_ID,EQP_PARAM_REF_CD,EQP_PARAM_CD,EQP_PARAM_NAME,TESTID,PARAMETERID,DEPARTMENT_ID,IS_CALCULATED,EQP_NAME)
AS
SELECT DISTINCT EMP.MST_EQUIPMENT_ID "MST_EQUIPMENT_ID",
                EMP.EQP_PARAM_REF_CD "EQP_PARAM_REF_CD",
                EMP.EQP_PARAM_CD "EQP_PARAM_CD",
                EMP.EQP_PARAM_NAME "EQP_PARAM_NAME",
                TM.TESTID "TESTID",
                PMMC.PARAMETERID "PARAMETERID",
                '' AS "DEPARTMENT_ID",
                TP.ISFORMULA AS "IS_CALCULATED",
                ED.EQP_NAME
  FROM LAB.TESTMASTER TM
 INNER JOIN LAB.TESTPARAMETER TP
    ON TM.TESTID = TP.TESTID
   AND TM.LOCATIONID = TP.LOCATIONID
 INNER JOIN LAB.PARAMETERMASTERMAINCLONE PMMC
    ON TP.PARAMETERID = PMMC.PARAMETERID
   AND TP.LOCATIONID = PMMC.LOCATIONID
 INNER JOIN LAB.PARAMETERMASTERMAINDETAILCLONE PMDC
    ON PMMC.PARAMETERID = PMDC.PARAMETERID
   AND PMMC.LOCATIONID = PMDC.LOCATIONID
 INNER JOIN LABEQUIP.LAB_LINK_PARAM LLP
    ON PMDC.PARAMETERDETAILID = LLP.PARAMETERDETAILID
 INNER JOIN LABEQUIP.EI_MST_LINK_PARAM EMP
    ON LLP.MST_LINK_PARAM_ID = EMP.MST_LINK_PARAM_ID
 INNER JOIN LABEQUIP.EI_MST_EQUIPMENTS_MASTER EM
    ON EMP.MST_EQUIPMENT_ID = EM.MST_EQP_MASTER_ID
 INNER JOIN LABEQUIP.EI_MST_EQUIPMENT_DETAILS ED
    ON EM.EQP_DETAILS_ID = ED.MST_EQP_DETAILS_ID
 WHERE LLP.ISACTIVE = 1
   AND EMP.ISACTIVE = 1
   AND TP.STATUS = 1
   AND TM.STATUS = 1
   AND PMMC.STATUS = 1
   AND PMDC.STATUS = 1
   AND TM.LOCATIONID in ('10201', '10362', '10209')
   AND TP.LOCATIONID in ('10201', '10362', '10209')
   AND PMMC.LOCATIONID in ('10201', '10362', '10209')
   AND PMDC.LOCATIONID in ('10201', '10362', '10209')
   AND EMP.ISACTIVE = 1;

CREATE OR REPLACE VIEW LABEQUIP.VW_LI_MACHINE_TESTMASTER_NEW
(MST_EQUIPMENT_ID,EQP_PARAM_REF_CD,EQP_NAME,EQP_PARAM_CD,TESTID,PARAMETERID,DEPARTMENT_ID,IS_CALCULATED)
AS
SELECT DISTINCT EMP.MST_EQUIPMENT_ID,
                EMP.EQP_PARAM_REF_CD,
                ED.EQP_NAME,
                EMP.EQP_PARAM_CD,
                TM.TESTID,
                PMMC.PARAMETERID,
                '' DEPARTMENT_ID,
                coalesce(EMP.EQP_TEST_ID,'0') IS_CALCULATED
  FROM LAB.TESTMASTER TM
 INNER JOIN LAB.TESTPARAMETER TP
    ON TM.TESTID = TP.TESTID
 INNER JOIN LAB.PARAMETERMASTERMAINCLONE PMMC
    ON TP.PARAMETERID = PMMC.PARAMETERID
 INNER JOIN LAB.PARAMETERMASTERMAINDETAILCLONE PMDC
    ON PMMC.PARAMETERID = PMDC.PARAMETERID
 INNER JOIN LABEQUIP.LAB_LINK_PARAM LLP
    ON PMDC.PARAMETERDETAILID = LLP.PARAMETERDETAILID
 INNER JOIN LABEQUIP.EI_MST_LINK_PARAM EMP
    ON LLP.MST_LINK_PARAM_ID = EMP.MST_LINK_PARAM_ID
 INNER JOIN LABEQUIP.EI_MST_EQUIPMENTS_MASTER EM
    ON EMP.MST_EQUIPMENT_ID = EM.MST_EQP_MASTER_ID
 INNER JOIN LABEQUIP.EI_MST_EQUIPMENT_DETAILS ED
    ON EM.EQP_DETAILS_ID = ED.MST_EQP_DETAILS_ID
 WHERE LLP.ISACTIVE = 1
   AND TM.LOCATIONID = TP.LOCATIONID
   AND TP.LOCATIONID = PMMC.LOCATIONID
   AND PMMC.LOCATIONID = PMDC.LOCATIONID
   AND TM.LOCATIONID = PMDC.LOCATIONID
   --AND TM.TESTID = 773
   AND PMMC.LOCATIONID = PMDC.LOCATIONID
   AND TP.STATUS = PMDC.STATUS
   AND TM.LOCATIONID IN ('10101','10108','10107','10551', '10552')
   AND PMMC.LOCATIONID IN ('10101','10108','10107','10551', '10552')
   AND PMDC.LOCATIONID IN ('10101','10108','10107','10551', '10552')
   AND TP.STATUS = 1
   AND PMMC.STATUS = 1
   AND PMDC.STATUS = 1;

CREATE OR REPLACE VIEW LABEQUIP.VW_LI_TESTREQUEST
(UHID,LRN,PATIENTNAME,SEX,AGE,DEPARTMENT_ID,LIS_TESTID,TESTNAME,LIS_PARAMETERID,PARAMETERNAME,SINID,SAMPLEID,SAMPLECOLLECTEDTIME,STATUS,BILLID,REQUESTEDDATE,PATIENTSERVICENO,LOCATIONID,PARAMETERID,TESTID)
AS
SELECT DISTINCT RR.UHID,
                RR.LRN,
                RP.FIRSTNAME || ' ' || RP.MIDDLENAME || ' ' || RP.LASTNAME PATIENTNAME,
                EL.LOVDETAILDESCRIPTION SEX,
                RP.AGE,
                RT.DEPARTMENTID DEPARTMENT_ID,
                RT.TESTID LIS_TESTID,
                TM.TESTNAME,
                TP.PARAMETERID LIS_PARAMETERID,
                PM.PARAMETERNAME,
                RT.SIN SINID,
                SMC.SPECIMENNAME SAMPLEID,
                RT.SAMPLECOLLECTEDTIME,
                '0' STATUS,
                '' BILLID,
                RR.REQUESTEDDATE REQUESTEDDATE,
                RR.PATIENTSERVICENO     PATIENTSERVICENO,
                TM.LOCATIONID           LOCATIONID,
                TP.PARAMETERID          PARAMETERID,
                RT.TESTID
  FROM LAB.REQUESTTESTS RT
 INNER JOIN LAB.RAISEREQUEST RR ON RT.LRN = RR.LRN
 INNER JOIN REGISTRATION.PATIENT RP ON (RP.UHID = RR.UHID /*OR
            RP.PREREGISTRATIONNO = RR.UHID*/
                                       ) ----CL
 INNER JOIN ehis.vwr_lovdetail EL ON RP.GENDER::numeric = EL.LOVDETAILID
 INNER JOIN LAB.TESTMASTER TM ON RT.TESTID = TM.TESTID
 INNER JOIN LAB.TESTPARAMETER TP ON TP.TESTID = RT.TESTID
 INNER JOIN LAB.PARAMETERMASTERMAINCLONE PM ON PM.PARAMETERID =
                                               TP.PARAMETERID
 INNER JOIN LAB.SPECIMENMASTERCLONE SMC ON SMC.SPECIMENID = RT.SAMPLETYPE
 WHERE RT.EQUIPMENTPROCESSING = 0
   /*AND RT.LOCATIONID = RR.LOCATIONID*/ ----CL
   AND RT.TESTSTATUS = 1
   AND RT.BILLINGSTATUS = 1
   AND RT.PREPARESAMPLE = 'Y'
   AND RT.SAMPLEVERIFY = 'N'
   AND RT.SAMPLECOLLECTED = 'Y'
   AND RT.PROCESSING = 'N'
   AND RT.TYPEOFPROCESSING IN (323, 322, 1675)
   AND TM.LOCATIONID IN ('10701', '10702')
   AND PM.LOCATIONID IN ('10701', '10702')
   AND TP.LOCATIONID IN ('10701', '10702')
   AND SMC.LOCATIONID IN ('10701', '10702') ----CL
   AND TP.STATUS = 1
   AND TP.APPROVED = 'Y' ----CL
   AND TM.STATUS = 1
   AND TM.APPROVED = 'Y' ----CL
   AND (RR.CREATEDDATE::date) BETWEEN (current_date - 15) AND (current_date)
   AND PM.STATUS = 1;

CREATE OR REPLACE VIEW LABEQUIP.VW_LI_TESTREQUESTN
(UHID,LRN,PATIENTNAME,SEX,AGE,DEPARTMENT_ID,LIS_TESTID,TESTNAME,LIS_PARAMETERID,PARAMETERNAME,SINID,SAMPLEID,SAMPLECOLLECTEDTIME,STATUS,BILLID,REQUESTEDDATE)
AS
select DISTINCT rr.uhid, rr.lrn, rp.firstname||' '||rp.middlename||' '||rp.lastname PATIENTNAME , el.lovdetaildescription SEX,
rp.age,  rt.departmentid DEPARTMENT_ID, rt.testid LIS_TESTID, tm.testname,tp.parameterid LIS_PARAMETERID, pm.parametername,
rt.sin SINID, smc.specimenname SAMPLEID, rt.samplecollectedtime, '0' STATUS,'' BILLID,rr.requesteddate REQUESTEDDATE
 from LAB.requesttests rt
inner join LAB.raiserequest rr on rt.lrn=rr.lrn
inner join registration.patient rp on (rp.uhid= rr.uhid  or rr.uhid=rp.preregistrationno)
inner join ehis.vwr_lovdetail el on rp.gender::numeric=el.lovdetailid
inner join LAB.testmaster tm on rt.testid=tm.testid
inner join LAB.testparameter tp on (rt.testid  = tp.testid and tm.testid= tp.testid)
inner join LAB.parametermastermainclone pm on tp.parameterid=pm.parameterid
INNER JOIN LAB.specimenmasterclone smc on rt.sampletype=smc.specimenid
where rt.equipmentprocessing=0 and rt.teststatus=1 and rt.billingstatus=1
and rt.preparesample='Y'
and rt.sampleverify ='N'
and rt.samplecollected='Y'
and rt.processing='N'
and rt.typeofprocessing in (323,322,1675)
and rp.locationid=tm.locationid::numeric
and tm.locationid  in ('10101','10108','10401')
and pm.locationid in ('10101','10108','10401')
and tp.locationid in ('10101','10108','10401')
and rp.status=tm.status
AND TP.STATUS=1
AND TM.STATUS=1
AND PM.STATUS=1;

CREATE OR REPLACE VIEW LABEQUIP.VW_LI_TESTREQUEST_BB
(UHID,LRN,PATIENTNAME,SEX,AGE,DEPARTMENT_ID,TESTID,TESTNAME,PARAMETERID,PARAMETERNAME,SINID,SAMPLEID,SAMPLECOLLECTEDTIME,STATUS,BILLID,REQUESTEDDATE,PATIENTSERVICENO,LOCATIONID)
AS
SELECT DISTINCT RR.UHID,
                RR.LRN,
                RP.FIRSTNAME || ' ' || RP.MIDDLENAME || ' ' || RP.LASTNAME "PATIENTNAME",
                EL.LOVDETAILDESCRIPTION "SEX",
                RP.AGE,
                RT.DEPARTMENTID "DEPARTMENT_ID",
                RT.TESTID "TESTID",
                TM.TESTNAME,
                TP.PARAMETERID "PARAMETERID",
                PM.PARAMETERNAME,
                RT.SIN "SINID",
                SMC.SPECIMENNAME "SAMPLEID",
                RT.SAMPLECOLLECTEDTIME,
                '0' "STATUS",
                'N' "BILLID",
                RR.REQUESTEDDATE "REQUESTEDDATE",
                RR.PATIENTSERVICENO,
                TM.LOCATIONID
  FROM LAB.REQUESTTESTS RT
 INNER JOIN LAB.RAISEREQUEST RR
    ON RT.LRN = RR.LRN /*AND RT.LOCATIONID=RR.LOCATIONID*/
 INNER JOIN REGISTRATION.PATIENT RP
    ON RP.UHID = RR.UHID /*AND RR.LOCATIONID=RP.LOCATIONID*/
 INNER JOIN ehis.vwr_lovdetail EL
    ON RP.GENDER::numeric = EL.LOVDETAILID
 INNER JOIN LAB.TESTMASTER TM
    ON RT.TESTID = TM.TESTID
   AND TM.LOCATIONID = RT.LOCATIONID
 INNER JOIN LAB.TESTPARAMETER TP
    ON TM.TESTID = TP.TESTID
   AND TM.LOCATIONID = TP.LOCATIONID
 INNER JOIN LAB.PARAMETERMASTERMAINCLONE PM
    ON TP.PARAMETERID = PM.PARAMETERID
   AND TP.LOCATIONID = PM.LOCATIONID
 INNER JOIN LAB.SPECIMENMASTERCLONE SMC
    ON RT.SAMPLETYPE = SMC.SPECIMENID
   AND RT.LOCATIONID = SMC.LOCATIONID
 WHERE RT.TESTSTATUS = 1
   AND TP.STATUS = 1
   AND TM.STATUS = 1
   AND PM.STATUS = 1
   AND SMC.STATUS = 1
   AND RR.STATUS = 1
   AND RT.BILLINGSTATUS = 1
   AND RT.PREPARESAMPLE = 'Y'
   AND RT.SAMPLECOLLECTED = 'Y'
   --AND RT.PROCESSING = 'N'
   --AND RT.SAMPLEVERIFY = 'N'
   AND RT.TYPEOFPROCESSING IN (322, 323, 1675)
   AND TM.LOCATIONID in ('10201', '10362', '10209')
   AND RT.LOCATIONID in ('10201', '10362', '10209')
   AND TP.LOCATIONID in ('10201', '10362', '10209')
   AND PM.LOCATIONID in ('10201', '10362', '10209')
   AND SMC.LOCATIONID in ('10201', '10362', '10209')
   AND (RR.CREATEDDATE::date) BETWEEN (current_date - 7) AND (current_date);

CREATE OR REPLACE VIEW LABEQUIP.VW_LI_TEST_REQ
(MACHINE_ID,MACHINE_TESTID,MACHINE_TESTNAME,DEPARTMENT_ID,PATIENTNAME,AGE,SEX,BILLID,SINID,IS_CALCULATED,STATUS,SAMPLEID,LIS_TESTID,LIS_PARAMETERID,REQUESTDATE,MST_EQUIPMENT_ID,EQP_PARAM_CD,TESTID,PARAMETERID,PATIENTSERVICENO,LRN,UHID,LOCATIONID,EQP_NAME,EQP_PARAM_REF_CD)
AS
SELECT DISTINCT
        LIMT.MACHINE_ID       MACHINE_ID,
        LIMT.MACHINE_TESTID   MACHINE_TESTID,
        LIMT.MACHINE_TESTNAME MACHINE_TESTNAME,
        LIMT.DEPARTMENT_ID    DEPARTMENT_ID,
        LITR.PATIENTNAME      PATIENTNAME,
        LITR.AGE              AGE,
        LITR.SEX              SEX,
        LITR.BILLID           BILLID,
        LITR.SINID            SINID,
        LIMT.IS_CALCULATED    IS_CALCULATED,
        LITR.STATUS           STATUS,
        LITR.SAMPLEID         SAMPLEID,
        LITR.LIS_TESTID       LIS_TESTID,
        LITR.LIS_PARAMETERID  LIS_PARAMETERID,
        LITR.REQUESTEDDATE    REQUESTDATE,
        LIMT.MST_EQUIPMENT_ID MST_EQUIPMENT_ID,
        LIMT.EQP_PARAM_CD     EQP_PARAM_CD,
        LITR.TESTID,
        LITR.PARAMETERID,
        LITR.PATIENTSERVICENO,
        LITR.LRN,
        LITR.UHID,
        LITR.LOCATIONID,
        NULL EQP_NAME,
        NULL EQP_PARAM_REF_CD
    FROM
        LABEQUIP.VW_LI_MACHINE_TESTMASTER LIMT,
        LABEQUIP.VW_LI_TESTREQUEST        LITR
    WHERE
            LIMT.LIS_TESTID = LITR.LIS_TESTID
        AND LIMT.LIS_PARAMETERID = LITR.LIS_PARAMETERID;

CREATE OR REPLACE VIEW LABEQUIP.VW_LI_TEST_REQ_NEW as
select
	distinct LIMT.mst_equipment_id,
	limt.eqp_name,
	limt.eqp_param_ref_cd,
	LIMT.TESTID,
	LIMT.DEPARTMENT_ID,
	LIMT.IS_CALCULATED IS_CALCULATED,
	rr.uhid,
	rr.lrn,
	rt.locationid,
	rp.birthdate,
	coalesce(tt.titletype,'') || ' ' || coalesce(rp.firstname,'') || ' ' || coalesce(rp.middlename,'') || ' ' || coalesce(rp.lastname,'') PATIENTNAME,
	el.lovdetaildescription SEX,
	rp.age,
	rt.departmentid,
	rt.testid LIS_TESTID,
	tm.testname,
	tp.parameterid LIS_PARAMETERID,
	pm.parametername,
	rt.sin SINID,
	smc.specimenname SAMPLEID,
	rt.samplecollectedtime,
	rt.samplepreparetime,
	'0' STATUS,
	'' BILLID,
	rr.requesteddate REQUESTEDDATE,
	rr.patientserviceno
from
	labequip.VW_LI_MACHINE_TESTMASTER_NEW LIMT,
	LAB.requesttests rt
inner join LAB.raiserequest rr
on
	rt.lrn = rr.lrn
inner join registration.patient rp
on
	rp.uhid = rr.uhid
inner join ehis.vwr_titlemaster tt
on
	rp.title::numeric = tt.titleid
inner join ehis.vwr_lovdetail el
on
	rp.gender::numeric = el.lovdetailid
inner join LAB.testmaster tm
on
	rt.testid = tm.testid
inner join LAB.testparameter tp
on
	tp.testid = rt.testid
inner join LAB.parametermastermainclone pm
on
	pm.parameterid = tp.parameterid
inner join LAB.specimenmasterclone smc
on
	smc.specimenid = rt.sampletype
where
	LIMT.TESTID = rt.testid
	--AND RT.LOCATIONID = TM.LOCATIONID
	and TM.LOCATIONID = TP.LOCATIONID
	and TP.LOCATIONID = PM.LOCATIONID
	--AND RT.LOCATIONID = TP.LOCATIONID
	--AND RT.LOCATIONID = PM.LOCATIONID
	and TM.LOCATIONID = PM.LOCATIONID
	and RT.teststatus = TM.STATUS
	and TM.STATUS = TP.STATUS
	and TP.STATUS = PM.STATUS
	and rt.equipmentprocessing = 0
	and rt.teststatus = 1
	and rt.billingstatus = 1
	and rt.preparesample = 'Y'
	and rt.sampleverify = 'N'
	and rt.samplecollected = 'Y'
	and rt.processing = 'N'
	and tm.approved = 'Y'
	and tp.approved = 'Y'
	and tm.status = 1
	and rt.typeofprocessing in (323, 322, 1675)
	and tm.locationid in ('10101', '10108', '10107', '10551', '10552','10408') -- added 10408 by steven based on oracle on 06-mar-24
	and pm.locationid in ('10101', '10108', '10107', '10551', '10552','10408') -- added 10408 by steven based on oracle on 06-mar-24
	and tp.locationid in ('10101', '10108', '10107', '10551', '10552','10408') -- added 10408 by steven based on oracle on 06-mar-24
	and tp.status = 1
	and pm.status = 1
	and LIMT.PARAMETERID = tp.parameterid
	and rt.createddate::date > (current_date-180);
	
CREATE OR REPLACE
VIEW LABEQUIP.VW_LI_TEST_REQ_NEW_AHIL AS
SELECT
	DISTINCT LIMT.mst_equipment_id,
	limt.eqp_name,
	limt.eqp_param_ref_cd,
	LIMT.TESTID,
	LIMT.DEPARTMENT_ID,
	LIMT.IS_CALCULATED IS_CALCULATED,
	rr.uhid,
	rr.lrn,
	REPLACE( (SUBSTR((concat(rp.firstname, NULL) || ' ' || concat(rp.middlename, NULL) || ' ' || concat(rp.lastname, NULL)),
	1,
	20)),
	'  ',
	' ') PATIENTNAME
  ,
	el.lovdetaildescription SEX,
	(CASE
		WHEN COALESCE(rp.age,
		0) = 0 THEN
          (CASE
			WHEN (EXTRACT(YEAR
		FROM
			current_date) - EXTRACT(YEAR
		FROM
			RP.Birthdate)) = 0 THEN
          1
			ELSE
          (EXTRACT(YEAR
		FROM
			current_date) - EXTRACT(YEAR
		FROM
			RP.Birthdate))
		END)
		ELSE RP.age
	END)
       AGE,
	rp.birthdate DOB,
	REPLACE((SUBSTR( ( COALESCE((CASE
		WHEN RR.patientserviceNO NOT LIKE 'BPLIP%' THEN
                       (
		SELECT
			COALESCE(DRE.FIRSTNAME, '') || ' ' || COALESCE(DRE.MIDDLENAME,
			'') || ' ' ||
                                COALESCE(DRE.LASTNAME,
			'') Doctor
		FROM
			hr.mv_employee_main_details DRE,
			billing.patientbill PB
		WHERE
			DRE.EMPLOYEEID = PB.primarydoctorid
			AND PB.locationid IN ('17101')
			AND PB.delflag = 1
			AND DRE.LOCATIONID IN ('17101')
			AND PB.patientidentifiernumber = RR.patientserviceno
			AND RR.LOCATIONID = PB.LOCATIONID )
		ELSE
                       (
		SELECT
			COALESCE(EE.FIRSTNAME, '') || ' ' || COALESCE(EE.MIDDLENAME,
			'') || ' ' ||
                               COALESCE(EE.LASTNAME,
			'') Doctor
		FROM
			hr.mv_employee_main_details ee,
			lab.raiserequest LRR,
			Adt.Inpatientmaster I
		WHERE
			LRR.Lrn = RR.lrn
			AND I.Inpatientno = LRR.Patientserviceno
			AND ee.EMPLOYEEID = I.Admittingdoctor
			AND LRR.Patientservice = 'IP'
			AND RR.patientserviceno = I.Inpatientno
			AND RR.LOCATIONID::NUMERIC = I.LOCATIONID)
	END),
	'NA') ),
	1,
	20) ),
	'  ',
	' ')
                     DOCTOR,
	REPLACE((SUBSTR( ( COALESCE((CASE
		WHEN RR.patientserviceNO NOT LIKE 'BPLIP%' THEN
                       (
		SELECT
			(DRE.EMPLOYEEID)::text DoctorID
		FROM
			hr.mv_employee_main_details DRE,
			billing.patientbill PB
		WHERE
			DRE.EMPLOYEEID = PB.primarydoctorid
			AND PB.locationid IN ('17101')
				AND PB.delflag = 1
				AND DRE.LOCATIONID IN ('17101')
					AND PB.patientidentifiernumber = RR.patientserviceno
					AND RR.LOCATIONID = PB.LOCATIONID )
		ELSE
                       (
		SELECT
			(EE.EMPLOYEEID)::text DoctorID
		FROM
			hr.mv_employee_main_details ee,
			lab.raiserequest LRR,
			Adt.Inpatientmaster I
		WHERE
			LRR.Lrn = RR.lrn
			AND I.Inpatientno = LRR.Patientserviceno
			AND ee.EMPLOYEEID = I.Admittingdoctor
			AND LRR.Patientservice = 'IP'
			AND RR.patientserviceno = I.Inpatientno
			AND RR.LOCATIONID::NUMERIC = I.LOCATIONID)
	END),
	'NA') ),
	1,
	20) ),
	'  ',
	' ')
                     DOCTORID,
	--rp.age ,
	rt.departmentid ,
	rt.testid LIS_TESTID,
	tm.testname,
	tp.parameterid LIS_PARAMETERID,
	pm.parametername,
	rt.sin SINID,
	smc.specimenname SAMPLEID,
	rt.samplecollectedtime,
	rt.samplepreparetime,
	'0' STATUS,
	'' BILLID,
	rr.requesteddate REQUESTEDDATE,
	--rr.patientserviceno
	rr.patientserviceno patientserviceno1 ,
	(SUBSTR(rr.patientserviceno,
	5,
	2)|| '' || rr.lrn) patientserviceno
	--,rr.lrn patientserviceno
FROM
	labequip.vw_li_machine_testmaster_AHIL LIMT,
	LAB.requesttests rt
INNER JOIN LAB.raiserequest rr ON
	rt.lrn = rr.lrn
	AND rr.locationid = rt.locationid
INNER JOIN registration.patient rp ON
	rp.uhid = rr.uhid
INNER JOIN ehis.vwr_lovdetail el ON
	rp.gender::NUMERIC = el.lovdetailid
INNER JOIN LAB.testmaster tm ON
	rt.testid = tm.testid
	--and tm.locationid = tp.locationid
INNER JOIN LAB.testparameter tp ON
	tp.testid = rt.testid
	AND tp.locationid = tm.locationid
INNER JOIN LAB.parametermastermainclone pm ON
	pm.parameterid = tp.parameterid
	AND pm.locationid = tp.locationid
INNER JOIN LAB.specimenmasterclone smc ON
	smc.specimenid = rt.sampletype
	--and smc.locationid = 11001
WHERE
	LIMT.TESTID = rt.testid
	AND rt.equipmentprocessing = 0
	AND rt.teststatus = 1
	AND rt.billingstatus = 1
	AND rt.preparesample = 'Y'
	AND rt.sampleverify = 'N'
	AND rt.samplecollected = 'Y'
	AND rt.processing = 'N'
	AND rt.typeofprocessing IN (323, 322, 1675)
	AND 
((tm.locationid IN ('17101')
		AND tm.locationid = pm.locationid
		AND tm.locationid = tp.locationid
		AND tm.locationid = rr.locationid )
	AND Current_database() IN ('ahsag'))
	AND rt.samplecollectedtime > current_date - 7
	--and rr.patientserviceno not like '%ANM%'
	AND tp.status = 1
	AND pm.status = 1
	AND LIMT.PARAMETERID = tp.parameterid
	-- from here added by steven based on oracle on 06/03/24 	
UNION ALL

SELECT
	DISTINCT LIMT.mst_equipment_id,
	limt.eqp_name,
	limt.eqp_param_ref_cd,
	LIMT.TESTID,
	LIMT.DEPARTMENT_ID,
	LIMT.IS_CALCULATED IS_CALCULATED,
	rr.uhid,
	rr.lrn,
	REPLACE( (SUBSTR((concat(rp.firstname, NULL) || ' ' || concat(rp.middlename, NULL) || ' ' || concat(rp.lastname, NULL)),
	1,
	20)),
	'  ',
	' ') PATIENTNAME
  ,
	el.lovdetaildescription SEX,
	(CASE
		WHEN COALESCE(rp.age,
		0) = 0 THEN
          (CASE
			WHEN (EXTRACT(YEAR
		FROM
			current_date) - EXTRACT(YEAR
		FROM
			RP.Birthdate)) = 0 THEN
          1
			ELSE
          (EXTRACT(YEAR
		FROM
			current_date) - EXTRACT(YEAR
		FROM
			RP.Birthdate))
		END)
		ELSE RP.age
	END)
       AGE,
	rp.birthdate DOB,
	REPLACE((SUBSTR( ( COALESCE((CASE
		WHEN RR.patientserviceNO NOT LIKE 'AHILIP%'
			AND RR.patientserviceNO NOT LIKE 'AHCCIP%' THEN
                       (
			SELECT
				COALESCE(DRE.FIRSTNAME, '') || ' ' || COALESCE(DRE.MIDDLENAME,
				'') || ' ' ||
                                COALESCE(DRE.LASTNAME,
				'') Doctor
			FROM
				hr.mv_employee_main_details DRE,
				billing.patientbill PB
			WHERE
				DRE.EMPLOYEEID = PB.primarydoctorid
				AND PB.locationid IN ('11001', '11002', '11201')
					AND PB.delflag = 1
					AND DRE.LOCATIONID IN ('11001', '11002', '11201')
						AND PB.patientidentifiernumber = RR.patientserviceno
						AND RR.LOCATIONID = PB.LOCATIONID )
			ELSE
                       (
			SELECT
				COALESCE(EE.FIRSTNAME, '') || ' ' || COALESCE(EE.MIDDLENAME,
				'') || ' ' ||
                               COALESCE(EE.LASTNAME,
				'') Doctor
			FROM
				hr.mv_employee_main_details ee,
				lab.raiserequest LRR,
				Adt.Inpatientmaster I
			WHERE
				LRR.Lrn = RR.lrn
				AND I.Inpatientno = LRR.Patientserviceno
				AND ee.EMPLOYEEID = I.Admittingdoctor
				AND LRR.Patientservice = 'IP'
				AND RR.patientserviceno = I.Inpatientno
				AND RR.LOCATIONID::NUMERIC = I.LOCATIONID)
		END),
	'NA') ),
	1,
	20) ),
	'  ',
	' ')
                     DOCTOR,
	REPLACE((SUBSTR( ( COALESCE((CASE
		WHEN RR.patientserviceNO NOT LIKE 'AHILIP%'
			AND RR.patientserviceNO NOT LIKE 'AHCCIP%' THEN
                       (
			SELECT
				(DRE.EMPLOYEEID)::text DoctorID
			FROM
				hr.mv_employee_main_details DRE,
				billing.patientbill PB
			WHERE
				DRE.EMPLOYEEID = PB.primarydoctorid
				AND PB.locationid IN ('11001', '11002', '11201')
					AND PB.delflag = 1
					AND DRE.LOCATIONID IN ('11001', '11002', '11201')
						AND PB.patientidentifiernumber = RR.patientserviceno
						AND RR.LOCATIONID = PB.LOCATIONID )
			ELSE
                       (
			SELECT
				(EE.EMPLOYEEID)::text DoctorID
			FROM
				hr.mv_employee_main_details ee,
				lab.raiserequest LRR,
				Adt.Inpatientmaster I
			WHERE
				LRR.Lrn = RR.lrn
				AND I.Inpatientno = LRR.Patientserviceno
				AND ee.EMPLOYEEID = I.Admittingdoctor
				AND LRR.Patientservice = 'IP'
				AND RR.patientserviceno = I.Inpatientno
				AND RR.LOCATIONID::NUMERIC = I.LOCATIONID)
		END),
	'NA') ),
	1,
	20) ),
	'  ',
	' ')
                     DOCTORID,
	--rp.age ,
	rt.departmentid ,
	rt.testid LIS_TESTID,
	tm.testname,
	tp.parameterid LIS_PARAMETERID,
	pm.parametername,
	rt.sin SINID,
	smc.specimenname SAMPLEID,
	rt.samplecollectedtime,
	rt.samplepreparetime,
	'0' STATUS,
	'' BILLID,
	rr.requesteddate REQUESTEDDATE,
	--rr.patientserviceno
	rr.patientserviceno patientserviceno1 ,
	(SUBSTR(rr.patientserviceno,
	5,
	2)|| '' || rr.lrn) patientserviceno
	--,rr.lrn patientserviceno
FROM
	labequip.vw_li_machine_testmaster_AHIL LIMT,
	LAB.requesttests rt
INNER JOIN LAB.raiserequest rr ON
	rt.lrn = rr.lrn
	AND rr.locationid = rt.locationid
INNER JOIN registration.patient rp ON
	rp.uhid = rr.uhid
INNER JOIN ehis.vwr_lovdetail el ON
	rp.gender::NUMERIC = el.lovdetailid
INNER JOIN LAB.testmaster tm ON
	rt.testid = tm.testid
	--and tm.locationid = tp.locationid
INNER JOIN LAB.testparameter tp ON
	tp.testid = rt.testid
	AND tp.locationid = tm.locationid
INNER JOIN LAB.parametermastermainclone pm ON
	pm.parameterid = tp.parameterid
	AND pm.locationid = tp.locationid
INNER JOIN LAB.specimenmasterclone smc ON
	smc.specimenid = rt.sampletype
	--and smc.locationid = 11001
WHERE
	LIMT.TESTID = rt.testid
	AND rt.equipmentprocessing = 0
	AND rt.teststatus = 1
	AND rt.billingstatus = 1
	AND rt.preparesample = 'Y'
	AND rt.sampleverify = 'N'
	AND rt.samplecollected = 'Y'
	AND rt.processing = 'N'
	AND rt.typeofprocessing IN (323, 322, 1675)
	AND (
tm.locationid IN ('11001', '11002', '11201')
		AND tm.locationid = pm.locationid
		AND tm.locationid = tp.locationid
		AND tm.locationid = rr.locationid
		AND Current_database() IN ('ehismum') )
	AND rt.samplecollectedtime > current_date - 7
	--and rr.patientserviceno not like '%ANM%'
	AND tp.status = 1
	AND pm.status = 1
	AND LIMT.PARAMETERID = tp.parameterid
UNION ALL

  SELECT
	DISTINCT LIMT.mst_equipment_id,
	limt.eqp_name,
	limt.eqp_param_ref_cd,
	LIMT.TESTID,
	LIMT.DEPARTMENT_ID,
	LIMT.IS_CALCULATED IS_CALCULATED,
	rr.uhid,
	rr.lrn,
	REPLACE( (SUBSTR((concat(rp.firstname, NULL) || ' ' || concat(rp.middlename, NULL) || ' ' || concat(rp.lastname, NULL)),
	1,
	20)),
	'  ',
	' ') PATIENTNAME
  ,
	el.lovdetaildescription SEX,
	(CASE
		WHEN COALESCE(rp.age,
		0) = 0 THEN
          (CASE
			WHEN (EXTRACT(YEAR
		FROM
			current_date) - EXTRACT(YEAR
		FROM
			RP.Birthdate)) = 0 THEN
          1
			ELSE
          (EXTRACT(YEAR
		FROM
			current_date) - EXTRACT(YEAR
		FROM
			RP.Birthdate))
		END)
		ELSE RP.age
	END)
       AGE,
	rp.birthdate DOB,
	REPLACE((SUBSTR( ( COALESCE((CASE
		WHEN RR.patientserviceNO NOT LIKE 'BSPIP%' THEN
                       (
		SELECT
			COALESCE(DRE.FIRSTNAME, '') || ' ' || COALESCE(DRE.MIDDLENAME,
			'') || ' ' ||
                                COALESCE(DRE.LASTNAME,
			'') Doctor
		FROM
			hr.Mv_employee_main_details DRE,
			billing.patientbill PB
		WHERE
			DRE.EMPLOYEEID = PB.primarydoctorid
			AND PB.locationid IN ('10501')
				AND PB.delflag = 1
				AND DRE.LOCATIONID IN ('10501')
					AND PB.patientidentifiernumber = RR.patientserviceno
					AND RR.LOCATIONID = PB.LOCATIONID )
		ELSE
                       (
		SELECT
			COALESCE(EE.FIRSTNAME, '') || ' ' || COALESCE(EE.MIDDLENAME,
			'') || ' ' ||
                               COALESCE(EE.LASTNAME,
			'') Doctor
		FROM
			hr.Mv_employee_main_details ee,
			lab.raiserequest LRR,
			Adt.Inpatientmaster I
		WHERE
			LRR.Lrn = RR.lrn
			AND I.Inpatientno = LRR.Patientserviceno
			AND ee.EMPLOYEEID = I.Admittingdoctor
			AND LRR.Patientservice = 'IP'
			AND RR.patientserviceno = I.Inpatientno
			AND RR.LOCATIONID = I.LOCATIONID::text)
	END),
	'NA') ),
	1,
	20) ),
	'  ',
	' ')
                     DOCTOR,
	REPLACE((SUBSTR( ( COALESCE((CASE
		WHEN RR.patientserviceNO NOT LIKE 'BSPIP%' THEN
                       (
		SELECT
			(DRE.EMPLOYEEID)::text DoctorID
		FROM
			hr.Mv_employee_main_details DRE,
			billing.patientbill PB
		WHERE
			DRE.EMPLOYEEID = PB.primarydoctorid
			AND PB.locationid IN ('10501')
				AND PB.delflag = 1
				AND DRE.LOCATIONID IN ('10501')
					AND PB.patientidentifiernumber = RR.patientserviceno
					AND RR.LOCATIONID = PB.LOCATIONID )
		ELSE
                       (
		SELECT
			(EE.EMPLOYEEID)::text DoctorID
		FROM
			hr.Mv_employee_main_details ee,
			lab.raiserequest LRR,
			Adt.Inpatientmaster I
		WHERE
			LRR.Lrn = RR.lrn
			AND I.Inpatientno = LRR.Patientserviceno
			AND ee.EMPLOYEEID = I.Admittingdoctor
			AND LRR.Patientservice = 'IP'
			AND RR.patientserviceno = I.Inpatientno
			AND RR.LOCATIONID = I.LOCATIONID::text)
	END),
	'NA') ),
	1,
	20) ),
	'  ',
	' ')
                     DOCTORID,
	--rp.age ,
	rt.departmentid ,
	rt.testid LIS_TESTID,
	tm.testname,
	tp.parameterid LIS_PARAMETERID,
	pm.parametername,
	rt.sin SINID,
	smc.specimenname SAMPLEID,
	rt.samplecollectedtime,
	rt.samplepreparetime,
	'0' STATUS,
	'' BILLID
,
	rr.requesteddate REQUESTEDDATE,
	--rr.patientserviceno
	rr.patientserviceno patientserviceno1 ,
	(SUBSTR(rr.patientserviceno,
	5,
	2)|| '' || rr.lrn) patientserviceno
	--,rr.lrn patientserviceno
FROM
	labequip.vw_li_machine_testmaster_AHIL LIMT,
	LAB.requesttests rt
INNER JOIN LAB.raiserequest rr ON
	rt.lrn = rr.lrn
	AND rr.locationid = rt.locationid
INNER JOIN registration.patient rp ON
	rp.uhid = rr.uhid
INNER JOIN ehis.vwr_lovdetail el ON
	rp.gender = el.lovdetailid::text
INNER JOIN LAB.testmaster tm ON
	rt.testid = tm.testid
	--and tm.locationid = tp.locationid
INNER JOIN LAB.testparameter tp ON
	tp.testid = rt.testid
	AND tp.locationid = tm.locationid
INNER JOIN LAB.parametermastermainclone pm ON
	pm.parameterid = tp.parameterid
	AND pm.locationid = tp.locationid
INNER JOIN LAB.specimenmasterclone smc ON
	smc.specimenid = rt.sampletype
WHERE
	LIMT.TESTID = rt.testid
	AND rt.equipmentprocessing = 0
	AND rt.teststatus = 1
	AND rt.billingstatus = 1
	AND rt.preparesample = 'Y'
	AND rt.sampleverify = 'N'
	AND rt.samplecollected = 'Y'
	AND rt.processing = 'N'
	AND rt.typeofprocessing IN (323, 322, 1675)
	AND tm.locationid IN ('10501')
	AND pm.locationid IN ('10501')
	AND tp.locationid IN ('10501')
	AND rr.locationid IN ('10501')
	AND UPPER(current_database()) IN ('EHISCHN')
	AND rt.samplecollectedtime > current_date - 7
	AND tp.status = 1
	AND pm.status = 1
	AND LIMT.PARAMETERID = tp.parameterid;
	
CREATE OR REPLACE VIEW MM.VW_CPR_INDENT_ISSUE
(X)
AS
select 'ehis';

CREATE OR REPLACE VIEW MM.VW_DAILYINV_VALUE_PROBLEM
(ITEMCODE,STORECODE,OB,OPENINGPRICE,CURRENTQTY,CURRENTPRICE,RECEIVEVALUE,RECEIVEQTY,ISSUEVALUE,ISSUEQTY,TRNRECEIPTVALUE,TRNISSUEVALUE)
AS
select 
d1.itemcode,
d1.storecode,
d1.qty as OB,
d1.avgprice as OpeningPrice,
d2.qty as currentqty,
d2.avgprice as CurrentPrice,
(select sum((d.reccon + d.recnoncon + d.receiveqty + d.returnackqty)*avgprice) from MM.dailyinventory d where d.itemcode = d1.itemcode and d.storecode= d1.storecode) as receiveValue,
(select sum((d.reccon + d.recnoncon + d.receiveqty + d.returnackqty)) from MM.dailyinventory d where d.itemcode = d1.itemcode and d.storecode= d1.storecode) as receiveQty,
(select sum((d.issueqty + d.returnqty + d.goodsreturnqty )*avgprice) from MM.dailyinventory d where d.itemcode = d1.itemcode and d.storecode= d1.storecode) as IssueValue,
(select sum((d.issueqty + d.returnqty + d.goodsreturnqty )) from MM.dailyinventory d where d.itemcode = d1.itemcode and d.storecode= d1.storecode) as IssueQty,

(   select 
    coalesce(sum(coalesce(rd.totalvalue,0)),0)
    from MM.receipts r
    inner join MM.receiptdetails rd on r.receiptid = rd.receiptid 
    where rd.itemcode = d1.itemcode and r.storecode = d1.storecode
      and r.srvcode is not null
      and r.statusid not in (5,99)
      and r.transactiontypeid = 3
      and r.createddate <= 
                           (
                       select max(updateddate)
                       from MM.dailyinventory l 
                       where l.itemcode = d1.itemcode
                         and l.storecode = d1.storecode
                       )

)as TrnReceiptValue,

(  
  select coalesce (sum(coalesce(std.itemvalue,0)),0)
  from MM.stocktransaction st
  inner join MM.stocktransactiondetails std on st.stocktransactionid = std.stocktransactionid
  where st.transactioncode in (2,4)
    and std.itemcode = d1.itemcode
    and st.storecode = d1.storecode
    and st.createddate <= (
                       select max(updateddate)
                       from MM.dailyinventory l 
                       where l.itemcode = d1.itemcode
                         and l.storecode = d1.storecode
                       )
    and st.status<>99
)as TrnIssueValue
from MM.dailyinventory d1
inner join MM.dailyinventory d2 on d1.itemcode = d2.itemcode and d1.storecode = d2.storecode
where d1.updateddate = '30-jun-2008'
  and d2.updateddate = (
                       select max(updateddate)
                       from MM.dailyinventory l 
                       where l.itemcode = d1.itemcode
                         and l.storecode = d1.storecode
                       )
   and d1.avgprice is not null
  /*
  select * from dailyinventory dd
  where dd.updateddate = '30-jun-2008'*/;

CREATE OR REPLACE VIEW MM.VW_DEPT_CAP_SRV
(NO,TRNDATE,VENDOR,TOTALVALUE,F2,F3,F6,F4,F5,F1,DCNUMBER,DCDATE,UOMDESC,ADDRESS,PRCODE,ITEMCODE,ITEMSHORTDESC,QTY,ADDITIONALCHARGEININVOICE)
AS
Select 
             r.srvcode As No
             ,to_char(r.createddate,'DD-MON-YYYY') As TrnDate
             ,v.vendorname As Vendor
             ,r.totalvalue As TotalValue
             ,r.Grncode As F2
             /*, CASE WHEN popr.storecode IS NULL THEN (select storename from store where store.storecode=popr.deptcode )
             ELSE s1.storename
             END As  F6
             */
            ,CASE WHEN 1 =1 THEN 'DEPARTMENT DIRECT CONSUMPTION'
             ELSE 'SRV DAY BOOK'
             END  AS F3

             ,(select s.storename from MM.popritems popr 
               inner join mm.vwr_store s on s.storecode = popr.storecode
               where popr.pocode  = r.srvcode limit 1
              )As  F6

             ,r.Pocode As F4
             ,p.ratecontractcode As F5
             ,rd.totalvalue as F1
             ,r.dcnumber,
             r.dcdate,
             (select uomdesc from mm.vwr_itemuom where  itemcode=ic.itemcode limit 1) as uomdesc,
             (SELECT t.VALUE FROM MM.installationinfo t WHERE t.key='CHENPRADDDRESS' ) AS Address,
   '' AS prcode ,
             rd.itemcode,
             ic.itemshortdesc,
             rd.qty,
       0 AS AdditionalChargeInInvoice
     from MM.receipts r
            INNER JOIN MM.receiptdetails rd ON rd.receiptid=r.receiptid 
                     and  r.transactiontypeid = 3   and r.pocode not like 'CPO%'
            INNER JOIN MM.VW_itemcompany ic ON ic.itemcode=rd.itemcode   and ic.itemtype in (1)
            inner join mm.vwr_vendor v on v.vendorcode =r.vendorcode
            --left outer JOIN popritems popr ON popr.pocode=r.srvcode and popr.itemcode = rd.itemcode
            inner join MM.po p on p.pocode = r.pocode  and p.statusid in (1,0,2,3)
            INNER JOIN mm.vwr_store s1 ON s1.storecode=r.storecode AND s1.Isdeptstore=1

           /*where 
                   r.createddate::date between  '1-oct-2008' and '31-oct-2008'*/;

CREATE OR REPLACE VIEW MM.VW_DEPT_GEN_SRV
(NO,TRNDATE,VENDOR,TOTALVALUE,F2,F3,F6,F4,F5,F1,DCNUMBER,DCDATE,UOMDESC,ADDRESS,PRCODE,ITEMCODE,ITEMSHORTDESC,QTY,ADDITIONALCHARGEININVOICE)
AS
Select 
             r.srvcode As No
             ,to_char(r.createddate,'DD-MON-YYYY') As TrnDate
             ,v.vendorname As Vendor
             ,r.totalvalue As TotalValue
             ,r.Grncode As F2
             /*, CASE WHEN popr.storecode IS NULL THEN (select storename from store where store.storecode=popr.deptcode )
             ELSE s1.storename
             END As  F6
             */
            ,CASE WHEN 1 =1 THEN 'DEPARTMENT DIRECT CONSUMPTION'
             ELSE 'SRV DAY BOOK'
             END  AS F3

             ,(select s.storename from MM.popritems popr 
               inner join mm.vwr_store s on s.storecode = popr.storecode
               where popr.pocode  = r.srvcode limit 1
              )As  F6

             ,r.Pocode As F4
             ,p.ratecontractcode As F5
             ,rd.totalvalue as F1
             ,r.dcnumber,
             r.dcdate,
             (select uomdesc from mm.vwr_itemuom where  itemcode=ic.itemcode limit 1) as uomdesc,
             (SELECT t.VALUE FROM MM.installationinfo t WHERE t.key='CHENPRADDDRESS' ) AS Address,
   '' AS prcode ,
             rd.itemcode,
             ic.itemshortdesc,
             rd.qty,
       0 AS AdditionalChargeInInvoice


      from MM.receipts r
            INNER JOIN MM.receiptdetails rd ON rd.receiptid=r.receiptid 
                     and  r.transactiontypeid = 3   and r.pocode not like 'CPO%'
            INNER JOIN MM.vw_itemcompany ic ON ic.itemcode=rd.itemcode   and ic.itemtype in (2,3)
            inner join mm.vwr_vendor v on v.vendorcode =r.vendorcode
            --left outer JOIN popritems popr ON popr.pocode=r.srvcode and popr.itemcode = rd.itemcode
            inner join MM.po p on p.pocode = r.pocode  and p.statusid in (1,0,2,3)
            INNER JOIN mm.vwr_store s1 ON s1.storecode=r.storecode AND s1.Isdeptstore=1

           /*where 
                   r.createddate::date between  '1-oct-2008' and '31-oct-2008'*/;

CREATE OR REPLACE VIEW MM.VW_ISSUE_NOT_UPDATED
(ISSUECODE,CREATEDDATE,STORECODE,ITEMCODE,QTY)
AS
select st.issuecode
,st.createddate
,st.storecode
,std.itemcode
,std.qty
 from MM.stocktransaction st
inner join MM.stocktransactiondetails std on st.stocktransactionid = std.stocktransactionid
where st.transactioncode = 2
  and st.createddate >=(select min(updateddate) from MM.inventorytracker)
except
select st.issuecode
,st.createddate
,st.storecode
,std.itemcode
,std.qty
 from MM.stocktransaction st
inner join MM.stocktransactiondetails std on st.stocktransactionid = std.stocktransactionid
inner join MM.inventorytracker inv on inv.transactioncode = st.issuecode and inv.itemcode = std.itemcode
where st.transactioncode = 2
group by st.issuecode
,st.createddate
,st.storecode
,std.itemcode
,std.qty;

CREATE OR REPLACE VIEW MM.VW_PO_HDR_VALUE_PROBLEM
(PROBLEM,POCODE,POID,BASEVALUE,LINEBVALUE,DISCVALUE,LINEDVALUE,TAXVALUE,LINETVALUE,TOTALVALUE,LINETOTALVALUE,ADDLCHARGE,SPECIALDISSCOUNT)
AS
select case
           when basevalue<>LineBValue then 'BASE'
           when round(discvalue)<> round(lineDValue) then 'DISC'
           when round(taxvalue)<>  round(lineTValue) then 'TAX'
           when round(totalvalue)<>  round(LineTotalValue+   coalesce(addlcharge,0) -    coalesce(specialdisscount,0)) then 'TOTAL'
       end AS PROBLEM
         ,t.POCODE,t.POID,t.BASEVALUE,t.LINEBVALUE,t.DISCVALUE,t.LINEDVALUE,t.TAXVALUE,t.LINETVALUE,t.TOTALVALUE,t.LINETOTALVALUE,t.ADDLCHARGE,t.SPECIALDISSCOUNT from
(
select p.pocode,p.poid
,p.basevalue,sum(pii.basicvalue)as LineBValue
,p.discvalue,sum(pii.discvalue)as lineDValue
,p.taxvalue,sum(pii.taxvalue)as lineTValue
,p.totalvalue,sum(pii.totalvalue) as LineTotalValue
,p.addlcharge
,p.specialdisscount
 from MM.po p
inner join MM.poitems pii on p.poid = pii.poid
group by p.pocode,p.poid
,p.basevalue,p.discvalue,p.taxvalue,p.totalvalue,p.addlcharge
,p.specialdisscount
)t where pocode is not null
         and
         (
        basevalue<>LineBValue
             or
        round(discvalue)<> round(lineDValue)
            or
        round(taxvalue)<>  round(lineTValue)
           or
        round(totalvalue)<>  round(LineTotalValue+   COALESCE(addlcharge,0) - coalesce(specialdisscount,0))
        );

CREATE OR REPLACE VIEW MM.VW_STORE_CAP_SRV
(NO,TRNDATE,VENDOR,TOTALVALUE,F2,F3,F6,F4,F5,F1,DCNUMBER,DCDATE,UOMDESC,ADDRESS,PRCODE,ITEMCODE,ITEMSHORTDESC,QTY,ADDITIONALCHARGEININVOICE)
AS
Select 
             r.srvcode As No
             ,to_char(r.createddate,'DD-MON-YYYY') As TrnDate
             ,v.vendorname As Vendor
             ,r.totalvalue As TotalValue
             ,r.Grncode As F2
             /*, CASE WHEN popr.storecode IS NULL THEN (select storename from store where store.storecode=popr.deptcode )
             ELSE s1.storename
             END As  F6
             */
            ,CASE WHEN 1 =1 THEN 'DEPARTMENT DIRECT CONSUMPTION'
             ELSE 'SRV DAY BOOK'
             END  AS F3

             ,(select s.storename from MM.popritems popr 
               inner join mm.vwr_store s on s.storecode = popr.storecode
               where popr.pocode  = r.srvcode limit 1
              )As  F6

             ,r.Pocode As F4
             ,p.ratecontractcode As F5
             ,rd.totalvalue as F1
             ,r.dcnumber,
             r.dcdate,
             (select uomdesc from mm.vwr_itemuom where  itemcode=ic.itemcode limit 1) as uomdesc,
             (SELECT t.VALUE FROM MM.installationinfo t WHERE t.key='CHENPRADDDRESS' ) AS Address,
   '' AS prcode ,
             rd.itemcode,
             ic.itemshortdesc,
             rd.qty,
       0 AS AdditionalChargeInInvoice
       from MM.receipts r
            INNER JOIN MM.receiptdetails rd ON rd.receiptid=r.receiptid 
                     and  r.transactiontypeid = 3   and r.pocode not like 'CPO%'
            INNER JOIN MM.vw_itemcompany ic ON ic.itemcode=rd.itemcode   and ic.itemtype in (1)
            inner join mm.vwr_vendor v on v.vendorcode =r.vendorcode
            --left outer JOIN popritems popr ON popr.pocode=r.srvcode and popr.itemcode = rd.itemcode
            inner join MM.po p on p.pocode = r.pocode  and p.statusid in (1,0,2,3)
            INNER JOIN mm.vwr_store s1 ON s1.storecode=r.storecode AND s1.Isdeptstore=0

           /*where 
                   r.createddate::date between  '1-oct-2008' and '31-oct-2008'*/;

CREATE OR REPLACE VIEW MM.VW_STORE_GEN_SRV
(NO,TRNDATE,VENDOR,TOTALVALUE,F2,F3,F6,F4,F5,F1,DCNUMBER,DCDATE,UOMDESC,ADDRESS,PRCODE,ITEMCODE,ITEMSHORTDESC,QTY,ADDITIONALCHARGEININVOICE)
AS
Select 
             r.srvcode As No
             ,to_char(r.createddate,'DD-MON-YYYY') As TrnDate
             ,v.vendorname As Vendor
             ,r.totalvalue As TotalValue
             ,r.Grncode As F2
             /*, CASE WHEN popr.storecode IS NULL THEN (select storename from store where store.storecode=popr.deptcode )
             ELSE s1.storename
             END As  F6
             */
            ,CASE WHEN 1 =1 THEN 'DEPARTMENT DIRECT CONSUMPTION'
             ELSE 'SRV DAY BOOK'
             END  AS F3

             ,(select s.storename from MM.popritems popr 
               inner join mm.vwr_store s on s.storecode = popr.storecode
               where popr.pocode  = r.srvcode limit 1
              )As  F6

             ,r.Pocode As F4
             ,p.ratecontractcode As F5
             ,rd.totalvalue as F1
             ,r.dcnumber,
             r.dcdate,
             (select uomdesc from mm.vwr_itemuom where  itemcode=ic.itemcode limit 1) as uomdesc,
             (SELECT t.VALUE FROM MM.installationinfo t WHERE t.key='CHENPRADDDRESS' ) AS Address,
   '' AS prcode ,
             rd.itemcode,
             ic.itemshortdesc,
             rd.qty,
       0 AS AdditionalChargeInInvoice
      from MM.receipts r
            INNER JOIN MM.receiptdetails rd ON rd.receiptid=r.receiptid 
                     and  r.transactiontypeid = 3   and r.pocode not like 'CPO%'
            INNER JOIN MM.vw_itemcompany ic ON ic.itemcode=rd.itemcode   and ic.itemtype in (2,3)
            inner join mm.vwr_vendor v on v.vendorcode =r.vendorcode
            --left outer JOIN popritems popr ON popr.pocode=r.srvcode and popr.itemcode = rd.itemcode
            inner join MM.po p on p.pocode = r.pocode  and p.statusid in (1,0,2,3)
            INNER JOIN mm.vwr_store s1 ON s1.storecode=r.storecode AND s1.Isdeptstore=0

           /*where 
                   r.createddate::date between  '1-oct-2008' and '31-oct-2008'*/;

CREATE OR REPLACE VIEW MM.VW_SUMSRVS
(ITEMCODE,SUMSRVS,STORENAME,STORECODE,CREATEDDATE,SRVCODE)
AS
select itemcode,coalesce(sum(coalesce(rd.qty,0)),0)as sumSRVs,s.storename,s.storecode,r.createddate,r.srvcode
                  from MM.receipts r inner join MM.receiptdetails rd on r.receiptid = rd.receiptid
                  inner join mm.vwr_store s on s.storecode = r.storecode
                  where  r.srvcode is not null
                   /* and r.transactiontypeid in( 3,5)*/
                     AND (
                             (r.transactiontypeid IN (3)and srvcode like 'SRV%'and pocode not like 'CPO%')
                                 or
                              (r.transactiontypeid IN (5)and srvcode like 'CSRV%')
                              ) and r.statusid not in (5,99)
  group by itemcode,s.storename,s.storecode,r.createddate,r.srvcode;

CREATE OR REPLACE VIEW MM.VW_SUM_ISSUES_RETURNS
(ITEMCODE,SUMISSUERETURN,STORENAME,STORECODE,CREATEDDATE,STOCKTRANSACTIONID,ISSUECODE,RETURNCODE)
AS
select itemcode,coalesce(sum(std.qty),0)as SumIssueReturn,s.storename,s.storecode,st.createddate
,st.stocktransactionid,st.issuecode,st.returncode
                from MM.stocktransaction st inner join MM.stocktransactiondetails std on st.stocktransactionid = std.stocktransactionid
                inner join mm.vwr_store s on s.storecode = st.storecode
                where st.transactioncode in (2,4)and st.status<>99
                  
  group by itemcode,s.storename,s.storecode,st.createddate,st.stocktransactionid,st.issuecode,st.returncode;

CREATE OR REPLACE VIEW MM.VW_SUM_RECEIPTS_RETURNSACKS
(ITEMCODE,SUMRECRETACK,STORENAME,STORECODE,CREATEDDATE,STOCKTRANSACTIONID,RECEIVEITEMCODE,RETURNCODE)
AS
select itemcode,coalesce(sum(std.qty),0)as SumRecRetAck,s.storename,s.storecode,st.createddate
,st.stocktransactionid ,st.receiveitemcode,st.returncode
                from MM.stocktransaction st inner join MM.stocktransactiondetails std on st.stocktransactionid = std.stocktransactionid
                inner join mm.vwr_store s on s.storecode = st.storecode
                where st.transactioncode in (3,5) and st.status<>99
  group by itemcode,s.storename,s.storecode,st.createddate,st.stocktransactionid ,st.receiveitemcode,st.returncode;

CREATE OR REPLACE VIEW PAYROLL.PAYROLL_HCMTRANSFORM_TEMP
(EMP_NO,ERN_CODE,AMOUNT,FROM_DATE,TO_DATE,STATUS,ERN_DEDFLAG,LOCATIONID,UPDATEDBY,UPLOAD,FILEID,INSERTED,CREATEDDATE)
AS
SELECT PHT.EMP_NO      EMP_NO,
       PHT.ERN_CODE    ERN_CODE,
       PHT.AMOUNT      AMOUNT,
       PHT.FROM_DATE   FROM_DATE,
       PHT.TO_DATE     TO_DATE,
       PHT.STATUS      STATUS,
       PHT.ERN_DEDFLAG ERN_DEDFLAG,
       PHT.LOCATIONID  LOCATIONID,
       PHT.UPDATEDBY   UPDATEDBY,
       PHT.UPLOAD      UPLOAD,
       PHT.FILEID      FILEID,
       PHT.INSERTED    INSERTED,
       PHT.CREATEDDATE CREATEDDATE
  FROM PAYROLL.PAYROLL_HCMTRANSFORM PHT
  where pht.LOCATIONID in (select distinct pecm.location_id from payroll.pay_ern_cd_mst pecm)
  AND PHT.FILEID NOT IN (SELECT DISTINCT PHTL.FILEID FROM PAYROLL.PAYROLL_HCMTRANSFORM PHTL);

CREATE OR REPLACE VIEW PAYROLL.V_LOCATION_MST
(MAPPINGID,REGIONID,REGIONNAME,CHARTID,LOCATIONNAME,LocationCode,MAPPINGSTATUS,UPDATEDBY,UPDATEDDATE)
AS
select mappingid,rmm.regionid ,rm.regionname,csd.chartid,csd.leveldetailname LocationName,
     csd.leveldetailcode LocationCode,mappingstatus, rmm.updatedby, rmm.updateddate
     from ehis.vwr_regionmappingmaster rmm
     inner join ehis.vwr_regionmaster rm
     on rmm.regionid=rm.regionid
     inner join ehis.vwr_coa_struct_details csd
     on rmm.chartid=csd.chartid
     where (rmm.status=1) and rm.regionid=4;

CREATE OR REPLACE VIEW PAYROLL.PAY_ESI_NO
(EMPLOYEEID,SOCIETYTHRIFT,ESI)
AS
select employeeid,max(case when accounttypename='SOCIETY THRIFT' then accountno end) SOCIETYTHRIFT,
max(case when accounttypename='ESI' then accountno end) ESI
from hr.vwr_emp_esi_no e
where e.status=1
group by employeeid;

CREATE OR REPLACE VIEW PAYROLL.PAY_EMP_PRM_HISTORY
(EMP_NO,EMP_CAT_CODE,EFF_FROM_DT,EFF_TO_DT,PRM_ARR_FLAG,USER_ID,UPDT,EMP_STAFFTYPE_CODE,EMP_GRADEID,EMP_POSITION_ID)
AS
SELECT EMP_NO,EMP_CAT_CODE,EFF_FROM_DT,EFF_TO_DT,PRM_ARR_FLAG,USER_ID,UPDT,EMP_STAFFTYPE_CODE,EMP_GRADE_ID EMP_GRADEID,EMP_POSITION_ID FROM HR.Emp_Prm_History_Update;

CREATE OR REPLACE VIEW PAYROLL.V_EMP_ARR_DTLS
(EMP_NO,ARR_FROM_DATE,ARR_TO_DATE)
AS
SELECT DISTINCT emp_no, from_date arr_from_date, to_date arr_to_date
  FROM payroll.pay_emp_earning
 WHERE ern_arr_flag = 'Y'
   AND STATUS = 1
/*and  amount <> 0*/
/*UNION ALL
SELECT DISTINCT empno ,
TO_DATE(FOR_MONTH||FOR_YEAR,'MONYYYY'),
LAST_DAY(TO_DATE(FOR_MONTH||FOR_YEAR,'MONYYYY'))
FROM  payroll.pay_emp_spl_allowances
WHERE ern_DED_arr_flg='Y'    AND STATUS = 1*/
UNION ALL
SELECT DISTINCT emp_no, from_date, to_date
  FROM payroll.pay_emp_ded
 WHERE ded_arr_flag = 'Y'
   AND STATUS = 1 /*and  amount <> 0*/ --- Changed by Debajyoti
/*UNION ALL
SELECT DISTINCT (EMD.EMPLOYEEID)::text,
a.FDA_FROMDT,
a.FDA_TODT
FROM   payroll.PAY_FDA_MST a,
HR.MV_EMPLOYEE_MAIN_DETAILS EMD
WHERE  a.FDA_ARR_FLAG='Y' AND A.STATUS = 1
and A.LOCATIONID=EMD.LOCATIONID
UNION ALL
SELECT DISTINCT TO_CHAR(EMD.EMPLOYEEID)::text,
a.FROM_DT,
a.TO_DT
FROM   payroll.PAY_VDA_MST a,
HR.MV_EMPLOYEE_MAIN_DETAILS EMD
WHERE  a.VDA_ARR_FLAG='Y' AND A.STATUS = 1
and A.LOCATIONID=EMD.LOCATIONID*/
UNION ALL
SELECT DISTINCT a.emp_no, a.EFF_FROM_DT, a.EFF_TO_DT
  FROM payroll.pay_emp_prm_history a
--hr.emp_prm_history_update a
 WHERE prm_arr_flag = 'Y'
UNION ALL
SELECT DISTINCT EMP_NO,
                TO_DATE(LEV_MONTH || LEV_YEAR, 'MONYYYY'),
                LAST_DAY(TO_DATE(a.LEV_MONTH || a.LEV_YEAR, 'MONYYYY'))
  FROM payroll.PAY_LEV_MONTHLY_REGISTER a
 WHERE A.STATUS = 1
   AND a.LEV_ARR_FLAG = 'Y'
UNION
SELECT PROC_EMP_NO, DATE1, LASTDATE
  FROM (SELECT PEP.PROC_EMP_NO,
               ADD_MONTHS(MAX(TO_DATE('01-' || PEP.PROC_MONTH || '-' ||
                                      PEP.PROC_YEAR)),
                          1) DATE1,
               LAST_DAY(ADD_MONTHS(MAX(TO_DATE('01-' || PEP.PROC_MONTH || '-' ||
                                               PEP.PROC_YEAR)),
                                   1)) LASTDATE
          FROM payroll.PAY_EMP_PROCESSES PEP
         GROUP BY PEP.PROC_EMP_NO) PEP,
       payroll.PAY_PROC_DATE PPD,
       hr.mv_employee_main_details PEM,
       hr.Vwr_EMPLOYEE_AUXILIARY_DETAILS ead
 WHERE PROC_EMP_NO::numeric = PEM.employeeid
   and ead.emp_id = PROC_EMP_NO::numeric
   and ead.STOPPAYMENT = 0
   AND PEM.LOCATIONID = PPD.LOCATIONID
   AND DATE1 < PPD.PROC_DATE
 ORDER BY 1, 2, 3;

CREATE OR REPLACE VIEW PAYROLL.V_EMP_PRM_HISTORY
(EMP_NO,EMP_CAT_CODE,EFF_FROM_DT,EFF_TO_DT,PRM_ARR_FLAG,USER_ID,UPDT,EMP_STAFFTYPE_CODE,EMP_GRADEID,EMP_POSITION_ID,DEPARTMENT,DESIGNATION)
AS
SELECT EMP_NO,
       EMP_CAT_CODE,
       EFF_FROM_DT,
       EFF_TO_DT,
       PRM_ARR_FLAG,
       USER_ID,
       UPDT,
       EMP_STAFFTYPE_CODE,
       EMP_GRADE_ID EMP_GRADEID,
       EMP_POSITION_ID,
       SUBSTR(EMP_POSITION_ID, 1, INSTR(EMP_POSITION_ID, '-')-1) AS Department,
       SUBSTR(EMP_POSITION_ID, INSTR(EMP_POSITION_ID, '-')+1) AS DESIGNATION
       FROM HR.Emp_Prm_History_Update;

CREATE OR replace VIEW PHARMACY.OP_PRESCRIPTION_NMUM_VW
(OPNUMBER,
UHID,
PATIENTNAME,
INDENTDATE,
DRUGID,
INDENTITEMDESC,
INDENTQTY,
DOCTORNAME,
PATIENTMOBILENUMBER,
LOCATIONID,
LOCATIONNAME)
AS
SELECT
	MR.Opnumber,
	opd.UHID,
	concat(RP.FIRSTNAME,
	NULL) || ' ' || concat(RP.MIDDLENAME,
	NULL) || ' ' || concat(RP.LASTNAME,
	NULL) AS PATIENTNAME,
	MR.CREATEDDATE AS INDENTDATE,
	mr.drugid,
	IC.ITEMSHORTDESC AS INDENTITEMDESC,
	MR.Quantity AS INDENTQTY,
	concat(HRE.FIRSTNAME,
	NULL) || ' ' || concat(HRE.MIDDLENAME,
	NULL) || ' ' || concat(HRE.LASTNAME,
	NULL) AS DOCTORNAME,
	ssd.mobilenumber AS patientmobilenumber,
	mr.locationid,
	sst.leveldetailname AS Locationname
FROM
	wards.opprescriptiondetails MR
INNER JOIN wards.opdetails opd ON
	opd.opdetailid = mr.opdetailid
INNER JOIN pharmacy.vwr_itemcompany IC ON
	IC.ITEMCODE = Mr.Drugid
JOIN REGISTRATION.PATIENT RP ON
	RP.UHID = opd.UHID
INNER JOIN registration.addressmaster ssd ON
	ssd.registrationid = rp.registrationid
LEFT OUTER JOIN HR.mv_EMPLOYEE_MAIN_DETAILS HRE ON
	HRE.EMPLOYEEID = mr.createdby::NUMERIC
INNER JOIN ehis.vwr_coa_struct_details sst ON
	sst.chartid = mr.locationid
WHERE
	mr.status = 1
	AND mr.locationid = '10551'
	AND MR.Quantity > 0
ORDER BY
	MR.OPNUMBER;

CREATE OR REPLACE VIEW PHARMACY.OP_PRESCRIPTION_VW
(OPNUMBER,UHID,PATIENTNAME,INDENTDATE,DRUGID,INDENTITEMDESC,INDENTQTY,DOCTORNAME,PATIENTMOBILENUMBER,LOCATIONID,LOCATIONNAME)
AS
SELECT MR.Opnumber,
opd.UHID, RP.FIRSTNAME || ' ' || RP.MIDDLENAME || ' ' || RP.LASTNAME AS PATIENTNAME,
MR.CREATEDDATE AS INDENTDATE, mr.drugid, IC.ITEMSHORTDESC AS INDENTITEMDESC,
MR.Quantity AS INDENTQTY, HRE.FIRSTNAME || ' ' || HRE.MIDDLENAME || ' ' || HRE.LASTNAME AS DOCTORNAME,
ssd.mobilenumber as patientmobilenumber, mr.locationid, sst.leveldetailname as Locationname
FROM wards.opprescriptiondetails MR
inner join wards.opdetails opd on opd.opdetailid = mr.opdetailid
INNER JOIN pharmacy.vwr_itemcompany IC ON IC.ITEMCODE = Mr.Drugid
JOIN REGISTRATION.PATIENT RP ON RP.UHID = opd.UHID
inner join registration.addressmaster ssd on ssd.registrationid=rp.registrationid
LEFT OUTER JOIN HR.MV_EMPLOYEE_MAIN_DETAILS HRE ON HRE.EMPLOYEEID = mr.createdby::numeric
inner join ehis.vwr_coa_struct_details sst on sst.chartid=mr.locationid
WHERE mr.status = 1 AND MR.Quantity > 0 ORDER BY MR.OPNUMBER;

CREATE OR REPLACE VIEW PHARMACY.VW_ISS_RET
(IPNO,VAL)
AS
select ipno,sum(IssueQty*IssueMrp - coalesce(RACKQty,0)*coalesce(RACKMrp,0)) val
from
(
select  ISS.storename, 
        ISS.INDENTCODE, 
        ISS.INDENTDATE, 
        ISS.IPNO, 
        ISS.ITEMCODE,         
        ISS.REQUESTEDQTY RequestedQty, 
        IC.Itemshortdesc, 
        ISS.issuecode, 
        ISS.REQUESTEDQTY IssueQty, 
        ISS.AVGBATPRICE  IssueMrp ,
        ISS.ISSUEDATE,
        coalesce(ret.QTY,0) RACKQty ,
        coalesce(ret.AVGRETBATPRICE,0) RACKMrp,
        RET.RackDate RackDate,
        (RP.FIRSTNAME || ' ' ||RP.MIDDLENAME|| ' ' ||RP.LASTNAME) AS PATIENTNAME 
from 
(
       select 
        mr.ipno,
        st.indentcode,
        ST.STORECODE,
        st.issuecode,
        std.itemcode,
        sum(bs.qty) REQUESTEDQTY,                      
        std.itemvalue,
        MR.CREATEDDATE AS INDENTDATE ,   
        ST.CREATEDDATE AS IssueDate,        
        O.STORENAME,    
        MR.UHID,              
        round(sum(bs.mrp*bs.qty)/sum(bs.qty),2) as AVGBATPRICE
 from PHARMACY.materialrequest mr  
 inner join PHARMACY.stocktransaction st on st.indentcode = mr.indentcode                
 inner join PHARMACY.stocktransactiondetails std on st.stocktransactionid = std.stocktransactionid 
 and st.transactioncode = 2
 inner join PHARMACY.batchserialitem bs on bs.stocktransactiondetailsid = std.stocktransactiondetailsid 
 and bs.itemcode = std.itemcode 
 and bs.transactiontypeid = 3
 Inner join pharmacy.vwr_store o on o.storecode=mr.storecode 
 group by mr.ipno,
        st.indentcode,
        ST.STORECODE,
        st.issuecode,
        std.itemcode,
        std.qty,
        std.itemvalue,
        MR.CREATEDDATE,
        ST.CREATEDDATE,        
        O.STORENAME,
        MR.UHID
)iss
inner join pharmacy.vwr_itemcompany ic on ic.ITEMCODE = ISS.ITEMCODE
/*left outer join
               (
               select std.qty
                     ,std.itemcode
                     ,str.issuecode
               from  stocktransaction str 
               inner join stocktransactiondetails std on str.stocktransactionid = std.stocktransactionid and str.transactioncode = 4               
               )retOnly on retOnly.itemcode = iss.itemcode and retOnly.issuecode = iss.issuecode                    
*/left outer join
               (
               select std.qty
                     ,std.itemcode
                     ,st.issuecode
                     ,ST.CREATEDDATE RackDate
                     ,round(sum(bs.mrp*bs.qty)/sum(bs.qty),2) as AVGRETBATPRICE
               from PHARMACY.stocktransaction st
               inner join PHARMACY.stocktransaction str on str.returncode = st.returncode and st.transactioncode =4
               inner join PHARMACY.stocktransactiondetails std on str.stocktransactionid = std.stocktransactionid and str.transactioncode = 5               

               inner join PHARMACY.batchserialitem bs on bs.stocktransactiondetailsid = std.stocktransactiondetailsid --std
                                       and bs.itemcode = std.itemcode --std
                                       and bs.transactiontypeid = 3
               group by 
                      std.qty
                     ,std.itemcode
                     ,st.issuecode
                     ,ST.CREATEDDATE 
               )ret on ret.itemcode = iss.itemcode and ret.issuecode = iss.issuecode
INNER JOIN REGISTRATION.PATIENT RP ON RP.UHID=ISS.UHID                
WHERE 
 ISS.RequestedQty> 0    
and ISS.STORECODE='11020151233'
and (iss.IssueDate between '15-dec-2009' and '1-jan-2010')
)stock group by ipno;

CREATE OR REPLACE VIEW PHARMACY.VW_RETLSUM
(IPNO,VAL)
AS
select  iss.ipno,sum(TotalIssueValue) - sum(coalesce(RTACKValue,0))as val
        from 
        (
               select 
                ST.STORECODE,
                std.itemcode,                
                sum(bs.mrp*bs.qty) as TotalIssueValue,
                mr.ipno
         from PHARMACY.materialrequest mr  
         inner join PHARMACY.stocktransaction st on st.indentcode = mr.indentcode /* and mr.ipno is not null */           
         inner join PHARMACY.stocktransactiondetails std on st.stocktransactionid = std.stocktransactionid 
                                                and st.transactioncode = 2 and st.createddate between '01-jan-2010' and '22-jan-2010'
         inner join PHARMACY.batchserialitem bs on bs.stocktransactiondetailsid = std.stocktransactiondetailsid 
                                       and bs.itemcode = std.itemcode 
                                       and bs.transactiontypeid = 3
         where instr(st.issuecode,'PMIS')>0 
           and st.storecode = '11020151233'
         group by ST.STORECODE,
                std.itemcode,
                mr.ipno
        )iss
        inner join pharmacy.vwr_itemcompany ic on ic.ITEMCODE = ISS.ITEMCODE
        left outer join
                       (
                       select 
                              std.itemcode
                             ,str.storecode 
                             ,sum(coalesce(bs.mrp,0)*coalesce(bs.qty,0))as RTACKValue
                             ,mr.ipno
                       from PHARMACY.stocktransaction st
                       inner join PHARMACY.stocktransaction str on str.returncode = st.returncode and st.transactioncode =4
                       inner join PHARMACY.materialrequest mr on mr.indentcode = st.indentcode
                       inner join PHARMACY.stocktransactiondetails std on str.stocktransactionid = std.stocktransactionid and str.transactioncode = 5 
                                                              --New fix
                                                              and (str.createddate between '01-jan-2010' and '22-jan-2010')
                       inner join PHARMACY.batchserialitem bs on bs.stocktransactiondetailsid = std.stocktransactiondetailsid --std
                                       and bs.itemcode = std.itemcode --std
                                       and bs.transactiontypeid = 3
                       where instr(st.issuecode,'PMIS')>0
                         and str.storecode = '11020151233' 
                       group by 
                             std.itemcode
                             ,str.storecode    
                             ,mr.ipno                         
                       )ret on ret.itemcode = iss.itemcode and ret.ipno = iss.ipno
group by iss.ipno;

CREATE OR REPLACE VIEW PHARMACY.VW_RETLSUM_ISSUE
(IPNO,TOTALISSUEVALUE)
AS
select 
       mr.ipno,
       sum(bs.mrp*bs.qty) as TotalIssueValue            
 from PHARMACY.materialrequest mr  
 inner join PHARMACY.stocktransaction st on st.indentcode = mr.indentcode 
 inner join PHARMACY.stocktransactiondetails std on st.stocktransactionid = std.stocktransactionid 
                                        and st.transactioncode = 2                                                 
 inner join PHARMACY.batchserialitem bs on bs.stocktransactiondetailsid = std.stocktransactiondetailsid 
                               and bs.itemcode = std.itemcode 
                               and bs.transactiontypeid = 3
 where instr(st.issuecode,'PMIS')>0 
   and st.storecode = '11020151233'
   and (st.createddate between '01-feb-2010' and '28-feb-2010')   
   and mr.ipno is not null        
 group by mr.ipno;

CREATE OR REPLACE VIEW PROCESS.MV_PROCESSFLOWTRANS_DIGITAL_V
(PROCESFLOWTRANSID,BUSINESSTRANSKEY)
AS
SELECT PROCESSFLOWTRANS.PROCESFLOWTRANSID
PROCESFLOWTRANSID,PROCESSFLOWTRANS.BUSINESSTRANSKEY BUSINESSTRANSKEY FROM
PROCESS.PROCESSFLOWTRANS PROCESSFLOWTRANS
WHERE PROCESSFLOWTRANS.PROCESSFLOWCODE='WK_FNB_01'
AND PROCESSFLOWTRANS.COMPLETED!='C';

CREATE OR REPLACE VIEW PROCESS.MV_PROCESSFLOWTRANS_FNB11
(PROCESFLOWTRANSID,PROCESSFLOWINSTANCEID,ACTIVITYCODE,STATUSID,WIPBY,SLA,CREATEDON,SERVICEID,STATUSUPDATEDON,WIPUPDATEDON,CREATEDBY,UPDATEDBY,COMPLETED,BUSINESSTRANSKEY,NOTIFYBYID,ALERTID,WORKFLOWSTATE,PROCESSFLOWID,ACTIVITYID,NOTIFYEMAILTEXT,NOTIFYSMSTEXT,NOTIFYDASHBOARDTEXT,ALERTEMAILTEXT,ALERTSMSTEXT,ALERTDASHBOARDTEXT,NOTIFIED,SLAUNIT,PROCESSFLOWCODE,UPDATEDON,COMPLETEDON,FLOWOWNERID,ALERTSENTFLAG,ESCALATIONSENTFLAG,WORKFLOWINITIATEDON,PREVIOUSTRANSID,NEXTTRANSID,TRANSIDXML,ASSIGNEDBY,ASSIGNEDDATE,ATTACHMENTS,TOOLTIPINFO)
AS
SELECT PROCESSFLOWTRANS.PROCESFLOWTRANSID     PROCESFLOWTRANSID,
       PROCESSFLOWTRANS.PROCESSFLOWINSTANCEID PROCESSFLOWINSTANCEID,
       PROCESSFLOWTRANS.ACTIVITYCODE          ACTIVITYCODE,
       PROCESSFLOWTRANS.STATUSID              STATUSID,
       PROCESSFLOWTRANS.WIPBY                 WIPBY,
       PROCESSFLOWTRANS.SLA                   SLA,
       PROCESSFLOWTRANS.CREATEDON             CREATEDON,
       PROCESSFLOWTRANS.SERVICEID             SERVICEID,
       PROCESSFLOWTRANS.STATUSUPDATEDON       STATUSUPDATEDON,
       PROCESSFLOWTRANS.WIPUPDATEDON          WIPUPDATEDON,
       PROCESSFLOWTRANS.CREATEDBY             CREATEDBY,
       PROCESSFLOWTRANS.UPDATEDBY             UPDATEDBY,
       PROCESSFLOWTRANS.COMPLETED             COMPLETED,
       PROCESSFLOWTRANS.BUSINESSTRANSKEY      BUSINESSTRANSKEY,
       PROCESSFLOWTRANS.NOTIFYBYID            NOTIFYBYID,
       PROCESSFLOWTRANS.ALERTID               ALERTID,
       PROCESSFLOWTRANS.WORKFLOWSTATE         WORKFLOWSTATE,
       PROCESSFLOWTRANS.PROCESSFLOWID         PROCESSFLOWID,
       PROCESSFLOWTRANS.ACTIVITYID            ACTIVITYID,
       PROCESSFLOWTRANS.NOTIFYEMAILTEXT       NOTIFYEMAILTEXT,
       PROCESSFLOWTRANS.NOTIFYSMSTEXT         NOTIFYSMSTEXT,
       PROCESSFLOWTRANS.NOTIFYDASHBOARDTEXT   NOTIFYDASHBOARDTEXT,
       PROCESSFLOWTRANS.ALERTEMAILTEXT        ALERTEMAILTEXT,
       PROCESSFLOWTRANS.ALERTSMSTEXT          ALERTSMSTEXT,
       PROCESSFLOWTRANS.ALERTDASHBOARDTEXT    ALERTDASHBOARDTEXT,
       PROCESSFLOWTRANS.NOTIFIED              NOTIFIED,
       PROCESSFLOWTRANS.SLAUNIT               SLAUNIT,
       PROCESSFLOWTRANS.PROCESSFLOWCODE       PROCESSFLOWCODE,
       PROCESSFLOWTRANS.UPDATEDON             UPDATEDON,
       PROCESSFLOWTRANS.COMPLETEDON           COMPLETEDON,
       PROCESSFLOWTRANS.FLOWOWNERID           FLOWOWNERID,
       PROCESSFLOWTRANS.ALERTSENTFLAG         ALERTSENTFLAG,
       PROCESSFLOWTRANS.ESCALATIONSENTFLAG    ESCALATIONSENTFLAG,
       PROCESSFLOWTRANS.WORKFLOWINITIATEDON   WORKFLOWINITIATEDON,
       PROCESSFLOWTRANS.PREVIOUSTRANSID       PREVIOUSTRANSID,
       PROCESSFLOWTRANS.NEXTTRANSID           NEXTTRANSID,
       PROCESSFLOWTRANS.TRANSIDXML            TRANSIDXML,
       PROCESSFLOWTRANS.ASSIGNEDBY            ASSIGNEDBY,
       PROCESSFLOWTRANS.ASSIGNEDDATE          ASSIGNEDDATE,
       PROCESSFLOWTRANS.ATTACHMENTS           ATTACHMENTS,
       PROCESSFLOWTRANS.TOOLTIPINFO           TOOLTIPINFO
  FROM PROCESS.PROCESSFLOWTRANS PROCESSFLOWTRANS
 WHERE PROCESSFLOWTRANS.PROCESSFLOWCODE = 'WK_FNB_01';

CREATE OR REPLACE VIEW PROCESS.MV_PROCESSFLOWTRANS_FNB22
(PROCESFLOWTRANSID,PROCESSFLOWINSTANCEID,ACTIVITYCODE,STATUSID,WIPBY,SLA,CREATEDON,SERVICEID,STATUSUPDATEDON,WIPUPDATEDON,CREATEDBY,UPDATEDBY,COMPLETED,BUSINESSTRANSKEY,NOTIFYBYID,ALERTID,WORKFLOWSTATE,PROCESSFLOWID,ACTIVITYID,NOTIFYEMAILTEXT,NOTIFYSMSTEXT,NOTIFYDASHBOARDTEXT,ALERTEMAILTEXT,ALERTSMSTEXT,ALERTDASHBOARDTEXT,NOTIFIED,SLAUNIT,PROCESSFLOWCODE,UPDATEDON,COMPLETEDON,FLOWOWNERID,ALERTSENTFLAG,ESCALATIONSENTFLAG,WORKFLOWINITIATEDON,PREVIOUSTRANSID,NEXTTRANSID,TRANSIDXML,ASSIGNEDBY,ASSIGNEDDATE,ATTACHMENTS,TOOLTIPINFO)
AS
SELECT PROCESSFLOWTRANS.PROCESFLOWTRANSID     PROCESFLOWTRANSID,
       PROCESSFLOWTRANS.PROCESSFLOWINSTANCEID PROCESSFLOWINSTANCEID,
       PROCESSFLOWTRANS.ACTIVITYCODE          ACTIVITYCODE,
       PROCESSFLOWTRANS.STATUSID              STATUSID,
       PROCESSFLOWTRANS.WIPBY                 WIPBY,
       PROCESSFLOWTRANS.SLA                   SLA,
       PROCESSFLOWTRANS.CREATEDON             CREATEDON,
       PROCESSFLOWTRANS.SERVICEID             SERVICEID,
       PROCESSFLOWTRANS.STATUSUPDATEDON       STATUSUPDATEDON,
       PROCESSFLOWTRANS.WIPUPDATEDON          WIPUPDATEDON,
       PROCESSFLOWTRANS.CREATEDBY             CREATEDBY,
       PROCESSFLOWTRANS.UPDATEDBY             UPDATEDBY,
       PROCESSFLOWTRANS.COMPLETED             COMPLETED,
       PROCESSFLOWTRANS.BUSINESSTRANSKEY      BUSINESSTRANSKEY,
       PROCESSFLOWTRANS.NOTIFYBYID            NOTIFYBYID,
       PROCESSFLOWTRANS.ALERTID               ALERTID,
       PROCESSFLOWTRANS.WORKFLOWSTATE         WORKFLOWSTATE,
       PROCESSFLOWTRANS.PROCESSFLOWID         PROCESSFLOWID,
       PROCESSFLOWTRANS.ACTIVITYID            ACTIVITYID,
       PROCESSFLOWTRANS.NOTIFYEMAILTEXT       NOTIFYEMAILTEXT,
       PROCESSFLOWTRANS.NOTIFYSMSTEXT         NOTIFYSMSTEXT,
       PROCESSFLOWTRANS.NOTIFYDASHBOARDTEXT   NOTIFYDASHBOARDTEXT,
       PROCESSFLOWTRANS.ALERTEMAILTEXT        ALERTEMAILTEXT,
       PROCESSFLOWTRANS.ALERTSMSTEXT          ALERTSMSTEXT,
       PROCESSFLOWTRANS.ALERTDASHBOARDTEXT    ALERTDASHBOARDTEXT,
       PROCESSFLOWTRANS.NOTIFIED              NOTIFIED,
       PROCESSFLOWTRANS.SLAUNIT               SLAUNIT,
       PROCESSFLOWTRANS.PROCESSFLOWCODE       PROCESSFLOWCODE,
       PROCESSFLOWTRANS.UPDATEDON             UPDATEDON,
       PROCESSFLOWTRANS.COMPLETEDON           COMPLETEDON,
       PROCESSFLOWTRANS.FLOWOWNERID           FLOWOWNERID,
       PROCESSFLOWTRANS.ALERTSENTFLAG         ALERTSENTFLAG,
       PROCESSFLOWTRANS.ESCALATIONSENTFLAG    ESCALATIONSENTFLAG,
       PROCESSFLOWTRANS.WORKFLOWINITIATEDON   WORKFLOWINITIATEDON,
       PROCESSFLOWTRANS.PREVIOUSTRANSID       PREVIOUSTRANSID,
       PROCESSFLOWTRANS.NEXTTRANSID           NEXTTRANSID,
       PROCESSFLOWTRANS.TRANSIDXML            TRANSIDXML,
       PROCESSFLOWTRANS.ASSIGNEDBY            ASSIGNEDBY,
       PROCESSFLOWTRANS.ASSIGNEDDATE          ASSIGNEDDATE,
       PROCESSFLOWTRANS.ATTACHMENTS           ATTACHMENTS,
       PROCESSFLOWTRANS.TOOLTIPINFO           TOOLTIPINFO
  FROM PROCESS.PROCESSFLOWTRANS PROCESSFLOWTRANS
 WHERE PROCESSFLOWTRANS.PROCESSFLOWCODE = 'WK_FNB_01'
   AND PROCESSFLOWTRANS.COMPLETED = 'N';

CREATE OR REPLACE VIEW PROCESS.MV_PROCESSFLOWTRANS_FNB33
(PROCESFLOWTRANSID,PROCESSFLOWINSTANCEID,ACTIVITYCODE,STATUSID,WIPBY,SLA,CREATEDON,SERVICEID,STATUSUPDATEDON,WIPUPDATEDON,CREATEDBY,UPDATEDBY,COMPLETED,BUSINESSTRANSKEY,NOTIFYBYID,ALERTID,WORKFLOWSTATE,PROCESSFLOWID,ACTIVITYID,NOTIFYEMAILTEXT,NOTIFYSMSTEXT,NOTIFYDASHBOARDTEXT,ALERTEMAILTEXT,ALERTSMSTEXT,ALERTDASHBOARDTEXT,NOTIFIED,SLAUNIT,PROCESSFLOWCODE,UPDATEDON,COMPLETEDON,FLOWOWNERID,ALERTSENTFLAG,ESCALATIONSENTFLAG,WORKFLOWINITIATEDON,PREVIOUSTRANSID,NEXTTRANSID,TRANSIDXML,ASSIGNEDBY,ASSIGNEDDATE,ATTACHMENTS,TOOLTIPINFO)
AS
SELECT PROCESSFLOWTRANS.PROCESFLOWTRANSID     PROCESFLOWTRANSID,
       PROCESSFLOWTRANS.PROCESSFLOWINSTANCEID PROCESSFLOWINSTANCEID,
       PROCESSFLOWTRANS.ACTIVITYCODE          ACTIVITYCODE,
       PROCESSFLOWTRANS.STATUSID              STATUSID,
       PROCESSFLOWTRANS.WIPBY                 WIPBY,
       PROCESSFLOWTRANS.SLA                   SLA,
       PROCESSFLOWTRANS.CREATEDON             CREATEDON,
       PROCESSFLOWTRANS.SERVICEID             SERVICEID,
       PROCESSFLOWTRANS.STATUSUPDATEDON       STATUSUPDATEDON,
       PROCESSFLOWTRANS.WIPUPDATEDON          WIPUPDATEDON,
       PROCESSFLOWTRANS.CREATEDBY             CREATEDBY,
       PROCESSFLOWTRANS.UPDATEDBY             UPDATEDBY,
       PROCESSFLOWTRANS.COMPLETED             COMPLETED,
       PROCESSFLOWTRANS.BUSINESSTRANSKEY      BUSINESSTRANSKEY,
       PROCESSFLOWTRANS.NOTIFYBYID            NOTIFYBYID,
       PROCESSFLOWTRANS.ALERTID               ALERTID,
       PROCESSFLOWTRANS.WORKFLOWSTATE         WORKFLOWSTATE,
       PROCESSFLOWTRANS.PROCESSFLOWID         PROCESSFLOWID,
       PROCESSFLOWTRANS.ACTIVITYID            ACTIVITYID,
       PROCESSFLOWTRANS.NOTIFYEMAILTEXT       NOTIFYEMAILTEXT,
       PROCESSFLOWTRANS.NOTIFYSMSTEXT         NOTIFYSMSTEXT,
       PROCESSFLOWTRANS.NOTIFYDASHBOARDTEXT   NOTIFYDASHBOARDTEXT,
       PROCESSFLOWTRANS.ALERTEMAILTEXT        ALERTEMAILTEXT,
       PROCESSFLOWTRANS.ALERTSMSTEXT          ALERTSMSTEXT,
       PROCESSFLOWTRANS.ALERTDASHBOARDTEXT    ALERTDASHBOARDTEXT,
       PROCESSFLOWTRANS.NOTIFIED              NOTIFIED,
       PROCESSFLOWTRANS.SLAUNIT               SLAUNIT,
       PROCESSFLOWTRANS.PROCESSFLOWCODE       PROCESSFLOWCODE,
       PROCESSFLOWTRANS.UPDATEDON             UPDATEDON,
       PROCESSFLOWTRANS.COMPLETEDON           COMPLETEDON,
       PROCESSFLOWTRANS.FLOWOWNERID           FLOWOWNERID,
       PROCESSFLOWTRANS.ALERTSENTFLAG         ALERTSENTFLAG,
       PROCESSFLOWTRANS.ESCALATIONSENTFLAG    ESCALATIONSENTFLAG,
       PROCESSFLOWTRANS.WORKFLOWINITIATEDON   WORKFLOWINITIATEDON,
       PROCESSFLOWTRANS.PREVIOUSTRANSID       PREVIOUSTRANSID,
       PROCESSFLOWTRANS.NEXTTRANSID           NEXTTRANSID,
       PROCESSFLOWTRANS.TRANSIDXML            TRANSIDXML,
       PROCESSFLOWTRANS.ASSIGNEDBY            ASSIGNEDBY,
       PROCESSFLOWTRANS.ASSIGNEDDATE          ASSIGNEDDATE,
       PROCESSFLOWTRANS.ATTACHMENTS           ATTACHMENTS,
       PROCESSFLOWTRANS.TOOLTIPINFO           TOOLTIPINFO
  FROM PROCESS.PROCESSFLOWTRANS PROCESSFLOWTRANS
 WHERE PROCESSFLOWTRANS.PROCESSFLOWCODE = 'WK_FNB_01'
   AND PROCESSFLOWTRANS.COMPLETED = 'N'
   AND (PROCESSFLOWTRANS.NOTIFYSMSTEXT = 'M' OR
       PROCESSFLOWTRANS.NOTIFYSMSTEXT = 'T' OR
       PROCESSFLOWTRANS.NOTIFYSMSTEXT = 'N');

CREATE OR REPLACE VIEW PROCESS.MV_PROCESSFLOWTRANS_FNBV
(PROCESFLOWTRANSID,PROCESSFLOWINSTANCEID,ACTIVITYCODE,STATUSID,WIPBY,SLA,CREATEDON,SERVICEID,STATUSUPDATEDON,WIPUPDATEDON,CREATEDBY,UPDATEDBY,COMPLETED,BUSINESSTRANSKEY,NOTIFYBYID,ALERTID,WORKFLOWSTATE,PROCESSFLOWID,ACTIVITYID,NOTIFYEMAILTEXT,NOTIFYSMSTEXT,NOTIFYDASHBOARDTEXT,ALERTEMAILTEXT,ALERTSMSTEXT,ALERTDASHBOARDTEXT,NOTIFIED,SLAUNIT,PROCESSFLOWCODE,UPDATEDON,COMPLETEDON,FLOWOWNERID,ALERTSENTFLAG,ESCALATIONSENTFLAG,WORKFLOWINITIATEDON,PREVIOUSTRANSID,NEXTTRANSID,TRANSIDXML,ASSIGNEDBY,ASSIGNEDDATE,ATTACHMENTS,TOOLTIPINFO)
AS
SELECT PROCESSFLOWTRANS.PROCESFLOWTRANSID     PROCESFLOWTRANSID,
       PROCESSFLOWTRANS.PROCESSFLOWINSTANCEID PROCESSFLOWINSTANCEID,
       PROCESSFLOWTRANS.ACTIVITYCODE          ACTIVITYCODE,
       PROCESSFLOWTRANS.STATUSID              STATUSID,
       PROCESSFLOWTRANS.WIPBY                 WIPBY,
       PROCESSFLOWTRANS.SLA                   SLA,
       PROCESSFLOWTRANS.CREATEDON             CREATEDON,
       PROCESSFLOWTRANS.SERVICEID             SERVICEID,
       PROCESSFLOWTRANS.STATUSUPDATEDON       STATUSUPDATEDON,
       PROCESSFLOWTRANS.WIPUPDATEDON          WIPUPDATEDON,
       PROCESSFLOWTRANS.CREATEDBY             CREATEDBY,
       PROCESSFLOWTRANS.UPDATEDBY             UPDATEDBY,
       PROCESSFLOWTRANS.COMPLETED             COMPLETED,
       PROCESSFLOWTRANS.BUSINESSTRANSKEY      BUSINESSTRANSKEY,
       PROCESSFLOWTRANS.NOTIFYBYID            NOTIFYBYID,
       PROCESSFLOWTRANS.ALERTID               ALERTID,
       PROCESSFLOWTRANS.WORKFLOWSTATE         WORKFLOWSTATE,
       PROCESSFLOWTRANS.PROCESSFLOWID         PROCESSFLOWID,
       PROCESSFLOWTRANS.ACTIVITYID            ACTIVITYID,
       PROCESSFLOWTRANS.NOTIFYEMAILTEXT       NOTIFYEMAILTEXT,
       PROCESSFLOWTRANS.NOTIFYSMSTEXT         NOTIFYSMSTEXT,
       PROCESSFLOWTRANS.NOTIFYDASHBOARDTEXT   NOTIFYDASHBOARDTEXT,
       PROCESSFLOWTRANS.ALERTEMAILTEXT        ALERTEMAILTEXT,
       PROCESSFLOWTRANS.ALERTSMSTEXT          ALERTSMSTEXT,
       PROCESSFLOWTRANS.ALERTDASHBOARDTEXT    ALERTDASHBOARDTEXT,
       PROCESSFLOWTRANS.NOTIFIED              NOTIFIED,
       PROCESSFLOWTRANS.SLAUNIT               SLAUNIT,
       PROCESSFLOWTRANS.PROCESSFLOWCODE       PROCESSFLOWCODE,
       PROCESSFLOWTRANS.UPDATEDON             UPDATEDON,
       PROCESSFLOWTRANS.COMPLETEDON           COMPLETEDON,
       PROCESSFLOWTRANS.FLOWOWNERID           FLOWOWNERID,
       PROCESSFLOWTRANS.ALERTSENTFLAG         ALERTSENTFLAG,
       PROCESSFLOWTRANS.ESCALATIONSENTFLAG    ESCALATIONSENTFLAG,
       PROCESSFLOWTRANS.WORKFLOWINITIATEDON   WORKFLOWINITIATEDON,
       PROCESSFLOWTRANS.PREVIOUSTRANSID       PREVIOUSTRANSID,
       PROCESSFLOWTRANS.NEXTTRANSID           NEXTTRANSID,
       PROCESSFLOWTRANS.TRANSIDXML            TRANSIDXML,
       PROCESSFLOWTRANS.ASSIGNEDBY            ASSIGNEDBY,
       PROCESSFLOWTRANS.ASSIGNEDDATE          ASSIGNEDDATE,
       PROCESSFLOWTRANS.ATTACHMENTS           ATTACHMENTS,
       PROCESSFLOWTRANS.TOOLTIPINFO           TOOLTIPINFO
  FROM PROCESS.PROCESSFLOWTRANS PROCESSFLOWTRANS
 WHERE PROCESSFLOWTRANS.PROCESSFLOWCODE = 'WK_FNB_01'
   AND PROCESSFLOWTRANS.COMPLETED = 'N';

CREATE OR REPLACE VIEW PROCESS.ROLEMASTER
(ROLEID,ROLENAME,BUSINESSMODULEID,LOCATIONID)
AS
select ROLEID,ROLENAME,BUSINESSMODULEID,LOCATIONID from securitytest_64.rolemaster;

CREATE OR REPLACE VIEW PROCESS.USERMASTER
(USERID,EMPLOYEEID,EMPLOYEECODE,TITLEID,FIRSTNAME,MIDDLENAME,LASTNAME,GENDERID,DOB,MARITALSTATUSID,BIRTHCOUNTRYID,NATIONALITYID,PHYSICALLYHANDICAPPED,SUPERVISORID,COMPANYID,LOCATIONID,DEPARTMENTID,COSTCENTERID,MAINCOSTCENTERID,PAYROLLACCOUNTINGAREAID,EMPLOYEELEVELID,EMPLOYEECATEGORYID,EMPLOYEETYPEID,DESIGNATIONID,GRADEID,LAST_SALARY,ADDRESS_TYPE,EMPLOYMENTSTATUSID,STATUS,CREATEDBY,CREATEDDATE,UPDATEDBY,UPDATEDDATE,FLEXIFIELD1,FLEXIFIELD2,PRESENTEMPLOYEEID,LOGINID,SPECIALITYID,EMAILID,CALENDARPRIVILEGES,SCHEDULABLE,SPECIALIZEDSERVICES)
AS
select EMPLOYEEID as USERID,EMPLOYEEID,EMPLOYEECODE,TITLEID,FIRSTNAME,MIDDLENAME,LASTNAME,GENDERID,DOB,MARITALSTATUSID,BIRTHCOUNTRYID,NATIONALITYID,PHYSICALLYHANDICAPPED,SUPERVISORID,COMPANYID,LOCATIONID,DEPARTMENTID,COSTCENTERID,MAINCOSTCENTERID,PAYROLLACCOUNTINGAREAID,EMPLOYEELEVELID,EMPLOYEECATEGORYID,EMPLOYEETYPEID,DESIGNATIONID,GRADEID,LAST_SALARY,ADDRESS_TYPE,EMPLOYMENTSTATUSID,STATUS,CREATEDBY,CREATEDDATE,UPDATEDBY,UPDATEDDATE,FLEXIFIELD1,FLEXIFIELD2,PRESENTEMPLOYEEID,LOGINID,SPECIALITYID,EMAILID,CALENDARPRIVILEGES,SCHEDULABLE,SPECIALIZEDSERVICES from hr.mv_employee_main_details;

CREATE OR REPLACE VIEW PROCESS.USERROLE
(USERID,ROLEID,LOCATIONID)
AS
select USERID,ROLEID,LOCATIONID from  securitytest_64.userroles;

CREATE OR REPLACE VIEW RADIOLOGY.RADIOLOGY_SEQUENCES_VW
(RAD_TBL_NAME,RAD_TBL_SEQ_NAME)
AS
SELECT 'RADDEPTMDLMASTER' rad_tbl_name, 'RAD_DEPTMDLMASTER_SEQ' rad_tbl_seq_name union all
SELECT 'RADEQUIPMENTMASTER' rad_tbl_name, 'RAD_EQUIPMENTMASTER_SEQ' rad_tbl_seq_name union all
SELECT 'RADLOGINMDLMASTER' rad_tbl_name, 'RAD_LOGINMDLMASTER_SEQ' rad_tbl_seq_name union all
SELECT 'RADLOVDETAILMASTER' rad_tbl_name, 'RAD_LOVDETAILMASTER_SEQ' rad_tbl_seq_name union all
SELECT 'RADLOVMASTER' rad_tbl_name, 'RAD_LOVMASTER_SEQ' rad_tbl_seq_name union all
SELECT 'RADMEDICALCERTIFICATE' rad_tbl_name, 'RAD_MEDICALCERTIFICATE_SEQ' rad_tbl_seq_name union all
SELECT 'RADOPTIONMASTER' rad_tbl_name, 'RAD_OPTIONMASTER_SEQ' rad_tbl_seq_name union all
SELECT 'RADPARAMETERDETAILMASTER' rad_tbl_name, 'RAD_PARAMETERDETAILMASTER_SEQ' rad_tbl_seq_name union all
SELECT 'RADPARAMETEROPTIONSMASTER' rad_tbl_name, 'RAD_PARAMETEROPTIONSMASTER_SEQ' rad_tbl_seq_name union all
SELECT 'RADPARAMMASTER' rad_tbl_name, 'RAD_PARAMMASTER_SEQ' rad_tbl_seq_name union all
SELECT 'RADPHYSICALLOCATIONMSTR' rad_tbl_name, 'RAD_PHYSICALLOCATIONMSTR_SEQ' rad_tbl_seq_name union all
SELECT 'RADPREPARATIONMASTER' rad_tbl_name, 'RAD_PREPARATIONMASTER_SEQ' rad_tbl_seq_name union all
SELECT 'RADPREREQUISITEMASTER' rad_tbl_name, 'RAD_PREREQUISITEMASTER_SEQ' rad_tbl_seq_name union all
SELECT 'RADRESULTCOLMASTER' rad_tbl_name, 'RAD_RESULTCOLMASTER_SEQ' rad_tbl_seq_name union all
SELECT 'RADRESULTROWHDRMASTER' rad_tbl_name, 'RAD_RESULTROWHDRMASTER_SEQ' rad_tbl_seq_name union all
SELECT 'RADRESULTTBLDTLMSTR' rad_tbl_name, 'RAD_RESULTTBLDTLMSTR_SEQ' rad_tbl_seq_name union all
SELECT 'RADRESULTTBLMSTR' rad_tbl_name, 'RAD_RESULTTBLMSTR_SEQ' rad_tbl_seq_name union all
SELECT 'RADSERVICEDRUGMASTER' rad_tbl_name, 'RAD_RADSERVICEDRUGMASTER_SEQ' rad_tbl_seq_name union all
SELECT 'RADSERVICEEQPMNTMASTER' rad_tbl_name, 'RAD_RADSERVICEEQPMTNMASTER_SEQ' rad_tbl_seq_name union all
SELECT 'RADSERVICEITEMMASTER' rad_tbl_name, 'RAD_RADSERVICEITEMMASTER_SEQ' rad_tbl_seq_name union all
SELECT 'RADSERVICEMASTER' rad_tbl_name, 'RAD_RADSERVICEMASTER_SEQ' rad_tbl_seq_name union all
SELECT 'RADSERVICEPARAMETERMASTER' rad_tbl_name, 'RAD_SERVICEPARAMETERMASTER_SEQ' rad_tbl_seq_name union all
SELECT 'RADSERVICESTUDYMASTER' rad_tbl_name, 'RAD_SERVICESTUDYMASTER_SEQ' rad_tbl_seq_name union all
SELECT 'RADSTATUSCONFIGMASTER' rad_tbl_name, 'RAD_STATUSCONFIGMASTER_SEQ' rad_tbl_seq_name union all
SELECT 'RADSTUDYGROUPMASTER' rad_tbl_name, 'RAD_STUDYGROUPMASTER_SEQ' rad_tbl_seq_name union all
SELECT 'RADSTUDYTYPEMASTER' rad_tbl_name, 'RAD_STUDYTYPEMASTER_SEQ' rad_tbl_seq_name union all
SELECT 'RADSUBSTUDYMASTER' rad_tbl_name, 'RAD_SUBSSTUDYMASTER_SEQ' rad_tbl_seq_name union all
SELECT 'RADUNITMASTER' rad_tbl_name, 'RAD_UNITMASTER_SEQ' rad_tbl_seq_name union all
SELECT 'RADANESREQUEST' rad_tbl_name, 'RAD_ANESREQUEST_SEQ' rad_tbl_seq_name union all
SELECT 'RADEXPOSURE' rad_tbl_name, 'RAD_EXPOSURE_SEQ' rad_tbl_seq_name union all
SELECT 'RADPREPPREQUISITES' rad_tbl_name, 'RAD_PREPPREQUISITES_SEQ' rad_tbl_seq_name union all
SELECT 'RADRECURRINGTEST' rad_tbl_name, 'RAD_RERECURRINGTST_SEQ' rad_tbl_seq_name union all
SELECT 'RADREQUESTDTLS' rad_tbl_name, 'RAD_REQUESTDTLS_SEQ' rad_tbl_seq_name union all
SELECT 'RADREQUESTHDR' rad_tbl_name, 'RAD_REQUESTHDR_SEQ' rad_tbl_seq_name union all
SELECT 'RADRESULTREPORTDTLS' rad_tbl_name, 'RAD_RSLTRPTDTLS_SEQ' rad_tbl_seq_name union all
SELECT 'RADRESULTREPORTHDR' rad_tbl_name, 'RAD_RSLTRPTHDR_SEQ' rad_tbl_seq_name union all
SELECT 'RADRESULTTBLDTLS' rad_tbl_name, 'RAD_RESULTTBLDTLS_SEQ' rad_tbl_seq_name union all
SELECT 'RADRSLTFLMDISPATCH' rad_tbl_name, 'RAD_RSLTFLMDISPATCH_SEQ' rad_tbl_seq_name union all
SELECT 'RADSRVCFLMUSAGE' rad_tbl_name, 'RAD_SRVCFLMUSAGE_SEQ' rad_tbl_seq_name union all
SELECT 'RADSRVCITEMSCONS' rad_tbl_name, 'RAD_SRVCITEMCONS_SEQ' rad_tbl_seq_name union all
SELECT 'RADSTATUSTIMES' rad_tbl_name, 'RAD_RADSTATUSTIMES_SEQ' rad_tbl_seq_name union all
SELECT 'RADUSERQUICKLIST' rad_tbl_name, 'RAD_USERQUICKLIST_SEQ' rad_tbl_seq_name union all
SELECT 'RADRADIOACTIVEMTRLDISCARD' rad_tbl_name, 'RAD_RADIOACTIVEMTRLDISCARD_SEQ' rad_tbl_seq_name union all
SELECT 'RADAREAMONITORINGHDR' rad_tbl_name,'RAD_AREAMONITORINGHDR_SEQ' rad_tbl_seq_name union all
SELECT 'RADAREAMONITORINGDTLS' rad_tbl_name,'RAD_AREAMONITORINGDTL_SEQ' rad_tbl_seq_name union all
SELECT 'RADRADIOACTIVEMTRLMASTER' rad_tbl_name,'RAD_RADIOACTIVEMTRL_SEQ' rad_tbl_seq_name UNION ALL
SELECT 'RADEXPOSUREPOINTMSTR' rad_tbl_name, 'RAD_EXPOSUREPOINT_SEQ' rad_tbl_seq_name union all
SELECT 'RADINSTRUMENTMSTR' rad_tbl_name, 'RAD_INSTRUMENT_SEQ' rad_tbl_seq_name union all
SELECT 'RADSIGNATUREDETAILS' rad_tbl_name,'RAD_RADSIGNATUREDETAILS_SEQ' rad_tbl_seq_name union all
SELECT 'RADUSERSCRPRIVSMASTER' rad_tbl_name,'RAD_USERSCRPRIVSMASTER_SEQ' rad_tbl_seq_name UNION ALL
SELECT 'RADDEPTSPECIALITIES' rad_tbl_name,'RAD_DEPTSPECIALITIES_SEQ' rad_tbl_seq_name ;

CREATE OR REPLACE VIEW RADIOLOGY.RADREQUESTDTLS_PACS_HL7
(REQUESTDTLID,REGISTRATIONID,UHID,PIDASGNAUTHORITY,PATIENTNAME,FIRSTNAME,MIDDLENAME,LASTNAME,PATIENTNAMETYPECODE,BIRTHDATE,GENDER,MOBILE_NUMBER,EMAILID,PATIENTNO,PATIENTTYPE,PATIENTCLASS,LOCATION,LOCATIONNAME,PACCNOASGNAUTHORITY,VISITASGNAUTHORITY,ORDERTYPE,ORDERSTATUS,NAMESPACEID,REQUESTID,DRN,ACCESSIONNO,SERVICEID,SERVICENAME,RQSTDDATETIME,MODALITY,SCHEDULESTATION,ENTRYDATE,DOCTORID,DOCTORNAME,PATIENTBILL,PATIENTTITLE,PATIENTLOCATION,BEDNUMBER,ORDERNUMBER,REFERRINGPHYSICANTITLE,REFERRINGPHYSICANNAME)
AS
SELECT RRD.REQUESTDTLID
       , PT.REGISTRATIONID
       , PT.UHID
       , 'PI' AS PIDASGNAUTHORITY
       , SUBSTR(PT.FIRSTNAME || ' ' || PT.MIDDLENAME  || ' ' || PT.LASTNAME, 0 ,64) AS PATIENTNAME
       , SUBSTR(PT.FIRSTNAME, 0, 30) AS FIRSTNAME
       , SUBSTR(PT.MIDDLENAME, 0, 30) AS MIDDLENAME
       , SUBSTR(PT.LASTNAME, 0 ,30) AS LASTNAME
       , 'L' AS PATIENTNAMETYPECODE
       , PT.BIRTHDATE
       , PT.GENDER
       , ADM.MOBILENUMBER AS MOBILE_NUMBER
       , PT.EMAILID AS EMAILID
       , RRH.PATIENTNO
       , RRH.PATIENTTYPE
       , CASE RRH.PATIENTTYPE
         WHEN 'IP' THEN 'I'
         ELSE 'O'
         END AS PATIENTCLASS
       , RRH.LOCATIONID AS LOCATION
       , LM.LOCATIONNAME AS LOCATIONNAME
       , 'AN' AS PACCNOASGNAUTHORITY
       , 'VN' AS VISITASGNAUTHORITY
       , CASE
         WHEN RRD.ISBILLED = 'N'  THEN NULL
         WHEN RRD.ISBILLED = 'Y' THEN
              CASE STAT.STATUSVALUE
              WHEN 'CANCELLED' THEN 'CA'
              ELSE 'NW'
              END
         ELSE NULL
         END AS ORDERTYPE
       , CASE
         WHEN RRD.ISBILLED = 'N'  THEN NULL
         WHEN RRD.ISBILLED = 'Y' THEN
              CASE STAT.STATUSVALUE
              WHEN 'CANCELLED' THEN 'CA'
              ELSE NULL
              END
         ELSE NULL
         END AS ORDERSTATUS
       , 'CCGPLOR' AS NAMESPACEID
       , RRD.REQUESTID
       , RRD.DRN
       , RRD.ACCESSIONNO
       , BSM.SERVICEID
       , BSM.SERVICENAME
       , RRD.RQSTDDATETIME
       , CASE
         WHEN MODT.HL7MODCODE IS NULL THEN 'OT'
         ELSE MODT.HL7MODCODE
         END AS MODALITY
       , CASE
         WHEN MODT.SCHEDULESTATION IS NULL THEN MODT.HL7MODCODE
         ELSE MODT.SCHEDULESTATION
         END AS SCHEDULESTATION
       , CURRENT_DATE AS ENTRYDATE
       , RADIOLOGY.FN_GETPATIENTDOCTORID(RRH.PATIENTNO, RRH.PATIENTTYPE, RRH.LOCATIONID) AS DOCTORID
       , RADIOLOGY.FN_GETPATIENTDOCTORNAME(RRH.PATIENTNO, RRH.PATIENTTYPE, RRH.LOCATIONID) AS DOCTORNAME
       , (CASE RRH.PATIENTTYPE
           WHEN 'IP' THEN
            RRH.PATIENTNO
           ELSE
            (SELECT PB.BILLNO
               FROM BILLING.PATIENTBILL PB
              WHERE PB.PATIENTIDENTIFIERNUMBER = RRH.PATIENTNO limit 1)
         END) PATIENTBILL,
            ---------------New Field Added For Hl7--------------------------------------------------------
         TM.TITLETYPE AS PATIENTTITLE,
        (CASE
        WHEN RRH.PATIENTTYPE = 'IP' THEN
                          HL7.PKG_HL7_UTIL_F_GET_WARDFORPATIENT(RRH.PATIENTNO)
                          ELSE
                           RRH.PATIENTTYPE
                        END) PATIENTLOCATION,
HL7.PKG_HL7_UTIL_F_GET_BEDNUMBER(RRH.PATIENTNO)AS BEDNUMBER,
RRD.DRN AS ORDERNUMBER,
(CASE
                          WHEN RRH.PATIENTTYPE = 'IP' THEN
                           HL7.PKG_HL7_UTIL_F_GETTITLEFORPRIMARYDOC(RRH.PATIENTNO,
                                                                    RRH.LOCATIONID)
                          ELSE
                           HL7.PKG_HL7_UTIL_FN_GETTITELFORREFERRALDOC(RRH.PATIENTNO,
                                                                   RRH.LOCATIONID)
                        END) AS REFERRINGPHYSICANTITLE,



                         (CASE
                          WHEN RRH.PATIENTTYPE = 'IP' THEN
                           HL7.PKG_HL7_UTIL_F_GETPRIMARYSECDOCTOR(RRH.PATIENTNO,
                                                                    RRH.LOCATIONID)
                          ELSE
                             HL7.PKG_HL7_UTIL_FN_GETREFERRALPHYSICAN(RRH.PATIENTNO,
                                                                   RRH.LOCATIONID)
                        END) AS REFERRINGPHYSICANNAME
   FROM RADIOLOGY.RADREQUESTDTLS RRD
       INNER JOIN RADIOLOGY.RADREQUESTHDR RRH ON RRH.REQUESTID = RRD.REQUESTID
       INNER JOIN RADIOLOGY.RADSERVICEMASTER RSM ON RRD.RADSERVICEID = RSM.RADSERVICEID AND RSM.STATUS = 1
       INNER JOIN RADIOLOGY.RADDEPTMDLMASTER RDMM ON RSM.DEPTMDLID = RDMM.DEPTMDLID AND RDMM.STATUS = 1
       INNER JOIN (SELECT S_RLDM.LOVDETAILID AS STATUSID, S_RLDM.LOVDETAILNAME AS STATUSVALUE
                      FROM RADIOLOGY.RADLOVDETAILMASTER S_RLDM
                           INNER JOIN RADIOLOGY.RADLOVMASTER S_RLM ON S_RLM.LOVID = S_RLDM.LOVID
                      WHERE UPPER(S_RLM.LOVCODE) = 'RAD_STATUSES' AND S_RLDM.STATUS = 1) STAT ON RRD.SRVCSTATUS = STAT.STATUSID
       LEFT OUTER JOIN HL7.HL7_RAD_MODMAPPING MODT ON MODT.RADMODID = RDMM.MDLLOVDTLID AND RDMM.LOCATIONID = MODT.LOCATIONID
       INNER JOIN BILLING.VW_SERVICEMASTER BSM ON BSM.LOCATIONID = RRH.LOCATIONID AND BSM.SERVICEID = RSM.SERVICEID
       INNER JOIN REGISTRATION.PATIENT PT ON RRH.UHID = PT.UHID
       INNER JOIN REGISTRATION.ADDRESSMASTER ADM ON ADM.REGISTRATIONID = PT.REGISTRATIONID
       INNER JOIN SECURITYTEST_64.LOCATIONMASTER LM ON LM.LOCATIONID = RRH.LOCATIONID
       LEFT OUTER JOIN ehis.vwr_titlemaster TM ON TM.TITLEID =PT.TITLE::numeric;

CREATE OR REPLACE VIEW RADIOLOGY.RADRESULTDTLS_PACS_HL7
(REQUESTDTLID,RSLTRPTHDRID,AUTHORIZEDDATE,OBSERVATIONVALUE,RESULTSTATUS,VALUETYPE,AUTHORIZEDBY,AUTHORIZEDBYNAME,REPORTEDBY,REPORTEDBYNAME,REPORTEDBY_1,REPORTEDBY_1NAME)
AS
SELECT RH.REQUESTDTLID,
       RH.RSLTRPTHDRID,
       RH.AUTHORIZEDDATE,
       RADIOLOGY.F_GETOBSERVATION(RH.RSLTRPTHDRID) AS OBSERVATIONVALUE,
       'F' AS RESULTSTATUS,
       'TX' AS VALUETYPE,
       RH.AUTHORIZEDBY,
       RADIOLOGY.F_GETEMPLOYEENAME(RH.AUTHORIZEDBY::numeric) AS AUTHORIZEDBYNAME,
       RH.REPORTEDBY,
       RADIOLOGY.F_GETEMPLOYEENAME(RH.REPORTEDBY::numeric) REPORTEDBYNAME,
       RH.REPORTEDBY_1,
       RADIOLOGY.F_GETEMPLOYEENAME(RH.REPORTEDBY_1::numeric) REPORTEDBY_1NAME
  FROM RADIOLOGY.RADRESULTREPORTHDR RH
 WHERE VERSIONNO IN (SELECT MAX(VERSIONNO)
                       FROM RADIOLOGY.RADRESULTREPORTHDR
                      WHERE REQUESTDTLID = RH.REQUESTDTLID);

CREATE OR REPLACE VIEW REGISTRATION.AGREEMENTS
(AGREEMENTID,AGREEMENTCODE,AGREEMENTNAME)
AS
SELECT AG.AGREEMENTID,AG.AGREEMENTCODE,AG.AGREEMENTNAME
   FROM   crm.vwr_agreements  AG;

CREATE OR REPLACE VIEW REGISTRATION.CRMCORPORATEMASTER
(CUSTOMERID,CUSTOMERNAME)
AS
select CUSTOMERID,CUSTOMERNAME
from crm.vwr_customers cs
   where cs.customertypeid=4;

CREATE OR REPLACE VIEW REGISTRATION.CRMCUSTOMERS
(CUSTOMERID,CUSTOMERNAME)
AS
select CUSTOMERID,CUSTOMERNAME
from crm.vwr_customers cs;

CREATE OR REPLACE VIEW REGISTRATION.FMS_IPDETAILS
(INPATIENTNO,UHID,BEDNUMBER,DOCTORNAME,SPECIALITYNAME,WARDNAME,DATEOFADMISSION,DISCHARGEDATE,LOCATIONID)
AS
select im.inpatientno AS INPATIENTNO,
im.uhid,
bm.bedcode AS BEDNUMBER,
ad.ADMITTINGDOCTORNAME As DoctorName,
sm.speciality_name As SPECIALITYNAME,
ld.leveldetailname As WARDNAME,
im.dateofadmission As DATEOFADMISSION,
im.dischargedate AS DISCHARGEDATE,
im.locationid
 from adt.inpatientmaster im
 inner join adt.bedmaster bm on bm.bedid=
 (select bedid from adt.bedadmission ba where ba.bedtransactionid=
 (select max(ba1.bedtransactionid)
 from adt.bedadmission ba1 where ba1.inpatientid=im.inpatientid ))
 inner join adt.admittingdoctor ad on ad.ADMITTINGDOCTORID=im.admittingdoctor
 inner join hr.mv_employee_main_details emd on emd.employeeid=ad.ADMITTINGDOCTORID
 inner join ehis.vwr_specialitymaster sm on sm.speciality_id=emd.specialityid
 inner join adt.leveldetail ld on ld.leveldetailid=bm.leveldetailid;

CREATE OR REPLACE VIEW REGISTRATION.FMS_IPDETAILS1
(INPATIENTNO,UHID,BEDNUMBER,DOCTORNAME,SPECIALITYNAME,WARDNAME,DATEOFADMISSION,DISCHARGEDATE,LOCATIONID)
AS
select im.inpatientno AS INPATIENTNO,
im.uhid,
bm.bedcode AS BEDNUMBER,
ad.ADMITTINGDOCTORNAME As DoctorName,
sm.speciality_name As SPECIALITYNAME,
ld.leveldetailname As WARDNAME,
im.dateofadmission As DATEOFADMISSION,
im.dischargedate AS DISCHARGEDATE,
im.locationid
 from adt.inpatientmaster im
 inner join adt.bedmaster bm on bm.bedid=
 (select bedid from adt.bedadmission ba where ba.bedtransactionid=
 (select max(ba1.bedtransactionid)
 from adt.bedadmission ba1 where ba1.inpatientid=im.inpatientid ))
 inner join adt.admittingdoctor ad on ad.ADMITTINGDOCTORID=im.admittingdoctor
 inner join hr.mv_employee_main_details emd on emd.employeeid=ad.ADMITTINGDOCTORID
 inner join ehis.vwr_specialitymaster sm on sm.speciality_id=emd.specialityid
 inner join adt.leveldetail ld on ld.leveldetailid=bm.leveldetailid
 where im.dateofadmission::date >= (current_date - 365);

CREATE OR REPLACE VIEW REGISTRATION.FMS_REGDETAILS
(REGISTRATIONNO,PATIENTNAME,BIRTHDAY,CONTACTNUMBER,EMAIL,LOCATIONID,ANNIVERSARY_DATE)
AS
select p.uhid AS REGISTRATIONNO,
tm.titletype ||''||p.firstname||''||p.middlename||''||p.lastname
As PatientName,
p.birthdate AS BIRTHDAY,
case when ad.mobilenumber is not null then
  ad.mobilenumber
  when ad.emergencynumber is not null then
    ad.emergencynumber
    else
      ad.residencenumber
      end
      As CONTACTNUMBER,
      p.emailid AS EMAIL,
      p.locationid AS LocationID, ' ' as ANNIVERSARY_DATE
from registration.patient p
inner join ehis.vwr_titlemaster tm on tm.titleid=p.title::numeric
inner join registration.addressmaster ad on ad.addresstypeid=2 and
 ad.registrationid=p.registrationid;

CREATE OR REPLACE VIEW REGISTRATION.mv_ent_patient_details
as
select
	ENT_PATIENT_DTLS.REGISTRATIONID REGISTRATIONID,
	ENT_PATIENT_DTLS.PREREGISTRATIONNO PREREGISTRATIONNO,
	ENT_PATIENT_DTLS.UHID UHID,
	ENT_PATIENT_DTLS.LOCATIONID LOCATIONID,
	ENT_PATIENT_DTLS.TITLE TITLE,
	ENT_PATIENT_DTLS.SUFIX SUFIX,
	ENT_PATIENT_DTLS.FIRSTNAME FIRSTNAME,
	ENT_PATIENT_DTLS.MIDDLENAME MIDDLENAME,
	ENT_PATIENT_DTLS.LASTNAME LASTNAME,
	ENT_PATIENT_DTLS.ALIASNAME ALIASNAME,
	ENT_PATIENT_DTLS.BIRTHDATE BIRTHDATE,
	ENT_PATIENT_DTLS.AGE AGE,
	ENT_PATIENT_DTLS.GENDER GENDER,
	ENT_PATIENT_DTLS.MARITALSTATUS MARITALSTATUS,
	ENT_PATIENT_DTLS.FATHERNAME FATHERNAME,
	ENT_PATIENT_DTLS.SPOUSENAME SPOUSENAME,
	ENT_PATIENT_DTLS.MOTHERMAIDENNAME MOTHERMAIDENNAME,
	ENT_PATIENT_DTLS.GAURDIANNAME GAURDIANNAME,
	ENT_PATIENT_DTLS.PATIENTTYPE PATIENTTYPE,
	ENT_PATIENT_DTLS.STATUS STATUS,
	ENT_PATIENT_DTLS.OLDUHID OLDUHID,
	ENT_PATIENT_DTLS.FLAG FLAG,
	ENT_PATIENT_DTLS.REGULARIZATIONDATE REGULARIZATIONDATE,
	ENT_PATIENT_DTLS.REGULARIZATIONCHECK REGULARIZATIONCHECK,
	ENT_PATIENT_DTLS.COUNTRY COUNTRY,
	ENT_PATIENT_DTLS.STATE STATE,
	ENT_PATIENT_DTLS.DISTRICT DISTRICT,
	ENT_PATIENT_DTLS.CITY CITY,
	ENT_PATIENT_DTLS.ADDRESS1 ADDRESS1,
	ENT_PATIENT_DTLS.ADDRESS2 ADDRESS2,
	ENT_PATIENT_DTLS.PRIMARYEMAIL PRIMARYEMAIL,
	ENT_PATIENT_DTLS.PINCODE PINCODE,
	ENT_PATIENT_DTLS.RESIDENCENUMBER RESIDENCENUMBER,
	ENT_PATIENT_DTLS.MOBILENUMBER MOBILENUMBER,
	ENT_PATIENT_DTLS.EMERGENCYNUMBER EMERGENCYNUMBER,
	ENT_PATIENT_DTLS.ERN ERN,
	ENT_PATIENT_DTLS.PRIVACYSTATUS PRIVACYSTATUS,
	ENT_PATIENT_DTLS.NATIONALITY NATIONALITY,
	ENT_PATIENT_DTLS.INTERNATIONALPATIENT INTERNATIONALPATIENT,
	ENT_PATIENT_DTLS.COUNTRYISSUED COUNTRYISSUED,
	ENT_PATIENT_DTLS.PASSPORTNUMBER PASSPORTNUMBER,
	ENT_PATIENT_DTLS.PASSPORTISSUEDATE PASSPORTISSUEDATE,
	ENT_PATIENT_DTLS.PASSPORTEXPIRYDATE PASSPORTEXPIRYDATE,
	ENT_PATIENT_DTLS.VISATYPE VISATYPE,
	ENT_PATIENT_DTLS.VISAISSUINGAUTHORITY VISAISSUINGAUTHORITY,
	ENT_PATIENT_DTLS.VISAISSUEDATE VISAISSUEDATE,
	ENT_PATIENT_DTLS.VISAEXPIRYDATE VISAEXPIRYDATE,
	ENT_PATIENT_DTLS.ALLERGIC ALLERGIC,
	ENT_PATIENT_DTLS.BLOODGROUP BLOODGROUP,
	ENT_PATIENT_DTLS.CREATEDBY CREATEDBY,
	ENT_PATIENT_DTLS.CREATEDDATE CREATEDDATE,
	ENT_PATIENT_DTLS.UPDATEDBY UPDATEDBY,
	ENT_PATIENT_DTLS.UPDATEDDATE UPDATEDDATE,
	ENT_PATIENT_DTLS.RUNREFRESHDATE RUNREFRESHDATE,
	ENT_PATIENT_DTLS.CUSTOMERSTATUS CUSTOMERSTATUS,
	ENT_PATIENT_DTLS.NOOFISSUES NOOFISSUES,
	ENT_PATIENT_DTLS.CITIZENSHIP CITIZENSHIP,
	ENT_PATIENT_DTLS.POSSESSPASSPORT POSSESSPASSPORT,
	ENT_PATIENT_DTLS.RHFACTOR RHFACTOR,
	ENT_PATIENT_DTLS.BASELOCATION BASELOCATION,
	ENT_PATIENT_DTLS.TRANSFERDATE TRANSFERDATE
from
	registration.vwr_ent_patient_dtls ENT_PATIENT_DTLS;

create or replace view registration.mv_ent_patient_uid as
select *
from registration.vwr_ent_patient_uid;

CREATE OR REPLACE VIEW REGISTRATION.MV_ENT_PATIENT_DTLS
(REGISTRATIONID,PREREGISTRATIONNO,UHID,LOCATIONID,TITLE,SUFIX,FIRSTNAME,MIDDLENAME,LASTNAME,ALIASNAME,BIRTHDATE,AGE,GENDER,MARITALSTATUS,FATHERNAME,SPOUSENAME,MOTHERMAIDENNAME,GAURDIANNAME,PATIENTTYPE,STATUS,OLDUHID,FLAG,REGULARIZATIONDATE,REGULARIZATIONCHECK,COUNTRY,STATE,DISTRICT,CITY,ADDRESS1,ADDRESS2,EMAILID,PINCODE,RESIDENCENUMBER,MOBILENUMBER,EMERGENCYNUMBER,ERN,PRIVACYSTATUS,NATIONALITY,INTERNATIONALPATIENT,COUNTRYISSUED,PASSPORTNUMBER,PASSPORTISSUEDATE,PASSPORTEXPIRYDATE,VISATYPE,VISAISSUINGAUTHORITY,VISAISSUEDATE,VISAEXPIRYDATE,ALLERGIC,BLOODGROUP,CREATEDBY,CREATEDDATE,UPDATEDBY,UPDATEDDATE,RUNREFRESHDATE,CUSTOMERSTATUS,NOOFISSUES,CITIZENSHIP,POSSESSPASSPORT,RHFACTOR,BASELOCATION,TRANSFERDATE,UIDTYPE,UIDNUMBER,UIDSTATUS,UIDUPDATEDDATE,UIDUPDATEDBY)
AS
select   epd.REGISTRATIONID,epd.PREREGISTRATIONNO,epd.UHID,epd.LOCATIONID,
epd.TITLE,epd.SUFIX,epd.FIRSTNAME,epd.MIDDLENAME,epd.LASTNAME,epd.ALIASNAME,
epd.BIRTHDATE,epd.AGE,epd.GENDER,epd.MARITALSTATUS,epd.FATHERNAME,epd.SPOUSENAME,
epd.MOTHERMAIDENNAME,epd.GAURDIANNAME,epd.PATIENTTYPE,epd.STATUS,epd.OLDUHID,epd.FLAG,
epd.REGULARIZATIONDATE,epd.REGULARIZATIONCHECK,epd.COUNTRY,epd.STATE,epd.DISTRICT,epd.CITY
,epd.ADDRESS1,epd.ADDRESS2,epd.PRIMARYEMAIL as emailid,epd.PINCODE,epd.RESIDENCENUMBER,epd.MOBILENUMBER,epd.EMERGENCYNUMBER,epd.ERN,epd.PRIVACYSTATUS,epd.NATIONALITY,epd.INTERNATIONALPATIENT,epd.COUNTRYISSUED,epd.PASSPORTNUMBER,epd.PASSPORTISSUEDATE,epd.PASSPORTEXPIRYDATE,epd.VISATYPE,epd.VISAISSUINGAUTHORITY,epd.VISAISSUEDATE,epd.VISAEXPIRYDATE,epd.ALLERGIC,epd.BLOODGROUP,epd.CREATEDBY,epd.CREATEDDATE,epd.UPDATEDBY,epd.UPDATEDDATE,epd.RUNREFRESHDATE,epd.CUSTOMERSTATUS,epd.NOOFISSUES,epd.CITIZENSHIP,epd.POSSESSPASSPORT,epd.RHFACTOR,epd.BASELOCATION,epd.TRANSFERDATE,epu.uidtype,epu.uidnumber ,epu.status as uidstatus,
       epu.updateddate as uidupdateddate,epu.updatedby as uidupdatedby
from  registration.mv_ent_patient_details epd
left outer join registration.mv_ent_patient_uid epu
     on epu.registrationid = epd.registrationid;

CREATE OR REPLACE VIEW SECURITYTEST_64.USERMASTER
(USERID,EMPLOYEEID,LOGINID,FIRSTNAME,MIDDLENAME,LASTNAME,LOCATIONID)
AS
select
em.employeeid as userid,
em.employeeid as employeeid,
em.loginid,
em.firstname,
em.middlename,
em.lastname,
em.locationid
from hr.mv_employee_main_details em;

CREATE OR REPLACE VIEW TIMECARD.LVM_SEQUENCES_VW
(LVM_TBL_NAME,LVM_TBL_SEQ_NAME)
AS
SELECT 'LVM_LEAVEREQUESTDTLS'  AS LVM_TBL_NAME,'LVRQSTDETAILID_SEQ' AS LVM_TBL_SEQ_NAME
UNION ALL
SELECT 'LVM_LEAVEREQUEST'  AS LVM_TBL_NAME,'LEAVEREQUESTID_SEQ' AS LVM_TBL_SEQ_NAME
UNION ALL
SELECT 'LVM_ENCASHMNTREQUEST' AS LVM_TBL_NAME,'LVM_ENCASHMNTRQSTID_SEQ' AS  LVM_TBL_SEQ_NAME
UNION ALL
SELECT 'LVM_LOPCLAIMREQUEST' AS LVM_TBL_NAME,'LVM_LOPCLAIMREQUESTID_SEQ' AS  LVM_TBL_SEQ_NAME
UNION ALL
/*SELECT 'LVM_LOPCLAIMREQUEST' AS LVM_TBL_NAME,'LVM_WRKFLWTRANSACTION_ID_SEQ' AS  LVM_TBL_SEQ_NAME
UNION ALL*/
SELECT 'LVM_WRKFLW_TRANS' AS LVM_TBL_NAME,'LVM_WRKFLW_TRANS_SEQ' AS  LVM_TBL_SEQ_NAME
UNION ALL
SELECT 'LVM_WRKFLW_TRANS_DTLS' AS LVM_TBL_NAME,'LVM_WRKFLW_TRANS_DTLS_SEQ' AS  LVM_TBL_SEQ_NAME
UNION ALL
SELECT 'LVM_WRKFLW_TRANS_WIPDTLS' AS LVM_TBL_NAME,'LVM_WRKFLW_TRANS_WIPDTLS_SEQ' AS  LVM_TBL_SEQ_NAME
UNION ALL
SELECT 'LVM_LEAVEBAL_LOG' AS LVM_TBL_NAME , 'LEAVE_LOGID_SEQ' AS LVM_TBL_SEQ_NAME
UNION ALL
SELECT 'LVM_LEAVETYPE_MSTR' AS LVM_TBL_NAME , 'LEAVETYPEID_SEQ' AS LVM_TBL_SEQ_NAME
UNION ALL
SELECT 'LVM_LVTYPE_CTGRY_MAPPING_MSTR' AS LVM_TBL_NAME , 'LEVTYPE_CTGRY_MAPPING_ID_SEQ' AS
LVM_TBL_SEQ_NAME
UNION ALL
SELECT 'LVM_LOCATION_LEAVETYPE_MAPPING' AS LVM_TBL_NAME , 'LOC_LVTYPE_MAP_ID_SEQ' AS
LVM_TBL_SEQ_NAME
UNION ALL
SELECT 'LVM_WRKFLW_NOFITY_TRANS'AS LVM_TBL_NAME ,'LVM_NOTIFICATION_TRANS_SEQ' AS
LVM_TBL_SEQ_NAME
UNION ALL
SELECT 'LVM_LEAVETYPE_DEF_MSTR' AS LVM_TBL_NAME ,'LEAVETYPE_DEF_MSTR_ID_SEQ' AS
LVM_TBL_SEQ_NAME
UNION ALL
SELECT 'LVM_LEAVEBALANCE'AS LVM_TBL_NAME ,'LVM_LEAVEBALANCE_ID_SEQ' AS
LVM_TBL_SEQ_NAME
UNION ALL
SELECT 'TM_TRANS_ATTENDANCE' AS LVM_TBL_NAME ,'TM_TRANS_ATTEND_ID_SEQ' AS
LVM_TBL_SEQ_NAME
UNION ALL
SELECT 'TM_ATTENDANCE' AS LVM_TBL_NAME ,'TM_ATTENDANCE_ID_SEQ' AS
LVM_TBL_SEQ_NAME
UNION ALL
SELECT 'TM_INTEG_STATUSTIME' AS LVM_TBL_NAME ,'TM_STATUS_ID_SEQ' AS
LVM_TBL_SEQ_NAME
UNION ALL
SELECT 'TM_MSTR_DTLS' AS LVM_TBL_NAME ,'TM_MSTR_DTLS_ID_SEQ' AS
LVM_TBL_SEQ_NAME
UNION ALL
SELECT 'LVM_SETTLE_ENCASHMNT_DTLS' AS LVM_TBL_NAME ,'LVM_SETTLE_ENCASHMNT_DTLS_SEQ' AS
LVM_TBL_SEQ_NAME
UNION ALL
SELECT 'LVM_APPLICABLE_EMP_TYPE' AS LVM_TBL_NAME ,'LVM_APPLICABLE_EMP_TYPE_SEQ' AS
LVM_TBL_SEQ_NAME
UNION ALL
SELECT 'LVM_EMP_CREDIT_DTLS' AS LVM_TBL_NAME ,'CREDIT_DTLS_ID_SEQ' AS
LVM_TBL_SEQ_NAME
UNION ALL
SELECT 'LVM_LOV_MSTR' AS LVM_TBL_NAME ,'LOVMASTER_SEQ' AS
LVM_TBL_SEQ_NAME
UNION ALL
SELECT 'LVM_LEAVEBAL_AUDIT' AS LVM_TBL_NAME ,'LVM_LEAVEBAL_AUDIT_ID_SEQ' AS
LVM_TBL_SEQ_NAME
UNION ALL
SELECT 'LVM_CREDITDTLS_AUDIT' AS LVM_TBL_NAME ,'LVM_CREDITDTLS_AUDIT_SEQ' AS
LVM_TBL_SEQ_NAME
UNION ALL
SELECT 'LVM_LOCATIONWISE_CREDITDTLS' AS LVM_TBL_NAME ,'LOC_CREDIT_ID_SEQ' AS
LVM_TBL_SEQ_NAME
UNION ALL
SELECT 'LVM_REASSIGN' AS LVM_TBL_NAME ,'LVM_REASSIGN_SEQ' AS
LVM_TBL_SEQ_NAME;

CREATE OR REPLACE VIEW WARDS.V_DS_DATA_FIX
(IPNO,PARAMETERID,CONTROLTYPEID,DISCHARGEDATE,LENGTH_VAL,DISCHARGEDTLID,DISCHARGENO,PARAMETERNAME,PARAMETERVALUE,PARAMETERDETAILVALUE)
AS
WITH PM AS ( SELECT
                       (SUBSTR(PM1.ATTRIBUTES, INSTR(PM1.ATTRIBUTES, 'Length="', 1) + 8, INSTR(PM1.ATTRIBUTES, '" ', INSTR(PM1.
                       ATTRIBUTES, 'Length="', 1)) - INSTR(PM1.ATTRIBUTES, 'Length="', 1) - 8))::numeric AS LENGTH_VAL
                     , PM1.*
                  FROM
                       WARDS.PARAMETERMASTER PM1
     )
     SELECT
          DS.IPNO
        , PM.PARAMETERID
        , PM.CONTROLTYPEID
        , DS.CREATEDDATE DISCHARGEDATE
        , PM.LENGTH_VAL
        , DSD.DISCHARGEDTLID
        , DSD.DISCHARGENO
        , DSD.PARAMETERNAME
        , DSD.PARAMETERVALUE
        , DSCD.PARAMETERDETAILVALUE
     FROM
               PM
          JOIN WARDS.PARAMETERMAPPING      PMAP ON PMAP.PARAMETERID = PM.PARAMETERID
          JOIN WARDS.DISCHARGESUMMDTLS     DSD ON DSD.PARAMMAPPINGID = PMAP.PARAMMAPPINGID
          JOIN WARDS.DISCHARGESUMM_DYNC    DS ON DS.DISCHARGENO = DSD.DISCHARGENO
          LEFT OUTER JOIN WARDS.DISCHARGESUMMCHLDDTLS DSCD ON DSCD.DISCHARGEDTLID = DSD.DISCHARGEDTLID;
------------------------------------------------------------------------------------------------Views For Mviews

/*create or replace view BILLING.VW_CODESYSTEMMASTER
as
select
	SM.CODESYSTEMID CODESYSTEMID,
	SM.SERVICEID SERVICEID,
	SM.SYSTEMCODE SYSTEMCODE,
	SM.SYSTEMCODENAME SYSTEMCODENAME,
	SM.SUBCODE SUBCODE,
	SM.STATUS STATUS,
	SM.LOCATIONID LOCATIONID,
	SM.CREATEDBY CREATEDBY,
	SM.CREATEDDATE CREATEDDATE,
	SM.UPDATEDBY UPDATEDBY,
	SM.UPDATEDDATE UPDATEDDATE
from
	billing.vw_codesystemmaster SM
where
	exists (
	select
		0
	from
		ehis.vwr_regionmappingmaster RMM
	where
		SM.LOCATIONID = RMM.CHARTID
		and RMM.STATUS = 1
		and RMM.REGIONID = 4);*/

/*create or replace view BILLING.VW_DEPENDENTSERVICES
as
select
	SM.DEPENDENTSERVICEID DEPENDENTSERVICEID,
	SM.DEPENDENTSERVICENAME DEPENDENTSERVICENAME,
	SM.CUSTOMERID CUSTOMERID,
	SM.LOCATIONID LOCATIONID,
	SM.CREATEDBY CREATEDBY,
	SM.CREATEDDATE CREATEDDATE,
	SM.SERVICEID SERVICEID,
	SM.UPDATEDBY UPDATEDBY,
	SM.UPDATEDDATE UPDATEDDATE,
	SM.DEPTID DEPTID,
	SM.ASSETID ASSETID
from
	billing.vw_dependentservices SM
where
	exists (
	select
		0
	from
		ehis.vwr_regionmappingmaster RMM
	where
		SM.LOCATIONID = RMM.CHARTID
		and RMM.STATUS = 1
		and RMM.REGIONID = 4);*/

/*create or replace view BILLING.VW_EQUIPMENTTYPESERVICERELATION
as
select
	SM.EQUIPMENTSERVICERELATIONID EQUIPMENTSERVICERELATIONID,
	SM.SERVICEID SERVICEID,
	SM.EQUIPMENTTYPEID EQUIPMENTTYPEID,
	SM.EQUIPMENTTYPENAME EQUIPMENTTYPENAME,
	SM.LOCATIONID LOCATIONID,
	SM.QUANTITY QUANTITY,
	SM.MANDATORY MANDATORY,
	SM.CREATEDBY CREATEDBY,
	SM.CREATEDDATE CREATEDDATE,
	SM.UPDATEDBY UPDATEDBY,
	SM.UPDATEDDATE UPDATEDDATE
from
	billing.vw_equipmenttypeservicerelation SM
where
	exists (
	select
		0
	from
		ehis.vwr_regionmappingmaster RMM
	where
		SM.LOCATIONID = RMM.CHARTID
		and RMM.STATUS = 1
		and RMM.REGIONID = 4)
;

create or replace view BILLING.VW_GENDER
as
select
	SM.GENDER GENDER,
	SM.FROMAGE FROMAGE,
	SM.TOAGE TOAGE,
	SM.CREATEDBY CREATEDBY,
	SM.CREATEDDATE CREATEDDATE,
	SM.UPDATEDBY UPDATEDBY,
	SM.UPDATEDDATE UPDATEDDATE,
	SM.GENDERID GENDERID,
	SM.SERVICEID SERVICEID,
	SM.LOCATIONID LOCATIONID
from
	billing.vw_gender SM
where
	exists (
	select
		0
	from
		ehis.vwr_regionmappingmaster RMM
	where
		SM.LOCATIONID = RMM.CHARTID
		and RMM.STATUS = 1
		and RMM.REGIONID = 4);

create or replace view BILLING.VW_GENERALTARIFFMASTER	
as
select
	SM.GENERALTARIFFID GENERALTARIFFID,
	SM.TEMPLATETARIFFID TEMPLATETARIFFID,
	SM.VERSIONNO VERSIONNO,
	SM.CUSTOMERID CUSTOMERID,
	SM.AGREEMENTID AGREEMENTID,
	SM.BEDCATEGORYID BEDCATEGORYID,
	SM.LOCATIONID LOCATIONID,
	SM.PATIENTSERVICEID PATIENTSERVICEID,
	SM.PATIENTTYPEID PATIENTTYPEID,
	SM.DISCOUNTMARKUPID DISCOUNTMARKUPID,
	SM.DISCOUNTMARKUPVALUE DISCOUNTMARKUPVALUE,
	SM.COMPOSITEAGREEMENTID COMPOSITEAGREEMENTID,
	SM.PRECEDENCEFLAG PRECEDENCEFLAG,
	SM.TARIFFVERSIONRULE TARIFFVERSIONRULE,
	SM.PROPOSALID PROPOSALID,
	SM.PROPOSALDATE PROPOSALDATE,
	SM.PROPOSALSTATUS PROPOSALSTATUS,
	SM.PUBLISHEDDATE PUBLISHEDDATE,
	SM.STATUS STATUS,
	SM.PAYERPAYABLE PAYERPAYABLE,
	SM.PATIENTPAYABLEPERCENTAGE PATIENTPAYABLEPERCENTAGE,
	SM.EFFECTIVEFROMDATE EFFECTIVEFROMDATE,
	SM.EFFECTIVETODATE EFFECTIVETODATE,
	SM.CREATEDBY CREATEDBY,
	SM.CREATEDDATE CREATEDDATE,
	SM.UPDATEDBY UPDATEDBY,
	SM.UPDATEDDATE UPDATEDDATE,
	SM.ROOMRENTCAP ROOMRENTCAP,
	SM.LOGICTEMPLATETARIFFID LOGICTEMPLATETARIFFID,
	SM.LOGICTEMPLATEVERSIONNO LOGICTEMPLATEVERSIONNO
from
	billing.vw_generaltariffmaster SM
where
	exists (
	select
		0
	from
		ehis.vwr_regionmappingmaster RMM
	where
		SM.LOCATIONID = RMM.CHARTID
		and RMM.STATUS = 1
		and RMM.REGIONID = 4)
;

create or replace view BILLING.VW_HUMANRESOURCESERVICE
as 
select
	SM.HUMANRESOURCESERVICEID HUMANRESOURCESERVICEID,
	SM.SERVICEID SERVICEID,
	SM.LOCATIONID LOCATIONID,
	SM.SPECIALIZATIONID SPECIALIZATIONID,
	SM.EMPLOYEECATEGORYID EMPLOYEECATEGORYID,
	SM.QUANTITY QUANTITY,
	SM.MANDETORY MANDETORY,
	SM.DISPLAYED DISPLAYED,
	SM.CREATEDBY CREATEDBY,
	SM.CREATEDDATE CREATEDDATE,
	SM.UPDATEDBY UPDATEDBY,
	SM.UPDATEDDATE UPDATEDDATE
from
	billing.vw_humanresourceservice SM
where
	exists (
	select
		0
	from
		ehis.vwr_regionmappingmaster RMM
	where
		SM.LOCATIONID = RMM.CHARTID
		and RMM.STATUS = 1
		and RMM.REGIONID = 4)
;
*/
/*create or replace view BILLING.VW_MATERIALMASTER	
as
select
	SM.MATERIALID MATERIALID,
	SM.MATERIALNAME MATERIALNAME,
	SM.SERVICEID SERVICEID,
	SM.ITEMCODE ITEMCODE,
	SM.RESOURESTYPE RESOURESTYPE,
	SM.CREATEDDATE CREATEDDATE,
	SM.CREATEDBY CREATEDBY,
	SM.UPDATEDDATE UPDATEDDATE,
	SM.UPDATEDBY UPDATEDBY,
	SM.LOCATIONID LOCATIONID,
	SM.CHOICEOFCUSTOMER CHOICEOFCUSTOMER,
	SM.QUANTITY QUANTITY
from
	billing.vw_materialmaster SM
where
	exists (
	select
		0
	from
		ehis.vwr_regionmappingmaster RMM
	where
		SM.LOCATIONID = RMM.CHARTID
		and RMM.STATUS = 1
		and RMM.REGIONID = 4)
;
*/
/*create or replace view BILLING.VW_NONRELATIONALTARIFFDETAILS as
select
	SM.SERVICEID SERVICEID,
	SM.LOCATIONID LOCATIONID,
	SM.TARIFF TARIFF,
	SM.VERSIONNO VERSIONNO,
	SM.DISCOUNTMARKUPID DISCOUNTMARKUPID,
	SM.DISCOUNTMARKUPVALUE DISCOUNTMARKUPVALUE,
	SM.PAYERPAYABLE PAYERPAYABLE,
	SM.PATIENTPAYABLEPERCENTAGE PATIENTPAYABLEPERCENTAGE,
	SM.EFFECTIVEFROMDATE EFFECTIVEFROMDATE,
	SM.EFFECTIVETODATE EFFECTIVETODATE,
	SM.NONRELATIONALTARIFFDETIALSID NONRELATIONALTARIFFDETIALSID,
	SM.GENERALTARIFFID GENERALTARIFFID,
	SM.IOMNUMBER IOMNUMBER,
	SM.IOMDATE IOMDATE,
	SM.REMARK REMARK,
	SM.CREATEDBY CREATEDBY,
	SM.CREATEDDATE CREATEDDATE,
	SM.UPDATEDBY UPDATEDBY,
	SM.UPDATEDDATE UPDATEDDATE,
	SM.PATIENTCONDITIONID PATIENTCONDITIONID
from
	billing.vw_nonrelationaltariffdetails SM
where
	exists (
	select
		0
	from
		ehis.vwr_regionmappingmaster RMM
	where
		SM.LOCATIONID = RMM.CHARTID
		and RMM.STATUS = 1
		and RMM.REGIONID = 4);

create or replace view BILLING.VW_PACKAGEDEFINITION	
as 
select
	SM.PACKAGEID PACKAGEID,
	SM.STAYOTHERBEDCATEGORY STAYOTHERBEDCATEGORY,
	SM.STAYICU STAYICU,
	SM.STARTBEFORE STARTBEFORE,
	SM.CUSTOMERID CUSTOMERID,
	SM.AGREEMENTID AGREEMENTID,
	SM.LOCATIONID LOCATIONID,
	SM.CREATEDBY CREATEDBY,
	SM.CREATEDDATE CREATEDDATE,
	SM.UPDATEDBY UPDATEDBY,
	SM.UPDATEDDATE UPDATEDDATE,
	SM.VERSIONNO VERSIONNO,
	SM.PACKAGEDEFINITIONID PACKAGEDEFINITIONID,
	SM.CRMSTATUS CRMSTATUS,
	SM.OTHERSERVICETYPEFLAG OTHERSERVICETYPEFLAG
from
	billing.vw_packagedefinition SM
where
	exists (
	select
		0
	from
		ehis.vwr_regionmappingmaster RMM
	where
		SM.LOCATIONID = RMM.CHARTID
		and RMM.STATUS = 1
		and RMM.REGIONID = 4)
;*/

/*create or replace view BILLING.VW_PACKAGEDISOUNT 
as 
select
	SM.PACKAGEID PACKAGEID,
	SM.TIMEPERIOD TIMEPERIOD,
	SM.DISCOUNTTYPE DISCOUNTTYPE,
	SM.DISCOUNTAMOUNT DISCOUNTAMOUNT,
	SM.DISCOUNTPERCENT DISCOUNTPERCENT,
	SM.INSERTEDBY INSERTEDBY,
	SM.INSERTDATE INSERTDATE,
	SM.UPDATEDBY UPDATEDBY,
	SM.UPDATEDATE UPDATEDATE,
	SM.AVAILEDPACKAGEID AVAILEDPACKAGEID,
	SM.PACKAGEDISCOUNTID PACKAGEDISCOUNTID,
	SM.LOCATIONID LOCATIONID
from
	billing.vw_packagedisount SM
where
	exists (
	select
		0
	from
		ehis.vwr_regionmappingmaster RMM
	where
		SM.LOCATIONID = RMM.CHARTID
		and RMM.STATUS = 1
		and RMM.REGIONID = 4)
;*/

/*create or replace view BILLING.VW_PACKAGEGROUP
as
select
	SM.GROUPID GROUPID,
	SM.PACKAGEGROUPNAME PACKAGEGROUPNAME,
	SM.PACKAGEID PACKAGEID,
	SM.CUSTOMERID CUSTOMERID,
	SM.AGREEMENTID AGREEMENTID,
	SM.LOCATIONID LOCATIONID,
	SM.GROUPLIMIT GROUPLIMIT,
	SM.CREATEDBY CREATEDBY,
	SM.CREATEDDATE CREATEDDATE,
	SM.UPDATEDBY UPDATEDBY,
	SM.UPDATEDDATE UPDATEDDATE,
	SM.VERSIONNO VERSIONNO,
	SM.BEDCATEGORYID BEDCATEGORYID,
	SM.PACKAGEGROUPID PACKAGEGROUPID,
	SM.QUOTEID QUOTEID,
	SM.CRMSTATUS CRMSTATUS,
	SM.PACKAGEDEFINITIONID PACKAGEDEFINITIONID,
	SM.SERVICETYPEID SERVICETYPEID
from
	billing.vw_packagegroup SM
where
	exists (
	select
		0
	from
		ehis.vwr_regionmappingmaster RMM
	where
		SM.LOCATIONID = RMM.CHARTID::numeric 
		and RMM.STATUS = 1
		and RMM.REGIONID = 4)
;*/

/*create or replace view BILLING.VW_PACKAGEITEMEXCLUSIONDETAILS
as
select
	SM.PACKAGEEXCLUSIONID PACKAGEEXCLUSIONID,
	SM.PACKAGEID PACKAGEID,
	SM.SERVICEID SERVICEID,
	SM.SERVICETYPEID SERVICETYPEID,
	SM.INSERTEDBY INSERTEDBY,
	SM.INSERTDATE INSERTDATE,
	SM.UPDATEDBY UPDATEDBY,
	SM.UPDATEDATE UPDATEDATE,
	SM.LOCATIONID LOCATIONID,
	SM.SERVICENAME SERVICENAME,
	SM.VERSIONNO VERSIONNO,
	SM.PACKAGEDEFINITIONID PACKAGEDEFINITIONID
from
	billing.vw_packageitemexclusiondetails SM
where
	exists (
	select
		0
	from
		ehis.vwr_regionmappingmaster RMM
	where
		SM.LOCATIONID = RMM.CHARTID
		and RMM.STATUS = 1
		and RMM.REGIONID = 4)
;*/

/*create or replace view BILLING.VW_PACKAGEITEMINCLUSIONDETAILS
as
select
	SM.PACKAGEINCLUSIONID PACKAGEINCLUSIONID,
	SM.PACKAGEID PACKAGEID,
	SM.SERVICEID SERVICEID,
	SM.SERVICETYPEID SERVICETYPEID,
	SM.LIMITTYPEID LIMITTYPEID,
	SM.INSERTEDBY INSERTEDBY,
	SM.INSERTDATE INSERTDATE,
	SM.UPDATEDBY UPDATEDBY,
	SM.UPDATEDATE UPDATEDATE,
	SM.LIMITVALUE LIMITVALUE,
	SM.SUBSITUTEITEMID SUBSITUTEITEMID,
	SM.HASLIMIT HASLIMIT,
	SM.LOCATIONID LOCATIONID,
	SM.QUANTITY QUANTITY,
	SM.SERVICENAME SERVICENAME,
	SM.VERSIONNO VERSIONNO,
	SM.PACKAGEDEFINITIONID PACKAGEDEFINITIONID
from
	billing.vw_packageiteminclusiondetails SM
where
	exists (
	select
		0
	from
		ehis.vwr_regionmappingmaster RMM
	where
		SM.LOCATIONID = RMM.CHARTID
		and RMM.STATUS = 1
		and RMM.REGIONID = 4)
;*/

/*create or replace view BILLING.VW_PACKAGESUBCATTYPEEXCLUSION	
as
select
	SM.PACKAGESUBCATTYPEEXCLUSIONID PACKAGESUBCATTYPEEXCLUSIONID,
	SM.PACKAGEID PACKAGEID,
	SM.SUBCATEGORYID SUBCATEGORYID,
	SM.SUBCATEGORYNAME SUBCATEGORYNAME,
	SM.LEVELID LEVELID,
	SM.LOCATIONID LOCATIONID,
	SM.CREATEDBY CREATEDBY,
	SM.CREATEDDATE CREATEDDATE,
	SM.UPDATEDBY UPDATEDBY,
	SM.UPDATEDDATE UPDATEDDATE,
	SM.PACKAGEDEFINITIONID PACKAGEDEFINITIONID
from
	billing.vw_packagesubcattypeexclusion SM
where
	exists (
	select
		0
	from
		ehis.vwr_regionmappingmaster RMM
	where
		SM.LOCATIONID = RMM.CHARTID
		and RMM.STATUS = 1
		and RMM.REGIONID = 4)
;*/

/*create or replace view BILLING.VW_PACKAGETYPEINCLUSIONDETAILS	
as
select
	SM.PACKAGEINCLUSIONID PACKAGEINCLUSIONID,
	SM.PACKAGEID PACKAGEID,
	SM.LIMITYPEID LIMITYPEID,
	SM.INSERTEDBY INSERTEDBY,
	SM.INSERTDATE INSERTDATE,
	SM.UPDATEDDATE UPDATEDDATE,
	SM.LIMITVALUE LIMITVALUE,
	SM.CREATEDBY CREATEDBY,
	SM.SERVICETYPEID SERVICETYPEID,
	SM.ISINGROUP ISINGROUP,
	SM.LOCATIONID LOCATIONID,
	SM.NOOFDAYSINCLUDED NOOFDAYSINCLUDED,
	SM.HASLIMIT HASLIMIT,
	SM.BEDCATEGORYID BEDCATEGORYID,
	SM.VERSIONNO VERSIONNO,
	SM.PACKAGEDEFINITIONID PACKAGEDEFINITIONID
from
	billing.vw_packagetypeinclusiondetails SM
where
	exists (
	select
		0
	from
		ehis.vwr_regionmappingmaster RMM
	where
		SM.LOCATIONID = RMM.CHARTID
		and RMM.STATUS = 1
		and RMM.REGIONID = 4)
;*/

/*create or replace view BILLING.VW_PATIENTCONDITONAPPLICABILITY	
as
select
	SM.PATIENTCONDTIONAPPLICABILITYID PATIENTCONDTIONAPPLICABILITYID,
	SM.SERVICEID SERVICEID,
	SM.LOCATIONID LOCATIONID,
	SM.APPLICABILITYID APPLICABILITYID,
	SM.VERSIONNO VERSIONNO,
	SM.CREATEDBY CREATEDBY,
	SM.CREATEDDATE CREATEDDATE,
	SM.UPDATEDBY UPDATEDBY,
	SM.UPDATEDDATE UPDATEDDATE,
	SM.PATIENTCONDITION PATIENTCONDITION
from
	billing.vw_patientconditonapplicability SM
where
	exists (
	select
		0
	from
		ehis.vwr_regionmappingmaster RMM
	where
		SM.LOCATIONID = RMM.CHARTID
		and RMM.STATUS = 1
		and RMM.REGIONID = 4)
;*/

/*create or replace view BILLING.VW_PATIENTCONSENT
as
select
	SM.CONSENTID CONSENTID,
	SM.SERVICEID SERVICEID,
	SM.UPDATEDBY UPDATEDBY,
	SM.UPDATEDATE UPDATEDATE,
	SM.LOCATIONID LOCATIONID,
	SM.CREATEDBY CREATEDBY,
	SM.CREATEDDATE CREATEDDATE,
	SM.PATIENTCONSENTMASTERID PATIENTCONSENTMASTERID
from
	billing.vw_patientconsent SM
where
	exists (
	select
		0
	from
		ehis.vwr_regionmappingmaster RMM
	where
		SM.LOCATIONID = RMM.CHARTID
		and RMM.STATUS = 1
		and RMM.REGIONID = 4)
;
*/
/*create or replace view BILLING.VW_PEMMASTER	
as
select
	SM.PEMID PEMID,
	SM.SERVICEID SERVICEID,
	SM.PRINTREQD PRINTREQD,
	SM.LOCATIONID LOCATIONID,
	SM.UPDATEDDATE UPDATEDDATE,
	SM.UPDATEDBY UPDATEDBY,
	SM.CREATEDBY CREATEDBY,
	SM.CREATEDDATE CREATEDDATE,
	SM.PEMTITLEMASTERID PEMTITLEMASTERID
from
	billing.vw_pemmaster SM
where
	exists (
	select
		0
	from
		ehis.vwr_regionmappingmaster RMM
	where
		SM.LOCATIONID = RMM.CHARTID
		and RMM.STATUS = 1
		and RMM.REGIONID = 4)
;*/

/*create or replace view BILLING.VW_PREREQUISITEMASTER
as
select
	SM.PREREQUISITEID PREREQUISITEID,
	SM.SERVICEID SERVICEID,
	SM.PREREQUISITENO PREREQUISITENO,
	SM.CREATEDBY CREATEDBY,
	SM.CREATEDDATE CREATEDDATE,
	SM.UPDATEDBY UPDATEDBY,
	SM.UPDATEDDATE UPDATEDDATE,
	SM.LOCATIONID LOCATIONID,
	SM.PREREQUISITETITLEMASTERID PREREQUISITETITLEMASTERID
from
	billing.vw_prerequisitemaster SM
where
	exists (
	select
		0
	from
		ehis.vwr_regionmappingmaster RMM
	where
		SM.LOCATIONID = RMM.CHARTID
		and RMM.STATUS = 1
		and RMM.REGIONID = 4)
;*/

/*create or replace view BILLING.VW_SCHEDULERMASTER
as
select
	SM.SCHEDULERID SCHEDULERID,
	SM.SERVICEID SERVICEID,
	SM.CALENDERCODE CALENDERCODE,
	SM.SLOTDURATION SLOTDURATION,
	SM.SLOTLENGTHTYPE SLOTLENGTHTYPE,
	SM.LEADTIME LEADTIME,
	SM.OVERBOOKINGALLOWED OVERBOOKINGALLOWED,
	SM.MINIMUMBOOKINGTIME MINIMUMBOOKINGTIME,
	SM.LOCATIONID LOCATIONID,
	SM.CREATEDDATE CREATEDDATE,
	SM.CREATEDBY CREATEDBY,
	SM.USAGETYPE USAGETYPE,
	SM.UPDATEDBY UPDATEDBY,
	SM.UPDATEDDATE UPDATEDDATE,
	SM.FRONTOFFICESERVICE FRONTOFFICESERVICE,
	SM.OVERBOOKINGQUANTITY OVERBOOKINGQUANTITY
from
	billing.vw_schedulermaster SM
where
	exists (
	select
		0
	from
		ehis.vwr_regionmappingmaster RMM
	where
		SM.LOCATIONID = RMM.CHARTID
		and RMM.STATUS = 1
		and RMM.REGIONID = 4)
;*/

/*create or replace view BILLING.VW_SERVICEAPPLICABILITY	
as
select
	SM.SERVICEAPPLICABILITYID SERVICEAPPLICABILITYID,
	SM.APPLICABILITYID APPLICABILITYID,
	SM.SERVICECODE SERVICECODE,
	SM.SERVICEID SERVICEID,
	SM.LOCATIONID LOCATIONID,
	SM.CREATEDBY CREATEDBY,
	SM.CREATEDDATE CREATEDDATE,
	SM.UPDATEDBY UPDATEDBY,
	SM.UPDATEDDATE UPDATEDDATE
from
	billing.vw_serviceapplicability SM
where
	exists (
	select
		0
	from
		ehis.vwr_regionmappingmaster RMM
	where
		SM.LOCATIONID = RMM.CHARTID
		and RMM.STATUS = 1
		and RMM.REGIONID = 4)
;*/

/*create or replace view BILLING.VW_SERVICEDELIVERYMASTER
as
select
	SM.SERVICEDELIVERYID SERVICEDELIVERYID,
	SM.SERVICEID SERVICEID,
	SM.LOCATIONID LOCATIONID,
	SM.CREATEDDATE CREATEDDATE,
	SM.CREATEDBY CREATEDBY,
	SM.UPDATEDBY UPDATEDBY,
	SM.UPDATEDDATE UPDATEDDATE,
	SM.SERVICEDELIVERVALUE SERVICEDELIVERVALUE
from
	billing.vw_servicedeliverymaster SM
where
	exists (
	select
		0
	from
		ehis.vwr_regionmappingmaster RMM
	where
		SM.LOCATIONID = RMM.CHARTID
		and RMM.STATUS = 1
		and RMM.REGIONID = 4)
;*/

/*create or replace view BILLING.VW_SERVICEFACILITY
as
select
	SM.SERVICEFACILITYID SERVICEFACILITYID,
	SM.SERVICEID SERVICEID,
	SM.LOCATIONID LOCATIONID,
	SM.ROOMTYPEID ROOMTYPEID,
	SM.MANDETORY MANDETORY,
	SM.SCHEDULABLE SCHEDULABLE,
	SM.CREATEDBY CREATEDBY,
	SM.CREATEDDATE CREATEDDATE,
	SM.UPDATEDBY UPDATEDBY,
	SM.UPDATEDDATE UPDATEDDATE,
	SM.ROOMID ROOMID
from
	billing.vw_servicefacility SM
where
	exists (
	select
		0
	from
		ehis.vwr_regionmappingmaster RMM
	where
		SM.LOCATIONID = RMM.CHARTID::numeric 
		and RMM.STATUS = 1
		and RMM.REGIONID = 4)
;
*/
/*create or replace view BILLING.VW_SERVICEMASTER
as
select
	SM.SERVICEID SERVICEID,
	SM.SERVICECODE SERVICECODE,
	SM.SERVICENAME SERVICENAME,
	SM.SERVICEDESCRIPTION SERVICEDESCRIPTION,
	SM.SERVICETYPEID SERVICETYPEID,
	SM.SERVICECATEGORYID SERVICECATEGORYID,
	SM.DEPTID DEPTID,
	SM.SUBDEPTID SUBDEPTID,
	SM.BASEDON BASEDON,
	SM.SCHUDELABLE SCHUDELABLE,
	SM.RESOURESREQUIRED RESOURESREQUIRED,
	SM.EFFECTIVEFROM EFFECTIVEFROM,
	SM.EFFECTIVETO EFFECTIVETO,
	SM.RESTORABLE RESTORABLE,
	SM.SERVICESTATUS SERVICESTATUS,
	SM.UOMID UOMID,
	SM.SERVICEMODEL SERVICEMODEL,
	SM.SERVICEPROVIDERTYPE SERVICEPROVIDERTYPE,
	SM.SERVICEPROVIDERNAME SERVICEPROVIDERNAME,
	SM.PARTNERDESCRIPTION PARTNERDESCRIPTION,
	SM.DEPOSITEAPPLICABLE DEPOSITEAPPLICABLE,
	SM.APPROVALREQUIREDFORBUFFER APPROVALREQUIREDFORBUFFER,
	SM.PEMREQUIRED PEMREQUIRED,
	SM.CONSENTREQUIRED CONSENTREQUIRED,
	SM.COSTDEFINITIONID COSTDEFINITIONID,
	SM.FINANCIALVERSIONNO FINANCIALVERSIONNO,
	SM.NONFINANCIALVERSIONNO NONFINANCIALVERSIONNO,
	SM.BILLABLE BILLABLE,
	SM.NATUREOFBILLING NATUREOFBILLING,
	SM.BILLABLETYPE BILLABLETYPE,
	SM.DISCOUNTABLE DISCOUNTABLE,
	SM.DEPOSITEAMOUNT DEPOSITEAMOUNT,
	SM.DEPOSITEPERCENTAGE DEPOSITEPERCENTAGE,
	SM.REFUNDABLE REFUNDABLE,
	SM.REFUNDPERIOD REFUNDPERIOD,
	SM.REFUNDAMOUNT REFUNDAMOUNT,
	SM.REFUNDPERCENT REFUNDPERCENT,
	SM.AUTHORIZATIONREQUIRED AUTHORIZATIONREQUIRED,
	SM.TAXABLE TAXABLE,
	SM.VERSIONNO VERSIONNO,
	SM.EQUIPMENT EQUIPMENT,
	SM.CLINICAL CLINICAL,
	SM.AVAILABLEONINTERNET AVAILABLEONINTERNET,
	SM.FACILITY FACILITY,
	SM.MAXDISCOUNTPERCENT MAXDISCOUNTPERCENT,
	SM.HIGHVALUESERVICES HIGHVALUESERVICES,
	SM.DISCOUNTLIMIT DISCOUNTLIMIT,
	SM.DISCOUNTDESCRIPTION DISCOUNTDESCRIPTION,
	SM.DISCOUNTAPPLICABLE DISCOUNTAPPLICABLE,
	SM.EPISODECOUNT EPISODECOUNT,
	SM.DEPOSITTARIFFAMOUNT DEPOSITTARIFFAMOUNT,
	SM.DEPOSITTARIFFPERCENTAGE DEPOSITTARIFFPERCENTAGE,
	SM.NONFINANCIALVERSIONCONTROL NONFINANCIALVERSIONCONTROL,
	SM.TOTALBASEPRICE TOTALBASEPRICE,
	SM.DEPENDENTSERVICE DEPENDENTSERVICE,
	SM.CHILD CHILD,
	SM.DATACENTERFLAG DATACENTERFLAG,
	SM.COMPANYID COMPANYID,
	SM.LOCATIONID LOCATIONID,
	SM.UPDATEDBY UPDATEDBY,
	SM.UPDATEDATE UPDATEDATE,
	SM.CREATEDDATE CREATEDDATE,
	SM.CREATEDBY CREATEDBY,
	SM.PREREQUISITEREQUIRED PREREQUISITEREQUIRED,
	SM.PATIENTTYPEID PATIENTTYPEID,
	SM.ISCOMPOSITESERVICE ISCOMPOSITESERVICE,
	SM.DISCOUNTTYPE DISCOUNTTYPE,
	SM.DEPOSITETYPE DEPOSITETYPE,
	SM.MATERIAL MATERIAL,
	SM.ADJUSTABLEAMOUNT ADJUSTABLEAMOUNT,
	SM.STARTBEFORE STARTBEFORE,
	SM.MAXNOOFDAYS MAXNOOFDAYS,
	SM.PACKAGETYPEID PACKAGETYPEID,
	SM.ISPACKAGEDEFINED ISPACKAGEDEFINED,
	SM.VISIBLE VISIBLE,
	SM.GRACEPERIOD GRACEPERIOD,
	SM.CODIFICATIONREQUIRED CODIFICATIONREQUIRED,
	SM.GENDERAPPLICABILITY GENDERAPPLICABILITY,
	SM.ITEMCODE ITEMCODE,
	SM.REFUNDTYPE REFUNDTYPE,
	SM.REFUNDPERIODTYPE REFUNDPERIODTYPE,
	SM.ISNONAPOLLOSERVICE ISNONAPOLLOSERVICE,
	SM.SERVICEALIAS SERVICEALIAS,
	SM.ISFREQUENTLYUSED ISFREQUENTLYUSED,
	SM.ISEDITABLE ISEDITABLE,
	SM.HEALTHCHECKUPTYPE HEALTHCHECKUPTYPE
from
	billing.vw_servicemaster SM
where
	exists (
	select
		0
	from
		ehis.vwr_regionmappingmaster RMM
	where
		SM.LOCATIONID = RMM.CHARTID
		and RMM.STATUS = 1
		and RMM.REGIONID = 4)
;*/

/*create or replace view BILLING.VW_TAXMASTER	
as
select
	SM.TAXID TAXID,
	SM.TAXMASTERCODE TAXMASTERCODE,
	SM.SERVICEID SERVICEID,
	SM.TAXMASTERNAME TAXMASTERNAME,
	SM.TAXTYPE TAXTYPE,
	SM.TAXAMOUNT TAXAMOUNT,
	SM.LOCATIONID LOCATIONID,
	SM.CREATEDBY CREATEDBY,
	SM.CREATEDDATE CREATEDDATE,
	SM.UPDATEDBY UPDATEDBY,
	SM.UPDATEDDATE UPDATEDDATE,
	SM.SERVICETYPEID SERVICETYPEID,
	SM.PERCENTFLAG PERCENTFLAG,
	SM.BEDCATEGORYID BEDCATEGORYID,
	SM.TAXSLABAMOUNT TAXSLABAMOUNT,
	SM.PATIENTTYPE PATIENTTYPE,
	SM.FROMDATE FROMDATE,
	SM.TODATE TODATE
from
	billing.vw_taxmaster SM
where
	exists (
	select
		0
	from
		ehis.vwr_regionmappingmaster RMM
	where
		SM.LOCATIONID = RMM.CHARTID
		and RMM.STATUS = 1
		and RMM.REGIONID = 4)
;*/

create or replace view CRM.AGREEMENTS_NEW
as
SELECT AGREEMENTS.AGREEMENTID              AGREEMENTID,
       AGREEMENTS.AGREEMENTCODE            AGREEMENTCODE,
       AGREEMENTS.AGREEMENTNAME            AGREEMENTNAME,
       AGREEMENTS.CUSTOMERID               CUSTOMERID,
       AGREEMENTS.STATUSID                 STATUSID,
       AGREEMENTS.EFFECTIVEDATE            EFFECTIVEDATE,
       AGREEMENTS.EXPIRYDATE               EXPIRYDATE,
       AGREEMENTS.UPDATINGTARIFFRULES      UPDATINGTARIFFRULES,
       AGREEMENTS.DESCRIPTION              DESCRIPTION,
       AGREEMENTS.PRIMARYASSIGNEDOWNER     PRIMARYASSIGNEDOWNER,
       AGREEMENTS.CREATEDBY                CREATEDBY,
       AGREEMENTS.CREATEDDATE              CREATEDDATE,
       AGREEMENTS.UPDATEDBY                UPDATEDBY,
       AGREEMENTS.UPDATEDDATE              UPDATEDDATE,
       AGREEMENTS.QUOTEID                  QUOTEID,
       AGREEMENTS.SIGNINGDATE              SIGNINGDATE,
       AGREEMENTS.FILETYPE                 FILETYPE,
       AGREEMENTS.FILENAME                 FILENAME,
       AGREEMENTS.FILEPATH                 FILEPATH,
       AGREEMENTS.CUSTOMERCATEGORYID       CUSTOMERCATEGORYID,
       AGREEMENTS.CUSTOMERTYPEID           CUSTOMERTYPEID,
       AGREEMENTS.AGREEMENTPRICINGDETAILS  AGREEMENTPRICINGDETAILS,
       AGREEMENTS.CUSTOMERPAYMENTDETAILS   CUSTOMERPAYMENTDETAILS,
       AGREEMENTS.CUSTOMERNAME             CUSTOMERNAME,
       AGREEMENTS.APPLICABLELOCATIONS      APPLICABLELOCATIONS,
       AGREEMENTS.ELIGIBILITYCHECK         ELIGIBILITYCHECK,
       AGREEMENTS.PROSPECTIVEREVIEW        PROSPECTIVEREVIEW,
       AGREEMENTS.DISCHARGEMANAGEMENT      DISCHARGEMANAGEMENT,
       AGREEMENTS.CONCURENTREVIEW          CONCURENTREVIEW,
       AGREEMENTS.IDENTIFIERS              IDENTIFIERS,
       AGREEMENTS.TIMEPERIOD               TIMEPERIOD,
       AGREEMENTS.APPLICABILITY            APPLICABILITY,
       AGREEMENTS.REMARKS                  REMARKS,
       AGREEMENTS.BASEBEDCATEGORYID        BASEBEDCATEGORYID,
       AGREEMENTS.LOCATIONID               LOCATIONID,
       AGREEMENTS.BASEPATIENTTYPEID        BASEPATIENTTYPEID,
       AGREEMENTS.ASSIGNEDOWNER            ASSIGNEDOWNER,
       AGREEMENTS.TARIFFPOSTINGFLAG        TARIFFPOSTINGFLAG,
       AGREEMENTS.DUEDATE                  DUEDATE,
       AGREEMENTS.USEASREF_TEMPLATE        USEASREF_TEMPLATE,
       AGREEMENTS.MEDICINEAMOUNTLIMIT      MEDICINEAMOUNTLIMIT,
       AGREEMENTS.GROUPMEDICINEAMOUNTLIMIT GROUPMEDICINEAMOUNTLIMIT,
       AGREEMENTS.ISEMPAGREEMENT           ISEMPAGREEMENT,
       AGREEMENTS.STATUSFLAG               STATUSFLAG,
       AGREEMENTS.CURRENCYCODE             CURRENCYCODE,
       AGREEMENTS.DUEFLAG                  DUEFLAG,
       AGREEMENTS.DISCRETIONARYCREDIT      DISCRETIONARYCREDIT,
       AGREEMENTS.DISCRETIONARYTYPE        DISCRETIONARYTYPE
  FROM crm.vwr_agreements AGREEMENTS
WHERE  AGREEMENTS.LOCATIONID  in('10701','10702') 
;

create or replace view LAB.VW_PARAMETERMASTERMAINDETAIL
as
select * from lab.vwr_parametermastermaindetail;

create or replace view MM.GT_BATCHSERIALITEM
as
SELECT BATCHSERIALITEM.STATUS                    STATUS,
       BATCHSERIALITEM.BATCHSERIALID             BATCHSERIALID,
       BATCHSERIALITEM.STOCKTRANSACTIONDETAILSID STOCKTRANSACTIONDETAILSID,
       BATCHSERIALITEM.ITEMCODE                  ITEMCODE,
       BATCHSERIALITEM.STORECODE                 STORECODE,
       BATCHSERIALITEM.BATCHSERIALCODE           BATCHSERIALCODE,
       BATCHSERIALITEM.ISBATCH                   ISBATCH,
       BATCHSERIALITEM.MFGDATE                   MFGDATE,
       BATCHSERIALITEM.EXPIRYDATE                EXPIRYDATE,
       BATCHSERIALITEM.TRANSACTIONTYPEID         TRANSACTIONTYPEID,
       BATCHSERIALITEM.UNITCOST                  UNITCOST,
       BATCHSERIALITEM.RECEIPTDATE               RECEIPTDATE,
       BATCHSERIALITEM.BATCHVALUE                BATCHVALUE,
       BATCHSERIALITEM.QTY                       QTY,
       BATCHSERIALITEM.MRP                       MRP,
       BATCHSERIALITEM.PRCODE                    PRCODE,
       BATCHSERIALITEM.DEPTCODE                  DEPTCODE,
       BATCHSERIALITEM.REASONCODE                REASONCODE,
       BATCHSERIALITEM.REJECTEDQTY               REJECTEDQTY,
       BATCHSERIALITEM.VENDORCODE                VENDORCODE,
       BATCHSERIALITEM.VENDORSITECODE            VENDORSITECODE,
       BATCHSERIALITEM.DCNO                      DCNO
  FROM MM.BATCHSERIALITEM
 WHERE BATCHSERIALITEM.TRANSACTIONTYPEID = 5
;

/*create or replace view MM.VW_ITEMCOMPANY
as
select
	ITEMCOMPANY.ISCONSIGNMENTITEM ISCONSIGNMENTITEM,
	ITEMCOMPANY.VARIANTALLOWED VARIANTALLOWED,
	ITEMCOMPANY.ISHAZARDOUS ISHAZARDOUS,
	ITEMCOMPANY.ISINCLUSEDINCOSTING ISINCLUSEDINCOSTING,
	ITEMCOMPANY.VEDANALYSIS VEDANALYSIS,
	ITEMCOMPANY.ITEMCLASSIFICATION ITEMCLASSIFICATION,
	ITEMCOMPANY.ITEMCATEGORY ITEMCATEGORY,
	ITEMCOMPANY.ITEMSUBCATEGORY1 ITEMSUBCATEGORY1,
	ITEMCOMPANY.ITEMSUBCATEGORY2 ITEMSUBCATEGORY2,
	ITEMCOMPANY.ITEMSUBCATEGORY3 ITEMSUBCATEGORY3,
	ITEMCOMPANY.ITEMSTORAGETYPE ITEMSTORAGETYPE,
	ITEMCOMPANY.UNITWEIGHT UNITWEIGHT,
	ITEMCOMPANY.WEIGHTUOM WEIGHTUOM,
	ITEMCOMPANY.UNITVOLUME UNITVOLUME,
	ITEMCOMPANY.VOLUMEUOM VOLUMEUOM,
	ITEMCOMPANY.LOOKUPID LOOKUPID,
	ITEMCOMPANY.SEQNUMBER SEQNUMBER,
	ITEMCOMPANY.ITEMTYPE ITEMTYPE,
	ITEMCOMPANY.ITEMCODE ITEMCODE,
	ITEMCOMPANY.ITEMSHORTDESC ITEMSHORTDESC,
	ITEMCOMPANY.ITEMLONGDESC ITEMLONGDESC,
	ITEMCOMPANY.FLEXIFIELD1 FLEXIFIELD1,
	ITEMCOMPANY.FLEXIFIELD2 FLEXIFIELD2,
	ITEMCOMPANY.FLEXIFIELD3 FLEXIFIELD3,
	ITEMCOMPANY.FLEXIFIELD4 FLEXIFIELD4,
	ITEMCOMPANY.FLEXIFIELD5 FLEXIFIELD5,
	ITEMCOMPANY.BARCODE BARCODE,
	ITEMCOMPANY.BIS BIS,
	ITEMCOMPANY.LEGACYITEMCODE LEGACYITEMCODE,
	ITEMCOMPANY.REUSABLEITEM REUSABLEITEM,
	ITEMCOMPANY.CREATIONDATE CREATIONDATE,
	ITEMCOMPANY.ITEMDESCNEW ITEMDESCNEW,
	ITEMCOMPANY.ITEMBRIEFDESC ITEMBRIEFDESC,
	ITEMCOMPANY.LEGACYSTOREITEMCODE LEGACYSTOREITEMCODE,
	ITEMCOMPANY.STATUS STATUS,
	ITEMCOMPANY.UPDATEDATE UPDATEDATE,
	ITEMCOMPANY.CREATEDBY CREATEDBY,
	ITEMCOMPANY.UPDATEDBY UPDATEDBY,
	ITEMCOMPANY.MANUFACTURERID MANUFACTURERID,
	ITEMCOMPANY.MAPPINGID MAPPINGID,
	ITEMCOMPANY.BRANDNAME BRANDNAME,
	ITEMCOMPANY.IMPORTERNAME IMPORTERNAME,
	ITEMCOMPANY.HSNCODE HSNCODE,
	ITEMCOMPANY.ISLOCALPO ISLOCALPO,
	ITEMCOMPANY.PURCHASEPRICE PURCHASEPRICE,
	ITEMCOMPANY.RCREFNUMBER RCREFNUMBER,
	ITEMCOMPANY.PUC PUC,
	ITEMCOMPANY.REGIONID REGIONID,
	ITEMCOMPANY.CHKMRP CHKMRP,
	ITEMCOMPANY.EFFECTIVEDATE EFFECTIVEDATE
from
	mm.vw_itemcompany ITEMCOMPANY
where
	ITEMCOMPANY.REGIONID = 0
;*/

create or replace view PHARMACY.MV_BATCHSERIALITEM
as 
select
	T.STATUS STATUS,
	T.BATCHSERIALID BATCHSERIALID,
	T.STOCKTRANSACTIONDETAILSID STOCKTRANSACTIONDETAILSID,
	T.ITEMCODE ITEMCODE,
	T.STORECODE STORECODE,
	T.BATCHSERIALCODE BATCHSERIALCODE,
	T.ISBATCH ISBATCH,
	T.MFGDATE MFGDATE,
	T.EXPIRYDATE EXPIRYDATE,
	T.TRANSACTIONTYPEID TRANSACTIONTYPEID,
	T.UNITCOST UNITCOST,
	T.RECEIPTDATE RECEIPTDATE,
	T.BATCHVALUE BATCHVALUE,
	T.QTY QTY,
	T.MRP MRP,
	T.PRCODE PRCODE,
	T.DEPTCODE DEPTCODE,
	T.REASONCODE REASONCODE,
	T.REJECTEDQTY REJECTEDQTY,
	T.CREATEDDATE CREATEDDATE
from
	pharmacy.BATCHSERIALITEM T
where
	T.TRANSACTIONTYPEID = 1
;

create or replace view PROCESS.MV_PROCESSFLOWTRANSWORKFLOW
as 
select
	PROCESSFLOWTRANSWORKFLOW.PROCESSFLOWTRANSWORKFLOWID PROCESSFLOWTRANSWORKFLOWID,
	PROCESSFLOWTRANSWORKFLOW.PROCESSFLOWTRANSID PROCESSFLOWTRANSID,
	PROCESSFLOWTRANSWORKFLOW.WORKFLOWSTEPID WORKFLOWSTEPID,
	PROCESSFLOWTRANSWORKFLOW.WIPBY WIPBY,
	PROCESSFLOWTRANSWORKFLOW.SLA SLA,
	PROCESSFLOWTRANSWORKFLOW.SLAUNIT SLAUNIT,
	PROCESSFLOWTRANSWORKFLOW.CREATEDON CREATEDON,
	PROCESSFLOWTRANSWORKFLOW.CREATEDBY CREATEDBY,
	PROCESSFLOWTRANSWORKFLOW.STATE STATE,
	PROCESSFLOWTRANSWORKFLOW.NOTIFYBYID NOTIFYBYID,
	PROCESSFLOWTRANSWORKFLOW.ALERTID ALERTID,
	PROCESSFLOWTRANSWORKFLOW.COMMENTS comments,
	PROCESSFLOWTRANSWORKFLOW.STATEUPDATEDON STATEUPDATEDON,
	PROCESSFLOWTRANSWORKFLOW.NOTIFYEMAILTEXT NOTIFYEMAILTEXT,
	PROCESSFLOWTRANSWORKFLOW.NOTIFYSMSTEXT NOTIFYSMSTEXT,
	PROCESSFLOWTRANSWORKFLOW.NOTIFYDASHBOARDTEXT NOTIFYDASHBOARDTEXT,
	PROCESSFLOWTRANSWORKFLOW.ALERTEMAILTEXT ALERTEMAILTEXT,
	PROCESSFLOWTRANSWORKFLOW.ALERTSMSTEXT ALERTSMSTEXT,
	PROCESSFLOWTRANSWORKFLOW.ALERTDASHBOARDTEXT ALERTDASHBOARDTEXT,
	PROCESSFLOWTRANSWORKFLOW.NOTIFIED NOTIFIED,
	PROCESSFLOWTRANSWORKFLOW.ALERTSENTFLAG ALERTSENTFLAG,
	PROCESSFLOWTRANSWORKFLOW.ESCALATIONSENTFLAG ESCALATIONSENTFLAG,
	PROCESSFLOWTRANSWORKFLOW.WIPUPDATEDON WIPUPDATEDON,
	PROCESSFLOWTRANSWORKFLOW.ASSIGNEDBY ASSIGNEDBY,
	PROCESSFLOWTRANSWORKFLOW.ASSIGNEDDATE ASSIGNEDDATE
from
	PROCESS.PROCESSFLOWTRANSWORKFLOW PROCESSFLOWTRANSWORKFLOW
where
	PROCESSFLOWTRANSWORKFLOW.STATE is null
	and PROCESSFLOWTRANSWORKFLOW.WIPBY is null
;

create or replace view PROCESS.MV_PROCESSFLOWTRANS_DIGITAL
as 
SELECT PROCESSFLOWTRANS.PROCESFLOWTRANSID
PROCESFLOWTRANSID,PROCESSFLOWTRANS.BUSINESSTRANSKEY BUSINESSTRANSKEY FROM
PROCESS.PROCESSFLOWTRANS PROCESSFLOWTRANS
WHERE PROCESSFLOWTRANS.PROCESSFLOWCODE='WK_FNB_01'
AND PROCESSFLOWTRANS.COMPLETED!='C'
;

create or replace view PROCESS.MV_PROCESSFLOWTRANS_FNB 
as 
select
	PROCESSFLOWTRANS.PROCESFLOWTRANSID PROCESFLOWTRANSID,
	PROCESSFLOWTRANS.PROCESSFLOWINSTANCEID PROCESSFLOWINSTANCEID,
	PROCESSFLOWTRANS.ACTIVITYCODE ACTIVITYCODE,
	PROCESSFLOWTRANS.STATUSID STATUSID,
	PROCESSFLOWTRANS.WIPBY WIPBY,
	PROCESSFLOWTRANS.SLA SLA,
	PROCESSFLOWTRANS.CREATEDON CREATEDON,
	PROCESSFLOWTRANS.SERVICEID SERVICEID,
	PROCESSFLOWTRANS.STATUSUPDATEDON STATUSUPDATEDON,
	PROCESSFLOWTRANS.WIPUPDATEDON WIPUPDATEDON,
	PROCESSFLOWTRANS.CREATEDBY CREATEDBY,
	PROCESSFLOWTRANS.UPDATEDBY UPDATEDBY,
	PROCESSFLOWTRANS.COMPLETED COMPLETED,
	PROCESSFLOWTRANS.BUSINESSTRANSKEY BUSINESSTRANSKEY,
	PROCESSFLOWTRANS.NOTIFYBYID NOTIFYBYID,
	PROCESSFLOWTRANS.ALERTID ALERTID,
	PROCESSFLOWTRANS.WORKFLOWSTATE WORKFLOWSTATE,
	PROCESSFLOWTRANS.PROCESSFLOWID PROCESSFLOWID,
	PROCESSFLOWTRANS.ACTIVITYID ACTIVITYID,
	PROCESSFLOWTRANS.NOTIFYEMAILTEXT NOTIFYEMAILTEXT,
	PROCESSFLOWTRANS.NOTIFYSMSTEXT NOTIFYSMSTEXT,
	PROCESSFLOWTRANS.NOTIFYDASHBOARDTEXT NOTIFYDASHBOARDTEXT,
	PROCESSFLOWTRANS.ALERTEMAILTEXT ALERTEMAILTEXT,
	PROCESSFLOWTRANS.ALERTSMSTEXT ALERTSMSTEXT,
	PROCESSFLOWTRANS.ALERTDASHBOARDTEXT ALERTDASHBOARDTEXT,
	PROCESSFLOWTRANS.NOTIFIED NOTIFIED,
	PROCESSFLOWTRANS.SLAUNIT SLAUNIT,
	PROCESSFLOWTRANS.PROCESSFLOWCODE PROCESSFLOWCODE,
	PROCESSFLOWTRANS.UPDATEDON UPDATEDON,
	PROCESSFLOWTRANS.COMPLETEDON COMPLETEDON,
	PROCESSFLOWTRANS.FLOWOWNERID FLOWOWNERID,
	PROCESSFLOWTRANS.ALERTSENTFLAG ALERTSENTFLAG,
	PROCESSFLOWTRANS.ESCALATIONSENTFLAG ESCALATIONSENTFLAG,
	PROCESSFLOWTRANS.WORKFLOWINITIATEDON WORKFLOWINITIATEDON,
	PROCESSFLOWTRANS.PREVIOUSTRANSID PREVIOUSTRANSID,
	PROCESSFLOWTRANS.NEXTTRANSID NEXTTRANSID,
	PROCESSFLOWTRANS.TRANSIDXML TRANSIDXML,
	PROCESSFLOWTRANS.ASSIGNEDBY ASSIGNEDBY,
	PROCESSFLOWTRANS.ASSIGNEDDATE ASSIGNEDDATE,
	PROCESSFLOWTRANS.ATTACHMENTS ATTACHMENTS,
	PROCESSFLOWTRANS.TOOLTIPINFO TOOLTIPINFO
from
	PROCESS.PROCESSFLOWTRANS PROCESSFLOWTRANS
where
	PROCESSFLOWTRANS.PROCESSFLOWCODE = 'WK_FNB_01'
;

create or replace view PROCESS.MV_PROCESSFLOWTRANS_FNB1	
as
select
	PROCESSFLOWTRANS.PROCESFLOWTRANSID PROCESFLOWTRANSID,
	PROCESSFLOWTRANS.PROCESSFLOWINSTANCEID PROCESSFLOWINSTANCEID,
	PROCESSFLOWTRANS.ACTIVITYCODE ACTIVITYCODE,
	PROCESSFLOWTRANS.STATUSID STATUSID,
	PROCESSFLOWTRANS.WIPBY WIPBY,
	PROCESSFLOWTRANS.SLA SLA,
	PROCESSFLOWTRANS.CREATEDON CREATEDON,
	PROCESSFLOWTRANS.SERVICEID SERVICEID,
	PROCESSFLOWTRANS.STATUSUPDATEDON STATUSUPDATEDON,
	PROCESSFLOWTRANS.WIPUPDATEDON WIPUPDATEDON,
	PROCESSFLOWTRANS.CREATEDBY CREATEDBY,
	PROCESSFLOWTRANS.UPDATEDBY UPDATEDBY,
	PROCESSFLOWTRANS.COMPLETED COMPLETED,
	PROCESSFLOWTRANS.BUSINESSTRANSKEY BUSINESSTRANSKEY,
	PROCESSFLOWTRANS.NOTIFYBYID NOTIFYBYID,
	PROCESSFLOWTRANS.ALERTID ALERTID,
	PROCESSFLOWTRANS.WORKFLOWSTATE WORKFLOWSTATE,
	PROCESSFLOWTRANS.PROCESSFLOWID PROCESSFLOWID,
	PROCESSFLOWTRANS.ACTIVITYID ACTIVITYID,
	PROCESSFLOWTRANS.NOTIFYEMAILTEXT NOTIFYEMAILTEXT,
	PROCESSFLOWTRANS.NOTIFYSMSTEXT NOTIFYSMSTEXT,
	PROCESSFLOWTRANS.NOTIFYDASHBOARDTEXT NOTIFYDASHBOARDTEXT,
	PROCESSFLOWTRANS.ALERTEMAILTEXT ALERTEMAILTEXT,
	PROCESSFLOWTRANS.ALERTSMSTEXT ALERTSMSTEXT,
	PROCESSFLOWTRANS.ALERTDASHBOARDTEXT ALERTDASHBOARDTEXT,
	PROCESSFLOWTRANS.NOTIFIED NOTIFIED,
	PROCESSFLOWTRANS.SLAUNIT SLAUNIT,
	PROCESSFLOWTRANS.PROCESSFLOWCODE PROCESSFLOWCODE,
	PROCESSFLOWTRANS.UPDATEDON UPDATEDON,
	PROCESSFLOWTRANS.COMPLETEDON COMPLETEDON,
	PROCESSFLOWTRANS.FLOWOWNERID FLOWOWNERID,
	PROCESSFLOWTRANS.ALERTSENTFLAG ALERTSENTFLAG,
	PROCESSFLOWTRANS.ESCALATIONSENTFLAG ESCALATIONSENTFLAG,
	PROCESSFLOWTRANS.WORKFLOWINITIATEDON WORKFLOWINITIATEDON,
	PROCESSFLOWTRANS.PREVIOUSTRANSID PREVIOUSTRANSID,
	PROCESSFLOWTRANS.NEXTTRANSID NEXTTRANSID,
	PROCESSFLOWTRANS.TRANSIDXML TRANSIDXML,
	PROCESSFLOWTRANS.ASSIGNEDBY ASSIGNEDBY,
	PROCESSFLOWTRANS.ASSIGNEDDATE ASSIGNEDDATE,
	PROCESSFLOWTRANS.ATTACHMENTS ATTACHMENTS,
	PROCESSFLOWTRANS.TOOLTIPINFO TOOLTIPINFO
from
	PROCESS.PROCESSFLOWTRANS PROCESSFLOWTRANS
where
	PROCESSFLOWTRANS.PROCESSFLOWCODE = 'WK_FNB_01'
	and PROCESSFLOWTRANS.COMPLETED = 'N'
;

create or replace view PROCESS.MV_PROCESSFLOWTRANS_FNB2	
as
select
	PROCESSFLOWTRANS.PROCESFLOWTRANSID PROCESFLOWTRANSID,
	PROCESSFLOWTRANS.PROCESSFLOWINSTANCEID PROCESSFLOWINSTANCEID,
	PROCESSFLOWTRANS.ACTIVITYCODE ACTIVITYCODE,
	PROCESSFLOWTRANS.STATUSID STATUSID,
	PROCESSFLOWTRANS.WIPBY WIPBY,
	PROCESSFLOWTRANS.SLA SLA,
	PROCESSFLOWTRANS.CREATEDON CREATEDON,
	PROCESSFLOWTRANS.SERVICEID SERVICEID,
	PROCESSFLOWTRANS.STATUSUPDATEDON STATUSUPDATEDON,
	PROCESSFLOWTRANS.WIPUPDATEDON WIPUPDATEDON,
	PROCESSFLOWTRANS.CREATEDBY CREATEDBY,
	PROCESSFLOWTRANS.UPDATEDBY UPDATEDBY,
	PROCESSFLOWTRANS.COMPLETED COMPLETED,
	PROCESSFLOWTRANS.BUSINESSTRANSKEY BUSINESSTRANSKEY,
	PROCESSFLOWTRANS.NOTIFYBYID NOTIFYBYID,
	PROCESSFLOWTRANS.ALERTID ALERTID,
	PROCESSFLOWTRANS.WORKFLOWSTATE WORKFLOWSTATE,
	PROCESSFLOWTRANS.PROCESSFLOWID PROCESSFLOWID,
	PROCESSFLOWTRANS.ACTIVITYID ACTIVITYID,
	PROCESSFLOWTRANS.NOTIFYEMAILTEXT NOTIFYEMAILTEXT,
	PROCESSFLOWTRANS.NOTIFYSMSTEXT NOTIFYSMSTEXT,
	PROCESSFLOWTRANS.NOTIFYDASHBOARDTEXT NOTIFYDASHBOARDTEXT,
	PROCESSFLOWTRANS.ALERTEMAILTEXT ALERTEMAILTEXT,
	PROCESSFLOWTRANS.ALERTSMSTEXT ALERTSMSTEXT,
	PROCESSFLOWTRANS.ALERTDASHBOARDTEXT ALERTDASHBOARDTEXT,
	PROCESSFLOWTRANS.NOTIFIED NOTIFIED,
	PROCESSFLOWTRANS.SLAUNIT SLAUNIT,
	PROCESSFLOWTRANS.PROCESSFLOWCODE PROCESSFLOWCODE,
	PROCESSFLOWTRANS.UPDATEDON UPDATEDON,
	PROCESSFLOWTRANS.COMPLETEDON COMPLETEDON,
	PROCESSFLOWTRANS.FLOWOWNERID FLOWOWNERID,
	PROCESSFLOWTRANS.ALERTSENTFLAG ALERTSENTFLAG,
	PROCESSFLOWTRANS.ESCALATIONSENTFLAG ESCALATIONSENTFLAG,
	PROCESSFLOWTRANS.WORKFLOWINITIATEDON WORKFLOWINITIATEDON,
	PROCESSFLOWTRANS.PREVIOUSTRANSID PREVIOUSTRANSID,
	PROCESSFLOWTRANS.NEXTTRANSID NEXTTRANSID,
	PROCESSFLOWTRANS.TRANSIDXML TRANSIDXML,
	PROCESSFLOWTRANS.ASSIGNEDBY ASSIGNEDBY,
	PROCESSFLOWTRANS.ASSIGNEDDATE ASSIGNEDDATE,
	PROCESSFLOWTRANS.ATTACHMENTS ATTACHMENTS,
	PROCESSFLOWTRANS.TOOLTIPINFO TOOLTIPINFO
from
	PROCESS.PROCESSFLOWTRANS PROCESSFLOWTRANS
where
	PROCESSFLOWTRANS.PROCESSFLOWCODE = 'WK_FNB_01'
	and PROCESSFLOWTRANS.COMPLETED = 'N'
	and (PROCESSFLOWTRANS.NOTIFYSMSTEXT = 'M'
		or PROCESSFLOWTRANS.NOTIFYSMSTEXT = 'T'
		or PROCESSFLOWTRANS.NOTIFYSMSTEXT = 'N')
;

------------------------------------------------------------------------------------------------
create or replace view BILLING.GETAHCPACKAGESVW	
as
SELECT DISTINCT SM.SERVICEID PACKAGEID,
                    SM.SERVICENAME PACKAGENAME,
                    (BILLING.F_GETSERVICEITEMTARIFF(SM.LOCATIONID,
                                            0,
                                            0,
                                            2,
                                            1,
                                            0,
                                            current_date,
                                            SM.SERVICEID,
                                            NULL,
                                            NULL,
                                            NULL,
                                            929)) PACKAGEAMOUNT,
                    TO_CHAR(PM.STARTDATE, 'DD-MON-YYYY HH24:MI:SS') AS STARTDATE,
                    TO_CHAR(PM.STARTDATE, 'DD-MON-YYYY HH24:MI:SS') AS ACTIVEFROM,
                    PM.EXPIRYDATE AS EXPIRYDATE
                    ,T.TEMPLATETARIFFID,NVL(PM.FROMDATE, '09-APR-1900') FROMDATE,NVL(PM.TODATE, '09-APR-1900') TODATE,SM.LOCATIONID
      FROM billing.vwr_templatetariffdetails T, billing.VW_SERVICEMASTER SM, billing.PACKAGEMASTER PM
     WHERE T.TEMPLATETARIFFID IN
           (SELECT G.TEMPLATETARIFFID
              FROM BILLING.VW_GENERALTARIFFMASTER G
             WHERE G.PATIENTSERVICEID = 2
               AND G.PATIENTTYPEID = 1
               AND G.LOCATIONID = SM.LOCATIONID)
       AND PM.PACKAGEID = SM.SERVICEID
       AND PM.LOCATIONID = SM.LOCATIONID
       AND SM.SERVICEID = T.SERVICEID
       AND SM.SERVICETYPEID IN (141, 142)
       AND SM.ISNONAPOLLOSERVICE = 'N'
       AND SM.SERVICESTATUS = 'ACTIVE'
       AND PM.STATUS = 1;

------------------------------------------------------------------------------------------------Views for Mviews
create or replace view radiology.vw_prun_user_stats as  SELECT rrd.requestdtlid,
    rrd.drn,
    max(
        CASE rst.statusid
            WHEN 15 THEN rst.statustimestamp
            ELSE NULL::timestamp without time zone
        END) AS confirmed_time,
    radiology.pkg_radiology_util_f_get_doctor_name(NULL::text, (max((
        CASE rst.statusid
            WHEN 15 THEN rst.createdby
            ELSE NULL::character varying
        END)::text))::numeric) AS confirmed_by,
    min(
        CASE rst.statusid
            WHEN 16 THEN rst.statustimestamp
            ELSE NULL::timestamp without time zone
        END) AS chkin_time,
    radiology.pkg_radiology_util_f_get_doctor_name(NULL::text, (max((
        CASE rst.statusid
            WHEN 16 THEN rst.createdby
            ELSE NULL::character varying
        END)::text))::numeric) AS chkin_by,
    max(
        CASE rst.statusid
            WHEN 19 THEN rst.statustimestamp
            ELSE NULL::timestamp without time zone
        END) AS chkout_time,
    radiology.pkg_radiology_util_f_get_doctor_name(NULL::text, (max((
        CASE rst.statusid
            WHEN 19 THEN rst.createdby
            ELSE NULL::character varying
        END)::text))::numeric) AS chkout_by,
    max(
        CASE rst.statusid
            WHEN 20 THEN rst.statustimestamp
            ELSE NULL::timestamp without time zone
        END) AS reported_time,
    radiology.pkg_radiology_util_f_get_doctor_name(NULL::text, (max((
        CASE rst.statusid
            WHEN 20 THEN rst.createdby
            ELSE NULL::character varying
        END)::text))::numeric) AS reported_by_login,
    max(
        CASE rst.statusid
            WHEN 21 THEN rst.statustimestamp
            ELSE NULL::timestamp without time zone
        END) AS authorized_time,
    radiology.pkg_radiology_util_f_get_doctor_name(NULL::text, (max((
        CASE rst.statusid
            WHEN 21 THEN rst.createdby
            ELSE NULL::character varying
        END)::text))::numeric) AS authorized_by_login,
    radiology.pkg_radiology_util_f_get_doctor_name(NULL::text, (rrrh.reportedby)::numeric) AS reported_by
   FROM (((radiology.radrequestdtls rrd
     JOIN radiology.radstatustimes rst ON ((rrd.requestdtlid = rst.requestdtlid)))
     JOIN radiology.radlovdetailmaster rldm ON ((rst.statusid = rldm.lovdetailid)))
     LEFT JOIN radiology.radresultreporthdr rrrh ON ((rrd.requestdtlid = rrrh.requestdtlid)))
  WHERE (((rrd.servnglocationid)::text = '10801'::text) AND (rrd.createddate >= CURRENT_DATE) AND (rst.statusid = ANY (ARRAY[(15)::numeric, (16)::numeric, (19)::numeric, (20)::numeric, (21)::numeric])))
  GROUP BY rrd.requestdtlid, rrd.drn, rrrh.reportedby
  ORDER BY rrd.requestdtlid;

CREATE OR REPLACE VIEW PAYROLL.V_ALLTYPES
(ETYPE,ECATEGORY,GRADE,POSITION)
AS
SELECT DISTINCT F1.ETYPE,F2.ECATEGORY,F3.GRADE,F4.POSITION
   FROM
   ( SELECT ESD.EMP_DTL_ID ETYPE
    FROM hr.vwr_employee_structure_details ESD
    WHERE ESD.STATUS=1
    AND eSD.EMP_MASTER_ID= 8 AND ESD.EMP_DTL_ID IN (125,127)) F1,
    ( SELECT ESD.EMP_DTL_ID ECATEGORY
    FROM hr.vwr_employee_structure_details ESD
    WHERE ESD.STATUS=1
    AND ESd.EMP_MASTER_ID= 7 AND ESD.EMP_DTL_ID IN (74,75,121,122,123)) F2,
   (SELECT DISTINCT LMM1.MAPPINGSOURCEID ECATEGORY,LMM2.MAPPINGDESTINATIONID GRADE,
ESD1.NAME CATEGORY1,ESD2.NAME LEVEL_DESC,ESD3.NAME GRADE1
FROM hr.vwr_levelmappingmaster LMM1
--CATE
JOIN hr.vwr_employee_structure_details ESD1 ON LMM1.MAPPINGSOURCEID=ESD1.EMP_DTL_ID AND ESD1.STATUS=1 AND LMM1.MAPPINGSTATUS=1
--LEVEL
JOIN hr.vwr_employee_structure_details ESD2
ON ESD2.EMP_DTL_ID=LMM1.MAPPINGDESTINATIONID
JOIN hr.vwr_levelmappingmaster LMM2
ON LMM2.MAPPINGSOURCEID=LMM1.MAPPINGDESTINATIONID AND LMM2.MAPPINGSTATUS=1 AND LMM1.MAPPINGSTATUS=1
--GRADE
JOIN hr.vwr_employee_structure_details ESD3
ON ESD3.EMP_DTL_ID=LMM2.MAPPINGDESTINATIONID AND LMM2.MAPPINGSTATUS=1 AND ESD3.STATUS=1
WHERE ESD1.EMP_MASTER_ID=7 AND ESD3.EMP_MASTER_ID=11 AND ESD2.EMP_MASTER_ID=10
) F3,
   (SELECT HR.F_Encodeposition(dlm.departmentid,dem.empoyeedetailid) POSITION ,ESD1.EMP_DTL_ID GRADE
   FROM
   hr.vwr_dept_empdetail_mappingmaster dem
    inner join  hr.vwr_employee_structure_details esd
    on dem.empoyeedetailid=esd.emp_dtl_id
    inner join ehis.vwr_deptlocationmappingmaster dlm
    on dem.departmentid=dlm.mappingid
    inner join ehis.vwr_coa_struct_details csd
    on dlm.departmentid=csd.chartid
    INNER JOIN hr.vwr_levelmappingmaster lmm
    ON LMM.MAPPINGDESTINATIONID=ESD.EMP_DTL_ID
    INNER JOIN hr.vwr_employee_structure_details ESD1
    ON LMM.MAPPINGSOURCEID=ESD1.EMP_DTL_ID
		where esd.emp_master_id=9			AND
		 esd1.emp_master_id=11
		and dlm.locationid='10201') F4
   WHERE F2.ECATEGORY=F3.ECATEGORY AND F3.GRADE=F4.GRADE
   ORDER BY 1,2,3,4;

create or replace view payroll.pay_emp_mst_rep_kol as  SELECT (emd.employeeid)::text AS emp_no,
    tm.titletype AS emp_title,
    emd.firstname AS emp_first_name,
    emd.middlename AS emp_middle_name,
    emd.lastname AS emp_last_name,
    (((((((COALESCE(tm.titletype, ''::character varying))::text || ' '::text) || (COALESCE(emd.firstname, ''::character varying))::text) || ' '::text) || (COALESCE(emd.middlename, ''::character varying))::text) || ' '::text) || (COALESCE(emd.lastname, ''::character varying))::text) AS ename,
    ' '::text AS emp_gender,
    initcap((esd.name)::text) AS emp_desig_code,
    emd.dob AS emp_dob,
    ead.payrollprocessdate AS emp_doj,
    initcap((csd2.leveldetailname)::text) AS emp_dept_code,
        CASE emd.status
            WHEN 1 THEN 'A'::text
            WHEN 0 THEN 'N'::text
            ELSE NULL::text
        END AS emp_status,
        CASE ead.stoppayment
            WHEN 0 THEN 'NO'::text
            WHEN 1 THEN 'YES'::text
            ELSE NULL::text
        END AS stoppayment,
    ead.pan_number AS emp_pan,
    ead.fathername AS emp_father_name,
    ead.dueretirementdate AS emp_date_of_retire,
    ead.dateofleaving AS emp_separation_date,
    ephu.emp_cat_code,
    ephu.emp_stafftype_code AS emp_staff_type_code,
    ead.dateofconfirmation AS emp_conf_date,
    ead.probationstartdate AS emp_prob_date,
    ead.dateofjoining AS emp_with_effect_from,
    ephu.emp_grade_id,
    ephu.emp_position_id,
    hr.f_deptfromposition((ephu.emp_position_id)::text) AS emp_dept_id,
    emd.locationid AS emp_area_code,
    epp.locationid AS emp_trans_area_code,
    NULL::text AS emp_notice_date,
    initcap((esd1.name)::text) AS stafftype,
    initcap((esd2.name)::text) AS category,
    initcap((esd3.name)::text) AS grade,
    initcap((((csd2.leveldetailname)::text || ' - '::text) || (esd.name)::text)) AS "position",
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::character varying
            ELSE ebd.account_no
        END AS account_no,
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::text
            ELSE (((bbm.banktname)::text || ' - '::text) || (bbrm.bankbranchname)::text)
        END AS bankname,
    hr.f_deptfromposition((ephu.emp_position_id)::text) AS departmentid,
    hr.f_desigfromposition((ephu.emp_position_id)::text) AS designationid,
    ead.pfnumber AS pfaccountno,
    ead.socialsecuiretynumber,
    ead.contract_from,
    ead.contract_to,
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::character varying
            ELSE atm.accountdesc
        END AS accountdesc,
    ead.pf_details,
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::numeric
            ELSE ebd.bank_name_id
        END AS bankid,
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::character varying
            ELSE atm.accountname
        END AS accountname,
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::numeric
            ELSE atm.accounttypeid
        END AS accounttypeid,
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::numeric
            ELSE ebd.bbank_branch_id
        END AS branchid,
    emd.presentemployeeid,
    ead.dateofseperation,
    ead.dateofresignationtendered,
    emd.titleid,
    emd.employmentstatusid,
        CASE emd.employmentstatusid
            WHEN 192 THEN 'ACTIVE'::text
            WHEN 545 THEN 'RNS'::text
            ELSE NULL::text
        END AS estatus,
    epp.locationid AS trans_location_id
   FROM (((((((((((((((hr.mv_employee_main_details emd
     JOIN hr.vwr_emp_pay_processdetails epp ON ((epp.empno = emd.employeeid)))
     JOIN ehis.vwr_titlemaster tm ON (((emd.titleid = tm.titleid) AND (tm.status = (1)::numeric))))
     JOIN hr.Vwr_EMPLOYEE_AUXILIARY_DETAILS ead ON ((emd.employeeid = ead.emp_id)))
     JOIN hr.emp_prm_history_update ephu ON ((emd.employeeid = (ephu.emp_no)::numeric)))
     JOIN payroll.pay_proc_date ppd ON ((((ppd.locationid)::text = (epp.locationid)::text) AND (((last_day(ppd.proc_date))::timestamp without time zone >= epp.startdate) AND ((last_day(ppd.proc_date))::timestamp without time zone <= epp.enddate)) AND ((ead.payrollprocessdate IS NULL) OR ((ead.payrollprocessdate <= ppd.proc_date) AND ((ppd.proc_date >= ephu.eff_from_dt) AND (ppd.proc_date <= ephu.eff_to_dt))) OR ((ead.payrollprocessdate > ppd.proc_date) AND (((last_day(ppd.proc_date))::timestamp without time zone >= ephu.eff_from_dt) AND ((last_day(ppd.proc_date))::timestamp without time zone <= ephu.eff_to_dt)))))))
     LEFT JOIN hr.vwr_employee_structure_details esd ON (((hr.f_desigfromposition((ephu.emp_position_id)::text) = esd.emp_dtl_id) AND (esd.status = (1)::numeric))))
     LEFT JOIN hr.vwr_employee_structure_details esd1 ON ((((ephu.emp_stafftype_code)::numeric = esd1.emp_dtl_id) AND (esd1.status = (1)::numeric))))
     LEFT JOIN hr.vwr_employee_structure_details esd2 ON ((((ephu.emp_cat_code)::numeric = esd2.emp_dtl_id) AND (esd2.status = (1)::numeric))))
     LEFT JOIN hr.vwr_employee_structure_details esd3 ON ((((ephu.emp_grade_id)::numeric = esd3.emp_dtl_id) AND (esd3.status = (1)::numeric))))
     LEFT JOIN ehis.vwr_coa_struct_details csd2 ON ((((hr.f_deptfromposition((ephu.emp_position_id)::text))::text = (csd2.chartid)::text) AND (csd2.status = (1)::numeric))))
     LEFT JOIN hr.vwr_employee_bank_details ebd ON (((ebd.emp_id = emd.employeeid) AND (ebd.status = (1)::numeric) AND (ebd.account_category_id = (281)::numeric))))
     LEFT JOIN ehis.vwr_accounttypemaster atm ON (((ebd.account_type_id = atm.accounttypeid) AND (atm.status = (1)::numeric))))
     LEFT JOIN hr.lovdetails ld ON (((ebd.account_category_id = ld.lovdetailid) AND (ld.status = (1)::numeric) AND (upper((ld.lovdetailvalue)::text) = 'SALARY ACCOUNT'::text))))
     LEFT JOIN ehis.vwr_bankbranchmaster bbrm ON (((bbrm.bankbranchid = ebd.bbank_branch_id) AND (bbrm.status = (1)::numeric))))
     LEFT JOIN ehis.vwr_bankmaster bbm ON (((bbm.bankid = ebd.bank_name_id) AND (bbm.status = (1)::numeric))))
  WHERE ((emd.status = (1)::numeric) AND (emd.employmentstatusid = ANY (ARRAY[(192)::numeric, (545)::numeric])) AND (((ld.lovdetailvalue)::text = 'SALARY ACCOUNT'::text) OR (ebd.account_category_id IS NULL)) AND ((emd.locationid)::text IN ( SELECT a.chartid
           FROM ehis.vwr_coa_struct_details a
          WHERE ((a.parentid)::text = '10800'::text))) AND ((emd.employeeid)::text !~~ '6%'::text) AND ((emd.employeeid)::text !~~ '9%'::text))
  ORDER BY (upper((emd.firstname)::text)), (upper((emd.lastname)::text));


CREATE OR REPLACE VIEW PAYROLL.PAY_EMP_MST_REP_INT_TRANS
(EMP_NO,EMP_TITLE,EMP_FIRST_NAME,EMP_MIDDLE_NAME,EMP_LAST_NAME,ENAME,EMP_GENDER,EMP_DESIG_CODE,EMP_DOB,EMP_DOJ,EMP_DEPT_CODE,EMP_STATUS,EMP_PAN,EMP_FATHER_NAME,EMP_DATE_OF_RETIRE,EMP_SEPARATION_DATE,EMP_CAT_CODE,EMP_STAFF_TYPE_CODE,EMP_CONF_DATE,EMP_PROB_DATE,EMP_WITH_EFFECT_FROM,EMP_GRADE_ID,EMP_POSITION_ID,EMP_DEPT_ID,EMP_AREA_CODE,EMP_TRANS_AREA_CODE,EMP_NOTICE_DATE,STAFFTYPE,CATEGORY,GRADE,POSITION,ACCOUNT_NO,BANKNAME,DEPARTMENTID,DESIGNATIONID,PFACCOUNTNO,SOCIALSECUIRETYNUMBER,CONTRACT_FROM,CONTRACT_TO,ACCOUNTDESC,PF_DETAILS,BANKID,ACCOUNTNAME,ACCOUNTTYPEID,BRANCHID,PRESENTEMPLOYEEID,DATEOFSEPERATION,DATEOFRESIGNATIONTENDERED,TITLEID,EMPLOYMENTSTATUSID)
AS
SELECT (emd.employeeid)::text EMP_NO,TM.TITLETYPE EMP_TITLE,
        emd.FIRSTNAME EMP_FIRST_NAME, emd.MIDDLENAME EMP_MIDDLE_NAME ,
        emd.LASTNAME EMP_LAST_NAME,
        TM.TITLETYPE||' '||EMD.FIRSTNAME||' '||EMD.Middlename||' '||EMD.LASTNAME ENAME,
        ' ' EMP_GENDER,
        INITCAP(ESD.NAME) EMP_DESIG_CODE,EMD.DOB EMP_DOB,EAD.PAYROLLPROCESSDATE EMP_DOJ,
        INITCAP(CSD2.LEVELDETAILNAME) EMP_DEPT_CODE,
--        DECODE(EMD.STATUS,1,'A',0,'N') EMP_STATUS,
        CASE
            WHEN (emd.status = (1)::numeric) THEN 'A'::text
            WHEN (emd.status = (0)::numeric) THEN 'N'::text
            ELSE NULL::text
        END AS emp_status,
        EAD.PAN_NUMBER EMP_PAN,
        /*EADD.ADDRESS1 EMP_PRESENT_ADD1,EADD.ADDRESS2 EMP_PRESENT_ADD2,' ' EMP_PRESENT_ADD3,
        ' ' EMP_PRESENT_TOWN,STM.STATENAME EMP_PRESENT_STATE,CTM.COUNTRYTYPE EMP_PRESENT_COUNTRY,
        EADD.PINCODE EMP_PRESENT_PIN_CODE,DM.DISTRICTNAME EMP_PRESENT_DISTRICT,
        EMD.PHYSICALLYHANDICAPPED EMP_HANDICAP_FLAG,*/EAD.FATHERNAME EMP_FATHER_NAME,
        EAD.Dueretirementdate EMP_DATE_OF_RETIRE,EAD.DATEOFLEAVING EMP_SEPARATION_dATE,
        EPHU.EMP_CAT_CODE EMP_CAT_CODE,EPHU.EMP_STAFFTYPE_CODE EMP_STAFF_TYPE_CODE,
        EAD.DATEOFCONFIRMATION EMP_CONF_DATE,EAD.PROBATIONSTARTDATE EMP_PROB_DATE,
        EAD.DATEOFJOINING EMP_WITH_EFFECT_FROM,EPHU.EMP_GRADE_ID EMP_GRADE_ID,
        EPHU.EMP_POSITION_ID EMP_POSITION_ID  ,
        hr.f_deptfromposition(ephu.emp_position_id) EMP_DEPT_ID
        /*EMD.DEPARTMENTID EMP_DEPT_ID*/-- coomented by chandra 0n 31st mar 10
        ,EMD.LOCATIONID EMP_AREA_CODE,epp.locationid EMP_TRANS_AREA_CODE,
        NULL EMP_NOTICE_DATE,
        INITCAP(ESD1.NAME) STAFFTYPE,INITCAP(ESD2.NAME) CATEGORY,INITCAP(ESD3.NAME) GRADE,
        INITCAP(CSD2.LEVELDETAILNAME||' - '||ESD.NAME) POSITION,
--        decode(ld.lovdetailid,null,null,EBD.ACCOUNT_NO) ACCOUNT_NO,
		CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL
            ELSE EBD.ACCOUNT_NO
        END AS ACCOUNT_NO,
--        decode(ld.lovdetailid,null,null,(BBM.BANKTNAME||' - '||BBRM.BANKBRANCHNAME)) BANKNAME,
		CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL
            ELSE (BBM.BANKTNAME||' - '||BBRM.BANKBRANCHNAME)
        END AS BANKNAME,
        /*EMD.DEPARTMENTID*/-- coomented by chandra 0n 31st mar 10
        hr.f_deptfromposition(ephu.emp_position_id) DEPARTMENTID,
        --EMD.DESIGNATIONID,
        hr.F_desigfromposition (ephu.emp_position_id) DESIGNATIONID ,
        EAD.PFNUMBER PFAccountNo,
        EAD.SOCIALSECUIRETYNUMBER,EAD.CONTRACT_FROM,EAD.CONTRACT_TO,
--        decode(ld.lovdetailid,null,null,ATM.ACCOUNTDESC) ACCOUNTDESC,
		CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL
            ELSE ATM.ACCOUNTDESC
        END AS ACCOUNTDESC,
        EAD.PF_DETAILS,

--        decode(ld.lovdetailid,null,null,ebd.bank_name_id) bankid,
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::numeric
            ELSE ebd.bank_name_id
        END AS bankid,
--        decode(ld.lovdetailid,null,null,ATM.Accountname) Accountname,
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::character varying
            ELSE atm.accountname
        END AS accountname,
--        decode(ld.lovdetailid,null,null,ATM.ACCOUNTTYPEID) ACCOUNTTYPEID,
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::numeric
            ELSE atm.accounttypeid
        END AS accounttypeid,
--        decode(ld.lovdetailid,null,null,EBD.BBANK_BRANCH_ID) BRANCHID,
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::numeric
            ELSE ebd.bbank_branch_id
        END AS branchid,
        EMD.Presentemployeeid , EAd.Dateofseperation ,
        ead.dateofresignationtendered,emd.titleid,emd.employmentstatusid
FROM HR.MV_EMPLOYEE_MAIN_DETAILS EMD
JOIN hr.vwr_emp_pay_processdetails epp ON epp.empno=emd.employeeid
JOIN ehis.vwr_titlemaster TM ON EMD.TITLEID = TM.TITLEID AND TM.STATUS=1
 JOIN HR.Vwr_EMPLOYEE_AUXILIARY_DETAILS EAD ON EMD.EMPLOYEEID = EAD.EMP_ID
 JOIN HR.EMP_PRM_HISTORY_UPDATE EPHU ON EMD.EMPLOYEEID=EPHU.EMP_NO::numeric
JOIN PAYROLL.PAY_PROC_DATE PPD ON PPD.LOCATIONID=epp.LOCATIONID 
AND 
--last_Day(ppd.proc_date) BETWEEN epp.startdate AND epp.enddate
((last_day(ppd.proc_date))::timestamp without time zone >= epp.startdate) AND ((last_day(ppd.proc_date))::timestamp without time zone <= epp.enddate)
AND (ead.payrollprocessdate IS NULL OR (ead.payrollprocessdate<=ppd.proc_date AND PPD.PROC_DATE BETWEEN EPHU.EFF_FROM_DT AND EPHU.EFF_TO_DT)
OR (ead.payrollprocessdate>ppd.proc_date AND 

--LAST_DAY(PPD.PROC_dATE) BETWEEN EPHU.EFF_fROM_dT AND EPHU.EFF_TO_DT))
((last_day(ppd.proc_date))::timestamp without time zone >= EPHU.EFF_fROM_dT) AND ((last_day(ppd.proc_date))::timestamp without time zone <= EPHU.EFF_TO_DT)))
left outer join hr.vwr_employee_structure_details esd
ON
hr.f_desigfromposition(ephu.emp_position_id)=ESD.EMP_DTL_ID AND ESD.STATUS=1
left outer join hr.vwr_employee_structure_details esd1
ON EPHU.EMP_STAFFTYPE_CODE::numeric =ESD1.EMP_DTL_ID AND ESD1.STATUS=1
left outer join hr.vwr_employee_structure_details esd2
ON EPHU.EMP_CAT_CODE::numeric =ESD2.EMP_DTL_ID AND ESD2.STATUS=1
left outer join hr.vwr_employee_structure_details esd3
ON EPHU.EMP_GRADE_ID::numeric =ESD3.EMP_DTL_ID AND ESD3.STATUS=1
left outer join ehis.vwr_coa_struct_details csd2
on hr.f_deptfromposition(ephu.emp_position_id)=csd2.chartid AND CSD2.STATUS=1
LEFT OUTER JOIN hr.vwr_employee_bank_details EBD ON EBD.EMP_ID = EMD.EMPLOYEEID AND EBD.STATUS=1
and ebd.account_category_id=281
LEFT OUTER JOIN ehis.vwr_accounttypemaster ATM ON EBD.ACCOUNT_TYPE_ID = ATM.ACCOUNTTYPEID
left outer join hr.lovdetails ld on ebd.account_category_id=ld.lovdetailid and ld.status=1
and upper(ld.lovdetailvalue)='SALARY ACCOUNT'
LEFT OUTER JOIN ehis.vwr_bankbranchmaster BBRM ON BBRM.BANKBRANCHID = EBD.BBANK_BRANCH_ID AND BBRM.STATUS=1
LEFT OUTER JOIN ehis.vwr_bankmaster BBM ON BBM.BANKID = EBD.BANK_NAME_ID AND BBM.STATUS=1
WHERE (EMD.Status = 1)and emd.employmentstatusid= 192
AND EAD.STOPPAYMENT=0 AND (LD.LOVDETAILVALUE='SALARY ACCOUNT' OR EBD.ACCOUNT_CATEGORY_ID IS NULL)
and emd.locationid in (select chartid from ehis.vwr_coa_struct_details a where a.parentid in ('10100','15100','10000','90000'))
and emd.employeeid not between 101894 and 102827
and 
--emd.employeeid not like '6%'
((emd.employeeid)::text !~~ '6%'::text)
--and emd.employeeid not like '8%'
and 
--emd.employeeid not like '9%'
((emd.employeeid)::text !~~ '9%'::text)
ORDER BY UPPER(emd.FIRSTNAME),UPPER(emd.LASTNAME);

CREATE OR REPLACE VIEW PAYROLL.PAY_EMP_MST_REP_BKP
(EMP_NO,EMP_TITLE,EMP_FIRST_NAME,EMP_MIDDLE_NAME,EMP_LAST_NAME,ENAME,EMP_GENDER,EMP_DESIG_CODE,EMP_DOB,EMP_DOJ,EMP_DEPT_CODE,EMP_STATUS,EMP_PAN,EMP_FATHER_NAME,EMP_DATE_OF_RETIRE,EMP_SEPARATION_DATE,EMP_CAT_CODE,EMP_STAFF_TYPE_CODE,EMP_CONF_DATE,EMP_PROB_DATE,EMP_WITH_EFFECT_FROM,EMP_GRADE_ID,EMP_POSITION_ID,EMP_DEPT_ID,EMP_AREA_CODE,EMP_NOTICE_DATE,STAFFTYPE,CATEGORY,GRADE,"POSITION",ACCOUNT_NO,BANKNAME,DEPARTMENTID,DESIGNATIONID,PFACCOUNTNO,SOCIALSECUIRETYNUMBER,CONTRACT_FROM,CONTRACT_TO,ACCOUNTDESC,PF_DETAILS,BANKID,ACCOUNTNAME,ACCOUNTTYPEID,BRANCHID,PRESENTEMPLOYEEID,DATEOFSEPERATION,DATEOFRESIGNATIONTENDERED,TITLEID,EMPLOYMENTSTATUSID)
AS
SELECT (emd.employeeid)::text EMP_NO,TM.TITLETYPE EMP_TITLE,
        emd.FIRSTNAME EMP_FIRST_NAME, emd.MIDDLENAME EMP_MIDDLE_NAME ,
        emd.LASTNAME EMP_LAST_NAME,
        TM.TITLETYPE||' '||EMD.FIRSTNAME||' '||EMD.Middlename||' '||EMD.LASTNAME ENAME,
        ' ' EMP_GENDER,
        INITCAP(ESD.NAME) EMP_DESIG_CODE,EMD.DOB EMP_DOB,EAD.PAYROLLPROCESSDATE EMP_DOJ,
        INITCAP(CSD2.LEVELDETAILNAME) EMP_DEPT_CODE,
--        DECODE(EMD.STATUS,1,'A',0,'N') EMP_STATUS
        CASE
            WHEN (emd.status = (1)::numeric) THEN 'A'::text
            WHEN (emd.status = (0)::numeric) THEN 'N'::text
            ELSE NULL::text
        END AS emp_status
        ,EAD.PAN_NUMBER EMP_PAN,
        /*EADD.ADDRESS1 EMP_PRESENT_ADD1,EADD.ADDRESS2 EMP_PRESENT_ADD2,' ' EMP_PRESENT_ADD3,
        ' ' EMP_PRESENT_TOWN,STM.STATENAME EMP_PRESENT_STATE,CTM.COUNTRYTYPE EMP_PRESENT_COUNTRY,
        EADD.PINCODE EMP_PRESENT_PIN_CODE,DM.DISTRICTNAME EMP_PRESENT_DISTRICT,
        EMD.PHYSICALLYHANDICAPPED EMP_HANDICAP_FLAG,*/EAD.FATHERNAME EMP_FATHER_NAME,
        EAD.Dueretirementdate EMP_DATE_OF_RETIRE,EAD.DATEOFLEAVING EMP_SEPARATION_dATE,
        EPHU.EMP_CAT_CODE EMP_CAT_CODE,EPHU.EMP_STAFFTYPE_CODE EMP_STAFF_TYPE_CODE,
        EAD.DATEOFCONFIRMATION EMP_CONF_DATE,EAD.PROBATIONSTARTDATE EMP_PROB_DATE,
        EAD.DATEOFJOINING EMP_WITH_EFFECT_FROM,EPHU.EMP_GRADE_ID EMP_GRADE_ID,
        EPHU.EMP_POSITION_ID EMP_POSITION_ID  ,
        hr.f_deptfromposition(ephu.emp_position_id) EMP_DEPT_ID
        /*EMD.DEPARTMENTID EMP_DEPT_ID*/-- coomented by chandra 0n 31st mar 10
        ,EMD.LOCATIONID EMP_AREA_CODE,
        NULL EMP_NOTICE_DATE,
        INITCAP(ESD1.NAME) STAFFTYPE,INITCAP(ESD2.NAME) CATEGORY,INITCAP(ESD3.NAME) GRADE,
        INITCAP(CSD2.LEVELDETAILNAME||' - '||ESD.NAME) POSITION,
--        decode(ld.lovdetailid,null,null,EBD.ACCOUNT_NO) ACCOUNT_NO,
        case 
        	when (ld.lovdetailid is null) then null 
        	else EBD.ACCOUNT_NO
        end ACCOUNT_NO,
--        decode(ld.lovdetailid,null,null,(BBM.BANKTNAME||' - '||BBRM.BANKBRANCHNAME)) BANKNAME,
        case 
        	when (ld.lovdetailid is null) then null 
        	else (BBM.BANKTNAME||' - '||BBRM.BANKBRANCHNAME)
        end BANKNAME,

        /*EMD.DEPARTMENTID*/-- coomented by chandra 0n 31st mar 10
        hr.f_deptfromposition(ephu.emp_position_id) DEPARTMENTID,
        --EMD.DESIGNATIONID,
        hr.F_desigfromposition (ephu.emp_position_id) DESIGNATIONID ,

EAD.PFNUMBER PFAccountNo,

        EAD.SOCIALSECUIRETYNUMBER,EAD.CONTRACT_FROM,EAD.CONTRACT_TO,
--        decode(ld.lovdetailid,null,null,ATM.ACCOUNTDESC) ACCOUNTDESC
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::character varying
            ELSE ATM.ACCOUNTDESC
        END AS ACCOUNTDESC
        ,EAD.PF_DETAILS,
--        decode(ld.lovdetailid,null,null,ebd.bank_name_id) bankid,
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL
            ELSE ebd.bank_name_id
        END AS bankid,
--        decode(ld.lovdetailid,null,null,ATM.Accountname) Accountname,
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::character varying
            ELSE ATM.Accountname
        END AS Accountname,
--        decode(ld.lovdetailid,null,null,ATM.ACCOUNTTYPEID) ACCOUNTTYPEID,
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL
            ELSE ATM.ACCOUNTTYPEID
        END AS ACCOUNTTYPEID,
--        decode(ld.lovdetailid,null,null,EBD.BBANK_BRANCH_ID) BRANCHID,
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL
            ELSE EBD.BBANK_BRANCH_ID
        END AS BRANCHID,        
        EMD.Presentemployeeid , EAd.Dateofseperation ,
        ead.dateofresignationtendered,emd.titleid,emd.employmentstatusid
FROM HR.MV_EMPLOYEE_MAIN_DETAILS EMD
JOIN ehis.vwr_titlemaster TM ON EMD.TITLEID = TM.TITLEID AND TM.STATUS=1
 JOIN HR.Vwr_EMPLOYEE_AUXILIARY_DETAILS EAD ON EMD.EMPLOYEEID = EAD.EMP_ID
 JOIN HR.EMP_PRM_HISTORY_UPDATE EPHU ON EMD.EMPLOYEEID=EPHU.EMP_NO::numeric
JOIN PAYROLL.PAY_PROC_DATE PPD ON PPD.LOCATIONID=EMD.LOCATIONID
AND (ead.payrollprocessdate IS NULL OR (ead.payrollprocessdate<=ppd.proc_date AND PPD.PROC_DATE BETWEEN EPHU.EFF_FROM_DT AND EPHU.EFF_TO_DT)
OR (ead.payrollprocessdate>ppd.proc_date AND 

--LAST_DAY(PPD.PROC_dATE) BETWEEN EPHU.EFF_fROM_dT AND EPHU.EFF_TO_DT
((last_day(ppd.proc_date))::timestamp without time zone >= ephu.eff_from_dt) AND ((last_day(ppd.proc_date))::timestamp without time zone <= ephu.eff_to_dt)))
left outer join hr.vwr_employee_structure_details esd
ON
hr.f_desigfromposition(ephu.emp_position_id)=ESD.EMP_DTL_ID AND ESD.STATUS=1
left outer join hr.vwr_employee_structure_details esd1
ON EPHU.EMP_STAFFTYPE_CODE::numeric  =ESD1.EMP_DTL_ID AND ESD1.STATUS=1
left outer join hr.vwr_employee_structure_details esd2
ON EPHU.EMP_CAT_CODE::numeric =ESD2.EMP_DTL_ID AND ESD2.STATUS=1
left outer join hr.vwr_employee_structure_details esd3
ON EPHU.EMP_GRADE_ID::numeric=ESD3.EMP_DTL_ID AND ESD3.STATUS=1
left outer join ehis.vwr_coa_struct_details csd2
on hr.f_deptfromposition(ephu.emp_position_id)=csd2.chartid AND CSD2.STATUS=1
LEFT OUTER JOIN hr.vwr_employee_bank_details EBD ON EBD.EMP_ID = EMD.EMPLOYEEID AND EBD.STATUS=1
and ebd.account_category_id=281
LEFT OUTER JOIN ehis.vwr_accounttypemaster ATM ON EBD.ACCOUNT_TYPE_ID = ATM.ACCOUNTTYPEID
AND ATM.STATUS=1
left outer join hr.lovdetails ld on ebd.account_category_id=ld.lovdetailid and ld.status=1
and upper(ld.lovdetailvalue)='SALARY ACCOUNT'
LEFT OUTER JOIN ehis.vwr_bankbranchmaster BBRM ON BBRM.BANKBRANCHID = EBD.BBANK_BRANCH_ID AND BBRM.STATUS=1
LEFT OUTER JOIN ehis.vwr_bankmaster BBM ON BBM.BANKID = EBD.BANK_NAME_ID AND BBM.STATUS=1
WHERE (EMD.Status = 1)and emd.employmentstatusid= 192
AND EAD.STOPPAYMENT=0 AND (LD.LOVDETAILVALUE='SALARY ACCOUNT' OR EBD.ACCOUNT_CATEGORY_ID IS NULL)
and emd.locationid in (select chartid from ehis.vwr_coa_struct_details a where a.parentid in ('10100','15100','10000','90000'))
and emd.employeeid not between 101894 and 102827
and 
--emd.employeeid not like '6%'
((emd.employeeid)::text !~~ '6%'::text)
--and emd.employeeid not like '8%'
and 
--emd.employeeid not like '9%'
((emd.employeeid)::text !~~ '9%'::text)
ORDER BY UPPER(emd.FIRSTNAME),UPPER(emd.LASTNAME);

create or replace view payroll.pay_emp_mst_rep as  SELECT (emd.employeeid)::character varying AS emp_no,
    tm.titletype AS emp_title,
    emd.firstname AS emp_first_name,
    emd.middlename AS emp_middle_name,
    emd.lastname AS emp_last_name,
    (((((((COALESCE(tm.titletype, ''::character varying))::text || ' '::text) || (COALESCE(emd.firstname, ''::character varying))::text) || ' '::text) || (COALESCE(emd.middlename, ''::character varying))::text) || ' '::text) || (COALESCE(emd.lastname, ''::character varying))::text) AS ename,
    ' '::text AS emp_gender,
    initcap((esd.name)::text) AS emp_desig_code,
    emd.dob AS emp_dob,
    ead.payrollprocessdate AS emp_doj,
    initcap((csd2.leveldetailname)::text) AS emp_dept_code,
        CASE
            WHEN (emd.status = (1)::numeric) THEN 'A'::text
            WHEN (emd.status = (0)::numeric) THEN 'N'::text
            ELSE NULL::text
        END AS emp_status,
    ead.pan_number AS emp_pan,
    ead.fathername AS emp_father_name,
    ead.dueretirementdate AS emp_date_of_retire,
    ead.dateofleaving AS emp_separation_date,
    ephu.emp_cat_code,
    ephu.emp_stafftype_code AS emp_staff_type_code,
    ead.dateofconfirmation AS emp_conf_date,
    ead.probationstartdate AS emp_prob_date,
    ead.dateofjoining AS emp_with_effect_from,
    ephu.emp_grade_id,
    ephu.emp_position_id,
    hr.f_deptfromposition((ephu.emp_position_id)::text) AS emp_dept_id,
    emd.locationid AS emp_area_code,
    epp.locationid AS emp_trans_area_code,
    NULL::text AS emp_notice_date,
    initcap((esd1.name)::text) AS stafftype,
    initcap((esd2.name)::text) AS category,
    initcap((esd3.name)::text) AS grade,
    initcap((((csd2.leveldetailname)::text || ' - '::text) || (esd.name)::text)) AS "position",
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::character varying
            ELSE ebd.account_no
        END AS account_no,
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::text
            ELSE (((bbm.banktname)::text || ' - '::text) || (bbrm.bankbranchname)::text)
        END AS bankname,
    hr.f_deptfromposition((ephu.emp_position_id)::text) AS departmentid,
    hr.f_desigfromposition((ephu.emp_position_id)::text) AS designationid,
    ead.pfnumber AS pfaccountno,
    ead.socialsecuiretynumber,
    ead.contract_from,
    ead.contract_to,
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::character varying
            ELSE atm.accountdesc
        END AS accountdesc,
    ead.pf_details,
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::numeric
            ELSE ebd.bank_name_id
        END AS bankid,
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::character varying
            ELSE atm.accountname
        END AS accountname,
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::numeric
            ELSE atm.accounttypeid
        END AS accounttypeid,
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::numeric
            ELSE ebd.bbank_branch_id
        END AS branchid,
    emd.presentemployeeid,
    ead.dateofseperation,
    ead.dateofresignationtendered,
    emd.titleid,
    emd.employmentstatusid,
    epp.locationid AS trans_location_id,
    een.accountno AS esi_no
   FROM (((((((((((((((((hr.mv_employee_main_details emd
     JOIN hr.vwr_emp_pay_processdetails epp ON ((epp.empno = emd.employeeid)))
     JOIN ehis.vwr_titlemaster tm ON (((emd.titleid = tm.titleid) AND (tm.status = (1)::numeric))))
     JOIN hr.Vwr_EMPLOYEE_AUXILIARY_DETAILS ead ON ((emd.employeeid = ead.emp_id)))
     JOIN hr.emp_prm_history_update ephu ON (((emd.employeeid)::text = (ephu.emp_no)::text)))
     JOIN payroll.pay_proc_date ppd ON ((((ppd.locationid)::text = (epp.locationid)::text) AND ((last_day(ppd.proc_date))::timestamp without time zone >= epp.startdate) AND ((last_day(ppd.proc_date))::timestamp without time zone <= epp.enddate) AND ((ead.payrollprocessdate IS NULL) OR ((ead.payrollprocessdate <= ppd.proc_date) AND ((PPD.PROC_DATE)::timestamp without time zone >= ephu.eff_from_dt) AND ((PPD.PROC_DATE)::timestamp without time zone <= ephu.eff_to_dt)) OR ((ead.payrollprocessdate > ppd.proc_date) AND ((last_day(ppd.proc_date))::timestamp without time zone >= ephu.eff_from_dt) AND ((last_day(ppd.proc_date))::timestamp without time zone <= ephu.eff_to_dt))))))
     LEFT JOIN hr.vwr_employee_structure_details esd ON (((hr.f_desigfromposition((ephu.emp_position_id)::text) = esd.emp_dtl_id) AND (esd.status = (1)::numeric))))
     LEFT JOIN hr.vwr_employee_structure_details esd1 ON ((((ephu.emp_stafftype_code)::text = ((esd1.emp_dtl_id)::character varying)::text) AND (esd1.status = (1)::numeric))))
     LEFT JOIN hr.vwr_employee_structure_details esd2 ON ((((ephu.emp_cat_code)::text = ((esd2.emp_dtl_id)::character varying)::text) AND (esd2.status = (1)::numeric))))
     LEFT JOIN hr.vwr_employee_structure_details esd3 ON ((((ephu.emp_grade_id)::text = ((esd3.emp_dtl_id)::character varying)::text) AND (esd3.status = (1)::numeric))))
     LEFT JOIN ehis.vwr_coa_struct_details csd2 ON ((((hr.f_deptfromposition((ephu.emp_position_id)::text))::text = (csd2.chartid)::text) AND (csd2.status = (1)::numeric))))
     LEFT JOIN hr.vwr_employee_bank_details ebd ON (((ebd.emp_id = emd.employeeid) AND (ebd.status = (1)::numeric) AND (ebd.account_category_id = (281)::numeric))))
     LEFT JOIN ehis.vwr_accounttypemaster atm ON (((ebd.account_type_id = atm.accounttypeid) AND (atm.status = (1)::numeric))))
     LEFT JOIN hr.lovdetails ld ON (((ebd.account_category_id = ld.lovdetailid) AND (ld.status = (1)::numeric) AND (upper((ld.lovdetailvalue)::text) = 'SALARY ACCOUNT'::text))))
     LEFT JOIN ehis.vwr_bankbranchmaster bbrm ON (((bbrm.bankbranchid = ebd.bbank_branch_id) AND (bbrm.status = (1)::numeric))))
     LEFT JOIN ehis.vwr_bankmaster bbm ON (((bbm.bankid = ebd.bank_name_id) AND (bbm.status = (1)::numeric))))
     LEFT JOIN hr.vwr_emp_esi_no een ON (((een.employeeid = emd.employeeid) AND (een.status = (1)::numeric) AND ((een.accounttype)::text = '46'::text)))))
  WHERE ((emd.status = (1)::numeric) AND (emd.employmentstatusid = (192)::numeric) AND (ead.stoppayment = (0)::numeric) AND (((ld.lovdetailvalue)::text = 'SALARY ACCOUNT'::text) OR (ebd.account_category_id IS NULL)) AND ((emd.locationid)::text IN ( SELECT a.chartid
           FROM ehis.vwr_coa_struct_details a
          WHERE ((a.parentid)::text = ANY (ARRAY[('10100'::character varying)::text, ('15100'::character varying)::text, ('10000'::character varying)::text, ('90000'::character varying)::text, ('10330'::character varying)::text, ('10340'::character varying)::text, ('10310'::character varying)::text, ('10300'::character varying)::text, ('10320'::character varying)::text])))) AND ((emd.employeeid < (101894)::numeric) OR (emd.employeeid > (102827)::numeric)) AND ((emd.employeeid)::text !~~ '6%'::text) AND ((emd.employeeid)::text !~~ '9%'::text))          
ORDER BY (upper((emd.firstname)::text)), (upper((emd.lastname)::text));

create or replace view payroll.pay_emp_mst_payslip as  
SELECT (emd.employeeid)::character varying AS emp_no,
    ead.payrollprocessdate AS emp_doj,
        CASE
            WHEN (emd.status = (1)::numeric) THEN 'A'::text
            WHEN (emd.status = (0)::numeric) THEN 'N'::text
            ELSE NULL::text
        END AS emp_status,
    ead.dateofleaving AS emp_separation_date,
    ephu.emp_cat_code,
    ephu.emp_stafftype_code AS emp_staff_type_code,
    ead.dateofconfirmation AS emp_conf_date,
    ead.dateofjoining AS emp_with_effect_from,
    ephu.emp_grade_id,
    ephu.emp_position_id,
    hr.f_deptfromposition((ephu.emp_position_id)::text) AS emp_dept_id,
    emd.locationid AS emp_area_code,
    hr.f_deptfromposition((ephu.emp_position_id)::text) AS departmentid,
    hr.f_desigfromposition((ephu.emp_position_id)::text) AS designationid,
    ead.pfnumber AS pfaccountno,
    ead.pf_details,
    ead.dateofseperation,
    ead.dateofresignationtendered,
    emd.employmentstatusid,
    epp.locationid AS trans_location_id,
    esn.societythrift,
    esn.esi
   FROM ((((((hr.mv_employee_main_details emd
     JOIN hr.Vwr_EMPLOYEE_AUXILIARY_DETAILS ead ON ((emd.employeeid = ead.emp_id)))
     JOIN hr.emp_prm_history_update ephu ON (((emd.employeeid)::text = (ephu.emp_no)::text)))
     JOIN payroll.pay_proc_date ppd ON ((((ppd.locationid)::text = (emd.locationid)::text) AND ((ead.payrollprocessdate IS NULL) OR ((ead.payrollprocessdate <= ppd.proc_date) AND (ppd.proc_date >= ephu.eff_from_dt) AND (ppd.proc_date <= ephu.eff_to_dt)) OR ((ead.payrollprocessdate > ppd.proc_date) AND ((last_day(ppd.proc_date))::timestamp without time zone >= ephu.eff_from_dt) AND ((last_day(ppd.proc_date))::timestamp without time zone <= ephu.eff_to_dt))))))
     JOIN hr.vwr_emp_pay_processdetails epp ON (((epp.empno = emd.employeeid) AND ((last_day(ppd.proc_date))::timestamp without time zone >= epp.startdate) AND ((last_day(ppd.proc_date))::timestamp without time zone <= epp.enddate))))
     JOIN payroll.v_location_mst vm ON (((vm.chartid)::text = (emd.locationid)::text)))
     LEFT JOIN payroll.pay_esi_no esn ON ((esn.employeeid = emd.employeeid)))
  WHERE ((emd.status = (1)::numeric) AND (ead.stoppayment = (0)::numeric) AND ((emd.employeeid)::text !~~ '6%'::text) AND ((emd.employeeid)::text !~~ '9%'::text)
       
AND emd.employeeid not in
( select PLMR.EMP_NO::numeric from payroll.pay_lev_monthly_register PLMR
      where PLMR.Lev_Availed=
          (select 
          (EXTRACT(EPOCH FROM (public.Last_date(PPD1.PROC_DATE) - PPD1.PROC_DATE))/(24*60*60)) +1
--          public.Last_date(PPD1.PROC_DATE)- PPD1.PROC_DATE + interval '1 day' 
          from payroll.Pay_Proc_Date PPD1
            where ppd1.locationid= EMd.Locationid)
      and UPPEr(plmr.lev_month)=
           (select to_char(PPD1.PROC_DATE, 'MON') from payroll.Pay_Proc_Date PPD1 where
           PPD1.Locationid=EMd.Locationid)
           and status =1
     and PLMR.lev_year=
           (select to_char(PPD1.PROC_DATE, 'YYYY') from payroll.Pay_Proc_Date PPD1 where
           PPD1.Locationid=EMd.Locationid)::numeric
           and status =1)

AND ((emd.locationid)::text IN ( SELECT csd.chartid
           FROM ehis.vwr_coa_struct_details csd
          WHERE ((csd.parentid)::text = ANY (ARRAY[('10000'::character varying)::text,('10100'::character varying)::text,('10330'::character varying)::text,('15100'::character varying)::text,('90000'::character varying)::text,('10340'::character varying)::text,('10300'::character varying)::text])))));

        


create or replace view payroll.pay_emp_mst_medicalcoverage as  SELECT (emd.employeeid)::character varying AS emp_no,
    tm.titletype AS emp_title,
    emd.firstname AS emp_first_name,
    emd.middlename AS emp_middle_name,
    emd.lastname AS emp_last_name,
    (((((((COALESCE(tm.titletype, ''::character varying))::text || ' '::text) || (COALESCE(emd.firstname, ''::character varying))::text) || ' '::text) || (COALESCE(emd.middlename, ''::character varying))::text) || ' '::text) || (COALESCE(emd.lastname, ''::character varying))::text) AS ename,
    ' '::text AS emp_gender,
    initcap((esd.name)::text) AS emp_desig_code,
    floor((months_between((CURRENT_TIMESTAMP(0))::timestamp without time zone, emd.dob) / (12)::numeric)) AS age,
    emd.dob AS emp_dob,
    ead.dateofjoining AS emp_doj,
    initcap((csd2.leveldetailname)::text) AS emp_dept_code,
        CASE
            WHEN (emd.status = (1)::numeric) THEN 'A'::text
            WHEN (emd.status = (0)::numeric) THEN 'N'::text
            ELSE NULL::text
        END AS emp_status,
    ead.pan_number AS emp_pan,
    ead.fathername AS emp_father_name,
    ead.dueretirementdate AS emp_date_of_retire,
    ead.dateofleaving AS emp_separation_date,
    ephu.emp_cat_code,
    ephu.emp_stafftype_code AS emp_staff_type_code,
    ead.dateofconfirmation AS emp_conf_date,
    ead.probationstartdate AS emp_prob_date,
    ead.dateofjoining AS emp_with_effect_from,
    ephu.emp_grade_id,
    ephu.emp_position_id,
    hr.f_deptfromposition((ephu.emp_position_id)::text) AS emp_dept_id,
    emd.locationid AS emp_area_code,
    NULL::text AS emp_notice_date,
    initcap((esd1.name)::text) AS stafftype,
    initcap((esd2.name)::text) AS category,
    initcap((esd3.name)::text) AS grade,
    initcap((((csd2.leveldetailname)::text || ' - '::text) || (esd.name)::text)) AS "position",
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::character varying
            ELSE ebd.account_no
        END AS account_no,
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::text
            ELSE (((bbm.banktname)::text || ' - '::text) || (bbrm.bankbranchname)::text)
        END AS bankname,
    hr.f_deptfromposition((ephu.emp_position_id)::text) AS departmentid,
    hr.f_desigfromposition((ephu.emp_position_id)::text) AS designationid,
    ead.pfnumber AS pfaccountno,
    ead.socialsecuiretynumber,
    ead.contract_from,
    ead.contract_to,
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::character varying
            ELSE atm.accountdesc
        END AS accountdesc,
    ead.pf_details,
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::numeric
            ELSE ebd.bank_name_id
        END AS bankid,
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::character varying
            ELSE atm.accountname
        END AS accountname,
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::numeric
            ELSE atm.accounttypeid
        END AS accounttypeid,
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::numeric
            ELSE ebd.bbank_branch_id
        END AS branchid,
    emd.presentemployeeid,
    ead.dateofseperation,
    vm.locationname,
    ead.dateofresignationtendered,
    emd.titleid,
    emd.employmentstatusid,
    ead.trialstartdate,
    ead.trialenddate,
    epp.locationid AS trans_location_id,
    csd11.leveldetailname AS transfer_location,
    een.accountno AS esi_no,
    ebn.uan_number
   FROM (((((((((((((((((((hr.mv_employee_main_details emd
     JOIN ehis.vwr_titlemaster tm ON (((emd.titleid = tm.titleid) AND (tm.status = (1)::numeric))))
     JOIN hr.Vwr_EMPLOYEE_AUXILIARY_DETAILS ead ON ((emd.employeeid = ead.emp_id)))
     JOIN hr.vwr_emp_prm_history ephu ON (((emd.employeeid)::text = (ephu.emp_no)::text)))
     JOIN payroll.pay_proc_date ppd ON ((((ppd.locationid)::text = (emd.locationid)::text) AND ((ead.payrollprocessdate IS NULL) OR ((ead.payrollprocessdate <= ppd.proc_date) AND (ppd.proc_date >= ephu.eff_from_dt) AND (ppd.proc_date <= ephu.eff_to_dt)) OR ((ead.payrollprocessdate > ppd.proc_date) AND ((last_day(ppd.proc_date))::timestamp without time zone >= ephu.eff_from_dt) AND ((last_day(ppd.proc_date))::timestamp without time zone <= ephu.eff_to_dt))))))
     JOIN hr.vwr_emp_pay_processdetails epp ON (((epp.empno = emd.employeeid) AND ((last_day(ppd.proc_date))::timestamp without time zone >= epp.startdate) AND ((last_day(ppd.proc_date))::timestamp without time zone <= epp.enddate))))
     LEFT JOIN hr.vwr_employee_structure_details esd ON (((hr.f_desigfromposition((ephu.emp_position_id)::text) = esd.emp_dtl_id) AND (esd.status = (1)::numeric))))
     LEFT JOIN hr.vwr_employee_structure_details esd1 ON ((((ephu.emp_stafftype_code)::text = ((esd1.emp_dtl_id)::character varying)::text) AND (esd1.status = (1)::numeric))))
     LEFT JOIN hr.vwr_employee_structure_details esd2 ON ((((ephu.emp_cat_code)::text = ((esd2.emp_dtl_id)::character varying)::text) AND (esd2.status = (1)::numeric))))
     LEFT JOIN hr.vwr_employee_structure_details esd3 ON ((((ephu.emp_grade_id)::text = ((esd3.emp_dtl_id)::character varying)::text) AND (esd3.status = (1)::numeric))))
     LEFT JOIN ehis.vwr_coa_struct_details csd2 ON ((((hr.f_deptfromposition((ephu.emp_position_id)::text))::text = (csd2.chartid)::text) AND (csd2.status = (1)::numeric))))
     LEFT JOIN hr.vwr_employee_bank_details ebd ON (((ebd.emp_id = emd.employeeid) AND (ebd.status = (1)::numeric) AND (ebd.account_category_id = (281)::numeric))))
     LEFT JOIN ehis.vwr_accounttypemaster atm ON (((ebd.account_type_id = atm.accounttypeid) AND (atm.status = (1)::numeric))))
     LEFT JOIN hr.lovdetails ld ON (((ebd.account_category_id = ld.lovdetailid) AND (ld.status = (1)::numeric) AND (upper((ld.lovdetailvalue)::text) = 'SALARY ACCOUNT'::text))))
     LEFT JOIN ehis.vwr_bankbranchmaster bbrm ON (((bbrm.bankbranchid = ebd.bbank_branch_id) AND (bbrm.status = (1)::numeric))))
     LEFT JOIN ehis.vwr_bankmaster bbm ON (((bbm.bankid = ebd.bank_name_id) AND (bbm.status = (1)::numeric))))
     LEFT JOIN hr.vwr_emp_esi_no een ON (((een.employeeid = emd.employeeid) AND (een.status = (1)::numeric) AND ((een.accounttype)::text = '46'::text))))
     LEFT JOIN hr.vwr_emp_benefit_details ebn ON ((ebn.emp_id = emd.employeeid)))
     JOIN payroll.v_location_mst vm ON (((vm.chartid)::text = (emd.locationid)::text)))
     JOIN ehis.vwr_coa_struct_details csd11 ON (((csd11.chartid)::text = (epp.locationid)::text)))
  WHERE ((emd.status = (1)::numeric) AND (ead.stoppayment = (0)::numeric) AND (((ld.lovdetailvalue)::text = 'SALARY ACCOUNT'::text) OR (ebd.account_category_id IS NULL)) AND ((emd.locationid)::text IN ( SELECT a.chartid
           FROM ehis.vwr_coa_struct_details a
          WHERE ((a.parentid)::text = ANY (ARRAY[('10100'::character varying)::text, ('15100'::character varying)::text, ('90000'::character varying)::text, ('10000'::character varying)::text, ('10330'::character varying)::text, ('10340'::character varying)::text, ('10310'::character varying)::text, ('10300'::character varying)::text, ('10320'::character varying)::text])))) AND ((emd.employeeid)::text !~~ '6%'::text) AND ((emd.employeeid)::text !~~ '7%'::text) AND ((emd.employeeid)::text !~~ '9%'::text) AND (emd.employmentstatusid = '192'::numeric))
  ORDER BY (upper((emd.firstname)::text)), (upper((emd.lastname)::text));

CREATE OR REPLACE VIEW PAYROLL.PAY_EMP_MST_HIS_BKP
(EMP_NO,EMP_TITLE,EMP_FIRST_NAME,EMP_MIDDLE_NAME,EMP_LAST_NAME,ENAME,EMP_GENDER,EMP_DESIG_CODE,EMP_DOB,EMP_DOJ,EMP_DEPT_CODE,EMP_STATUS,EMP_PAN,EMP_HANDICAP_FLAG,EMP_FATHER_NAME,EMP_DATE_OF_RETIRE,EMP_SEPARATION_DATE,EMP_CAT_CODE,EMP_STAFF_TYPE_CODE,EMP_CONF_DATE,EMP_PROB_DATE,EMP_WITH_EFFECT_FROM,EMP_GRADE_ID,EMP_POSITION_ID,EMP_DEPT_ID,EMP_AREA_CODE,EMP_NOTICE_DATE,STAFFTYPE,CATEGORY,GRADE,"POSITION",ACCOUNT_NO,BANKNAME,DEPARTMENTID,DESIGNATIONID,PFACCOUNTNO,SOCIALSECUIRETYNUMBER,CONTRACT_FROM,CONTRACT_TO,ACCOUNTDESC,PF_DETAILS,BANKID,ACCOUNTNAME,ACCOUNT_TYPE_ID,PAY_MONTH,PAY_YEAR)
AS
SELECT (emd.employeeid)::text EMP_NO,TM.TITLETYPE EMP_TITLE,
       EMD.FIRSTNAME EMP_FIRST_NAME, EMD.MIDDLENAME EMP_MIDDLE_NAME ,
       EMD.LASTNAME EMP_LAST_NAME,
       TM.TITLETYPE||' '||EMD.FIRSTNAME||' '||EMD.LASTNAME ENAME,
        ' ' EMP_GENDER,
       INITCAP(ESD.NAME) EMP_DESIG_CODE,EMD.DOB EMP_DOB,EAD.PAYROLLPROCESSDATE EMP_DOJ,
       INITCAP(CSD2.LEVELDETAILNAME) EMP_DEPT_CODE,
--       DECODE(EMD.STATUS,1,'A',0,'N') EMP_STATUS,
        CASE
            WHEN (emd.status = (1)::numeric) THEN 'A'::text
            WHEN (emd.status = (0)::numeric) THEN 'N'::text
            ELSE NULL::text
        END AS emp_status,
       EAD.PAN_NUMBER EMP_PAN,
       EMD.PHYSICALLYHANDICAPPED EMP_HANDICAP_FLAG,EAD.FATHERNAME EMP_FATHER_NAME,
       EAD.Dueretirementdate EMP_DATE_OF_RETIRE,EAD.DATEOFLEAVING EMP_SEPARATION_dATE,
       Eh.Employeecategoryid EMP_CAT_CODE,EH.Employeetypeid EMP_STAFF_TYPE_CODE,
       EAD.DATEOFCONFIRMATION EMP_CONF_DATE,EAD.PROBATIONSTARTDATE EMP_PROB_DATE,
       EAD.DATEOFJOINING EMP_WITH_EFFECT_FROM,EH.Gradeid EMP_GRADE_ID,
       EH.Positionid EMP_POSITION_ID  ,
       EMD.DEPARTMENTID EMP_DEPT_ID,EMD.LOCATIONID EMP_AREA_CODE,
       NULL EMP_NOTICE_DATE,
       INITCAP(ESD1.NAME) STAFFTYPE,INITCAP(ESD2.NAME) CATEGORY,INITCAP(ESD3.NAME) GRADE,
       INITCAP(CSD2.LEVELDETAILNAME||' - '||ESD.NAME) POSITION,
       EBD.ACCOUNT_NO,(BBM.BANKTNAME||' - '||BBRM.BANKBRANCHNAME) BANKNAME,
       EMD.DEPARTMENTID,EMD.DESIGNATIONID, 
EAD.PFNUMBER PFAccountNo,
        EAD.SOCIALSECUIRETYNUMBER,EAD.CONTRACT_FROM,EAD.CONTRACT_TO,ATM.ACCOUNTDESC,EAD.PF_DETAILS,
       ebd.bank_name_id bankid, ATM.Accountname,EBD.ACCOUNT_TYPE_ID , EH.Pay_Month, EH.Pay_Year
     
FROM HR.MV_EMPLOYEE_MAIN_DETAILS EMD
JOIN PAYROLL.Emp_History EH   ON EH.Emp_No= EMd.Employeeid  
JOIN ehis.vwr_titlemaster TM ON EMD.TITLEID = TM.TITLEID AND TM.STATUS=1
JOIN HR.Vwr_EMPLOYEE_AUXILIARY_DETAILS EAD ON EMD.EMPLOYEEID = EAD.EMP_ID
--JOIN HR.EMP_PRM_HISTORY_UPDATE EPHU ON EMD.EMPLOYEEID=EPHU.EMP_NO
JOIN PAYROLL.PAY_PROC_DATE PPD ON PPD.LOCATIONID=EMD.LOCATIONID
--AND ( '01'||'-'||eh.pay_month||'-'||eh.pay_year  BETWEEN to_char(EPHU.EFF_FROM_DT,'dd-MON-yyyy') AND to_char(EPHU.EFF_TO_DT, 'DD-MON-yyyy')
--OR LAST_DAY('01'||'-'||eh.pay_month||'-'||eh.pay_year) BETWEEN to_char(EPHU.EFF_fROM_dT,'dd-MON-yyyy') AND to_char(EPHU.EFF_TO_DT,'dd-MON-yyyy'))
left outer join hr.vwr_employee_structure_details esd
ON
HR.f_desigfromposition(eh.positionid)=ESD.EMP_DTL_ID AND ESD.STATUS=1
left outer join hr.vwr_employee_structure_details esd1
ON Eh.Employeetypeid=ESD1.EMP_DTL_ID AND ESD1.STATUS=1
left outer join hr.vwr_employee_structure_details esd2
ON Eh.Employeecategoryid =ESD2.EMP_DTL_ID AND ESD2.STATUS=1
left outer join hr.vwr_employee_structure_details esd3
ON Eh.Gradeid=ESD3.EMP_DTL_ID AND ESD3.STATUS=1
left outer join ehis.vwr_coa_struct_details csd2
on HR.f_deptfromposition(eh.positionid)=csd2.chartid AND CSD2.STATUS=1
LEFT OUTER JOIN hr.vwr_employee_bank_details EBD ON EBD.EMP_ID = EMD.EMPLOYEEID AND EBD.STATUS=1
and ebd.account_category_id= 281
LEFT OUTER JOIN ehis.vwr_accounttypemaster ATM ON EBD.ACCOUNT_TYPE_ID = ATM.ACCOUNTTYPEID
AND ATM.STATUS=1
LEFT OUTER JOIN ehis.vwr_bankbranchmaster BBRM ON BBRM.BANKBRANCHID = EBD.BBANK_BRANCH_ID AND BBRM.STATUS=1
LEFT OUTER JOIN ehis.vwr_bankmaster BBM ON BBM.BANKID = EBD.BANK_NAME_ID AND BBM.STATUS=1
WHERE (EMD.Status = 1)
ORDER BY UPPER(EMd.FIRSTNAME),UPPER(EMD.LASTNAME);

CREATE OR REPLACE VIEW PAYROLL.PAY_EMP_MST_HIS
(EMP_NO,EMP_TITLE,EMP_FIRST_NAME,EMP_MIDDLE_NAME,EMP_LAST_NAME,ENAME,EMP_GENDER,EMP_DESIG_CODE,EMP_DOB,EMP_DOJ,EMP_DEPT_CODE,EMP_STATUS,EMP_PAN,EMP_HANDICAP_FLAG,EMP_FATHER_NAME,EMP_DATE_OF_RETIRE,EMP_SEPARATION_DATE,EMP_CAT_CODE,EMP_STAFF_TYPE_CODE,EMP_CONF_DATE,EMP_PROB_DATE,EMP_WITH_EFFECT_FROM,EMP_GRADE_ID,EMP_POSITION_ID,EMP_DEPT_ID,EMP_AREA_CODE,EMP_TRANS_AREA_CODE,EMP_NOTICE_DATE,STAFFTYPE,CATEGORY,GRADE,"POSITION",ACCOUNT_NO,BANKNAME,DEPARTMENTID,DESIGNATIONID,PFACCOUNTNO,SOCIALSECUIRETYNUMBER,CONTRACT_FROM,CONTRACT_TO,ACCOUNTDESC,PF_DETAILS,BANKID,ACCOUNTNAME,ACCOUNT_TYPE_ID,PAY_MONTH,PAY_YEAR)
AS
SELECT (emd.employeeid)::text EMP_NO,TM.TITLETYPE EMP_TITLE,
       EMD.FIRSTNAME EMP_FIRST_NAME, EMD.MIDDLENAME EMP_MIDDLE_NAME ,
       EMD.LASTNAME EMP_LAST_NAME,
       TM.TITLETYPE||' '||EMD.FIRSTNAME||' '||EMD.LASTNAME ENAME,
        ' ' EMP_GENDER,
       INITCAP(ESD.NAME) EMP_DESIG_CODE,EMD.DOB EMP_DOB,EAD.PAYROLLPROCESSDATE EMP_DOJ,
       INITCAP(CSD2.LEVELDETAILNAME) EMP_DEPT_CODE,
--       DECODE(EMD.STATUS,1,'A',0,'N') EMP_STATUS,
        CASE
            WHEN (emd.status = (1)::numeric) THEN 'A'::text
            WHEN (emd.status = (0)::numeric) THEN 'N'::text
            ELSE NULL::text
        END AS emp_status,       
       EAD.PAN_NUMBER EMP_PAN,
       EMD.PHYSICALLYHANDICAPPED EMP_HANDICAP_FLAG,EAD.FATHERNAME EMP_FATHER_NAME,
       EAD.Dueretirementdate EMP_DATE_OF_RETIRE,EAD.DATEOFLEAVING EMP_SEPARATION_dATE,
       Eh.Employeecategoryid EMP_CAT_CODE,EH.Employeetypeid EMP_STAFF_TYPE_CODE,
       EAD.DATEOFCONFIRMATION EMP_CONF_DATE,EAD.PROBATIONSTARTDATE EMP_PROB_DATE,
       EAD.DATEOFJOINING EMP_WITH_EFFECT_FROM,EH.Gradeid EMP_GRADE_ID,
       EH.Positionid EMP_POSITION_ID  ,
       EMD.DEPARTMENTID EMP_DEPT_ID,EMD.LOCATIONID EMP_AREA_CODE,eh.trans_location_id EMP_TRANS_AREA_CODE,
       NULL EMP_NOTICE_DATE,
       INITCAP(ESD1.NAME) STAFFTYPE,INITCAP(ESD2.NAME) CATEGORY,INITCAP(ESD3.NAME) GRADE,
       INITCAP(CSD2.LEVELDETAILNAME||' - '||ESD.NAME) POSITION,
       EBD.ACCOUNT_NO,(BBM.BANKTNAME||' - '||BBRM.BANKBRANCHNAME) BANKNAME,
       EMD.DEPARTMENTID,EMD.DESIGNATIONID, 
EAD.PFNUMBER PFAccountNo,
        EAD.SOCIALSECUIRETYNUMBER,EAD.CONTRACT_FROM,EAD.CONTRACT_TO,ATM.ACCOUNTDESC,EAD.PF_DETAILS,
       ebd.bank_name_id bankid, ATM.Accountname,EBD.ACCOUNT_TYPE_ID , EH.Pay_Month, EH.Pay_Year
     
FROM HR.MV_EMPLOYEE_MAIN_DETAILS EMD
JOIN PAYROLL.Emp_History EH   ON EH.Emp_No= EMd.Employeeid  
JOIN ehis.vwr_titlemaster TM ON EMD.TITLEID = TM.TITLEID AND TM.STATUS=1
JOIN HR.Vwr_EMPLOYEE_AUXILIARY_DETAILS EAD ON EMD.EMPLOYEEID = EAD.EMP_ID
--JOIN HR.EMP_PRM_HISTORY_UPDATE EPHU ON EMD.EMPLOYEEID=EPHU.EMP_NO
JOIN PAYROLL.PAY_PROC_DATE PPD ON PPD.LOCATIONID=EMD.LOCATIONID
--AND ( '01'||'-'||eh.pay_month||'-'||eh.pay_year  BETWEEN to_char(EPHU.EFF_FROM_DT,'dd-MON-yyyy') AND to_char(EPHU.EFF_TO_DT, 'DD-MON-yyyy')
--OR LAST_DAY('01'||'-'||eh.pay_month||'-'||eh.pay_year) BETWEEN to_char(EPHU.EFF_fROM_dT,'dd-MON-yyyy') AND to_char(EPHU.EFF_TO_DT,'dd-MON-yyyy'))
left outer join hr.vwr_employee_structure_details esd
ON
HR.f_desigfromposition(eh.positionid)=ESD.EMP_DTL_ID AND ESD.STATUS=1
left outer join hr.vwr_employee_structure_details esd1
ON Eh.Employeetypeid=ESD1.EMP_DTL_ID AND ESD1.STATUS=1
left outer join hr.vwr_employee_structure_details esd2
ON Eh.Employeecategoryid =ESD2.EMP_DTL_ID AND ESD2.STATUS=1
left outer join hr.vwr_employee_structure_details esd3
ON Eh.Gradeid=ESD3.EMP_DTL_ID AND ESD3.STATUS=1
left outer join ehis.vwr_coa_struct_details csd2
on HR.f_deptfromposition(eh.positionid)=csd2.chartid AND CSD2.STATUS=1
LEFT OUTER JOIN hr.vwr_employee_bank_details EBD ON EBD.EMP_ID = EMD.EMPLOYEEID AND EBD.STATUS=1
and ebd.account_category_id= 281
LEFT OUTER JOIN ehis.vwr_accounttypemaster ATM ON EBD.ACCOUNT_TYPE_ID = ATM.ACCOUNTTYPEID
AND ATM.STATUS=1
LEFT OUTER JOIN ehis.vwr_bankbranchmaster BBRM ON BBRM.BANKBRANCHID = EBD.BBANK_BRANCH_ID AND BBRM.STATUS=1
LEFT OUTER JOIN ehis.vwr_bankmaster BBM ON BBM.BANKID = EBD.BANK_NAME_ID AND BBM.STATUS=1
WHERE (EMD.Status = 1)
ORDER BY UPPER(EMd.FIRSTNAME),UPPER(EMD.LASTNAME);
CREATE OR REPLACE VIEW PAYROLL.PAY_EMP_MST_BKP
(EMP_NO,EMP_TITLE,EMP_FIRST_NAME,EMP_MIDDLE_NAME,EMP_LAST_NAME,ENAME,EMP_GENDER,EMP_DESIG_CODE,EMP_DOB,EMP_DOJ,EMP_DEPT_CODE,EMP_STATUS,EMP_PAN,EMP_FATHER_NAME,EMP_DATE_OF_RETIRE,EMP_SEPARATION_DATE,EMP_CAT_CODE,EMP_STAFF_TYPE_CODE,EMP_CONF_DATE,EMP_PROB_DATE,EMP_WITH_EFFECT_FROM,EMP_GRADE_ID,EMP_POSITION_ID,EMP_DEPT_ID,EMP_AREA_CODE,EMP_NOTICE_DATE,STAFFTYPE,CATEGORY,GRADE,"POSITION",ACCOUNT_NO,BANKNAME,DEPARTMENTID,DESIGNATIONID,PFACCOUNTNO,SOCIALSECUIRETYNUMBER,CONTRACT_FROM,CONTRACT_TO,ACCOUNTDESC,PF_DETAILS,BANKID,ACCOUNTNAME,ACCOUNTTYPEID,BRANCHID,PRESENTEMPLOYEEID,DATEOFSEPERATION,LOCATIONNAME,DATEOFRESIGNATIONTENDERED,TITLEID,EMPLOYMENTSTATUSID,TRIALSTARTDATE,TRIALENDDATE)
AS
SELECT (emd.employeeid)::text EMP_NO,TM.TITLETYPE EMP_TITLE,FIRSTNAME EMP_FIRST_NAME, MIDDLENAME EMP_MIDDLE_NAME ,
  LASTNAME EMP_LAST_NAME,TM.TITLETYPE||' '||EMD.FIRSTNAME||' '||EMD.MIDDLENAME||' '||EMD.LASTNAME ENAME,
  ' ' EMP_GENDER,INITCAP(ESD.NAME) EMP_DESIG_CODE,EMD.DOB EMP_DOB,EAD.PAYROLLPROCESSDATE EMP_DOJ,
  INITCAP(CSD2.LEVELDETAILNAME) EMP_DEPT_CODE,
--  DECODE(EMD.STATUS,1,'A',0,'N') EMP_STATUS,
          CASE
            WHEN (emd.status = (1)::numeric) THEN 'A'::text
            WHEN (emd.status = (0)::numeric) THEN 'N'::text
            ELSE NULL::text
        END AS emp_status,
  EAD.PAN_NUMBER EMP_PAN,
  EAD.FATHERNAME EMP_FATHER_NAME,EAD.Dueretirementdate EMP_DATE_OF_RETIRE,EAD.DATEOFLEAVING EMP_SEPARATION_dATE,
  EPHU.EMP_CAT_CODE EMP_CAT_CODE,EPHU.EMP_STAFFTYPE_CODE EMP_STAFF_TYPE_CODE,
  EAD.DATEOFCONFIRMATION EMP_CONF_DATE,EAD.PROBATIONSTARTDATE EMP_PROB_DATE,
  EAD.DATEOFJOINING EMP_WITH_EFFECT_FROM,EPHU.EMP_GRADE_ID EMP_GRADE_ID,
  EPHU.EMP_POSITION_ID EMP_POSITION_ID,hr.f_deptfromposition(ephu.emp_position_id) EMP_DEPT_ID,
  EMD.LOCATIONID EMP_AREA_CODE,NULL EMP_NOTICE_DATE,INITCAP(ESD1.NAME) STAFFTYPE,INITCAP(ESD2.NAME) CATEGORY,INITCAP(ESD3.NAME) GRADE,
  INITCAP(CSD2.LEVELDETAILNAME||' - '||ESD.NAME) POSITION,
--  decode(ld.lovdetailid,null,null,EBD.ACCOUNT_NO) ACCOUNT_NO,
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::character varying
            ELSE ebd.account_no
        END AS account_no,
--  decode(ld.lovdetailid,null,null,(BBM.BANKTNAME||' - '||BBRM.BANKBRANCHNAME)) BANKNAME,
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::text
            ELSE (((bbm.banktname)::text || ' - '::text) || (bbrm.bankbranchname)::text)
        END AS bankname,
  hr.f_deptfromposition(ephu.emp_position_id) DEPARTMENTID, hr.F_desigfromposition (ephu.emp_position_id) DESIGNATIONID ,
  EAD.PFNUMBER PFAccountNo,EAD.SOCIALSECUIRETYNUMBER,EAD.CONTRACT_FROM,EAD.CONTRACT_TO,
--  decode(ld.lovdetailid,null,null,ATM.ACCOUNTDESC) ACCOUNTDESC
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL
            ELSE ATM.ACCOUNTDESC
        END AS ACCOUNTDESC,
  EAD.PF_DETAILS,
--  decode(ld.lovdetailid,null,null,ebd.bank_name_id) bankid,
    CASE
        WHEN (ld.lovdetailid IS NULL) THEN NULL::numeric
        ELSE ebd.bank_name_id
    END AS bankid,
--  decode(ld.lovdetailid,null,null,ATM.Accountname) Accountname,
    CASE
        WHEN (ld.lovdetailid IS NULL) THEN NULL::character varying
        ELSE atm.accountname
    END AS accountname,
--  decode(ld.lovdetailid,null,null,ATM.ACCOUNTTYPEID) ACCOUNTTYPEID,
    CASE
        WHEN (ld.lovdetailid IS NULL) THEN NULL::numeric
        ELSE atm.accounttypeid
    END AS accounttypeid,
--    decode(ld.lovdetailid,null,null,EBD.BBANK_BRANCH_ID) BRANCHID,
    CASE
        WHEN (ld.lovdetailid IS NULL) THEN NULL::numeric
        ELSE ebd.bbank_branch_id
    END AS branchid,
  EMD.Presentemployeeid , EAd.Dateofseperation, VM.LocationName,
  ead.dateofresignationtendered,emd.titleid,emd.employmentstatusid
  ,trialstartdate,trialenddate
FROM HR.MV_EMPLOYEE_MAIN_DETAILS EMD
JOIN ehis.vwr_titlemaster TM ON EMD.TITLEID = TM.TITLEID AND TM.STATUS=1
JOIN HR.Vwr_EMPLOYEE_AUXILIARY_DETAILS EAD ON EMD.EMPLOYEEID = EAD.EMP_ID
JOIN HR.EMP_PRM_HISTORY_UPDATE EPHU ON EMD.EMPLOYEEID=EPHU.EMP_NO::numeric 
JOIN PAYROLL.PAY_PROC_DATE PPD ON PPD.LOCATIONID=EMD.LOCATIONID
AND (ead.payrollprocessdate IS NULL OR (ead.payrollprocessdate<=ppd.proc_date AND PPD.PROC_DATE BETWEEN EPHU.EFF_FROM_DT AND EPHU.EFF_TO_DT)
OR (ead.payrollprocessdate>ppd.proc_date and

--LAST_DAY(PPD.PROC_dATE) BETWEEN EPHU.EFF_fROM_dT AND EPHU.EFF_TO_DT
((last_day(ppd.proc_date))::timestamp without time zone >= EPHU.EFF_fROM_dT) AND ((last_day(ppd.proc_date))::timestamp without time zone <= EPHU.EFF_TO_DT)

))

left outer join hr.vwr_employee_structure_details esd ON hr.f_desigfromposition(ephu.emp_position_id)=ESD.EMP_DTL_ID AND ESD.STATUS=1
left outer join hr.vwr_employee_structure_details esd1 ON EPHU.EMP_STAFFTYPE_CODE::numeric =ESD1.EMP_DTL_ID AND ESD1.STATUS=1
left outer join hr.vwr_employee_structure_details esd2 ON EPHU.EMP_CAT_CODE::numeric =ESD2.EMP_DTL_ID AND ESD2.STATUS=1
left outer join hr.vwr_employee_structure_details esd3 ON EPHU.EMP_GRADE_ID::numeric =ESD3.EMP_DTL_ID AND ESD3.STATUS=1
left outer join ehis.vwr_coa_struct_details csd2 on hr.f_deptfromposition(ephu.emp_position_id)=csd2.chartid AND CSD2.STATUS=1
LEFT OUTER JOIN hr.vwr_employee_bank_details EBD ON EBD.EMP_ID = EMD.EMPLOYEEID AND EBD.STATUS=1 and ebd.account_category_id=281
LEFT OUTER JOIN ehis.vwr_accounttypemaster ATM ON EBD.ACCOUNT_TYPE_ID = ATM.ACCOUNTTYPEID AND ATM.STATUS=1
left outer join hr.lovdetails ld on ebd.account_category_id=ld.lovdetailid and ld.status=1 and upper(ld.lovdetailvalue)='SALARY ACCOUNT'
LEFT OUTER JOIN ehis.vwr_bankbranchmaster BBRM ON BBRM.BANKBRANCHID = EBD.BBANK_BRANCH_ID AND BBRM.STATUS=1
LEFT OUTER JOIN ehis.vwr_bankmaster BBM ON BBM.BANKID = EBD.BANK_NAME_ID AND BBM.STATUS=1
JOIN PAYROLL.V_LOCATION_MST VM ON VM.chartid= EMD.LOCATIONID
WHERE (EMD.Status = 1)AND EAD.STOPPAYMENT=0
AND (LD.LOVDETAILVALUE='SALARY ACCOUNT' OR EBD.ACCOUNT_CATEGORY_ID IS NULL)
and emd.locationid in (select chartid from ehis.vwr_coa_struct_details a where a.parentid in ('10100','15100','90000'))
and emd.employeeid not between 101894 and 102827
and 
--emd.employeeid not like '6%'
((emd.employeeid)::text !~~ '6%'::text)
--and emd.employeeid not like '8%'
and 
--emd.employeeid not like '9%'
((emd.employeeid)::text !~~ '9%'::text)
ORDER BY UPPER(FIRSTNAME),UPPER(LASTNAME)
-- to eliminate 30 days lop employees
/*AND
emd.employeeid not in
( select PLMR.EMP_NO from pay_lev_monthly_register PLMR
      where PLMR.Lev_Availed=
          (select Last_day(PPD1.PROC_DATE)- PPD1.PROC_DATE + 1 from Pay_Proc_Date PPD1
            where ppd1.locationid= EMd.Locationid)
      and UPPEr(plmr.lev_month)=
           (select to_char(PPD1.PROC_DATE, 'MON') from Pay_Proc_Date PPD1 where
           PPD1.Locationid=EMd.Locationid)
           and status =1
     and PLMR.lev_year=
           (select to_char(PPD1.PROC_DATE, 'YYYY') from Pay_Proc_Date PPD1 where
           PPD1.Locationid=EMd.Locationid)
           and status =1
     ) */;

CREATE OR REPLACE VIEW pay_emp_mst as  SELECT (emd.employeeid)::character varying AS emp_no,
    tm.titletype AS emp_title,
    emd.firstname AS emp_first_name,
    emd.middlename AS emp_middle_name,
    emd.lastname AS emp_last_name,
    (((((((COALESCE(tm.titletype, ''::character varying))::text || ' '::text) || (COALESCE(emd.firstname, ''::character varying))::text) || ' '::text) || (COALESCE(emd.middlename, ''::character varying))::text) || ' '::text) || (COALESCE(emd.lastname, ''::character varying))::text) AS ename,
    ' '::text AS emp_gender,
    initcap((esd.name)::text) AS emp_desig_code,
    emd.dob AS emp_dob,
    ead.payrollprocessdate AS emp_doj,
    initcap((csd2.leveldetailname)::text) AS emp_dept_code,
        CASE
            WHEN (emd.status = (1)::numeric) THEN 'A'::text
            WHEN (emd.status = (0)::numeric) THEN 'N'::text
            ELSE NULL::text
        END AS emp_status,
    ead.pan_number AS emp_pan,
    ead.fathername AS emp_father_name,
    ead.dueretirementdate AS emp_date_of_retire,
    ead.dateofleaving AS emp_separation_date,
    ephu.emp_cat_code,
    ephu.emp_stafftype_code AS emp_staff_type_code,
    ead.dateofconfirmation AS emp_conf_date,
    ead.probationstartdate AS emp_prob_date,
    ead.dateofjoining AS emp_with_effect_from,
    ephu.emp_grade_id,
    ephu.emp_position_id,
    hr.f_deptfromposition((ephu.emp_position_id)::text) AS emp_dept_id,
    emd.locationid AS emp_area_code,
    NULL::text AS emp_notice_date,
    initcap((esd1.name)::text) AS stafftype,
    initcap((esd2.name)::text) AS category,
    initcap((esd3.name)::text) AS grade,
    initcap((((csd2.leveldetailname)::text || ' - '::text) || (esd.name)::text)) AS "position",
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::character varying
            ELSE ebd.account_no
        END AS account_no,
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::text
            ELSE (((bbm.banktname)::text || ' - '::text) || (bbrm.bankbranchname)::text)
        END AS bankname,
    hr.f_deptfromposition((ephu.emp_position_id)::text) AS departmentid,
    hr.f_desigfromposition((ephu.emp_position_id)::text) AS designationid,
    ead.pfnumber AS pfaccountno,
    ead.socialsecuiretynumber,
    ead.contract_from,
    ead.contract_to,
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::character varying
            ELSE atm.accountdesc
        END AS accountdesc,
    ead.pf_details,
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::numeric
            ELSE ebd.bank_name_id
        END AS bankid,
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::character varying
            ELSE atm.accountname
        END AS accountname,
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::numeric
            ELSE atm.accounttypeid
        END AS accounttypeid,
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::numeric
            ELSE ebd.bbank_branch_id
        END AS branchid,
    emd.presentemployeeid,
    ead.dateofseperation,
    vm.locationname,
    ead.dateofresignationtendered,
    emd.titleid,
    emd.employmentstatusid,
    ead.trialstartdate,
    ead.trialenddate,
    epp.locationid AS trans_location_id,
    csd11.leveldetailname AS transfer_location,
    een.accountno AS esi_no,
    ebn.uan_number
   FROM (((((((((((((((((((hr.mv_employee_main_details emd
     JOIN ehis.vwr_titlemaster tm ON (((emd.titleid = tm.titleid) AND (tm.status = (1)::numeric))))
     JOIN hr.Vwr_EMPLOYEE_AUXILIARY_DETAILS ead ON ((emd.employeeid = ead.emp_id)))
     JOIN hr.emp_prm_history_update ephu ON (((emd.employeeid)::text = (ephu.emp_no)::text)))
     JOIN payroll.pay_proc_date ppd ON ((((ppd.locationid)::text = (emd.locationid)::text) AND ((ead.payrollprocessdate IS NULL) OR ((ead.payrollprocessdate <= ppd.proc_date) AND ((current_date >= ephu.eff_from_dt) AND (current_date <= ephu.eff_to_dt))) OR ((ead.payrollprocessdate > ppd.proc_date) AND ((last_day(ppd.proc_date))::timestamp without time zone >= ephu.eff_from_dt) AND ((last_day(ppd.proc_date))::timestamp without time zone <= ephu.eff_to_dt))))))
     JOIN hr.vwr_emp_pay_processdetails epp ON (((epp.empno = emd.employeeid) AND ((last_day(ppd.proc_date))::timestamp without time zone >= epp.startdate) AND ((last_day(ppd.proc_date))::timestamp without time zone <= epp.enddate))))
     LEFT JOIN hr.vwr_employee_structure_details esd ON (((hr.f_desigfromposition((ephu.emp_position_id)::text) = esd.emp_dtl_id) AND (esd.status = (1)::numeric))))
     LEFT JOIN hr.vwr_employee_structure_details esd1 ON ((((ephu.emp_stafftype_code)::text = (esd1.emp_dtl_id)::text) AND (esd1.status = (1)::numeric))))
     LEFT JOIN hr.vwr_employee_structure_details esd2 ON ((((ephu.emp_cat_code)::text = (esd2.emp_dtl_id)::text) AND (esd2.status = (1)::numeric))))
     LEFT JOIN hr.vwr_employee_structure_details esd3 ON ((((ephu.emp_grade_id)::text = (esd3.emp_dtl_id)::text) AND (esd3.status = (1)::numeric))))
     LEFT JOIN ehis.vwr_coa_struct_details csd2 ON ((((hr.f_deptfromposition((ephu.emp_position_id)::text))::text = (csd2.chartid)::text) AND (csd2.status = (1)::numeric))))
     LEFT JOIN hr.vwr_employee_bank_details ebd ON (((ebd.emp_id = emd.employeeid) AND (ebd.status = (1)::numeric) AND (ebd.account_category_id = (281)::numeric))))
     LEFT JOIN ehis.vwr_accounttypemaster atm ON (((ebd.account_type_id = atm.accounttypeid) AND (atm.status = (1)::numeric))))
     LEFT JOIN hr.lovdetails ld ON (((ebd.account_category_id = ld.lovdetailid) AND (ld.status = (1)::numeric) AND (upper((ld.lovdetailvalue)::text) = 'SALARY ACCOUNT'::text))))
     LEFT JOIN ehis.vwr_bankbranchmaster bbrm ON (((bbrm.bankbranchid = ebd.bbank_branch_id) AND (bbrm.status = (1)::numeric))))
     LEFT JOIN ehis.vwr_bankmaster bbm ON (((bbm.bankid = ebd.bank_name_id) AND (bbm.status = (1)::numeric))))
     LEFT JOIN hr.vwr_emp_esi_no een ON (((een.employeeid = emd.employeeid) AND (een.status = (1)::numeric) AND ((een.accounttype)::text = '46'::text))))
     LEFT JOIN hr.vwr_emp_benefit_details ebn ON ((ebn.emp_id = emd.employeeid)))
     JOIN payroll.v_location_mst vm ON (((vm.chartid)::text = (emd.locationid)::text)))
     JOIN ehis.vwr_coa_struct_details csd11 ON (((csd11.chartid)::text = (epp.locationid)::text)))
  WHERE ((emd.status = (1)::numeric) AND (ead.stoppayment = (0)::numeric) AND (((ld.lovdetailvalue)::text = 'SALARY ACCOUNT'::text) OR (ebd.account_category_id IS NULL)) AND ((emd.locationid)::text IN ( SELECT a.chartid
           FROM ehis.vwr_coa_struct_details a
          WHERE ((a.parentid)::text = ANY (ARRAY[('10200'::character varying)::text, ('10100'::character varying)::text, ('15100'::character varying)::text, ('90000'::character varying)::text, ('10000'::character varying)::text, ('10330'::character varying)::text, ('10340'::character varying)::text, ('10310'::character varying)::text, ('10300'::character varying)::text, ('10320'::character varying)::text])))) AND ((emd.employeeid)::text !~~ '6%'::text) AND ((emd.employeeid)::text !~~ '9%'::text))
  ORDER BY (upper((emd.firstname)::text)), (upper((emd.lastname)::text));

CREATE OR REPLACE VIEW MM.VW_TOTALGL_SRV_POSTING
(SRVDATE,TOTALGLVALUETOBEPOSTED)
AS
select SRVDate, sum(Disc_Tax_Sum+addncharges)As TotalGLValueToBePosted
from
(
SELECT r.srvcode,r.addncharges,(r.createddate)::date as SRVDate,sum(rd.discvalue+rd.taxvalue)as Disc_Tax_Sum
                  
                FROM MM.Receipts r
                     Inner join MM.receiptdetails rd on r.receiptid = rd.receiptid
                     --for AccountNumbers
                       --For Getting storecode
                      inner join MM.receipts rGRN on r.grncode = rGRN.grncode and rGrn.transactiontypeid = 1 and rGRN.Statusid<>4
                     inner join mm.vwr_store s on s.storecode = rGRN.storecode
                     inner join MM.itemlocation il on il.itemcode = rd.itemcode and il.locationid = s.locationid
                     inner join mm.vwr_orafinaccounts Ac on Ac.accountkeyvalue =  il.accountkey
                     --for journal entries
                     inner join MM.Journal jr on jr.TransactionType= r.transactiontypeid
                     inner join MM.PO po on  r.POCode= po.POCode --and po.storecode = rGrn.storecode --This Condition is not valid
                                          AND PO.STATUSID <>4--to take latest amended po
                     inner join MM.POItems poitem on po.poid = poitem.poid and poitem.itemcode = rd.itemcode
                     inner join MM.journalbatchcoa jrcoa on jrcoa.chartid=MM.F_GetLocationCOACode(rGrn.storecode)
                     --for getting CAPITAL Item VAT Tax separately
                     inner join MM.vw_itemcompany iComp on iComp.Itemcode = rd.itemcode
            
                WHERE
                    /*R.IsGLPosted Is null and*/
                    R.transactiontypeid = (
                                           select lovDetails.Lovdetailvalue::numeric from
                                           MM.Lovmaster inner join MM.lovDetails on Lovmaster.LovID = lovDetails.LovID
                                           where Lovmaster.LovDescription='ReceiptsTransactionType'
                                           and lovDetails.Lovdetaildescription='SRV'
                                           )
                    and r.createddate::date >='1-jul-2008'
                    AND R.statusid>0 AND R.STATUSID<>99
                    and Ac.Interfacecode = 'GL'
                    and Ac.Recordtype = 'SRV'
                    and Ac.Entrydr_Cr = 'D'
group by r.srvcode,r.addncharges,r.createddate::date

UNION

SELECT r.srvcode,r.addncharges,r.createddate::date as SRVDate,sum(rd.discvalue+rd.taxvalue)as Disc_Tax_Sum

                FROM MM.Receipts r
                     Inner join MM.receiptdetails rd on r.receiptid = rd.receiptid
                     --for AccountNumbers
                       --For Getting storecode

                     inner join mm.vwr_store s on s.storecode = r.storecode
                     inner join MM.itemlocation il on il.itemcode = rd.itemcode and il.locationid = s.locationid
                     inner join mm.vwr_orafinaccounts Ac on Ac.accountkeyvalue =  il.accountkey
                     --for journal entries
                     inner join MM.Journal jr on jr.TransactionType= r.transactiontypeid
                     inner join MM.PO po on  r.POCode= po.POCode --and po.storecode = rGrn.storecode --This Condition is not valid
                                          AND PO.STATUSID <>4--to take latest amended po
                     inner join MM.POItems poitem on po.poid = poitem.poid and poitem.itemcode = rd.itemcode
                     inner join MM.journalbatchcoa jrcoa on jrcoa.chartid=mm.F_GetLocationCOACode(r.storecode)
                     --for getting CAPITAL Item VAT Tax separately
                     inner join MM.vw_itemcompany iComp on iComp.Itemcode = rd.itemcode

                WHERE
                    /*R.IsGLPosted Is null and*/
                    R.transactiontypeid = 5
                    AND R.SRVCODE LIKE 'CSRV%'
                    and r.createddate::date >='1-jul-2008'
                    AND R.statusid>0 AND R.STATUSID<>99
                    and Ac.Interfacecode = 'GL'
                    and Ac.Recordtype = 'SRV'
                    and Ac.Entrydr_Cr = 'D'
group by r.srvcode,r.addncharges,r.createddate::date

)rcpt group by SRVDate
order by SRVDate;



CREATE OR REPLACE VIEW PAYROLL.PAY_EMP_MST
(EMP_NO,EMP_TITLE,EMP_FIRST_NAME,EMP_MIDDLE_NAME,EMP_LAST_NAME,ENAME,EMP_GENDER,EMP_DESIG_CODE,EMP_DOB,EMP_DOJ,EMP_DEPT_CODE,EMP_STATUS,EMP_PAN,EMP_FATHER_NAME,EMP_DATE_OF_RETIRE,EMP_SEPARATION_DATE,EMP_CAT_CODE,EMP_STAFF_TYPE_CODE,EMP_CONF_DATE,EMP_PROB_DATE,EMP_WITH_EFFECT_FROM,EMP_GRADE_ID,EMP_POSITION_ID,EMP_DEPT_ID,EMP_AREA_CODE,EMP_NOTICE_DATE,STAFFTYPE,CATEGORY,GRADE,"POSITION",ACCOUNT_NO,BANKNAME,DEPARTMENTID,DESIGNATIONID,PFACCOUNTNO,SOCIALSECUIRETYNUMBER,CONTRACT_FROM,CONTRACT_TO,ACCOUNTDESC,PF_DETAILS,BANKID,ACCOUNTNAME,ACCOUNTTYPEID,BRANCHID,PRESENTEMPLOYEEID,DATEOFSEPERATION,LOCATIONNAME,DATEOFRESIGNATIONTENDERED,TITLEID,EMPLOYMENTSTATUSID,TRIALSTARTDATE,TRIALENDDATE,TRANS_LOCATION_ID,TRANSFER_LOCATION,ESI_NO,UAN_NUMBER)
AS
SELECT (emd.employeeid)::text EMP_NO,TM.TITLETYPE EMP_TITLE,FIRSTNAME EMP_FIRST_NAME, MIDDLENAME EMP_MIDDLE_NAME ,
  LASTNAME EMP_LAST_NAME,TM.TITLETYPE||' '||EMD.FIRSTNAME||' '||EMD.MIDDLENAME||' '||EMD.LASTNAME ENAME,
  ' ' EMP_GENDER,INITCAP(ESD.NAME) EMP_DESIG_CODE,EMD.DOB EMP_DOB,EAD.PAYROLLPROCESSDATE EMP_DOJ,
  INITCAP(CSD2.LEVELDETAILNAME) EMP_DEPT_CODE,
--  DECODE(EMD.STATUS,1,'A',0,'N') EMP_STATUS,
	case when (EMD.STATUS = 1) then 'A'
		when (EMD.STATUS = 0) then 'N'
		ELSE NULL::text
	end as EMP_STATUS,
  EAD.PAN_NUMBER EMP_PAN,
  EAD.FATHERNAME EMP_FATHER_NAME,EAD.Dueretirementdate EMP_DATE_OF_RETIRE,EAD.DATEOFLEAVING EMP_SEPARATION_dATE,
  EPHU.EMP_CAT_CODE EMP_CAT_CODE,EPHU.EMP_STAFFTYPE_CODE EMP_STAFF_TYPE_CODE,
  EAD.DATEOFCONFIRMATION EMP_CONF_DATE,EAD.PROBATIONSTARTDATE EMP_PROB_DATE,
  EAD.DATEOFJOINING EMP_WITH_EFFECT_FROM,EPHU.EMP_GRADE_ID EMP_GRADE_ID,
  EPHU.EMP_POSITION_ID EMP_POSITION_ID,hr.f_deptfromposition(ephu.emp_position_id) EMP_DEPT_ID,
  EMD.LOCATIONID EMP_AREA_CODE,NULL EMP_NOTICE_DATE,INITCAP(ESD1.NAME) STAFFTYPE,INITCAP(ESD2.NAME) CATEGORY,INITCAP(ESD3.NAME) GRADE,
  INITCAP(CSD2.LEVELDETAILNAME||' - '||ESD.NAME) POSITION,decode(ld.lovdetailid,null,null,EBD.ACCOUNT_NO) ACCOUNT_NO,
--  decode(ld.lovdetailid,null,null,(BBM.BANKTNAME||' - '||BBRM.BANKBRANCHNAME)) BANKNAME,
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL
            ELSE (BBM.BANKTNAME||' - '||BBRM.BANKBRANCHNAME)
        END AS BANKNAME,  
  hr.f_deptfromposition(ephu.emp_position_id) DEPARTMENTID, hr.F_desigfromposition (ephu.emp_position_id) DESIGNATIONID ,
  EAD.PFNUMBER PFAccountNo,EAD.SOCIALSECUIRETYNUMBER,EAD.CONTRACT_FROM,EAD.CONTRACT_TO,
--  decode(ld.lovdetailid,null,null,ATM.ACCOUNTDESC) ACCOUNTDESC
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL
            ELSE ATM.ACCOUNTDESC
        END AS ACCOUNTDESC,
  EAD.PF_DETAILS,
--  decode(ld.lovdetailid,null,null,ebd.bank_name_id) bankid,
--  decode(ld.lovdetailid,null,null,ATM.Accountname) Accountname,
--  decode(ld.lovdetailid,null,null,ATM.ACCOUNTTYPEID) ACCOUNTTYPEID,
--  decode(ld.lovdetailid,null,null,EBD.BBANK_BRANCH_ID) BRANCHID,
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::numeric
            ELSE ebd.bank_name_id
        END AS bankid,
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::character varying
            ELSE atm.accountname
        END AS accountname,
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::numeric
            ELSE atm.accounttypeid
        END AS accounttypeid,
        CASE
            WHEN (ld.lovdetailid IS NULL) THEN NULL::numeric
            ELSE ebd.bbank_branch_id
        END AS branchid,

  EMD.Presentemployeeid , EAd.Dateofseperation, VM.LocationName,
  ead.dateofresignationtendered,emd.titleid,emd.employmentstatusid
  ,trialstartdate,trialenddate,EPP.LOCATIONID TRANS_LOCATION_ID,CSD11.LEVELDETAILNAME TRANSFER_LOCATION,
--- ADDED BY SATHISH V (15/3/2018) START ---
  EEN.ACCOUNTNO AS ESI_NO,
--- ADDED BY SATHISH V (15/3/2018) END ---
--- ADDED BY SATHISH V (01/06/2018) START ---
  EBN.UAN_NUMBER
--- ADDED BY SATHISH V (01/06/2018) END ---
FROM HR.MV_EMPLOYEE_MAIN_DETAILS EMD
JOIN ehis.vwr_titlemaster TM ON EMD.TITLEID = TM.TITLEID AND TM.STATUS=1
JOIN HR.Vwr_EMPLOYEE_AUXILIARY_DETAILS EAD ON EMD.EMPLOYEEID = EAD.EMP_ID
JOIN HR.EMP_PRM_HISTORY_UPDATE EPHU ON EMD.EMPLOYEEID=EPHU.EMP_NO::numeric
JOIN PAYROLL.PAY_PROC_DATE PPD ON PPD.LOCATIONID=EMD.LOCATIONID
AND (ead.payrollprocessdate IS NULL OR 
(
ead.payrollprocessdate<=ppd.proc_date AND 
--Current_date /*PPD.PROC_DATE*/ BETWEEN EPHU.EFF_FROM_DT AND EPHU.EFF_TO_DT
((current_date >= ephu.eff_from_dt) AND (current_date <= ephu.eff_to_dt))
)
OR 
(
ead.payrollprocessdate>ppd.proc_date AND 
--LAST_DAY(PPD.PROC_dATE) BETWEEN EPHU.EFF_fROM_dT AND EPHU.EFF_TO_DT
((LAST_DAY(PPD.PROC_dATE)::timestamp without time zone  >= ephu.eff_from_dt) AND (LAST_DAY(PPD.PROC_dATE)::timestamp without time zone <= ephu.eff_to_dt))
))
JOIN hr.vwr_emp_pay_processdetails EPP ON EPP.EMPNO=EMD.EMPLOYEEID
AND 
--LAST_DAY(PPD.PROC_DATE) BETWEEN EPP.STARTDATE AND EPP.ENDDATE
((LAST_DAY(PPD.PROC_dATE)::timestamp without time zone  >= EPP.STARTDATE) AND (LAST_DAY(PPD.PROC_dATE)::timestamp without time zone <= EPP.STARTDATE))
left outer join hr.vwr_employee_structure_details esd ON hr.f_desigfromposition(ephu.emp_position_id)=ESD.EMP_DTL_ID AND ESD.STATUS=1
left outer join hr.vwr_employee_structure_details esd1 ON EPHU.EMP_STAFFTYPE_CODE::numeric =ESD1.EMP_DTL_ID AND ESD1.STATUS=1
left outer join hr.vwr_employee_structure_details esd2 ON EPHU.EMP_CAT_CODE::numeric =ESD2.EMP_DTL_ID AND ESD2.STATUS=1
left outer join hr.vwr_employee_structure_details esd3 ON EPHU.EMP_GRADE_ID::numeric=ESD3.EMP_DTL_ID AND ESD3.STATUS=1
left outer join ehis.vwr_coa_struct_details csd2 on hr.f_deptfromposition(ephu.emp_position_id)=csd2.chartid AND CSD2.STATUS=1
LEFT OUTER JOIN hr.vwr_employee_bank_details EBD ON EBD.EMP_ID = EMD.EMPLOYEEID AND EBD.STATUS=1 and ebd.account_category_id=281
LEFT OUTER JOIN ehis.vwr_accounttypemaster ATM ON EBD.ACCOUNT_TYPE_ID = ATM.ACCOUNTTYPEID AND ATM.STATUS=1
left outer join hr.lovdetails ld on ebd.account_category_id=ld.lovdetailid and ld.status=1 and upper(ld.lovdetailvalue)='SALARY ACCOUNT'
LEFT OUTER JOIN ehis.vwr_bankbranchmaster BBRM ON BBRM.BANKBRANCHID = EBD.BBANK_BRANCH_ID AND BBRM.STATUS=1
LEFT OUTER JOIN ehis.vwr_bankmaster BBM ON BBM.BANKID = EBD.BANK_NAME_ID AND BBM.STATUS=1
--- ADDED BY SATHISH V (15/3/2018) START GETTING ESI ACCOUNT NO---
LEFT OUTER JOIN hr.vwr_emp_esi_no EEN ON EEN.EMPLOYEEID=EMD.EMPLOYEEID AND EEN.STATUS=1 AND EEN.ACCOUNTTYPE='46'
--- ADDED BY SATHISH V (15/3/2018) END ---
--- ADDED BY SATHISH V (01/06/2018) START UAN & PAN NUMBER ---
LEFT OUTER JOIN hr.vwr_emp_benefit_details EBN ON EBN.EMP_ID=EMD.EMPLOYEEID
--- ADDED BY SATHISH V (01/06/2018) END ---
JOIN PAYROLL.V_LOCATION_MST VM ON VM.chartid= EMD.LOCATIONID
JOIN ehis.vwr_coa_struct_details CSD11 ON CSD11.CHARTID=EPP.LOCATIONID
WHERE (EMD.Status = 1)AND EAD.STOPPAYMENT=0
AND (LD.LOVDETAILVALUE='SALARY ACCOUNT' OR EBD.ACCOUNT_CATEGORY_ID IS NULL)
and emd.locationid in (select chartid from ehis.vwr_coa_struct_details a where a.parentid in ('10100','15100','90000','10000','10330','10340','10310','10300','10320'))
--and emd.employeeid not between 101894 and 102827
and ((emd.employeeid)::text !~~ '6%'::text) AND ((emd.employeeid)::text !~~ '9%'::text)
ORDER BY UPPER(FIRSTNAME),UPPER(LASTNAME)
-- to eliminate 30 days lop employees
/*AND
emd.employeeid not in
( select PLMR.EMP_NO from pay_lev_monthly_register PLMR
      where PLMR.Lev_Availed=
          (select Last_day(PPD1.PROC_DATE)- PPD1.PROC_DATE + 1 from Pay_Proc_Date PPD1
            where ppd1.locationid= EMd.Locationid)
      and UPPEr(plmr.lev_month)=
           (select to_char(PPD1.PROC_DATE, 'MON') from Pay_Proc_Date PPD1 where
           PPD1.Locationid=EMd.Locationid)
           and status =1
     and PLMR.lev_year=
           (select to_char(PPD1.PROC_DATE, 'YYYY') from Pay_Proc_Date PPD1 where
           PPD1.Locationid=EMd.Locationid)
           and status =1
     ) */
;

CREATE OR REPLACE VIEW ehis.eh_ay_master_mv
AS SELECT allergenmaster.allergenid,
    allergenmaster.allergenname,
    allergenmaster.allergytypeid,
    allergenmaster.ingredienttypeid,
    allergenmaster.quantity,
    allergenmaster.unitid,
    allergenmaster.status,
    allergenmaster.updatedby,
    allergenmaster.updateddate,
    allergenmaster.macronutrients,
    allergenmaster.micronutrients,
    allergenmaster.locationid,
    allergenmaster.itemcode,
    allergenmaster.inhouse,
    allergenmaster.outsourced,
    allergenmaster.genericname,
    allergenmaster.visibility
   FROM ehis.vwr_allergenmaster allergenmaster;
   
  
  CREATE OR REPLACE VIEW ehis.eh_ay_setmaster_mv
AS SELECT eh_ay_setmaster.groupid,
    eh_ay_setmaster.groupname,
    eh_ay_setmaster.status,
    eh_ay_setmaster.updatedby,
    eh_ay_setmaster.updatedate,
    eh_ay_setmaster.createdby,
    eh_ay_setmaster.createddate
   FROM ehis.vwr_eh_ay_setmaster eh_ay_setmaster;

create or replace view HR.MV_PRIVILEGEMAPPING
as
select
	PRIVILEGEMAPPING.PRIVILEGEREQUESTID PRIVILEGEREQUESTID,
	PRIVILEGEMAPPING.REQUESTORID REQUESTORID,
	PRIVILEGEMAPPING.POSITIONAPPLIEDFOR POSITIONAPPLIEDFOR,
	PRIVILEGEMAPPING.EXPERIENCEAFTERPG EXPERIENCEAFTERPG,
	PRIVILEGEMAPPING.APPROVALSTATUS APPROVALSTATUS,
	PRIVILEGEMAPPING.APPROVERID APPROVERID,
	PRIVILEGEMAPPING.STATUS STATUS,
	PRIVILEGEMAPPING.UPDATEDBY UPDATEDBY,
	PRIVILEGEMAPPING.UPDATEDDATE UPDATEDDATE,
	PRIVILEGEMAPPING.REQUESTORDATE REQUESTORDATE,
	PRIVILEGEMAPPING.APPROVERDATE APPROVERDATE,
	PRIVILEGEMAPPING.REQUESTORREMARKS REQUESTORREMARKS,
	PRIVILEGEMAPPING.APPROVERREMARKS APPROVERREMARKS,
	PRIVILEGEMAPPING.APPROVEDBY APPROVEDBY
from
	HR.PRIVILEGEMAPPING PRIVILEGEMAPPING;
	
create or replace view PHARMACY.ITEMCOMPANY_DUMY
as
select
	ITEMCOMPANY.ISCONSIGNMENTITEM ISCONSIGNMENTITEM,
	ITEMCOMPANY.VARIANTALLOWED VARIANTALLOWED,
	ITEMCOMPANY.ISHAZARDOUS ISHAZARDOUS,
	ITEMCOMPANY.ISINCLUSEDINCOSTING ISINCLUSEDINCOSTING,
	ITEMCOMPANY.VEDANALYSIS VEDANALYSIS,
	ITEMCOMPANY.ITEMCLASSIFICATION ITEMCLASSIFICATION,
	ITEMCOMPANY.ITEMCATEGORY ITEMCATEGORY,
	ITEMCOMPANY.ITEMSUBCATEGORY1 ITEMSUBCATEGORY1,
	ITEMCOMPANY.ITEMSUBCATEGORY2 ITEMSUBCATEGORY2,
	ITEMCOMPANY.ITEMSUBCATEGORY3 ITEMSUBCATEGORY3,
	ITEMCOMPANY.ITEMSTORAGETYPE ITEMSTORAGETYPE,
	ITEMCOMPANY.UNITWEIGHT UNITWEIGHT,
	ITEMCOMPANY.WEIGHTUOM WEIGHTUOM,
	ITEMCOMPANY.UNITVOLUME UNITVOLUME,
	ITEMCOMPANY.VOLUMEUOM VOLUMEUOM,
	ITEMCOMPANY.LOOKUPID LOOKUPID,
	ITEMCOMPANY.SEQNUMBER SEQNUMBER,
	ITEMCOMPANY.ITEMTYPE ITEMTYPE,
	ITEMCOMPANY.ITEMCODE ITEMCODE,
	ITEMCOMPANY.ITEMSHORTDESC ITEMSHORTDESC,
	ITEMCOMPANY.ITEMLONGDESC ITEMLONGDESC,
	ITEMCOMPANY.FLEXIFIELD1 FLEXIFIELD1,
	ITEMCOMPANY.FLEXIFIELD2 FLEXIFIELD2,
	ITEMCOMPANY.FLEXIFIELD3 FLEXIFIELD3,
	ITEMCOMPANY.FLEXIFIELD4 FLEXIFIELD4,
	ITEMCOMPANY.FLEXIFIELD5 FLEXIFIELD5,
	ITEMCOMPANY.BARCODE BARCODE,
	ITEMCOMPANY.BIS BIS,
	ITEMCOMPANY.LEGACYITEMCODE LEGACYITEMCODE,
	ITEMCOMPANY.REUSABLEITEM REUSABLEITEM,
	ITEMCOMPANY.CREATIONDATE CREATIONDATE,
	ITEMCOMPANY.ITEMDESCNEW ITEMDESCNEW,
	ITEMCOMPANY.ITEMBRIEFDESC ITEMBRIEFDESC,
	ITEMCOMPANY.GENERICNAME GENERICNAME,
	ITEMCOMPANY.SCHEDULETYPEID SCHEDULETYPEID,
	ITEMCOMPANY.MANUFACTURERID MANUFACTURERID,
	ITEMCOMPANY.DRUGTYPECATEGORYID DRUGTYPECATEGORYID,
	ITEMCOMPANY.DRUGTYPESTATUS DRUGTYPESTATUS,
	ITEMCOMPANY.DRUGSTRENGTH DRUGSTRENGTH
from
	pharmacy.vwr_itemcompany ITEMCOMPANY;

create or replace view HR.V_EMPLOYEE_MAIN_DETAILS
as
select
	EMPLOYEE_MAIN_DETAILS.EMPLOYEEID EMPLOYEEID,
	EMPLOYEE_MAIN_DETAILS.EMPLOYEECODE EMPLOYEECODE,
	EMPLOYEE_MAIN_DETAILS.TITLEID TITLEID,
	EMPLOYEE_MAIN_DETAILS.FIRSTNAME FIRSTNAME,
	EMPLOYEE_MAIN_DETAILS.MIDDLENAME MIDDLENAME,
	EMPLOYEE_MAIN_DETAILS.LASTNAME LASTNAME,
	EMPLOYEE_MAIN_DETAILS.GENDERID GENDERID,
	EMPLOYEE_MAIN_DETAILS.DOB DOB,
	EMPLOYEE_MAIN_DETAILS.MARITALSTATUSID MARITALSTATUSID,
	EMPLOYEE_MAIN_DETAILS.BIRTHCOUNTRYID BIRTHCOUNTRYID,
	EMPLOYEE_MAIN_DETAILS.NATIONALITYID NATIONALITYID,
	EMPLOYEE_MAIN_DETAILS.PHYSICALLYHANDICAPPED PHYSICALLYHANDICAPPED,
	EMPLOYEE_MAIN_DETAILS.SUPERVISORID SUPERVISORID,
	EMPLOYEE_MAIN_DETAILS.COMPANYID COMPANYID,
	EMPLOYEE_MAIN_DETAILS.LOCATIONID LOCATIONID,
	EMPLOYEE_MAIN_DETAILS.DEPARTMENTID DEPARTMENTID,
	EMPLOYEE_MAIN_DETAILS.COSTCENTERID COSTCENTERID,
	EMPLOYEE_MAIN_DETAILS.MAINCOSTCENTERID MAINCOSTCENTERID,
	EMPLOYEE_MAIN_DETAILS.PAYROLLACCOUNTINGAREAID PAYROLLACCOUNTINGAREAID,
	EMPLOYEE_MAIN_DETAILS.EMPLOYEELEVELID EMPLOYEELEVELID,
	EMPLOYEE_MAIN_DETAILS.EMPLOYEECATEGORYID EMPLOYEECATEGORYID,
	EMPLOYEE_MAIN_DETAILS.EMPLOYEETYPEID EMPLOYEETYPEID,
	EMPLOYEE_MAIN_DETAILS.DESIGNATIONID DESIGNATIONID,
	EMPLOYEE_MAIN_DETAILS.GRADEID GRADEID,
	EMPLOYEE_MAIN_DETAILS.LAST_SALARY LAST_SALARY,
	EMPLOYEE_MAIN_DETAILS.ADDRESS_TYPE ADDRESS_TYPE,
	EMPLOYEE_MAIN_DETAILS.EMPLOYMENTSTATUSID EMPLOYMENTSTATUSID,
	EMPLOYEE_MAIN_DETAILS.STATUS STATUS,
	EMPLOYEE_MAIN_DETAILS.CREATEDBY CREATEDBY,
	EMPLOYEE_MAIN_DETAILS.CREATEDDATE CREATEDDATE,
	EMPLOYEE_MAIN_DETAILS.UPDATEDBY UPDATEDBY,
	EMPLOYEE_MAIN_DETAILS.UPDATEDDATE UPDATEDDATE,
	EMPLOYEE_MAIN_DETAILS.FLEXIFIELD1 FLEXIFIELD1,
	EMPLOYEE_MAIN_DETAILS.FLEXIFIELD2 FLEXIFIELD2,
	EMPLOYEE_MAIN_DETAILS.PRESENTEMPLOYEEID PRESENTEMPLOYEEID,
	EMPLOYEE_MAIN_DETAILS.LOGINID LOGINID,
	EMPLOYEE_MAIN_DETAILS.SPECIALITYID SPECIALITYID,
	EMPLOYEE_MAIN_DETAILS.EMAILID EMAILID,
	EMPLOYEE_MAIN_DETAILS.CALENDARPRIVILEGES CALENDARPRIVILEGES,
	EMPLOYEE_MAIN_DETAILS.SCHEDULABLE SCHEDULABLE,
	EMPLOYEE_MAIN_DETAILS.SPECIALIZEDSERVICES SPECIALIZEDSERVICES,
	EMPLOYEE_MAIN_DETAILS.PROCESSED_FLAG PROCESSED_FLAG,
	EMPLOYEE_MAIN_DETAILS.TRANSFERSTATUS TRANSFERSTATUS
from
	hr.Mv_employee_main_details EMPLOYEE_MAIN_DETAILS;

create or replace view CRM.CAMPAIGNS_01
as 
SELECT CAMPAIGNID           CAMPAIGNID,
       CAMPAIGNNAME         CAMPAIGNNAME,
       CAMPAIGNCATEGORYID   CAMPAIGNCATEGORYID,
       STARTDATE            STARTDATE,
       ENDDATE              ENDDATE,
       DURATION             DURATION,
       PRIORITYID           PRIORITYID,
       PROMOTIONCHANNELS    PROMOTIONCHANNELS,
       CREATEDBY            CREATEDBY,
       CREATEDDATE          CREATEDDATE,
       VENUE                VENUE,
       DESCRIPTION          DESCRIPTION,
       ASSIGNEDOWNER        ASSIGNEDOWNER,
       UPDATEDBY            UPDATEDBY,
       UPDATEDDATE          UPDATEDDATE,
       PRIMARYASSIGNEDOWNER PRIMARYASSIGNEDOWNER,
       CAMPAIGNFREQUENCY    CAMPAIGNFREQUENCY,
       CAMPAIGNCODE         CAMPAIGNCODE,
       LOCATIONID           LOCATIONID,
       CAMPAIGNTYPEID       CAMPAIGNTYPEID,
       CAMPAIGNSTATUSID     CAMPAIGNSTATUSID
  FROM crm.vwr_campaigns;

create or replace view HR.EMPLOYEE_AUXILIARY_DETAILS1
as
select
	EMPLOYEE_AUXILIARY_DETAILS.EMP_AUX_ID EMP_AUX_ID,
	EMPLOYEE_AUXILIARY_DETAILS.MADIAN_NAME_OTHER_NAME MADIAN_NAME_OTHER_NAME,
	EMPLOYEE_AUXILIARY_DETAILS.MARRIAGE_DATE MARRIAGE_DATE,
	EMPLOYEE_AUXILIARY_DETAILS.SPOUSE_NAME SPOUSE_NAME,
	EMPLOYEE_AUXILIARY_DETAILS.SPOUSE_DOB SPOUSE_DOB,
	EMPLOYEE_AUXILIARY_DETAILS.CITIZENSHIP_ID CITIZENSHIP_ID,
	EMPLOYEE_AUXILIARY_DETAILS.RELIGION_ID RELIGION_ID,
	EMPLOYEE_AUXILIARY_DETAILS.CASTE_ID CASTE_ID,
	EMPLOYEE_AUXILIARY_DETAILS.BLOOD_GROUP_ID BLOOD_GROUP_ID,
	EMPLOYEE_AUXILIARY_DETAILS.SOCIALSECUIRETYNUMBER SOCIALSECUIRETYNUMBER,
	EMPLOYEE_AUXILIARY_DETAILS.PH_DESCRIPTION PH_DESCRIPTION,
	EMPLOYEE_AUXILIARY_DETAILS.IDENTIFICATION_MARK1 IDENTIFICATION_MARK1,
	EMPLOYEE_AUXILIARY_DETAILS.IDENTIFICATION_MARK2 IDENTIFICATION_MARK2,
	EMPLOYEE_AUXILIARY_DETAILS.EXPAT EXPAT,
	EMPLOYEE_AUXILIARY_DETAILS.COTRACTEMPLOYEE COTRACTEMPLOYEE,
	EMPLOYEE_AUXILIARY_DETAILS.BARGAINABLE_STATUS BARGAINABLE_STATUS,
	EMPLOYEE_AUXILIARY_DETAILS.UPLOAD_FILE_NAME UPLOAD_FILE_NAME,
	EMPLOYEE_AUXILIARY_DETAILS.UPLOAD_FILE_TYPE UPLOAD_FILE_TYPE,
	EMPLOYEE_AUXILIARY_DETAILS.UPLOAD_FILE_PATH UPLOAD_FILE_PATH,
	EMPLOYEE_AUXILIARY_DETAILS.EMP_ID EMP_ID,
	EMPLOYEE_AUXILIARY_DETAILS.CONTRACT_FROM CONTRACT_FROM,
	EMPLOYEE_AUXILIARY_DETAILS.CONTRACT_TO CONTRACT_TO,
	EMPLOYEE_AUXILIARY_DETAILS.UNDER_BOND UNDER_BOND,
	EMPLOYEE_AUXILIARY_DETAILS.PAN_NUMBER PAN_NUMBER,
	EMPLOYEE_AUXILIARY_DETAILS.DRIVING_DETAILS DRIVING_DETAILS,
	EMPLOYEE_AUXILIARY_DETAILS.AWARDS_REWARDS AWARDS_REWARDS,
	EMPLOYEE_AUXILIARY_DETAILS.UNION_MEMBER UNION_MEMBER,
	EMPLOYEE_AUXILIARY_DETAILS.VACCINATION_DETAILS VACCINATION_DETAILS,
	EMPLOYEE_AUXILIARY_DETAILS.INTENSHIP_INSTITUTE_DETAILS INTENSHIP_INSTITUTE_DETAILS,
	EMPLOYEE_AUXILIARY_DETAILS.FELLOWSHIP_INSTITUTE_DETAILS FELLOWSHIP_INSTITUTE_DETAILS,
	EMPLOYEE_AUXILIARY_DETAILS.REGISTRATION_DETAILS REGISTRATION_DETAILS,
	EMPLOYEE_AUXILIARY_DETAILS.MEDICAL_LICENSE MEDICAL_LICENSE,
	EMPLOYEE_AUXILIARY_DETAILS.PROF_MEMBERSHIP_DETAILS PROF_MEMBERSHIP_DETAILS,
	EMPLOYEE_AUXILIARY_DETAILS.INSURANCE_CARRIER_DETAILS INSURANCE_CARRIER_DETAILS,
	EMPLOYEE_AUXILIARY_DETAILS.PENDING_PROFL_LIABLITY_CLAIMS PENDING_PROFL_LIABLITY_CLAIMS,
	EMPLOYEE_AUXILIARY_DETAILS.PUBLIC_HEALTH_INSTITUTION PUBLIC_HEALTH_INSTITUTION,
	EMPLOYEE_AUXILIARY_DETAILS.OTHER_DETAILS OTHER_DETAILS,
	EMPLOYEE_AUXILIARY_DETAILS.BOND_DETAILS BOND_DETAILS,
	EMPLOYEE_AUXILIARY_DETAILS.PF_DETAILS PF_DETAILS,
	EMPLOYEE_AUXILIARY_DETAILS.UPDATEDBY UPDATEDBY,
	EMPLOYEE_AUXILIARY_DETAILS.UPDATEDDATE UPDATEDDATE,
	EMPLOYEE_AUXILIARY_DETAILS.DATEOFJOINING DATEOFJOINING,
	EMPLOYEE_AUXILIARY_DETAILS.DATEOFLEAVING DATEOFLEAVING,
	EMPLOYEE_AUXILIARY_DETAILS.DATEOFAPOINTMENT DATEOFAPOINTMENT,
	EMPLOYEE_AUXILIARY_DETAILS.PROBATIONSTARTDATE PROBATIONSTARTDATE,
	EMPLOYEE_AUXILIARY_DETAILS.PROBATIONENDDATE PROBATIONENDDATE,
	EMPLOYEE_AUXILIARY_DETAILS.DATEOFCONFIRMATION DATEOFCONFIRMATION,
	EMPLOYEE_AUXILIARY_DETAILS.LASTPROMOTIONDATE LASTPROMOTIONDATE,
	EMPLOYEE_AUXILIARY_DETAILS.DUERETIREMENTDATE DUERETIREMENTDATE,
	EMPLOYEE_AUXILIARY_DETAILS.ACTUALRETIREMENTDATE ACTUALRETIREMENTDATE,
	EMPLOYEE_AUXILIARY_DETAILS.LASTINCREMENTDATE LASTINCREMENTDATE,
	EMPLOYEE_AUXILIARY_DETAILS.DUEINCREMENTDATE DUEINCREMENTDATE,
	EMPLOYEE_AUXILIARY_DETAILS.ACTUALINCREMENTDATE ACTUALINCREMENTDATE,
	EMPLOYEE_AUXILIARY_DETAILS.SUSPENSIONFROMDATE SUSPENSIONFROMDATE,
	EMPLOYEE_AUXILIARY_DETAILS.SUSPENSIONTODATE SUSPENSIONTODATE,
	EMPLOYEE_AUXILIARY_DETAILS.DATEOFRESIGNATIONTENDERED DATEOFRESIGNATIONTENDERED,
	EMPLOYEE_AUXILIARY_DETAILS.DATEOFSEPERATION DATEOFSEPERATION,
	EMPLOYEE_AUXILIARY_DETAILS.FATHERNAME FATHERNAME,
	EMPLOYEE_AUXILIARY_DETAILS.FATHERDOB FATHERDOB,
	EMPLOYEE_AUXILIARY_DETAILS.MOTHERNAME MOTHERNAME,
	EMPLOYEE_AUXILIARY_DETAILS.MOTHERDOB MOTHERDOB,
	EMPLOYEE_AUXILIARY_DETAILS.CONTRACTDESCRIPTION CONTRACTDESCRIPTION,
	EMPLOYEE_AUXILIARY_DETAILS.UHID UHID,
	EMPLOYEE_AUXILIARY_DETAILS.PHTYPE PHTYPE,
	EMPLOYEE_AUXILIARY_DETAILS.RHTYPE RHTYPE,
	EMPLOYEE_AUXILIARY_DETAILS.STOPPAYMENT STOPPAYMENT,
	EMPLOYEE_AUXILIARY_DETAILS.PFNUMBER PFNUMBER,
	EMPLOYEE_AUXILIARY_DETAILS.PAYROLLPROCESSDATE PAYROLLPROCESSDATE,
	EMPLOYEE_AUXILIARY_DETAILS.RESIGNATION_RFLID RESIGNATION_RFLID,
	EMPLOYEE_AUXILIARY_DETAILS.TRIALSTARTDATE TRIALSTARTDATE,
	EMPLOYEE_AUXILIARY_DETAILS.TRIALENDDATE TRIALENDDATE
from
	hr.employee_auxiliary_details EMPLOYEE_AUXILIARY_DETAILS;
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

create or replace view HR.MV_EMPLOYEE_PASSPORT_DETAILS
as
select
	EMPLOYEE_PASSPORT_DETAILS.PASSPORT_ID PASSPORT_ID,
	EMPLOYEE_PASSPORT_DETAILS.PASSPORT_NUMBER PASSPORT_NUMBER,
	EMPLOYEE_PASSPORT_DETAILS.PLACE_OF_ISSUE PLACE_OF_ISSUE,
	EMPLOYEE_PASSPORT_DETAILS.DATE_OF_ISSUE DATE_OF_ISSUE,
	EMPLOYEE_PASSPORT_DETAILS.DATE_OF_EXPIRY DATE_OF_EXPIRY,
	EMPLOYEE_PASSPORT_DETAILS.EMIGRATION_CHECK_REQUIRED EMIGRATION_CHECK_REQUIRED,
	EMPLOYEE_PASSPORT_DETAILS.EMP_ID EMP_ID,
	EMPLOYEE_PASSPORT_DETAILS.VISADETAILS VISADETAILS,
	EMPLOYEE_PASSPORT_DETAILS.UPDATEDBY UPDATEDBY,
	EMPLOYEE_PASSPORT_DETAILS.UPDATEDDATE UPDATEDDATE,
	EMPLOYEE_PASSPORT_DETAILS.ADDRESS_ID ADDRESS_ID,
	EMPLOYEE_PASSPORT_DETAILS.STATUS STATUS
from
	hr.employee_passport_details EMPLOYEE_PASSPORT_DETAILS;

create or replace view BILLING.LOVMASTER_DUP
as
select
	LOVMASTER.LOVID LOVID,
	LOVMASTER.LOVCODE LOVCODE,
	LOVMASTER.LOVNAME LOVNAME,
	LOVMASTER.LOVDESCRIPTION LOVDESCRIPTION,
	LOVMASTER.STATUS STATUS,
	LOVMASTER.CREATEDBY CREATEDBY,
	LOVMASTER.CREATEDDATE CREATEDDATE,
	LOVMASTER.UPDATEDBY UPDATEDBY,
	LOVMASTER.UPDATEDDATE UPDATEDDATE
from
	billing.vwr_lovmaster LOVMASTER;

create or replace view BILLING.SERVICEMASTER_DUP
as
select
	SERVICEMASTER.SERVICEID SERVICEID,
	SERVICEMASTER.SERVICECODE SERVICECODE,
	SERVICEMASTER.SERVICENAME SERVICENAME,
	SERVICEMASTER.SERVICEDESCRIPTION SERVICEDESCRIPTION,
	SERVICEMASTER.SERVICETYPEID SERVICETYPEID,
	SERVICEMASTER.SERVICECATEGORYID SERVICECATEGORYID,
	SERVICEMASTER.DEPTID DEPTID,
	SERVICEMASTER.SUBDEPTID SUBDEPTID,
	SERVICEMASTER.BASEDON BASEDON,
	SERVICEMASTER.SCHUDELABLE SCHUDELABLE,
	SERVICEMASTER.RESOURESREQUIRED RESOURESREQUIRED,
	SERVICEMASTER.EFFECTIVEFROM EFFECTIVEFROM,
	SERVICEMASTER.EFFECTIVETO EFFECTIVETO,
	SERVICEMASTER.RESTORABLE RESTORABLE,
	SERVICEMASTER.SERVICESTATUS SERVICESTATUS,
	SERVICEMASTER.UOMID UOMID,
	SERVICEMASTER.SERVICEMODEL SERVICEMODEL,
	SERVICEMASTER.SERVICEPROVIDERTYPE SERVICEPROVIDERTYPE,
	SERVICEMASTER.SERVICEPROVIDERNAME SERVICEPROVIDERNAME,
	SERVICEMASTER.PARTNERDESCRIPTION PARTNERDESCRIPTION,
	SERVICEMASTER.DEPOSITEAPPLICABLE DEPOSITEAPPLICABLE,
	SERVICEMASTER.APPROVALREQUIREDFORBUFFER APPROVALREQUIREDFORBUFFER,
	SERVICEMASTER.PEMREQUIRED PEMREQUIRED,
	SERVICEMASTER.CONSENTREQUIRED CONSENTREQUIRED,
	SERVICEMASTER.COSTDEFINITIONID COSTDEFINITIONID,
	SERVICEMASTER.FINANCIALVERSIONNO FINANCIALVERSIONNO,
	SERVICEMASTER.NONFINANCIALVERSIONNO NONFINANCIALVERSIONNO,
	SERVICEMASTER.BILLABLE BILLABLE,
	SERVICEMASTER.NATUREOFBILLING NATUREOFBILLING,
	SERVICEMASTER.BILLABLETYPE BILLABLETYPE,
	SERVICEMASTER.DISCOUNTABLE DISCOUNTABLE,
	SERVICEMASTER.DEPOSITEAMOUNT DEPOSITEAMOUNT,
	SERVICEMASTER.DEPOSITEPERCENTAGE DEPOSITEPERCENTAGE,
	SERVICEMASTER.REFUNDABLE REFUNDABLE,
	SERVICEMASTER.REFUNDPERIOD REFUNDPERIOD,
	SERVICEMASTER.REFUNDAMOUNT REFUNDAMOUNT,
	SERVICEMASTER.REFUNDPERCENT REFUNDPERCENT,
	SERVICEMASTER.AUTHORIZATIONREQUIRED AUTHORIZATIONREQUIRED,
	SERVICEMASTER.TAXABLE TAXABLE,
	SERVICEMASTER.VERSIONNO VERSIONNO,
	SERVICEMASTER.EQUIPMENT EQUIPMENT,
	SERVICEMASTER.CLINICAL CLINICAL,
	SERVICEMASTER.AVAILABLEONINTERNET AVAILABLEONINTERNET,
	SERVICEMASTER.FACILITY FACILITY,
	SERVICEMASTER.MAXDISCOUNTPERCENT MAXDISCOUNTPERCENT,
	SERVICEMASTER.HIGHVALUESERVICES HIGHVALUESERVICES,
	SERVICEMASTER.DISCOUNTLIMIT DISCOUNTLIMIT,
	SERVICEMASTER.DISCOUNTDESCRIPTION DISCOUNTDESCRIPTION,
	SERVICEMASTER.DISCOUNTAPPLICABLE DISCOUNTAPPLICABLE,
	SERVICEMASTER.EPISODECOUNT EPISODECOUNT,
	SERVICEMASTER.DEPOSITTARIFFAMOUNT DEPOSITTARIFFAMOUNT,
	SERVICEMASTER.DEPOSITTARIFFPERCENTAGE DEPOSITTARIFFPERCENTAGE,
	SERVICEMASTER.NONFINANCIALVERSIONCONTROL NONFINANCIALVERSIONCONTROL,
	SERVICEMASTER.TOTALBASEPRICE TOTALBASEPRICE,
	SERVICEMASTER.DEPENDENTSERVICE DEPENDENTSERVICE,
	SERVICEMASTER.CHILD CHILD,
	SERVICEMASTER.DATACENTERFLAG DATACENTERFLAG,
	SERVICEMASTER.COMPANYID COMPANYID,
	SERVICEMASTER.LOCATIONID LOCATIONID,
	SERVICEMASTER.UPDATEDBY UPDATEDBY,
	SERVICEMASTER.UPDATEDATE UPDATEDATE,
	SERVICEMASTER.CREATEDDATE CREATEDDATE,
	SERVICEMASTER.CREATEDBY CREATEDBY,
	SERVICEMASTER.PREREQUISITEREQUIRED PREREQUISITEREQUIRED,
	SERVICEMASTER.PATIENTTYPEID PATIENTTYPEID,
	SERVICEMASTER.ISCOMPOSITESERVICE ISCOMPOSITESERVICE,
	SERVICEMASTER.DISCOUNTTYPE DISCOUNTTYPE,
	SERVICEMASTER.DEPOSITETYPE DEPOSITETYPE,
	SERVICEMASTER.MATERIAL MATERIAL,
	SERVICEMASTER.ADJUSTABLEAMOUNT ADJUSTABLEAMOUNT,
	SERVICEMASTER.STARTBEFORE STARTBEFORE,
	SERVICEMASTER.MAXNOOFDAYS MAXNOOFDAYS,
	SERVICEMASTER.PACKAGETYPEID PACKAGETYPEID,
	SERVICEMASTER.ISPACKAGEDEFINED ISPACKAGEDEFINED,
	SERVICEMASTER.VISIBLE VISIBLE,
	SERVICEMASTER.GRACEPERIOD GRACEPERIOD,
	SERVICEMASTER.CODIFICATIONREQUIRED CODIFICATIONREQUIRED,
	SERVICEMASTER.GENDERAPPLICABILITY GENDERAPPLICABILITY,
	SERVICEMASTER.ITEMCODE ITEMCODE,
	SERVICEMASTER.REFUNDTYPE REFUNDTYPE,
	SERVICEMASTER.REFUNDPERIODTYPE REFUNDPERIODTYPE,
	SERVICEMASTER.ISNONAPOLLOSERVICE ISNONAPOLLOSERVICE,
	SERVICEMASTER.SERVICEALIAS SERVICEALIAS,
	SERVICEMASTER.ISFREQUENTLYUSED ISFREQUENTLYUSED
from
	billing.vw_servicemaster SERVICEMASTER
;

create or replace view HR.TEMP_EMP_NOMINEE_FUNDDETAILS
as
select
	EMP_NOMINEE_FUNDDETAILS.NOMINEE_FUNDID NOMINEE_FUNDID,
	EMP_NOMINEE_FUNDDETAILS.NOMINEE_ID NOMINEE_ID,
	EMP_NOMINEE_FUNDDETAILS.PERCENTAGE_AMOUNT PERCENTAGE_AMOUNT,
	EMP_NOMINEE_FUNDDETAILS.UPDATEDBY UPDATEDBY,
	EMP_NOMINEE_FUNDDETAILS.UPDATEDDATE UPDATEDDATE,
	EMP_NOMINEE_FUNDDETAILS.STATUS STATUS,
	EMP_NOMINEE_FUNDDETAILS.NOMINEE_OF NOMINEE_OF
from
	hr.vwr_emp_nominee_funddetails EMP_NOMINEE_FUNDDETAILS
;

create or replace view BILLING.MV_PACKAGEDEFINITION
as
select
	PACKAGEDEFINITION.PACKAGEID PACKAGEID,
	PACKAGEDEFINITION.STAYOTHERBEDCATEGORY STAYOTHERBEDCATEGORY,
	PACKAGEDEFINITION.STAYICU STAYICU,
	PACKAGEDEFINITION.STARTBEFORE STARTBEFORE,
	PACKAGEDEFINITION.CUSTOMERID CUSTOMERID,
	PACKAGEDEFINITION.AGREEMENTID AGREEMENTID,
	PACKAGEDEFINITION.LOCATIONID LOCATIONID,
	PACKAGEDEFINITION.CREATEDBY CREATEDBY,
	PACKAGEDEFINITION.CREATEDDATE CREATEDDATE,
	PACKAGEDEFINITION.UPDATEDBY UPDATEDBY,
	PACKAGEDEFINITION.UPDATEDDATE UPDATEDDATE,
	PACKAGEDEFINITION.VERSIONNO VERSIONNO,
	PACKAGEDEFINITION.PACKAGEDEFINITIONID PACKAGEDEFINITIONID,
	PACKAGEDEFINITION.CRMSTATUS CRMSTATUS,
	PACKAGEDEFINITION.OTHERSERVICETYPEFLAG OTHERSERVICETYPEFLAG
from
	billing.vw_packagedefinition PACKAGEDEFINITION
;

create or replace view PHARMACY.ITEMCOMPANY_1
as
select
	ITEMCOMPANY.ISCONSIGNMENTITEM ISCONSIGNMENTITEM,
	ITEMCOMPANY.VARIANTALLOWED VARIANTALLOWED,
	ITEMCOMPANY.ISHAZARDOUS ISHAZARDOUS,
	ITEMCOMPANY.ISINCLUSEDINCOSTING ISINCLUSEDINCOSTING,
	ITEMCOMPANY.VEDANALYSIS VEDANALYSIS,
	ITEMCOMPANY.ITEMCLASSIFICATION ITEMCLASSIFICATION,
	ITEMCOMPANY.ITEMCATEGORY ITEMCATEGORY,
	ITEMCOMPANY.ITEMSUBCATEGORY1 ITEMSUBCATEGORY1,
	ITEMCOMPANY.ITEMSUBCATEGORY2 ITEMSUBCATEGORY2,
	ITEMCOMPANY.ITEMSUBCATEGORY3 ITEMSUBCATEGORY3,
	ITEMCOMPANY.ITEMSTORAGETYPE ITEMSTORAGETYPE,
	ITEMCOMPANY.UNITWEIGHT UNITWEIGHT,
	ITEMCOMPANY.WEIGHTUOM WEIGHTUOM,
	ITEMCOMPANY.UNITVOLUME UNITVOLUME,
	ITEMCOMPANY.VOLUMEUOM VOLUMEUOM,
	ITEMCOMPANY.LOOKUPID LOOKUPID,
	ITEMCOMPANY.SEQNUMBER SEQNUMBER,
	ITEMCOMPANY.ITEMTYPE ITEMTYPE,
	ITEMCOMPANY.ITEMCODE ITEMCODE,
	ITEMCOMPANY.ITEMSHORTDESC ITEMSHORTDESC,
	ITEMCOMPANY.ITEMLONGDESC ITEMLONGDESC,
	ITEMCOMPANY.FLEXIFIELD1 FLEXIFIELD1,
	ITEMCOMPANY.FLEXIFIELD2 FLEXIFIELD2,
	ITEMCOMPANY.FLEXIFIELD3 FLEXIFIELD3,
	ITEMCOMPANY.FLEXIFIELD4 FLEXIFIELD4,
	ITEMCOMPANY.FLEXIFIELD5 FLEXIFIELD5,
	ITEMCOMPANY.BARCODE BARCODE,
	ITEMCOMPANY.BIS BIS,
	ITEMCOMPANY.LEGACYITEMCODE LEGACYITEMCODE,
	ITEMCOMPANY.REUSABLEITEM REUSABLEITEM,
	ITEMCOMPANY.CREATIONDATE CREATIONDATE,
	ITEMCOMPANY.ITEMDESCNEW ITEMDESCNEW,
	ITEMCOMPANY.ITEMBRIEFDESC ITEMBRIEFDESC,
	ITEMCOMPANY.GENERICNAME GENERICNAME,
	ITEMCOMPANY.SCHEDULETYPEID SCHEDULETYPEID,
	ITEMCOMPANY.MANUFACTURERID MANUFACTURERID,
	ITEMCOMPANY.DRUGTYPECATEGORYID DRUGTYPECATEGORYID,
	ITEMCOMPANY.DRUGTYPESTATUS DRUGTYPESTATUS,
	ITEMCOMPANY.DRUGSTRENGTH DRUGSTRENGTH
from
	pharmacy.vwr_itemcompany ITEMCOMPANY
;

create or replace view CRM.CUSTOMERS_1
as
select
	CUSTOMERS.CUSTOMERID CUSTOMERID,
	CUSTOMERS.CUSTOMERCATEGORYID CUSTOMERCATEGORYID,
	CUSTOMERS.CUSTOMERTYPEID CUSTOMERTYPEID,
	CUSTOMERS.CUSTOMERNAME CUSTOMERNAME,
	CUSTOMERS.STATUSID STATUSID,
	CUSTOMERS.ESTABLISHEDDATE ESTABLISHEDDATE,
	CUSTOMERS.TITLEID TITLEID,
	CUSTOMERS.FIRSTNAME FIRSTNAME,
	CUSTOMERS.MIDDLENAME MIDDLENAME,
	CUSTOMERS.LASTNAME LASTNAME,
	CUSTOMERS.GENDERID GENDERID,
	CUSTOMERS.DATEOFBIRTH DATEOFBIRTH,
	CUSTOMERS.WEDDINGANNIVERSARY WEDDINGANNIVERSARY,
	CUSTOMERS.MCIREGISTRATIONNO MCIREGISTRATIONNO,
	CUSTOMERS.RANK RANK,
	CUSTOMERS.PAN PAN,
	CUSTOMERS.PARENTCOMPANY PARENTCOMPANY,
	CUSTOMERS.INDUSTRYTYPE INDUSTRYTYPE,
	CUSTOMERS.INDUSTRYSUBTYPE INDUSTRYSUBTYPE,
	CUSTOMERS.TOTALNOOFEMPLOYEES TOTALNOOFEMPLOYEES,
	CUSTOMERS.TPANAME TPANAME,
	CUSTOMERS.INSURANCECOMPANYNAME INSURANCECOMPANYNAME,
	CUSTOMERS.REGISTEREDNO REGISTEREDNO,
	CUSTOMERS.NOOFBENIFICIARIES NOOFBENIFICIARIES,
	CUSTOMERS.IRDANO IRDANO,
	CUSTOMERS.HEALTHCAREFECILITATOR HEALTHCAREFECILITATOR,
	CUSTOMERS.CREATEDBY CREATEDBY,
	CUSTOMERS.CREATEDDATE CREATEDDATE,
	CUSTOMERS.UPDATEDBY UPDATEDBY,
	CUSTOMERS.UPDATEDDATE UPDATEDDATE,
	CUSTOMERS.AVERAGEAGE AVERAGEAGE,
	CUSTOMERS.PRIMARYOWNER PRIMARYOWNER,
	CUSTOMERS.STATEGOVTREGNO STATEGOVTREGNO,
	CUSTOMERS.CUSTOMERCODE CUSTOMERCODE,
	CUSTOMERS.QUALIFICATION QUALIFICATION,
	CUSTOMERS.SPECIALIZATION SPECIALIZATION,
	CUSTOMERS.LOCATIONID LOCATIONID,
	CUSTOMERS.PROCESSED_FLAG PROCESSED_FLAG,
	CUSTOMERS.ASSIGNEDOWNER ASSIGNEDOWNER,
	CUSTOMERS.OLDCUSTOMERCODE OLDCUSTOMERCODE,
	CUSTOMERS.CUSTOMERREMARKS CUSTOMERREMARKS,
	CUSTOMERS.HOBBIES HOBBIES,
	CUSTOMERS.NOOFOPD NOOFOPD,
	CUSTOMERS.PATIENTIDENTIFIER PATIENTIDENTIFIER,
	CUSTOMERS.ROUNDOFFREQUIRED ROUNDOFFREQUIRED
from
	crm.vwr_customers CUSTOMERS
;

create or replace view crm.AGREEMENTS_16JAN_TEST
as
select
	AGREEMENTS.AGREEMENTID AGREEMENTID,
	AGREEMENTS.AGREEMENTCODE AGREEMENTCODE,
	AGREEMENTS.AGREEMENTNAME AGREEMENTNAME,
	AGREEMENTS.CUSTOMERID CUSTOMERID,
	AGREEMENTS.STATUSID STATUSID,
	AGREEMENTS.EFFECTIVEDATE EFFECTIVEDATE,
	AGREEMENTS.EXPIRYDATE EXPIRYDATE,
	AGREEMENTS.UPDATINGTARIFFRULES UPDATINGTARIFFRULES,
	AGREEMENTS.DESCRIPTION DESCRIPTION,
	AGREEMENTS.PRIMARYASSIGNEDOWNER PRIMARYASSIGNEDOWNER,
	AGREEMENTS.CREATEDBY CREATEDBY,
	AGREEMENTS.CREATEDDATE CREATEDDATE,
	AGREEMENTS.UPDATEDBY UPDATEDBY,
	AGREEMENTS.UPDATEDDATE UPDATEDDATE,
	AGREEMENTS.QUOTEID QUOTEID,
	AGREEMENTS.SIGNINGDATE SIGNINGDATE,
	AGREEMENTS.FILETYPE FILETYPE,
	AGREEMENTS.FILENAME FILENAME,
	AGREEMENTS.FILEPATH FILEPATH,
	AGREEMENTS.CUSTOMERCATEGORYID CUSTOMERCATEGORYID,
	AGREEMENTS.CUSTOMERTYPEID CUSTOMERTYPEID,
	AGREEMENTS.AGREEMENTPRICINGDETAILS AGREEMENTPRICINGDETAILS,
	AGREEMENTS.CUSTOMERPAYMENTDETAILS CUSTOMERPAYMENTDETAILS,
	AGREEMENTS.CUSTOMERNAME CUSTOMERNAME,
	AGREEMENTS.APPLICABLELOCATIONS APPLICABLELOCATIONS,
	AGREEMENTS.ELIGIBILITYCHECK ELIGIBILITYCHECK,
	AGREEMENTS.PROSPECTIVEREVIEW PROSPECTIVEREVIEW,
	AGREEMENTS.DISCHARGEMANAGEMENT DISCHARGEMANAGEMENT,
	AGREEMENTS.CONCURENTREVIEW CONCURENTREVIEW,
	AGREEMENTS.IDENTIFIERS IDENTIFIERS,
	AGREEMENTS.TIMEPERIOD TIMEPERIOD,
	AGREEMENTS.APPLICABILITY APPLICABILITY,
	AGREEMENTS.REMARKS REMARKS,
	AGREEMENTS.BASEBEDCATEGORYID BASEBEDCATEGORYID,
	AGREEMENTS.LOCATIONID LOCATIONID,
	AGREEMENTS.BASEPATIENTTYPEID BASEPATIENTTYPEID,
	AGREEMENTS.ASSIGNEDOWNER ASSIGNEDOWNER,
	AGREEMENTS.TARIFFPOSTINGFLAG TARIFFPOSTINGFLAG,
	AGREEMENTS.DUEDATE DUEDATE,
	AGREEMENTS.USEASREF_TEMPLATE USEASREF_TEMPLATE,
	AGREEMENTS.MEDICINEAMOUNTLIMIT MEDICINEAMOUNTLIMIT,
	AGREEMENTS.GROUPMEDICINEAMOUNTLIMIT GROUPMEDICINEAMOUNTLIMIT,
	AGREEMENTS.ISEMPAGREEMENT ISEMPAGREEMENT,
	AGREEMENTS.STATUSFLAG STATUSFLAG,
	AGREEMENTS.CURRENCYCODE CURRENCYCODE
from
	crm.vwr_agreements AGREEMENTS
;

create or replace view REGISTRATION.MV_ENT_PATIENTALLERGY
as select
	*
from
	registration.vwr_ent_patientallergy
;

create or replace view EHIS.MV_SUPPORT_TEAM 
as select
	SUPPORT_TEAM.ACCOUNT_ID ACCOUNT_ID,
	SUPPORT_TEAM.EMPLOYEE_NAME EMPLOYEE_NAME,
	SUPPORT_TEAM.LOCATION_NAME LOCATION_NAME
from
	ehis.vwr_support_team SUPPORT_TEAM
;

create or replace view RADIOLOGY.HL7_RADREQUESTDTLS_DELHI
as 
select
	REQUESTDTLID,
	ACCESSIONNO,
	ISBILLED,
	SRVCSTATUS
from
	RADIOLOGY.RADREQUESTDTLS
;

create or replace view hr.HL7_RADREQUESTDTLS
as
select
	REQUESTDTLID,
	ACCESSIONNO,
	ISBILLED,
	SRVCSTATUS
from
	RADIOLOGY.RADREQUESTDTLS
;

create or replace view EHIS.ITEMCOMPANY
as
select
	ITEMCOMPANY.ISCONSIGNMENTITEM ISCONSIGNMENTITEM,
	ITEMCOMPANY.VARIANTALLOWED VARIANTALLOWED,
	ITEMCOMPANY.ISHAZARDOUS ISHAZARDOUS,
	ITEMCOMPANY.ISINCLUSEDINCOSTING ISINCLUSEDINCOSTING,
	ITEMCOMPANY.VEDANALYSIS VEDANALYSIS,
	ITEMCOMPANY.ITEMCLASSIFICATION ITEMCLASSIFICATION,
	ITEMCOMPANY.ITEMCATEGORY ITEMCATEGORY,
	ITEMCOMPANY.ITEMSUBCATEGORY1 ITEMSUBCATEGORY1,
	ITEMCOMPANY.ITEMSUBCATEGORY2 ITEMSUBCATEGORY2,
	ITEMCOMPANY.ITEMSUBCATEGORY3 ITEMSUBCATEGORY3,
	ITEMCOMPANY.ITEMSTORAGETYPE ITEMSTORAGETYPE,
	ITEMCOMPANY.UNITWEIGHT UNITWEIGHT,
	ITEMCOMPANY.WEIGHTUOM WEIGHTUOM,
	ITEMCOMPANY.UNITVOLUME UNITVOLUME,
	ITEMCOMPANY.VOLUMEUOM VOLUMEUOM,
	ITEMCOMPANY.LOOKUPID LOOKUPID,
	ITEMCOMPANY.SEQNUMBER SEQNUMBER,
	ITEMCOMPANY.ITEMTYPE ITEMTYPE,
	ITEMCOMPANY.ITEMCODE ITEMCODE,
	ITEMCOMPANY.ITEMSHORTDESC ITEMSHORTDESC,
	ITEMCOMPANY.ITEMLONGDESC ITEMLONGDESC,
	ITEMCOMPANY.FLEXIFIELD1 FLEXIFIELD1,
	ITEMCOMPANY.FLEXIFIELD2 FLEXIFIELD2,
	ITEMCOMPANY.FLEXIFIELD3 FLEXIFIELD3,
	ITEMCOMPANY.FLEXIFIELD4 FLEXIFIELD4,
	ITEMCOMPANY.FLEXIFIELD5 FLEXIFIELD5,
	ITEMCOMPANY.BARCODE BARCODE,
	ITEMCOMPANY.BIS BIS,
	ITEMCOMPANY.LEGACYITEMCODE LEGACYITEMCODE,
	ITEMCOMPANY.REUSABLEITEM REUSABLEITEM,
	ITEMCOMPANY.CREATIONDATE CREATIONDATE,
	ITEMCOMPANY.ITEMDESCNEW ITEMDESCNEW,
	ITEMCOMPANY.ITEMBRIEFDESC ITEMBRIEFDESC,
	ITEMCOMPANY.LEGACYSTOREITEMCODE LEGACYSTOREITEMCODE,
	ITEMCOMPANY.STATUS STATUS,
	ITEMCOMPANY.UPDATEDATE UPDATEDATE
from
	mm.vw_itemcompany ITEMCOMPANY
;
create or replace view hr.mv_EMP_PRM_HISTORY
as 
select
	EMP_PRM_HISTORY.EMP_NO EMP_NO,
	EMP_PRM_HISTORY.EMP_CAT_CODE EMP_CAT_CODE,
	EMP_PRM_HISTORY.EFF_FROM_DT EFF_FROM_DT,
	EMP_PRM_HISTORY.EFF_TO_DT EFF_TO_DT,
	EMP_PRM_HISTORY.PRM_ARR_FLAG PRM_ARR_FLAG,
	EMP_PRM_HISTORY.USER_ID USER_ID,
	EMP_PRM_HISTORY.UPDT UPDT,
	EMP_PRM_HISTORY.EMP_STAFFTYPE_CODE EMP_STAFFTYPE_CODE,
	EMP_PRM_HISTORY.EMP_GRADE_ID EMP_GRADE_ID,
	EMP_PRM_HISTORY.EMP_POSITION_ID EMP_POSITION_ID,
	EMP_PRM_HISTORY.PRMCOUNT PRMCOUNT
from
	hr.vwr_emp_prm_history EMP_PRM_HISTORY
;


create or replace view mm.vw_itemstore_del
as select	* from mm.ItemStore ;

create or replace view mm.vw_qoh_del
as select	* from mm.qoh ;

create or replace view mm.vw_dailyinventory_del
as select	* from mm.dailyinventory ;


create or replace view mm.vw_itemstore_qoh_del
as
select	mis.itemcode as ItemCode, round(coalesce (sum(mqh.qty),0),2) as Qty, mis.storecode as storecode
from mm.ItemStore mis, mm.qoh mqh
where mis.itemcode = mqh.itemcode and mis.storecode = mqh.storecode
group by mis.itemcode, mis.storecode ;

create or replace view hr.vw_EMPLOYEE_PASSPORT_DETAILS
as
select
	EMPLOYEE_PASSPORT_DETAILS.PASSPORT_ID PASSPORT_ID,
	EMPLOYEE_PASSPORT_DETAILS.PASSPORT_NUMBER PASSPORT_NUMBER,
	EMPLOYEE_PASSPORT_DETAILS.PLACE_OF_ISSUE PLACE_OF_ISSUE,
	EMPLOYEE_PASSPORT_DETAILS.DATE_OF_ISSUE DATE_OF_ISSUE,
	EMPLOYEE_PASSPORT_DETAILS.DATE_OF_EXPIRY DATE_OF_EXPIRY,
	EMPLOYEE_PASSPORT_DETAILS.EMIGRATION_CHECK_REQUIRED EMIGRATION_CHECK_REQUIRED,
	EMPLOYEE_PASSPORT_DETAILS.EMP_ID EMP_ID,
	EMPLOYEE_PASSPORT_DETAILS.VISADETAILS VISADETAILS,
	EMPLOYEE_PASSPORT_DETAILS.UPDATEDBY UPDATEDBY,
	EMPLOYEE_PASSPORT_DETAILS.UPDATEDDATE UPDATEDDATE,
	EMPLOYEE_PASSPORT_DETAILS.ADDRESS_ID ADDRESS_ID,
	EMPLOYEE_PASSPORT_DETAILS.STATUS STATUS
from
	hr.employee_passport_details EMPLOYEE_PASSPORT_DETAILS;