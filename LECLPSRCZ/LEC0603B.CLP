/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Euro Currency Conversion of Repayments')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC0603B - Midas LE Euro Currency Conversion of Repayments  */
/*                                                                   */
/*       Calls :   LE0391 - Repayment Schedule Euro Ccy Conversion   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CEU020  *CREATE    Date 02Apr98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CEU020 - EMU LE Multi-Currency Rollover                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
/*/COPY WNCPYSRC,mmCnnnnINT                                          */
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
/** Check LDA if existing */
/**/
             CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                          CRTDTAARA  DTAARA(QTEMP/LDA)  +
                          TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('MIDAS LE AS400 LOCAL +
                          DATA AREA EQUIVALENT')
             ENDDO
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
/**/
/** Initialize job switches */
/**/
             CHGJOB     SWS(XXXXXX00)
 
             SNDPGMMSG  MSG('Euro Currency Conversion of +
                          Repayments') TOMSGQ(MRUNQ)
 
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
             IF         COND(&STAT *EQ 'N') THEN(DO)
                CPYF       FROMFILE(LAUPDDK) TOFILE(XLAUPDDK) +
                           MBROPT(*REPLACE) FMTOPT(*MAP)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XLAUPDDK)
                CPYF       FROMFILE(LAUPDZ1) TOFILE(XLAUPDZ1) +
                           MBROPT(*REPLACE) FMTOPT(*MAP)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XLAUPDZ1)
                CPYF       FROMFILE(ACTN3DK) TOFILE(XACTN3DK) +
                           MBROPT(*REPLACE) FMTOPT(*MAP)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XACTN3DK)
                CPYF       FROMFILE(ROLRECS) TOFILE(XROLRECS) +
                           MBROPT(*REPLACE) FMTOPT(*MAP)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM XROLRECS)
                CHGVAR     VAR(&STAT) VALUE('Y')
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
                ENDDO
 
             ELSE (DO)
                CPYF       FROMFILE(XLAUPDDK) TOFILE(LAUPDDK) +
                           MBROPT(*REPLACE) FMTOPT(*MAP)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM LAUPDDK)
                CPYF       FROMFILE(XLAUPDZ1) TOFILE(LAUPDZ1) +
                           MBROPT(*REPLACE) FMTOPT(*MAP)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM LAUPDZ1)
                CPYF       FROMFILE(XACTN3DK) TOFILE(ACTN3DK) +
                           MBROPT(*REPLACE) FMTOPT(*MAP)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM ACTN3DK)
                CPYF       FROMFILE(XROLRECS) TOFILE(ROLRECS) +
                           MBROPT(*REPLACE) FMTOPT(*MAP)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM ROLRECS)
             ENDDO
 
             CALL       PGM(LE0391)
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
                GOTO       CMDLBL(END)
             ENDDO
/**/
/* Clear all copy files */
/**/
             CLRPFM     FILE(XLAUPDDK)
             CLRPFM     FILE(XLAUPDZ1)
             CLRPFM     FILE(XACTN3DK)
             CLRPFM     FILE(XROLRECS)
             CHGVAR     VAR(&STAT) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
 
/*/COPY WNCPYSRC,mmCnnnnMPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            LEC0603B ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
