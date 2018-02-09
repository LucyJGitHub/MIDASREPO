/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Switchable f - init pgms control')           */
/*********************************************************************/
/*                                                                   */
/*       Midas     - System Control Module                       */
/*                                                                   */
/*       SCC3090  - Switchable features by initialisation programs   */
/*                   control                                         */
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
/*       Prev Amend No. S01430             Date 07Jul93              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01430 - SWITCHABILITY ENHANCEMENTS PHASE 2                 */
/*                INCLUSION OF SWITCHABLE FEATURE INITIALISATION     */
/*                PROGRAMS                                           */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&IPPGM &RTNCDE &IPMODE)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&IPPGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&IPMODE) TYPE(*CHAR) LEN(1)
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
             CALL       PGM(&IPPGM) PARM(&RTNCDE &IPMODE)
/**/
             IF         COND(&RTNCDE *NE '       ') THEN(GOTO +
                          CMDLBL(ABNOR))
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
             GOTO       CMDLBL(END)
/**/
 ABNOR:
             CHGVAR     VAR(&RTNCDE) VALUE('*ERROR')
/**/
 END:        ENDPGM
