/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas TI COB shadow posting of TI postings')          */
/*********************************************************************/
/*                                                                   */
/*       Midas/TI Interface                                          */
/*                                                                   */
/*       TIC0370 - TI COB Shadow posting of forward dated TI postings*/
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 139756             Date 18Feb99              */
/*                      CTI001  *CREATE    Date 27Aug97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       139756 - Commitment control scope incorrect                 */
/*       CTI001 - Midas/TI Interface (Phase 1)                       */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10) VALUE('TIC0370')
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0) VALUE(1)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(1)
/*/COPY WNCPYSRC,TIC0370001                                          */
 
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
/* Start commitment control for batch jobs with file updates */
             IF         COND(&JOBTYPE = '0') THEN(DO)
/***************STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))      */ /*139756*/
                STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*139756*/
             ENDDO
 
             CHGJOB     SWS(XXXXXX00)
 
             SNDPGMMSG  MSG('TIC0370 - TI COB Shadow posting of TI +
                          Postings') TOMSGQ(MRUNQ)
 
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas Local Data Area'))
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
             CHGVAR     VAR(&DMLIB) VALUE(&PREFIX *CAT 'DMLIB')
/*/COPY WNCPYSRC,TIC0370002                                          */
 
/*  Check the status of restart flag  */
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &BUSY)
 
/*  If this is not a restart  */
             IF         COND(&BUSY *EQ 'N') THEN(DO)
             CLRPFM     FILE(&DMLIB/XMEMOS)
             MONMSG     MSGID(CPF3142) EXEC(CRTDUPOBJ OBJ(MEMOS) +
                          FROMLIB(&DMLIB) OBJTYPE(*FILE) +
                          NEWOBJ(XMEMOS))
             CPYF       FROMFILE(MEMOS) TOFILE(XMEMOS) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
             CLRPFM     FILE(&DMLIB/XRSACMT)
             MONMSG     MSGID(CPF3142) EXEC(CRTDUPOBJ OBJ(RSACMTPD) +
                          FROMLIB(&DMLIB) OBJTYPE(*FILE) +
                          NEWOBJ(XRSACMT))
             CPYF       FROMFILE(RSACMTPD) TOFILE(XRSACMT) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
/*/COPY WNCPYSRC,TIC0370003                                          */
 
 
/*  Update status to 'Y' in case component fails to update the file */
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ 'Y')
             ENDDO
 
/*  This is a restart  */
             ELSE       CMD(DO)
             CLRPFM     FILE(&DMLIB/MEMOS)
             CPYF       FROMFILE(XMEMOS) TOFILE(MEMOS) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
             CLRPFM     FILE(&DMLIB/RSACMTPD)
             CPYF       FROMFILE(XRSACMT) TOFILE(RSACMTPD) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
/*/COPY WNCPYSRC,TIC0370004                                          */
             ENDDO
 
/*  Main processing  */
             CALL       PGM(TI0370) PARM(&RTNCDE)
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
             COMMIT
             DLTF       FILE(XMEMOS)
             DLTF       FILE(XRSACMT)
/*/COPY WNCPYSRC,TIC0370005                                          */
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ 'N')
             GOTO       CMDLBL(ENDPGM)
             ENDDO
 
 
/* Abnormal termination processing */
ABNOR:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('TIC0370 - TI COB Shadow posting of TI +
                          Postings terminated abnormally') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&LDA)
             MONMSG     MSGID(CPF0000)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&LDA) +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000)
             ROLLBACK
             MONMSG     MSGID(CPF0000)
 
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
