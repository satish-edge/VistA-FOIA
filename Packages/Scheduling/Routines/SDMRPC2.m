SDMRPC2 ;MTZ/CKU - APPOINTMENT RPC; 07/23/2012  3:03 PM
 ;;6.0;Scheduling;;07/17/2012;
 Q
MAKE(RV,DFN,SC,SD,TYPE,LEN,LVL) ; SD APPOINTMENT MAKE
 N STATUS,RESULT S STATUS=$$MAKE^SDMAPI2(.RESULT,DFN,SC,SD,TYPE,LEN,LVL)
 D MERGE^SDMRPC(.RV,.RESULT)
 Q
MAKEUS(RV,DFN,SC,SD,TYP,STYP) ; SD APPOINTMENT MAKE UNSCH
 N STATUS,RESULT S STATUS=$$MAKEUS^SDMAPI2(.RESULT,DFN,SC,SD,TYP,STYP)
 D MERGE^SDMRPC(.RV,.RESULT)
 Q
CHKAPP(RV,SC,DFN,SD,LEN) ; SD APPOINTMENT CHECK
 N STATUS,RESULT S STATUS=$$CHKAPP^SDMAPI2(.RESULT,SC,DFN,SD,LEN)
 D MERGE^SDMRPC(.RV,.RESULT)
 Q
CHECKIN(RV,DFN,SD,SC) ; SD APPOINTMENT CHECK-IN
 N STATUS,RESULT S STATUS=$$CHECKIN^SDMAPI2(.RESULT,DFN,SD,SC)
 D MERGE^SDMRPC(.RV,.RESULT)
 Q
CANCEL(RV,DFN,SC,SD,TYPE,RSN,RMK) ; SD APPOINTMENT CANCEL
 N STATUS,RESULT S STATUS=$$CANCEL^SDMAPI2(.RESULT,DFN,SC,SD,TYPE,RSN,RMK)
 D MERGE^SDMRPC(.RV,.RESULT)
 Q
NOSHOW(RV,DFN,SC,SD,LVL) ; SD APPOINTMENT NOSHOW
 N STATUS,RESULT S STATUS=$$NOSHOW^SDMAPI2(.RESULT,DFN,SC,SD,LVL)
 I 'STATUS S RV=-1
 D MERGE^SDMRPC(.RV,.RESULT)
 Q
LSTAPPT(RV,SEARCH,START,NUMBER) ; SD APPOINTMENT LIST BY NAME
 N STATUS,RESULT S STATUS=$$LSTAPPT^SDMAPI1(.RESULT,SEARCH,START,NUMBER)
 I 'STATUS S RV=-1
 D MERGE^SDMRPC(.RV,.RESULT)
 Q
GETAPPT(RV,TYPE) ; SD GET APPOINTMENT TYPE
 N STATUS,RESULT S STATUS=$$GETAPPT^SDMAPI1(.RESULT,TYPE)
 I 'STATUS S RV=-1
 D MERGE^SDMRPC(.RV,.RESULT)
 Q
GETELIG(RV,ELIG) ; SD GET ELIGIBILITY DETAILS
 N STATUS,RESULT S STATUS=$$GETELIG^SDMAPI1(.RESULT,ELIG)
 I 'STATUS S RV=-1
 D MERGE^SDMRPC(.RV,.RESULT)
 Q
