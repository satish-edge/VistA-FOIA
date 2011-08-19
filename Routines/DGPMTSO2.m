DGPMTSO2 ;ALB/LM - TREATING SPECIALTY INPATIENT LISTING BY TS ;2-2-93
 ;;5.3;Registration;;Aug 13, 1993
 ;
START Q:'PTLTS
 S REPORT="< <  PATIENT LISTING BY TREATING SPECIALTY  > >"
 S (PAGE,TOTAL)=0
 D HEAD^DGPMTSO
 D SUBHEAD
 ;
DIV S DIV="" F DIV1=0:0 S DIV=$O(^TMP($J,"PTLTS",DIV)) Q:DIV=""  D:$Y+8>IOSL HEAD^DGPMTSO,SUBHEAD Q:END  W !?5,"DIVISION: ",$S($D(^DG(40.8,DIV,0)):$P(^(0),"^"),1:"EMPTY") D TREAT Q:END  S SUBCOUNT=^TMP($J,"PTLTS",DIV) D TOTAL Q:END
 ;
 G:END END
 D:$Y+8>IOSL HEAD^DGPMTSO,SUBHEAD Q:END
 F L=1:1:(IOM-3) W "-"
 W !!?3,"TOTAL   =  ",$J($P(TOTAL,"^",1),4),?25,"PASS = ",$J($P(TOTAL,"^",2),4),?45,"AA = ",$J($P(TOTAL,"^",3),4),?65,"UA = ",$J($P(TOTAL,"^",4),4),?85,"ASIH = ",$J($P(TOTAL,"^",5),4),?105,"PTS REMAINING   = ",$J($P(TOTAL,"^",6),4)
 S PTLTS=0
 ;
END K ADMDT,DGTS,DGTS1,DIV,DIV1,ID,IFN,L,PAGE,PTNM,PTNM1,REPORT,SUBCOUNT,TOTAL,TREAT,TREAT1,TSXFR,WARD,PTLTS,SUBNAME
 Q
 ;
TREAT S TREAT="" F TREAT1=0:0 S TREAT=$O(^TMP($J,"PTLTS",DIV,TREAT)) Q:TREAT=""  Q:END  D DGTS
 Q
 ;
DGTS S DGTS="" F DGTS1=0:0 S DGTS=$O(^TMP($J,"PTLTS",DIV,TREAT,DGTS)) Q:DGTS=""  D:$Y+8>IOSL HEAD^DGPMTSO,SUBHEAD Q:END  W !!?10,"FACILITY TREATING SPECIALTY:  ",TREAT D PTNM Q:END  S SUBCOUNT=^TMP($J,"PTLTS",DIV,TREAT,DGTS) S SUBNAME="TS" D SUB
 Q
 ;
PTNM S PTNM="" F PTNM1=0:0 S PTNM=$O(^TMP($J,"PTLTS",DIV,TREAT,DGTS,PTNM)) Q:PTNM=""  F IFN=0:0 S IFN=$O(^TMP($J,"PTLTS",DIV,TREAT,DGTS,PTNM,IFN)) Q:'IFN  D INFO Q:END
 Q
 ;
INFO S WARD=$P(^TMP($J,"PTLTS",DIV,TREAT,DGTS,PTNM,IFN),"^")
 S ADMDT=$P(^TMP($J,"PTLTS",DIV,TREAT,DGTS,PTNM,IFN),"^",2)
 S TSXFR=$P(^TMP($J,"PTLTS",DIV,TREAT,DGTS,PTNM,IFN),"^",3)
 S ABSENCE=$P(^TMP($J,"PTLTS",DIV,TREAT,DGTS,PTNM,IFN),"^",4)
 S ID=$S($D(^DPT(IFN,.36)):$P(^DPT(IFN,.36),"^",3),1:"")
 ;
 I $Y+8>IOSL D HEAD^DGPMTSO,SUBHEAD Q:END
LINE W !,PTNM,?30,ID,?45,ADMDT,?65,WARD,?100,TSXFR,?120,ABSENCE
 Q
 ;
TOTAL S $P(TOTAL,"^",1)=$P(TOTAL,"^",1)+$P(SUBCOUNT,"^",1) ; current patients
 S $P(TOTAL,"^",2)=$P(TOTAL,"^",2)+$P(SUBCOUNT,"^",2) ; pass
 S $P(TOTAL,"^",3)=$P(TOTAL,"^",3)+$P(SUBCOUNT,"^",3) ; aa
 S $P(TOTAL,"^",4)=$P(TOTAL,"^",4)+$P(SUBCOUNT,"^",4) ; ua
 S $P(TOTAL,"^",5)=$P(TOTAL,"^",5)+$P(SUBCOUNT,"^",5) ; asih
 S $P(TOTAL,"^",6)=$P(TOTAL,"^")-$P(TOTAL,"^",3)-$P(TOTAL,"^",4)-$P(TOTAL,"^",5) ; Current patient minus absences except Pass equals patient's remaining.
 ;
 S SUBNAME="DIVISION"
 ;
SUB D:$Y+6>IOSL HEAD^DGPMTSO Q:END
 ;
 S $P(SUBCOUNT,"^",6)=$P(SUBCOUNT,"^")-$P(SUBCOUNT,"^",3)-$P(SUBCOUNT,"^",4)-$P(SUBCOUNT,"^",5) ; Current patient minus absences except Pass equals patient's remaining.
 W !
 F L=1:1:(IOM-3) W "-"
 W !,SUBNAME,!
 W "SUBCOUNT   =  ",$J($P(SUBCOUNT,"^",1),4),?25,"PASS = ",$J($P(SUBCOUNT,"^",2),4),?45,"AA   = ",$J($P(SUBCOUNT,"^",3),4),?65,"UA   = ",$J($P(SUBCOUNT,"^",4),4),?85,"ASIH   = ",$J($P(SUBCOUNT,"^",5),4)
 W ?105,"PTS REMAINING   = ",$J($P(SUBCOUNT,"^",6),4),!
 Q
 ;
SUBHEAD ;
 Q:END
 W !!,"PATIENT",?30,"PT'S ID",?45,"ADMISSION DATE",?65,"INPATIENT WARD",?100,"LAST TS SERVICE",?120,"ABSENCE",!
 F L=1:1:(IOM-3) W "-"
 W !
 Q