/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RR Recover DTAARA sts at recvr point')          */
/********************************************************************/
/*                                                                  */
/*  Midas - Restart Recovery Module                         */
/*                                                                  */
/*  SDC1723 - RECOVER DATA AREAS TO STATUS AT RECOVER TO POINT      */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. E29436        DATE 11OCT91                  */
/*       PREV AMEND NO. RT0159        DATE 26JUN91                  */
/*                      S01117        DATE 17/08/89                 */
/*                      S01127        DATE 02/06/88                 */
/*                      E11514        DATE 12/10/87                 */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       E29436 - MOVED TO SOURCE FILE RRCLSRC FROM SDCLSRC.        */
/*       RT0159 - Messages should be sent via new Midas Info Screen.*/
/*       S01117 - MULTIBRANCHING                                    */
/*       S01127 - DESCRIPTION OF CHANGE - IF FUTURES & OPTIONS      */
/*                PRESENT IN SYSTEM, ALSO RECOVER FFSTAT & NACON    */
/*                DATA AREAS                                        */
/*       E11514 - PROJECT CHECK FOR ENTRY SPECIFIC DATA SHOULD BE   *  *E11514*/
/*                MADE FROM POSITION 125 AS SYSTEM DATA IS CONT-    *  *E11514*/
/*                AINED IN FIRST 125 POSITIONS OF RETRIEVED JOURN-  *  *E11514*/
/*                AL ENTRY.                                         *  *E11514*/
/*                                                                  */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&TOPNT)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/*   INITIAL PROCESSING                                             */
/**/
             DCL        VAR(&TOPNT) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&TOPNTA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MMODA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MNATNA) TYPE(*CHAR) LEN(5)
             DCL        VAR(&REPTNA) TYPE(*CHAR) LEN(5)               /*S01117*/
             DCL        VAR(&NACONA) TYPE(*CHAR) LEN(6)               /*S01127*/
             DCL        VAR(&XXSTAT) TYPE(*CHAR) LEN(256)
/************DCL********VAR(&RTNVAR)*TYPE(*CHAR)*LEN(272)************  *E11514*/
             DCL        VAR(&RTNVAR) TYPE(*CHAR) LEN(397)             /*E11514*/
             DCL        VAR(&RTNSQN) TYPE(*DEC) LEN(10 0)
/**/
/* GLOBAL MONITOR MESSAGE */
/**/
             SNDPGMMSG  MSG('Restore Data Areas') +
                        TOMSGQ(MRUNQ)
/**/
             CHGVAR  VAR(&TOPNTA) VALUE(&TOPNT)
/**/
/* RESTORE DATAAREA MMOD FROM FIRST 'DT' ENTRY BELONGING TO 'JS' ENTRY */
/**/
             RTVJRNE    JRN(ICJRN) RCVRNG(ICRCV001) FROMENT(&TOPNT) +
                          ENTTYP(DT) RTNSEQNBR(&RTNSQN) +
                          RTNJRNE(&RTNVAR)
/**/
/************IF*COND(%SST(&RTNVAR 7 10)**EQ*&TOPNTA)*THEN(DO)********  *E11514*/
             IF COND(%SST(&RTNVAR 132 10) *EQ &TOPNTA) THEN(DO)       /*E11514*/
/**/
/***************CHGVAR**VAR(&MMODA)*VALUE(%SST(&RTNVAR 13 256))******  *E11514*/
                CHGVAR  VAR(&MMODA) VALUE(%SST(&RTNVAR 142 256))      /*E11514*/
/**/
                CHGDTAARA DTAARA(MMOD) VALUE(&MMODA)
/**/
                CHGVAR VAR(&TOPNT) VALUE(&RTNSQN + 1)
             ENDDO
/**/
/* RESTORE DATA AREA MNATN FROM SECOND 'DT' ENTRY */
/**/
             RTVJRNE    JRN(ICJRN) RCVRNG(ICRCV001) FROMENT(&TOPNT) +
                          ENTTYP(DT) RTNSEQNBR(&RTNSQN) +
                          RTNJRNE(&RTNVAR)
/**/
/************IF*COND(%SST(&RTNVAR 7 10)**EQ &TOPNTA)*THEN(DO)********  *E11514*/
             IF COND(%SST(&RTNVAR 132 10) *EQ &TOPNTA) THEN(DO)       /*E11514*/
/**/
/***************CHGVAR**VAR(&MNATNA)*VALUE(%SST(&RTNVAR 13 5))*******  *E11514*/
                CHGVAR  VAR(&MNATNA) VALUE(%SST(&RTNVAR 142 5))       /*E11514*/
/**/
                CHGDTAARA DTAARA(MNATN) VALUE(&MNATNA)
/**/
                CHGVAR VAR(&TOPNT) VALUE(&RTNSQN + 1)
/**/
             ENDDO
                                                                      /*S01127*/
/**/
/* RESTORE DATA AREA REPSEQ FROM THIRD 'DT' ENTRY                      *S01117*/
/**/
             RTVJRNE    JRN(ICJRN) RCVRNG(ICRCV001) FROMENT(&TOPNT) +
                          ENTTYP(DT) RTNSEQNBR(&RTNSQN) +
                          RTNJRNE(&RTNVAR)                            /*S01117*/
/**/
             IF COND(%SST(&RTNVAR 132 10) *EQ &TOPNTA) THEN(DO)       /*S01117*/
/**/
                CHGVAR  VAR(&REPTNA) VALUE(%SST(&RTNVAR 142 5))       /*S01117*/
/**/
                CHGDTAARA DTAARA(REPSEQ) VALUE(&REPTNA)               /*S01117*/
/**/
                CHGVAR VAR(&TOPNT) VALUE(&RTNSQN + 1)                 /*S01117*/
/**/
             ENDDO                                                    /*S01117*/
                                                                      /*S01127*/
/**/                                                                  /*S01127*/
/**IF*FF*PRESENT*IN*THE*SYSTEM,*THE THIRD 'DT' ENTRY WILL HOLD S01127//*S01117*/
/* IF FF PRESENT IN THE SYSTEM, THE FOURTH 'DT' ENTRY WILL HOLD */    /*S01117*/
/* THE CONTENTS OF THE NACON DATA AREA    */                          /*S01127*/
/**/                                                                  /*S01127*/
             IF COND(%SST(&MMODA 50 1) *EQ 'Y') THEN(DO)              /*S01127*/
/**/                                                                  /*S01127*/
                RTVJRNE    JRN(ICJRN) RCVRNG(ICRCV001)              +
                             FROMENT(&TOPNT) ENTTYP(DT)             +
                             RTNSEQNBR(&RTNSQN) RTNJRNE(&RTNVAR)      /*S01127*/
/**/                                                                  /*S01127*/
                IF COND(%SST(&RTNVAR 132 10) *EQ &TOPNTA) THEN(DO)    /*S01127*/
/**/                                                                  /*S01127*/
                   CHGVAR  VAR(&NACONA) VALUE(%SST(&RTNVAR 142 6))    /*S01127*/
/**/                                                                  /*S01127*/
                   CHGDTAARA DTAARA(NACON) VALUE(&NACONA)             /*S01127*/
/**/                                                                  /*S01127*/
                   CHGVAR VAR(&TOPNT) VALUE(&RTNSQN + 1)              /*S01127*/
/**/                                                                  /*S01127*/
                ENDDO                                                 /*S01127*/
/**/                                                                  /*S01127*/
             ENDDO                                                    /*S01127*/
                                                                      /*S01127*/
/**/
/* RESTORE ALL OTHER DATA AREAS FROM FOLLOWING 'DT' ENTRIES */
/**/
 RETRIEVE:   RTVJRNE    JRN(ICJRN) RCVRNG(ICRCV001) FROMENT(&TOPNT) +
                          ENTTYP(DT) RTNSEQNBR(&RTNSQN) +
                          RTNJRNE(&RTNVAR)
/**/                                                                  /*E11514*/
/* END NORMALLY WHEN NO MORE 'DT' ENTRIES ARE FOUND                 *  *E11514*/
/**/                                                                  /*E11514*/
             MONMSG     MSGID(CPF7073) EXEC(GOTO CMDLBL(END))         /*E11514*/
/**/
/* CONTINUE TO PROCESS 'DT' ENTRIES UNTIL THEY NO LONGER CORRESPOND  */
/* TO THE RECOVERY POINT SELECTED                                    */
/**/
/************IF*COND(%SST(&RTNVAR 7 10)**EQ &TOPNTA)*THEN(DO)********  *E11514*/
             IF COND(%SST(&RTNVAR 132 10) *EQ &TOPNTA) THEN(DO)       /*E11514*/
/**/
/***************CHGVAR**VAR(&XXSTAT)*VALUE(%SST(&RTNVAR 13 256))*****  *E11514*/
                CHGVAR  VAR(&XXSTAT) VALUE(%SST(&RTNVAR 142 256))     /*E11514*/
/**/
/***************CHGDTAARA*DTAARA(%SST(&RTNVAR 1 6))*VALUE(&XXSTAT)***  *E11514*/
                CHGDTAARA DTAARA(%SST(&RTNVAR 126 6)) VALUE(&XXSTAT)  /*E11514*/
/**/
                CHGVAR VAR(&TOPNT) VALUE(&RTNSQN + 1)
/**/
                GOTO RETRIEVE
/**/
             ENDDO
/**/
             GOTO END
/**/
/*   ERROR PROCESSING                                                */
/**/
 /***ABNOR:******SNDPGMMSG  MSG('PROGRAM  Restore Data Areas - ENDED+ /*RT0159*/
 /***********             ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ +   /*RT0159*/
 /***********             MRUNQ)                                      /*RT0159*/
 ABNOR:                                                               /*RT0159*/
             SNDPGMMSG  MSG('PROGRAM  Restore Data Areas - ENDED +
                          ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)           /*RT0159*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*RT0159*/
             CALL       PGM(SDC0700) PARM('SDC1723' 'RSTDTARABN' ' +
                          ')                                          /*RT0159*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             GOTO END
END:         ENDPGM
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
