/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Clear MT5xx Backup files')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas     - MESSAGE GENERATION MODULE                   */
/*                                                                   */
/*   MGC0500 - CLEAR MT500 MESSAGES GENERATION BACKUP FILES          */
/*   Called by SDC05                                                 */
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
/*       Prev Amend No. S01401             Date 16Jun93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01401 - SWIFT Messages MT5xxs - New Program.               */
/*                                                                   */
/********************************************************************/
 
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             MONMSG     MSGID(CPF0000)
 
             CLRPFM     FILE(MGF510BU)
             CLRPFM     FILE(MGF512BU)
             CLRPFM     FILE(MGF520BU)
             CLRPFM     FILE(MGF521BU)
             CLRPFM     FILE(MGF522BU)
             CLRPFM     FILE(MGF523BU)
             CLRPFM     FILE(MGF554BU)
             CLRPFM     FILE(MGF579BU)
             CLRPFM     FILE(MGF580BU)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
