GMPLSITE ;RGI -- GMPL Site parameters ; 04/06/12
 ;;2.0;Problem List;**260002**;Aug 25, 1994
 Q  ;
 ;
GET(RETURN) ;
 N %
 K RETURN
 S %=$$GETPAR(.RETURN)
 S RETURN("REV")=$S(RETURN("REV")="R":1,1:0)
 Q
 ;
VERIFY()    ;
 N PARAMS
 D GET(.PARAMS)
 Q PARAMS("VER")
 ;
GETPAR(RETURN) ;
 K RETURN
 D GETPARM^GMPLDAL3(.RETURN)
 Q 1
 ;
SET(RETURN,PARAMS) ;
 N CHOICES,HASERR,HASELEM,I
 S CHOICES=",VER,PRT,CLU,REV,SDP,"
 S HASELEM=0,HASERR=0,I=""
 F  S I=$O(PARAMS(I)) Q:I=""  S HASELEM=1 D
 . I CHOICES'[(","_I_",") S HASERR=1 D ERR^GMPLAPIE("RETURN","INVALIDPARAM",I) Q
 . I PARAMS(I)="" Q
 . I I'="REV",PARAMS(I)'=1,PARAMS(I)'=0,PARAMS(I)'="@" S HASERR=1 D ERR^GMPLAPIE("RETURN","INVALIDPARAM",PARAMS(I)_" @"_I) Q
 . I I="REV",PARAMS(I)'="R",PARAMS(I)'="C",PARAMS(I)'="@" S HASERR=1 D ERR^GMPLAPIE("RETURN","INVALIDPARAM",PARAMS(I)_" @"_I) Q
 I HASERR Q 0
 I 'HASELEM D ERR^GMPLAPIE("RETURN","INVALIDPARAM","NO KEY") Q 0
 D SETPARM^GMPLDAL3(.PARAMS)
 Q 1
 ;
