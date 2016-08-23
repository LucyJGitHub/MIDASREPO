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
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 069249             DATE 08APR94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       069249 - Use system file QADSPDBR to compile program        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&FILE)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
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
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
