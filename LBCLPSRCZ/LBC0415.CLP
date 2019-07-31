/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LB Availability Below Zero Report')             */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Lending Module                        */
/*                                                                   */
/*       LBC0415 - Availability Below Zero Report                    */
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
/*       Prev Amend No. 096092             Date 23Nov95              */
/*                      S01498             Date 11Aug94              */
/*                      35723              DATE 11FEB92              */
/*                      S01189     GB      DATE 11AUG92              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       096092 - OPNQRYF is not part of recovery proc. (S01498)     */
/*                LB0405P1 not keyed by acc. officer                 */
/*       S01498 - Portfolio Lending Upgrade to Release 10            */
/*                COB recovery processing removed                    */
/*       35723  - LB PROGRAM CANNOT BE RESTARTABLE                   */
/*       S01189 - COB RECOVERY PROCESSING                            */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&RSEQ &RLEV &RENT)                       /*S01498*/
/*>>S01189>>*/
/**********  PGM                                                    **/
/*********** PGM        PARM(&CNAM &CSEQ)                          */ /*S01498*/
/*********** DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)             */ /*S01498*/
/*********** DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)               */ /*S01498*/
/*********** DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)              */ /*S01498*/
/*<<S01189<<*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01498*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01498*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01498*/
 
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(52)
 
/* Global monitor message error trap                                 */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000 CPA0000) +
                          EXEC(GOTO CMDLBL(MONTAG))
             GOTO       CMDLBL(RUN)
 
 MONTAG:     DMPCLPGM
             CHGJOB     SWS(XXXXXX11)                                  /*35723*/
             RCLRSC
             RETURN
 
/* Send program message                                              */
 RUN:        SNDPGMMSG  MSG('LBC0415 - Availability below zero +
                          report') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* Reset external switches                                           */
             CHGJOB     SWS(XXXXXX00)
 
/*>>S01189>>*/
/***********       CHGVAR     VAR(&BUSY) VALUE(' ')                */ /*S01498*/
/***********       CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)       */ /*S01498*/
/***********       CHGVAR     VAR(&BUSY) VALUE('N')                */ /*S01498*/
/***********       CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)       */ /*S01498*/
/*<<S01189<<*/
/* Processing                                                        */
 
/*********** OVRDBF     FILE(SDCUSTPD) SHARE(*YES)                 */ /*S01498*/
/*********** OPNQRYF FILE((SDCUSTPD) (SDLBCSPD)) FORMAT(SDCUSTPD) +*/ /*S01498*/
/***********            QRYSLT('(BBTYLC *NE "D") *AND (CUCHTP *NE +*/ /*S01498*/
/***********              "D") *AND (CULOMB *EQ "Y")') +           */ /*S01498*/
/***********              KEYFLD((BBBRCD) (BBACOC) (BBPCNB) +      */ /*S01498*/
/***********              (BBCUST)) JFLD((1/BBCUST 2/CUPNP8))      */ /*S01498*/
             OVRDBF     FILE(SDCUSTPD) SHARE(*YES)                    /*096092*/
             OPNQRYF FILE((SDCUSTPD) (SDLBCSPD)) FORMAT(SDCUSTPD) +
                        QRYSLT('(BBTYLC *NE "D") *AND (CUTYLC *NE +
                          "D") *AND (CULOMB *EQ "Y")') +
                          KEYFLD((BBBRCD) (BBACOC) (BBPCNB) +
                          (BBCUST)) JFLD((1/BBCUST 2/CUCUST))         /*096092*/
 
/*********** CALL       PGM(LB0415)                                */ /*S01498*/
             CALL       PGM(LB0415) PARM(&RSEQ &RENT)                 /*S01498*/
 
/*********** CLOF       OPNID(SDCUSTPD)                            */ /*S01498*/
/*********** DLTOVR     FILE(SDCUSTPD)                             */ /*S01498*/
             CLOF       OPNID(SDCUSTPD)                               /*096092*/
             DLTOVR     FILE(SDCUSTPD)                                /*096092*/
 
/* Data base error processing                                        */
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
/*********** SNDPGMMSG  MSGID(DBM0001) MSGF(LXGBMSGF) MSGDTA(&MEM)+*/ /*S01498*/
/***********                           TOMSGQ(MOPERQ MRUNQ)        */ /*S01498*/
             SNDPGMMSG  MSGID(DBM0001) MSGF(LBUSRMSG) MSGDTA(&MEM) +
                                       TOMSGQ(MOPERQ MRUNQ)           /*S01498*/
             GOTO       CMDLBL(ENDPGM)
/*>>S01189>>*/
/***********       CHGVAR     VAR(&BUSY) VALUE('Y')                */ /*S01498*/
/***********       CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)       */ /*S01498*/
/*<<S01189<<*/
             ENDDO
 
 ENDPGM:     RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
