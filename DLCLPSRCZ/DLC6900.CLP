/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Interest and COF Accruals Report')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC6900 - Interest and Cost of Funds Accrual Report         */
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
/*       Prev Amend No. CAC001 *CREATE     Date 01FEB96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CAC001 - Profit Centre Accounting Development:              */
/*                New CL program.                                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(128)
             DCL        VAR(&QRYSEL) TYPE(*CHAR) LEN(50)
/**/
/**  Global Monitor Message:                                         */
/**   If an unmonitored message occurs perform error processing     */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
             CALL       PGM(AOMMODR0) PARM('*MSG  ' '*FIRST' &MMOD)
/**/
/**  If Analytical Accounting is not present, then end the program */
/**/
             IF         COND(%SST(&MMOD 100 1) *EQ 'N') THEN(DO)
                SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('DL +
                             Interest and Cost of Funds Accrual Report +
                             not allowed.  Analytical Accounting is not +
                             present') TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)
                GOTO       CMDLBL(END)
             ENDDO
/**/
/**  Create LDA if it does not already exist */
/**/
             SNDMSG     MSG('DLC6900 - Dealing Interest and Cost of +
                          Funds Accruals Report') TOMSGQ(MRUNQ)
             CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('MIDAS SD AS400 LOCAL +
                          DATA AREA EQUIVALENT'))
/**/
/**  Call report program */
/**/
             CHGJOB     SWS(00000000)
             CALL       PGM(DL6900) PARM(&RSEQ &RLEV &RENT)
/**/
/**  Database error processing */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 /**/
             GOTO       CMDLBL(END)
 /**/
 ABNOR:      DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          DLC6900 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 /**/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
