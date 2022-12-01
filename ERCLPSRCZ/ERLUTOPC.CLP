/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ER LU Download file to PCFILE to folder')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting Module                           */
/*                                                                   */
/*       ERLUTOPC - Download PCfile to Folder                        */
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
/*                      ULX008  *CREATE    Date 23Feb00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD027509 - Change folder calculation to use absolute path.  */
/*                  Applied for MD-38096                             */
/*       CSC059 - Replace QDLS processing by IFS                     */
/*       MD046248 - Finastra Rebranding                              */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       ULX008 - CSSF Statutory Reporting : Commissariat aux Bourses*/
/*                                                                   */
/*********************************************************************/

             PGM        PARM(&PREFIX &EDATE &TYPE)

             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&EDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DOCNAME) TYPE(*CHAR) LEN(12)
             DCL        VAR(&TEXT) TYPE(*CHAR) LEN(50) VALUE(' ')
             DCL        VAR(&CPT) TYPE(*DEC) LEN(1 0) VALUE(0)
             DCL        VAR(&CPTCHR) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&CPT2) TYPE(*DEC) LEN(2 0) VALUE(9)
             DCL        VAR(&CPT2CHR) TYPE(*CHAR) LEN(2) VALUE('09')
             DCL        VAR(&FILEIAS) TYPE(*CHAR) LEN(50)                                 /*CSC059*/
             DCL        VAR(&IASP_YN) TYPE(*CHAR) LEN(1)                                  /*CSC059*/
             DCL        VAR(&IASP) TYPE(*CHAR) LEN(10)                                    /*CSC059*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')                    /*CSC059*/
             DCL        VAR(&RTNC) TYPE(*CHAR) LEN(7) VALUE('       ')                    /*CSC059*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6) VALUE('CSC059')                      /*CSC059*/
             DCL        VAR(&SARREC) TYPE(*CHAR) LEN(200)                                 /*CSC059*/
             DCL        VAR(&CSC059) TYPE(*CHAR) LEN(1) VALUE('N' )                       /*CSC059*/
/*/COPY GPCPYSRCG,GPSVALDCL                                          */                   /*CSC059*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
             DCLF       FILE(ERLUDPPD) RCDFMT(ERLUDPD0)

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

/***  Recognized types is 'RT14'.  ***/

             IF         COND(&TYPE *NE 'RT14') THEN(GOTO +
                          CMDLBL(ENDPGM))

/***  Retrieve system prefix.  ***/

             RCVF       DEV(*FILE) RCDFMT(ERLUDPD0)

/* Do a Copy in xxDPLIB. ***/

             CHGVAR     VAR(&TOLIB) VALUE(&PREFIX *CAT 'DPLIB')

/***  If not Folder, don't copy file in Document  ***/

             IF         COND(&TYPE *EQ 'RT14' *AND &DWRT14 *EQ +
                          '                ') THEN(DO)

/***  But save in XXDPLIB.  ***/
             CHGVAR     VAR(&DOCNAME) +
                        VALUE('L' *CAT &EDATE *CAT  &CPTCHR *CAT '.TXT')
             GOTO       CMDLBL(TOOMUCH)
             ENDDO

/***  When OK, Create Doc. name  ***/

     IF COND(&TYPE *EQ 'RT14') THEN(DO)
             CHGVAR     VAR(&DOCNAME) +
                        VALUE('L' *CAT &EDATE *CAT  &CPTCHR *CAT '.TXT')

/***  If document not found, OK  ***/
/*LOOP:      CHKDLO     DLO(&DOCNAME) FLR(&DWRT14) OBJTYPE(*DOC)                          /*CSC059*/
 LOOP:       IF         COND(&CSC059 *EQ 'Y') THEN(DO)                                    /*CSC059*/
             OVRPRTF FILE(QSYSPRT) HOLD(*YES)                                             /*CSC059*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC059*/
/**********  CHGVAR     VAR(&FILEIAS) VALUE(&IASP *TCAT '/' *CAT &DWRT14 +
                          *TCAT '/' *CAT &DOCNAME)                           /*CSC059*/ /*MD027509*/
             CHGVAR     VAR(&FILEIAS) VALUE('/' *CAT &IASP *TCAT '/' *CAT &DWRT14 +
                          *TCAT '/' *CAT &DOCNAME)                                      /*MD027509*/
             ENDDO                                                                        /*CSC059*/
             ELSE       CMD(DO)                                                           /*CSC059*/
             CHGVAR     VAR(&FILEIAS) VALUE('/' *CAT &DWRT14 +
                          *TCAT '/' *CAT &DOCNAME)                                      /*MD027509*/
             ENDDO                                                                        /*CSC059*/
             DSPLNK     OBJ(&FILEIAS) OUTPUT(*PRINT)                                      /*CSC059*/
             MONMSG     MSGID(CPFA0A9) EXEC(DO)                                           /*CSC059*/
                                                                                          /*CSC059*/
/***  Create in folder ***/                                                               /*CSC059*/
                                                                                          /*CSC059*/
/**********  CHGVAR     VAR(&FILEIAS) VALUE(&IASP *TCAT '/' *CAT &DWRT14 +
                            *TCAT '/' *CAT &DOCNAME)                         /*CSC059*/ /*MD027509*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC059*/
             CHGVAR     VAR(&FILEIAS) VALUE('/' *CAT &IASP *TCAT '/' *CAT &DWRT14 +
                            *TCAT '/' *CAT &DOCNAME)                                    /*MD027509*/
             ENDDO                                                                        /*CSC059*/
             ELSE       CMD(DO)                                                           /*CSC059*/
             CHGVAR     VAR(&FILEIAS) VALUE('/' *CAT &DWRT14 +
                            *TCAT '/' *CAT &DOCNAME)                                    /*MD027509*/
             ENDDO                                                                        /*CSC059*/
             CPYTOIMPF  FROMFILE(QTEMP/ERFT14PP) TOSTMF(&FILEIAS) +
                          MBROPT(*REPLACE) STMFCODPAG(*PCASCII) +
                          RCDDLM(*CRLF) DTAFMT(*FIXED)                                    /*CSC059*/
                                                                                          /*CSC059*/
/***  Leave PGM  ***/                                                                     /*CSC059*/
                                                                                          /*CSC059*/
             GOTO       CMDLBL(ENDPGM)                                                    /*CSC059*/
             ENDDO                                                                        /*CSC059*/
                                                                                          /*CSC059*/
             ENDDO                                                                        /*CSC059*/
             ELSE       CMD(DO)                                                           /*CSC059*/
             CHKDLO     DLO(&DOCNAME) FLR(&DWRT14) OBJTYPE(*DOC)                          /*CSC059*/
             MONMSG     MSGID(CPF8A82) EXEC(DO)
             CHGVAR     VAR(&TEXT) VALUE('CCSF - for ' *CAT +
                          %SST(&DOCNAME 2 6) *CAT ' Version ' *CAT +
                          &CPTCHR)

/***  Create in folder ***/

             CPYTOPCD   FROMFILE(QTEMP/ERFT14PP) TOFLR(&DWRT14) +
                          TODOC(&DOCNAME) REPLACE(*YES) +
                          TRNTBL(*DFT) TRNFMT(*TEXT)

/***  Add a description  ***/

             CHGDOCD    DOC(&DOCNAME) FLR(&DWRT14) DOCD(&TEXT)
             MONMSG     MSGID(CPF0000 OFC0000)

/***  Leave PGM  ***/

             GOTO       CMDLBL(ENDPGM)
             ENDDO
             ENDDO                                                                        /*CSC059*/
                                                                                          /*CSC059*/
             IF         COND(&CSC059 *EQ 'Y') THEN(DO)                                    /*CSC059*/
             DLTSPLF FILE(QSYSPRT) SPLNBR(*LAST)                                          /*CSC059*/
             MONMSG  MSGID(CPF0000)                                                       /*CSC059*/
             ENDDO                                                                        /*CSC059*/

/***  if it exists, take next sequence: Max. 10 Doc- by day  ***/

             IF         COND(&CPT *LT 9) THEN(CHGVAR VAR(&CPT) +
                          VALUE(&CPT + 1))
             ELSE       CMD(GOTO CMDLBL(TOOMUCH))

/***  Create new docname.   ***/

             CHGVAR     VAR(&CPTCHR) VALUE(&CPT)
             CHGVAR     VAR(&DOCNAME) VALUE('L' *CAT &EDATE *CAT +
                          &CPTCHR *CAT '.TXT')
             GOTO LOOP
             ENDDO

 TOOMUCH:    CHGVAR     VAR(&FILE) VALUE(%SST(&DOCNAME 1 7))
             CHGVAR     VAR(&CPT2) VALUE(&CPT2 + 1)

/***  Maximum 90 by day  ***/

             IF         COND(&CPT2 *EQ 99) THEN(GOTO CMDLBL(ENDPGM))
             CHGVAR     VAR(&CPT2CHR) VALUE(&CPT2)
             CHGVAR     VAR(%SST(&FILE 8 2)) VALUE(&CPT2CHR)

/***  Check that file is not yet present  ***/

             CHKOBJ     OBJ(&TOLIB/&FILE) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)

             SNDPGMMSG  MSG('No folder or Maximum of 10 Documents +
                          for date is reached. Please create/clean +
                          folder and use ' *CAT &FILE *CAT ' to +
                          copy on PC file format') TOMSGQ(MOPERQ MRUNQ)

/***  Keep temporary ==> Manual copy is necessary.  ***/

             CPYF       FROMFILE(QTEMP/ERFT14PP) +
                          TOFILE(&TOLIB/&FILE ) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
             GOTO       CMDLBL(ENDPGM)
             ENDDO

             GOTO TOOMUCH

ERROR:       IF         COND(&TYPE *EQ 'RT14') THEN(SNDPGMMSG +
                          MSG('Download of ERFT14PP failed') +
                          TOMSGQ(MOPERQ MRUNQ))

 ENDPGM:     CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited 2005')
             MONMSG     MSGID(CPF0000)
             IF         COND(&CSC059 *EQ 'Y') THEN(DO)                                    /*CSC059*/
             DLTOVR     FILE(QSYSPRT)                                                     /*CSC059*/
             MONMSG     MSGID(CPF0000)                                                    /*CSC059*/
             ENDDO                                                                        /*CSC059*/
                                                                                          /*CSC059*/
             ENDPGM
