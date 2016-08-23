/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Safe Custody Fees Initialisation')           */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Securities Trading Module                   */
/*                                                                   */
/*       CL/SEC1800 - Safe Custody Fees Initialisation Program       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. CSW003   *CREATE   DATE 15MAY96              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CSW003 - MT5xx Message Generation - Phase 2                 */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTNCDE &IPMODE)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&IPMODE) TYPE(*CHAR) LEN(1)
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* */
/** Mode 1 - Calling program for the first time                    */
/** Mode 2 - Re-calling program if already previously used         */
/** Mode 3 - Calling program to set SCF flag to 'N'                */
/* */
             IF         COND((&IPMODE *EQ '1') *OR +
                          (&IPMODE *EQ '2')    *OR +
                          (&IPMODE *EQ '3')) THEN(DO)
 
                CHGJOB     SWS(XXXXXX00)
             CALL       PGM(SE1800) PARM(&IPMODE)
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                              CMDLBL(ABNOR))
 
             ENDDO
 
             IF         COND(&IPMODE *EQ ' ') THEN(GOTO +
                          CMDLBL(ABNOR))
 
             GOTO       CMDLBL(END)
 
 ABNOR:      CHGVAR     VAR(&RTNCDE) VALUE('*ERROR')
 
 /**/
 /* Send the error message */
 /**/
             SNDPGMMSG  MSG('Program SEC1800 ended abnormally') +
                          TOMSGQ(MOPERQ)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
