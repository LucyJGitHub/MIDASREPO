/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Customer Confs (COB) Phase 3 At End')        */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  FUtures and Options Module                        */
/*                                                                   */
/*   FFC0692C -  Customer Confirmations (COB) Phase 3                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   LAST AMEND NO. CFF001             DATE 01JUN95                  */
/*   PREV AMEND NO. S01522             DATE 15MAR95                  */
/*                  Xxxxxx             DATE ddmmmyy                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*   CFF001  -  ENHANCED OTC PROCESSING SWITCHABLE FEATURE           */
/*   S01522  -  User Defined Correspondence                          */
/*              Split FFC0692 into three components                  */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&DATA)       TYPE(*CHAR) LEN(50)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CFF001*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CFF001*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*CFF001*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*CFF001*/
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/* */
/* Send Message to MRUNQ and standard processing parameters */
/* */
             SNDPGMMSG  MSG('FFC0692C - Customer Confirmations Phase +
                          3 At End') TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXX000)
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CFF001*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CFF001*/
             CHGVAR     VAR(&SAR) VALUE('CFF001')                     /*CFF001*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CFF001*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CFF001*/
             GOTO       CMDLBL(ENDCLPGM)                              /*CFF001*/
             ENDDO                                                    /*CFF001*/
/**/
/*  OTC Confirmations need U6 on (for FFSETL)                       */
/**/
             CHGJOB     SWS(XXXXX100)
/**/
/*   Call FF0584 - OTC Confirmations Print: At End                  */
/**/
             CALL       PGM(FF0584)
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/* */
             GOTO       CMDLBL(ENDCLPGM)
/* */
/* Report Database errors trapped by program */
/* */
 DBERR:
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
 
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program FFC0692C ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          FFC0692C ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/* */
             ENDPGM
