/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Safe Custody Fees Initialisation')              */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Securities Trading Module                   */
/*                                                                   */
/*       CL/SEC6000 - Safe Custody Fees Initialisation Program       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01464   *CREATE   DATE 04APR94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       S01464 - Safe Custody Fees                                  */
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
/* */
             IF         COND((&IPMODE *EQ '1') *OR +
                          (&IPMODE *EQ '2')) THEN(DO)
 
                CLRPFM     FILE(SECFGRPD)
                CLRPFM     FILE(SECFGRPA)
                CLRPFM     FILE(SECGCDPD)
                CLRPFM     FILE(SECGCDPA)
                CLRPFM     FILE(SECICFPD)
                CLRPFM     FILE(SECICFPA)
                CLRPFM     FILE(SEOCFSPD)
                CLRPFM     FILE(SESCFAPD)
 
                CHGJOB     SWS(XXXXXX00)
                CALL       PGM(SE6000) PARM(&IPMODE)
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                              CMDLBL(ABNOR))
 
             ENDDO
/* */
/** Mode 3 - Calling program to set SCF flag to 'N'                  */
/* */
             IF         COND(&IPMODE *EQ '3') THEN(DO)
 
                CHGJOB     SWS(XXXXXX00)
                CALL       PGM(SE6000) PARM(&IPMODE)
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                              CMDLBL(ABNOR))
 
             ENDDO
 
             IF         COND(&IPMODE *EQ ' ') THEN(GOTO +
                          CMDLBL(ABNOR))
 
             GOTO       CMDLBL(END)
 
 ABNOR:      CHGVAR     VAR(&RTNCDE) VALUE('*ERROR')
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
