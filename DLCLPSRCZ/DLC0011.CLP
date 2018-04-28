/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Citydealer cash flow extract in EVTS fmt')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC0011 - Midas/Citydealer Cash Flow extract in EVTS format */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Last Amend No. CCM003  *CREATE    Date 01Feb01              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CCM003 - Download of Cashflows from Midas to City Dealer.   */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&NUMREC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&PRE)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&FOLD) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/*    Global monitor message                                         */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
/*    Get system prefix                                              */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRE)
             CHGVAR     VAR(&FOLD) VALUE('TSM' *TCAT &PRE)
 
 
/**/
/*    If PF/DLETNTPD is not empty copy to PC document NTETVS in  */
/*    folder TSMxx (xx is the system prefix)                     */
/**/
             OVRDBF     FILE(DLETNTPD) SHARE(*NO)
             RTVMBRD    FILE(DLETNTPD) NBRCURRCD(&NUMREC)
 
             IF         COND(&NUMREC *NE 0) THEN(DO)
 
             CPYTOPCD   FROMFILE(DLETNTPD) TOFLR(&FOLD) +
                          TODOC(NTETVS.CSV) TRNFMT(*TEXT)
             MONMSG     MSGID(IWS16B4 IWS1612) EXEC(GOTO TAG1)
             CPYF       FROMFILE(DLETNTPD) TOFILE(DLETVTPD) +
                          MBROPT(*ADD)
             CLRPFM     FILE(DLETNTPD)
 TAG1:       ENDDO
/**/
/*    If PF/DLETLEPD is not empty copy to PC document LEETVS in  */
/*    folder TSMxx (xx is the system prefix)                    */
/**/
             OVRDBF     FILE(DLETLEPD) SHARE(*NO)
             RTVMBRD    FILE(DLETLEPD) NBRCURRCD(&NUMREC)
 
             IF         COND(&NUMREC *NE 0) THEN(DO)
 
             CPYTOPCD   FROMFILE(DLETLEPD) TOFLR(&FOLD) +
                          TODOC(LEETVS.CSV) TRNFMT(*TEXT)
             MONMSG     MSGID(IWS16B4 IWS1612) EXEC(GOTO TAG2)
             CPYF       FROMFILE(DLETLEPD) TOFILE(DLETVTPD) +
                          MBROPT(*ADD)
             CLRPFM     FILE(DLETLEPD)
 TAG2:       ENDDO
/**/
/*    If PF/DLETFTPD is not empty copy to PC document FTETVS in */
/*    folder TSMxx (xx is the system prefix)                    */
/**/
             OVRDBF     FILE(DLETFTPD) SHARE(*NO)
             RTVMBRD    FILE(DLETFTPD) NBRCURRCD(&NUMREC)
 
             IF         COND(&NUMREC *NE 0) THEN(DO)
 
             CPYTOPCD   FROMFILE(DLETFTPD) TOFLR(&FOLD) +
                          TODOC(FTETVS.CSV) TRNFMT(*TEXT)
             MONMSG     MSGID(IWS16B4 IWS1612) EXEC(GOTO TAG3)
             CPYF       FROMFILE(DLETFTPD) TOFILE(DLETVTPD) +
                          MBROPT(*ADD)
             CLRPFM     FILE(DLETFTPD)
 TAG3:       ENDDO
/**/
/*    If PF/DLETPLPD is not empty copy to PC document PLETVS in */
/*    folder TSMxx (xx is the system prefix)                   */
/**/
             OVRDBF     FILE(DLETPLPD) SHARE(*NO)
             RTVMBRD    FILE(DLETPLPD) NBRCURRCD(&NUMREC)
 
             IF         COND(&NUMREC *NE 0) THEN(DO)
 
             CPYTOPCD   FROMFILE(DLETPLPD) TOFLR(&FOLD) +
                          TODOC(PLETVS.CSV) TRNFMT(*TEXT)
             MONMSG     MSGID(IWS16B4 IWS1612) EXEC(GOTO TAG4)
             CPYF       FROMFILE(DLETPLPD) TOFILE(DLETVTPD) +
                          MBROPT(*ADD)
             CLRPFM     FILE(DLETPLPD)
 TAG4:       ENDDO
 
/*    Database error processing                                      */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                ROLLBACK
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                           TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
             GOTO       CMDLBL(END)
/**/
 /*   Abnormal termination - batch job                               */
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('Copy to Citydealer document ENDED +
                          ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*                                                                   */
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
