/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Exposure limits & mat. FX deals - reports')  */
/*********************************************************************/
/*                                                                   */
/*        Midas     - Dealing Module                                 */
/*                                                                   */
/*       DLC0806B - EXPOSURE AGAINST LIMITS & MATURITY OF FX DEALS   */
/*                  - REPORTS                                        */
/*                                                                   */
/*       (c) Finastra International Limited 2008                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. CCB016  *CREATE    Date 28May08              */
/*      Midas Plus 1.4 Base -----------------------------------------*/
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*   CCB016 - CoB Performance Enhancements                           */
/*            Split DLC0806 into two components, DLC0806A for data   */
/*            extraction and DLC0806B for reporting.                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &PARM)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2008')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)
             DCL        VAR(&CDL002) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&BNNTCE) TYPE(*CHAR) LEN(1) VALUE('N')
 
/* Global monitor message                                                                         */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB      SWS(00000000)
 
/* Set job switch U1 for Full or Exception reporting                                              */
 
             IF         COND(%SUBSTRING(&PARM 1 1) = 'Y') +
                          THEN(CHGJOB SWS(10000000))
 
/* Check if CDL002 (FX Netting) installed                                                         */
 
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CDL002')
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CDL002) VALUE('Y'))
 
/* Check if FX Customer Netting installed                                                         */
 
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CALL       PGM(AODEALR0) PARM(&RTCD '*FIRST' &DSFDY)
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&BNNTCE) VALUE(%SST(&DSFDY 94 +
                          94)))
 
/************************       DL0760 - CUSTOMER EXPOSURE            *****************************/
 
             SNDMSG     MSG('CUSTOMER EXPOSURE AGAINST ALL LIMITS +
                          REPORT') TOMSGQ(MRUNQ)
 
/* Set job switch U3 if FX Netting and FX Customer Netting both installed                         */
 
             IF         COND((&CDL002 *EQ 'Y') *AND (&BNNTCE *EQ +
                          'Y')) THEN(CHGJOB SWS(XX1XXXXX))
 
/* Check if S01433 (Enhanced Dealing Limits) installed and call DL0760A if so,                    */
/* else call DL0760                                                                               */
 
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'S01433')
 
             IF         COND(&RTCD *EQ '       ') THEN(CALL +
                        PGM(DL0760A) PARM(&RSEQ))
             ELSE       CMD(CALL PGM(DL0760) PARM(&RSEQ))
 
/* Reset job switch U3                                                                            */
 
             IF         COND((&CDL002 *EQ 'Y') *AND (&BNNTCE *EQ +
                          'Y')) THEN(CHGJOB SWS(XX0XXXXX))
 
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(GOTO CMDLBL(ABNOR))
 
/****************       DL0765 - MONEY MARKET EXPOSURE BY CUSTOMER           **********************/
 
/* Check if S01360 (Money Market Customer Exposure by Customer Report) is installed               */
/* and call DL0765 if so                                                                          */
 
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'S01360')
 
             IF         COND(&RTCD *EQ '       ') THEN(DO)
                SNDMSG     MSG('MONEY MARKET EXPOSURE BY CUSTOMER +
                             REPORT') TOMSGQ(MRUNQ)
                CALL       PGM(DL0765) PARM(&RSEQ)
             ENDDO
 
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(GOTO CMDLBL(ABNOR))
 
/****************       DL0780 - EXPOSURE BY COUNTRY OF RISK                 **********************/
 
             SNDMSG     MSG('COUNTRY OF RISK EXPOSURE AGAINST ALL +
                          LIMITS REPORT') TOMSGQ(MRUNQ)
 
/* Set job switch U3 if FX Netting and FX Customer Netting both installed                         */
 
             IF         COND((&CDL002 *EQ 'Y') *AND (&BNNTCE *EQ +
                          'Y')) THEN(CHGJOB SWS(XX1XXXXX))
 
             CALL       PGM(DL0780) PARM(&RSEQ)
 
/* Reset job switch U3                                                                            */
 
             IF         COND((&CDL002 *EQ 'Y') *AND (&BNNTCE *EQ +
                          'Y')) THEN(CHGJOB SWS(XX0XXXXX))
 
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(GOTO CMDLBL(ABNOR))
 
/****************       DL0800 - EXPOSURE BY REGION OF RISK                  **********************/
 
             SNDMSG     MSG('REGION OF RISK EXPOSURE AGAINST ALL +
                          LIMITS REPORT') TOMSGQ(MRUNQ)
 
             CALL       PGM(DL0800) PARM(&RSEQ)
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO CMDLBL(ENDPGM))
 
ABNOR:       IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                SNDMSG     MSG('Job terminated - database in error') +
                             TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                SNDMSG     MSG('File controls out of balance') +
                             TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
             CHGJOB     SWS(XXXXXXX1)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited')
 
 ENDPGM:     ENDPGM
