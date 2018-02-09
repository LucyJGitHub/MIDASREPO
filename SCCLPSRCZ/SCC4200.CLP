/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Calls SCCRTKEYB for initialising SAR file')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC4200 - Calls SCCRTKEYB to allow update of switchable     */
/*                 features files for non-core once password         */
/*                 access has been activated                         */
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
/*       Prev Amend No. CSC005  *CREATE    Date 08May98              */
/*                                                                   */
/*       CALLED BY: SC1200                                           */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC005 - New suite of programs and files to permit          */
/*                insertion of switchable features via passwords.    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SARN &SARD &PASS &RTN)
 
             DCL        VAR(&SARN) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(50)
             DCL        VAR(&PASS) TYPE(*CHAR) LEN(16)
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Create non-core feature - ensure that new description is entered */
 
          ?  SCCRTKEYB   SARN(&SARN) SARD(&SARD) NEWD(Y) +
                           RSTS(R)
             MONMSG     MSGID(CPF6801) EXEC(DO)
 
/* Send message back to SC1200 to indicate F3 pressed */
 
             CHGVAR     VAR(&RTN) VALUE('F3     ')
 
             GOTO       CMDLBL(END)
 
             ENDDO
 
             RTVDTAARA  DTAARA(QTEMP/PUNE) RTNVAR(&PASS)
 
/* Data area not found monitor message */
 
             MONMSG     MSGID(CPF1015) EXEC(GOTO CMDLBL(END))
 
             GOTO       CMDLBL(END)
 ABNOR:
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SCC4200 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
