/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE CI communications program control')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail  Module                                      */
/*                                                                   */
/*       REC4401 - CI Communications Program Control                 */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CPK015             Date 25Feb02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      164273             Date 29Jul99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CCI001             Date 10NOV98              */
/*                      139595             Date 22Jul98              */
/*                      124644             Date 21Oct97              */
/*                      CRT003  *CREATE    Date 22JUL96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK015 - Move data queues fom XLIB to DPLIB.                */
/*       164273 - Change 'Cashier 8' references to 'Cashier'         */
/*       CCI001 - Midas Cashier Enhancements - dtaq RECASH in XLIB   */
/*                not DILIB                                          */
/*       139595 - APYJOBDLBL no longer core and not required.        */
/*       124644 - Correct the parameters passed to REC4411           */
/*       CRT003 - Branch Automation Interface.                       */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&UNID &USID)
 
             DCL        VAR(&UNID)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&USID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&JOBN)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&JBDQ)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRFX)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&XLIB)   TYPE(*CHAR) LEN(10)
/*********** DCL        VAR(&DPLIB)  TYPE(*CHAR) LEN(10)        */   /*CCI001*/
             DCL        VAR(&DTAQLIB) TYPE(*CHAR) LEN(10)                                 /*CPK015*/
             DCL        VAR(&RTCD)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&BAII)   TYPE(*CHAR) LEN(264)
             DCL        VAR(&PROD)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBQ)   TYPE(*CHAR) LEN(10)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&PRFX) VALUE(%SST(&UNID 1 2))
             CHGVAR     VAR(&XLIB) VALUE(&PRFX *CAT 'XLIB')
/*********** CHGVAR     VAR(&DPLIB) VALUE(&PRFX *CAT 'DPLIB')        /*CCI001*/
             CHGVAR     VAR(&DTAQLIB) VALUE(&PRFX *CAT 'DPLIB')                           /*CPK015*/
 
/* Create local data area */
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local data area')
             MONMSG     MSGID(CPF1023)
 
/*********** APYJOBDLBL JOBD(&XLIB/MIDASIC)                      */  /*139595*/
/*********** MONMSG    MSGID(CPF9999 CPF9898 CPF9810) EXEC(GOTO + */ /*139595*/
/***********              CMDLBL(ABNOR))                         */  /*139595*/
 
             RTVJOBA    NBR(&JOBN)
 
             CHGVAR     VAR(&JBDQ) VALUE('CASH' *CAT &JOBN)
/***********CRTDTAQ    DTAQ(&DPLIB/&JBDQ) MAXLEN(2560)       */       /*CCI001*/
/***********CRTDTAQ    DTAQ(&XLIB/&JBDQ) MAXLEN(2560)                          /*CCI001*/ /*CPK015*/
             CRTDTAQ    DTAQ(&DTAQLIB/&JBDQ) MAXLEN(2560)                                 /*CPK015*/
 
             CHGVAR     VAR(&OPTN) VALUE('*FIRST')
             CALL       PGM(AOBAIIR0) PARM(&RTCD &OPTN &BAII)
 
             IF         COND(&RTCD *NE '       ') THEN(DO)
/***********   CALL       PGM(REC4411) PARM('REC4401' &JOBN '0000' +
/***********              'USR0052' '   ' ' ' ' ')                    /*124644*/
               CALL       PGM(REC4411) PARM('REC4401' &JOBN '0000' +
                          '   ' 'USR0052' ' ')                        /*124644*/
               GOTO       CMDLBL(ABNOR)
             ENDDO
 
             CHGVAR     VAR(&PROD) VALUE(%SST(&BAII 15 10))
 
/**********  IF         COND((&RTCD *EQ '       ') *AND +
/**********               (&PROD *EQ 'CASHIER 8 ')) THEN(DO) */       /*164273*/
             IF         COND((&RTCD *EQ '       ') *AND +
                          (&PROD *EQ 'CASHIER   ')) THEN(DO)          /*164273*/
               CHGVAR   VAR(&JOBQ) VALUE(%SST(&BAII 58 10))
 
               ADDICFDEVE FILE(RE4401CM) PGMDEV(CIPGMD) +
                            RMTLOCNAME(*REQUESTER) CMNTYPE(*APPC)
               MONMSG     MSGID(CPF7365)
 
               TFRJOB     JOBQ(&XLIB/&JOBQ) RTGDTA('CASHIER')
               GOTO     CMDLBL(END)
             ENDDO
 
 ABNOR:
/*********** DLTDTAQ    DTAQ(&DPLIB/&JBDQ)                   */       /*CCI001*/
/************DLTDTAQ    DTAQ(&XLIB/&JBDQ)                                      /*CCI001*/ /*CPK015*/
             DLTDTAQ    DTAQ(&JBDQ)                                                       /*CPK015*/
             MONMSG     MSGID(CPF0001)
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('Cashier Communications Program REC4401 +
                          Ended Abnormally') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF2469) EXEC(DO)
                        SNDPGMMSG MSG('Cashier Communications Program +
                          REC4401 Ended Abnormally') TOMSGQ(QSYSOPR)
                        ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
