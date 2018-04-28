/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Create temporary files for subfile use')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       CRTSDT - Create Temporary Files for Subfile Records         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2009           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Last Amend No. CSC041  *CREATE    Date 26Nov09              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSC041 - 4-Eyes Checking Gaps (Applied BUG23918)            */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2009')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(END))
 
             CPYF       FROMFILE(SDATPD1) TOFILE(QTEMP/SUBF1) +
                        CRTFILE(*YES)
 
 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International +
                          Banking Systems Ltd.')
             ENDPGM
