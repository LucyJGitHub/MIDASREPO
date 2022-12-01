/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas MA Inform PC that download may begin')          */
/*********************************************************************/
/*                                                                   */
/*  Midas - Optical Disk Archiving Module                    */
/*                                                                   */
/*  MAC0130 - Inform the PC that download may commence.              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD025638           Date 10Oct22              */
/*       Prev Amend No. CSC059             Date 10Oct22              */
/*                      MD058733           Date 16Feb22              */
/*                      MD046248           Date 27Oct17              */
/*                      251701             Date 08Apr13              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01382             Date 30Apr92              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
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
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM

             DCL        VAR(&SYSTEM) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SUBFLR) TYPE(*CHAR) LEN(11)
             DCL        VAR(&FOLDER) TYPE(*CHAR) LEN(17)
             DCL        VAR(&FLRIAS) TYPE(*CHAR) LEN(50)                                  /*CSC059*/
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(50)                                    /*CSC059*/
             DCL        VAR(&IASP_YN) TYPE(*CHAR) LEN(1)                                  /*CSC059*/
             DCL        VAR(&IASP) TYPE(*CHAR) LEN(10)                                    /*CSC059*/
             DCL        VAR(&IASP_PR) TYPE(*CHAR) LEN(1)                                /*MD025638*/
             DCL        VAR(&ZSUBDIR) TYPE(*CHAR) LEN(200)                                /*CSC059*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')                    /*CSC059*/
             DCL        VAR(&RTNC) TYPE(*CHAR) LEN(7) VALUE('       ')                    /*CSC059*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6) VALUE('CSC059')                      /*CSC059*/
             DCL        VAR(&SARREC) TYPE(*CHAR) LEN(200)                                 /*CSC059*/
             DCL        VAR(&CSC059) TYPE(*CHAR) LEN(1) VALUE('N' )                       /*CSC059*/
/*/COPY GPCPYSRCG,GPSVALDCL                                          */                   /*CSC059*/
/*/COPY WNCPYSRC,MAC0130001                                          */
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
/*/COPY WNCPYSRC,MAC0130002                                          */
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
             CHGVAR     VAR(&IASP_PR) VALUE(%SST(&IASP 1 1))                            /*MD025638*/
/*                                                                                          CSC059*/
/*  If IASP environment,                                                                    CSC059*/
/*                                                                                          CSC059*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC059*/
/*                                                                                          CSC059*/
/*  Get name of IASP.                                                                       CSC059*/
/*                                                                                          CSC059*/
             CHGVAR     VAR(&IASP) VALUE(%SST(&SVAL2 1 10))                               /*CSC059*/
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
             CHGVAR     VAR(&ZSUBDIR) VALUE(%SST(&SVAL1 1 200))                           /*CSC059*/
/*                                                                                        /*CSC059*/
             ENDDO                                                                        /*CSC059*/

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
                                                                                          /*CSC059*/
/* If feature CSC059 is switched on */                                                    /*CSC059*/
             IF         COND(&CSC059 *EQ 'Y') THEN(DO)                                    /*CSC059*/
                                                                                          /*CSC059*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC059*/
             CHGVAR     VAR(&FLRIAS) VALUE(&IASP *TCAT '/' *CAT &ZSUBDIR *TCAT '/OPTIC')  /*CSC059*/
             IF         COND((&IASP_YN *EQ 'Y') *AND (&IASP_PR *NE +
                          '/')) THEN(CHGVAR VAR(&FLRIAS) VALUE('/' +
                          *TCAT &IASP *TCAT '/' *CAT &ZSUBDIR *TCAT '/OPTIC'))          /*MD025638*/
             ENDDO                                                                        /*CSC059*/
             ELSE       CMD(DO)                                                           /*CSC059*/
             CHGVAR     VAR(&FLRIAS) VALUE('/' *CAT &ZSUBDIR *TCAT '/OPTIC')              /*CSC059*/
             ENDDO                                                                        /*CSC059*/
             CRTDIR     DIR(&FLRIAS)                                                      /*CSC059*/
             MONMSG     MSGID(CPFA0A0)                                                    /*CSC059*/
/* Get Midas system prefix from DTAARA/SDSTAT */                                          /*CSC059*/
                                                                                          /*CSC059*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSTEM)                              /*CSC059*/
                                                                                          /*CSC059*/
/* Build sub-folder name */                                                               /*CSC059*/
                                                                                          /*CSC059*/
             CHGVAR     VAR(&SUBFLR) VALUE('DOWNLOAD.' *CAT +
                          &SYSTEM)                                                        /*CSC059*/
                                                                                          /*CSC059*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC059*/
             CHGVAR     VAR(&FLRIAS) VALUE(&IASP *TCAT '/' *CAT &ZSUBDIR *TCAT +
                                           '/OPTIC/' *CAT &SUBFLR)                        /*CSC059*/
             IF         COND((&IASP_YN *EQ 'Y') *AND (&IASP_PR *NE +
                          '/')) THEN(CHGVAR VAR(&FLRIAS) VALUE('/' +
                          *TCAT &IASP *TCAT '/' *CAT &ZSUBDIR *TCAT +
                          '/OPTIC/' *CAT &SUBFLR))                                      /*MD025638*/
             ENDDO                                                                        /*CSC059*/
             ELSE       CMD(DO)                                                           /*CSC059*/
             CHGVAR     VAR(&FLRIAS) VALUE('/' *CAT &ZSUBDIR *TCAT +
                                           '/OPTIC/' *CAT &SUBFLR)                        /*CSC059*/
             ENDDO                                                                        /*CSC059*/
             CRTDIR     DIR(&FLRIAS)                                                      /*CSC059*/
             MONMSG     MSGID(CPFA0A0)                                                    /*CSC059*/
                                                                                          /*CSC059*/
/* Build folder/subfolder string */                                                       /*CSC059*/
                                                                                          /*CSC059*/
             CHGVAR     VAR(&FOLDER) VALUE('OPTIC/DOWNLOAD.' *CAT +
                          &SYSTEM)                                                        /*CSC059*/
                                                                                          /*CSC059*/
/* Set flag to allow extraction by PC */                                                  /*CSC059*/
                                                                                          /*CSC059*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC059*/
             CHGVAR     VAR(&FILE) VALUE(&IASP *TCAT '/' *CAT &ZSUBDIR +
                          *TCAT '/' *CAT &FOLDER *TCAT '/READY.GO')                       /*CSC059*/
             IF         COND((&IASP_YN *EQ 'Y') *AND (&IASP_PR *NE +
                          '/')) THEN(CHGVAR VAR(&FILE) VALUE('/' +
                          *TCAT &IASP *TCAT '/' *CAT &ZSUBDIR +
                          *TCAT '/' *CAT &FOLDER *TCAT '/READY.GO'))                    /*MD025638*/
             ENDDO                                                                        /*CSC059*/
             ELSE       CMD(DO)                                                           /*CSC059*/
             CHGVAR     VAR(&FILE) VALUE('/' *CAT &ZSUBDIR +
                          *TCAT '/' *CAT &FOLDER *TCAT '/READY.GO')                       /*CSC059*/
             ENDDO                                                                        /*CSC059*/
             CPYTOIMPF  FROMFILE(*LIBL/MAORDYPD) TOSTMF(&FILE) +
                          MBROPT(*REPLACE) STMFCODPAG(*PCASCII) +
                          RCDDLM(*CRLF) DTAFMT(*FIXED)                                    /*CSC059*/
             ENDDO                                                                        /*CSC059*/
             ELSE       CMD(DO)                                                           /*CSC059*/

/* If feature CSC059 is switched off */                                                   /*CSC059*/
             IF         COND(&IFSFIX *NE 'Y') THEN(DO)                                    /*251701*/
/* Create folders if not already there */

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

/* Build folder/subfolder string */

             CHGVAR     VAR(&FOLDER) VALUE('OPTIC/DOWNLOAD.' *CAT +
                          &SYSTEM)
/*/COPY WNCPYSRC,MAC0130003                                          */

/* Set flag to allow extraction by PC */

             CPYTOPCD   FROMFILE(MAORDYPD) TOFLR(&FOLDER) +
                          TODOC(READY.GO) REPLACE(*YES) TRNFMT(*TEXT)

             CHGDOCD    DOC(READY.GO) FLR(&FOLDER) +
                          DOCD('Data ready for download to PC flag')
             ENDDO                                                                        /*251701*/

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
                          &DPLIB *TCAT '.LIB/MAORDSTMF.FILE/MAORDSTMF.MBR')               /*251701*/
             CHGVAR     VAR(&TOPATH) VALUE(&FOLDER *TCAT '/READY.GO')                     /*251701*/
             CRTPF      FILE(&DPLIB/MAORDSTMF) RCDLEN(1) +
                          MAXMBRS(*NOMAX) SIZE(*NOMAX)                                    /*251701*/
             MONMSG     MSGID(CPF5813 CPF7302)                                            /*251701*/
/**********  CPYTOSTMF  FROMMBR(&FROMPATH) TOSTMF(&TOPATH) +      *********/            /*MD058733*/
/**********               STMFOPT(*REPLACE) STMFCODPAG(*PCASCII)  *********/ /*251701*/ /*MD058733*/
             CPYTOSTMF  FROMMBR(&FROMPATH) TOSTMF(&TOPATH) +
                          STMFOPT(*REPLACE) AUT(*INDIR) STMFCODPAG(*PCASCII)            /*MD058733*/
             ENDDO                                                                        /*251701*/
             ENDDO                                                                        /*CSC059*/
                                                                                          /*251701*/
/*/COPY WNCPYSRC,MAC0130004                                          */
             GOTO       CMDLBL(END)

 ABNOR:      CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000)
             SNDMSG     MSG('MAC0130 - Set download flag for PC +
                          ended abnormally') TOMSGQ(MOPERQ)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000)

 END:        ENDPGM
