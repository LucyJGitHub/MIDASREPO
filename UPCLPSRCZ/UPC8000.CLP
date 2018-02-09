/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas UP Build/Review *ALL Action Files - shell')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Bridge                                              */
/*                                                                   */
/*       UPC8000 - Build/Review *ALL Action Files                    */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CUP021             Date 07Feb11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      CUP033             Date 18Sep06              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CPK023             Date 06Dec05              */
/*                      CSM005             Date 21Sep05              */
/*                      CUP024             Date 13Jun03              */
/*                      CUP020  *CREATE    Date 03Jan03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CUP021 - Rewrite of Action File processing.                 */
/*       CUP033 - Removal of System Value /COPYs                     */
/*       CPK023 - No specific library reference for UPSTAT.          */
/*       CSM005 - Changes to /COPYs.  Recompile.                     */
/*       CUP024 - Migration of Bridge ICD to the System Values file. */
/*       CUP020 - Additional changes for Action Files                */
/*                                                                   */
/*********************************************************************/
/**********  PGM        PARM(&MODE)                                                    */ /*CUP033*/
/**********  PGM        PARM(&MODE &PFXSVAL &OPFXSVAL &BRGSVAL)             */ /*CUP033*/ /*CUP021*/
             PGM        PARM(&MODE &PFXSVAL &OPFXSVAL &LAYER)                             /*CUP021*/
 
/* Mode can be of three types:                                    */
/*  *BUILD  - Build only (only valid during implementation)       */
/****BLDRVW*-*Build*and*review*(only valid during implementation)**/ /*                */ /*CUP021*/
/*  *REVIEW - Review only (only valid during implementation)      */
 
             DCL        VAR(&PFXSVAL) TYPE(*CHAR) LEN(20)                                 /*CUP033*/
             DCL        VAR(&OPFXSVAL) TYPE(*CHAR) LEN(20)                                /*CUP033*/
/**********  DCL        VAR(&BRGSVAL) TYPE(*CHAR) LEN(20)                   */ /*CUP033*/ /*CUP021*/
             DCL        VAR(&LAYER) TYPE(*CHAR) LEN(7)                                    /*CUP021*/
/**COPY*UPCPYSRC,UPSVALDCL*                                          */ /*  */ /*CUP024*/ /*CUP033*/
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SBSID) TYPE(*CHAR) LEN(2)                                    /*CUP033*/
             DCL        VAR(&OLDSBSID) TYPE(*CHAR) LEN(2)                                 /*CUP033*/
/**********  DCL        VAR(&PTFUPG) TYPE(*CHAR) LEN(10)                    */ /*CUP033*/ /*CUP021*/
             DCL        VAR(&BLANKSVAL) TYPE(*CHAR) LEN(1) VALUE('N')                     /*CUP033*/
             DCL        VAR(&OLDLIB) TYPE(*CHAR) LEN(10)                                  /*CUP021*/
             DCL        VAR(&NEWLIB) TYPE(*CHAR) LEN(10)                                  /*CUP021*/
 
/**********  DCL        VAR(&UPSTAT) TYPE(*CHAR) LEN(256)                              */ /*CUP033*/
/**********  DCL        VAR(&TOSBSID) TYPE(*CHAR) LEN(2)                               */ /*CUP033*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
/************DCLF       FILE(UPUICDPD)                                                 */ /*CUP024*/
             DCLF       FILE(UPSVALJ0)                                                    /*CUP033*/
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES)
             CHGJOB     SWS(XXXXXX00)
 
             DLTDTAARA  DTAARA(QTEMP/MIDASMSG)
             MONMSG     MSGID(CPF0000)
             CRTDTAARA  DTAARA(QTEMP/MIDASMSG) TYPE(*CHAR) LEN(800) +
                          VALUE(' ')
 
/* Create temporary file to hold error messages. */                                       /*CUP021*/
             DLTF       FILE(QTEMP/UPERRMQT)                                              /*CUP021*/
             MONMSG     MSGID(CPF2105)                                                    /*CUP021*/
             CRTPF      FILE(QTEMP/UPERRMQT) RCDLEN(100) +
                          TEXT('Temporary file for holding error +
                          messages')                                                      /*CUP021*/
 
/************RCVF                                                                      */ /*CUP024*/
/**COPY*UPCPYSRC,UPSVALCAL1*                                         */ /*  */ /*CUP024*/ /*CUP033*/
/**COPY*UPCPYSRC,UPSVALCAL3*                                         */ /*  */ /*CPK023*/ /*CUP033*/
 
/**Check*if*all*relevant*fields*have*been*entered*in*ICD.**//*                         */ /*CUP033*/
/**********  IF         COND(&PTFUPG *EQ ' ' *OR &SBSID *EQ ' ') +                     */ /*CPK023*/
/**********               THEN(DO)                                                     */ /*CPK023*/
/**********  IF         COND(&SBSID *EQ ' ' *OR &PTFUPG *EQ ' ' *OR +                  */ /*CUP033*/
/**********               &OLDSBSID *EQ ' ') THEN(DO)                       */ /*CPK023*/ /*CUP033*/
 
VALIDATE:                                                                                 /*CUP033*/
             RCVF                                                                         /*CUP033*/
             MONMSG     MSGID(CPF0864) EXEC(DO)                                           /*CUP033*/
                GOTO       CMDLBL(CHECK)                                                  /*CUP033*/
             ENDDO                                                                        /*CUP033*/
 
             IF         COND(&GISVAL *EQ &PFXSVAL) THEN(DO)                               /*CUP033*/
                IF         COND(&GIVAL *EQ ' ') THEN(DO)                                  /*CUP033*/
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                                  /*CUP033*/
                ENDDO                                                                     /*CUP033*/
                ELSE       CMD(DO)                                                        /*CUP033*/
                   CHGVAR     VAR(&SBSID) VALUE(&GIVAL)                                   /*CUP033*/
                ENDDO                                                                     /*CUP033*/
             ENDDO                                                                        /*CUP033*/
 
             IF         COND(&GISVAL *EQ &OPFXSVAL) THEN(DO)                              /*CUP033*/
                IF         COND(&GIVAL *EQ ' ') THEN(DO)                                  /*CUP033*/
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                                  /*CUP033*/
                ENDDO                                                                     /*CUP033*/
                ELSE       CMD(DO)                                                        /*CUP033*/
                   CHGVAR     VAR(&OLDSBSID) VALUE(&GIVAL)                                /*CUP033*/
                ENDDO                                                                     /*CUP033*/
             ENDDO                                                                        /*CUP033*/
 
/**********  IF         COND(&GISVAL *EQ BRGXSVAL) THEN(DO)                 */ /*CUP033*/ /*CUP021*/
/**********     IF         COND(&GIVAL *EQ ' ') THEN(DO)                    */ /*CUP033*/ /*CUP021*/
/**********        CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                    */ /*CUP033*/ /*CUP021*/
/**********     ENDDO                                                       */ /*CUP033*/ /*CUP021*/
/**********     ELSE       CMD(DO)                                          */ /*CUP033*/ /*CUP021*/
/**********        CHGVAR     VAR(&PTFUPG) VALUE(&GIVAL)                    */ /*CUP033*/ /*CUP021*/
/**********     ENDDO                                                       */ /*CUP033*/ /*CUP021*/
/**********  ENDDO                                                          */ /*CUP033*/ /*CUP021*/
 
             GOTO       CMDLBL(VALIDATE)                                                  /*CUP033*/
 
 CHECK:                                                                                   /*CUP033*/
             IF         COND(&BLANKSVAL *EQ 'Y') THEN(DO)                                 /*CUP033*/
                RTVMSG     MSGID(UPM0003) MSGF(UTMSGF) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
                RTVMSG     MSGID(UPM0004) MSGF(UTMSGF) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (151 50)) VALUE(&MESSAGE)
                CALL       PGM(SCC0010) PARM('UPC8000' 'ENTER' ' ')
                GOTO       CMDLBL(END)
             ENDDO
 
/* Set up library list. */                                                                /*CUP033*/
             CALL       PGM(UPC0014) PARM(&SBSID)                                         /*CUP033*/
 
/**Retrieve*'to'*library*prefix*from*data*area*UPSTAT.**/ /*                           */ /*CPK023*/
/**********  RTVDTAARA  DTAARA(&PTFUPG/UPSTAT) RTNVAR(&UPSTAT)                         */ /*CPK023*/
/**********  CHGVAR     VAR(&TOSBSID) VALUE(%SST(&UPSTAT 62 2))                        */ /*CPK023*/
/**If*&TOSBSID*is*blank*this*means*that*this*is*an*'XX'*to*'XX'**/ /*                  */ /*CPK023*/
/**type*upgrade.*************************************************/ /*                  */ /*CPK023*/
/**********  IF         COND(&TOSBSID *EQ ' ') THEN(DO)                                */ /*CPK023*/
/**********     CHGVAR     VAR(&TOSBSID) VALUE(%SST(&UPSTAT 60 2))                     */ /*CPK023*/
/**********  ENDDO                                                                     */ /*CPK023*/
 
/* Copy UPACTFPD file to temporary version. */
             DLTF       FILE(QTEMP/UPACTFQT)
             MONMSG     MSGID(CPF0000)
/**********  CPYF       FROMFILE(UPACTFPD) TOFILE(QTEMP/UPACTFQT) +                    */ /*CUP021*/
/**********               MBROPT(*REPLACE) CRTFILE(*YES)                               */ /*CUP021*/
             CPYF       FROMFILE(UPACTFPD) TOFILE(QTEMP/UPACTFQT) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          INCCHAR(AALAYR 1 *EQ &LAYER)                                    /*CUP021*/
 
             CHGVAR     VAR(&OLDLIB) VALUE(&OLDSBSID *TCAT 'DTALIB')                      /*CUP021*/
             CHGVAR     VAR(&NEWLIB) VALUE(&SBSID *TCAT 'DTALIB')                         /*CUP021*/
 
/**Call*program*to*check*Action*Files.**/ /*                                           */ /*CUP021*/
/**********  CALL       PGM(UPC8001) PARM(&MODE &SBSID &TOSBSID +                      */ /*CPK023*/
/**********               &PTFUPG)                                                     */ /*CPK023*/
/**********  CALL       PGM(UPC8001) PARM(&MODE &OLDSBSID &SBSID +                     */ /*CUP021*/
/**********               &PTFUPG)                                          */ /*CPK023*/ /*CUP021*/
             CALL       PGM(UPC008001) PARM(&MODE &OLDLIB &NEWLIB)                        /*CUP021*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/**********     RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +                               */ /*CUP021*/
/**********               MSGDTA('UPC8001') MSG(&MESSAGE)                              */ /*CUP021*/
                RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('UPC008001') MSG(&MESSAGE)                               /*CUP021*/
                CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
/**********     CALL       PGM(SCC0010) PARM('UPC8001' 'JOBLOG' 'Y')                   */ /*CUP021*/
                CALL       PGM(SCC0010) PARM('UPC008001' 'JOBLOG' 'Y')                    /*CUP021*/
                GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(END)
 
ABNOR:
             RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('UPC8000') MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE('Check +
                          joblog for details')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(SCC0010) PARM('UPC8000' 'JOBLOG' 'Y')
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
