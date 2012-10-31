GMPL1 ; SLC/MKB/AJB -- Problem List actions ; 09/13/12
 ;;2.0;Problem List;**3,20,28,260002**;Aug 25, 1994
 ; 10 MAR 2000 - MA - Added to the routine another user prompt
 ; to backup and refine Lexicon search if ICD code 799.9
ADD ;add new entry to list - Requires GMPDFN
 N GMPROB,GMPTERM,GMPICD,Y,DUP,GMPIFN,GMPFLD
 W !
 S GMPROB=$$TEXT^GMPLEDT4("") I GMPROB="^" S GMPQUIT=1 Q
 I 'GMPARAM("CLU")!('$D(GMPLUSER)&('$$KCHK^XUSRB("GMPL ICD CODE"))) S GMPTERM="",GMPICD="799.9" G ADD1
 F  D  Q:$D(GMPQUIT)!(+$G(Y))
 . D SEARCH^GMPLX(.GMPROB,.Y,$$EZBLD^DIALOG(1250000.009),"1")
 . I +Y'>0 S GMPQUIT=1 Q
 . S %=$$DUPL^GMPLAPI2(.DUP,+GMPDFN,+Y,GMPROB)
 . I DUP,'$$DUPLOK^GMPLX(DUP) S (Y,GMPROB)=""
 . I +Y=1 D ICDMSG
 Q:$D(GMPQUIT)
 S GMPTERM=$S(+$G(Y)>1:Y,1:""),GMPICD=$G(Y(1))
 S:'$L(GMPICD) GMPICD="799.9"
ADD1 ; set up default values
 ; -- May enter here with GMPROB=text,GMPICD=code,GMPTERM=#^term
 ; added for Code Set Versioning (CSV)
 N OK,GMPI,GMPFLD,GMPELIG
 D ELIG(.GMPELIG)
 I '$$DEFAULT^GMPLAPI4(.GMPFLD,GMPROB,GMPICD,GMPTERM,$G(GMPROV),$G(GMPCLIN),.GMPELIG) D  H 3 Q
 . W !,GMPROB,!,$$ERRTXT^GMPLAPIE(.GMPFLD)
 K GMPLJUMP
ADD2 ; prompt for values
 D FLDS^GMPLEDT3 ; set GMPFLD("FLD") of editable fields
 F GMPI=2:1:7 D @(GMPFLD("FLD",GMPI)_"^GMPLEDT1") Q:$D(GMPQUIT)  K GMPLJUMP ; cannot ^-jump here
 Q:$D(GMPQUIT)
ADD3 ; Ok to save?
 S OK=$$ACCEPT^GMPLDIS1(.GMPFLD),GMPLJUMP=0 ; ok to save values?
 I OK="^" D  S GMPQUIT=1 H 1 Q
 . D EN^DDIOL($$EZBLD^DIALOG(1250000.01),"","!!?10")
 . D EN^DDIOL("","","!")
 I OK D  Q  ; ck DA for error?
 . N I
 . D EN^DDIOL($$EZBLD^DIALOG(1250000.011),"","!!")
 . I '$$NEW^GMPLAPI2(.GMPIFN,GMPDFN,GMPROV,.GMPFLD) W $$ERRTXT^GMPLAPIE(.GMPIFN) G ADD4
 . S I=$S(GMPLIST(0)'>0:1,GMPARAM("REV"):$O(GMPLIST(0))-.01,1:GMPLIST(0)+1)
 . S GMPLIST(I)=GMPIFN,GMPLIST("B",GMPIFN)=I,GMPLIST(0)=$G(GMPLIST(0))+1
 . S GMPSAVED=1
 . W " done."
ADD4 ; Not ok -- edit values, ask again
 F GMPI=1:1:GMPFLD("FLD",0) D @(GMPFLD("FLD",GMPI)_"^GMPLEDT1") Q:$D(GMPQUIT)!($D(GMPSAVED))  I $G(GMPLJUMP) S GMPI=GMPLJUMP-1 S GMPLJUMP=0 ; reset GMPI to desired fld
 Q:$D(DTOUT)  K GMPQUIT,DUOUT G ADD3
 Q
 ;
 ; *********************************************************************
 ; *  GMPIFN expected for the following calls:
 ;
STATUS(GMPIFN,GMPROV,GMPVAMC,GMPSAVED,ERT) ; -- inactivate problem
 N PROBTEXT,GMPFLD,PROMPT,DEFAULT,DELETED,ACTIVE,ONSET,RETURN
 S PROBTEXT=$$PROBTEXT^GMPLX(GMPIFN)
 S %=$$ACTIVE^GMPLAPI2(.ACTIVE,GMPIFN)
 I 'ACTIVE D ERR^GMPLAPIE(ERT,"PRBINACT"," ("_PROBTEXT_")") Q 0
 S %=$$DELETED^GMPLAPI2(.DELETED,GMPIFN)
 I DELETED D ERR^GMPLAPIE(ERT,"PRBDLTD"," ("_PROBTEXT_")") Q 0
 S %=$$ONSET^GMPLAPI2(.ONSET,GMPIFN)
 S GMPFLD(.13)=ONSET
 W !!,PROBTEXT
 D RESOLVED^GMPLEDT4 Q:$D(GMPQUIT) 0
 S PROMPT=$$EZBLD^DIALOG(1250000.012),DEFAULT="" D EDNOTE^GMPLEDT4 Q:$D(GMPQUIT) 0
 W !
 S %=$$INACTV^GMPLAPI2(.RETURN,GMPIFN,$G(GMPROV),Y,$G(GMPFLD(1.07)))
 D EN^DDIOL($$EZBLD^DIALOG(1250000.013),"","")
 D EN^DDIOL("","","!")
 H 1
 S GMPSAVED=1
 Q 1
 ;
NEWNOTE(RETURN,GMPIFN,GMPROV) ; -- add a new comment
 N GMPFLD,NOTES,GMPQUIT,ICDACTV
 W !!,$$PROBTEXT^GMPLX(GMPIFN)
 S %=$$CODESTS^GMPLAPI2(.ICDACTV,GMPIFN,DT)
 I 'ICDACTV D  H 2 Q 0
 . D EN^DDIOL($$EZBLD^DIALOG(1250000.014),"","!")
 . D EN^DDIOL("","","!")
 D NOTE^GMPLEDT1
 Q:$D(GMPQUIT)!($D(GMPFLD(10,"NEW"))'>9) 0
 M NOTES=GMPFLD(10,"NEW")
 Q $$NEWNOTE^GMPLAPI3(.RETURN,GMPIFN,GMPROV,.NOTES)
 ;
DELETE(RETURN,GMPIFN,GMPROV,GMPSAVED) ; -- delete a problem
 N PROMPT,DEFAULT,X,Y,SAVED,DELETED
 W !!,$$PROBTEXT^GMPLX(GMPIFN)
 S %=$$DELETED^GMPLAPI2(.DELETED,GMPIFN)
 I DELETED D ERRX^GMPLAPIE(.RETURN,"PRBDLTD") H 2 Q 0
 S PROMPT=$$EZBLD^DIALOG(1250000.015),DEFAULT=""
 D EDNOTE^GMPLEDT4 Q:$D(GMPQUIT) 0 D EN^DDIOL("","","!")
 S SAVED=$$DELETE^GMPLAPI2(.RETURN,GMPIFN,GMPROV,Y)
 D:SAVED EN^DDIOL($$EZBLD^DIALOG(1250000.016),"","")
 D EN^DDIOL("","","!") H 1
 S:SAVED GMPSAVED=1
 Q SAVED
 ;
VERIFY ; -- verify a transcribed problem, if parameter on
 N GMPERR
 D EN^DDIOL($$PROBTEXT^GMPLX(GMPIFN),"","!!")
 D EN^DDIOL("","","!")
 S GMPSAVED=$$VERIFY^GMPLAPI2(.GMPERR,GMPIFN)
 D:GMPSAVED EN^DDIOL($$EZBLD^DIALOG(1250000.017),"","")
 D:GMPSAVED EN^DDIOL("")
 D:'GMPSAVED EN^DDIOL($$ERRTXT^GMPLAPIE(.GMPERR),"","")
 Q
ICDMSG ; If Lexicon returns ICD code 799.9
 N DIR,DTOUT,DUOUT
 S DIR(0)="YAO"
 D BLD^DIALOG(1250000.018,,,"DIR(""A"")")
 S DIR("B")=$$EZBLD^DIALOG(1250000.019)
 S DIR("T")=DTIME
 D ^DIR
 I $D(DTOUT)!$D(DUOUT) S Y=0
 I +Y=0 S (GMPLY,GMPROB)=""
 Q
 ;
ELIG(RETURN) ; Returns array of eligibility status
 S:GMPSC RETURN("SC")=""
 S:GMPAGTOR RETURN("AO")=""
 S:GMPION RETURN("IR")=""
 S:GMPGULF RETURN("EC")=""
 Q
