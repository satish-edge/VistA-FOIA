DGPMAPI1 ;RGI/VSL - ADMIT PATIENT API; 12/14/2012
 ;;5.3;Registration;**260003**;
ADMIT(RETURN,PARAM) ; Admit patient
 ;
 ;Input
 ;
 ;Required elements include:
 ;  PARAM("ADMREG")=admitting regulation
 ;  PARAM("ATNDPHY")=attending physician
 ;  PARAM("DATE")=date time (admission date)
 ;  PARAM("FDEXC")=facility directory exclusion
 ;  PARAM("FTSPEC")=facility treating specialty
 ;  PARAM("PATIENT")=patient
 ;  PARAM("SHDIAG")=short diagnosis
 ;  PARAM("TYPE")=type of movement
 ;  PARAM("WARD")=ward
 ;
 ;Optional elements include:
 ;  PARAM("ADMSCC")=admitted for sc condition
 ;  PARAM("ADMSRC")=source of admission
 ;  PARAM("DIAG",1)=diagnosis array
 ;  PARAM("ELIGIB")=admitting eligibility
 ;  PARAM("PRYMPHY")=primary physician
 ;  PARAM("ROOMBED")=roombed
 ;  PARAM("SCADM")=scheduled admission
 ;  PARAM("SERILL")=condition (SERIOUSLY ILL)
 N %,PM6,DFN,PTF,RPTF,PM1,PM6,NOD60,IFN1,IFN6
 S %=$$CHKADM(.RETURN,.PARAM)
 I %=0 Q 0
 S DFN=PARAM("PATIENT")
 S %=$$LOCKMVT^DGPMDAL1(DFN)
 I %=0 S RETURN=0 D ERRX^DGPMAPIE(.RETURN,"FILELOCK") Q 0
 S PM1(.01)=PARAM("DATE") ; admission date
 D ADDMVMTX^DGPMDAL1(.RETURN,.PM1)
 S IFN1=+RETURN
 ;Add PTF
 S PTF(.01)=DFN,PTF(2)=PARAM("DATE")
 S PTF(11)=1,PTF(6)=0,PTF(77)=0
 S PTF(20.1)=$S($G(PARAM("ELIGIB")):PARAM("ELIGIB"),1:0) ; eligibility
 S PTF(20)=PARAM("ADMSRC")
 D ADDPTF^DGPMDAL1(.RPTF,.PTF)
 D UPDPTF^DGPMDAL1(.RPTF,.PTF,+RPTF)
 K PM1
 S PM1(.06)=PARAM("WARD")  ; ward
 D UPDMVT^DGPMDAL1(.RETURN,.PM1,IFN1)
 S PM1(.02)=1  ; transaction
 S PM1(.16)=+RPTF
 S PM1(.03)=DFN  ; patient
 D UPDMVT^DGPMDAL1(.RETURN,.PM1,IFN1)
 S PM1(.04)=PARAM("TYPE")  ; type of movement
 S PM1(.06)=PARAM("WARD")  ; ward
 S PM1(.07)=PARAM("ROOMBED")  ; roombed
 S PM1(.1)=PARAM("SHDIAG")  ; short diagnosis
 S PM1(.11)=PARAM("ADMSCC")  ; admitted for sc condition
 S PM1(.12)=PARAM("ADMREG")  ; admitting regulation
 S PM1(.25)=$S(+$G(PARAM("SCADM"))>0:1,1:0)  ; scheduled admission
 S PM1(41)=PARAM("FDEXC")  ; facility directory exclusion
 S PM1(42)=$$NOW^XLFDT()  ; facility directory time stamp
 S PM1(43)=DUZ  ; facility directory user
 S PM1(54)=0
 S PM1(100)=DUZ,PM1(101)=$$NOW^XLFDT()
 S PM1(102)=DUZ,PM1(103)=$$NOW^XLFDT()
 D UPDMVT^DGPMDAL1(.RETURN,.PM1,IFN1)
 K PM1
 S PM1(.14)=IFN1  ; admission checkin movement
 D UPDMVT^DGPMDAL1(.RETURN,.PM1,IFN1)
 I +$G(PARAM("SCADM"))>0 D 
 . N SCADM S SCADM(17)=IFN1
 . D UPDSCADM^DGPMDAL1(,.SCADM,+$G(PARAM("SCADM")))
 S PARAM("ADMIFN")=IFN1,PARAM("RELIFN")=IFN1
 D ADDFTST(.RETURN,.PARAM)
 D UPDPAT(,.PARAM,DFN)
 D SETAEVT^DGPMDAL1(IFN1,+RETURN,"A")
 D MVTEVT(DFN,1,IFN1)
 S RETURN=IFN1
 D ULOCKMVT^DGPMDAL1(DFN)
 Q 1
 ;
UPDPAT(RETURN,PARAM,DFN) ; Update patient
 N PAT
 S PAT(.103)=PARAM("FTSPEC")
 S PAT(.104)=$G(PARAM("PRYMPHY"))
 S PAT(.1041)=PARAM("ATNDPHY")
 S PAT(401.3)=$G(PARAM("SERILL"))
 S PAT(401.4)=$P($$NOW^XLFDT(),".")
 D RESET^DGPMDDCN
 D UPDPAT^DGPMDAL1(,.PAT,DFN)
 Q 1
 ;
CANDEL(RETURN,AFN) ; 
 N APMV,I,TXT
 S RETURN=1
 D LSTAPMV^DGPMDAL1(.APMV,AFN,".15")
 F I=0:0 S I=$O(APMV(I)) Q:I=""!'RETURN  D
 . I APMV(I,.15,"I")]"" S RETURN=0 D ERRX^DGPMAPIE(.RETURN,"CANDASIH") Q
 Q:'RETURN 0
 D GETMVT^DGPMDAL1(.MVT,AFN,".16;.17;.21")
 I MVT(.21,"I"),MVT(.17,"I") S RETURN=0 D ERRX^DGPMAPIE(.RETURN,"CANMDDF") Q 0
 S %=$$ISPTFCEN^DGPMDAL1(MVT(.16,"I"))
 I % S RETURN=0,TXT(1)=% D ERRX^DGPMAPIE(.RETURN,"CANDWPTF",.TXT) Q 0
 Q 1
 ;
DELADM(RETURN,AFN) ; Delete admission
 N ADM,I,MVTS
 S RETURN=0
 S %=$$CANDEL^DGPMAPI1(.RETURN,AFN) Q:'RETURN 0
 D GETMVT^DGPMDAL1(.ADM,AFN,".03;.15;.16;.17;.21")
 D SETDLEVT^DGPMDAL1(AFN)
 D LSTCA^DGPMDAL1(.MVTS,AFN)
 S IN=0
 F  S IN=$O(MVTS(IN)) Q:IN=""  D
 . D:IN'=AFN DELMVT^DGPMDAL1(IN)
 D DELPTF^DGPMDAL1(ADM(.16,"I"))
 D DELMVT^DGPMDAL1(AFN)
 D MVTEVT(ADM(.03,"I"),1,AFN)
 S RETURN=1
 Q 1
 ;
UPDADM(RETURN,PARAM,AFN) ; Update admission
 N MVT,OLD,DFN,RPHY S RETURN=0
 S %=$$GETADM^DGPMAPI8(.OLD,AFN)
 S %=$$CHKADM(.RETURN,.PARAM)
 S DFN=$P(OLD("PATIENT"),U)
 Q:%=0 0
 S %=$$LOCKMVT^DGPMDAL1(DFN)
 I %=0 S RETURN=0 D ERRX^DGPMAPIE(.RETURN,"FILELOCK") Q 0
 S RPHY=$$GETRPHY^DGPMDAL1(AFN)
 D SETAEVT^DGPMDAL1(AFN,RPHY,"P")
 S MVT(41)=PARAM("FDEXC")
 S MVT(.12)=PARAM("ADMREG")
 S MVT(.11)=PARAM("ADMSCC")
 S MVT(.04)=PARAM("TYPE")
 S MVT(.1)=PARAM("SHDIAG")
 S MVT(.06)=PARAM("WARD")
 S MVT(.07)=PARAM("ROOMBED")
 D UPDMVT^DGPMDAL1(.RETURN,.MVT,AFN)
 S %=$$UPDFTS(.RETURN,.PARAM,RPHY)
 S %=$$UPDPTF(.RETURN,.PARAM,$P(OLD("PTF"),U))
 S %=$$UPDPAT(.RETURN,.PARAM,DFN)
 D SETAEVT^DGPMDAL1(AFN,RPHY,"A")
 D MVTEVT(DFN,1,AFN)
 D ULOCKMVT^DGPMDAL1(DFN)
 S RETURN=1
 Q 1
 ;
UPDPTF(RETURN,ADM,PFN) ; Update ptf
 N PTF
 S PTF(20.1)=$S($G(PARAM("ELIGIB")):PARAM("ELIGIB"),1:0) ; eligibility
 S PTF(20)=PARAM("ADMSRC")
 D UPDPTF^DGPMDAL1(,.PTF,PFN)
 Q 1
 ;
UPDFTS(RETURN,PARAM,MFN) ; Update facility treating specialty
 N MVT,DIAG
 S MVT(.08)=PARAM("PRYMPHY")  ; primary physician
 S MVT(.09)=PARAM("FTSPEC")   ; facility treating specialty
 S MVT(.19)=PARAM("ATNDPHY")  ; attending physician
 D UPDMVT^DGPMDAL1(.RETURN,.MVT,MFN)
 M DIAG=PARAM("DIAG")
 D UPDDIAG^DGPMDAL1(.RETURN,.DIAG,MFN)
 Q 1
 ;
CHKADM(RETURN,PARAM) ; Check admit parameters
 N TXT,TMP S RETURN=0 ; patient
 I $G(PARAM("PATIENT"))="" S TXT(1)="PARAM('PATIENT')" D ERRX^DGPMAPIE(.RETURN,"INVPARM",.TXT) Q 0
 D GETPAT^DGPMDAL2(.TMP,$G(PARAM("PATIENT")))
 I TMP=0 S TXT(1)="PARAM('PATIENT')" D ERRX^DGPMAPIE(.RETURN,"INVPARM",.TXT) Q 0
 K TMP ; admission date
 I $G(PARAM("DATE"))=""!(+$G(PARAM("DATE"))<1800000) S TXT(1)="PARAM('DATE')" D ERRX^DGPMAPIE(.RETURN,"INVPARM",.TXT) Q 0
 K TMP ; facility directory exclusion
 I +$G(PARAM("FDEXC"))'=0&(+$G(PARAM("FDEXC"))'=1) S TXT(1)="PARAM('FDEXC')" D ERRX^DGPMAPIE(.RETURN,"INVPARM",.TXT) Q 0
 K TMP ; admission regulation
 I $G(PARAM("ADMREG"))="" S TXT(1)="PARAM('ADMREG')" D ERRX^DGPMAPIE(.RETURN,"INVPARM",.TXT) Q 0
 D GETAREG^DGPMDAL2(.TMP,$G(PARAM("ADMREG")))
 I TMP=0 S TXT(1)="PARAM('ADMREG')" D ERRX^DGPMAPIE(.RETURN,"INVPARM",.TXT) Q 0
 I $G(TMP(4,"I"))=1 S TXT(1)="PARAM('ADMREG')" D ERRX^DGPMAPIE(.RETURN,"INVPARM",.TXT) Q 0
 K TMP ; type of movement
 I $G(PARAM("TYPE"))="" S TXT(1)="PARAM('TYPE')" D ERRX^DGPMAPIE(.RETURN,"INVPARM",.TXT) Q 0
 D GETADMMT^DGPMDAL2(.TMP,$G(PARAM("TYPE")))
 I TMP=0 S TXT(1)="PARAM('TYPE')" D ERRX^DGPMAPIE(.RETURN,"INVPARM",.TXT) Q 0
 I $G(TMP(.02,"I"))'=1 S TXT(1)="PARAM('TYPE')" D ERRX^DGPMAPIE(.RETURN,"INVPARM",.TXT) Q 0
 K TMP ; short diagnosis
 I $L($G(PARAM("SHDIAG")))<3!($L($G(PARAM("SHDIAG")))>30) S TXT(1)="PARAM('SHDIAG')" D ERRX^DGPMAPIE(.RETURN,"INVPARM",.TXT) Q 0
 K TMP ; ward
 I $G(PARAM("WARD"))="" S TXT(1)="PARAM('WARD')" D ERRX^DGPMAPIE(.RETURN,"INVPARM",.TXT) Q 0
 D GETWARD^DGPMDAL2(.TMP,$G(PARAM("WARD")),".01;400;200*")
 I TMP=0 S TXT(1)="PARAM('WARD')" D ERRX^DGPMAPIE(.RETURN,"INVPARM",.TXT) Q 0
 I TMP=1,TMP(400,"I")="" S TXT(1)="PARAM('WARD')" D ERRX^DGPMAPIE(.RETURN,"INVPARM",.TXT) Q 0
 I TMP=1,$D(TMP("OOS")),'$$ISWRDACT^DGPMAPI7(.TMP,PARAM("DATE")) S TXT(1)="PARAM('WARD')" D ERRX^DGPMAPIE(.RETURN,"WRDINACT",.TXT) Q 0
 N ERR K TMP S ERR=0 ; roombed
 I $G(PARAM("ROOMBED"))'="" D  Q:ERR 0
 . D GETBED^DGPMDAL2(.TMP,$G(PARAM("ROOMBED")),".01;.2;100*;200*")
 . I TMP=0 S ERR=1,TXT(1)="PARAM('ROOMBED')" D ERRX^DGPMAPIE(.RETURN,"INVPARM",.TXT)
 . I '$D(TMP("W",PARAM("WARD"))) S ERR=1,TXT(1)="PARAM('ROOMBED')" D ERRX^DGPMAPIE(.RETURN,"INVPARM",.TXT)
 . I $D(TMP("OOS")),'$$ISBEDACT^DGPMAPI7(.TMP,PARAM("DATE")) S ERR=1,TXT(1)="PARAM('ROOMBED')" D ERRX^DGPMAPIE(.RETURN,"BEDINACT",.TXT)
 . I $$ISBEDOCC^DGPMAPI7(PARAM("ROOMBED"),PARAM("PATIENT")) S ERR=1,TXT(1)="PARAM('ROOMBED')" D ERRX^DGPMAPIE(.RETURN,"INVPARM",.TXT)
 K TMP ; facility treating specialty
 I $G(PARAM("FTSPEC"))="" S TXT(1)="PARAM('FTSPEC')" D ERRX^DGPMAPIE(.RETURN,"INVPARM",.TXT) Q 0
 D GETFTS^DGPMDAL2(.TMP,$G(PARAM("FTSPEC")),".01;100*")
 I TMP=0 S TXT(1)="PARAM('FTSPEC')" D ERRX^DGPMAPIE(.RETURN,"INVPARM",.TXT) Q 0
 I $D(TMP("E")),'$$ISFTSACT^DGPMAPI7(.TMP,PARAM("DATE")) S TXT(1)="PARAM('ADMREG')" D ERRX^DGPMAPIE(.RETURN,"INVPARM",.TXT) Q 0
 K TMP ;attender
 I $G(PARAM("ATNDPHY"))="" S TXT(1)="PARAM('ATNDPHY')" D ERRX^DGPMAPIE(.RETURN,"INVPARM",.TXT) Q 0
 I '$$SCREEN^DGPMDD($G(PARAM("ATNDPHY")),,+$G(PARAM("DATE"))) D  Q 0
 . S TXT(1)="PARAM(""ATNDPHY"")" D ERRX^DGPMAPIE(.RETURN,"INVPARM",.TXT)
 K TMP S ERR=0 ; source of admission
 I $G(PARAM("ADMSRC"))'="" D  Q:ERR 0
 . D GETADMS^DGPMDAL2(.TMP,$G(PARAM("ADMSRC")))
 . I TMP=0 S ERR=1,TXT(1)="PARAM('ADMSRC')" D ERRX^DGPMAPIE(.RETURN,"INVPARM",.TXT)
 S ERR=0 ; primary physician
 I $G(PARAM("PRYMPHY"))'="" D  Q:ERR 0
 . I '$$SCREEN^DGPMDD($G(PARAM("PRYMPHY")),,+$G(PARAM("DATE"))) D  Q
 . . S ERR=1,TXT(1)="PARAM(""PRYMPHY"")" D ERRX^DGPMAPIE(.RETURN,"INVPARM",.TXT)
 S RETURN=1
 Q 1
 ;
ADDFTST(RETURN,PARAM) ; Add ralated physical movement
 N PM6,IFN6,DIAG
 S PM6(.01)=PARAM("DATE") ; admission date
 D ADDMVMTX^DGPMDAL1(.RETURN,.PM6)
 S IFN6=+RETURN
 S PM6(.02)=6  ; transaction
 D UPDMVT^DGPMDAL1(.RETURN,.PM6,IFN6)
 S PM6(.03)=PARAM("PATIENT")  ; patient
 S PM6(.14)=PARAM("ADMIFN")  ; admission checkin movement
 S PM6(.24)=PARAM("RELIFN")  ; related physical movement
 S PM6(100)=DUZ,PM6(101)=$$NOW^XLFDT()
 S PM6(102)=DUZ,PM6(103)=$$NOW^XLFDT()
 D UPDMVT^DGPMDAL1(.RETURN,.PM6,IFN6)
 K PM6
 S PM6(.04)=42
 S PM6(.08)=PARAM("PRYMPHY")  ; primary physician
 S PM6(.09)=PARAM("FTSPEC")  ; facility treating specialty
 S PM6(.18)=20  ; mas movement type
 S PM6(.19)=PARAM("ATNDPHY")  ; attending physician
 D UPDMVT^DGPMDAL1(.RETURN,.PM6,IFN6)
 S:'$D(PARAM("DIAG")) DIAG(1)=PARAM("SHDIAG")
 M:$D(PARAM("DIAG")) DIAG=PARAM("DIAG")
 D UPDDIAG^DGPMDAL1(.RETURN,.DIAG,IFN6)
 S RETURN=IFN6
 Q
 ;
MVTEVT(DFN,TYPE,MFN) ; Movement events
 N DGPMDA,DGPMA,DGPMP,DGPMT,DGQUIET,DGNEW,DGPM0
 D START^DGPWB(DFN)
 D EN^DGPMVBM
 S DGPM0=""
 S DGPMA=$$GETMVT0^DGPMDAL1(MFN)
 S DGPMDA=MFN,DGPMP="",DGPMT=TYPE,DGQUIET=1
 S:TYPE=1 DGNEW=1
 D ^DGPMEVT
 Q
 ;
