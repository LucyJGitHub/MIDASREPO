/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Convert SWIFT BIC Bank file')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Message Management Module                   */
/*                                                                   */
/*       MEC1410  - Convert SWIFT BIC Bank file to MEBICDPD          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CFT002             Date 20Nov98              */
/*                      S01435             Date 26Nov93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CFT002 - Straight Through Processing Phase 1                */
/*       S01435 - Incoming Message Management                        */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTN_CODE)
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&NBR_RCDS) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBR_RCD2) TYPE(*DEC) LEN(10 0)           /*CFT002*/
/*/COPY WNCPYSRC,MEC1410001                                          */
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/* */
/* Set switches */
/* */
             CHGJOB     SWS(XXXXX000)
/*/COPY WNCPYSRC,MEC1410002                                          */
/* */                                                                 /*CFT002*/
/* Test to see if MEBICDF has data */                                 /*CFT002*/
/* */                                                                 /*CFT002*/
             RTVMBRD    FILE(MEBICDF) NBRCURRCD(&NBR_RCD2)            /*CFT002*/
             IF         COND(&NBR_RCD2 *EQ 0) THEN(DO)                /*CFT002*/
/* */
/* Test to see if MEBANKF has data */
/* */
             RTVMBRD    FILE(MEBANKF) NBRCURRCD(&NBR_RCDS)
             IF         COND(&NBR_RCDS *EQ 0) THEN(GOTO +
                          CMDLBL(ENDCLPGM))
             ENDDO                                                    /*CFT002*/
/*/COPY WNCPYSRC,MEC1410003                                          */
/* */
/* Send message */
/* */
             SNDPGMMSG  MSG('MEC1410 - Convert SWIFT BIC Bank File') +
                          TOMSGQ(MRUNQ)
/* */
/* Clear file */
/* */
             CLRPFM     FILE(MEBICDPD)
/* */                                                                 /*CFT002*/
/* If no records in MEBICDF then convert MEBANKF */                   /*CFT002*/
/* */                                                                 /*CFT002*/
             IF         COND(&NBR_RCD2 *EQ 0) THEN(DO)                /*CFT002*/
/* */                                                                 /*CFT002*/
/*/COPY WNCPYSRC,MEC1410004                                          */
/* */
/* Run ME1410 - for copy  */
/* */
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/* */
             CALL       PGM(ME1410) PARM(&RTN_CODE)
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/* */
/* Clear bank file if return code not blank */
/* */
             IF         COND(&RTN_CODE *EQ '       ') THEN(DO)
             CLRPFM     FILE(MEBANKF)
             ENDDO
             ENDDO                                                    /*CFT002*/
/* */                                                                 /*CFT002*/
/* If records in MEBICDF then convert */                              /*CFT002*/
/* */                                                                 /*CFT002*/
             IF         COND(&NBR_RCD2 *GT 0) THEN(DO)                /*CFT002*/
             CPYF       FROMFILE(MEBICDF) TOFILE(MEBICDPD) +
                          MBROPT(*ADD) INCCHAR(*RCD 1 *EQ 'FI') +
                          FMTOPT(*NOCHK)                              /*CFT002*/
/* */                                                                 /*CFT002*/
/* Clear bank file if return code not blank */                        /*CFT002*/
/* */                                                                 /*CFT002*/
             CLRPFM     FILE(MEBICDF)                                 /*CFT002*/
                                                                      /*CFT002*/
             ENDDO                                                    /*CFT002*/
/**/
/*/COPY WNCPYSRC,MEC1410005                                          */
/**/
             GOTO       CMDLBL(ENDCLPGM)
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program MEC1410 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MEC1410 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
