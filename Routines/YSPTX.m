YSPTX ;SLC/DKG,SLC/TGA-ENTER MSGS & NOTES IN PT. TEXT FILE ;5/30/91  09:35 ;
 ;;5.01;MENTAL HEALTH;;Dec 30, 1994
1 ;
 S YSTL="" W @IOF S YSYDT=DT W !!?3,YSFHDR,"s for ",YSNM,"   ",YSSEX,"   age ",YSAGE,!!
FN ; Called by routine YSPTX1, YSPTXR
 D DTS G END:YSTOUT!YSUOUT,AD^YSPTXR:YSOP="+"
EL ;
 W !!?3,"(E)nter" W:'YSNH "/Edit, (P)rint," R " or (Q)uit: Q// ",A1:DTIME S YSTOUT='$T,YSUOUT=A1["^"
 G:YSTOUT!YSUOUT END1 S A1=$TR($E(A1),"eqp","EQP") G END:"Q"[A1,ENT^YSPTX1:"E"[A1,^YSPTXR:"P"[A1 W $C(7)," ?" D QUES1^YSPTX1 G EL
 ;
DTS ;
 S (YSNH,YSOP)=0 I '$D(^PTX(YSDFN,YSTY)) S YSNH=1 W $C(7),!!?3,"No ",YSFHDR,"s on file",!! Q
 K A S (K,YSOLD,YSOL,YSPRM,YSPM,YSIDT)=0 W !!?10,"Previous ",YSFHDR,"(s)",!
IDT ;
 S YSIDT=$O(^PTX(YSDFN,YSTY,YSIDT)) G:'YSIDT SEL S K=K+1,YSHD=9999999-YSIDT,(Y,A(K))=YSHD
 D ENDD^YSUTL S (YSOL,YSPM)=0 D:YSTY(0) CK W !?8,$J(K,3),"  ",Y G IDT
SEL ;
 I YSPRM!YSOLD W !!?8,"* Patient Messages/Crisis Notes may be moved to ",!?10,"Progress Notes through the MHS Manager Option.",!
 I K=1 W !!?10,Y R "  OK? Y// ",A1:DTIME S YSTOUT='$T,YSUOUT=A1["^" Q:YSTOUT!YSUOUT  S A1=$TR($E(A1),"yn","YN") I "Y"[A1 S YSYDT=A(1) Q
 I K=1 Q:A1="N"  W:A1'["?" " ?",$C(7) D QUES2^YSPTX1 G DTS
SL1 ;
 W !!?3,"Select ",YSFHDR," NUMBER (Type '+' only to list more than one): " R YSOP:DTIME S YSTOUT='$T,YSUOUT=YSOP["^" Q:YSTOUT!YSUOUT!("+"[YSOP)  I $D(A(YSOP)) S YSYDT=A(YSOP) Q
 W:YSOP'["?" $C(7)," ?" D QUES3^YSPTX1 G SL1
 ;
NN ; Called by routine YSPTX1
 I '$D(^PTX(YSDFN,YSTY,YSIDT,1,DUZ,1,0)) S A2=1 Q
 K K S (K,A2)=0 W !!?10,YSFHDR," TIME(S):",!
A2 ;
 S A2=$O(^PTX(YSDFN,YSTY,YSIDT,1,DUZ,1,A2)) G:'A2 SA2 S K=K+1,K(K)=A2,YSDTM=^(A2,0)
 S Y=$P(YSDTM,"."),YSYD=$P(YSDTM,".",2) D ENDD^YSUTL
 S YSMN=$E(YSYD,3,4) S:$L(YSMN)=1 YSMN=YSMN_"0"
 S YSHR=$E(YSYD,1,2),A=$S(YSHR<12:YSHR,YSHR>12:YSHR-12,YSHR=12:12,1:"00"),M=$S(YSHR<12:"A",YSHR=12&(YSMN>0):"P",YSHR>12:"P",1:0),YSTM=A_":"_YSMN_" "_M_"M"
 W !?8,$J(K,3),"  ",YSDT(1)_" at "_YSTM G A2
SA2 ;
 I K=1 R "  OK? Y// ",A1:DTIME S YSTOUT='$T,YSUOUT=A1["^" Q:YSTOUT!YSUOUT  S A1=$TR($E(A1),"yn","YN") S:A1="" A1="Y" G:A1="N" AT I "Y"[A1 S A2=K(K) Q
 I K=1 W:A1'["?" " ?",$C(7) D QUES2^YSPTX1 G NN
SC1 ;
 W !!?3,"Select ",YSFHDR," NUMBER: " R A4:DTIME S YSTOUT='$T,YSUOUT=A4["^" Q:YSTOUT!YSUOUT  G:A4="" AT S:$D(K(A4)) A2=K(A4) I A4<1!(A4>K) W:A4'["?" " ?",$C(7) D QUES3^YSPTX1 G SC1
 Q:A4>0&(A4'>K)
AT ;
 W !!?3,"Are you adding a NEW ",YSFHDR R " for this patient? Y// ",A1:DTIME S YSTOUT='$T,YSUOUT=A1["^" Q:YSTOUT!YSUOUT  S A1=$TR($E(A1),"yn","YN") I "Y"[A1 S:YSYDT=DT A2=K(K)+1 S:YSYDT'=DT A2=1,YSYDT=DT,YSIDT=9999999-YSYDT Q
 Q:"N"[A1  W " ?",$C(7) D QUES4^YSPTX1 G AT
 ;
CN ; Called from MENU option YSCRISNOT
 ;
 S YSTL="" D ^YSLRP G:YSDFN<1 END1 S YSTY="CN",YSTY(0)=1,YSFN1="^99.29D^",YSFN2="^99.3P^",YSFN3="^99.31^",YSFHDR="Crisis Note"
 G 1
PN ;
 D ^YSLRP G:YSDFN<1 END S YSTY="PN",YSTY(0)=0,YSFN1="^99.01D^",YSFN2="^99.02P^",YSFN3="^99.03^",YSFHDR="Progress Note",YSFTR="SF 509"
 G 1
 ;
MS ; Called from MENU option YSPATMSG
 ;
 S YSTL="" D ^YSLRP G:YSDFN<1 END1 S YSTY="MS",YSTY(0)=1,YSFN1="^99.39D^",YSFN2="^99.4P^",YSFN3="^99.41^",YSFHDR="Message"
 G 1
 ;
END ; Called by routine YSPTX1
 I '$G(YSIDT) S YSIDT=9999999-DT
 S YSUSR=DUZ D FCK^YSMV1
END1 ; Called by routine YSPTXR
 I $G(YSTOUT),IOST?1"C-".E W:IOF]"" @IOF
 K %,%DT,%ZIS,A,A1,A2,A3,A4,B4,C,D,DIC,DIW,DIWF,DIWL,DIWR,DIWT,DN,DW2,DWI,I,I0,IO("Q"),J,K,L,M,X,X1,Y,YSCON,YSD,YSDC,YSDH,YSDTM,YSFN1,YSFN2,YSFN3,YSFTR,YSHD,YSFHDR
 K YSHR,YSLDT,YSMOR,YSMN,YSNH,YSNN,YSNS,YSNT,YSNU,YSOL,YSOLD,YSOP,YSP4,YSPF,YSP0,YSPM,YSPRM,YSPTD,YSSP,YSTHN,YSTM,YSTN,YSTXN,YSUR,YSUS,YSUSER,YSUSN,YSUSR,YSUTL,YSYN
 K YSYD,YSYDT,Z,ZTSK K:YSTL="" YSAGE,YSDOB,YSSEX,YSSSN K YSTL Q
CK ;
 S YSUSR=0
USR ;
 S YSUSR=$O(^PTX(YSDFN,YSTY,YSIDT,1,YSUSR)) Q:'YSUSR  S YSTXN=0
TXN ;
 S YSTXN=$O(^PTX(YSDFN,YSTY,YSIDT,1,YSUSR,1,YSTXN)) G:'YSTXN USR I $D(^PTX(YSDFN,YSTY,YSIDT,1,YSUSR,1,YSTXN,2)),^(2)="P" S:YSOL YSOL=0 S YSPM=1 S YSPRM=1 Q
OLD ;
 S:'YSPM YSOL=1 S YSOLD=1
 G TXN