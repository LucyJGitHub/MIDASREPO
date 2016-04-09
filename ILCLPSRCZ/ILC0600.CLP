/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IBLC 2002 Data area ILSTAT update')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - IBLC 2002 Module                                    */
/*                                                                   */
/*       ILC0600 - IBLC 2002 DATA AREA ILSTAT UPDATE                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CER001             Date 25Apr05              */
/*       Prev Amend No. ULX043             Date 28Jun01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       ULX043 - IBLC 2002 Reporting                                */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
 
/***  Declare Data String for Midas Error Message.  ***/
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(75)
             DCL        VAR(&EOM)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&EOY)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ILSTAT) TYPE(*CHAR) LEN(256)
 
/***  Reset Error values - switches and LDA.  ***/
 
             CHGJOB     SWS(XXXXXX00)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
             CHGVAR     VAR(&MSG) VALUE('ILC0600 - IBLC 2002 - Data +
                          area update')
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ MRUNQ)
 
/***  Call program.  ***/
 
             CALL       PGM(SD2000) PARM(&EOM &EOY &ERROR)
             IF         COND(&ERROR *NE ' ') THEN(DO)
                        RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                        SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                                   MSGDTA(&MEM) TOMSGQ(MOPERQ)
                        GOTO       CMDLBL(ABNORMAL)
             ENDDO
 
             IF         COND(&EOM *EQ 'Y') THEN(CHGDTAARA +
                          DTAARA(ILSTAT (8 1)) VALUE('Y'))
             ELSE       CMD(CHGDTAARA DTAARA(ILSTAT (8 1)) VALUE('N'))
 
/***  CAll Progrom to FLAG on Reporting for IBLC 2002  ***/
 
             CALL       PGM(IL0600)
 
/***  Monitor for Database Errors (U7 and U8 on).  ***/
/***  Retrieve Error information and set Message data.  ***/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                        RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                        SNDPGMMSG  MSGID(DBE0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                   TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
             GOTO ENDPGM
 
/* Abnormal termination processing */
 
 ABNORMAL:   DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
             SNDPGMMSG  MSG('ILC0600 - IBLC 2002 - Update Data Area +
                          Terminated abnormally.') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('ILC0600 +
                          terminated abnormaly - see job log for +
                          details') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/***  End Program.  ***/
 
 ENDPGM:     CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International +
                          Banking Systems Ltd. 2005')
             MONMSG     MSGID(CPF0000)
             ENDPGM
