/*********************************************************************/
/*XBIA   DSPFD FILE(CGPGENPD) TYPE(*BASATR) OUTPUT(*OUTFILE)         */                   /*160665*/
/*XBIA           OUTFILE(QTEMP/DSPFDF) OUTMBR(*FIRST *ADD)           */                   /*160665*/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas MA Archive batch control')                      */
/*OVR  : OVRDBF FILE(TMPSPLF) TOFILE(FCTMPPD)                       :*/
/*********************************************************************/
/*                                                                   */
/*  Midas - Microfiche/Optical Disk Archiving Module                 */
/*                                                                   */
/*  MAC06    - Archive Batch job Control                             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. AR1097467A         Date 12Apr13              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG1804            Date 25May04              */
/* Midas Release 4.01 -----------------------------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      175941             Date 03Jan01              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      160665             Date 05Apr00              */
/*                      165866             Date 05Apr00              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                 132482                DATE 20May98                */
/*                 090061                DATE 27JUN96                */
/*                 S01382                DATE 24JUL92                */
/*                 E27260                DATE 11SEP91                */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*  AR1097467A - Expected 15% COB run optimization not met           */
/*  BUG1804 - Only perform delay job if Correspondence Manager is    */
/*            switched off as CM generates XML output and not SPLF.  */
/*  175941 - Allow delay job when UDC_PRTGEN is still running.       */
/*  160665 - With UDC - delay job until only one member in CGPGENPD. */
/*  165866 - Only delay when UDC is present.                         */
/*  132482 - Delay job 45 minutes to stop UDC conflict .             */
/*  090061 - 'Re-submit Archiving job' remains in DLYW status, and   */
/*           cannot start the archiving processing.  Value in the    */
/*           dtaara MACHK is 'Z'.  The fix Is therefore to           */
/*           default the updating of data area MACHK from 'Z' to 'N' */
/*           upon completion of archiving process.                   */
/*  S01382 - OPTICAL DISK DEVELOPMENT                                */
/*  E27260 - Change 'Microfiche Archiving' to 'Midas Archiving'.     */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/* This program controls Archiving of individual reports and whole   */
/*  output queues to Microfiche and/or Optical Disk Tape files.      */
/*                                                                   */
/*********************************************************************/
 PGM
 
 DCL        &eflg    *char   1 value(' ')      /* Error Flag        */
 DCL        &machk   *char   1                 /* Archiving Status  */
/*/COPY WNCPYSRC,MAC06006                                            */
 DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')                  /*165866*/
 DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST ')            /*165866*/
 DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                            /*165866*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&FMT)  TYPE(*CHAR) LEN(200)               /*175941*/
             DCL        VAR(&CGDTA)  TYPE(*CHAR) LEN(512)             /*175941*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)                 /*175941*/
             DCL   VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE('       ')     /*175941*/
             DCL   VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST ')     /*175941*/
             DCL   VAR(&RTNCDE) TYPE(*CHAR) LEN(7)                    /*BUG1804*/
             DCL   VAR(&OPTION) TYPE(*CHAR) LEN(7)                    /*BUG1804*/
             DCL   VAR(&SARD)   TYPE(*CHAR) LEN(6)                    /*BUG1804*/
             DCL   VAR(&CCG015) TYPE(*CHAR) LEN(1) VALUE('N')         /*BUG1804*/
 
/**********  DCLF       FILE(QTEMP/DSPFDF) */                  /*160665 175941*/
                                                                      /*160665*/
 monmsg     (RPG0000 CPF0000 MCH0000) exec(goto abnor)
/*/COPY WNCPYSRC,MAC06004                                            */
                                                                      /*BUG1804*/
/** Determine if CCG015 is installed */                               /*BUG1804*/
                                                                      /*BUG1804*/
             CHGVAR     VAR(&RTNCDE) VALUE('       ')                 /*BUG1804*/
             CHGVAR     VAR(&OPTION) VALUE('*VERIFY')                 /*BUG1804*/
             CHGVAR     VAR(&SARD) VALUE('CCG015')                    /*BUG1804*/
                                                                      /*BUG1804*/
             CALL       PGM(AOSARDR0) PARM(&RTNCDE &OPTION &SARD)     /*BUG1804*/
             IF         COND(&RTNCDE *EQ '       ') THEN(CHGVAR +
                          VAR(&CCG015) VALUE('Y'))                    /*BUG1804*/
 
/**/                                                                  /*165866*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)          /*165866*/
/**/                                                                  /*165866*/
/** Database error handling                                        */ /*165866*/
/**/                                                                  /*165866*/
             IF         COND(&RTCD *NE '       ') THEN(DO)            /*165866*/
               SNDPGMMSG  MSG('Error on access to ICD file +
                            AOMMODPD') TOMSGQ(MOPERQ)                 /*165866*/
               GOTO       CMDLBL(ABNOR)                               /*165866*/
             ENDDO                                                    /*165866*/
 
/************Dlyjob*****dly(2700)**/                           /*132482 165866*/
/************IF*********COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DLYJOB +
/*************************DLY(2700))**/                        /*165866 160665*/
/**********  IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)/*160665 175941*/
                                                                      /*160665*/
/**********  DLYJOB     DLY(300) */                            /*160665 175941*/
/** DSPF:       DSPFD      FILE(CGPGENPD) TYPE(*BASATR) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/DSPFDF) +
                          OUTMBR(*FIRST *ADD) */               /*160665 175941*/
/**********  RCVF */                                           /*160665 175941*/
                                                                      /*160665*/
/**********  IF         COND(&ATNOMB *GT 1) THEN(DO) */        /*160665 175941*/
/**********  DLYJOB     DLY(300) */                            /*160665 175941*/
/**********  GOTO       CMDLBL(DSPF) */                        /*160665 175941*/
/**********  ENDDO */                                          /*160665 175941*/
                                                                      /*160665*/
/**********  ENDDO */                                          /*160665 175941*/
                                                                      /*160665*/
             RTVDTAARA  DTAARA(CGDTA)   RTNVAR(&CGDTA)                /*175941*/
                                                                      /*175941*/
                                                                      /*175941*/
/*  If UDC_PRTGEN status is set to N, run Archiving Job, else  */     /*175941*/
/*  add delay  */                                                     /*175941*/
                                                                      /*175941*/
/*  Access PF/SDMMODPD to determine whether UDC module is on  */      /*175941*/
                                                                      /*175941*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)          /*175941*/
                                                                      /*175941*/
/*  Database error handling  */                                       /*175941*/
                                                                      /*175941*/
             IF         COND(&RTCD *NE '       ') THEN(DO)            /*175941*/
             CHGVAR     VAR(&MSG) VALUE('Error on access to ICD file +
                          SDMMODPD')                                  /*175941*/
             GOTO       CMDLBL(ABNOR)                                 /*175941*/
             ENDDO                                                    /*175941*/
                                                                      /*175941*/
CHKRUN:      RTVDTAARA  DTAARA(CGDTA)   RTNVAR(&CGDTA)                /*175941*/
/************IF      COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)*/ /*175941 BUG1804*/
             IF         COND((%SST(&FMT 101 1) *EQ 'Y') *AND +
                        (&CCG015 *NE 'Y')) THEN(DO)                   /*BUG1804*/
             IF         COND(%SST(&CGDTA 357 1) *EQ 'Y') THEN(DO)     /*175941*/
             DLYJOB     DLY(1800)                                     /*175941*/
             GOTO       CMDLBL(CHKRUN)                                /*175941*/
             ENDDO                                                    /*175941*/
             ENDDO                                                    /*175941*/
                                                                      /*175941*/
/*/COPY WNCPYSRC,MAC06005                                            */
 
 chgjob     sws(XXXXXX00)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
 
/* Retrieve Archiving Status                                       */
 
         rtvdtaara  machk   rtnvar(&machk)
 
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/*  If Archiving Status (&machk) is set to N, or Y              +
      run Archiving Control Pgm  - MAC06060                        */
 
 IF    ((&machk *eq 'N') *or (&machk *eq 'Y')) +
       then(DO)
 
               call    MAC0606       parm(&EFLG)
               IF      ((%switch(XXXXXX11)) *or +
                          (&EFLG *ne ' '))     then(goto ABNOR)
 
               rtvdtaara  machk   rtnvar(&machk)
       ENDDO
 
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/**If*Archiving*Status*(&machk)*is*set*to*'C',*********************+  /*S01382*/
/**clear*all*Archive*Output*Queues**********************************/ /*S01382*/
 
 
/******IF   (&machk *eq 'C') +                                     */ /*S01382*/
/******then(DO)                                                    */ /*S01382*/
 
/******        call    MAC0607       parm(&EFLG)                   */ /*S01382*/
/******        IF      ((%switch(XXXXXX11)) *or +                  */ /*S01382*/
/******                   (&EFLG *ne ' '))    then(goto ABNOR)     */ /*S01382*/
 
/******        rtvdtaara  machk   rtnvar(&machk)                   */ /*S01382*/
/******ENDDO                                                       */ /*S01382*/
 
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */ /*S01382*/
/*  If Archiving Status (&machk) is not set to C,                  +
      wait for 5 minutes before receiving data area again          */ /*S01382*/
                                                                      /*S01382*/
 LOOP:       IF         COND(&MACHK *NE 'C') THEN(DO)                 /*S01382*/
/**********     DLYJOB     DLY(300)                                            /*S01382 AR1097467A*/
                DLYJOB     DLY(30)                                                    /*AR1097467A*/
                RTVDTAARA  DTAARA(MACHK) RTNVAR(&MACHK)               /*S01382*/
                GOTO       CMDLBL(LOOP)                               /*S01382*/
             ENDDO                                                    /*S01382*/
                                                                      /*S01382*/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/**If*Archiving*Status*(&machk)*is*set*to*'F',*********************+  /*S01382*/
/***run*Archiving*Audit*Report**************************************/ /*S01382*/
/* If Archiving Status (&machk) is set to 'C',                     +
    run Archiving Audit Report                                     */ /*S01382*/
 
 
/******IF   (&machk *eq 'F') +                                     */ /*S01382*/
/******then(DO)                                                    */ /*S01382*/
             IF         COND(&MACHK *EQ 'C') THEN(DO)                 /*S01382*/
 
/* Order the microfiche and optical disk header records before     */ /*S01382*/
/* printing archive audit report                                   */ /*S01382*/
/**************call    MA0630                                      */ /*S01382*/
               call    MAC0652
               IF      (%switch(XXXXXX11)) then(goto ABNOR)
 
/**************chgdtaara  machk   ('Z')                               /*090061*/
/*/COPY WNCPYSRC,MAC06002                                            */
               chgdtaara  machk   ('N')                               /*090061*/
/*/COPY WNCPYSRC,MAC06003                                            */
       ENDDO
 
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/*/COPY WNCPYSRC,MAC06001                                            */
 
 goto END
 
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
 
ABNOR:  CHGJOB    sws(XXXXXX11)
        monmsg    (RPG0000 CPF0000 MCH0000)
/**********SNDMSG    MSG('M/fiche Archiving Control program +
/**********          ended abnormally')  TOMSGQ(MOPERQ)               /*E27260*/
           SNDMSG    MSG('Midas archiving control program +
                     ended abnormally')  TOMSGQ(MOPERQ)               /*E27260*/
           monmsg    (RPG0000 CPF0000 MCH0000)
 
END:    ENDPGM
