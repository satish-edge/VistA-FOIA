IBXX21 ; COMPILED XREF FOR FILE #399.044 ; 05/26/11
 ; 
 S DA=0
A1 ;
 I $D(DISET) K DIKLM S:DIKM1=1 DIKLM=1 G @DIKM1
0 ;
A S DA=$O(^DGCR(399,DA(1),"D1",DA)) I DA'>0 S DA=0 G END
1 ;
 S DIKZ(0)=$G(^DGCR(399,DA(1),"D1",DA,0))
 S X=$P($G(DIKZ(0)),U,1)
 I X'="" S ^DGCR(399,DA(1),"D1","B",$E(X,1,30),DA)=""
 G:'$D(DIKLM) A Q:$D(DISET)
END G ^IBXX22