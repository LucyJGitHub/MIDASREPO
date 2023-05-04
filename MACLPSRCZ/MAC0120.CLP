/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas MA Copy data to shared folder')                 */
/*********************************************************************/
/*                                                                   */
/*  Midas - Optical Disk Archiving Module                    */
/*                                                                   */
/*  MAC0120 - Transfer data for download to optical disk to folder.  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. BA6016             Date 10Feb23              */
/*       Prev Amend No. MD038851           Date 10Oct22              */
/*                      MD025638           Date 10Oct22              */
/*                      CSC059             Date 10Oct22              */
/*                      MD058733           Date 16Feb22              */
/*                      MD046248           Date 27Oct17              */
/*                      251701             Date 08Apr13              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01382             Date 30Apr92              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       BA6016 - Upgrade CMD IFSAUT to BFMidas (GSH016)             */
/*  MD038851 - Printerfiles not sent to download folder              */
/*           - To correct the folder/path of the directory by adding */
/*             '/' in OPTIC                                          */
/*  MD025638 - CRTDIR fails with CPFA09 error. Add '/' in front      */
/*             of &IASP when in IASP env. and &IASP is not           */
/*             preceded with '/'.                                    */
/*           - Applied for MD-38096.                                 */
/*  CSC059 - Replace QDLS processing by IFS                          */
/*       MD058733 - In download to STORQM, DOWNLOAD directory is not */
/*                  recreated in IFS and DAT file authorities are    */
/*                  wrong.                                           */
/*       MD046248 - Finastra Rebranding                              */
/*  251701 - Emergency workaround to stop ORF download failure       */
/*           at monthend - don't use QDLS                            */
/*         - Applied for AR1097431                                   */
/*  S01382 - CREATED FOR OPTICAL DISK DEVELOPMENT.                   */
/*                                                                   */
/*********************************************************************/
/*/COPY WNCPYSRC,MAC0120004                                          */
             PGM        PARM(&INPFILE &TEXT)
/*/COPY WNCPYSRC,MAC0120005                                          */

             DCL        VAR(&INPFILE) TYPE(*CHAR) LEN(8)
/*/COPY WNCPYSRC,MAC0120006                                          */
             DCL        VAR(&TEXT) TYPE(*CHAR) LEN(30)
             DCL        VAR(&PCFILE) TYPE(*CHAR) LEN(12)
             DCL        VAR(&SYSTEM) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SUBFLR) TYPE(*CHAR) LEN(11)
             DCL        VAR(&FOLDER) TYPE(*CHAR) LEN(17)
             DCL        VAR(&FLRIAS) TYPE(*CHAR) LEN(50)                                  /*CSC059*/
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(80)                                    /*CSC059*/
             DCL        VAR(&IASP_YN) TYPE(*CHAR) LEN(1)                                  /*CSC059*/
             DCL        VAR(&IASP) TYPE(*CHAR) LEN(10)                                    /*CSC059*/
             DCL        VAR(&IASP_PR) TYPE(*CHAR) LEN(1)                                /*MD025638*/
             DCL        VAR(&ZSUBDIR) TYPE(*CHAR) LEN(200)                                /*CSC059*/
             DCL        VAR(&RETCOD) TYPE(*CHAR) LEN(7)                                   /*BA6016*/
             DCL        VAR(&FMT200) TYPE(*CHAR) LEN(200)                                 /*BA6016*/
             DCL        VAR(&BA6016) TYPE(*CHAR) LEN(1) VALUE('N')                        /*BA6016*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')                    /*CSC059*/
             DCL        VAR(&RTNC) TYPE(*CHAR) LEN(7) VALUE('       ')                    /*CSC059*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6) VALUE('CSC059')                      /*CSC059*/
             DCL        VAR(&SARREC) TYPE(*CHAR) LEN(200)                                 /*CSC059*/
             DCL        VAR(&CSC059) TYPE(*CHAR) LEN(1) VALUE('N' )                       /*CSC059*/
/*/COPY GPCPYSRCG,GPSVALDCL                                          */                   /*CSC059*/
/*/COPY WNCPYSRC,MAC0120001                                          */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)                                   /*251701*/
             DCL        VAR(&TOPATH) TYPE(*CHAR) LEN(50)                                  /*251701*/
             DCL        VAR(&FROMPATH) TYPE(*CHAR) LEN(50)                                /*251701*/
             DCL        VAR(&IFSFIX) TYPE(*CHAR) LEN(1)                                   /*251701*/
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)                                   /*251701*/
             DCL        VAR(&SVALK1) TYPE(*CHAR) LEN(20)                                  /*251701*/
             DCL        VAR(&SVAL1) TYPE(*CHAR) LEN(200)                                  /*251701*/
             DCL        VAR(&SVALK2) TYPE(*CHAR) LEN(20)                                  /*251701*/
             DCL        VAR(&SVAL2) TYPE(*CHAR) LEN(200)                                  /*251701*/
             DCL        VAR(&SVALK3) TYPE(*CHAR) LEN(20)                                  /*251701*/
             DCL        VAR(&SVAL3) TYPE(*CHAR) LEN(200)                                  /*251701*/
             DCL        VAR(&SVALK4) TYPE(*CHAR) LEN(20)                                  /*251701*/
             DCL        VAR(&SVAL4) TYPE(*CHAR) LEN(200)                                  /*251701*/
             DCL        VAR(&SVALK5) TYPE(*CHAR) LEN(20)                                  /*251701*/
             DCL        VAR(&SVAL5) TYPE(*CHAR) LEN(200)                                  /*251701*/
             DCL        VAR(&SVALK6) TYPE(*CHAR) LEN(20)                                  /*251701*/
             DCL        VAR(&SVAL6) TYPE(*CHAR) LEN(200)                                  /*251701*/
             DCL        VAR(&SVALK7) TYPE(*CHAR) LEN(20)                                  /*251701*/
             DCL        VAR(&SVAL7) TYPE(*CHAR) LEN(200)                                  /*251701*/
             DCL        VAR(&SVALK8) TYPE(*CHAR) LEN(20)                                  /*251701*/
             DCL        VAR(&SVAL8) TYPE(*CHAR) LEN(200)                                  /*251701*/
             DCL        VAR(&SVALK9) TYPE(*CHAR) LEN(20)                                  /*251701*/
             DCL        VAR(&SVAL9) TYPE(*CHAR) LEN(200)                                  /*251701*/
             DCL        VAR(&SVALK0) TYPE(*CHAR) LEN(20)                                  /*251701*/
             DCL        VAR(&SVAL10) TYPE(*CHAR) LEN(200)                                 /*251701*/

             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

             CHGJOB     SWS(XXXXXX00)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/*/COPY WNCPYSRC,MAC0120002                                          */
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
             CHGVAR     VAR(&IASP_PR) VALUE(%SST(&IASP 1 1))                            /*MD025638*/
             CALL       PGM(AOSARDR0) PARM(&RETCOD '*VERIFY' +
                          'BA6016' &FMT200)                                               /*BA6016*/
             IF         COND(&RETCOD *EQ '       ') THEN(DO)                              /*BA6016*/
             CHGVAR     VAR(&BA6016) VALUE('Y')                                           /*BA6016*/
             ENDDO                                                                        /*BA6016*/
             ENDDO                                                                        /*CSC059*/
/*                                                                                        /*CSC059*/
/** Get the zone IFS subdirectory system value */                                         /*CSC059*/
/*                                                                                        /*CSC059*/
             CALL       PGM(AOSVALR0) PARM(&RSVALRTNC +
                          'ZoneIFSsubdirectory' &SVAL1 &SVALK2 +
                          &SVAL2 &SVALK3 &SVAL3 &SVALK4 &SVAL4 +
                          &SVALK5 &SVAL5 &SVALK6 &SVAL6 &SVALK7 +
                          &SVAL7 &SVALK8 &SVAL8 &SVALK9 &SVAL9 +
                          &SVALK10 &SVAL10)                                               /*CSC059*/
/*                                                                                        /*CSC059*/
/** Determine IFS subdirectory. */                                                        /*CSC059*/
/*                                                                                        /*CSC059*/
             CHGVAR     VAR(&ZSUBDIR) VALUE(%SST(&SVAL1 1 200))                           /*CSC059*/
             ENDDO                                                                        /*CSC059*/

/* Create folders if not already there */

/* If feature CSC059 is switched on */                                                    /*CSC059*/
             IF         COND(&CSC059 *EQ 'Y') THEN(DO)                                    /*CSC059*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC059*/
             CHGVAR     VAR(&FLRIAS) VALUE(&IASP *TCAT '/' *CAT +
                          &ZSUBDIR *TCAT '/OPTIC')                                        /*CSC059*/
             IF         COND(&IASP_PR *NE '/') THEN(CHGVAR +
                          VAR(&FLRIAS) VALUE('/' *TCAT &IASP *TCAT +
                          '/' *CAT &ZSUBDIR *TCAT '/OPTIC'))                            /*MD025638*/
             ENDDO                                                                        /*CSC059*/
             ELSE       CMD(DO)                                                           /*CSC059*/
             CHGVAR     VAR(&FLRIAS) VALUE('/' *TCAT +
                          &ZSUBDIR *TCAT '/OPTIC')                                        /*CSC059*/
             ENDDO                                                                        /*CSC059*/
             CRTDIR     DIR(&FLRIAS)                                                      /*CSC059*/
             MONMSG     MSGID(CPFA0A0)                                                    /*CSC059*/
             IF         COND((&IASP_YN *EQ 'Y') *AND (&BA6016 *EQ +
                        'Y')) THEN(DO)                                                    /*BA6016*/
             IFSAUT     PATH(&FLRIAS)                                                     /*BA6016*/
             MONMSG     MSGID(CPF0000)                                                    /*BA6016*/
             ENDDO                                                                        /*BA6016*/
             ENDDO                                                                        /*CSC059*/
                                                                                          /*CSC059*/
                                                                                          /*CSC059*/
/* Get Midas system prefix from DTAARA/SDSTAT */                                          /*CSC059*/
                                                                                          /*CSC059*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSTEM)                              /*CSC059*/
                                                                                          /*CSC059*/
/* Build sub-folder name */                                                               /*CSC059*/
                                                                                          /*CSC059*/
             CHGVAR     VAR(&SUBFLR) VALUE('DOWNLOAD.' *CAT +
                          &SYSTEM)                                                        /*CSC059*/
                                                                                          /*CSC059*/
             IF         COND(&CSC059 *EQ 'Y') THEN(DO)                                    /*CSC059*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC059*/
             CHGVAR     VAR(&FLRIAS) VALUE(&IASP *TCAT '/' *CAT +
                          &ZSUBDIR *TCAT '/OPTIC/' *CAT &SUBFLR)                          /*CSC059*/
/**********  IF         COND(&IASP_PR *NE '/') THEN(CHGVAR +
                          VAR(&FLRIAS) VALUE('/' *TCAT &IASP *TCAT +
                          '/' *CAT &ZSUBDIR *TCAT '/OPTIC' *CAT &SUBFLR))  /*MD025638*/ /*MD038851*/
             IF         COND(&IASP_PR *NE '/') THEN(CHGVAR +
                          VAR(&FLRIAS) VALUE('/' *TCAT &IASP *TCAT +
                          '/' *CAT &ZSUBDIR *TCAT '/OPTIC/' *CAT &SUBFLR))              /*MD038851*/
             ENDDO                                                                        /*CSC059*/
             ELSE       CMD(DO)                                                           /*CSC059*/
             CHGVAR     VAR(&FLRIAS) VALUE('/' *TCAT +
                          &ZSUBDIR *TCAT '/OPTIC/' *CAT &SUBFLR)                          /*CSC059*/
             ENDDO                                                                        /*CSC059*/
             CRTDIR     DIR(&FLRIAS)                                                      /*CSC059*/
             MONMSG     MSGID(CPFA0A0)                                                    /*CSC059*/
             IF         COND((&IASP_YN *EQ 'Y') *AND (&BA6016 *EQ +
                        'Y')) THEN(DO)                                                    /*BA6016*/
             IFSAUT     PATH(&FLRIAS)                                                     /*BA6016*/
             MONMSG     MSGID(CPF0000)                                                    /*BA6016*/
             ENDDO                                                                        /*BA6016*/
             ENDDO                                                                        /*CSC059*/
                                                                                          /*CSC059*/
/* Build folder name */                                                                   /*CSC059*/
                                                                                          /*CSC059*/
             CHGVAR     VAR(&FOLDER) VALUE('OPTIC/DOWNLOAD.' *CAT +
                          &SYSTEM)                                                        /*CSC059*/
                                                                                          /*CSC059*/
                                                                                          /*CSC059*/
/* Copy optical disk file(MAOPTDPD) to the folder */                                      /*CSC059*/
             CHGVAR     VAR(&PCFILE) VALUE(&INPFILE *TCAT '.DAT')                         /*CSC059*/
                                                                                          /*CSC059*/
             IF         COND(&CSC059 *EQ 'Y') THEN(DO)                                    /*CSC059*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC059*/
             CHGVAR     VAR(&FILE) VALUE(&IASP *TCAT '/' *CAT +
                          &ZSUBDIR *TCAT '/' *CAT &FOLDER *TCAT '/' +
                          *CAT &PCFILE)                                                   /*CSC059*/
             IF         COND(&IASP_PR *NE '/') THEN(CHGVAR +
                          VAR(&FILE) VALUE('/' *TCAT &IASP *TCAT '/' +
                          *CAT &ZSUBDIR *TCAT '/' *CAT &FOLDER *TCAT +
                          '/' *CAT &PCFILE))                                            /*MD025638*/
             ENDDO                                                                        /*CSC059*/
             ELSE       CMD(DO)                                                           /*CSC059*/
             CHGVAR     VAR(&FILE) VALUE('/' *TCAT +
                          &ZSUBDIR *TCAT '/' *CAT &FOLDER *TCAT '/' +
                          *CAT &PCFILE)                                                   /*CSC059*/
             ENDDO                                                                        /*CSC059*/
                                                                                          /*CSC059*/
             CPYTOIMPF  FROMFILE(*LIBL/MAOPTDPD &INPFILE) +
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
                                                                                          /*CSC059*/
/* If CSC059 is not switched on */                                                        /*CSC059*/
             ELSE       CMD(DO)                                                           /*CSC059*/
             CALL       PGM(AOSVALR0) PARM(&RTNCDE 'StopORFFailure' +
                          &SVAL1 &SVALK2 &SVAL2 &SVALK3 &SVAL3 +
                          &SVALK4 &SVAL4 &SVALK5 &SVAL5 &SVALK6 +
                          &SVAL6 &SVALK7 &SVAL7 &SVALK8 &SVAL8 +
                          &SVALK9 &SVAL9 &SVALK0 &SVAL10)                                 /*251701*/
                                                                                          /*251701*/
             IF         COND(&RTNCDE *EQ '       ') THEN(DO)                              /*251701*/
             CHGVAR     VAR(&IFSFIX) VALUE(%SST(&SVAL1 1 1))                              /*251701*/
             ENDDO                                                                        /*251701*/
                                                                                          /*251701*/
             IF         COND(%SST(&SVAL1 1 4) *EQ '*NRF') THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*251701*/
                                                                                          /*251701*/
             IF         COND(&IFSFIX *NE 'Y') THEN(DO)                                    /*251701*/
             CRTFLR     FLR(OPTIC) TEXT('Midas Optical disk +
                          download folder') AUT(*ALL)
             MONMSG     MSGID(CPF8A85 CPF8A18)

/* Get Midas system prefix from DTAARA/SDSTAT */

             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSTEM)

/* Build sub-folder name */

             CHGVAR     VAR(&SUBFLR) VALUE('DOWNLOAD.' *CAT +
                          &SYSTEM)

             CRTFLR     FLR(&SUBFLR) INFLR(OPTIC) +
                          TEXT('Midas data for PC folder') +
                          AUT(*ALL)
             MONMSG     MSGID(CPF8A85 CPF8A18)

/* Build folder name */

             CHGVAR     VAR(&FOLDER) VALUE('OPTIC/DOWNLOAD.' *CAT +
                          &SYSTEM)
/*/COPY WNCPYSRC,MAC0120003                                          */

/* Copy optical disk file(MAOPTDPD) to the folder */

             CHGVAR     VAR(&PCFILE) VALUE(&INPFILE *TCAT '.DAT')

             CPYTOPCD   FROMFILE(MAOPTDPD) TOFLR(&FOLDER) +
                          FROMMBR(&INPFILE) TODOC(&PCFILE) +
                          REPLACE(*YES) TRNFMT(*TEXT)

             CHGDOCD    DOC(&PCFILE) FLR(&FOLDER) +
                          DOCD(&TEXT)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000)
             ENDDO                                                                        /*251701*/
/*/COPY WNCPYSRC,MAC0120007                                          */
             IF         COND(&IFSFIX *EQ 'Y') THEN(DO)                                    /*251701*/
             CRTDIR     DIR('OPTIC')                                                      /*251701*/
             MONMSG     MSGID(CPFA0A0)                                                    /*251701*/
                                                                                          /*251701*/
/* Get Midas system prefix from DTAARA/SDSTAT */                                          /*251701*/
                                                                                          /*251701*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSTEM)                              /*251701*/
                                                                                          /*251701*/
/* Build sub-folder name */                                                               /*251701*/
                                                                                          /*251701*/
             CHGVAR     VAR(&FOLDER) VALUE('OPTIC/DOWNLOAD.' *CAT +
                          &SYSTEM)                                                        /*251701*/
                                                                                          /*251701*/
             CRTDIR     DIR(&FOLDER)                                                      /*251701*/
             MONMSG     MSGID(CPFA0A0)                                                    /*251701*/
                                                                                          /*251701*/
/* Copy optical disk file(MAOPTDPD) to the folder */                                      /*251701*/
                                                                                          /*251701*/
             CHGVAR     VAR(&DPLIB) VALUE(&SYSTEM *TCAT 'DPLIB')                          /*251701*/
             CHGVAR     VAR(&FROMPATH) VALUE('/QSYS.LIB/' *TCAT +
                          &DPLIB *TCAT '.LIB/MAOPTSTMF.FILE/' *TCAT +
                          &INPFILE *TCAT '.MBR')                                          /*251701*/
             CHGVAR     VAR(&TOPATH) VALUE(&FOLDER *TCAT '/' *TCAT +
                          &INPFILE *TCAT '.DAT')                                          /*251701*/
             CRTPF      FILE(&DPLIB/MAOPTSTMF) RCDLEN(220) +
                          MAXMBRS(*NOMAX) SIZE(*NOMAX)                                    /*251701*/
             MONMSG     MSGID(CPF5813 CPF7302)                                            /*251701*/
             CPYF       FROMFILE(MAOPTDPD) TOFILE(&DPLIB/MAOPTSTMF) +
                          FROMMBR(&INPFILE) TOMBR(&INPFILE) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NOCHK)                   /*251701*/
/**********  CPYTOSTMF  FROMMBR(&FROMPATH) TOSTMF(&TOPATH) +      *********/            /*MD058733*/
/**********               STMFOPT(*REPLACE) STMFCODPAG(*PCASCII)  *********/ /*251701*/ /*MD058733*/
             CPYTOSTMF  FROMMBR(&FROMPATH) TOSTMF(&TOPATH) STMFOPT(*REPLACE) +
                          AUT(*INDIR) STMFCODPAG(*PCASCII)                              /*MD058733*/
                                                                                          /*251701*/
             ENDDO                                                                        /*251701*/
             ENDDO                                                                        /*CSC059*/

             GOTO       CMDLBL(END)

 ABNOR:      CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000)
             SNDMSG     MSG('MAC0120 - Copy output queue data to +
                          shared folder ended abnormally') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000)

 END:        ENDPGM
