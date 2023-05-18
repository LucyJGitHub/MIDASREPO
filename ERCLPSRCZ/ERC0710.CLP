/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ER Download file to PCFILE format')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting Module                           */
/*                                                                   */
/*       ERC0710 - Downlaod CAd Reporting in PC Format               */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD027509           Date 10Oct22              */
/*       Prev Amend No. CSC059             Date 10Oct22              */
/*                      MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CER001             Date 25Apr05              */
/*                      209262             Date 20Feb01              */
/*                      ULX040  *CREATE    Date 20Feb01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD027509 - Change folder calculation to use absolute path.  */
/*                  Applied for MD-38096                             */
/*       CSC059 - Replace QDLS processing by IFS                     */
/*       MD046248 - Finastra Rebranding                              */
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
/*****       DCL        VAR(&TEXT) TYPE(*CHAR) LEN(50) VALUE(' ')                         /*CSC059*/
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(50)                                    /*CSC059*/
             DCL        VAR(&IASP_YN) TYPE(*CHAR) LEN(1)                                  /*CSC059*/
             DCL        VAR(&IASP) TYPE(*CHAR) LEN(10)                                    /*CSC059*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')                    /*CSC059*/
             DCL        VAR(&RTNC) TYPE(*CHAR) LEN(7) VALUE('       ')                    /*CSC059*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6) VALUE('CSC059')                      /*CSC059*/
             DCL        VAR(&SARREC) TYPE(*CHAR) LEN(200)                                 /*CSC059*/
             DCL        VAR(&CSC059) TYPE(*CHAR) LEN(1) VALUE('N' )                       /*CSC059*/
/*/COPY GPCPYSRCG,GPSVALDCL                                          */                   /*CSC059*/
             DCL        VAR(&TEXT) TYPE(*CHAR) LEN(50) VALUE(' ')
             DCL        VAR(&RETCOD) TYPE(*CHAR) LEN(7)                                   /*BA6016*/
             DCL        VAR(&FMT200) TYPE(*CHAR) LEN(200)                                 /*BA6016*/
             DCL        VAR(&BA6016) TYPE(*CHAR) LEN(1) VALUE('N')                        /*BA6016*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')

/**********  DCLF       FILE(ERPATHPD) RCDFMT(ERPATHD0)                   */              /*CER001*/
             DCLF       FILE(ERPTHXPD) RCDFMT(ERPATHD0)                                   /*CER001*/

             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR))
/*                                                                                        /*CSC059*/
/* Check if feature CSC059 is on */                                                       /*CSC059*/
             CALL       PGM(AOSARDR0) PARM(&RTNC &OPTN &SAR &SARREC)                      /*CSC059*/
             IF         COND(&RTNC *EQ '       ') THEN(CHGVAR +
                          VAR(&CSC059) VALUE('Y'))                                        /*CSC059*/
/* If CSC059 is on, check IASP */                                                         /*CSC059*/
             IF         COND(&CSC059 *EQ 'Y') THEN(DO)                                    /*CSC059*/
/*                                                                                        /*CSC059*/
/*  Get the global IASP system values */                                                  /*CSC059*/
/*                                                                                        /*CSC059*/
             CALL       PGM(GPAOSVALR0) PARM(&RSVALRTNC +
                          'IASPinstallation' &SVAL1 'IASPgroup' +
                          &SVAL2 &SVALK3 &SVAL3 &SVALK4 &SVAL4 +
                          &SVALK5 &SVAL5 &SVALK6 &SVAL6 &SVALK7 +
                          &SVAL7 &SVALK8 &SVAL8 &SVALK9 &SVAL9 +
                          &SVALK10 &SVAL10)                                               /*CSC059*/
/*                                                                                          CSC059*/
/** Check whether system is in IASP environment.                                            CSC059*/
/*                                                                                          CSC059*/
             CHGVAR     VAR(&IASP_YN) VALUE(%SST(&SVAL1 1 1))                             /*CSC059*/
/*                                                                                          CSC059*/
/*  If IASP environment,                                                                    CSC059*/
/*                                                                                          CSC059*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC059*/
/*                                                                                          CSC059*/
/*  Get name of IASP.                                                                       CSC059*/
/*                                                                                          CSC059*/
             CHGVAR     VAR(&IASP) VALUE(%SST(&SVAL2 1 10))                               /*CSC059*/
             CALL       PGM(AOSARDR0) PARM(&RETCOD '*VERIFY' +
                          'BA6016' &FMT200)                                               /*BA6016*/
             IF         COND(&RETCOD *EQ '       ') THEN(DO)                              /*BA6016*/
             CHGVAR     VAR(&BA6016) VALUE('Y')                                           /*BA6016*/
             ENDDO                                                                        /*BA6016*/
             ENDDO                                                                        /*CSC059*/
             ENDDO                                                                        /*CSC059*/

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

             IF         COND(&CSC059 *EQ 'Y') THEN(DO)                                    /*CSC059*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC059*/
/**********  CHGVAR     VAR(&FILE) VALUE(&IASP *TCAT '/' *CAT &DWERDT +
                            *TCAT '/' *CAT &DOCNAME)                         /*CSC059*/ /*MD027509*/
             CHGVAR     VAR(&FILE) VALUE('/' *CAT &IASP *TCAT '/' *CAT &DWERDT +
                            *TCAT '/' *CAT &DOCNAME)                                    /*MD027509*/
             ENDDO                                                                        /*CSC059*/
             ELSE       CMD(DO)                                                           /*CSC059*/
             CHGVAR     VAR(&FILE) VALUE('/' *CAT &DWERDT +
                            *TCAT '/' *CAT &DOCNAME)                                    /*MD027509*/
             ENDDO                                                                        /*CSC059*/
             CPYTOIMPF  FROMFILE(ERFT30PP) TOSTMF(&FILE) +
                          MBROPT(*REPLACE) STMFCODPAG(*PCASCII) +
                          RCDDLM(*CRLF) DTAFMT(*FIXED)                                    /*CSC059*/
/** Invoke Handelsbanken command IFSAUT to correctly set user        */                   /*BA6016*/
/** authority to the IFS directory                                   */                   /*BA6016*/
                                                                                          /*BA6016*/
             IF         COND((&IASP_YN *EQ 'Y') *AND (&BA6016 *EQ +
                        'Y')) THEN(DO)                                                    /*BA6016*/
             IFSAUT     PATH(&FILE)                                                       /*BA6016*/
             MONMSG     MSGID(CPF0000)                                                    /*BA6016*/
             ENDDO                                                                        /*BA6016*/
                                                                                          /*CSC059*/
             ENDDO                                                                        /*CSC059*/
             ELSE       CMD(DO)                                                           /*CSC059*/
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
             ENDDO                                                                        /*CSC059*/

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

             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited')
             MONMSG     MSGID(CPF0000)
             ENDPGM
