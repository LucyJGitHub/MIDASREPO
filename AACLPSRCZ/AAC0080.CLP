/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AA Transactions by profit centre control pgm')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Analytical Accounting Module                        */
/*                                                                   */
/*       AAC0080 - Transactions by Profit Centre Control Program     */
/*                                                                   */
/*       Function:  This program will list all transactions which    */
/*                  uses the unallocated profit centre.              */
/*                                                                   */
/*       Calls:     AA0080 - Transactions by Profit Centre List      */
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
/*       Prev Amend No. 124823 *CREATE     Date 08Aug97              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       124823 - Provide a report for transactions by profit centre */
/*                New report program.                                */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&RSEQ &RLEV &RENT)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RSEQ)   TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&MEM)    TYPE(*CHAR) LEN(50)
             DCL        VAR(&MMOD)   TYPE(*CHAR) LEN(128)
/**/
/**  Global Monitor Message:                                         */
/**   If an unmonitorred message occurs perform error processing     */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
             CALL       PGM(AOMMODR0) PARM('      ' '*FIRST' &MMOD)
/**/
/**  If Analytical Accounting is not present, then end the program */
/**/
             IF         COND(%SST(&MMOD 100 1) *EQ 'N') THEN(DO)
                GOTO       CMDLBL(END)
             ENDDO
/**/
/**  Create LDA if it does not already exist */
/**/
             SNDMSG     MSG('AAC0080 - Transactions by Profit Centre +
                          Audit List') TOMSGQ(MRUNQ)
             CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD AS400 local +
                          data area equivalent'))
/**/
             OVRDBF     FILE(TTRANL1) MBR(*ALL)
/**/
/**  Call report program  */
/**/
             CHGJOB     SWS(00000000)
             CALL       PGM(AA0080) PARM(&RSEQ &RLEV &RENT)
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
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 /**/
 ABNOR:      DMPCLPGM
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          AAC0080 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 /**/
 END:        DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000)
             ENDPGM
