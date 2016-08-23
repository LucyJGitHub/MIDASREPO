/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE CI branch monitor status control')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail  Module                                      */
/*                                                                   */
/*       REC4405 - CI Branch Monitor Status Control                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Note:   REC4405 must reside in the same library as REC4402. */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*       Last Amend No. 164273             Date 29Jul99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 139595             Date 22Jul98              */
/*                      124644             Date 21Oct97              */
/*                      118134             Date 02Jun97              */
/*                      CRT003  *CREATE    Date 22JUL96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       164273 - Change 'Cashier 8' references to 'Cashier'         */
/*       139595 - APYJOBDLBL no longer core and not required.        */
/*       124644 - Pass correct parameters to REC4411                 */
/*       118134 - Correct ABNOR processing to ensure termination.    */
/*       CRT003 - Branch Automation Interface.                       */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&BRCH &USID &UNID &ACTION)
 
             DCL        VAR(&BRCH)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&USID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&UNID)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(5)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&JOBN)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&PRFX)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&XLIB)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&DMLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&DPLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&BRCA)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&RTCD)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&BAII)   TYPE(*CHAR) LEN(264)
             DCL        VAR(&PROD)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBQ)   TYPE(*CHAR) LEN(10)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&PRFX) VALUE(%SST(&UNID 1 2))
             CHGVAR     VAR(&BRCA) VALUE(%SST(&BRCH 1 3))
             CHGVAR     VAR(&XLIB) VALUE(&PRFX *CAT 'XLIB')
             CHGVAR     VAR(&DMLIB) VALUE(&PRFX *CAT 'DMLIB')
             CHGVAR     VAR(&DPLIB) VALUE(&PRFX *CAT 'DPLIB')
 
 
/* Create local data area */
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local data area')
             MONMSG     MSGID(CPF1023)
 
             CHGDTAARA  DTAARA(QTEMP/LDA (1 3)) VALUE(&BRCA)
 
/**********  APYJOBDLBL JOBD(&XLIB/MIDASIC)                    ****/  /*139595*/
 
             RTVJOBA    NBR(&JOBN)
 
             CHGVAR     VAR(&OPTN) VALUE('*FIRST')
             CALL       PGM(AOBAIIR0) PARM(&RTCD &OPTN &BAII)
 
             IF         COND(&RTCD *NE '       ') THEN(DO)
/***********   CALL       PGM(REC4411) PARM('REC4405' &JOBN '0000' +
/***********              'USR0052' '   ' ' ' ' ')                    /*124644*/
               CALL       PGM(REC4411) PARM('REC4405' &JOBN '0000' +
                          &BRCA 'USR0052' ' ')                        /*124644*/
               GOTO       CMDLBL(ABNOR)
             ENDDO
 
             CHGVAR     VAR(&PROD) VALUE(%SST(&BAII 15 10))
 
/**********  IF         COND((&RTCD *EQ '       ') *AND +
/**********               (&PROD *EQ 'CASHIER 8 ')) THEN(DO) */       /*164273*/
             IF         COND((&RTCD *EQ '       ') *AND +
                          (&PROD *EQ 'CASHIER   ')) THEN(DO)          /*164273*/
               CHGVAR   VAR(&JOBQ) VALUE(%SST(&BAII 58 10))
               TFRJOB     JOBQ(&XLIB/&JOBQ) RTGDTA('BM STATUS')
               GOTO     CMDLBL(END)
             ENDDO
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('CI Branch Monitor Status Program REC4405 +
                          Ended Abnormally') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF2469)  EXEC(DO)                      /*118134*/
                SNDPGMMSG  MSG('CI Branch Monitor Status Program REC4405 +
                             Ended Abnormally') TOMSGQ(QSYSOPR)       /*118134*/
             ENDDO                                                    /*118134*/
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
 ENDPGM:     ENDPGM
