GMPLEDT2 ; SLC/MKB/KER -- Problem List edit actions ; 03/28/12
 ;;2.0;Problem List;**26,35,260002**;Aug 25, 1994
 ;
 ; External References
 ;   DBIA 10060  ^VA(200
 ;   DBIA 10003  ^%DT
 ;   DBIA 10006  ^DIC
 ;   DBIA 10026  ^DIR
 ;   DBIA 10103  $$HTFM^XLFDT
 ;   DBIA 10104  $$UP^XLFSTR
 ;                   
EDITED() ; Returns 1 if problem has been altered
 N FLD,NOTE,DIFFRENT S DIFFRENT=0
 F FLD=0:0 S FLD=$O(GMPORIG(FLD)) Q:(FLD'>0)!(FLD'<10)  I GMPORIG(FLD)'=GMPFLD(FLD) S DIFFRENT=1 Q
 G:DIFFRENT EDQ
 I $D(GMPFLD(10,"NEW"))>9 S DIFFRENT=1 G EDQ
 F NOTE=0:0 S NOTE=$O(GMPORIG(10,NOTE)) Q:NOTE'>0  I $P(GMPORIG(10,NOTE),U,3)'=$P(GMPFLD(10,NOTE),U,3) S DIFFRENT=1 Q
EDQ Q DIFFRENT
 ;
SUREDEL(NUM) ; -- sure you want to delete problems?
 N DIR,X,Y,MSG
 D:NUM=1 BLD^DIALOG(1250000.236,,,"MSG")
 D:NUM'=1 BLD^DIALOG(1250000.237,NUM,,"MSG")
 D EN^DDIOL(.MSG)
 S DIR(0)="YA",DIR("B")="NO"
 D BLD^DIALOG(1250000.238,,,"DIR(""A"")")
 D BLD^DIALOG($S(NUM=1:1250000.239,1:250000.240),,,"DIR(""?"")")
 D EN^DDIOL($C(7),,"?0")
 D ^DIR
 Q +Y
 ;
DELETE ; Remove current problem from patient's list
 N DELETED,MSG
 S VALMBCK=$S(VALMCC:"",1:"R")
 Q:'$$SUREDEL(1)
 S %=$$DELETE^GMPLAPI2(.DELETED,GMPIFN,+$G(GMPROV))
 I 'DELETED W $$ERRTXT^GMPLAPIE(DELETED) H 2 Q
 S GMPSAVED=1
 S VALMBCK="Q"
 D BLD^DIALOG(1250000.241,,,"MSG")
 D EN^DDIOL(.MSG)
 H 1
 Q
 ;
VERIFY ; Mark current problem as verified
 N MSG
 I GMPFLD(1.02)'="T" D  H 1 Q
 . D BLD^DIALOG(1250000.242,,,"MSG")
 . D EN^DDIOL($C(7))
 . D EN^DDIOL(.MSG)
 S GMPFLD(1.02)="P" D EN^DDIOL(".")
 D EN^DDIOL($$EZBLD^DIALOG(1250000.243),,"?0") H 1
 Q
 ;
NPERSON ; look up into #200, given PROMPT,HELPMSG,DEFAULT (returns X, Y)
 N DIC
NP N DIR
 S DIR(0)="FA"
 S DIR("A")=PROMPT_$S(+DEFAULT:$P(DEFAULT,U,2)_"//",1:"")
 D ^DIR
 I $D(DTOUT)!(X="^") S GMPQUIT=1 Q
 I X?1"^".E D JUMP^GMPLEDT3(X) Q:$D(GMPQUIT)!($G(GMPLJUMP))  K:$G(GMPIFN) GMPLJUMP G NP
 I X="" S Y=DEFAULT Q
 I X="@" G:'$$SURE^GMPLX NP S Y="" Q
 I X="?" W !!,HELPMSG,! G NP
 I X["??" D NPHELP G NP
 S DIC="^VA(200,",DIC(0)="EMQ" D ^DIC
 I Y'>0 D  G NP
 . D EN^DDIOL(HELPMSG,,"!!")
 . D EN^DDIOL($C(7))
 Q
 ;
NPHELP ; List names in New Person file
 N NM,CNT,I,Y,DIR,X S CNT=0,(NM,Y)=""
 D EN^DDIOL($$EZBLD^DIALOG(1250000.244))
 F  S NM=$O(^VA(200,"B",NM)) Q:NM=""  D  Q:Y'=""
 . S CNT=CNT+1 I '(CNT#9) D  Q:Y="^"
 . . D BLD^DIALOG(1250000.245,,,"DIR(""A"")")
 . . S DIR(0)="EA"
 . . D ^DIR
 . . S Y=X
 . . S:$D(DTOUT) Y="^"
 . S I=$O(^VA(200,"B",NM,0)) D EN^DDIOL("   "_$P($G(^VA(200,I,0)),U))
 D EN^DDIOL("")
 Q
 ;
DATE ; Edit date fields given PROMPT,HELPMSG,DEFAULT (ret'ns X,Y)
 N %DT,DIR,MSG S %DT="EP"
D1 ;
 K DIR
 S DIR(0)="DA"
 S DIR("A")=PROMPT_$S(+DEFAULT:$P(DEFAULT,U,2)_"//",1:"")
 D ^DIR
 I $D(DTOUT)!(X="^") S GMPQUIT=1 Q
 I X?1"^".E D JUMP^GMPLEDT3(X) Q:$D(GMPQUIT)!($G(GMPLJUMP))  K:$G(GMPIFN) GMPLJUMP G D1
 I X="" S Y=DEFAULT Q
 I X="@" G:'$$SURE^GMPLX D1 S Y="" Q
 I X="?" W !!,HELPMSG,! G D1
 I X["??" D DTHELP G D1
 D ^%DT I Y<1 D  G D1
 . D EN^DDIOL($$EZBLD^DIALOG(1250000.246))
 . D DTHELP
 . D EN^DDIOL(HELPMSG)
 I Y>DT D  G D1
 . D BLD^DIALOG(1250000.247,,,"MSG")
 . D EN^DDIOL(.MSG)
 . D EN^DDIOL($C(7))
 Q
 ;
DTHELP ; Date help
 N MSG
 D BLD^DIALOG(1250000.248,,,"MSG")
 D EN^DDIOL(.MSG)
 Q
 ;
SPEXP ; Edit Fields 1.11, 1.12, 1.13, 1.15, 1.16, 1.17, 1.18
 D:GMPAGTOR SP(1.11,1250000.249) Q:$D(GMPQUIT)!($G(GMPLJUMP))
 S:$G(GMPFLD(1.11)) $P(GMPFLD(1.11),U,2)="AGENT ORANGE"
 D:GMPION SP(1.12,1250000.250) Q:$D(GMPQUIT)!($G(GMPLJUMP))
 S:$G(GMPFLD(1.12)) $P(GMPFLD(1.12),U,2)="RADIATION"
 D:GMPGULF SP(1.13,1250000.251) Q:$D(GMPQUIT)!($G(GMPLJUMP))
 S:$G(GMPFLD(1.13)) $P(GMPFLD(1.13),U,2)="ENV CONTAMINANTS"
 D:GMPHNC SP(1.15,1250000.252) Q:$D(GMPQUIT)!($G(GMPLJUMP))
 S:$G(GMPFLD(1.15)) $P(GMPFLD(1.15),U,2)="HEAD/NECK CANCER"
 D:GMPMST SP(1.16,1250000.253) Q:$D(GMPQUIT)!($G(GMPLJUMP))
 S:$G(GMPFLD(1.16)) $P(GMPFLD(1.16),U,2)="MIL SEXUAL TRAUMA"
 D:GMPCV SP(1.17,1250000.254) Q:$D(GMPQUIT)!($G(GMPLJUMP))
 S:$G(GMPFLD(1.17)) $P(GMPFLD(1.17),U,2)="COMBAT VET"
 D:GMPSHD SP(1.18,1250000.255) Q:$D(GMPQUIT)!($G(GMPLJUMP))
 S:$G(GMPFLD(1.18)) $P(GMPFLD(1.18),U,2)="SHAD"
 Q
SP(FLD,NAME) ; edit exposure fields -- Requires FLD number & field NAME
 N DIR,X,Y,GMPLN S DIR(0)="YAO" ;,GMPLN=$$UP^XLFSTR(NAME)
 D BLD^DIALOG(NAME,,,"DIR(""A"")")
 D BLD^DIALOG(NAME+.007,,,"DIR(""?"")")
 S:$L($G(GMPFLD(FLD))) DIR("B")=$S(+GMPFLD(FLD):"YES",1:"NO")
SP1 D ^DIR I $D(DTOUT)!(Y="^") S GMPQUIT=1 Q
 I Y?1"^".E D JUMP^GMPLEDT3(Y) Q:$D(GMPQUIT)!($G(GMPLJUMP))  K:$G(GMPIFN) GMPLJUMP G SP1
 I X="@" G:'$$SURE^GMPLX SP1 S Y=""
 S GMPFLD(FLD)=Y S:Y'="" GMPFLD(FLD)=GMPFLD(FLD)_U_$S(Y:"YES",1:"NO")
 Q
