/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas ED Drip feed controller')                       */
/********************************************************************/
/*                                                                  */
/*       Midas - Midas Export Data Interface Module                 */
/*                                                                  */
/*       EDC0040 - Drip Feed Controller                             */
/*                                                                  */
/*       Function : This program controls the production of Drip    */
/*                  Feed batches.                                   */
/*                                                                  */
/*       Submitted by : RRRECOVER                                   */
/*                      SCC0103                                     */
/*                      SCMINIT                                     */
/*                      SCBACKUP                                    */
/*                                                                  */
/*       Called by :    SCC05                                       */
/*                                                                  */
/*       Calls :  EDC0050                                           */
/*                ED0080                                            */
/*                EDC0045                                           */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*       Last Amend No. MD021155           Date 10Jul13              */
/*       Prev Amend No. AR1060743          Date 26Nov12              */
/*                      CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             Date 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      113682             DATE 04FEB98             */
/*                      S01408             DATE 19JUN95             */
/*                      S01493 *CREATE     DATE 16MAY94             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD021155 - COB Restructure Phase 1 remnants                */
/*                - CCB009 conditioning left in                     */
/*       AR1060743 - All HATS input initial screen appears a        */
/*                   confirmation of NWDC processing                */
/*       CCB020 - COB Restructure - Secondary COB Infrastracture    */
/*       CCB009 - Journal files throughout close of business        */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       113682 - Error messages should be sent to MOPERQ not       */
/*                QSYSOPR.                                          */
/*       S01408 - Addition of core hook EDC0040MP1                  */
/*       S01493 - Midas Export Data Interface Module                */
/*                                                                  */
/********************************************************************/
             PGM
 
/* Copyright statement definition */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Other declarations */
 
/**********  DCL        VAR(&PHASE) TYPE(*CHAR) LEN(1)                                 */ /*CCB020*/
             DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(4)                                    /*CCB020*/
             DCL        VAR(&CMTC) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&EDDRIP) TYPE(*CHAR) LEN(43)
             DCL        VAR(&JOBN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USRN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JBNB) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DFEN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DFWT) TYPE(*DEC) LEN(5)
             DCL        VAR(&PJLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(2)
/*******************************************************************          */ /*CCB009 MD021155*/
/**Declare*variable*CCB009*-*flag*for*switchable*feature************          */ /*CCB009 MD021155*/
/*******************************************************************          */ /*CCB009 MD021155*/
/**********  DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)                       */ /*CCB009 MD021155*/
/**********  DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)                      */ /*CCB009 MD021155*/
 
 
/* Global error monitor */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*******************************************************************          */ /*CCB009 MD021155*/
/***Check*for*Switchable*feature*CCB009.****************************          */ /*CCB009 MD021155*/
/*******************************************************************          */ /*CCB009 MD021155*/
/**********  CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +                       */ /*MD021155*/
/**********               'CCB009' &AOFMT)                                    */ /*CCB009 MD021155*/
             CHGJOB     SWS(00000000)
 
/* Copyright statement definition - at runtime */
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/* If Input Cycle then create LDA */
 
/**********  RTVDTAARA  DTAARA(MPHAS (1 1)) RTNVAR(&PHASE)                             */ /*CCB020*/
/**********  CALL       PGM(CBC000001) PARM(&MPHAS)                             /*CCB020 AR1060743*/
             CALL       PGM(CBC001001) PARM(&MPHAS)                                    /*AR1060743*/
 
/**********  IF         COND(&PHASE *EQ 'A') THEN(DO)                                  */ /*CCB020*/
/**********     CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +                    */ /*CCB020*/
/**********                  TEXT('Midas LDA')                                         */ /*CCB020*/
             IF         COND(&MPHAS *EQ '*NO') THEN(DO)                                   /*CCB020*/
                CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                             TEXT('Midas LDA')                                            /*CCB020*/
             ENDDO
 
/* Allocate DTAARA/EDC0040 so another copy of the job not submitted */
 
             ALCOBJ     OBJ((EDC0040 *DTAARA *EXCL))
             MONMSG     MSGID(CPF1002) EXEC(DO)
               SNDPGMMSG  MSG('Midas Export Data Interface Background +
                            job cannot allocate needed object (data +
                            area EDC0040). Drip Feed will attempt to +
                            restart at next signon into MIDAS system.')
               GOTO       CMDLBL(ENDCLPGM)
             ENDDO
 
/* Amend EDDRIP with job details so the job can be ended by SCC05 */
 
             RTVJOBA    JOB(&JOBN) USER(&USRN) NBR(&JBNB)
 
             RTVDTAARA  DTAARA(EDDRIP) RTNVAR(&EDDRIP)
             CHGDTAARA  DTAARA(EDDRIP (18 26)) VALUE(&JOBN *CAT +
                          &USRN *CAT &JBNB)
 
             MONMSG     MSGID(CPF1063) EXEC(DO)
               SNDPGMMSG  MSG('Midas Export Data Interface Background +
                            job cannot allocate needed object (data +
                            area EDDRIP). Drip Feed will attempt to +
                            restart at next signon into MIDAS system.')
               GOTO       CMDLBL(ENDCLPGM)
             ENDDO
 
/* Retrieve Interface ICD */
 
LOOP:
 
             CALL       PGM(EDC0045) PARM(&DFEN &DFWT)
 
/* Create Batches if I/F should be active */
 
             IF         COND(&DFEN *EQ 'Y') THEN(DO)
 
/* If commitment control and journalling are not on then ...... */
 
                IF         COND(&CMTC *EQ 'N') THEN(DO)
 
/*******************************************************************          */ /*CCB009 MD021155*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),****          */ /*CCB009 MD021155*/
/*******************************************************************          */ /*CCB009 MD021155*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)                  */ /*CCB009 MD021155*/
/**Delete*old*journal*etc.*if*they*exist**/ /*                                       */ /*MD021155*/
/*******************************************************************                 */ /*MD021155*/
/**********        ENDJRNPF   FILE(*ALL) JRN(EDJRN)                                  */ /*MD021155*/
/**********        MONMSG     MSGID(CPF9801)                                         */ /*MD021155*/
/*******************************************************************                 */ /*MD021155*/
/**********        DLTJRN     JRN(EDJRN)                                             */ /*MD021155*/
/**********        MONMSG     MSGID(CPF2105)                                         */ /*MD021155*/
/**********                                                                          */ /*MD021155*/
/**********        CHGJOB     INQMSGRPY(*DFT)                                        */ /*MD021155*/
/**********                                                                          */ /*MD021155*/
/**********        DLTJRNRCV  JRNRCV(EDRCV000)                                       */ /*MD021155*/
/**********        MONMSG     MSGID(CPF2105)                                         */ /*MD021155*/
/**********                                                                          */ /*MD021155*/
/**********        CHGJOB     INQMSGRPY(*RQD)                                        */ /*MD021155*/
/**********  ENDDO                                                            */ /*CCB009 MD021155*/
 
/* Create new journalling environment */
 
                   CHGVAR     VAR(&CMTC) VALUE('Y')
 
                   RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREF)
                   CHGVAR     VAR(&PJLIB) VALUE(&PREF *CAT 'JLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,EDC0040MP1                                          */
                                                                      /*S01408*/
/*******************************************************************          */ /*CCB009 MD021155*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),****          */ /*CCB009 MD021155*/
/*******************************************************************          */ /*CCB009 MD021155*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)                  */ /*CCB009 MD021155*/
/**********        CRTJRNRCV  JRNRCV(&PJLIB/EDRCV000) AUT(*ALL)                      */ /*MD021155*/
/**********        MONMSG     MSGID(CPF7010)                                         */ /*MD021155*/
/**********                                                                          */ /*MD021155*/
/**********        CRTJRN     JRN(&PJLIB/EDJRN)  +                                   */ /*MD021155*/
/**********                     JRNRCV(&PJLIB/EDRCV000) AUT(*ALL)                    */ /*MD021155*/
/**********        MONMSG     MSGID(CPF7010)                                         */ /*MD021155*/
/**********                                                                          */ /*MD021155*/
/**********        STRJRNPF   FILE(EDOLDJPD EDSAVEPD EDDFAUPD EDLASTPD) +            */ /*MD021155*/
/**********                    JRN(EDJRN) IMAGES(*BOTH) OMTJRNE(*OPNCLO)             */ /*MD021155*/
/**********        MONMSG     MSGID(CPF7030)                                         */ /*MD021155*/
/**********  ENDDO                                                            */ /*CCB009 MD021155*/
 
/* Start commitment control */
 
/**********        STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))      /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
                   MONMSG     MSGID(CPF8351)
                ENDDO
 
/* Create new batches */
 
                CALL       PGM(EDC0050)
                IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO +
                             CMDLBL(ABNOR))
 
/* Delete processed batches */
 
                CALL       PGM(ED0080)
 
                IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                   ROLLBACK
                   GOTO       CMDLBL(ABNOR)
                ENDDO
                COMMIT
             ENDDO
 
/* OTHERWISE */
 
/* If Interface has been switched off then end Commitment Control */
/* and journalling.                                               */
 
             ELSE       CMD(DO)
               IF         COND(&CMTC *EQ 'Y') THEN(DO)
/*******************************************************************          */ /*CCB009 MD021155*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),****          */ /*CCB009 MD021155*/
/*******************************************************************          */ /*CCB009 MD021155*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)                  */ /*CCB009 MD021155*/
/**********      ENDJRNPF   FILE(*ALL) JRN(EDJRN)                                    */ /*MD021155*/
/**********      MONMSG     MSGID(CPF9801)                                           */ /*MD021155*/
/**********                                                                          */ /*MD021155*/
/**********      DLTJRN     JRN(EDJRN)                                               */ /*MD021155*/
/**********      MONMSG     MSGID(CPF2105)                                           */ /*MD021155*/
/**********                                                                          */ /*MD021155*/
/**********      CHGJOB     INQMSGRPY(*DFT)                                          */ /*MD021155*/
/**********                                                                          */ /*MD021155*/
/**********      DLTJRNRCV  JRNRCV(EDRCV000)                                         */ /*MD021155*/
/**********      MONMSG     MSGID(CPF2105)                                           */ /*MD021155*/
/**********      CHGJOB     INQMSGRPY(*RQD)                                          */ /*MD021155*/
/**********  ENDDO                                                            */ /*CCB009 MD021155*/
 
                 ENDCMTCTL
                 CHGVAR     VAR(&CMTC) VALUE('N')
               ENDDO
             ENDDO
 
/* If still Input Cycle then repeat the process */
 
/**********  RTVDTAARA  DTAARA(MPHAS (1 1)) RTNVAR(&PHASE)                             */ /*CCB020*/
             CALL PGM(CBC000001) PARM(&MPHAS)                                             /*CCB020*/
 
/**********  IF         COND(&PHASE *EQ 'A') THEN(DO)                                  */ /*CCB020*/
/**********    DLYJOB     DLY(&DFWT)                                                   */ /*CCB020*/
/**********    GOTO       CMDLBL(LOOP)                                                 */ /*CCB020*/
             IF         COND(&MPHAS *EQ '*NO') THEN(DO)                                   /*CCB020*/
               DLYJOB     DLY(&DFWT)                                                      /*CCB020*/
               GOTO       CMDLBL(LOOP)                                                    /*CCB020*/
             ENDDO
 
             GOTO       CMDLBL(ENDCLPGM)
 
ABNOR:
/*113682*****SNDPGMMSG  MSG('EDC0040 Midas Export Data Drip Feed +
                          Controller TERMINATED ABNORMALLY') +
                          TOMSGQ(*SYSOPR) MSGTYPE(*INQ)              /*113682*/
             SNDPGMMSG  MSG('EDC0040 Midas Export Data Drip Feed +
                          Controller TERMINATED ABNORMALLY') +
                          TOMSGQ(MOPERQ MRUNQ)                       /*113682*/
             MONMSG     MSGID(CPF0000 MCH0000)
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
               CHGJOB     SWS(XXXXXX11)
               MONMSG     MSGID(CPF0000 MCH0000)
               DMPCLPGM
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
ENDCLPGM:
             DLCOBJ     OBJ((EDC0040 *DTAARA *EXCL))
             ENDPGM
