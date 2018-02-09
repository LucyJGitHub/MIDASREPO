/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Deposit comm/chrgs types file init')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC2120 - Deposits Commission/Charges Type file Initialisa  */
/*                 tion program                                      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*       Prev Amend No. CDL006  *CREATE    Date 26Apr99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CDL006 - Dealing Fiduciary.                                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTNCDE &IPMODE)
 
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&IPMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(90)
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCLF       FILE(DLCCGDPA) RCDFMT(DLCCGDD1)
 
/* Global monitor message                                            */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
/** Mode 1 - Calling program for the first time                      */
 
             IF         COND(&IPMODE = '1') THEN(DO)
 
/* Check if SE module is switched on via access object AOMMODR0.     */
 
                CHGVAR     VAR(&PRTCD) VALUE('       ')
                CALL       PGM(AOMMODR0) PARM(&PRTCD '*FIRST ' &FMT)
 
/* Database Error Handling                                           */
 
                IF         COND(&PRTCD *NE '       ') THEN(DO)
                   CHGVAR     VAR(&MSG) VALUE('DLC2120 - Error on access to +
                                SDMMODPD')
                   GOTO       CMDLBL(ERROR)
                ENDDO
 
/* Securities Module Installed, Copy file SECGTD and SECGTA to Fidu- */
/* ciary files DLCCGDPD and DLCCGDPA respectively.                   */
 
                IF         COND(%SST(&FMT 31 1) *EQ 'Y') THEN(DO)
                   CPYF       FROMFILE(SECGTD) TOFILE(DLCCGDPD) +
                                MBROPT(*REPLACE) FMTOPT(*NOCHK)
                   MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
                      CHGVAR     VAR(&MSG) VALUE('Unable to copy SE +
                                   Commission/Charges File to Deposits +
                                   Commission/Charges File properly.')
                      GOTO     CMDLBL(ERROR)
                   ENDDO
 
                   CPYF       FROMFILE(SECGTA) TOFILE(DLCCGDPA) +
                                MBROPT(*REPLACE) FMTOPT(*NOCHK)
                   MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
                      CHGVAR     VAR(&MSG) VALUE('Unable to copy SE trailer +
                                   file to Deposits trailer file properly.')
                      GOTO     CMDLBL(ERROR)
                   ENDDO
 
                ENDDO
 
                ELSE       CMD(DO)
                  CLRPFM     FILE(DLCCGDPD)
                  CLRPFM     FILE(DLCCGDPA)
                  INZPFM     FILE(DLCCGDPA) TOTRCDS(1)
                ENDDO
 
/* Initialise SDCCGRPA trailer file                                  */
 
             CALL       PGM(DL2120)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                CHGVAR     VAR(&MSG) VALUE('Unable to initialise +
                             SDCCGRPA trailer file properly.')
                GOTO       CMDLBL(ERROR)
             ENDDO
 
             GOTO       CMDLBL(END)
             ENDDO
 
/** Mode 2 - Re-calling program if already previously used           */
 
             IF         COND(&IPMODE = '2') THEN(DO)
               CHGJOB     SWS(XXXXXX00)
               GOTO       CMDLBL(END)
             ENDDO
 
/** Mode 3 - Switching off the SAR                                   */
 
             IF         COND(&IPMODE = '3') THEN(DO)
               CHGJOB     SWS(XXXXXX00)
               GOTO       CMDLBL(END)
             ENDDO
ERROR:
             CHGVAR     VAR(&RTNCDE) VALUE('*ERROR*')
             SNDPGMMSG   MSG(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ) +
                           MSGTYPE(*INFO)
             MONMSG      MSGID(CPF0000 MCH0000)
             GOTO        CMDLBL(END)
 
 ABNOR:
 
             CHGVAR     VAR(&RTNCDE) VALUE('*ERROR*')
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          DLC2120 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
