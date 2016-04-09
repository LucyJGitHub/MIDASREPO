/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ER Download file to PCFILE format - I/C')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting Module                           */
/*                                                                   */
/*       ERCLU26 - Download CAd Reporting in PC Format - I/C         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CER001             Date 25Apr05              */
/*       Prev Amend No. 209262             Date 20Feb01              */
/*                      ULX040  *CREATE    Date 20Feb01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       209262 - CHANGE .PP TO .TXT                                 */
/*       ULX040 - FIRE - RT30 Generation in Midas                    */
/*                                                                   */
/*********************************************************************/
 
             PGM
 
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&EDATE) TYPE(*CHAR) LEN(6)
/**********  DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)                   */              /*CER001*/
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(4)
/**********  DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)                   */              /*CER001*/
             DCL        VAR(&DOCNAME) TYPE(*CHAR) LEN(12)
             DCL        VAR(&TEXT) TYPE(*CHAR) LEN(50) VALUE(' ')
             DCL        VAR(&RETCOD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&FMT200) TYPE(*CHAR) LEN(200)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
 
             DCLF       FILE(ERPATHPD) RCDFMT(ERPATHD0)
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR))
 
/***  Verify that Car is present ***/
             CALL       PGM(AOSARDR0) PARM(&RETCOD '*VERIFY' +
                          'ULX040' &FMT200)
             IF         COND(&RETCOD *EQ '       ') THEN(DO)
 
             CHGVAR     VAR(&ERROR) VALUE('Y')
 
             SNDPGMMSG  MSG('ERCLU26 - RT30 Formatting CAD file +
                          started') TOMSGQ(MOPERQ MRUNQ)
 
             CALL ERLU26 PARM(&EDATE  &ERROR)
             IF         COND(&ERROR *EQ 'E') THEN(GOTO CMDLBL(ERROR))
 
/***  Format ERLUCAPD file into xxDPLIB/ERLUCAPD ***/
/**********  RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)              */              /*CER001*/
/**********  CHGVAR     VAR(&TOLIB) VALUE(&PREFIX *CAT 'CADLIB') */                       /*CER001*/
/**********  CHGVAR     VAR(&TOLIB) VALUE(&PREFIX *CAT 'DVLIB')           */              /*CER001*/
             CLRPFM     FILE(ERFT30PP)
/**********  OVRDBF     FILE(ERLUCAL0) TOFILE(&TOLIB/ERLUCAL0)            */              /*CER001*/
             OVRDBF     FILE(ERLUCAL0) TOFILE(ERLCAXL0)                                   /*CER001*/
 
/***  Call pgm for Formattage.  ***/
 /*          ADDLIBLE   LIB(&TOLIB)     */
             CALL       PGM(ER0710) PARM(&EDATE)
   /*        RMVLIBLE   LIB(&TOLIB)       */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             SNDPGMMSG  MSG('ERCLU26 - ER0710 - Formattage failed, +
                          display joblog.') TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(ERROR)
             ENDDO
 
             RCVF       DEV(*FILE) RCDFMT(ERPATHD0)
 
/***  If not Folder, don't copy file in Document  ***/
 
             IF         COND(&DWERDT *EQ '                ') THEN(DO)
             SNDPGMMSG  MSG('ERCLU26 - Download failed due to no +
                          Path specified - Transfer manually (See +
                          Transfer details documentation)') +
                          TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/***   When OK, Create Doc. name  ***/
/**          CHGVAR     VAR(&DOCNAME) +
                        VALUE('ER' *CAT &EDATE *CAT '.PP')    ** 209262 */
             CHGVAR     VAR(&DOCNAME) +
                        VALUE('ER' *CAT &EDATE *CAT '.TXT')                  /* 209262 */
 
             CHGVAR     VAR(&TEXT) VALUE('CAD - Download of' *CAT +
                          %SST(&EDATE 1 2) *CAT '/' *CAT +
                          %SST(&EDATE 3 2) *CAT '/' *CAT +
                          %SST(&EDATE 5 2) )
 
/***  Create in folder ***/
             CPYTOPCD   FROMFILE(ERFT30PP) TOFLR(&DWERDT) +
                          TODOC(&DOCNAME) REPLACE(*YES) +
                          TRNTBL(*DFT) TRNFMT(*TEXT)
 
/***  Add a description  ***/
             CHGDOCD    DOC(&DOCNAME) FLR(&DWERDT) DOCD(&TEXT)
             MONMSG     MSGID(CPF0000 OFC0000)
 
             ENDDO            /***  ULX040 Treatment.  ***/
 
/***  Leave PGM  ***/
             CHGVAR     VAR(&ERROR) VALUE('N')
 
             GOTO       CMDLBL(ENDPGM)
 
 ERROR:      SNDPGMMSG  MSG('Download of ERFT30PP failed') +
                          TOMSGQ(MOPERQ MRUNQ)
 
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International +
                          Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000)
             ENDPGM
