SDM ;SF/GFT,ALB/BOK - MAKE AN APPOINTMENT ; 09/24/2012
 ;;5.3;Scheduling;**15,32,38,41,44,79,94,167,168,218,223,250,254,296,380,478,441,260003**;AUG 13, 1993;Build 14
 ;                                           If defined...
 ; appt mgt vars:  SDFN := DFN of patient....will not be asked
 ;                SDCLN := ifn of clinic.....will not be asked    
 ;              SDAMERR := returned if error occurs
 ; 
 S:'$D(SDMM) SDMM=0
EN1 ;
 N ERR,PAT
 L  W !! D I^SDUTL
 N Y S Y=$G(SDCLN)
 I '$D(SDCLN) S Y=$$SELCLN^SDMUTL()
 S:+Y>0!($D(SDCLN)) %=$$GETCLN^SDMAPI1(.CLN,+Y) G:+Y=0!'$D(CLN("LENGTH OF APP'T")) END
 N SDRES S:$D(SDCLN) Y=+SDCLN S SDRES=$$CLNCK^SDMAPI1(.ERR,+Y)
 I 'SDRES W !,?5,$P(ERR(0),U,2),!,?5,"Clinic MUST be corrected before continuing." G END:$D(SDCLN),SDM
 K SDAPTYP,SDIN,SDRE,SDXXX S:$D(SDCLN) Y=+SDCLN
 S TMPYCLNC=Y,STPCOD=CLN("STOP CODE NUMBER") ;SD/478
 I $D(CLN("INACTIVATE DATE")) S SDIN=CLN("INACTIVATE DATE"),SDRE=CLN("REACTIVATE DATE")
 K SDINA I $D(SDIN),SDIN S SDINA=SDIN K SDIN
 I $D(SD),$D(SC),+Y'=+SC K SD
 S X=CLN("HOUR CLINIC DISPLAY BEGINS"),STARTDAY=$S($L(X):X,1:8)
 S SL=CLN("LENGTH OF APP'T")
 S SC=Y,SB=STARTDAY-1/100
 S X=CLN("DISPLAY INCREMENTS PER HOUR"),HSI=$S(X=1:X,X:X,1:4),SI=$S(X="":4,X<3:4,X:X,1:4)
 S STR="#@!$* XXWVUTSRQPONMLKJIHGFEDCBA0123456789jklmnopqrstuvwxyz",SDDIF=$S(HSI<3:8/HSI,1:2) K Y
 K ERR S %=$$CLNRGHT^SDMAPI1(.ERR,+SC) I ERR=0 W !,*7,$P(ERR(0),U,2) S:$D(SDCLN) SDAMERR="" G END:$D(SDCLN),SDM
 D CS^SDM1A S SDW="",WY="Y"
 I '$D(ORACTION),'$D(SDFN) S Y=$$SELPAT^SDMUTL() S:+Y=0 X="" S DFN=+Y G:+Y=0 END:$D(SDCLN),^SDM0:X[U,SDM
 S:$D(SDFN) DFN=SDFN
 S %=$$GETPAT^SDMAPI3(.PAT,DFN,1)
 I $D(PAT("DATE OF DEATH")),PAT("DATE OF DEATH")]"" W !?10,*7,"PATIENT HAS DIED." S:$D(SDFN) SDAMERR="" G END:$D(SDFN),SDM
 D ^SDM4 I $S('$D(COLLAT):1,COLLAT=7:1,1:0) G:$D(SDCLN) END G SDM
 ;-- get sub-category for appointment type
 S SDXSCAT=$$SUB^DGSAUTL(SDAPTYP,2,"")
 K SDXXX D EN G END:$D(SDCLN),SDM
EN K SDMLT1 W:$P(VAEL(9),U,2)]"" !!,?15,"MEANS TEST STATUS: ",$P(VAEL(9),U,2),!
 ; *** sck, mt blocking removed
 ;S X="EASMTCHK" X ^%ZOSF("TEST") I $T,$$MT^EASMTCHK(DFN,+$G(SDAPTYP),"M") S SDAMERR="" Q
 I PAT("REMARKS")]"" W !?3,*7,$P(PAT("REMARKS"),U,2)
 I $D(^DGS(41.1,"B",DFN)) F I=0:0 S I=$O(^DGS(41.1,"B",DFN,I)) Q:I'>0  I $P(^DGS(41.1,I,0),U,2)'<DT&('$P(^DGS(41.1,I,0),U,13)) W !,"SCHEDULED FOR ADMISSION ON " S Y=$P(^(0),U,2) D DT^SDM0
PEND S %=""
 N PEND
 S %=$$GETPEND^SDMAPI1(.PEND,DFN,DT) W:PEND=0 !,"NO PENDING APPOINTMENTS"
 I PEND D  G END:%<0,HELP:'%
 .S %=1 W !,"DISPLAY PENDING APPOINTMENTS:"
 .D YN^DICN
 .I %Y["^" S SDMLT1=1
 D:%=1
 .N DX,DY,SDXY,SDEND S SDXY="S DX=$X,DY=0"_$S($L($G(^%ZOSF("XY"))):" "_^("XY"),1:"") X SDXY
 .S CN=1
 . F Y=DT:0 S Y=$O(PEND(Y)) Q:Y'>0  D
 . . X:(($Y+4)>IOSL) "D OUT^SDUTL X SDXY"
 . . W:$X>9 ! W CN,".",?4 D DT^SDM0 W ?23
 . . W "("_PEND(Y,"LENGTH OF APP'T")_" MIN) "
 . . W $S($D(PEND(Y,"CLINIC")):PEND(Y,"CLINIC"),1:"DELETED CLINIC ")
 . . W PEND(Y,"COLLATERAL VISIT"),"  ",PEND(Y,"APPOINTMENT TYPE")
 . . W:$G(PEND(Y,"CONSULT LINK"))>0 " Consult Appt."
 . . S CN=CN+1
 ;Prompt for ETHNICITY if no value on file
 I '$O(PAT("ETHNICITY INFORMATION","")) D
 . N ROU,PRMPT,FILE,FIELDS,FLDOR
 . S ROU="LSTETNS^SDMLST",PRMPT="Select ETHNICITY: "
 . S FILE="ETHNICITY",FIELDS=""
 . S ETN=$$SELECT^SDMUTL(ROU,PRMPT,FILE,FIELDS)
 . I +ETN>0 S %=$$SETETN^SDMAPI3(DFN,ETN)
 ;Prompt for RACE if no value on file
 I '$O(PAT("RACE INFORMATION","")) D
 . D RACE
 I $S('$D(PAT("STREET ADDRESS [LINE 1]")):1,PAT("STREET ADDRESS [LINE 1]")="":1,1:0) N FLG S FLG(1)=1 D EN^DGREGAED(DFN,.FLG)
 Q:$D(SDXXX)
E S Y=CLN("PRINCIPAL CLINIC")
 S SDW="" I $D(^DPT(DFN,.1)) S SDW=^(.1) W !,"NOTE - PATIENT IS NOW IN WARD "_SDW
 Q:$D(SDXXX)
EN2 F X=0:0 S X=$O(^DPT(DFN,"DE",X)) Q:'$D(^(+X,0))  I ^(0)-SC=0!'(^(0)-Y) F XX=0:0 S XX=$O(^DPT(DFN,"DE",X,1,XX)) Q:XX<1  S SDDIS=$P(^(XX,0),U,3) I 'SDDIS D:'$D(SDMULT) A^SDCNSLT G ^SDM0
 I '$D(^SC(+Y,0)) S Y=+SC
 S Y=$P(^SC(+Y,0),U)
 ; SCRESTA = Array of pt's teams causing restricted consults
 N SCRESTA
 S SCREST=$$RESTPT^SCAPMCU4(DFN,DT,"SCRESTA")
 IF SCREST D
 .N SCTM
 . S SCCLNM=Y
 . W !,?5,"Patient has restricted consults due to team assignment(s):"
 .S SCTM=0
 .F  S SCTM=$O(SCRESTA(SCTM)) Q:'SCTM  W !,?10,SCRESTA(SCTM)
 IF SCREST&'$G(SCOKCONS) D  Q
 .W !,?5,"This patient may only be given appointments and enrolled in clinics via"
 .W !,?15,"Make Consult Appointment Option, and"
 .W !,?15,"Edit Clinic Enrollment Data option"
 D:$G(SCREST) MAIL^SCMCCON(DFN,.SCCLNM,2,DT,"SCRESTA")
 K DR,SCREST,SCCLNM
 D:'$D(SDMULT) ^SDCNSLT ;SD/478
 G ^SDM0
 ;
END D KVAR^VADPT K SDAPTYP,SDSC,%,%DT,ASKC,COV,DA,DIC,DIE,DP,DR,HEY,HSI,HY,J,SB,SC,SDDIF,SDJ,SDLN,SD17,SDMAX,SDU,SDYC,SI,SL,SSC,STARTDAY,STR
 K WY,X,XX,Y,S,SD,SDAP16,SDEDT,SDTY,SM,SS,ST,ARG,CCX,CCXN,HX,I,PXR,SDINA,SDW,COLLAT,SDDIS I $D(SDMM) K:'SDMM SDMM
 K A,CC,CLNIEN,CN,CNIEN,CNPAT,CNSLTLNK,CNSULT,CNT,CONS,CPRSTAT,CW,DSH,DTENTR,DTIN,DTLMT,DTR,ND,P8,PROC,PT,PTIEN,PTNM,RTMP,NOSHOW,SCPTTM,SD1,SDAMSCN,SDATE,SDDOT,SDII,SDINC,SDINCM,SDLEN,SDNS,SDSI,SDST,SDSTR,SDSTRTDT
 K SDXSCAT,SENDER,SERVICE,SRV,STATUS,STPCOD,TMP,TMPYCLNC,TYPE
 I '$D(SDMLT) K SDMLT1
 Q
 ;
OERR S XQORQUIT=1 Q:'$D(ORVP)  S DFN=+ORVP G SDM
 ;
HELP W !,"YES - TO DISPLAY FUTURE APPOINTMENTS",!,"NO - FUTURE APPOINTMENTS NOT DISPLAYED" G PEND
 ;
CNAM(SDCL) ;Return clinic name
 ;Input: SDCL=clinic ien
 N SDX
 S SDX=CLN("NAME")
 Q $S($L(SDX):SDX,1:"this clinic")
RACE ; Set race
 N ROU,PRMPT,FILE,FIELDS,FLDOR,ROU1
 S ROU="LSTRACES^SDMLST",PRMPT="Select RACE: "
 S FILE="RACE",FIELDS="",ROU1="GETPRES^SDMLST"
 S HLP1(0)="HLP1^SDM",HLP2(0)="HLP2^SDM"
 D SETRACE
 Q
SETRACE ;
 S ETN=$$SELECT^SDMUTL(ROU,PRMPT,FILE,FIELDS,,.HLP1,.HLP2,ROU1)
 I +ETN>0  D
 . N RES
 . S %=$$GETPRES^SDMAPI3(.RES,DFN)
 . S ADD=$$ASKADD($P(ETN,U,2),+RES(0))
 . S:ADD %=$$SETRACE^SDMAPI3(DFN,ETN)
 . D SETRACE
 Q
HLP1 ;
 W !?4,"You may enter a new RACE INFORMATION, if you wish"
 W !?4,"Select from the available listing all races which best identify this"
 W !?4,"patient"
 W !?4,"Inactive values are not selectable",!
 Q
 ;
HLP2 ;
 W !?4,"You may enter a new RACE INFORMATION, if you wish"
 W !?4,"Patient's race",!!
 Q
 ;
ASKADD(NEWEL,RESCNT) ; Ask
 N DIR,X,Y
 S RESCNT=RESCNT+1_$S(RESCNT=0:"st",1:"nd")
 S DIR("A")=" Are you adding '"_NEWEL_"' as a new RACE INFORMATION (the "_RESCNT_" for this PATIENT"
 S DIR(0)="YO",DIR("B")="No"
 D ^DIR Q Y
 ;
