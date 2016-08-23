/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ML ADDMSGD for DSPF text')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Utilities Module                                */
/*                                                                   */
/*       MLC0140  - ADDMSGD FOR DSPF TEXT                            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01516             DATE 18JUL94              */
/*       PREV AMEND NO. Xnnnnn             DATE ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01516 - Incorporation into core                            */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MSGFNM &MSGDNM &MSGDNB &LIBRAIRIE +
                          &MULTLIB)
 
             DCL        VAR(&MSGDNB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGFNM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGDNM) TYPE(*CHAR) LEN(80)
             DCL        VAR(&LIBRAIRIE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MULTLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             CHKOBJ     OBJ(&MULTLIB/&MSGFNM) OBJTYPE(*MSGF)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTMSGF    MSGF(&MULTLIB/&MSGFNM) SIZE(1000)
             ENDDO
 
             ADDMSGD    MSGID(&MSGDNB) MSGF(&MULTLIB/&MSGFNM) +
                          MSG(&MSGDNM)
 
             RETURN
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
