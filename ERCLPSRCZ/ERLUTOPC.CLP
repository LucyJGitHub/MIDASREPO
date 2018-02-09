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
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 25Apr05              */
/*                      ULX008  *CREATE    Date 23Feb00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
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
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
             DCLF       FILE(ERLUDPPD) RCDFMT(ERLUDPD0)
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR))
 
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
 LOOP:       CHKDLO     DLO(&DOCNAME) FLR(&DWRT14) OBJTYPE(*DOC)
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
             ENDPGM
