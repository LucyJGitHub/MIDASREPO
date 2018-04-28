/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GP Check/start global subsystem')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       GPC000102 - Check /Start global subsystem                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2004           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG1676 *CREATE       Date 24Feb04           */
/*       Prev Amend No. Xnnnnn                Date ddmmmyy           */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG1676 - Ensure global subsystem is running.               */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&SYPR) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SBSSTR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2004')
 
                CALL       PGM(GPRTVLIB) PARM(&SYPR)
 
                STRSBS     SBSD('M' *CAT &SYPR *CAT 'GSBS')
                MONMSG     MSGID(CPF1010) EXEC(GOTO CMDLBL(END))
                CHGVAR     VAR(&SBSSTR) VALUE('Y')
 
             GOTO       CMDLBL(END)
ERROR:
             CHGJOB     SWS(XXXXXX11)
 
END:
             ENDPGM
