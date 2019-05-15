/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas TI Postings purge control')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Trade Inovation (TI) Module                         */
/*                                                                   */
/*       TIC0380 - Midas/TI COB TI Postings Purge                    */
/*                                                                   */
/*       Function: This program calls TI0380 in the COB to 'drop'    */
/*                 TI postings from file LF/TIPOSTL0 with a value    */
/*                 date prior to the next business day.              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 228542             Date 10Aug04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      139756             Date 18Feb99              */
/*                      CTI001  *CREATE    Date 16Jul97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       139756 - Commitment control scope incorrect                 */
/*       CTI001 - Midas / Trade Innovation Interface Phase 1         */
/*                                                                   */
/*********************************************************************/
 
/* Component Name and Component Sequence                                      */
 
             PGM        PARM(&PCNAM &PCSEQ)
 
             DCL        VAR(&PCNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PCSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&LIBPRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/* Start commitment control for batch jobs with file updates */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
/***************STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))      */ /*139756*/
                STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*139756*/
             ENDDO
 
/* Start commitment control for batch jobs with file updates */
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('TI0380 +
                          TI Postings Purge') TOMSGQ(MRUNQ)
 
/* Set up 'DP' library                                       */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LIBPRE)
             CHGVAR     VAR(&DPLIB) VALUE(&LIBPRE *CAT 'DPLIB')
 
/* Get COB component restart status and file backups or backup files      */
             CALL       PGM(CB0160) PARM(&PCNAM &PCSEQ &STAT)
 
             IF         COND(&STAT *EQ 'Y') THEN(DO)
             CPYF       FROMFILE(&DPLIB/XTIPOSTPD) TOFILE(TIPOSTPD) +
                          MBROPT(*REPLACE)
             ENDDO
             ELSE       CMD(DO)
             CPYF       FROMFILE(TIPOSTPD) TOFILE(&DPLIB/XTIPOSTPD) +
                          MBROPT(*ADD) CRTFILE(*YES)
             CHGVAR     VAR(&STAT) VALUE('Y')
             CALL       PGM(CB0150) PARM(&PCNAM &PCSEQ &STAT)
             ENDDO
 
             CHGJOB     SWS(00000000)
 
             CALL       PGM(TI0380)
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 /* Change data area TIBATCH, which contains the next available */
 /* batch number, to blank  */
             CHGDTAARA  DTAARA(TIBATCH) VALUE(' ')
/**********  RGZPFM     FILE(TIPOSTPD)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF2981)                                                    /*228542*/
             CALL       PGM(SCC000060) PARM('TIPOSTPD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
                                                                                          /*228542*/
             DLTF       FILE(&DPLIB/XTIPOSTPD)
             CHGVAR     VAR(&STAT) VALUE('N')
             CALL       PGM(CB0150) PARM(&PCNAM &PCSEQ &STAT)
             GOTO       CMDLBL(END)
             ENDDO
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                ROLLBACK
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('TI0380 +
                          TI Postings Purge Failed') TOMSGQ(MOPERQ)
 
             GOTO       CMDLBL(END)
             ENDDO
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          TIC0380 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
 
             ENDPGM
