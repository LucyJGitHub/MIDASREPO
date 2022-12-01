/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ER Download file to PCFILE format - I/C')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting Module                           */
/*                                                                   */
/*       ERCLU26 - Download CAd Reporting in PC Format - I/C         */
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

             PGM

             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&EDATE) TYPE(*CHAR) LEN(6)
/**********  DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)                   */              /*CER001*/
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(4)
/**********  DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)                   */              /*CER001*/
             DCL        VAR(&DOCNAME) TYPE(*CHAR) LEN(12)
             DCL        VAR(&TEXT) TYPE(*CHAR) LEN(50) VALUE(' ')
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(50)                                    /*CSC059*/
             DCL        VAR(&IASP_YN) TYPE(*CHAR) LEN(1)                                  /*CSC059*/
             DCL        VAR(&IASP) TYPE(*CHAR) LEN(10)                                    /*CSC059*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')                    /*CSC059*/
             DCL        VAR(&RTNC) TYPE(*CHAR) LEN(7) VALUE('       ')                    /*CSC059*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6) VALUE('CSC059')                      /*CSC059*/
             DCL        VAR(&SARREC) TYPE(*CHAR) LEN(200)                                 /*CSC059*/
             DCL        VAR(&CSC059) TYPE(*CHAR) LEN(1) VALUE('N' )                       /*CSC059*/
/*/COPY GPCPYSRCG,GPSVALDCL                                          */                   /*CSC059*/
             DCL        VAR(&RETCOD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&FMT200) TYPE(*CHAR) LEN(200)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')

             DCLF       FILE(ERPATHPD) RCDFMT(ERPATHD0)

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
             ENDDO                                                                        /*CSC059*/
             ENDDO                                                                        /*CSC059*/

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

             ENDDO            /***  ULX040 Treatment.  ***/

/***  Leave PGM  ***/
             CHGVAR     VAR(&ERROR) VALUE('N')

             GOTO       CMDLBL(ENDPGM)

 ERROR:      SNDPGMMSG  MSG('Download of ERFT30PP failed') +
                          TOMSGQ(MOPERQ MRUNQ)

 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited')
             MONMSG     MSGID(CPF0000)
             ENDPGM
