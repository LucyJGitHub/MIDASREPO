/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IBLC 2002 Routing keys list')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - IBLC 2002 Module                                    */
/*                                                                   */
/*       ILC0340  - ROUTING KEYS LIST SELECTION                      */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 25Apr05              */
/*                      ULX043             Date 28Jun01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       ULX043 - IBLC 2002 Reporting                                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
 
/***  Declare variables.  ***/
 
             DCL        VAR(&MOD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OPTION) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
 
/***  Reset external switches.  ***/
 
 RUN:        CHGJOB     SWS(0XXXXX00)
 
/***  (Re-)Initialize parameters of called program.  ***/
 
             CHGVAR     VAR(&TYPE) VALUE(' ')
             CHGVAR     VAR(&OPTION) VALUE(%SST(&RPARM 1 2))
 
/***  Setup parameters depending of Option entered.  ***/
/***  Full list choice under 11, else Audit list.    ***/
 
             IF         COND(&OPTION *LE '10')  +
                        THEN(CHGVAR VAR(&TYPE) VALUE('F'))
             ELSE       CMD(CHGVAR VAR(&TYPE) VALUE('A'))
 
/***  Initialize Module parameter.  ***/
/***  Dealing module.  ***/
             IF         COND(&OPTION *EQ '01' *OR &OPTION *EQ '11') +
                        THEN(CHGVAR     VAR(&MOD) VALUE('DL'))
 
/***  Dealing module for Negotiable Assets.  ***/
             IF         COND(&OPTION *EQ '02' *OR &OPTION *EQ '12') +
                        THEN(CHGVAR     VAR(&MOD) VALUE('DN'))
 
/***  Customer Lending module.  ***/
             IF         COND(&OPTION *EQ '03' *OR &OPTION *EQ '13') +
                        THEN(CHGVAR     VAR(&MOD) VALUE('LE'))
 
/***  Securities Trading module.  ***/
             IF         COND(&OPTION *EQ '04' *OR &OPTION *EQ '14') +
                        THEN(CHGVAR     VAR(&MOD) VALUE('SE'))
 
/***  Funds transfers module.  ***/
             IF         COND(&OPTION *EQ '05' *OR &OPTION *EQ '15') +
                        THEN(CHGVAR     VAR(&MOD) VALUE('FT'))
 
/***  Futures & Options module.  ***/
             IF         COND(&OPTION *EQ '06' *OR &OPTION *EQ '16') +
                        THEN(CHGVAR     VAR(&MOD) VALUE('FF'))
 
/***  All modules.  ***/
             IF         COND(&OPTION *EQ '07' *OR &OPTION *EQ '17') +
                        THEN(CHGVAR     VAR(&MOD) VALUE('**'))
 
/***  If valid option entered call list program.  ***/
             IF         COND(&MOD *NE '  ') THEN(DO)
                        CALL       PGM(IL0340) PARM(&MOD &TYPE &RSEQ &RLEV)
                        MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
                                   SNDPGMMSG  MSG('Transaction failed. Re-input +
                                   necessary. Enter to continue.') TOPGMQ(*EXT)
                        DMPCLPGM
                        GOTO       CMDLBL(ENDPGM)
                        ENDDO                         /***  MONMSG.  ***/
             ENDDO
 
 ENDPGM:     CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited 2005')
             MONMSG     MSGID(CPF0000)
             ENDPGM
