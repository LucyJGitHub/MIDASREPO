/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Updates SAR password data area')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC3200 - Switchable features command processing program.   */
/*                 Validated switchable feature details, input       */
/*                 using commands SCCRTKEY and SCCRTKEYB, are        */
/*                 passed to SC3100 where the files are updated.     */
/*                 This program also puts the switchable feature     */
/*                 password in a data area for processing by         */
/*                 SCC4200, if the command was called as part of     */
/*                 the switchable features initialisation process.   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC005  *CREATE    Date 08May98              */
/*                                                                   */
/*       Called by: SCCRTKEY                                         */
/*                  SCCRTKEYB                                        */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSC005 - New suite of programs and files to permit          */
/*                insertion of switchable features via passwords.    */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&SARN &PASS &NEWD &SARD &PRIM +
                          &CEMI &WRELL &WIREL &CLVL &RSTS +
                          &DFLT &MNTB &CHRG &FLRN &DOCN +
                          &HELP &CORE)
             DCL        VAR(&SARN) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PASS) TYPE(*CHAR) LEN(16)
             DCL        VAR(&NEWD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(50)
             DCL        VAR(&PRIM) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CEMI) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WRELL) TYPE(*CHAR) LEN(5)
             DCL        VAR(&WIREL) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CLVL) TYPE(*CHAR) LEN(4)
             DCL        VAR(&RSTS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DFLT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MNTB) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CHRG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FLRN) TYPE(*CHAR) LEN(35)
             DCL        VAR(&DOCN) TYPE(*CHAR) LEN(11)
             DCL        VAR(&HELP) TYPE(*CHAR) LEN(8)
             DCL        VAR(&CORE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1) VALUE('G')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Call validation program */
             CALL       PGM(SC3100) PARM(&PASS &RTNCDE &SARN &MODE +
                          &CORE)
 
             CHKOBJ     OBJ(PUNE) OBJTYPE(*DTAARA)
 
/*   Object in library not found   */
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/PUNE) TYPE(*CHAR) LEN(16) +
                          VALUE('&PASS') TEXT('Switchable Feature +
                          password data area'))
             MONMSG     MSGID(CPF1023)
 
             CHGDTAARA  DTAARA(PUNE) VALUE(&PASS)
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SCC3200 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
