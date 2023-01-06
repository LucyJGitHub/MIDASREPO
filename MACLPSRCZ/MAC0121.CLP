/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MA Rename or delete DOWNLOAD.xx folder')        */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Optical Reporting Facility                      */
/*                                                                   */
/*       MAC0121 - Delete or Rename the Optical Disk                 */
/*                 DOWNLOAD.xx Folder.                               */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD025638           Date 10Oct22              */
/*       Prev Amend No. CSC059             Date 10Oct22              */
/*                      MD058733           Date 16Feb22              */
/*                      MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG11102           Date 15May06              */
/*                      CPK024             Date 12Apr06              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      194175             Date 03Aug01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      078155  *CREATE    Date 06Jan95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD025638 - CRTDIR fails with CPFA09 error. Add '/' in front */
/*                  of &IASP when in IASP env. and &IASP is not      */
/*                  preceded with '/'.                               */
/*                - Applied for MD-38096.                            */
/*       CSC059 - Replace QDLS processing by IFS                     */
/*       MD058733 - In download to STORQM, DOWNLOAD directory is not */
/*                  recreated in IFS and DAT file authorities are    */
/*                  wrong.                                           */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG11102 - Do not proceed with rename if backup folder      */
/*                  already exists.                                  */
/*       CPK024 - Packaging of MPlus 1.2.1. Copy sources needed by   */
/*                UTC0012.                                           */
/*       194175 - Add loop to retry delete folder ten times if locked*/
/*                by PC ORF job.                                     */
/*       078155 - New program created for this change.               */
/*                - Allow the optical disk download folder to be     */
/*                  either renamed or deleted daily by setting a     */
/*                  flag on the optical disk ICD.                    */
/*                                                                   */
/*********************************************************************/
             PGM

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&SYSTEM) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RTNCODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&STRING) TYPE(*CHAR) LEN(200)
             DCL        VAR(&FOLDER) TYPE(*CHAR) LEN(17)
             DCL        VAR(&OLDFLR) TYPE(*CHAR) LEN(11)
             DCL        VAR(&NEWFLR) TYPE(*CHAR) LEN(11)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(3 0) VALUE(1)                          /*194175*/
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
             DCL        VAR(&OLDDIR) TYPE(*CHAR) LEN(50)                                /*MD058733*/
             DCL        VAR(&NEWDIR) TYPE(*CHAR) LEN(11)                                /*MD058733*/
             DCL        VAR(&IFSFIX) TYPE(*CHAR) LEN(1)                                 /*MD058733*/
             DCL        VAR(&SVALK1) TYPE(*CHAR) LEN(20)                                /*MD058733*/
             DCL        VAR(&SVAL1) TYPE(*CHAR) LEN(200)                                /*MD058733*/
             DCL        VAR(&SVALK2) TYPE(*CHAR) LEN(20)                                /*MD058733*/
             DCL        VAR(&SVAL2) TYPE(*CHAR) LEN(200)                                /*MD058733*/
             DCL        VAR(&SVALK3) TYPE(*CHAR) LEN(20)                                /*MD058733*/
             DCL        VAR(&SVAL3) TYPE(*CHAR) LEN(200)                                /*MD058733*/
             DCL        VAR(&SVALK4) TYPE(*CHAR) LEN(20)                                /*MD058733*/
             DCL        VAR(&SVAL4) TYPE(*CHAR) LEN(200)                                /*MD058733*/
             DCL        VAR(&SVALK5) TYPE(*CHAR) LEN(20)                                /*MD058733*/
             DCL        VAR(&SVAL5) TYPE(*CHAR) LEN(200)                                /*MD058733*/
             DCL        VAR(&SVALK6) TYPE(*CHAR) LEN(20)                                /*MD058733*/
             DCL        VAR(&SVAL6) TYPE(*CHAR) LEN(200)                                /*MD058733*/
             DCL        VAR(&SVALK7) TYPE(*CHAR) LEN(20)                                /*MD058733*/
             DCL        VAR(&SVAL7) TYPE(*CHAR) LEN(200)                                /*MD058733*/
             DCL        VAR(&SVALK8) TYPE(*CHAR) LEN(20)                                /*MD058733*/
             DCL        VAR(&SVAL8) TYPE(*CHAR) LEN(200)                                /*MD058733*/
             DCL        VAR(&SVALK9) TYPE(*CHAR) LEN(20)                                /*MD058733*/
             DCL        VAR(&SVAL9) TYPE(*CHAR) LEN(200)                                /*MD058733*/
             DCL        VAR(&SVALK0) TYPE(*CHAR) LEN(20)                                /*MD058733*/
             DCL        VAR(&SVAL10) TYPE(*CHAR) LEN(200)                               /*MD058733*/

/***COPY*MACPYSRC,MAC0121INT*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,MAC0121INT                                          */                   /*CPK024*/

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/***COPY*MACPYSRC,MAC0121MPS*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,MAC0121MPS                                          */                   /*CPK024*/
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
             OVRPRTF    FILE(QSYSPRT) HOLD(*YES)                                          /*CSC059*/
             ENDDO                                                                        /*CSC059*/
/*                                                                                        /*CSC059*/

/* Determine whether a rename or delete is required */

             CALL       PGM(AOOPTCR0) PARM(&RTNCODE '*FIRST' &STRING)

             IF         COND(&RTNCODE *NE ' ') THEN(GOTO CMDLBL(ABNOR))

/* If neither a rename or delete are required */

             IF         COND((%SST(&STRING 37 1) *NE 'D') *AND +
                          (%SST(&STRING 37 1) *NE 'R')) THEN(DO)
               GOTO       CMDLBL(END)
             ENDDO


/* Get Midas system prefix from DTAARA/SDSTAT */

             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSTEM)

/* If feature CSC059 is switched on */                                                    /*CSC059*/
             IF         COND(&CSC059 *EQ 'Y') THEN(DO)                                    /*CSC059*/
                                                                                          /*CSC059*/
/* Build folder name */                                                                   /*CSC059*/
                                                                                          /*CSC059*/
             CHGVAR     VAR(&FOLDER) VALUE('OPTIC/DOWNLOAD.' *CAT +
                          &SYSTEM)                                                        /*CSC059*/
                                                                                          /*CSC059*/
/* Build old folder name */                                                               /*CSC059*/
                                                                                          /*CSC059*/
               CHGVAR     VAR(&OLDFLR) VALUE('DOWNLOAD.' *CAT &SYSTEM)                    /*CSC059*/
                                                                                          /*CSC059*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC059*/
             CHGVAR     VAR(&FLRIAS) VALUE(&IASP *TCAT '/' *CAT &ZSUBDIR *TCAT +
                                           '/OPTIC/' *CAT &OLDFLR)                        /*CSC059*/
             IF         COND((&IASP_YN *EQ 'Y') *AND (&IASP_PR *NE +
                          '/')) THEN(CHGVAR VAR(&FLRIAS) VALUE('/' +
                          *TCAT &IASP *TCAT '/' *CAT &ZSUBDIR *TCAT +
                          '/OPTIC/' *CAT &OLDFLR))                                      /*MD025638*/
             ENDDO                                                                        /*CSC059*/
             ELSE       CMD(DO)                                                           /*CSC059*/
             CHGVAR     VAR(&FLRIAS) VALUE('/' *CAT &ZSUBDIR *TCAT +
                                           '/OPTIC/' *CAT &OLDFLR)                        /*CSC059*/
             ENDDO                                                                        /*CSC059*/
             DSPLNK     OBJ(&FLRIAS) OUTPUT(*PRINT) OBJTYPE(*DIR)                         /*CSC059*/
             MONMSG     MSGID(CPFA0A9) EXEC(GOTO CMDLBL(END))                             /*CSC059*/
             DLTSPLF    FILE(QSYSPRT) SPLNBR(*LAST)                                       /*CSC059*/
                                                                                          /*CSC059*/
/*Or rename the folder */                                                                 /*CSC059*/
             IF         COND(%SST(&STRING 37 1) *EQ 'R') THEN(DO)                         /*CSC059*/
                                                                                          /*CSC059*/
/* Get the rundate */                                                                     /*CSC059*/
                                                                                          /*CSC059*/
               CALL       PGM(AOBANKR0) PARM(&RTNCODE '*FIRST' &STRING)                   /*CSC059*/
                                                                                          /*CSC059*/
               IF         COND(&RTNCODE *NE ' ') THEN(GOTO +
                            CMDLBL(ABNOR))                                                /*CSC059*/
                                                                                          /*CSC059*/
/* Build new folder name */                                                               /*CSC059*/
                                                                                          /*CSC059*/
             CHGVAR     VAR(&NEWFLR) VALUE('D' *CAT %SST(&STRING 43 +
                          7) *CAT '.' *CAT &SYSTEM)                                       /*CSC059*/
                                                                                          /*CSC059*/
             IF         COND(%SST(&NEWFLR 2 1) *EQ ' ') THEN(DO)                          /*CSC059*/
                CHGVAR     VAR(%SST(&NEWFLR 2 1)) VALUE('0')                              /*CSC059*/
             ENDDO                                                                        /*CSC059*/
                                                                                          /*CSC059*/
/* Only rename if new folder does not exist in OPTIC */                                 /*BUG11102*/
                                                                                          /*CSC059*/
                IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                /*CSC059*/
                   CHGVAR     VAR(&FLRIAS) VALUE(&IASP *TCAT '/' *CAT &ZSUBDIR *TCAT +
                                           '/OPTIC/' *CAT &NEWFLR)                        /*CSC059*/
                   IF         COND((&IASP_YN *EQ 'Y') *AND (&IASP_PR *NE +
                          '/')) THEN(CHGVAR VAR(&FLRIAS) VALUE('/' +
                          *TCAT &IASP *TCAT '/' *CAT &ZSUBDIR *TCAT +
                          '/OPTIC/' *CAT &NEWFLR))                                      /*MD025638*/
                ENDDO                                                                     /*CSC059*/
                ELSE       CMD(DO)                                                        /*CSC059*/
                   CHGVAR     VAR(&FLRIAS) VALUE('/' *CAT &ZSUBDIR *TCAT +
                                           '/OPTIC/' *CAT &NEWFLR)                        /*CSC059*/
                ENDDO                                                                     /*CSC059*/
                DSPLNK     OBJ(&FLRIAS) OUTPUT(*PRINT) OBJTYPE(*DIR)                      /*CSC059*/
                MONMSG     MSGID(CPFA0A9) EXEC(DO)                                        /*CSC059*/
                   IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                             /*CSC059*/
                      CHGVAR     VAR(&FILE) VALUE(&IASP *TCAT '/' *CAT &ZSUBDIR *TCAT +
                                           '/OPTIC/' *CAT &OLDFLR)                        /*CSC059*/
                      IF         COND((&IASP_YN *EQ 'Y') *AND (&IASP_PR *NE +
                          '/')) THEN(CHGVAR VAR(&FILE) VALUE('/' +
                          *TCAT &IASP *TCAT '/' *CAT &ZSUBDIR *TCAT +
                          '/OPTIC/' *CAT &OLDFLR))                                      /*MD025638*/
                   ENDDO                                                                  /*CSC059*/
                   ELSE       CMD(DO)                                                     /*CSC059*/
                      CHGVAR     VAR(&FILE) VALUE('/' *CAT &ZSUBDIR *TCAT +
                                           '/OPTIC/' *CAT &OLDFLR)                        /*CSC059*/
                   ENDDO                                                                  /*CSC059*/
                   RNM        OBJ(&FILE) NEWOBJ(&NEWFLR)                                  /*CSC059*/
                   SNDPGMMSG  MSG('Directory ' *CAT &OLDFLR *CAT ' successfully +
                          renamed to ' *CAT &NEWFLR) TOMSGQ(MOPERQ)                       /*CSC059*/
                                                                                          /*CSC059*/
                   DLTSPLF    FILE(QSYSPRT) SPLNBR(*LAST)                                 /*CSC059*/
                   MONMSG     MSGID(CPF0000)                                              /*CSC059*/
                ENDDO                                                                     /*CSC059*/
                ENDDO                                                                     /*CSC059*/
             ENDDO                                                                        /*CSC059*/
/* If feature CSC059 is switched off */                                                   /*CSC059*/
             ELSE       CMD(DO)                                                           /*CSC059*/

             CALL       PGM(AOSVALR0) PARM(&RTNCODE 'StopORFFailure' +
                          &SVAL1 &SVALK2 &SVAL2 &SVALK3 &SVAL3 +
                          &SVALK4 &SVAL4 &SVALK5 &SVAL5 &SVALK6 +
                          &SVAL6 &SVALK7 &SVAL7 &SVALK8 &SVAL8 +
                          &SVALK9 &SVAL9 &SVALK0 &SVAL10)                               /*MD058733*/
                                                                                        /*MD058733*/
             IF         COND(&RTNCODE *EQ '       ') THEN(DO)                           /*MD058733*/
             CHGVAR     VAR(&IFSFIX) VALUE(%SST(&SVAL1 1 1))                            /*MD058733*/
             ENDDO                                                                      /*MD058733*/
                                                                                        /*MD058733*/
             IF         COND(%SST(&SVAL1 1 4) *EQ '*NRF') THEN(GOTO +
                          CMDLBL(ABNOR))                                                /*MD058733*/
                                                                                        /*MD058733*/
             IF         COND(&IFSFIX *NE 'Y') THEN(DO)                                  /*MD058733*/
/* Build folder name */

             CHGVAR     VAR(&FOLDER) VALUE('OPTIC/DOWNLOAD.' *CAT +
                          &SYSTEM)

/* Build old folder name */

               CHGVAR     VAR(&OLDFLR) VALUE('DOWNLOAD.' *CAT &SYSTEM)

/* Check that the folder exists */

             CHKDLO     DLO(&OLDFLR) FLR(OPTIC) OBJTYPE(*FLR)
             MONMSG     MSGID(CPF8A77) EXEC(GOTO CMDLBL(END))

/* Delete folder and associated documents */

             IF         COND(%SST(&STRING 37 1) *EQ 'D') THEN(DO)
 RETRY:                                                                                   /*194175*/
               DLTDLO     DLO(*ALL) FLR(&FOLDER)
               MONMSG     MSGID(CPF8A78 CPF8A16) EXEC(DO)                                 /*194175*/
                  DLYJOB DLY(51)                                                          /*194175*/
                  CHGVAR VAR(&COUNT) VALUE(&COUNT + 1)                                    /*194175*/
                  IF (&COUNT *LE 10) GOTO RETRY                                           /*194175*/
               ENDDO                                                                      /*194175*/
                IF (&COUNT *EQ 11) THEN(DO)                                               /*194175*/
                   SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) +
                   MSGDTA('Unable to delete documents in' +
                   *BCAT &FOLDER *TCAT ' -- Folder in use') +
                   TOMSGQ(MOPERQ)                                                         /*194175*/
                MONMSG MSGID(CPF0000 MCH0000)                                             /*194175*/
                GOTO ABNOR                                                                /*194175*/
                ENDDO                                                                     /*194175*/
             ENDDO

/* Or rename folder */

             IF         COND(%SST(&STRING 37 1) *EQ 'R') THEN(DO)

/* Get the rundate */

               CALL       PGM(AOBANKR0) PARM(&RTNCODE '*FIRST' &STRING)

               IF         COND(&RTNCODE *NE ' ') THEN(GOTO +
                            CMDLBL(ABNOR))

/* Build new folder name */

             CHGVAR     VAR(&NEWFLR) VALUE('D' *CAT %SST(&STRING 43 +
                          7) *CAT '.' *CAT &SYSTEM)

             IF         COND(%SST(&NEWFLR 2 1) *EQ ' ') THEN(DO)
                CHGVAR     VAR(%SST(&NEWFLR 2 1)) VALUE('0')
             ENDDO

/* Only rename if new folder does not exist in OPTIC */                                 /*BUG11102*/
             CHKDLO     DLO(&NEWFLR) FLR(OPTIC) OBJTYPE(*FLR)                           /*BUG11102*/
             MONMSG     MSGID(CPF8A77) EXEC(DO)                                         /*BUG11102*/
                                                                                        /*BUG11102*/
/* Rename the folder */

               RNMDLO     DLO(&OLDFLR) NEWDLO(&NEWFLR) FLR(OPTIC)
             SNDPGMMSG  MSG('Folder ' *CAT &OLDFLR *CAT ' successfully +
                          renamed to ' *CAT &NEWFLR) TOMSGQ(MOPERQ)                     /*BUG11102*/
             ENDDO                                                                      /*BUG11102*/

             ENDDO
             ENDDO                                                                      /*MD058733*/
             IF         COND(&IFSFIX *EQ 'Y') THEN(DO)                                  /*MD058733*/
             IF         COND(%SST(&STRING 37 1) *EQ 'R') THEN(DO)                       /*MD058733*/
                                                                                        /*MD058733*/
/* Get the rundate */                                                                   /*MD058733*/
                                                                                        /*MD058733*/
             CALL       PGM(AOBANKR0) PARM(&RTNCODE '*FIRST' &STRING)                   /*MD058733*/
                                                                                        /*MD058733*/
             IF         COND(&RTNCODE *NE ' ') THEN(GOTO CMDLBL(ABNOR))                 /*MD058733*/
                                                                                        /*MD058733*/
             CHGVAR     VAR(&OLDDIR) VALUE('/OPTIC/DOWNLOAD.' *CAT &SYSTEM)             /*MD058733*/
                                                                                        /*MD058733*/
/* Build new directory   */                                                             /*MD058733*/
                                                                                        /*MD058733*/
             CHGVAR     VAR(&NEWDIR) VALUE('D' *CAT %SST(&STRING 43 +
                          7) *CAT '.' *CAT &SYSTEM)                                     /*MD058733*/
                                                                                        /*MD058733*/
             IF         COND(%SST(&NEWDIR 2 1) *EQ ' ') THEN(DO)                        /*MD058733*/
                CHGVAR     VAR(%SST(&NEWDIR 2 1)) VALUE('0')                            /*MD058733*/
             ENDDO                                                                      /*MD058733*/
                                                                                        /*MD058733*/
/* Rename the directory */                                                              /*MD058733*/
                                                                                        /*MD058733*/
             REN        OBJ(&OLDDIR) NEWOBJ(&NEWDIR)                                    /*MD058733*/
             SNDPGMMSG  MSG('Directory ' *CAT &OLDDIR *CAT ' successfully +
                          renamed to ' *CAT &NEWDIR) TOMSGQ(MOPERQ)                     /*MD058733*/
                                                                                        /*MD058733*/
             ENDDO                                                                      /*MD058733*/
             ENDDO                                                                      /*MD058733*/
             ENDDO                                                                        /*CSC059*/

/***COPY*MACPYSRC,MAC0121MPE*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,MAC0121MPE                                          */                   /*CPK024*/

             GOTO       CMDLBL(END)

 ABNOR:
/***COPY*MACPYSRC,MAC0121ERR*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,MAC0121ERR                                          */                   /*CPK024*/

             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)

             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MAC0121 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)

END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             MONMSG     MSGID(CPF0000 MCH0000)
             IF         COND(&CSC059  *EQ 'Y') THEN(DLTOVR FILE(QSYSPRT))                 /*CSC059*/

/***COPY*MACPYSRC,MAC0121END*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,MAC0121END                                          */                   /*CPK024*/

             ENDPGM
