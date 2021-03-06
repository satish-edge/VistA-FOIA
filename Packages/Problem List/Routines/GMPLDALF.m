GMPLDALF ; RGI -- DATA ACCESS LAYER - FILEMAN CALLS ; 03/27/12
 ;;2.0;Problem List;**260002**;Aug 25, 1994
DETAIL(GMPIFN,GMPFLD,ERT) ; Return problem details
 ;                
 ; Input   GMPIFN  Pointer to Problem file #9000011
 ;                
 ; Output  GMPFLD Array, passed by reference
 ;
 N GMPBUF,FILE,I,PROBLEM
 S PROBLEM=9000011
 D GETS^DIQ(PROBLEM,GMPIFN,".01:.03;.05;.06:.08;.12;.13;1.01:1.18","IE","GMPBUF","ERT")
 Q:'$D(GMPBUF(PROBLEM,GMPIFN_",")) 0
 S I=""
 F  S I=$O(GMPBUF(PROBLEM,GMPIFN_",",I)) Q:I=""  D
 . S GMPFLD(I)=GMPBUF(PROBLEM,GMPIFN_",",I,"I")_U_GMPBUF(PROBLEM,GMPIFN_",",I,"E")
 Q 1
 ;
VERIFIED(GMPIFN) ; True if problem already verified
 Q $$GET1^DIQ(9000011,2,"1.02","I")'="T"
 ;
MKPERM(GMPIFN) ; Make a problem PERMANENT
 D CHGCOND(GMPIFN,"T","P")
 Q
 ;
CHGCOND(GMPIFN,OLD,NEW,GMPROV) ; Change condition flag
 N AUDMSG,FDA
 S GMPROV=$G(GMPROV,DUZ)
 S FDA(9000011,GMPIFN_",",1.02)=NEW
 D FILE^DIE("","FDA")
 S AUDMSG=""
 S:(NEW="H") AUDMSG="Deleted"
 S:(OLD="T")&(NEW="P") AUDMSG="Verified"
 S:(OLD="H")&(NEW="P") AUDMSG="Replaced"
 D AUDIT^GMPLDAL(GMPIFN,OLD,NEW,AUDMSG,+GMPROV)
 D DTMOD^GMPLDAL(GMPIFN)
 Q
 ;
LOCK(GMPIFN,SUB,ERT) ;
 S SUB=+$G(SUB)
 L +^AUPNPROB(GMPIFN,SUB):1
 I '$T D ERR^GMPLAPIE(ERT,"FILELOCK") Q 0
 Q 1
 ;
UNLOCK(GMPIFN,SUB) ;
 L -^AUPNPROB(GMPIFN,SUB)
 Q
 ;
