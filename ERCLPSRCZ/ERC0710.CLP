/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ER Download file to PCFILE format')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting Module                           */
/*                                                                   */
/*       ERC0710 - Downlaod CAd Reporting in PC Format               */
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
 
             PGM        PARM(&PREFIX &TYPE &ERROR)
 
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&EDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DOCNAME) TYPE(*CHAR) LEN(12)
             DCL        VAR(&TEXT) TYPE(*CHAR) LEN(50) VALUE(' ')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
 
/**********  DCLF       FILE(ERPATHPD) RCDFMT(ERPATHD0)                   */              /*CER001*/
             DCLF       FILE(ERPTHXPD) RCDFMT(ERPATHD0)                                   /*CER001*/
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR))
 
/***  Recognized types are : 'RT30' ***/
             IF         COND(&TYPE *NE 'RT30') THEN(GOTO +
                          CMDLBL(ENDPGM))
 
             CHGVAR     VAR(&ERROR) VALUE('Y')
 
/***  Do RT30 Specific Treatment  ***/
             IF         COND(&TYPE *EQ 'RT30') THEN(DO)
 
/***  Send message  ***/
/**********  SNDPGMMSG  MSG('ERC0710 - RT30 Formatting CAD file started') +
                          TOMSGQ(CADMSGQ MOPERQ MRUNQ)                    */              /*CER001*/
             SNDPGMMSG  MSG('ERC0710 - RT30 Formatting CAD file started') +
                          TOMSGQ(MOPERQ MRUNQ)                                            /*CER001*/
 
/***  Format ERLUCAPD file into xxDPLIB/ERFT30PP ***/
             CHGVAR     VAR(&TOLIB) VALUE(&PREFIX *CAT 'DPLIB')
             OVRDBF     FILE(ERFT30PP) TOFILE(&TOLIB/ERFT30PP)
/**********  OVRDBF     FILE(ERBANKPD) SHARE(*NO)                         */              /*CER001*/
             OVRDBF     FILE(ERBNKXPD) SHARE(*NO)                                         /*CER001*/
             CLRPFM     FILE(&TOLIB/ERFT30PP)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
/***  Call pgm for Formattage.  ***/
             CHGVAR     VAR(&EDATE) VALUE('      ')
/**********  CALL       PGM(ER0710) PARM(&EDATE)                          */              /*CER001*/
             CALL       PGM(ER0710A) PARM(&EDATE)                                         /*CER001*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/**********  SNDPGMMSG  MSG('ERC0710 - Formattage failed, do +
                          formattage manually during I/C.') +
                          TOMSGQ(CADMSGQ MOPERQ MRUNQ)                    */              /*CER001*/
             SNDPGMMSG  MSG('ERC0710 - Formattage failed, do +
                          formattage manually during I/C.') +
                          TOMSGQ(MOPERQ MRUNQ)                                            /*CER001*/
             GOTO       CMDLBL(ERROR)
             ENDDO
 
/*** Send Message for Creation in Folder ***/
/**********  SNDPGMMSG  MSG('ERC0710 - RT30 Formattage ended succesfully +
                          (ERFT30PP) - Preparing download.') +
                          TOMSGQ(CADMSGQ MOPERQ MRUNQ)                    */              /*CER001*/
             SNDPGMMSG  MSG('ERC0710 - RT30 Formattage ended succesfully +
                          (ERFT30PP) - Preparing download.') +
                          TOMSGQ(MOPERQ MRUNQ)                                            /*CER001*/
 
             RCVF       DEV(*FILE) RCDFMT(ERPATHD0)
 
/***  If not Folder, don't copy file in Document  ***/
 
             IF         COND(&DWERDT *EQ '                ') THEN(DO)
             SNDPGMMSG  MSG('ERC0710 - Download failed due to no +
                          Path specified - Transfer manually (See +
                          Transfer details documentation)') +
                          TOMSGQ(CADMSGQ MOPERQ MRUNQ)
             GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/***  RT30 : When OK, Create Doc. name  ***/
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
 
             ENDDO            /***  RT30 Treatment.  ***/
 
/***  Leave PGM  ***/
             CHGVAR     VAR(&ERROR) VALUE('N')
 
             GOTO       CMDLBL(ENDPGM)
 
/***ERROR:******IF         COND(&TYPE *EQ 'RT30') THEN(SNDPGMMSG +
                          MSG('Download of ERFT30PP failed') +
                          TOMSGQ(CADMSGQ MOPERQ MRUNQ))                   */              /*CER001*/
    ERROR:      IF         COND(&TYPE *EQ 'RT30') THEN(SNDPGMMSG +
                          MSG('Download of ERFT30PP failed') +
                          TOMSGQ(MOPERQ MRUNQ))                                           /*CER001*/
 
 ENDPGM:     DLTOVR     FILE(ERFT30PP)
             MONMSG     MSGID(CPF0000)
/**********  DLTOVR     FILE(ERBANKPD)                                    */              /*CER001*/
             DLTOVR     FILE(ERBNKXPD)                                                    /*CER001*/
             MONMSG     MSGID(CPF0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International +
                          Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000)
             ENDPGM
