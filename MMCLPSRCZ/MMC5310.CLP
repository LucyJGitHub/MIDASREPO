/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MM Rollover deal opt ctl program')              */
/*********************************************************************/
/*                                                                   */
/*       Midas       MONEY MARKET MODULE                             */
/*                                                                   */
/*       MMC5310 - ROLLOVER DEALS OPTION CONTROL                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC023             Date 30Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Prev Amend No. 190336             Date 27Feb01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      119070             Date 19Feb98              */
/*                      085347            DATE 31MAR95               */
/*                      084206            DATE 20MAR95               */
/*                      077556            DATE 20DEC94               */
/*                      S01434            DATE 26JUL93               */
/*                      049421            DATE 18JAN93               */
/*                      ROLLOV            DATE 18JAN93               */
/*                                                                   */
/*********************************************************************/
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       190336  -  No error msg sent when transaction failed        */
/*       119070  -  FILE REORGANISED EACH TIME CAUSING LOCK WAIT     */
/*                  REMOVE 085347                                    */
/*       085347  -  DUPLICATE KEY ERROR OCCURED FOR DEALSCX0 WHEN    */
/*                  ROLLOVER MAINTENANCE INPUT IS ABORTED AND THEN   */
/*                  RE-ENTERED AGAIN.                                */
/*       084206  -  THE ALLOCATED DEAL NUMBER IS NOT REACTIVATED     */
/*                  IF F3 IS PRESSED AT LDNI INPUT IF MM5310 HAS     */
/*                  ALLOCATED THE DEAL NUMBER AUTOMATICALLY.  THE    */
/*                  UPDATE FOR DEAL NUMBER RANGES IS NOT ROLLED      */
/*                  BACK.                                            */
/*       077556  -  MMDEALLL SHOULD BE UNDER COMMITMENT CONTROL      */
/*       S01434  -  Recompiled - Enhanced Rollovers                  */
/*       049421  -  HEADER BOX STANDARDISATION                       */
/*       ROLLOV  -  WRITTEN FOR ROLLOVER DEALS                       */
/*********************************************************************/
/*********** PGM        PARM(&PARM)                                     S01434*/
/*********** DCL        &PARM         TYPE(*CHAR)  LEN(8)               S01434*/
             PGM                                                      /*S01434*/
             DCLF       FILE(SDMGMEPD)                                /*S01434*/
             DCL        &MSG          TYPE(*CHAR)  LEN(50)
/* DATA AREA VARIABLES */
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&DLSTAT) TYPE(*CHAR) LEN(256)
/*********** DCL        VAR(&SWSTAT) TYPE(*CHAR) LEN(256)               S01434*/
/*********** DCL        VAR(&PMP) TYPE(*CHAR) LEN(1)                    S01434*/
/*********** DCL        VAR(&WWUSER) TYPE(*CHAR) LEN(10)                S01434*/
/*********** DCL        VAR(&WWNUMB) TYPE(*CHAR) LEN(6)                 S01434*/
/*********** DCL        VAR(&WWMBR)  TYPE(*CHAR) LEN(9)                 S01434*/
/**/
             DCL        VAR(&KEYBUF) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/* Monitor for error messages not trapped in the rest of the */
/* program. If they occur reclaim resources and exit.        */
     MONMSG MSGID(CPF0000 CPA0000 MCH0000 RPG0000) +
            EXEC(GOTO CMDLBL(ERR))
     GOTO CMDLBL(RUN)
ERR:
     RCLRSC
     RETURN
/**/
RUN:
/*  FIRST RESET JOB SWITCHES */
             CHGJOB     SWS(XXX0XX00)
/*********** RTVDTAARA  DTAARA(MMOD (75 1)) RTNVAR(&PMP)                S01434*/
/*********** IF         COND(&PMP = 'Y') THEN(CHGJOB SWS(XXX1XXXX))     S01434*/
/*  PRONO needs to have SHARE(*NO) for certain components otherwise  */
/*  they crash */
            OVRDBF PRONO  SHARE(*NO)
 
             CALL       PGM(QWSSETWS) PARM('0')
             MONMSG     MSGID(CPF0000)                                /*S01434*/
/**/
/***PREPARE*A*MEMBER*NAME*FROM*THE*JOB*ATTRIBUTES***********************S01434*/
/***********                                                            S01434*/
/***********                                                            S01434*/
/*********** RTVJOBA    USER(&WWUSER) NBR(&WWNUMB)                      S01434*/
/*********** CHGVAR     VAR(&WWMBR) VALUE(%SST(&WWUSER 1 3) *TCAT +     S01434*/
/***********                &WWNUMB  )                            E15515S01434*/
/***********                                                            S01434*/
/***********                                                            S01434*/
/***TEST*FOR*THE*PRESENCE*OF*THIS*MEMBER*ON*MMSTDAPP.*IF*IT*DOES*NOT****S01434*/
/***EXIST*ADD*MEMBER*WITH*THIS*NAME*TO*THE*FILE*MMSTDAPP.***************S01434*/
/***********                                                            S01434*/
/***********                                                            S01434*/
/*********** CHKOBJ     OBJ(MMSTDAPP) OBJTYPE(*FILE) MBR(&WWMBR)        S01434*/
/*********** MONMSG     MSGID(CPF9815) EXEC(DO)                         S01434*/
/***********    ADDPFM     FILE(MMSTDAPP) MBR(&WWMBR) SHARE(*NO )       S01434*/
/*********** ENDDO                                                      S01434*/
/***********                                                            S01434*/
/***TEST*FOR*THE*PRESENCE*OF*THIS*MEMBER*ON*MMSTDBPP.*IF*IT*DOES*NOT****S01434*/
/***EXIST*ADD*MEMBER*WITH*THIS*NAME*TO*THE*FILE*MMSTDBPP.***************S01434*/
/***********                                                            S01434*/
/***********                                                            S01434*/
/*********** CHKOBJ     OBJ(MMSTDBPP) OBJTYPE(*FILE) MBR(&WWMBR)        S01434*/
/*********** MONMSG     MSGID(CPF9815) EXEC(DO)                         S01434*/
/***********    ADDPFM     FILE(MMSTDBPP) MBR(&WWMBR) SHARE(*NO )       S01434*/
/*********** ENDDO                                                      S01434*/
/***********                                                            S01434*/
/***********                                                            S01434*/
/***TEST*FOR*THE*PRESENCE*OF*THIS*MEMBER*ON*MMSTDLPP.*IF*IT*DOES*NOT****S01434*/
/***EXIST*ADD*MEMBER*WITH*THIS*NAME*TO*THE*FILE*MMSTDLPP.***************S01434*/
/***********                                                            S01434*/
/***********                                                            S01434*/
/*********** CHKOBJ     OBJ(MMSTDLPP) OBJTYPE(*FILE) MBR(&WWMBR)        S01434*/
/*********** MONMSG     MSGID(CPF9815) EXEC(DO)                         S01434*/
/***********    ADDPFM     FILE(MMSTDLPP) MBR(&WWMBR) SHARE(*NO )       S01434*/
/*********** ENDDO                                                      S01434*/
/***********                                                            S01434*/
/***********                                                            S01434*/
/***TEST*FOR*THE*PRESENCE*OF*THIS*MEMBER*ON*MMSTDSPP.*IF*IT*DOES*NOT****S01434*/
/***EXIST*ADD*MEMBER*WITH*THIS*NAME*TO*THE*FILE*MMSTDSPP.***************S01434*/
/***********                                                            S01434*/
/***********                                                            S01434*/
/*********** CHKOBJ     OBJ(MMSTDSPP) OBJTYPE(*FILE) MBR(&WWMBR)        S01434*/
/*********** MONMSG     MSGID(CPF9815) EXEC(DO)                         S01434*/
/***********    ADDPFM     FILE(MMSTDSPP) MBR(&WWMBR) SHARE(*NO )       S01434*/
/*********** ENDDO                                                      S01434*/
/***********                                                            S01434*/
/***********                                                            S01434*/
/**TEST*FOR*THE*PRESENCE*OF*THIS*MEMBER*ON*MMSTDDLL.*IF*IT*DOES*NOT*****S01434*/
/**EXIST*ADD*MEMBER*WITH*THIS*NAME*TO*THE*FILE*MMSTDDLL.****************S01434*/
/***********                                                            S01434*/
/***********                                                            S01434*/
/*********** CHKOBJ     OBJ(MMSTDDLL) OBJTYPE(*FILE) MBR(&WWMBR)        S01434*/
/*********** MONMSG     MSGID(CPF9815) EXEC(DO)                         S01434*/
/***********    ADDLFM     FILE(MMSTDDLL) MBR(&WWMBR) +                 S01434*/
/***********               DTAMBRS((MMSTDAPP (&WWMBR)) (MMSTDBPP +      S01434*/
/***********               (&WWMBR)) (MMSTDLPP (&WWMBR)) (MMSTDSPP +    S01434*/
/***********               (&WWMBR))) SHARE(*NO)                        S01434*/
/*********** ENDDO                                                      S01434*/
 
             OVRDBF     FILE(MMDEALLL) SHARE(*NO)                     /*077556*/
             OVRDBF     FILE(CADLFALL) SHARE(*NO)                     /*084206*/
/*/COPY WNCPYSRC,MMC5310001                                          */
/*  CALL PROGRAM             */
     CALL PGM(MM5310)
 
/*********** RTVDTAARA  DTAARA(SDSTAT (127 1)) RTNVAR(&KEYBUF)          S01434*/
             RTVDTAARA  DTAARA(SDSTAT (11 1)) RTNVAR(&KEYBUF)         /*S01434*/
/*/COPY WNCPYSRC,MMC5310007                                          */
/************IF         COND(&KEYBUF *NE N) THEN(CALL PGM(QWSSETWS) + /*190336*/
/************             PARM('1'))                                  /*190336*/
             IF         COND(&KEYBUF *NE N) THEN(DO)                  /*190336*/
                CALL PGM(QWSSETWS) PARM('1')                          /*190336*/
                MONMSG     MSGID(CPF0000)                             /*190336*/
             ENDDO                                                    /*190336*/
/*/COPY WNCPYSRC,MMC5310008                                          */
 
              DLTOVR      FILE(PRONO)
/*/COPY WNCPYSRC,MMC5310002                                          */
              DLTOVR      FILE(MMDEALLL)                              /*077556*/
              DLTOVR      FILE(CADLFALL)                              /*084206*/
/******       RGZPFM      FILE(DEALSCX0)                     *085347****119070*/
/*  IF U7 AND U8 ARE ON SEND DATA BASE ERROR MESSAGE TO MOPERQ */
/*  AND *EXT:                                                  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(*LDA (134 50)) RTNVAR(&MSG)
                SNDPGMMSG  MSGID(DBM0001) MSGF(DRSMM) MSGDTA(&MSG) +
                          TOMSGQ(MOPERQ)
 
                SNDPGMMSG MSG('Transaction Failed. Re-input Necessary. +
                          Press ENTER to Continue.') TOPGMQ(*EXT)
 
                ROLLBACK
             ENDDO
 /* ADD PROCESSING FOR CONFIRMATIONS */         /*START E13300*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
             IF         COND(%SWITCH(XXXXX000)) THEN(DO)
 /* DO CONFIRMATIONS IF BACK OFFICE DEAL INPUT CALLED */
/*********** IF         COND(&PARM *EQ 'MM5320') THEN(DO)               S01434*/
             IF         COND((%SST(&MMOD 25 1) *EQ 'Y') *OR  +
                           (%SST(&MMOD 33 1) *EQ 'Y')) THEN(DO)
             RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)
 /* CHECK THAT CONFIRMATION PROCESS IS NOT ALREADY RUNNING */
                IF         COND(%SST(&DLSTAT 6 2) *EQ 'NN') THEN(DO)
                   ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
                   CHGDTAARA  DTAARA(DLSTAT (6 1)) VALUE('Y')
                   DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
/*********** RTVDTAARA  DTAARA(SWSTAT) RTNVAR(&SWSTAT)                  S01434*/
/***********          IF        COND(%SST(&SWSTAT 9 1) *EQ Y) THEN(DO)  S01434*/
/***********             ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))       S01434*/
/***********             CHGDTAARA  DTAARA(DLSTAT (6 1)) VALUE('N')     S01434*/
/***********             DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))       S01434*/
/***********          ENDDO                                             S01434*/
/*********** ELSE   DO                                                  S01434*/
                      SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)
/*/COPY WNCPYSRC,MMC5310003                                          */
/************SBMJOB     JOB(DLC0210A) JOBD(MBATCH) USER(*JOBD) +                          /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL   DLC0210A') +                       /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(MOPERQ)                                     /*CSC023*/
/************SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +                          /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +                         /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(MOPERQ)                                     /*CSC023*/
             SBMJOB     JOB(DLC0210A) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL   DLC0210A') +
                          INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                         /*CSC023*/
             SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
                          INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                         /*CSC023*/
/*/COPY WNCPYSRC,MMC5310004                                          */
/***********       ENDDO                                                S01434*/
                ENDDO
/*********** ENDDO                                                      S01434*/
             ELSE   DO
             RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)
 /* CHECK THAT CONFIRMATION PROCESS IS NOT ALREADY RUNNING */
                IF         COND(%SST(&DLSTAT 6 1) *EQ 'N') THEN(DO)
                   ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
                   CHGDTAARA  DTAARA(DLSTAT (6 1)) VALUE('Y')
                   DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
                   SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)
/*/COPY WNCPYSRC,MMC5310005                                          */
/************SBMJOB     JOB(DLC0210A) JOBD(MBATCH) USER(*JOBD) +                          /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL   DLC0210A') +                       /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(MOPERQ)                                     /*CSC023*/
/************SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +                          /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +                         /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(MOPERQ)                                     /*CSC023*/
             SBMJOB     JOB(DLC0210A) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL   DLC0210A') +
                          INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                         /*CSC023*/
             SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
                          INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                         /*CSC023*/
/*/COPY WNCPYSRC,MMC5310006                                          */
             RCVF                                                     /*S01434*/
             IF         COND(&ENAPRG *EQ 'Y') THEN(DO)                /*S01434*/
                        CALL       PGM(FCC0201) PARM('DLC0211' +
                                   '10001' 'DL0308' 'B')              /*S01434*/
             ENDDO                                                    /*S01434*/
/**/
                ENDDO
             ENDDO
                ENDDO
             ENDDO
/**/
/*  RECLAIM RESOURCES TO PURGE THE FX UPDATE PROGRAMS FROM */
/*  MEMORY, AND RELEASE THEIR FILES                        */
             RCLRSC
/**/
/*  END THE PROGRAM */
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
