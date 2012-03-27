GMPLDALF ; / DATA ACCESS LAYER - FILEMAN CALLS ;02/27/12  12:00
 ;;TBD;Problem List;;02/27/2012
CREATE(GMPFLD,ERT) ; Create new problem
 N GMPUPD,X,GMPIEN
 S GMPFLD(.07)=$$NEXTNMBR^GMPLSAVE(2,2956)
 s X=$P(GMPFLD(.05),U,2),GMPFLD(.05)=$P($$PROVNARR^GMPLX(X,+GMPFLD(1.01)),U)
 M GMPUPD(9000011,"+1,")=GMPFLD
 D UPDATE^DIE("","GMPUPD","GMPIEN","ERT")
 Q +$G(GMPIEN(1))
 ;
DETAIL(GMPIFN,GMPFLD,ERT) ; Return problem details
 ;                
 ; Input   GMPIFN  Pointer to Problem file #9000011
 ;                
 ; Output  GMPFLD Array, passed by reference
 ;
 N GMPBUF,FILE,I
 S PROBLEM=9000011
 D GETS^DIQ(PROBLEM,GMPIFN,".01:.03;.05;.06;.08;.12;.13;1.01:1.18","IE","GMPBUF","ERT")
 Q:'$D(GMPBUF(PROBLEM,GMPIFN_",")) 0
 S I=""
 F  S I=$O(GMPBUF(PROBLEM,GMPIFN_",",I)) Q:I=""  D
 . S GMPFLD(I)=GMPBUF(PROBLEM,GMPIFN_",",I,"I")_U_GMPBUF(PROBLEM,GMPIFN_",",I,"E")
 Q 1
 ;
VERIFIED(GMPIFN) ; True if problem already verified
 Q $$GET1^DIQ(9000011,2,"1.02","I")'="T"
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
