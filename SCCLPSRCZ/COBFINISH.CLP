/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SC End of close of business phase')             */
/*********************************************************************/
/*                                                                   */
/*       Midas     - System Control Module                           */
/*                                                                   */
/*       COBFINISH - End of Close of Business Phase.                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC020             Date 31Mar04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01495             DATE 01OCT94              */
/*                      Xnnnnn             DATE ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*       S01495 - New program created to mark the end of the         */
/*                close of business phase of dependency based        */
/*                close of business.                                 */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ABNOR))
/*/COPY WNCPYSRC,COBFINIS01                                          */
 
/*********** RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS) ***************************************CSC020*/
/*/COPY WNCPYSRC,COBFINIS02                                          */
/**********  CHGDTAARA  MPHAS VALUE('D')                                               */ /*CCB020*/
/**********  SCWRTJREG EVENT(MPHAS) FLAG(D) TEXT('MPHAS changed from C to D')   */ /*CSC020 CCB020*/
/*/COPY WNCPYSRC,COBFINIS03                                          */
             GOTO       CMDLBL(END)
 
/* Abnormal termination processing */
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
 
             SNDPGMMSG  MSG('Program COBFINISH ended abnormally') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
