OCXDI01V ;SLC/RJS,CLA - OCX PACKAGE DIAGNOSTIC ROUTINES ;SEP 7,1999 at 10:30
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**32**;Dec 17,1997
 ;;  ;;ORDER CHECK EXPERT version 1.01 released OCT 29,1998
 ;
S ;
 ;
 D DOT^OCXDIAG
 ;
 ;
 K REMOTE,LOCAL,OPCODE,REF
 F LINE=1:1:500 S TEXT=$P($T(DATA+LINE),";",2,999) Q:TEXT  I $L(TEXT) D  Q:QUIT
 .S ^TMP("OCXDIAG",$J,$O(^TMP("OCXDIAG",$J,"A"),-1)+1)=TEXT
 ;
 G ^OCXDI01W
 ;
 Q
 ;
DATA ;
 ;
 ;;R^"863.2:",.01,"E"
 ;;D^VISIT
 ;;R^"863.2:","863.21:1",.01,"E"
 ;;D^FILE
 ;;R^"863.2:","863.21:1",1,"E"
 ;;D^9000010
 ;;EOR^
 ;;KEY^863.2:^PHYSICIANS
 ;;R^"863.2:",.01,"E"
 ;;D^PHYSICIANS
 ;;R^"863.2:","863.21:1",.01,"E"
 ;;D^FILE
 ;;R^"863.2:","863.21:1",1,"E"
 ;;D^200
 ;;EOR^
 ;;EOF^OCXS(863.2)^1
 ;;SOF^863.1  OCX MDD APPLICATION
 ;;KEY^863.1:^CLINICAL QUERIES
 ;;R^"863.1:",.01,"E"
 ;;D^CLINICAL QUERIES
 ;;EOR^
 ;;EOF^OCXS(863.1)^1
 ;;SOF^863.3  OCX MDD LINK
 ;;KEY^863.3:^PATIENT.NAME
 ;;R^"863.3:",.01,"E"
 ;;D^PATIENT.NAME
 ;;R^"863.3:",.02,"E"
 ;;D^PATIENT
 ;;R^"863.3:",.05,"E"
 ;;D^NAME OF PATIENT
 ;;R^"863.3:",3.1,"E"
 ;;D^NAME
 ;;R^"863.3:",3.3,"E"
 ;;D^1
 ;;R^"863.3:","863.32:1",.01,"E"
 ;;D^FM NAVIGATION CODE
 ;;R^"863.3:","863.32:1",1,"E"
 ;;D^.01
 ;;EOR^
 ;;KEY^863.3:^PATIENT.DEMOGRAPHIC
 ;;R^"863.3:",.01,"E"
 ;;D^PATIENT.DEMOGRAPHIC
 ;;R^"863.3:",.02,"E"
 ;;D^PATIENT
 ;;R^"863.3:",3.1,"E"
 ;;D^DEMOGRAPHIC
 ;;R^"863.3:",3.3,"E"
 ;;D^2
 ;;EOR^
 ;;KEY^863.3:^PATIENT.SEX
 ;;R^"863.3:",.01,"E"
 ;;D^PATIENT.SEX
 ;;R^"863.3:",.02,"E"
 ;;D^PATIENT
 ;;R^"863.3:",.04,"E"
 ;;D^DEMOGRAPHIC
 ;;R^"863.3:",.05,"E"
 ;;D^SEX OF PATIENT
 ;;R^"863.3:",3.1,"E"
 ;;D^SEX
 ;;R^"863.3:",3.3,"E"
 ;;D^3
 ;;R^"863.3:","863.31:1",.01,"E"
 ;;D^GENDER
 ;;R^"863.3:","863.32:1",.01,"E"
 ;;D^FM NAVIGATION CODE
 ;;R^"863.3:","863.32:1",1,"E"
 ;;D^.02
 ;;EOR^
 ;;KEY^863.3:^PATIENT.DOB
 ;;R^"863.3:",.01,"E"
 ;;D^PATIENT.DOB
 ;;R^"863.3:",.02,"E"
 ;;D^PATIENT
 ;;R^"863.3:",.04,"E"
 ;;D^DEMOGRAPHIC
 ;;R^"863.3:",.05,"E"
 ;;D^DATE OF BIRTH
 ;;R^"863.3:",3.3,"E"
 ;;D^4
 ;;R^"863.3:","863.31:1",.01,"E"
 ;;D^DATE OF BIRTH
 ;;R^"863.3:","863.31:2",.01,"E"
 ;;D^BIRTHDATE
 ;;R^"863.3:","863.31:3",.01,"E"
 ;;D^DOB
 ;;R^"863.3:","863.32:1",.01,"E"
 ;;D^FM NAVIGATION CODE
 ;;R^"863.3:","863.32:1",1,"E"
 ;;D^DOB
 ;;EOR^
 ;;KEY^863.3:^PATIENT.BLOOD TYPE
 ;;R^"863.3:",.01,"E"
 ;;D^PATIENT.BLOOD TYPE
 ;;R^"863.3:",.02,"E"
 ;;D^PATIENT
 ;;R^"863.3:",.05,"E"
 ;;D^BLOOD TYPE
 ;;R^"863.3:",3.3,"E"
 ;;D^5
 ;;R^"863.3:","863.32:1",.01,"E"
 ;;D^FM NAVIGATION CODE
 ;;R^"863.3:","863.32:1",1,"E"
 ;;D^IHS PATIENT:BLOOD TYPE
 ;;EOR^
 ;;KEY^863.3:^PATIENT.VISIT
 ;;R^"863.3:",.01,"E"
 ;;D^PATIENT.VISIT
 ;;R^"863.3:",.02,"E"
 ;;D^PATIENT
 ;;R^"863.3:",.03,"E"
 ;;D^VISIT
 ;;R^"863.3:",.05,"E"
 ;;D^RECENT CHOLE FLAG
 ;;R^"863.3:",3.3,"E"
 ;;D^6
 ;;R^"863.3:","863.31:1",.01,"E"
 ;;D^ENCOUNTER
 ;;R^"863.3:","863.32:1",.01,"E"
 ;;D^FM NAVIGATION CODE
 ;;R^"863.3:","863.32:1",1,"E"
 ;;D^IHS PATIENT:,VISIT:
 ;;R^"863.3:","863.32:2",.01,"E"
 ;;D^OCXO EXTERNAL FUNCTION CALL
 ;;R^"863.3:","863.32:2",1,"E"
 ;;D^RECCH(|PATIENT IEN|,7)
 ;;R^"863.3:","863.32:3",.01,"E"
 ;;D^OCXO UP-ARROW PIECE NUMBER
 ;;R^"863.3:","863.32:3",1,"E"
 ;;D^1
 ;;EOR^
 ;;KEY^863.3:^VISIT.DATE
 ;;R^"863.3:",.01,"E"
 ;;D^VISIT.DATE
 ;;R^"863.3:",.02,"E"
 ;;D^VISIT
 ;;R^"863.3:",.05,"E"
 ;;D^DATE OF VISIT
 ;;R^"863.3:",3.1,"E"
 ;;D^DATE
 ;;R^"863.3:",3.3,"E"
 ;;D^1
 ;;R^"863.3:","863.31:1",.01,"E"
 ;;D^VISIT DATE
 ;;R^"863.3:","863.31:2",.01,"E"
 ;;D^DATE OF VISIT
 ;;R^"863.3:","863.32:1",.01,"E"
 ;;D^FM NAVIGATION CODE
 ;;R^"863.3:","863.32:1",1,"E"
 ;;D^.01
 ;;EOR^
 ;;KEY^863.3:^VISIT.TYPE
 ;;R^"863.3:",.01,"E"
 ;;D^VISIT.TYPE
 ;;R^"863.3:",.02,"E"
 ;;D^VISIT
 ;;R^"863.3:",.05,"E"
 ;;D^TYPE OF VISIT
 ;;R^"863.3:",3.1,"E"
 ;;D^TYPE
 ;;R^"863.3:",3.3,"E"
 ;;D^2
 ;;R^"863.3:","863.32:1",.01,"E"
 ;;D^FM NAVIGATION CODE
 ;;R^"863.3:","863.32:1",1,"E"
 ;;D^.03
 ;;EOR^
 ;;KEY^863.3:^VISIT.SERVICE CATAGORY
 ;;R^"863.3:",.01,"E"
 ;;D^VISIT.SERVICE CATAGORY
 ;;R^"863.3:",.02,"E"
 ;;D^VISIT
 ;;R^"863.3:",.05,"E"
 ;;D^SERVICE CATEGORY
 ;;R^"863.3:",3.1,"E"
 ;;D^SERVICE CATEGORY
 ;;R^"863.3:",3.3,"E"
 ;;D^3
 ;;R^"863.3:","863.32:1",.01,"E"
 ;;D^FM NAVIGATION CODE
 ;;R^"863.3:","863.32:1",1,"E"
 ;;D^.07
 ;;EOR^
 ;;KEY^863.3:^PATIENT.SSN
 ;;R^"863.3:",.01,"E"
 ;;D^PATIENT.SSN
 ;;R^"863.3:",.02,"E"
 ;;D^PATIENT
 ;;R^"863.3:",.05,"E"
 ;;D^SOCIAL SECURITY NUMBER
 ;;R^"863.3:",3.3,"E"
 ;;D^4
 ;;R^"863.3:","863.32:1",.01,"E"
 ;;D^FM NAVIGATION CODE
 ;;R^"863.3:","863.32:1",1,"E"
 ;;D^.09
 ;;EOR^
 ;;KEY^863.3:^PATIENT.CITY
 ;;R^"863.3:",.01,"E"
 ;;D^PATIENT.CITY
 ;;R^"863.3:",.02,"E"
 ;;D^PATIENT
 ;;R^"863.3:",.05,"E"
 ;;D^CITY
 ;;R^"863.3:",3.3,"E"
 ;;D^11
 ;;R^"863.3:","863.32:1",.01,"E"
 ;;D^FM NAVIGATION CODE
 ;;R^"863.3:","863.32:1",1,"E"
 ;;D^.114
 ;;EOR^
 ;;KEY^863.3:^PATIENT.HL7_FILLER
 ;;R^"863.3:",.01,"E"
 ;;D^PATIENT.HL7_FILLER
 ;;R^"863.3:",.02,"E"
 ;;D^PATIENT
 ;;R^"863.3:",.04,"E"
 ;;D^HL7
 ;;R^"863.3:",.05,"E"
 ;;D^HL7 FILLER
 ;;R^"863.3:","863.32:1",.01,"E"
 ;;D^OCXO VT-BAR PIECE NUMBER
 ;;R^"863.3:","863.32:2",.01,"E"
 ;;D^OCXO UP-ARROW PIECE NUMBER
 ;;R^"863.3:","863.32:2",1,"E"
 ;;D^2
 ;;R^"863.3:","863.32:3",.01,"E"
 ;;D^OCXO VARIABLE NAME
 ;;R^"863.3:","863.32:3",1,"E"
 ;;D^OCXODATA("ORC",3)
 ;;R^"863.3:","863.32:4",.01,"E"
 ;;D^OCXO HL7 SEGMENT ID
 ;;R^"863.3:","863.32:5",.01,"E"
 ;;D^OCXO DATA DRIVE SOURCE
 ;;R^"863.3:","863.32:5",1,"E"
 ;1;
 ;