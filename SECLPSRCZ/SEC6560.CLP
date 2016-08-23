/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Files Setup')                                */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Securities Trading Module                       */
/*                                                                   */
/*       SEC6560 - SE Files Setup                                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01496  *CREATE    DATE 21NOV94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       S01496 - Incorporation of Jyske Enhancements (New program)  */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/**/
/*********** PGM                                                        S01496*/
             PGM        PARM(&RTNCDE &IPMODE)                         /*S01496*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)               /*S01496*/
             DCL        VAR(&IPMODE) TYPE(*CHAR) LEN(1)               /*S01496*/
/**/
/* Global monitor message error trap */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000 CPA0000) +
                          EXEC(GOTO CMDLBL(ABNOR))
/**/
/**  Call program */
/**/
             CALL       PGM(SE6560)
/**/
/**  End of program */
/**/
             SNDPGMMSG  MSG('Program SEC6560 is completed normally')   +
                          TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(END)
/**/
ABNOR:       SNDPGMMSG  MSG('Program SEC6560 ended ABNORMALLY') +
                          TOMSGQ(MOPERQ MRUNQ)
/**/
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
