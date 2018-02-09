/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF I/C Posn Close Out Rpt - Prompt')            */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                    */
/*                                                                   */
/*   FFC0322P  -  POSITION CLOSE OUT REPORT ( INTERIM ) - PROMPT     */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*   Last Amend No. MD046248           Date 27Oct17                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   PREV AMEND NO. E44850             DATE 17SEP92                  */
/*                  FO0045             DATE 26MAR90                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*   MD046248 - Finastra Rebranding                                  */
/*   E44850      - If report requested for market OTC a parm.        */
/*               - mismatch occurs in RCF component FCC0200.         */
/*   FO0045  -  New Prompt Program for report program - required     */
/*              because of R10 RCF changes.                          */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM &RACT &RCMD)
/**/
/*   DECLARE VARIABLES                                              */
/**/
             DCL        VAR(&RSEQ)   TYPE(*CHAR)  LEN(5)
             DCL        VAR(&RLEV)   TYPE(*CHAR)  LEN(1)
             DCL        VAR(&RENT)   TYPE(*CHAR)  LEN(3)
             DCL        VAR(&RPARM)  TYPE(*CHAR)  LEN(100)
             DCL        VAR(&RACT)   TYPE(*CHAR)  LEN(1)
             DCL        VAR(&RCMD)   TYPE(*CHAR)  LEN(1)
             DCL        VAR(&MEM)    TYPE(*CHAR)  LEN(50)
             DCL        VAR(&PMRKT)  TYPE(*CHAR)  LEN(2)
             DCL        VAR(&PHEAD)  TYPE(*CHAR)  LEN(30)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
             CHGJOB     SWS(10000000)
/**/
/*   CALL MARKET CENTRE PROMPT PROGRAM                              */
/**/
             CHGVAR     VAR(&PHEAD) VALUE('POSITION CLOSE OUT REPORT')
             CALL       PGM(FF1265) PARM(&PMRKT &PHEAD)
/**/
/* UPDATE RCMD PARAMETER IF F3 OR F12 OPTIONS TAKEN BY USER         */
/**/
             IF         COND(&PMRKT *EQ '03') THEN(CHGVAR VAR(&RCMD) +
                          VALUE('E'))
             IF         COND(&PMRKT *EQ '12') THEN(CHGVAR VAR(&RCMD) +
                          VALUE('F'))
/**/
/* IF F3 OR F12 OPTIONS TAKEN, DEALLOCATE DATAAREA AND EXIT         */
/**/
             IF         COND((&RCMD *EQ 'E') *OR (&RCMD *EQ 'F')) +
                          THEN(GOTO CMDLBL(DEALC))
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND      */
/* MESSAGE TO MOPERQ.                                               */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
/* SET UP PARAMETERS FOR CALL TO FFC0320                            */
/**/
/**/                                                                  /*E44850*/
             IF         COND(&PMRKT *EQ ' ') THEN(CHGVAR VAR(&PMRKT) +
                          VALUE('##'))                                /*E44850*/
/**/                                                                  /*E44850*/
             CHGVAR     VAR(&RPARM) VALUE(&PMRKT)
/**/
             GOTO       CMDLBL(END)
/**/
/*   ERROR PROCESSING                                               */
/**/
 ABNOR:      SNDPGMMSG  MSG('FFC0322P - POSTION CLOSE OUT REPORT +
                          PROMPT - ENDED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/* DEALLOCATE THE MARKET DATA AREA IF DATABASE ERROR OR F3/F12      */
/**/
DEALC:       IF         COND((&PMRKT *NE '  ') *AND (&PMRKT *NE +
                          '**')) THEN(DO)
                     DLCOBJ OBJ((&PMRKT *DTAARA *SHRRD))
                     MONMSG MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO
/**/
END:         ENDPGM
