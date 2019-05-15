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
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG11102           Date 15May06              */
/*                      CPK024             Date 12Apr06              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      194175             Date 03Aug01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      078155  *CREATE    Date 06Jan95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
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
 
/***COPY*MACPYSRC,MAC0121INT*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,MAC0121INT                                          */                   /*CPK024*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/***COPY*MACPYSRC,MAC0121MPS*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,MAC0121MPS                                          */                   /*CPK024*/
 
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
 
/***COPY*MACPYSRC,MAC0121END*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,MAC0121END                                          */                   /*CPK024*/
 
             ENDPGM
