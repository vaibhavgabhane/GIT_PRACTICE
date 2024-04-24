SELECT DISTINCT RH.PLANNED_DATE SURGERYDATE,
               RH.IP_NUMBER IPNO,
               RH.PROC_REQ_HDR_ID REQUESTNO,
               (SELECT concat((SELECT TM.TITLETYPE
                          FROM EHIS.TITLEMASTER TM
                         WHERE TM.TITLEID = P.TITLE),null) || ' ' ||
concat(P.FIRSTNAME,null) || ' ' ||
                       concat(P.MIDDLENAME,null) || ' ' || concat(P.LASTNAME,null)
                  FROM REGISTRATION.PATIENT P
                 WHERE P.UHID = RH.UHID) AS PATIENTNAME,
               OT.PKG_OT_UTIL.F_GET_SURGERY_NAMES(RH.PROC_REQ_HDR_ID,
                                                  'A',
                                                  10201) SERVICENAME,
               concat(CTD.TIMEOUT_DATE,null) ||' '|| concat(CTD.TIMEOUT_TIME,null) OTSTARTDATETIME,
               concat(CTD.CHKOUT_DATE,null) ||' '|| concat(CTD.CHKOUT_TIME,null) OTENDDATETIME,
               --(CTD.CHKOUT_TIME - CTD.TIMEOUT_TIME) * 24 * 60 OTDURATION,
               (TO_DATE(concat(CTD.CHKOUT_DATE,null) || concat(CTD.CHKOUT_TIME,null),
                        'DD-MON-YYHH24:MI:SS') -
               TO_DATE(concat(CTD.TIMEOUT_DATE,null) || concat(CTD.TIMEOUT_TIME,null),
                        'DD-MON-YYHH24:MI:SS')) * 24 * 60 OTDURATION,

               /*(SELECT E.FIRSTNAME || ' ' || E.MIDDLENAME || ' ' ||
                                                      E.LASTNAME
                                                 FROM WARDS.OTNURSEDETAILS O,
               HR.EMPLOYEE_MAIN_DETAILS E
                                                WHERE O.IPNUMBER = OT.IPNUMBER
                                                  AND E.EMPLOYEEID =
O.NURSEID) SCRUBNURSE,*/
               RM.ROOMNAME,
               ('DR.' || concat(EMP.FIRSTNAME,null) || ' ' || concat(EMP.MIDDLENAME,null) || ' ' ||
               concat(EMP.LASTNAME,null)) SURGEON,
               SM.SPECIALITY_NAME
 FROM /*WARDS.OTREQUEST OT,

      WARDS.OTSURGEONDETAILS OTS,*/ OT.OT_PROC_REQ_HDR RH
 JOIN OT.OT_CONSUMPTN_TIMEOUT_DTLS CTD ON RH.PROC_REQ_HDR_ID =
                                          CTD.PROC_REQ_HDR_ID
--   WARDS.OTANESTHESIANDETAILS OAD,
 JOIN EHIS.ROOMMASTER RM ON RH.PLANNED_OT_ID = RM.ROOMID
 JOIN HR.EMPLOYEE_MAIN_DETAILS EMP ON EMP.EMPLOYEEID = RH.TEAM_LEAD_ID
 JOIN EHIS.SPECIALITYMASTER SM ON EMP.SPECIALITYID = SM.SPECIALITY_ID

 WHERE TRUNC(CTD.TIMEOUT_DATE) BETWEEN '01-nov-2021' AND '30-nov-2021'

     -- AND OAD.IPNUMBER = OT.IPNUMBER
  AND RH.STATUS = 1
  AND RH.REQUEST_STATUS = 3
  AND RH.LOCATIONID = '10201'
  AND RM.LOCATIONID = '10201'
  AND RH.IP_NUMBER IN ('IP372761',
'IP372883',
'IP374142',
'IP374526',
'IP374672',
'IP374954',
'IP375646',
'IP375834',
'IP376327',
'IP376336',
'IP376517',
'IP375879',
'IP376065')

 -- AND RM.ROOMNAME NOT LIKE '%CATH%'
-- ORDER BY SURGERYDATE
