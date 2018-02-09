/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Generation trades and depot movements')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC7560IC - SE Generation Trades & Depot Movements INPUT CYC*/
/*                                                                   */
/*       This program will generate the transactions in Input Cycle  */
/*       It is a copy of SEC7560. Corporate Actions                  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 229358  *CREATE    Date 24Mar03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       229358 - Corporate Actions in I/C                           */
/*                                                                   */
/*********************************************************************/
             PGM
 
/* Declare PGM Variables */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MEM)    TYPE(*CHAR) LEN(52)
             DCL        VAR(&PRESBS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSE061) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' '))
 
/* Reset Switches */
             CHGJOB     SWS(00000000)
 
             SNDPGMMSG  MSG('SEC7560IC - CO Generation Trades & +
                          Depot Movements Processing') TOMSGQ(MRUNQ)
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRESBS)
 
 
/* Call RPG/SE7560 - SE Generation Trades & Depot Movements*/
             OVRDBF     FILE(SEVTRDL1) TOFILE(SEVTRADL1) SHARE(*NO)
             OVRDBF     FILE(SEVDVPL1) TOFILE(SEVDVPRL1) SHARE(*NO)
 
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SAR) VALUE('CSE061')
             CHGVAR     VAR(&CSE061) VALUE('N')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)
             IF         COND(&RTCD *EQ '       ') THEN(DO)
                CHGVAR     VAR(&CSE061) VALUE('Y')
             ENDDO
 
             IF         COND(&CSE061 *EQ 'Y') THEN(DO)
                OVRDBF     FILE(SECOALL5) TOFILE(SECOAL12)
             ENDDO
 
             CALL       PGM(SE7560)
 
             IF         COND(&CSE061 *EQ 'Y') THEN(DO)
                DLTOVR     FILE(SECOALL5)
                OVRDBF     FILE(SECOALL5) TOFILE(SECOAL12)
             ENDDO
 
/* Database error processing */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                CHGVAR VAR(&MEM) VALUE('SEC7560 - JOB TERMINATED, +
                                        DATABASE IN ERROR')
                SNDPGMMSG MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                SNDPGMMSG  MSG('SEC7560IC - JOB TERMINATED, DATABASE IN +
                             ERROR') TOPGMQ(*EXT) MSGTYPE(*INFO)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* For File in Balance Error */
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                CHGVAR     VAR(&MEM) VALUE('SEC7560IC - FILE CONTROLS +
                             OUT OF BALANCE')
                SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             CALL       PGM(SEC0304)
 
             RCLRSC
 
             GOTO       CMDLBL(END)
ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
             DSPJOBLOG  OUTPUT(*PRINT)
             MONMSG     MSGID(CPF0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
