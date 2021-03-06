YSGAF3 ;ASF/ALB- GAF CASE FINDER ;10/30/98  13:50
 ;;5.01;MENTAL HEALTH;**48,49**;Dec 30, 1994
MAIN ;
 K ^TMP("YSGF",$J),^TMP("YSGFM",$J)
 W @IOF,!?10,"Global Assessment of Functioning Case finder",!
 D DTRANGE Q:YSGFBDT=""!(YSGFEDT="")
 W !
 D SORT Q:Y="^"!(Y="")
 S YSGFSRT=$S(Y=2:1,1:0)    ; 0 for PATIENT sort, 1 for PROVIDER sort
 W !!,"Results returned via Mailman. Please queue this report for after hours."
QUEUE ;
 K IOP,ZTIO,ZTSAVE
 S ZTIO="",ZTSAVE("YSGF*")="",ZTRTN="ENQ^YSGAF3",ZTDESC="GAF Case Finder" D ^%ZTLOAD W:$D(ZTSK) !!,"Your Task Number is "_ZTSK D ^%ZISC
 K ^TMP("YSGF",$J),^TMP("YSGFM",$J)
 K G,G1,P,VA,X,X1,X2,XMSUB,XMTEXT,XTMP,XMY,Y,YSDA,YSGAFDL,YSGFBDT,YSGFCNT
 K YSGFCNT2,YSGFDNIT,YSGFEDT,YSGFI,YSGFITE,YSGFMCNT,YSGFMTC,YSGFN
 K YSGFNM,YSGFS,YSIN,YSLOC,YSOEDT,YSOEFN,YSPTFGAF,YSSCFN,YSSCN,YSTOT
 K YSPRV,YSDTA,YSPARSE,YSGFSRT,YSX2
 Q
ENQ ;queue entry
 S:$D(ZTQUEUED) ZTREQ="@"
 S YSGFN=0
 D OE
 D HEAD,PTLST,BOT
 D MAIL2 ; output
 Q
DTRANGE ;date range
 W ! S (YSGFBDT,YSGFEDT)="",%DT("A")="Beginning Date for GAF Case Finder Date Range: ",%DT="AEX" D ^%DT
 Q:Y'>0
 S YSGFBDT=+Y_".000001"
 W ! S %DT("A")="Ending Date for GAF Case Finder Date Range: " D ^%DT
 Q:Y'>0
 S YSGFEDT=+Y_".595959"
 I (YSGFEDT>0)&(YSGFEDT<YSGFBDT) W !,?7,"Ending Date must be closer to today than Beginning Date",! H 2 W $C(7) G DTRANGE
 Q
SORT ; Choose sort
 S DIR(0)="SA^1:PATIENT;2:PROVIDER",DIR("B")=1,DIR("T")=60
 S DIR("A")="Sort by (1) PATIENT or (2) PROVIDER? "
 D ^DIR
 Q
OE ;loop thru OUTPATIENT ENCOUNTER file
 S YSOEDT=YSGFBDT-.0001
 F  S YSOEDT=$O(^SCE("B",YSOEDT)) Q:(YSOEDT>(YSGFEDT+.9))!(YSOEDT'>0)  S YSOEFN=0 F  S YSOEFN=$O(^SCE("B",YSOEDT,YSOEFN)) Q:YSOEFN'>0  D
 . S G=^SCE(YSOEFN,0) ;outpatient encounter information
 . S DFN=$P(G,U,2) Q:DFN'>0
 . S YSSCFN=$P(G,U,3) Q:YSSCFN'>0
 . S YSSCN=$P($G(^DIC(40.7,YSSCFN,0)),U,2) ;AMIS reporting stop code
 . I (YSSCN>499)&(YSSCN<600)&(YSSCN'=526)&(YSSCN'=527)&(YSSCN'=528)&(YSSCN'=542)&(YSSCN'=545)&(YSSCN'=546) D
 .. D GETPRV
 .. S:YSPRV="" YSPRV=" "
 .. S:'YSGFSRT SORT1=$P(^DPT(DFN,0),U),SORT2=YSPRV
 .. S:YSGFSRT SORT1=YSPRV,SORT2=$P(^DPT(DFN,0),U)
 .. S XTMP=$P(G,U)_U_$P(G,U,4)_U_YSOEFN
 .. S ^TMP("YSGF",$J,SORT1,SORT2,DFN)=XTMP
 Q
HEAD ;header
 K ^TMP("YSGFM",$J)
 S YSGFS="",$P(YSGFS," ",75)=""
 S YSGFN=0
 S YSGFITE=$$SITE
 S YSGFN=YSGFN+1,^TMP("YSGFM",$J,YSGFN)=$E(YSGFS,1,15)_"GAF Case Finder"
 S Y=YSGFBDT\1 X ^DD("DD") S YSGFN=YSGFN+1,^TMP("YSGFM",$J,YSGFN)="Begining Date: "_Y
 S Y=YSGFEDT\1 X ^DD("DD") S YSGFN=YSGFN+1,^TMP("YSGFM",$J,YSGFN)="  Ending Date: "_Y
 S YSGFN=YSGFN+1,^TMP("YSGFM",$J,YSGFN)="     Facility: "_YSGFITE
 S YSGFN=YSGFN+1,^TMP("YSGFM",$J,YSGFN)=" "
 S YSGFN=YSGFN+1,^TMP("YSGFM",$J,YSGFN)="The following is a list of all patients who had a Mental Health Outpatient"
 S YSGFN=YSGFN+1,^TMP("YSGFM",$J,YSGFN)="Encounter between the above dates but do not have a GAF score WITHIN 90 DAYS."
 S YSGFN=YSGFN+1,^TMP("YSGFM",$J,YSGFN)="Last MH (non-telephonic) Outpatient Encounter in date range is listed."
 S YSGFN=YSGFN+1,^TMP("YSGFM",$J,YSGFN)=" "
 S YSGFN=YSGFN+1,^TMP("YSGFM",$J,YSGFN)="Name"_$E(YSGFS,1,17)_"SSN     Date                Location         Provider"
 Q
BOT ; bottom
 S YSGFN=YSGFN+1,^TMP("YSGFM",$J,YSGFN)=" "
 S YSGFN=YSGFN+1,^TMP("YSGFM",$J,YSGFN)=YSTOT_" MH patients without a GAF."
 S YSGFN=YSGFN+1,^TMP("YSGFM",$J,YSGFN)=YSGFDNIT_" MH patients had a GAF."
 S YSGFN=YSGFN+1,^TMP("YSGFM",$J,YSGFN)=" "
 Q
PTLST ;check for previous GAF and print
 S SORT1="",YSTOT=0,YSGFDNIT=0
 F  S SORT1=$O(^TMP("YSGF",$J,SORT1)) Q:SORT1=""  D
 .S SORT2="" F  S SORT2=$O(^TMP("YSGF",$J,SORT1,SORT2)) Q:SORT2=""  D
 ..S DFN=0 F  S DFN=$O(^TMP("YSGF",$J,SORT1,SORT2,DFN)) Q:DFN'>0  D
 ... S G=^TMP("YSGF",$J,SORT1,SORT2,DFN)
 ... S:'YSGFSRT YSGFNM=SORT1,YSPRV=SORT2
 ... S:YSGFSRT YSGFNM=SORT2,YSPRV=SORT1
 ... S YSOEFN=$P(G,U,3)
 ... D GAFCK ;check if GAF done OUTPATIENT
 ... I YSGFI=1 S YSGFDNIT=YSGFDNIT+1 Q  ;out if done
 ... D PTFCK ;check inpatient GAF
 ... I YSGFI=1 S YSGFDNIT=YSGFDNIT+1 Q  ;out if done
 ... S YSTOT=YSTOT+1
 ... D DEM^VADPT S YSGFN=YSGFN+1
 ... S ^TMP("YSGFM",$J,YSGFN)=$E(YSGFNM_YSGFS,1,20)_" "_$E(VA("BID")_"  ",1,6)_" "
 ... K YSDTA,YSPARSE
 ... D GETGEN^SDOE(YSOEFN,"YSDTA")
 ... D PARSE^SDOE(.YSDTA,"EXTERNAL","YSPARSE")
 ... S XTMP=" "_$E(YSPARSE(.01),1,18)_"  "_$E(YSPARSE(.04)_YSGFS,1,15)
 ... S ^TMP("YSGFM",$J,YSGFN)=^TMP("YSGFM",$J,YSGFN)_XTMP
 ... D GETPRV
 ... S ^TMP("YSGFM",$J,YSGFN)=^TMP("YSGFM",$J,YSGFN)_"  "_$E(YSPRV,1,10)
 Q
GETPRV ;Get provider info
 K YSDTA
 D GETPRV^SDOE(YSOEFN,"YSDTA")
 S YSPRV=$O(YSDTA(-1))
 I $L(YSPRV) D
 .S YSPRV=$P(YSDTA(YSPRV),U)
 .S YSPRV=$$EXTERNAL^DILFD(9000010.06,.01,"",YSPRV)
 Q
GAFCK ;check gaf already done 0=NONE 1=DONE
 S YSGFI=0
 Q:'$D(^YSD(627.8,"AX5",DFN))
 S YSGAFDL=$O(^YSD(627.8,"AX5",DFN,0)) Q:YSGAFDL'>0
 S X1=9999999-YSGAFDL
 S X2=$P(G,U)
 D ^%DTC
 S:X<91 YSGFI=1
 Q
PTFCK ;
 S YSGFI=0,YSX2=$P(G,U)
 Q:'$D(^DGPT("B",DFN))
 S YSIN=0 F  S YSIN=$O(^DGPT("B",DFN,YSIN)) Q:YSIN'>0!(YSGFI=1)  D
 . S YSPTFGAF=$P($G(^DGPT(YSIN,300)),U,6) ; current functional assessment
 . Q:YSPTFGAF'?1N.N
 . S X1=$P($G(^DGPT(YSIN,70)),U) ; discharge date
 . Q:X1'?7N.E
 . S X2=YSX2
 . D ^%DTC
 . S:X<91 YSGFI=1
 Q
MAIL2 ; SEND MAILMAN
 K ^TMP("YSMM",$J)
 S YSGFMCNT=0,YSGFMTC=(YSGFN\1000)+1
 S YSGFCNT=0,YSGFCNT2=0 F  S YSGFCNT=$O(^TMP("YSGFM",$J,YSGFCNT)) Q:(YSGFCNT'>0)  D
 .S YSGFCNT2=YSGFCNT2+1,^TMP("YSMM",$J,YSGFCNT)=^TMP("YSGFM",$J,YSGFCNT)
 .I (YSGFCNT2=1000)!(YSGFCNT=YSGFN) D
 ..S YSGFMCNT=YSGFMCNT+1
 ..S DTIME=600
 ..S XMSUB="GAF Case Finder      ("_YSGFMCNT_" OF "_YSGFMTC_")"
 ..S XMTEXT="^TMP(""YSMM"",$J,"
 ..S XMY(DUZ)=""
 ..S XMDUZ="AUTOMATED MESSAGE"
 ..D ^XMD
 ..S YSGFCNT2=0
 ..K ^TMP("YSMM",$J)
 Q
 ;
SITE() ;SET YSGFITE EQUAL TO SITE-NAME
 N DA,DIC,DIQ,DR
 S YSDA=+$P($$SITE^VASITE,U,3)
 S DIC=4,DR=".01",DA=YSDA,DIQ(0)="EN",DIQ="YSLOC"
 D EN^DIQ1
 S YSLOC=$P(YSLOC(4,+YSDA,.01,"E"),",")
 QUIT YSLOC
