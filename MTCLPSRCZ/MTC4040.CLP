/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MT Intermediary msg file creation')             */
/*********************************************************************/
/*                                                                   */
/*     Midas - TELEX INTERFACE                               */
/*                                                                   */
/*     MTC4040 - INTERMEDIARY MESSAGE FILE CREATION                  */
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
/*     PREV AMEND NO.  00000      DATE 00XXX00                       */
/*                     00000      DATE 00XXX00                       */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*********************************************************************/
             PGM        PARM(&ERR)
 
             DCL        VAR(&ERR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MOD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global Monitor Message. */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Clear Intermediary Message File 'MTIMFPF' */
             CLRPFM     FILE(MTIMFPF)
 
/* Copy data from Journaled File 'MTJIMPF' to un-Journaled */
/* Intermediary Message File 'MTIMFPF' */
             CPYF       FROMFILE(MTJIMPF) TOFILE(MTIMFPF) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)
 
/* MOVE LIBRARY NAME TO (&DMLIB) */
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR    VAR(&MOD) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR    VAR(&DMLIB) VALUE(&MOD *CAT 'DMLIB')
 
             INCMSGF    FILE(MTIMFPF) LIBRARY(&DMLIB)
 
/* Clear Journaled File 'MTJIMPF' */
             CLRPFM     FILE(MTJIMPF)
 
             GOTO END
ABNOR:       CHGVAR     VAR(&ERR) VALUE('1')
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
