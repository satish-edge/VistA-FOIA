SCTMDAL1 ;RGI/CBR - TEAM API; 08/31/2012
 ;;5.3;scheduling;**260003**;08/13/93;
LSTTMS(RETURN,SEARCH,START,NUMBER) ; Return teams.
 N FILE,FIELDS,RET,SCR
 S FILE="404.51",FIELDS="@;.01"
 S:$D(START)=0 START="" S:$D(SEARCH)=0 SEARCH=""
 S:$D(SEARCH(0)) SCR="I $S($P(^(0),U,5)="_SEARCH(0)_":1,1:0)"
 D LIST^DIC(FILE,"",FIELDS,"",$G(NUMBER),.START,SEARCH,"B",.SCR,"","RETURN")
 Q
 ;
GETEAM(RETURN,SCTM,INT,EXT,REZ) ; Get team
 N FILE,FLDS,SF
 S FILE=404.51,FLDS("*")=""
 D GETREC^SDMDAL(.RETURN,SCTM,FILE,.FLDS,.SF,$G(INT),$G(EXT),$G(REZ))
 Q
 ;
GETEAMPO(RETURN,SCTM,INT,EXT,REZ) ; Get team position
 N FILE,FLDS,SF
 S FILE=404.57,FLDS("*")=""
 S SF("5")="",SF("5","N")="CLNS",SF("5","F")="404.575"
 D GETREC^SDMDAL(.RETURN,SCTM,FILE,.FLDS,.SF,$G(INT),$G(EXT),$G(REZ))
 Q
 ;
GETTMH(RETURN,SCTM,INT,EXT,REZ) ; Get team history
 N FILE,FLDS,SF,TMH
 S TMH=$O(^SCTM(404.58,"B",SCTM,"")) Q:TMH'>0
 S FILE=404.58,FLDS("*")=""
 D GETREC^SDMDAL(.RETURN,TMH,FILE,.FLDS,.SF,$G(INT),$G(EXT),$G(REZ))
 Q
 ;
GETTMPO(RETURN,SCTMPO,INT,EXT,REZ) ; Get team position
 N FILE,FLDS,SF,TMH
 S:SCTMPO>0 TMH=SCTMPO
 S:SCTMPO'>0 TMH=$O(^SCTM(404.57,"B",SCTMPO,"")) Q:TMH'>0
 S FILE=404.57,FLDS("*")=""
 D GETREC^SDMDAL(.RETURN,TMH,FILE,.FLDS,.SF,$G(INT),$G(EXT),$G(REZ))
 Q
 ;
GETTMPOH(RETURN,SCTM,INT,EXT,REZ) ; Get team position history
 N FILE,FLDS,SF,TMH
 S TMH=$O(^SCTM(404.59,"B",SCTM,"")) Q:TMH'>0
 S FILE=404.59,FLDS("*")=""
 D GETREC^SDMDAL(.RETURN,TMH,FILE,.FLDS,.SF,$G(INT),$G(EXT),$G(REZ))
 Q
 ;
GETPOASH(RETURN,SCTMPO,INT,EXT,REZ) ; Get position assignment history
 N FILE,FLDS,SF,TMH
 S TMH=$O(^SCTM(404.52,"B",SCTMPO,"")) Q:TMH'>0
 S FILE=404.52,FLDS("*")=""
 D GETREC^SDMDAL(.RETURN,TMH,FILE,.FLDS,.SF,$G(INT),$G(EXT),$G(REZ))
 Q
 ;
LSTPRPO(RETURN,SEARCH,START,NUMBER) ; Return practitioner's positions.
 N FILE,FIELDS,RET,SCR
 S FILE="404.52",FIELDS="@;.01IE;.03;.02;.04"
 S:$D(START)=0 START="" S:$D(SEARCH)=0 SEARCH=""
 ;S SCR="I $S($P(^(0),U,5)="_SEARCH(0)_":1,1:0)"
 D LIST^DIC(FILE,"",FIELDS,"",$G(NUMBER),.START,SEARCH,"C",.SCR,"","RETURN")
 Q
 ;
LSTPOS(RETURN,SEARCH,START,NUMBER) ; Return positions.
 N FILE,FIELDS,RET,SCR
 S FILE="404.57",FIELDS="@;.01;.02;.09"
 S:$D(START)=0 START="" S:$D(SEARCH)=0 SEARCH=""
 S SCR="I $S($P(^(0),U,2)="_SEARCH(0)_":1,1:0)"
 D LIST^DIC(FILE,"",FIELDS,"",$G(NUMBER),.START,SEARCH,"B",.SCR,"","RETURN")
 Q
 ;
