GMPLMGR1 ; SLC/MKB -- Problem List VALM Utilities cont ;09/14/12
 ;;2.0;Problem List;**10,260002**;Aug 25, 1994
NEWPAT ; select new patient
 N NEWPT S VALMBCK="R"
 I GMPARAM("PRT"),$D(GMPRINT) D AUTO^GMPLMGR2 I $D(DTOUT) S VALMBCK="Q" Q
 W ! D FULL^VALM1
 S NEWPT=$S($D(ORVP)&(+$$VERSION^XPDUTL("OR")<3):$$OEPAT,1:$$PAT^GMPLX1)
 I (+NEWPT>0),(+NEWPT'=+GMPDFN) D
 . S GMPDFN=NEWPT,VALMBG=1
 . S (GMPSC,GMPAGTOR,GMPION,GMPGULF)=0 D:GMPVA VADPT^GMPLX1(+GMPDFN)
 . D GETPLIST(.GMPLIST,.GMPTOTAL,.GMPLVIEW) K GMPRINT
 . D BUILD^GMPLMGR(.GMPLIST),HDR^GMPLMGR
 S VALMSG=$$MSG^GMPLX
 Q
 ;
OEPAT() ; Calls OE/RR to return new patient, or -1
 N DFN,VADM,Y
 D IN^OR I +ORVP'>0 Q -1
 I +ORVP=+GMPDFN Q GMPDFN
 S DFN=+ORVP D DEM^VADPT
 S Y=DFN_U_VADM(1)_U_$E(VADM(1))_VA("BID")
 I VADM(6) S Y=Y_U_+VADM(6) ; date of death
 Q Y
 ;
INACTIVE ; Incl inactive problems
 N ACTIVE
 S VALMBCK=$S(VALMCC:"",1:"R")
 I GMPLVIEW("ACT")="" D  Q
 . W !!,"Listing already includes inactive problems!" H 1
 S %=$$HASPRBS^GMPLAPI4(.ACTIVE,+GMPDFN,"I")
 I 'ACTIVE D  Q
 . W !!,"Patient has no inactive problems to include.",! H 1
 S GMPLVIEW("ACT")="",VALMBCK="R",VALMSG=$$MSG^GMPLX
 D GETPLIST(.GMPLIST,.GMPTOTAL,.GMPLVIEW),BUILD^GMPLMGR(.GMPLIST),HDR^GMPLMGR
 Q
 ;
NEWSRV ; select new service
 N DIC,NEWVIEW,VIEW,PROMPT,HELPMSG Q:$D(GMPQUIT)
 S DIC="^DIC(49,",DIC("S")="I $P(^(0),U,9)=""C"""
 S VIEW="service(s)",PROMPT="Select SERVICE: ",HELPMSG="LISTSERV"
 D NEW Q:$D(GMPQUIT)
 I NEWVIEW'=$E(GMPLVIEW("VIEW"),2,99) S GMPLVIEW("VIEW")="S"_NEWVIEW,GMPREBLD=1
 Q
 ;
NEWCLIN ; Select new clinic
 N DIC,NEWVIEW,VIEW,PROMPT,HELPMSG Q:$D(GMPQUIT)
 S DIC="^SC(",DIC("S")="I $P(^(0),U,3)=""C"""
 S VIEW="clinic(s)",PROMPT="Select CLINIC: ",HELPMSG="LISTCLIN"
 D NEW Q:$D(GMPQUIT)
 I NEWVIEW'=$E(GMPLVIEW("VIEW"),2,99) S GMPLVIEW("VIEW")="C"_NEWVIEW,GMPREBLD=1
 Q
 ;
NEW ; prompt, from NEWSRV or NEWCLIN
 N X,Y S NEWVIEW="",DIC(0)="EMQ"
 W !!,"Enter the "_VIEW_" from which you wish to view problems:"
 F  D  Q:$D(GMPQUIT)!(X="")
 . W !,PROMPT R X:DTIME I '$T!(X["^") S GMPQUIT=1 Q
 . Q:X=""  I X="?" W !!?3,"Enter the "_VIEW_", one at a time, from which you wish to view",!?3,"problems; press <return> when you have finished.",! Q
 . I X["??" D @HELPMSG Q
 . D ^DIC I Y>0 S NEWVIEW=NEWVIEW_+Y_"/",PROMPT="ANOTHER ONE: "
 I '$D(GMPQUIT),$L(NEWVIEW) S NEWVIEW="/"_NEWVIEW
 Q
 ;
LISTSERV ; List clinical services
 N I,CNT,Y S CNT=0,Y=""
 W !,"Choose from: "
 F I=0:0 S I=$O(^DIC(49,"F","C",I)) Q:I'>0  D  Q:Y'=""
 . S CNT=CNT+1 I '(CNT#8) D  Q:Y="^"
 . . W "      ... more, or ^ to stop: " R Y:DTIME S:'$T Y="^"
 . W !,"   "_$P(^DIC(49,I,0),U)
 . W:$P(^(0),U,4) "  ("_$P(^DIC(49,$P(^(0),U,4),0),U)_")"
 W ! Q
 ;
LISTCLIN ; List clinics
 N I,CNT,Y S CNT=0,Y=""
 W !,"Choose from: "
 F I=0:0 S I=$O(^SC(I)) Q:I'>0  D  Q:Y'=""
 . Q:$P($G(^SC(I,0)),U,3)'="C"  ; must be a clinic
 . S CNT=CNT+1 I '(CNT#8) D  Q:Y="^"
 . . W "      ... more, or ^ to stop: " R Y:DTIME S:'$T Y="^"
 . W !,"   "_$P($G(^SC(I,0)),U)
 W ! Q
 ;
NEWPROV ; select new provider
 N X,Y,DIC,NEWPROV Q:$D(GMPQUIT)  S NEWPROV=""
 S DIC="^VA(200,",DIC(0)="EMQ" ; screen on PROVIDER key ??
 W !!,"Enter the name of the provider whose problems you wish to view:"
NPRV R !,"Select PROVIDER: ",X:DTIME I '$T!(X["^") S GMPQUIT=1 Q
 Q:X=""  I X="?" D  G NPRV
 . W !!?3,"If you wish to see only those problems of the current patient that"
 . W !?3,"are associated with a specific provider, enter his/her name here.",!
 I X["??" D NPHELP^GMPLEDT2 G NPRV
 D ^DIC S:+Y NEWPROV=Y I +Y'>0 G NPRV
 I +NEWPROV'=+GMPLVIEW("PROV") S GMPLVIEW("PROV")=NEWPROV,GMPREBLD=1
 Q
 ;
KEYS ; adds to XQORM("KEY") array
 I $G(GMPARAM("VER")) S XQORM("KEY","$")=$$PROTKEY^GMPLEXT("GMPL VERIFY")_"^1"
KEY S XQORM("KEY","=")=$$PROTKEY^GMPLEXT("VALM NEXT SCREEN")_"^1"
 Q
 ;
GETPLIST(PLIST,TOTAL,VIEW) ; Build PLIST(#)=IFN for view
 N STBEG,STEND,ST,CNT,IFN,RECORD,DATE,LIST K PLIST
 W:'$G(GMPARAM("QUIET")) !,"Searching for the patient's problem list ..."
 S %=$$GETPLIST^GMPLAPI4(.PLIST,GMPDFN,VIEW("ACT"),GMPARAM("REV"),VIEW("PROV"),VIEW("VIEW"),1)
 S TOTAL=PLIST
 Q
