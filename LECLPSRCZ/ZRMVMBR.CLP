/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Remove LF members to input file')            */
/*OVR *: OVRDBF FILE(DBR) TOFILE(QADSPDBR)                          :*/
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                     */
/*                                                                   */
/*       ZRMVMBR - REMOVE LOGICAL FILE MEMBERS TO INPUT FILE         */
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
/*       Prev Amend No. 069249             Date 08Apr94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       069249 - Use system file QADSPDBR to compile program        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&FILE)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCLF       FILE(DBR)
             DSPDBR     FILE(&FILE) OUTPUT(*OUTFILE) OUTFILE(QTEMP/DBR)
LOOP1:       RCVF       DEV(*FILE) RCDFMT(QWHDRDBR)
/* */
             MONMSG     CPF0864 EXEC(GOTO END)
             RMVM       FILE(&WHREFI) MBR(&WHREFI)
             MONMSG     MSGID(CPF0000)
/* */
             GOTO LOOP1
/* */
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
