GMPLDAL2 ; RGI/VSL -- DATA ACCESS LAYER - DIRECT GLOBALS ACCESS ; 05/23/12
 ;;2.0;Problem List;**260002**;Aug 25, 1994
GETADATA(RETURN,AIFN) ; Get the audit entry details
 N AUD0,AUD1
 S AUD0=$G(^GMPL(125.8,AIFN,0))
 Q:'AUD0 0
 S RETURN(0)=""
 S RETURN(0,.01)=$P(AUD0,U,1)
 S RETURN(0,1)=$P(AUD0,U,2)
 S RETURN(0,2)=$P(AUD0,U,3)
 S RETURN(0,3)=$P(AUD0,U,4)
 I RETURN(0,1)="1.01" D
 . S RETURN(0,4)=$P(AUD0,U,5,6)
 . S RETURN(0,5)=$P(AUD0,U,7,8)
 . S RETURN(0,6)=$P(AUD0,U,9)
 . S RETURN(0,7)=$P(AUD0,U,10)
 E  D
 . S RETURN(0,4)=$P(AUD0,U,5)
 . S RETURN(0,5)=$P(AUD0,U,6)
 . S RETURN(0,6)=$P(AUD0,U,7)
 . S RETURN(0,7)=$P(AUD0,U,8)
 S RETURN(1)=$G(^GMPL(125.8,AIFN,1))
 S AUD1=$G(^GMPL(125.8,AIFN,1))
 S RETURN(1)=""
 S RETURN(1,.01)=$P(AUD1,U,1)
 S RETURN(1,.03)=$P(AUD1,U,3)
 S RETURN(1,.04)=$P(AUD1,U,4)
 S RETURN(1,.05)=$P(AUD1,U,5)
 S RETURN(1,.06)=$P(AUD1,U,6)
 Q 1
 ;
AUDITX(RETURN,GMPIFN,FIELD,VALUE) ; Returns all audit data of the problem
 N IDT,AIFN,X0,X1,FLD,CNT
 S CNT=0,RETURN=CNT
 F IDT=0:0 S IDT=$O(^GMPL(125.8,"AD",GMPIFN,IDT)) Q:IDT'>0  D
 . F AIFN=0:0 S AIFN=$O(^GMPL(125.8,"AD",GMPIFN,IDT,AIFN)) Q:AIFN'>0  D
 .. S X0=$G(^GMPL(125.8,AIFN,0)),X1=$G(^(1)) Q:'$L(X0)
 .. I $G(FIELD),$P(X0,U,2)'=FIELD Q
 .. I $G(FIELD),$G(VALUE),$P(X0,U,6)'=VALUE Q
 .. S CNT=CNT+1
 .. S RETURN(CNT,1)=$P(X0,U,2)
 .. S RETURN(CNT,2)=$P(X0,U,3)
 .. S RETURN(CNT,3)=$P(X0,U,4)
 .. S RETURN(CNT,4)=$P(X0,U,5)
 .. S RETURN(CNT,5)=$P(X0,U,6)
 .. S RETURN(CNT,6)=$P(X0,U,7)
 .. S RETURN(CNT,7)=$P(X0,U,8)
 .. S:$L(X1) RETURN(CNT,1101)=X1,RETURN(CNT,4)=$P(X1,U,3)
 S RETURN=CNT
 Q
 ;
GETAUDIT(RETURN,GMPIFN,FIELD,VALUE) ; Returns all audit data of the problem
 N IDT,AIFN,X0,X1,FLD,CNT
 S CNT=0,RETURN=CNT
 F IDT=0:0 S IDT=$O(^GMPL(125.8,"AD",GMPIFN,IDT)) Q:IDT'>0  D
 . F AIFN=0:0 S AIFN=$O(^GMPL(125.8,"AD",GMPIFN,IDT,AIFN)) Q:AIFN'>0  D
 .. S X0=$G(^GMPL(125.8,AIFN,0)),X1=$G(^(1)) Q:'$L(X0)
 .. I $G(FIELD),$P(X0,U,2)'=FIELD Q
 .. I $G(FIELD),$G(VALUE),$P(X0,U,6)'=VALUE Q
 .. S CNT=CNT+1
 .. S RETURN(CNT,0)=$P(X0,U,2,8)
 .. S:$L(X1) RETURN(CNT,1)=X1
 S RETURN=CNT
 Q
 ;
GETHIST(RETURN,GMPIFN) ; Returns all audit entries of the problem
 ; RETURN - By reference, problem history
 ;  RETURN(I)=Audit IFN
 ; GMIFN - Problem IFN
 N IDT,AIFN,LCNT
 S LCNT=0
 I '$D(^GMPL(125.8,"B",GMPIFN)) Q  ;BAIL OUT - NO CHANGES
 S IDT=""
 F  S IDT=$O(^GMPL(125.8,"AD",GMPIFN,IDT)) Q:IDT'>0  D
 . S AIFN=""
 . F  S AIFN=$O(^GMPL(125.8,"AD",GMPIFN,IDT,AIFN)) Q:AIFN'>0  D
 .. S LCNT=LCNT+1
 .. S RETURN(LCNT)=AIFN
 Q
 ;
