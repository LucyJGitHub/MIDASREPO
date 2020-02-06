/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ME BIC ZIP placement and clearing prefix mt.')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Message Management                                  */
/*                                                                   */
/*       MEC1620 - MIDAS OVERRIDE DATABASE FILE FOR MEZIPPL0         */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       Prev Amend No. CFT007  *CREATE    Date 25Oct99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CFT007 - BIC Database Plus Integration                      */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             OVRDBF     FILE(MEZIPPLR) TOFILE(MEZIPPL0) SHARE(*NO)
 
             CALL       PGM(ME1620)
 
             DLTOVR     FILE(MEZIPPLR)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
