/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IBLC 2002 Download file to PCFILE to folder')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - IBLC 2002 Module                                    */
/*                                                                   */
/*       ILDWTOPC - Create PC document wioth IBLC 2002 items         */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. BA6016             Date 10Feb23              */
/*       Prev Amend No. MD027509           Date 10Oct22              */
/*                      CSC059             Date 10Oct22              */
/*                      MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CER001             Date 25Apr05              */
/*                      200880             Date 05Dec01              */
/*                      ULX043             Date 11Oct01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BA6016 - Upgrade CMD IFSAUT to BFMidas (GSH016)             */
/*       MD027509 - Change folder calculation to use absolute path.  */
/*                  Applied for MD-38096                             */
/*       CSC059 - Replace QDLS processing by IFS                     */
/*       MD046248 - Finastra Rebranding                              */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       200880 - ULX043 - Narrative too long                        */
/*       ULX043 - IBLC 2002 Reporting                                */
/*                                                                   */
/*********************************************************************/

             PGM        PARM(&RETCOD &BCLN &FLR )

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')

/***  Declare variables.  ***/

             DCL        VAR(&RETCOD) TYPE(*CHAR) LEN(1)  VALUE(' ')
             DCL        VAR(&BCLN)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&FLR)    TYPE(*CHAR) LEN(63)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DOCNAME) TYPE(*CHAR) LEN(12)
             DCL        VAR(&MBRNAME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&FMT200) TYPE(*CHAR) LEN(200)                                 /*BA6016*/
             DCL        VAR(&BA6016) TYPE(*CHAR) LEN(1) VALUE('N')                        /*BA6016*/
             DCL        VAR(&TEXT) TYPE(*CHAR) LEN(50) VALUE(' ')
/*****       DCL        VAR(&TEXT) TYPE(*CHAR) LEN(50) VALUE(' ')                         /*CSC059*/
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(150)                                   /*CSC059*/
             DCL        VAR(&IASP_YN) TYPE(*CHAR) LEN(1)                                  /*CSC059*/
             DCL        VAR(&IASP) TYPE(*CHAR) LEN(10)                                    /*CSC059*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')                    /*CSC059*/
             DCL        VAR(&RTNC) TYPE(*CHAR) LEN(7) VALUE('       ')                    /*CSC059*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6) VALUE('CSC059')                      /*CSC059*/
             DCL        VAR(&SARREC) TYPE(*CHAR) LEN(200)                                 /*CSC059*/
             DCL        VAR(&CSC059) TYPE(*CHAR) LEN(1) VALUE('N' )                       /*CSC059*/
/*/COPY GPCPYSRCG,GPSVALDCL                                          */                   /*CSC059*/

             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR))
/*                                                                                        /*CSC059*/
/* Check if feature CSC059 is on */                                                       /*CSC059*/
             CALL       PGM(AOSARDR0) PARM(&RTNC &OPTN &SAR &SARREC)                      /*CSC059*/
             IF         COND(&RTNC *EQ '       ') THEN(CHGVAR +
                          VAR(&CSC059) VALUE('Y'))                                        /*CSC059*/
                                                                                          /*CSC059*/
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

/***  Create doc name : ABCLMMDD.TXT, BCL is BCL bank reference,  ***/
/***                                  MM  is month of reporting,  ***/
/***                                  DD  is Day of Reporting.    ***/

             RTVDTAARA  DTAARA(ILSTAT (2 6)) RTNVAR(&DATE)
             CHGVAR     VAR(&DOCNAME) VALUE('A' *CAT &BCLN *CAT +
                          %SST(&DATE 3 4) *CAT '.TXT')

/***  Create document in folder using active Bank details   ***/

             CHGVAR     VAR(&MBRNAME) VALUE('BCL' *CAT &BCLN)
             IF         COND(&CSC059 *EQ 'Y') THEN(DO)                                    /*CSC059*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC059*/
/**********  CHGVAR     VAR(&FILE) VALUE(&IASP *TCAT '/' *CAT &FLR +
                            *TCAT '/' *CAT &DOCNAME)                         /*CSC059*/ /*MD027509*/
             CHGVAR     VAR(&FILE) VALUE('/' *CAT &IASP *TCAT '/' *CAT &FLR +
                            *TCAT '/' *CAT &DOCNAME)                                    /*MD027509*/
             ENDDO                                                                        /*CSC059*/
             ELSE       CMD(DO)                                                           /*CSC059*/
             CHGVAR     VAR(&FILE) VALUE('/' *CAT &FLR +
                            *TCAT '/' *CAT &DOCNAME)                                    /*MD027509*/
             ENDDO                                                                        /*CSC059*/
             CPYTOIMPF  FROMFILE(*LIBL/ILDATAPD &MBRNAME) +
                          TOSTMF(&FILE) MBROPT(*REPLACE) +
                          STMFCODPAG(*PCASCII) RCDDLM(*CRLF) +
                          DTAFMT(*FIXED)                                                  /*CSC059*/
/** Invoke Handelsbanken command IFSAUT to correctly set user        */                   /*BA6016*/
/** authority to the IFS directory                                   */                   /*BA6016*/
                                                                                          /*BA6016*/
             IF         COND((&IASP_YN *EQ 'Y') *AND (&BA6016 *EQ +
                        'Y')) THEN(DO)                                                    /*BA6016*/
             IFSAUT     PATH(&FILE)                                                       /*BA6016*/
             MONMSG     MSGID(CPF0000)                                                    /*BA6016*/
             ENDDO                                                                        /*BA6016*/
             ENDDO                                                                        /*CSC059*/
             ELSE       CMD(DO)                                                           /*CSC059*/
             CPYTOPCD   FROMFILE(ILDATAPD) TOFLR(&FLR) +
                          FROMMBR(&MBRNAME) TODOC(&DOCNAME) +
                          REPLACE(*YES) TRNTBL(*DFT) TRNFMT(*TEXT)

/****    CHGVAR     VAR(&TEXT) VALUE('IBLC 2002 - BCL ref : ' +         200880*/
/****                     *CAT &BCLN *CAT ' at date : ' +               200880*/
/****                     *CAT %SST(&DATE 5 2) *CAT  '/'  +             200880*/
/****                     *CAT %SST(&DATE 3 2) *CAT '/20'  +            200880*/
/****                     *CAT %SST(&DATE 1 2) *CAT '.')                200880*/
             CHGVAR     VAR(&TEXT) VALUE('BCL ref : ' +
                          *CAT &BCLN *CAT ' at date : ' +
                          *CAT %SST(&DATE 5 2) *CAT  '/'  +
                          *CAT %SST(&DATE 3 2) *CAT '/20'  +
                          *CAT %SST(&DATE 1 2) *CAT '.')              /*200880*/
             CHGDOCD    DOC(&DOCNAME) FLR(&FLR) DOCD(&TEXT)
             MONMSG     MSGID(CPF0000 OFC0000)
             ENDDO                                                                        /*CSC059*/

/***  Leave PGM  ***/

             GOTO       CMDLBL(ENDPGM)

 ERROR:      SNDPGMMSG  MSG('Download of ILDATAPD failed during +
                          treatment of ' *CAT &BCLN *CAT ' - see +
                          dump in joblog for details') TOMSGQ(MOPERQ MRUNQ)
             CHGVAR     VAR(&RETCOD) VALUE('1')
             DMPCLPGM

 ENDPGM:     CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited 2005')
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(ILDATAPD)
             MONMSG     MSGID(CPF0000)
             ENDPGM
