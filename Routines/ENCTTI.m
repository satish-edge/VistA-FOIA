ENCTTI ;(WASH ISC)/RGY-Calculate Time ;10-31-89
 ;;7.0;ENGINEERING;;Aug 17, 1993
 ;Copy of PRCTTI ;DH-WASH ISC
 ;ENCTMIN=# of min. to add or sub, ENCTSD=date to add or sub from in FM format -- Answer ret. in 'Y'
 S X2=ENCTMIN\1440,HOUR=(ENCTMIN-(1440*X2))\60,MIN=(ENCTMIN-(1440*X2)-(60*HOUR))#$S(ENCTMIN<0:-60,1:60),X1=ENCTSD\1,HR=$E(ENCTSD,9,10),MI=$E(ENCTSD,11,12)
 S:$L(HR)=1 HR=HR_0 S:$L(MI)=1 MI=MI_0 S MI=MI+MIN S:MI>59 MI=MI-60,HR=HR+1
 S:MI<0 MI=MI+60,HR=HR-1 S HR=HR+HOUR S:HR>23 HR=HR-24,X2=X2+1 S:HR<0 HR=HR+24,X2=X2-1 S:HR+MI=0 X2=X2-1,HR=24,MI=0 S:HR<10 HR=0_HR S:MI<10 MI=0_MI S X=X1 D:X2 C^%DTC S X=$P(X,".") S Y=+(X_"."_HR_MI)
 ; install with verson 17.3 of fm
 K HR,MI,X1,X2,HOUR,MIN,ENCTMIN,O Q