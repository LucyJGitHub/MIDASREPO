/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL OIS Housekeeping for DLDOISPD')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC1659 - OIS Housekeeping for DLDOISPD                     */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CIR007  *CREATE    Date 11May01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
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
 
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
 
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')
 
             CHGVAR     VAR(&STAT) VALUE(' ')
 
/** Check if restart flag is 'Y'                                   */
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
 
/** If restart, Copy back the saved deals extension file           */
             IF         COND(&STAT = 'Y') THEN(DO)
             CPYF       FROMFILE(DLDOISPDX1) TOFILE(DLDOISPD) +
                          TOMBR(*FROMMBR) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(DLDOISPD))
 
             ENDDO
 
             DLTF       FILE(&TOLIB/DLDOISPDX1)
             MONMSG     MSGID(CPF0000)
 
/** Make a copy of the deal extension file DLDOISPD                */
             CPYF       FROMFILE(DLDOISPD) TOFILE(&TOLIB/DLDOISPDX1) +
                          TOMBR(*FROMMBR) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
 
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
             CHGVAR     VAR(&STAT) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
 
             CALL       PGM(DL1659)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          DL1659 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)  MSGTYPE(*INFO)
                GOTO    CMDLBL(ENDPGM)
 
             ENDDO
 
/** Successful Completion - Clear Saved extension file             */
             CHGVAR     VAR(&STAT) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
 
             DLTF       FILE(&TOLIB/DLDOISPDX1)
             MONMSG     MSGID(CPF0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
 ENDPGM:     ENDPGM
