/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ED Export data drip feed housekeeping')         */
/********************************************************************/
/*                                                                  */
/*       Midas - Midas Export Data Module                           */
/*                                                                  */
/*       EDC0100 - Drip Feed Housekeeping                           */
/*                                                                  */
/*       Function : This program receives parameter PBTCH (batch to */
/*                  be processed) and removes the member with the   */
/*                  same name.                                      */
/*                                                                  */
/*       Called by : COB Process                                    */
/*                                                                  */
/*       Calls :    CB0150                                          */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 228542             Date 05Aug04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      113682             Date 04Feb98              */
/*                      101971             Date 17Jul95              */
/*                      S01408             DATE 19JUN95             */
/*                      S01493 *CREATE     DATE 16MAY94             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       228542 - RGZPFM has changed at R5V3                        */
/*       113682 - Error messages should be sent to MOPERQ not       */
/*                QSYSOPR.                                          */
/*       101971 - Phase II Modifications                            */
/*       S01408 - Addition of core hook EDC0100MP1                  */
/*       S01493 - Midas Export Data Module                          */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
/* Copyright statement definition */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
 
/* Global error monitor and other initial actions */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
             CHGJOB     SWS(00000000)
 
             SNDPGMMSG  MSG('EDC0100 - Midas Export Data Drip Feed +
                          Housekeeping') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,EDC0100MP1                                          */
                                                                      /*S01408*/
/* Check for component restart */
 
             CHGVAR     VAR(&BUSY) VALUE(' ')
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &BUSY)
 
             IF         COND(&BUSY *EQ 'Y') THEN(DO)
               CPYF       FROMFILE(XEDDFAUPD) TOFILE(EDDFAUPD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                            FILE(EDDFAUPD))
             ENDDO
 
/* Delete copy file */
 
             DLTF       FILE(XEDDFAUPD)
             MONMSG     MSGID(CPF0000)
 
/* and copy file */
 
             CPYF       FROMFILE(EDDFAUPD) TOFILE(&TOLIB/XEDDFAUPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XEDDFAUPD))
 
/* Process PF/EDDFAUPD by calling ED0100 */
 
             CHGVAR     VAR(&BUSY) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &BUSY)
 
/*********** CALL       ED0100                                        /*101971*/
             CALL       PGM(ED0101)                                   /*101971*/
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
/* Housekeeping for files */
 
/**********  RGZPFM     FILE(EDDFAUPD)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF2981 CPF2995)                                            /*228542*/
             CALL       PGM(SCC000060) PARM('EDDFAUPD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
 
/**********  RGZPFM     FILE(EDSAVEPD)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF2981 CPF2995)                                            /*228542*/
             CALL       PGM(SCC000060) PARM('EDSAVEPD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
 
/**********  RGZPFM     FILE(EDLASTPD)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF2981 CPF2995)                                            /*228542*/
             CALL       PGM(SCC000060) PARM('EDLASTPD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
 
/* Update DTAARA/EDDRIP - RESET LAST JOURNAL SEQUENCE NO. TO ZERO. */
/*                        LAST BATCH NO. IS NOT INITIALISED.  THIS */
/*                        IS SO THAT OLD BATCH NAMES ARE NOT DUP-  */
/*                        LICATED.                                 */
 
/***CHGDTAARA**DTAARA(*LIBL/EDDRIP (1 10)) VALUE('0000000000')      /*101971*/
             CHGDTAARA  DTAARA(*LIBL/EDDRIP (1 10)) +
                          VALUE('0000000001')                       /*101971*/
 
/* Copyright statement definition - at runtime */
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             CHGVAR     VAR(&BUSY) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &BUSY)
 
             GOTO       CMDLBL(ENDCLPGM)
 
 /* Error processing */
 
ABNOR:
/*113682*****SNDPGMMSG  MSG('EDC0100 Midas Export Data Drip Feed +
                          Housekeeping TERMINATED ABNORMALLY') +
                          TOMSGQ(*SYSOPR) MSGTYPE(*INQ)              /*113682*/
             SNDPGMMSG  MSG('EDC0100 Midas Export Data Drip Feed +
                          Housekeeping TERMINATED ABNORMALLY') +
                          TOMSGQ(MOPERQ MRUNQ)                       /*113682*/
 
             MONMSG     MSGID(CPF0000 MCH0000)
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                CHGJOB     SWS(XXXXXX11)
                MONMSG     MSGID(CPF0000 MCH0000)
                DMPCLPGM
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
ENDCLPGM:
             ENDPGM
