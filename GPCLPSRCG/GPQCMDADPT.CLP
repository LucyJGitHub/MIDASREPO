/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GP QCMD adoption for the global layer')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing                                   */
/*                                                                   */
/*       GPQCMDADPT - QCMD Adoption for the Global Layer             */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CGP001  *CREATE    Date 03Oct03              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CGP001 - Global Processing:                                 */
/*                - New program to allow the client to (optionally)  */
/*                  grant QCMD access to the global database.        */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CALL       PGM(QCMD)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
             GOTO       CMDLBL(END)
 
ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
