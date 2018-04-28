/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Prices Maintainance')                        */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                            */
/*                                                                   */
/*   FFC0224  -  PRICES MAINTAINANCE FOR ALL POSITIONS               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   LAST AMEND NO. 100497             DATE 09AUG96                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*   100497 - Created new CL program to allow FF Prices Input pgm    */
/*            FF0310 to be called from a menu option in I/C as well  */
/*            as during EOC processing.                              */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&PMRKT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PHEAD) TYPE(*CHAR) LEN(30)
             DCL        VAR(&PMKTN) TYPE(*CHAR) LEN(20)
             DCL        VAR(&APRP) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ECOB) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/*  INITIAL PROMPT-PROGRAM :  CHOOSE MARKET-CENTRE.                  */
/**/
 MARKETSLT:  CHGJOB     SWS(XXXX0XXX)
/**/
             CHGVAR     VAR(&PHEAD) VALUE('PRICES MAINTENANCE')
             CALL       PGM(FF1265) PARM(&PMRKT &PHEAD)
/**/
/**    IF  A DATABASE-ERROR OCCURRED,  END PROGRAM.                  */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(END))
/**/
/*  CMD/3 TAKEN, MARKET CENTRE PARAMETER WILL BE '03'                */
/*  CMD/12 TAKEN, MARKET CENTRE PARAMETER WILL BE '12'               */
/**/
             IF         COND(&PMRKT *EQ '03') THEN(GOTO END)
             IF         COND(&PMRKT *EQ '12') THEN(GOTO END)
/**/
/**    OVERRIDE FILES TO MARKET-CENTRE MEMBERS                       */
/**/
             IF         COND(&PMRKT *NE '  ') THEN(DO)
             OVRDBF     FILE(POSTN4) MBR(&PMRKT)
             OVRDBF     FILE(PRICS)  MBR(&PMRKT)
             OVRDBF     FILE(PRISP)  MBR(&PMRKT)
             OVRDBF     FILE(PRICSA) MBR(&PMRKT)
             OVRDBF     FILE(PRISPA) MBR(&PMRKT)
             ENDDO
             ELSE       CMD(DO)
             OVRDBF     FILE(POSTN4) MBR(OTC)
             OVRDBF     FILE(PRICS)  MBR(OTC)
             OVRDBF     FILE(PRISP)  MBR(OTC)
             OVRDBF     FILE(PRICSA) MBR(OTC)
             OVRDBF     FILE(PRISPA) MBR(OTC)
             ENDDO
/**/
/*   SET AUTOMATIC PRICES PROMPT SCREEN TO 'Y' TO FORCE SCREEN DISPLAY */
/*   SET END OF CENTRE FLAG TO 'N'                                   */
/**/
             CHGVAR     VAR(&APRP) VALUE('Y')
             CHGVAR     VAR(&ECOB) VALUE('N')
/**/
/*   CALL MAINTENANCE PROGRAM                                        */
/**/
             CALL       PGM(FF0310)  PARM(&PMRKT &APRP &ECOB)
/**/
/*   DELETE ALL FILE-OVERRIDES FOR CURRENT INVOCATION OF JOB         */
/**/
             DLTOVR     FILE(*ALL)
/**/
/* IF COMMAND/5 WAS TAKEN TO END PROGRAM, RETURN TO MARKET SELECTION */
/**/
             IF         COND(%SWITCH(XXXX1X00)) THEN(GOTO +
                          CMDLBL(MARKETSLT))
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
             ENDPGM
