HBHXMNT3 ;VAMC(IRMS)/MJT-HBHC maintenance routine prints report of patients with pseudo SSN, includes:  patient name, SSN, form & corresponding date, called from HBHXMNT2 ;9403
 ;;1.0;HOSPITAL BASED HOME CARE;**2**;NOV 01,1993
 K ^TMP("HBHC",$J)
 ; Max length for HBHCHEAD = 50
 S HBHCCC=0,$P(HBHCY,"-",81)="",HBHCPAGE=0,HBHCHEAD="Pseudo SSN Patch Related",HBHCHDR="W ""Patient Name"",?35,""SSN"",?51,""Form"",?62,""Date""",HBHCCOLM=(80-(30+$L(HBHCHEAD))\2) S:HBHCCOLM'>0 HBHCCOLM=1 D TODAY^HBHCUTL
 D:IO'=IO(0)!($D(IO("S"))) HDRPAGE^HBHCUTL
 I '$D(IO("S")),(IO=IO(0)) S HBHCCC=HBHCCC+1 W @IOF D HDRPAGE^HBHCUTL
 S HBHCDPT=0
 F  S HBHCDPT=$O(^HBHC(634.5,"B",HBHCDPT)) Q:HBHCDPT'>0  F HBHCFILE=631,632 S HBHCDFN=0 F  S HBHCDFN=$O(^HBHC(HBHCFILE,"B",HBHCDFN)) Q:HBHCDFN'>0  S HBHCIEN=0 F  S HBHCIEN=$O(^HBHC(HBHCFILE,"B",HBHCDFN,HBHCIEN)) Q:HBHCIEN'>0  D PROCESS
 D PRTLOOP,ENDRPT^HBHCUTL1
EXIT ; Exit module
 D ^%ZISC
 K HBHCCC,HBHCCOLM,HBHCDATE,HBHCDFN,HBHCDPT,HBHCDPT0,HBHCFILE,HBHCFORM,HBHCHEAD,HBHCHDR,HBHCIEN,HBHCINFO,HBHCNAME,HBHCPAGE,HBHCSSN,HBHCTDY,HBHCY,HBHCZ,Y,^TMP("HBHC",$J)
 Q
PROCESS ; Process records
 S HBHCINFO=^HBHC(HBHCFILE,HBHCIEN,0),HBHCDPT0=^DPT($P(HBHCINFO,U),0),HBHCSSN=$P(HBHCDPT0,U,9)
 Q:HBHCSSN?9N
 I HBHCFILE=631 S:$D(^HBHC(HBHCFILE,"AE","F",HBHCIEN)) ^TMP("HBHC",$J,3,$P(HBHCDPT0,U),$P(HBHCINFO,U,2))=$E(HBHCSSN,1,3)_"-"_$E(HBHCSSN,4,5)_"-"_$E(HBHCSSN,6,10)
 I HBHCFILE=631 S:($D(^HBHC(HBHCFILE,"AF","F",HBHCIEN)))&('$D(^HBHC(HBHCFILE,"AE","F",HBHCIEN))) ^TMP("HBHC",$J,5,$P(HBHCDPT0,U),$P(HBHCINFO,U,40))=$E(HBHCSSN,1,3)_"-"_$E(HBHCSSN,4,5)_"-"_$E(HBHCSSN,6,10)
 I HBHCFILE=632 S:$D(^HBHC(HBHCFILE,"AC","F",HBHCIEN)) ^TMP("HBHC",$J,4,$P(HBHCDPT0,U),$P(HBHCINFO,U,2))=$E(HBHCSSN,1,3)_"-"_$E(HBHCSSN,4,5)_"-"_$E(HBHCSSN,6,10)
 Q
PRTLOOP ; Print loop
 S HBHCFORM=0
 F  S HBHCFORM=$O(^TMP("HBHC",$J,HBHCFORM)) Q:HBHCFORM'>0  S HBHCNAME="" F  S HBHCNAME=$O(^TMP("HBHC",$J,HBHCFORM,HBHCNAME)) Q:HBHCNAME=""  S HBHCDATE=0 F  S HBHCDATE=$O(^TMP("HBHC",$J,HBHCFORM,HBHCNAME,HBHCDATE)) Q:HBHCDATE'>0  D PRINT
 Q
PRINT ; Print report
 I ($D(ZTRTN)!(HBHCCC=0))&((IOSL-$Y)<5) W @IOF D HDRPAGE^HBHCUTL
 I (IOSL-$Y)<5 W @IOF D HDRPAGE^HBHCUTL
 S Y=HBHCDATE D DD^%DT
 W !,HBHCNAME,?35,^TMP("HBHC",$J,HBHCFORM,HBHCNAME,HBHCDATE),?51,HBHCFORM,?62,Y,!,HBHCY
 Q