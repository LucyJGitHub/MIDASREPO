/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB Work with users')                            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Processing                        */
/*                                                                   */
/*       CBC0532 - COB WORK WITH COB USERS                           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. S01408             Date 07AUG95              */
/*       Prev Amend No. S01420 *Create     DATE 15MAR95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01408 - Hooks moved to WNCPYSRC from CBCPYSRC:             */
/*                - CBC0532INT                                       */
/*                - CBC0532MPS                                       */
/*                - CBC0532MPE                                       */
/*                - CBC0532ERR                                       */
/*                - CBC0532END                                       */
/*       S01420 - CoB Enhancements (Batch Monitor).                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CODE)
 
/*/COPY WNCPYSRC,CBC0532INT                                          */
 
             DCL        VAR(&CODE)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global error message trap */
 
             MONMSG     MSGID(CPF0000 CPI0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,CBC0532MPS                                          */
 
             CALL       PGM(CB0532)  PARM(&CODE)
 
/*/COPY WNCPYSRC,CBC0532MPE                                          */
 
             GOTO       CMDLBL(ENDP)
 
ABNOR:
/*/COPY WNCPYSRC,CBC0532ERR                                          */
 
ENDP:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*/COPY WNCPYSRC,CBC0532END                                          */
 
             ENDPGM
