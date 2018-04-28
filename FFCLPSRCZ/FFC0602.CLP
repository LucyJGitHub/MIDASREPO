/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Audit Reports (COB)')                        */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                    */
/*                                                                   */
/*   FFC0602  -  AUDIT REPORTS (COB)                                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   LAST AMEND NO. S01117             DATE 30JAN90                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*   S01117  -  MULTIBRANCHING                                       */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
/*   DECLARE VARIABLES                                              */
/**/
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&ERRPGM) TYPE(*CHAR) LEN(8)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/* Set switches for audit report                                    */
/**/
             CHGJOB     SWS(0X1XXXXX)
/**/
/* Audit message to MRUNQ                                           */
/**/
             SNDPGMMSG  MSG('FFC0602 - +
                          Audit Reports') TOMSGQ(MRUNQ)
/**/
/* Reset journal entries extract file                               */
/**/
             CLRPFM     FILE(JRNCGD)
/**/
/*  Override FFAUD to Share(*no) to allow opening for Input in +
    calling program and for Update in called program.               */
/**/
             OVRDBF     FILE(FFAUD) SHARE(*NO)
/**/
/*  Override JRNCGD to Share(*no) to allow opening for Input in +
/*  calling program and for Update in called program.               */
/**/
             OVRDBF     FILE(JRNCGD) SHARE(*NO)
/**/
/* Call Audit control program - loops to process all audit files    */
/**/
             CALL       PGM(FF0550) PARM(&ERRPGM)
/**/
             DLTOVR     FILE(FFAUD)
/**/
/* If all calls ended normally goto end.                            */
/**/
             IF  COND( %SWITCH(XXXXXX00)) THEN(GOTO END)
/**/
/* If U8 on - file controls out of balance                          */
/**/
             IF  COND( %SWITCH(XXXXXX01)) THEN(DO)
             SNDPGMMSG  MSG('FFC0602 -  File Controls Out Of Balance +
                        For File ' *bcat &ERRPGM) TOPGMQ(*EXT) +
                        TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
/*     Database error processing. Send message to MOPERQ & WORKSTN  */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*********** RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)          */ /*S01117*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                        TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
 END:        RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
/**/
