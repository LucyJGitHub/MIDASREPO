/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Guarantees/Securities Review Report')        */
/*********************************************************************/
/*                                                                  */
/*       Midas - LEC1005R - Customer Lending                         */
/*                                                                  */
/*       LEC1005R - GUARANTEES/SECURITY/REVIEW REPORT               */
/*           CREATED FOR FIX 116180 BASED ON LEC1005.               */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. 116180 *CREATE*     DATE 18Jun98            */
/*       Prev Amend No. XXXXXX              DATE DDMmmYY            */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       116180 - Allow report to be on request rather than monthly.*/
/*                LEC1005 has been changed only to run the extract  */
/*                LE0960 and update the GTEES file. This program has*/
/*                been written to run LE0960 & LE0970 but not to    */
/*                update GTEES. This component must be run before   */
/*                LEC1005 which is still only run at Month End.     */
/*                Applied fix 073739.                               */
/*                                                                  */
/********************************************************************/
/**/
             PGM        PARM(&RSEQ &RLEV &RENT)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) +
                        VALUE('GUARANTEES/SECURITY/REVIEW +
                        REPORT')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*DEC) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
                CLRPFM     FILE(GTUPDHH)       /* NEW LF/GTEES FILE */
                CLRPFM     FILE(GTUPDGT)       /* OUTPUT FROM LE0960*/
                CLRPFM     FILE(GTUPDZZ)
/**/
                CLRPFM     FILE(GTEXTHH)       /* LF/GTEXT FILE     */
                CLRPFM     FILE(GTEXTGX)       /* OUTPUT FROM LE0960*/
                CLRPFM     FILE(GTEXTZZ)
/**/
                SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
/**/
                CALL       PGM(LE0960)
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
/**/
                IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/* POSITION FILE TO THE PARTICULAR ENTITY                                     */
             IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) +
             THEN(DO)
                 OVRDBF    FILE(SGTEX) POSITION(*KEY 1 GTEXTGXF +
                           &RENT)
                 OPNDBF    FILE(SGTEX) OPTION(*ALL)
                 MONMSG    MSGID(CPF0000) EXEC(DO)
                     DLTOVR     FILE(SGTEX)
                 ENDDO
             CLOF       OPNID(SGTEX)
             MONMSG     MSGID(CPF0000)
             ENDDO
             CALL       PGM(LE0970) PARM(&RSEQ &RENT)
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
                   CLRPFM     FILE(GTUPDHH)
                   CLRPFM     FILE(GTUPDGT)
                   CLRPFM     FILE(GTUPDZZ)
/**/
                   CLRPFM     FILE(GTEXTHH)
                   CLRPFM     FILE(GTEXTGX)
                   CLRPFM     FILE(GTEXTZZ)
/**/
             ENDDO
/**/
             CLOF       OPNID(SGTEX)
             MONMSG     MSGID(CPF0000)
/**/
             GOTO       CMDLBL(END)
/**/
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          LEC1005R ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
