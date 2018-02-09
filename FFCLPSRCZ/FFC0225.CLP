/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Spot Prices maintenance')                    */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                    */
/*                                                                   */
/*   FFC0225  -  SPOT PRICES MAINTENANCE                             */
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
/*   PREV AMEND NO. N00000             DATE DDMMMYY                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*     CHANGE DESCRIPTIONS                                           */
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*-------------------------------------------------------------------*/
/*     CREATION REQUIREMENTS                                         */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&PMRKT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PMKTN) TYPE(*CHAR) LEN(20)
             DCL        VAR(&PBUSD) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/**  INITIAL PROMPT-PROGRAM :  CHOOSE MARKET-CENTRE.                    */
/**  ( ALLOCATES  MARKET-CENTRE DATA-AREA  TO CURRENT JOB )             */
/**/
 MARKETSLT:  CHGJOB     SWS(XXXX0XXX)
/**/
             CALL       PGM(FF0230) PARM(&PMRKT &PMKTN &PBUSD)
/**/
/**    IF  A DATABASE-ERROR OCCURRED,  END PROGRAM.                     */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ENDPGM)
/**/
/**    IF  USER REQUESTED EXIT (CMD-1),  RESET SWITCH  AND END PROGRAM. */
/**/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                CHGJOB     SWS(XXXXXXX0)
                GOTO       CMDLBL(ENDPGM)
                ENDDO
/**/
/**    OVERRIDE FILES TO MARKET-CENTRE MEMBERS                          */
/**/
             OVRDBF     FILE(PRISP) MBR(&PMRKT)
             OVRDBF     FILE(PRISPA) MBR(&PMRKT)
/**/
             OVRDBF     FILE(PRISPX) TOFILE(PRISP) MBR(&PMRKT) +
                          SHARE(*NO)
/**/
/**  MAINTENANCE PROGRAM                                                */
/**/
             CALL       PGM(FF0235) PARM(&PMRKT &PMKTN &PBUSD)
/**/
/**    DEALLOCATE  MARKET-CENTRE DATA-AREA                              */
/**    AS ALLOCATED TO CURRENT JOB BY PROMPT-PROGRAM                    */
/**/
             DLCOBJ     OBJ((&PMRKT *DTAARA *SHRRD))
/**/
/**    DELETE ALL FILE-OVERRIDES FOR CURRENT INVOCATION OF JOB          */
/**/
             DLTOVR     FILE(*ALL)
/**/
/* IF COMMAND/5 WAS TAKEN TO END PROGRAM, RETURN TO MARKET SELECTION*/
/**/
             IF         COND(%SWITCH(XXXX1X00)) THEN(GOTO +
                          CMDLBL(MARKETSLT))
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
 ENDPGM:     ENDPGM
