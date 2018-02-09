/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SF Change password')                            */
/*********************************************************************/
/*   Midas  SECURITY PROFILE FACILITY                        */
/*                                                                   */
/*   SFC0060  MIDAS USER PASSWORD CHANGE                             */
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
/*   PREV AMEND. NO. 000            DATE    00/00/00                 */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*********************************************************************/
             PGM
/*                                                                   */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
/* CHANGE PASSWORD  */
             CHGPWD
/* IF SUCCESFULLY CHANGED GO BACK */
             RCVMSG     MSGQ(*PGMQ) MSGID(&MSGID)
             IF         COND(&MSGID *EQ CPC2352) THEN(GOTO +
                          CMDLBL(ENDLBL))
/* IF NOT CHANGED IT MEANS THAT F12 OR F3 WAS TAKEN */
             SIGNOFF    LOG(*LIST)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDLBL:      ENDPGM
