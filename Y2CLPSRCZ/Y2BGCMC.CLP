/*********************************************************************/
/*                                                                   */
/*       Midas - (Module Name) Module                                */
/*                                                                   */
/*       mmCnnnn - (Program Name)                                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. XNNNNN  *CREATE    Date DDMmmYY              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       Xnnnnn - (fix description)                                  */
/*                                                                   */
/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Y2 R2.1.1 Begin commit control')                      */
/*********************************************************************/
/*T: YAPPOBJ Begin commit control. */
/*Z: CRTCLPGM LOG(*NO)  */
/*H: SYSTEM     : SYNON/2 ROUTINE                                      */
/*H: PROGRAMMER : P.WILSON                                             */
/*       (c) Finastra International Limited 2001                     */
/*H: SYNOPSIS: Starts commit control for calling job                   */
/********************************************************************/
/**/
PGM  (&RTNCDE)
 
 DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7) /* Return code */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/*H: 1. Reset return code.                                             */
          CHGVAR     VAR(&RTNCDE) VALUE('       ')
 
/*H: 2. Attempt to start commit control.                               */
STRCMTCTL  LCKLVL(*CHG)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             RCVMSG     MSGTYPE(*EXCP) MSGID(&RTNCDE)
         ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
ENDPGM
