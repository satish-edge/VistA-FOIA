WVLABWPS ;HCIOFO/FT-Display Surgical Pathology Data from Lab Package ;3/4/99  15:00
 ;;1.0;WOMEN'S HEALTH;**6**;Sep 30, 1998
 ;
EN ; Move data from ^TMP("LRA",$J) to ^TMP("WVLAB",$J) for display
 ; Called from WVLABWP and WVPROC
 Q:'$D(^TMP("LRA",$J))
 N WVLINE,WVNODE,WVDATE,WVRPTDT,WVSUB2,WVSUB3,WVSUB4,WVSUB5,WVTEXT,X
 K ^TMP("WVLAB",$J)
 S (WVDATE,WVLINE)=0
 F  S WVDATE=$O(^TMP("LRA",$J,WVDATE)) Q:'WVDATE  D
 .S WVSUB2=""
 .F  S WVSUB2=$O(^TMP("LRA",$J,WVDATE,WVSUB2)) Q:WVSUB2=""!(WVSUB2?1A)  S WVNODE=$G(^TMP("LRA",$J,WVDATE,WVSUB2)) D ACCESSN
 .I $D(^TMP("LRA",$J,WVDATE,1.2)) D SUPRPT
 .Q
 ; NOTE: Calling routine should kill ^TMP("LRA",$J)
 Q
ACCESSN ; Collection date & Lab Accession#
 I WVSUB2=0 D
 .D ADD^WVLABWPC
 .S ^TMP("WVLAB",$J,WVLINE,0)="      Collected: "_$P(WVNODE,U,1)
 .D ADD^WVLABWPC
 .S ^TMP("WVLAB",$J,WVLINE,0)="Lab Accession #: "_$P(WVNODE,U,2)
 .Q
 I WVSUB2=.1 D SPEC Q
 I $S(WVSUB2=.2:1,WVSUB2=1:1,WVSUB2=1.1:1,WVSUB2=1.3:1,WVSUB2=1.4:1,1:0) D TEXT Q
 I WVSUB2=2 D
 .S WVSUB3=0
 .F  S WVSUB3=$O(^TMP("LRA",$J,WVDATE,WVSUB2,WVSUB3)) Q:WVSUB3'>0  D
 ..S X=^TMP("LRA",$J,WVDATE,WVSUB2,WVSUB3)
 ..D WRTTM,WRTP
 ..Q
 .Q
 Q
SPEC ; Specimen list
 S WVSUB4=$O(^TMP("LRA",$J,WVDATE,.1,0))
 D ADD^WVLABWPC
 S ^TMP("WVLAB",$J,WVLINE,0)="Specimen: "_$G(^TMP("LRA",$J,WVDATE,.1,WVSUB4))
 F  S WVSUB4=$O(^TMP("LRA",$J,WVDATE,.1,WVSUB4)) Q:'WVSUB4  D
 .D ADD^WVLABWPC
 .S ^TMP("WVLAB",$J,WVLINE,0)=$$REPEAT^XLFSTR(" ",10)_$G(^TMP("LRA",$J,WVDATE,.1,WVSUB4))
 .Q
 D ADD^WVLABWPC,BLANK^WVLABWPC
 Q
TEXT ; Gross Description & Microscopic Exam/Dx
 D ADD^WVLABWPC
 S ^TMP("WVLAB",$J,WVLINE,0)="<"_WVNODE_">"
 S WVSUB4=0
 F  S WVSUB4=$O(^TMP("LRA",$J,WVDATE,WVSUB2,WVSUB4)) Q:'WVSUB4  D
 .S WVTEXT=^TMP("LRA",$J,WVDATE,WVSUB2,WVSUB4)
 .D ADD^WVLABWPC
 .S ^TMP("WVLAB",$J,WVLINE,0)=WVTEXT
 .Q
 Q
SUPRPT ; Supplementary Report
 S WVSUB2=0
 F  S WVSUB2=$O(^TMP("LRA",$J,WVDATE,1.2,WVSUB2)) Q:'WVSUB2  D
 .S WVRPTDT=$G(^TMP("LRA",$J,WVDATE,1.2,WVSUB2,0))
 .S WVRPTDT=$$FMTE^XLFDT(WVRPTDT,"2P")
 .D ADD^WVLABWPC
 .S ^TMP("WVLAB",$J,WVLINE,0)="Supplementary Report: "_WVRPTDT
 .S WVSUB3=0
 .F  S WVSUB3=$O(^TMP("LRA",$J,WVDATE,1.2,WVSUB2,WVSUB3)) Q:'WVSUB3  D
 ..D ADD^WVLABWPC
 ..S ^TMP("WVLAB",$J,WVLINE,0)=$G(^TMP("LRA",$J,WVDATE,1.2,WVSUB2,WVSUB3))
 ..Q
 .Q
 Q
WRTTM ; Display Topography, Disease, Morphology and Etiology values
 D ADD^WVLABWPC
 S ^TMP("WVLAB",$J,WVLINE,0)="Topography: "_$P(X,U,1)
 S WVSUB4=0
 F  S WVSUB4=$O(^TMP("LRA",$J,WVDATE,WVSUB2,WVSUB3,1,WVSUB4)) Q:'WVSUB4  D
 .D ADD^WVLABWPC
 .S ^TMP("WVLAB",$J,WVLINE,0)=$S(WVSUB4=1:"Disease: ",1:$$REPEAT^XLFSTR(" ",10))_$G(^TMP("LRA",$J,WVDATE,WVSUB2,WVSUB3,1,WVSUB4))
 .Q
 D ADD^WVLABWPC
 S WVSUB4=0
 F  S WVSUB4=$O(^TMP("LRA",$J,WVDATE,WVSUB2,WVSUB3,2,WVSUB4)) Q:'WVSUB4  D
 .D ADD^WVLABWPC
 .S ^TMP("WVLAB",$J,WVLINE,0)="Morphology: "_$G(^TMP("LRA",$J,WVDATE,WVSUB2,WVSUB3,1,WVSUB4))
 .S WVSUB5=0
 .F  S WVSUB4=$O(^TMP("LRA",$J,WVDATE,WVSUB2,WVSUB3,2,WVSUB4,2,WVSUB5)) Q:'WVSUB5  D
 ..D ADD^WVLABWPC
 ..S ^TMP("WVLAB",$J,WVLINE,0)=$S(WVSUB5=1:"Etiology: ",1:$$REPEAT^XLFSTR(" ",10))_$G(^TMP("LRA",$J,WVDATE,WVSUB2,WVSUB3,2,WVSUB4,1,WVSUB5))
 ..Q
 .Q
 Q
WRTP ; Display Procedure values
 Q:'$O(^TMP("LRA",$J,WVDATE,WVSUB2,WVSUB3,4,0))
 D ADD^WVLABWPC
 S ^TMP("WVLAB",$J,WVLINE,0)="<Procedures>"
 S WVSUB4=0
 F  S WVSUB4=$O(^TMP("LRA",$J,WVDATE,WVSUB2,WVSUB3,4,WVSUB4)) Q:WVSUB4  D
 .D ADD^WVLABWPC
 .S ^TMP("WVLAB",$J,WVLINE,0)=$P($G(^TMP("LRA",$J,WVDATE,WVSUB2,WVSUB3,4,WVSUB4)),U,1)
 .Q
 Q
