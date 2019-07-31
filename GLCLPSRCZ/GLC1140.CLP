/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL Amount Accrual Update, Entry Gen')           */
/********************************************************************/
/*                                                                  */
/*        Midas     - General Ledger Module                     */
/*                                                                  */
/*       GLC1140 - AMOUNT ACCRUAL UPDATE & ENTRY GENERATION         */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CGL141             Date 12Dec12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      E41721             Date 25Jun92              */
/*                    .   E18361             DATE  25NOV89          */
/*       PREV AMEND NO.   E18526             DATE  25/09/89         */
/*       LAST AMEND NO.    S01189            DATE  03/04/89         */
/*       PREV AMEND NO.    S01194            DATE  16/03/89         */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*      CGL141 - Amount Accruals Extended Narrative.                */
/*               Added Hooks: CGL141_001 to CGL141_003              */
/*      E41721 - ADD GLOBAL MONMSG AND ERROR PROCESSING             */
/*      E18361 - NOT APPLIED AS SUPERCEDED BY S01189                */
/*               ( CORRECTION TO E18526 )                           */
/*      E18526 - NOT APPLIED AS SUPERCEDED BY S01189                */
/*               ( POSITIONS FOR MFU INDICATOR IN GLSTAT INCORRECT )*/
/*      S01189 - COB 2 ENHANCEMENTS - THESE SUPERSEDE ERROR FIXES   */
/*               E18361 AND E18526                                  */
/*      S01194 - NEW STANDING DATA                                  */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*           PGM                                                     //*S01189*/
             PGM     PARM(&CNAM &CSEQ)                                /*S01189*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MSG)     TYPE(*CHAR) LEN(75)
/*********** DCL        VAR(&MEM)     TYPE(*CHAR) LEN(44)*/           /*S01194*/
             DCL        VAR(&MEM)     TYPE(*CHAR) LEN(50)             /*S01194*/
             DCL        VAR(&LDA)     TYPE(*CHAR) LEN(256)
/*           DCL        VAR(&GLSTAT)  TYPE(*CHAR) LEN(256)           //*S01189*/
             DCL        VAR(&CNAM)    TYPE(*CHAR) LEN(10)             /*S01189*/
             DCL        VAR(&CSEQ)    TYPE(*DEC) LEN(5)               /*S01189*/
             DCL        VAR(&BUSY)    TYPE(*CHAR) LEN(1)              /*S01189*/
/*/COPY OFCPYSRCZ,CGL141_001                                         */                   /*CGL141*/
/**/
/*   MONITOR ANY ERROR MESSAGE DURING PGM AND GO TO ABNORMAL */
/*   PROCESSING IF THERE IS A PROBLEM                041721  */
/**/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR)) /* E41721 */
/**/
/**/
             CHGJOB   SWS(00000000)
/**/
/*********** OVRDBF     FILE(TABLE) TOFILE(TABGL)*/                   /*S01194*/
/**/
                   SNDPGMMSG  MSG('Amount Accrual Update & Entry Generation') +
                                TOMSGQ(MRUNQ)
/**/
/*           RTVDTAARA  DTAARA(GLSTAT) RTNVAR(&GLSTAT)               //*S01189*/
             CHGVAR     VAR(&BUSY) VALUE(' ')                         /*S01189*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
/**/
/*         IF COND(%SUBSTRING(&GLSTAT 54 3) = 'OLD') THEN(DO)        //*S01189*/
           IF         COND(&BUSY = 'N') THEN(DO)                      /*S01189*/
/*/COPY OFCPYSRCZ,CGL141_002                                         */                   /*CGL141*/
/**/
             CLRPFM NAMACA
             CLRPFM NAMACD
             CLRPFM NAMACZ
             CLRPFM GEAAPD
             CLRPFM GEAAZZ
             OVRDBF     FILE(GEAAPD) SEQONLY(*YES 250)
/**/
             CALL   GL1140
/**/
/**/
          ENDDO
/**/
           IF COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/
/*           CHGDTAARA  DTAARA(GLSTAT (53 3)) VALUE(NEW)             //*S01189*/
/*           CHGDTAARA  DTAARA(GLSTAT) VALUE(&GLSTAT)                //*S01189*/
             CHGVAR     VAR(&BUSY) VALUE('Y')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
/**/
             CLRPFM AMACCA
             CLRPFM AMACCD
             CLRPFM AMACCZ
/**/
             CPYF NAMACA AMACCA MBROPT(*REPLACE) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(AMACCA))
             CPYF NAMACD AMACCD MBROPT(*REPLACE) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(AMACCD))
             CPYF NAMACZ AMACCZ MBROPT(*REPLACE) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(AMACCZ))
/*/COPY OFCPYSRCZ,CGL141_003                                         */                   /*CGL141*/
/**/
/*           RTVDTAARA  DTAARA(GLSTAT) RTNVAR(&GLSTAT)               //*S01189*/
/*           CHGDTAARA  DTAARA(GLSTAT (10 3)) VALUE(OLD)             //*S01189*/
/*           CHGDTAARA  DTAARA(GLSTAT) VALUE(&GLSTAT)                //*S01189*/
             CHGVAR     VAR(&BUSY) VALUE('N')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
/**/
          ENDDO
/**/
          DLTOVR *ALL
/**/
/*  SEND FILE CONTROL MESSAGES  */
/**/
/*********** IF COND(%SWITCH(XXXXXXX1)) THEN(DO)*/                    /*S01194*/
             IF COND(%SWITCH(XXXXXX01)) THEN(DO)                      /*S01194*/
/**/
               CHGVAR &MSG VALUE('FILE CONTROLS OUT OF BALANCE - FILE +
                                 AMACC')
               SNDPGMMSG &MSG TOMSGQ(MOPERQ)
               SNDPGMMSG &MSG TOPGMQ(*EXT)
             ENDDO
/**/
/*  SEND DATABASE MESSAGES  */
/**/
             IF COND(%SWITCH(XXXXXX1X)) THEN(DO)
/**/
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
/***********    CHGVAR &MEM VALUE(%SUBSTRING(&LDA 134 44))*/          /*S01194*/
                CHGVAR &MEM VALUE(%SUBSTRING(&LDA 134 50))            /*S01194*/
                SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ) TOPGMQ(*EXT)
/**/
             ENDDO
/**/
/*   IF NO ERRORS OCCURED DURING PGM GO TO END OF PGM   E41721 */
/**/
             GOTO CMDLBL(ENDIT) /*E41721*/
/**/
/*   ERROR PROCESSING FOR UNMONITORED MESSAGES          E41721 */
/**/
 ABNOR:      CHGJOB     SWS(XXXXXX11) /* E41721 */
/**/
/*   MONITOR FOR ERRORS WITHIN ABNORMAL PROCESSING TO STOP LOOPING */
/**/
             MONMSG     MSGID(CPF0000) /* E41721 */
             CHGVAR     VAR(&MSG) VALUE('ERROR IN GLC1140 - SEE JOB +
                          LOG') /* E41721 */
             MONMSG     MSGID(CPF0000) /* E41721 */
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ) /* E41721 */
             MONMSG     MSGID(CPF0000) /* E41721 */
             SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) /* E41721 */
             MONMSG     MSGID(CPF0000) /* E41721 */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             MONMSG     MSGID(CPF0000) /* E41721 */
/**/
/**/
/*           ENDPGM             E41721*/
 ENDIT:      ENDPGM   /*E41721*/
