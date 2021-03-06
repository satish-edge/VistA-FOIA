LEXQID ;ISL/KER - Query - ICD Diagnosis - Extract ;01/03/2011
 ;;2.0;LEXICON UTILITY;**62,73**;Sep 23, 1996;Build 10
 ;               
 ; Global Variables
 ;    ^ICD9(              ICR   4485
 ;    ^TMP("LEXQID")      SACC 2.3.2.5.1
 ;    ^TMP("LEXQIDA")     SACC 2.3.2.5.1
 ;    ^TMP("LEXQIDO")     SACC 2.3.2.5.1
 ;               
 ; External References
 ;    GETS^DIQ            ICR   2056
 ;    HIST^ICDAPIU        ICR   3991
 ;    $$ICDDX^ICDCODE     ICR   3990
 ;    $$DT^XLFDT          ICR  10103
 ;               
EN ; Main Entry Point
 N LEXENV S LEXENV=$$EV^LEXQM Q:+LEXENV'>0
 N LEXAD,LEXEDT,LEXCDT,LEXEXIT,LEXTEST S LEXEXIT=0,LEXCDT="" K ^TMP("LEXQID",$J),^TMP("LEXQIDO",$J),^TMP("LEXQIDA",$J)
 F  S LEXCDT=$$AD^LEXQM,LEXAD=LEXCDT Q:'$L(LEXCDT)  Q:+($G(LEXEXIT))>0  S LEXEDT=$P(LEXCDT,"^",1),LEXCDT=$P(LEXCDT,"^",2) Q:LEXCDT'?7N  D LOOK Q:LEXCDT'?7N  Q:+LEXEXIT>0
 K ^TMP("LEXQID",$J),^TMP("LEXQIDO",$J),^TMP("LEXQIDA",$J)
 Q
LOOK ; ICD Lookup Loop
 N LEXGET,LEXST,LEXSD,LEXLD,LEXMD,LEXLX,LEXWN,LEXCC,LEXMC,LEXICD,LEXICDC S LEXCDT=$G(LEXCDT),LEXEDT=$$ED^LEXQM(LEXCDT) I LEXCDT'?7N S LEXCDT="" Q
 S LEXLEN=62 F  S LEXICD=$$ICD^LEXQIDA S:LEXICD="^^" LEXEXIT=1 Q:+($G(LEXEXIT))>0  Q:LEXICD="^"!(LEXICD="^^")  D  Q:LEXICD="^"!(LEXICD="^^")
 . K LEXGET,LEXST,LEXSD,LEXLD,LEXMD,LEXLX,LEXWN,LEXCC,LEXMC,^TMP("LEXQID",$J) N LEXIEN,LEXLDT,LEXELDT,LEXINC,LEXINOT,LEXIREQ,LEXINCC
 . S LEXIEN=+($G(LEXICD)),LEXLDT=+($G(LEXCDT)) Q:+LEXIEN'>0  Q:LEXLDT'?7N  S LEXELDT=$$SD^LEXQM(LEXLDT) Q:'$L(LEXELDT)
 . S LEXINOT=$$NOT^LEXQIDA(+($G(LEXIEN))) S:LEXINOT["^^" LEXEXIT=1 Q:LEXINOT["^"
 . S LEXIREQ=$$REQ^LEXQIDA(+($G(LEXIEN))) S:LEXIREQ["^^" LEXEXIT=1 Q:LEXIREQ["^"
 . S LEXINCC=$$NCC^LEXQIDA(+($G(LEXIEN))) S:LEXINCC["^^" LEXEXIT=1 Q:LEXINCC["^"
 . D CSV,EN^LEXQID4
 Q
CSV ; Code Set Versioning Display
 N LEXEDT,LEXIEN,LEXIENS,LEXLTXT,LEXSO,LEXSTAT,LEXNAM
 S LEXCDT=$G(LEXCDT),LEXEDT=$$ED^LEXQM(LEXCDT) I LEXCDT'?7N S (LEXICD,LEXCDT)="" Q
 S LEXIEN=+($G(LEXICD)),LEXSO=$P($G(LEXICD),"^",2),LEXLTXT=$P($G(LEXICD),"^",3) Q:+LEXIEN'>0  Q:'$L(LEXSO)
 S LEXNAM=$P($$ICDDX^ICDCODE(LEXSO,LEXCDT),"^",4) I '$L(LEXNAM) D
 . S LEXNAM=$O(^ICD9(+LEXIEN,67,"B"," "),-1)
 . S LEXNAM=$O(^ICD9(+LEXIEN,67,"B",+LEXNAM," "),-1)
 . S LEXNAM=$P($G(^ICD9(+LEXIEN,67,+LEXNAM,0)),"^",2)
 Q:'$L($G(LEXNAM))
 ;
 ; Get the "Unversioned" Fields
 ; 
 ;   ICD Code             Field .01
 ;   Age Low              Field 14
 ;   Age High             Field 15
 ;   Sex                  Field 9.5
 ;   Unacc as Princ. DX   Field 101
 S LEXIENS=LEXIEN_"," D GETS^DIQ(80,LEXIENS,".01;9.5;14;15;101","IE","LEXGET","LEXMSG")
 S LEXGET(80,(+LEXIEN_","),"B")=$G(LEXNAM)
 ;            
 ; Get the "Versioned" Fields
 ;            
 ;   Date/Status          80.066  (66)
 S LEXST=$$EF(+($G(LEXIEN)),+LEXCDT),LEXSTAT=+($P(LEXST,"^",2))
 ;   Diagnosis Name       80.067  (67)
 D SDS(+($G(LEXIEN)),+LEXCDT,.LEXSD,62,LEXSTAT)
 ;   Description          80.068  (68)
 D LDS^LEXQID2(+($G(LEXIEN)),+LEXCDT,.LEXLD,62,LEXSTAT)
 ;   Lexicon Expression          
 D LX^LEXQID2(+($G(LEXIEN)),+LEXCDT,.LEXLX,62,LEXSTAT)
 ;   Warning Message
 D WN^LEXQID2(+LEXCDT,.LEXWN,62)
 ;   DRG Groups           80.071  (71)
 D DRG^LEXQID3(+LEXIEN,+LEXCDT,LEXLEN)
 ;   CC                   80.0103 (103)
 D CC^LEXQID3(+($G(LEXIEN)),+LEXCDT,.LEXCC)
 ;   MDC                  80.072  (72)
 D MDC^LEXQID2(+($G(LEXIEN)),LEXCDT,.LEXMC)
 ;            
 ; Get the "Asked for" Fields
 ;            
 ;   Codes not to use     80.01   (20) 
 D:+($G(LEXINOT))>0 NOT^LEXQID3(+LEXIEN,+LEXCDT,LEXLEN)
 ;   Codes required with  80.02   (30) 
 D:+($G(LEXIREQ))>0 REQ^LEXQID3(+LEXIEN,+LEXCDT,LEXLEN)
 ;   Codes not CC with    80.03   (40)
 D:+($G(LEXINCC))>0 NCC^LEXQID3(+LEXIEN,+LEXCDT,LEXLEN)
 Q
 ; 
EF(X,LEXCDT) ; Effective Dates
 N LEX,LEXAD,LEXBRD,LEXBRW,LEXEE,LEXEF,LEXES,LEXFA,LEXH,LEXI,LEXID,LEXIEN,LEXLS,LEXSO,LEXST S LEXIEN=+($G(X)),LEXCDT=+($G(LEXCDT))
 Q:+LEXIEN'>0 "^^"  Q:'$L(^ICD9(+LEXIEN,0)) "^^"  Q:LEXCDT'?7N "^^"  S LEXSO=$P($G(^ICD9(+LEXIEN,0)),"^",1)
 S LEX=$$ICDDX^ICDCODE(LEXSO,LEXCDT) S LEXFA=$$FA(+LEXIEN),(LEXLS,LEXST)=$P(LEX,"^",10),LEXID=$P(LEX,"^",12),LEXBRD=2781001,LEXBRW=""
 S:LEXCDT<LEXBRD&(+LEXFA=LEXBRD) LEXBRW="Warning:  The 'Based on Date' provided precedes the initial Code Set Business Rule date of "_$$SD^LEXQM(LEXBRD)_", the Effective date may be inaccurate."
 S LEXAD=$P(LEX,"^",17),LEXES=$S(+LEXST>0:"Active",1:"Inactive")
 S:+LEXST'>0&(+LEXAD'>0) LEXES="Not Applicable",LEXLS=-1 S:LEXST>0 LEXEF=LEXAD S:LEXST'>0 LEXEF=LEXID
 S:LEXST'>0&(+LEXID'>0) LEXEF=LEXFA S LEXEE=$$SD^LEXQM(LEXEF)
 I LEXST'>0,+LEXID'>0,$L(LEXEE),+LEXEF>LEXCDT S LEXEE="(future activation of "_LEXEE_")",LEXEF=""
 S X=LEXLS_"^"_LEXST_"^"_LEXEF_"^"_LEXES_"^"_LEXEE S:$L(LEXBRW) $P(X,"^",6)=LEXBRW
 Q X
 ; 
SDS(X,LEXVDT,LEX,LEXLEN,LEXSTA) ; Diagnosis (short description)
 ; 
 ; LEX=# of Lines
 ; LEX(0)=External Date of Diagnosis Name
 ; LEX(#)=Diagnosis Name
 ; 
 N LEXD,LEXBRD,LEXBRW,LEXDDT,LEXE,LEXEE,LEXEFF,LEXFA,LEXHIS,LEXI,LEXIA,LEXIEN,LEXL,LEXLAST,LEXLEF,LEXLHI,LEXM,LEXR,LEXSDT,LEXSO,LEXLSD,LEXT
 S LEXIEN=$G(X) Q:+LEXIEN'>0  Q:'$D(^ICD9(+LEXIEN,67))  S LEXVDT=+($G(LEXVDT)) S:LEXVDT'?7N LEXVDT=$$DT^XLFDT S LEXSTA=+($G(LEXSTA))
 S LEXSO=$P($G(^ICD9(+LEXIEN,0)),"^",1),LEXLAST=$$ICDDX^ICDCODE(LEXSO),LEXLSD=$P(LEXLAST,"^",4),LEXBRD=2781001,LEXBRW=""
 S:$D(LEXGET)&($L(LEXLSD)) LEXGET(80,(+LEXIEN_","),"B")=LEXLSD
 S LEXLEN=+($G(LEXLEN)) S:+LEXLEN'>0 LEXLEN=62 S LEXFA=$$FA(+LEXIEN),LEXM=""
 S LEXM="" S:+LEXVDT<LEXFA&(LEXFA'=LEXBRD) LEXM="Diagnosis Short Name is not available.  The date provided precedes the initial activation of the code" I $L(LEXM) D  Q
 . K LEX N LEXT,LEXI S LEXT(1)=LEXM D PR^LEXQM(.LEXT,(LEXLEN-7))
 . S LEXI=0 F  S LEXI=$O(LEXT(LEXI)) Q:+LEXI'>0  S LEXT=$G(LEXT(LEXI)) S LEX(LEXI)=LEXT
 . S:$D(LEX(1)) LEX(0)="--/--/----" S LEX=+($O(LEX(" "),-1))
 S LEXM="" S LEXEFF=$O(^ICD9(LEXIEN,67,"B",(LEXVDT+.001)),-1),LEXHIS=$O(^ICD9(LEXIEN,67,"B",+LEXEFF," "),-1),LEXSDT=$P($G(^ICD9(+LEXIEN,67,+LEXHIS,0)),"^",2)
 S LEXLEF=$O(^ICD9(LEXIEN,67,"B",(9999999+.001)),-1),LEXLHI=$O(^ICD9(LEXIEN,67,"B",+LEXLEF," "),-1),LEXDDT=$P($G(^ICD9(+LEXIEN,67,+LEXLHI,0)),"^",2)
 S (LEXD,LEXE,LEXR)="" S:$L(LEXSDT)&(LEXEFF?7N) LEXD=LEXSDT,LEXE=LEXEFF
 S:$L(LEXDDT)&(LEXLEF?7N)&('$L(LEXD))&('$L(LEXE)) LEXD=LEXDDT,LEXE=LEXLEF,LEXR="No Text Available for Date Provided"
 K LEX S LEX(1)=LEXD S:$L(LEXD) LEXGET(80,(+LEXIEN_","),"B")=LEXD
 S LEXEE=$$SD^LEXQM(LEXE) S:$D(LEXTEST)&(+LEXSTA'>0) LEXEE="--/--/----" S:$L(LEX(1)) LEX(0)=LEXEE
 S LEX=+($O(LEX(" "),-1))
 Q
 ; Miscellaneous
FA(X) ;   First Activation
 N LEXFA,LEXH,LEXI,LEXIEN,LEXSO
 S LEXIEN=+($G(X)) S X="",LEXSO=$P($G(^ICD9(+LEXIEN,0)),"^",1) D HIST^ICDAPIU(LEXSO,.LEXH) S LEXFA="",LEXI=0
 F  S LEXI=$O(LEXH(LEXI)) Q:+LEXI'>0!($L(LEXFA))  S:+($G(LEXH(LEXI)))>0&(LEXI?7N) LEXFA=LEXI Q:$L(LEXFA)
 S X=LEXFA
 Q X
IA(X) ;   Inaccurate
 N LEXBRD,LEXVDT,LEXSYS S LEXVDT=+($G(X)),LEXSYS=1,LEXVDT=$S($G(LEXVDT)="":$$DT^XLFDT,1:$$DBR(LEXVDT)),LEXBRD=3021001,X=$S(LEXVDT<LEXBRD:1,1:0)
 Q X
DBR(X) ;   Date Business Rules
 N LEXVDT S LEXVDT=$G(X) Q:'$G(LEXVDT)!($P(LEXVDT,".")'?7N) $$DT^XLFDT
 S:LEXVDT#10000=0 LEXVDT=LEXVDT+101 S:LEXVDT#100=0 LEXVDT=LEXVDT+1 S X=$S(LEXVDT<2781001:2781001,1:LEXVDT)
 Q X
