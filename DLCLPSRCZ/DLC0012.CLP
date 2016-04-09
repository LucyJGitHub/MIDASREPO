/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Citydealer cash flow extract in EVTS fmt')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC0012 - Midas Customer Lending Download of Transactions   */
/*                 to City Dealer in ETVS Format                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Last Amend No. CCM003 *CREATE     Date 02Feb01              */
/*       Prev Amend No.                    Date                      */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CCM003 - Midas/City Dealer Lending interface.               */
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
 
/*    Global monitor message.                                        */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*    Obtain system prefix.                                          */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRE)
             CHGVAR     VAR(&FOLD) VALUE('TSM' *TCAT &PRE)
 
 
/*    If file DLETLEPD is not empty then copy to PC document         */
/*    LEETVS.CSV in shared folder TSMxx, where xx is the Midas       */
/*    system prefix.                                                 */
 
             OVRDBF     FILE(DLETLEPD) SHARE(*NO)
             RTVMBRD    FILE(DLETLEPD) NBRCURRCD(&NUMREC)
 
             IF         COND(&NUMREC *NE 0) THEN(DO)
 
             CPYTOPCD   FROMFILE(DLETLEPD) TOFLR(&FOLD) +
                          TODOC(LEETVS.CSV) TRNFMT(*TEXT)
             MONMSG     MSGID(IWS16B4 IWS1612) EXEC(GOTO TAG1)
             CPYF       FROMFILE(DLETLEPD) TOFILE(DLETVTPD) +
                          MBROPT(*ADD)
             CLRPFM     FILE(DLETLEPD)
 TAG1:       ENDDO
 
/*    If file DLETCLPD is not empty then copy to PC document            CCM003*/
/*    CLETVS.CSV in shared folder TSMxx, where xx is the Midas          CCM003*/
/*    system prefix.                                                    CCM003*/
 
             OVRDBF     FILE(DLETCLPD) SHARE(*NO)                     /*CCM003*/
             RTVMBRD    FILE(DLETCLPD) NBRCURRCD(&NUMREC)             /*CCM003*/
 
             IF         COND(&NUMREC *NE 0) THEN(DO)                  /*CCM003*/
 
             CPYTOPCD   FROMFILE(DLETCLPD) TOFLR(&FOLD) +
                          TODOC(CLETVS.CSV) TRNFMT(*TEXT)             /*CCM003*/
             MONMSG     MSGID(IWS16B4 IWS1612) EXEC(GOTO TAG2)        /*CCM003*/
             CPYF       FROMFILE(DLETCLPD) TOFILE(DLETVTPD) +
                          MBROPT(*ADD)                                /*CCM003*/
             CLRPFM     FILE(DLETCLPD)                                /*CCM003*/
 TAG2:       ENDDO
 
/*    If file DLETCPPD is not empty then copy to PC document            CCM003*/
/*    CPETVS.CSV in shared folder TSMxx, where xx is the Midas          CCM003*/
/*    system prefix.                                                    CCM003*/
 
             OVRDBF     FILE(DLETCPPD) SHARE(*NO)                     /*CCM003*/
             RTVMBRD    FILE(DLETCPPD) NBRCURRCD(&NUMREC)             /*CCM003*/
 
             IF         COND(&NUMREC *NE 0) THEN(DO)                  /*CCM003*/
 
             CPYTOPCD   FROMFILE(DLETCPPD) TOFLR(&FOLD) +
                          TODOC(CPETVS.CSV) TRNFMT(*TEXT)             /*CCM003*/
             MONMSG     MSGID(IWS16B4 IWS1612) EXEC(GOTO TAG3)        /*CCM003*/
             CPYF       FROMFILE(DLETCPPD) TOFILE(DLETVTPD) +
                          MBROPT(*ADD)                                /*CCM003*/
             CLRPFM     FILE(DLETCPPD)                                /*CCM003*/
 TAG3:       ENDDO
 
/*    Database error processing.                                     */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                ROLLBACK
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                           TOMSGQ(MOPERQ MRUNQ)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 /*   Abnormal termination - batch job                               */
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('Copy to Citydealer document LEETVS +
                          ENDED ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
