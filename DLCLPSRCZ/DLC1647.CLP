/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL OIS Deals Details File Maintenance')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC1647 - OIS Deal Details File Maintenance Control         */
/*                                                                   */
/*                 Calls program DL1647 during COB to write          */
/*                 records to DLDOISPD and update DEALSDG            */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. 204923             Date 29Apr02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CIR007  *CREATE    Date 11May01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       204923 - Rate Fix Days Adjustment (OIS)                     */
/*       CIR007 - Overnight Index Swaps                              */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
 
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Create LDA if not present */
 
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                        CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                                   AUT(*EXCLUDE)
                        ENDDO
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
 
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')
 
 
             CHGVAR     VAR(&STAT) VALUE(' ')
 
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
 
 
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
 
/* If restart, Copy back the saved data from the Deals and the      */
/* Deals Extension file.                                            */
 
             IF         COND(&STAT = 'Y') THEN(DO)
 
             CPYF       FROMFILE(&TOLIB/DLDOISPDX1) TOFILE(DLDOISPD) +
                          TOMBR(*FROMMBR) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(DLDOISPD))
 
             CPYF       FROMFILE(&TOLIB/DEALSDGX1) TOFILE(DEALSDG) +
                          TOMBR(*FROMMBR) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(DEALSDG))
             ENDDO
 
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
 
             DLTF       FILE(&TOLIB/DLDOISPDX1)
             MONMSG     MSGID(CPF0000)
 
             DLTF       FILE(&TOLIB/DEALSDGX1)
             MONMSG     MSGID(CPF0000)
 
/* Make a copy of the deal extension file DLDOISPD                   */
 
             CPYF       FROMFILE(DLDOISPD) TOFILE(&TOLIB/DLDOISPDX1) +
                          TOMBR(*FROMMBR) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
 
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
/* Make a copy of the deal file DEALSDG                              */
 
             CPYF       FROMFILE(DEALSDG) TOFILE(&TOLIB/DEALSDGX1) +
                          TOMBR(*FROMMBR) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
 
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
 
             CHGVAR     VAR(&STAT) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
 
             CALL       PGM(DL1671)                                                       /*204923*/
                                                                                          /*204923*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                  /*204923*/
                 SNDPGMMSG  MSG('Job Terminated - Database in Error') +
                             TOMSGQ(MOPERQ)                                               /*204923*/
                 GOTO       CMDLBL(ABNOR)                                                 /*204923*/
             ENDDO                                                                        /*204923*/
                                                                                          /*204923*/
             CALL       PGM(DL1647)
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
/* Successful Completion - Clear Saved Deals and Deals Extension File*/
 
             CHGVAR     VAR(&STAT) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
 
             DLTF       FILE(&TOLIB/DLDOISPDX1)
             MONMSG     MSGID(CPF0000)
 
             DLTF       FILE(&TOLIB/DEALSDGX1)
             MONMSG     MSGID(CPF0000)
 
                GOTO    CMDLBL(ENDPGM)
 
             ENDDO
 
 ABNOR:      SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          DL1647 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)  MSGTYPE(*INFO)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
 
 ENDPGM:     ENDPGM
 
 
