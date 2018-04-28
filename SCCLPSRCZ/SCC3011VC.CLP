/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT CHGOWNAUT validity checker')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC3011VC - Call a Specific Switchable Feature Maintenance  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC007  *CREATE    Date 10Oct98              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSC007 - New program                                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SARDESC &SARNUMBER &CORE &PROGRAM)
 
/*/COPY WNCPYSRC,SCC3011INT                                          */
 
             DCL        VAR(&SARNUMBER) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SARDESC) TYPE(*CHAR) LEN(50)
             DCL        VAR(&PROGRAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CORE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CMSG) TYPE(*CHAR) LEN(8)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGTXT) TYPE(*CHAR) LEN(70)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(24)
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCLF       FILE(SCSARSPD)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
/* If core mode then file to be checked is SCSARZPD                 */
 
             IF         COND(&CORE *EQ 'N') THEN(DO)
               OVRDBF     FILE(SCSARSPD) TOFILE(SCSARZPD)
               CHGVAR     VAR(&CMSG) VALUE('Non-core')
               CHGVAR     VAR(&FILE) VALUE('SCSARZPD')
               ENDDO
             ELSE       CMD(DO)
               CHGVAR     VAR(&CMSG) VALUE('Core')
               CHGVAR     VAR(&FILE) VALUE('SCSARSPD')
             ENDDO
 
 
/* Check if Switchable Feature actually exists                      */
 
 RCVF:
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(DO)
               CHGVAR     VAR(&ERROR) VALUE('Y')
               CHGVAR     VAR(&MSGDTA) VALUE(&CMSG *CAT &SARNUMBER *CAT &FILE)
               RTVMSG     MSGID(CBM0235) MSGF(GBCBUSRMSG) +
                          MSGDTA(&MSGDTA) MSG(&MSGTXT)
             SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA(&MSGTXT) +
                          MSGTYPE(*DIAG)
               CHGVAR     VAR(&ERROR) VALUE('Y')
               GOTO       CMDLBL(CONT)
             ENDDO
             IF         COND(&AXSARN *EQ &SARNUMBER) THEN(GOTO +
                          CMDLBL(CONT))
             GOTO       CMDLBL(RCVF)
 
 CONT:
             CHKOBJ     OBJ(&PROGRAM) OBJTYPE(*PGM)
             MONMSG     MSGID(CPF9801) EXEC(DO)
               CHGVAR     VAR(&ERROR) VALUE('Y')
               RTVMSG     MSGID(CBM0236) MSGF(GBCBUSRMSG) +
                          MSGDTA(&PROGRAM) MSG(&MSGTXT)
               SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                          MSGDTA(&MSGTXT) MSGTYPE(*DIAG)
               ENDDO
 
/*  Send message to cause CPF to pass earlier messages back         */
 
             IF         COND(&ERROR *EQ 'Y') THEN(SNDPGMMSG +
                          MSGID(CPF0002) MSGF(QCPFMSG) +
                          MSGTYPE(*ESCAPE))
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SCC3011VC ended abnormally - see job +
                          log') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
