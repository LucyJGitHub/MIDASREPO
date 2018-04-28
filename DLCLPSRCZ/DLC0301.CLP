/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL CUSTOMER DEALS ENQUIRY')                     */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC0301 - CUSTOMER DEALS ENQUIRY                           */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG1832            Date 19Feb02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. BHF998             Date 11Mar91              */
/*                      S01117             Date 17Jul89              */
/*                      S01194             DATE  17/07/89           */
/*                      S01179             DATE  10/09/88           */
/*                      S01119             DATE  28/07/87           */
/*                      S01104             DATE  22/09/86           */
/*                                                                  */
/********************************************************************/
/*       BUG1832- Projected Account Movements Enquiry Problems       */
/*       BHF998  -  OVERRIDE CUSDL TO DISPLAY DEALS IN REVERSE      */
/*                  DATE ORDER                                      */
/*       S01117  -  MULTIBRANCHING                                  */
/*       S01194  -  NEW STANDING DATA FILES                         */
/*       S01179  -  AS400 CONVERSION                                */
/*       S01179  -  AS400 CONVERSION                                */
/*       S01119  -  FRA/IRS INCORPORATION                           */
/*       S01104  -  CREATE DATA AREA FOR LINKING TO DL0170          */
/*                                                                  */
/********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)                 /*S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
/*                                                                    /*S01119*/
/*********** DCLDTAARA  DTAARA(LDA)                                     S01179*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                /*S01179*/
/*                                                                    /*S01119*/
/**/                                                                  /*S01104*/
             DLTDTAARA  DTAARA(DLSDS)                                 /*S01104*/
             MONMSG     MSGID(CPF0000)                                /*S01104*/
/*********** CRTDTAARA  DTAARA(DLSDS.QTEMP) TYPE(*CHAR) LEN(161)*S01104*S01179*/
/**********  CRTDTAARA  DTAARA(QTEMP/DLSDS) TYPE(*CHAR) LEN(161)     */       /*S01178*/ /*BUG1832*/
             CRTDTAARA  DTAARA(QTEMP/DLSDS) TYPE(*CHAR) LEN(167)                         /*BUG1832*/
             CHGJOB     SWS(00000000)                                 /*S01104*/
/**/
/************OVRDBF     FILE(TABLE) TOFILE(TABDLI)                    /*S01194*/
             OVRDBF     FILE(CUSDL) TOFILE(CUSDL1)                    /*BHF998*/
             CALL       PGM(DL0120)
/************DLTOVR     FILE(TABLE)                                   /*S01194*/
             DLTOVR     FILE(CUSDL)                                   /*BHF998*/
/**/
             RTVJOBA    JOB(&JOB) SWS(&SWS)
             IF         COND((%SUBSTRING(&SWS 7 1) = '1') *OR +
                        (%SUBSTRING(&SWS 8 1) = '1')) THEN(DO)
/*********                                                            /*S01119*/
/*********   SNDPGMMSG  MSG('Job Terminated - Database in Error') +           */
/*********              TOMSGQ(MOPERQ)                                        */
/*********   SNDPGMMSG  MSG('Job Terminated - Database in Error') +           */
/*********              TOMSGQ(&JOB)                                          */
/*********      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                   */
/*********         RCVDTAARA  DTAARA(LDA)                               S01179*/
                   RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                /*S01179*/
/**************    CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))/*S01117*/
                   CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))
/**************    SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-/*S01117*/
                   SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM)-
                               TOMSGQ(MOPERQ)
/**************    SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-/*S01117*/
                   SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM)-
                               TOPGMQ(*EXT)
/*                                                                    /*S01119*/
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
