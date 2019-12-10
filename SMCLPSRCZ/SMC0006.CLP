/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SM Check contents of "to" library')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Implementation module                               */
/*                                                                   */
/*       SMC0006 - Check contents of "to" library                    */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD054605           Date 17Oct19              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      CUP034             Date 23Jan07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CUP033             Date 30Jun06              */
/*                      CSM005             Date 21Sep05              */
/*                      CSM003             Date 30May05              */
/*                      CUP016 *CREATE     Date 26Mar03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD054605 - Deliverable Data Split for SDSVALPD              */
/*       MD046248 - Finastra Rebranding                              */
/*       CUP034 - Reduce size of implementation library.             */
/*       CUP033 - Removal of System Value /COPYs.                    */
/*       CSM005 - Changes to /COPYs.  Recompile.                     */
/*       CSM003 - Use system value rather than UPSTAT.               */
/*       CUP016 - Add implementation software to core.               */
/*                                                                   */
/*********************************************************************/
/**********  PGM        PARM(&LIBTYPE)                                                 */ /*CUP033*/
             PGM        PARM(&LIBTYPE &PFXSVAL &OPFXSVAL)                                 /*CUP033*/

/**COPY*UPCPYSRC,UPSVALDCL*                                          */ /*             */ /*CUP033*/
             DCL        VAR(&LIBTYPE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PFXSVAL) TYPE(*CHAR) LEN(20)                                 /*CUP033*/
             DCL        VAR(&OPFXSVAL) TYPE(*CHAR) LEN(20)                                /*CUP033*/

/**********  DCL        VAR(&TOSBSID) TYPE(*CHAR) LEN(2)                               */ /*CSM003*/
             DCL        VAR(&SBSID) TYPE(*CHAR) LEN(2)                                    /*CSM003*/
             DCL        VAR(&OLDSBSID) TYPE(*CHAR) LEN(2)                                 /*CSM003*/
             DCL        VAR(&BLANKSVAL) TYPE(*CHAR) LEN(1) VALUE('N')                     /*CUP033*/
             DCL        VAR(&FROMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NOTFMBR) TYPE(*CHAR) LEN(10)
/**********  DCL        VAR(&UPSTAT) TYPE(*CHAR) LEN(256)                              */ /*CSM003*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')

/**********  DCLF       FILE(UPSVALJ0) */                                      /*CUP033* *MD054605*/
             DCLF       FILE(UPSVALJ0) ALWNULL(*YES)                                    /*MD054605*/

/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES)
             CHGJOB     SWS(XXXXXX00)

/* Create data area /MIDASMSG in QTEMP */
             DLTDTAARA  DTAARA(QTEMP/MIDASMSG)
             MONMSG     MSGID(CPF0000)
             CRTDTAARA  DTAARA(QTEMP/MIDASMSG) TYPE(*CHAR) LEN(800) +
                          VALUE(' ')

/**COPY*UPCPYSRC,UPSVALCAL1*                                         */ /*             */ /*CUP033*/
/**COPY*UPCPYSRC,UPSVALCAL3*                                         */ /*  /* /*CSM003*/ /*CUP033*/
/**********  IF         COND(&PTFUPG *EQ ' ' *OR &SBSID *EQ ' ') +                     */ /*CSM003*/
/**********               THEN(DO)                                                     */ /*CSM003*/
/**********  IF         COND(&SBSID *EQ ' ' *OR &PTFUPG *EQ ' ' *OR +                  */ /*CUP033*/
/**********               &OLDSBSID *EQ ' ') THEN(DO)                       */ /*CSM003*/ /*CUP033*/

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

             GOTO       CMDLBL(VALIDATE)                                                  /*CUP033*/

 CHECK:                                                                                   /*CUP033*/
             IF         COND(&BLANKSVAL *EQ 'Y') THEN(DO)                                 /*CUP033*/
/* Set up messages for Midas Information Screen  */
                RTVMSG     MSGID(UPM0003) MSGF(UTMSGF) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
                RTVMSG     MSGID(UPM0004) MSGF(UTMSGF) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (151 50)) VALUE(&MESSAGE)
                CALL       PGM(SCC0010) PARM('SMC0006' 'ENTER' ' ')
                GOTO       CMDLBL(END)
             ENDDO

/**Retrieve*to*library*prefix*from*data*area*UPSTAT**/ /*                              */ /*CSM003*/
/**********  RTVDTAARA  DTAARA(&PTFUPG/UPSTAT) RTNVAR(&UPSTAT)                         */ /*CSM003*/
/**********  CHGVAR     VAR(&TOSBSID) VALUE(%SST(&UPSTAT 62 2))                        */ /*CSM003*/
/**If*this*is*blank*then*this*should*mean*that*this*is*an*'XX'**/ /*                   */ /*CSM003*/
/**to*'XX'*type*migration.**************************************/ /*                   */ /*CSM003*/
/**********  IF         COND(&TOSBSID *EQ '  ') THEN(DO)                               */ /*CSM003*/
/**********     CHGVAR     VAR(&TOSBSID) VALUE(%SST(&UPSTAT 60 2))                     */ /*CSM003*/
/**********  ENDDO                                                                     */ /*CSM003*/

/* Set up library list. */                                                                /*CUP034*/
             CALL       PGM(UPC0014) PARM(&SBSID)                                         /*CUP034*/

/* Set up library names */
             IF         COND(&LIBTYPE *EQ 'DM') THEN(DO)
/**********     CHGVAR     VAR(&FROMLIB) VALUE(&SBSID *TCAT 'DMLIB')                   */ /*CSM003*/
/**********     CHGVAR     VAR(&TOLIB) VALUE(&TOSBSID *TCAT 'DMLIB')                   */ /*CSM003*/
                CHGVAR     VAR(&FROMLIB) VALUE(&OLDSBSID *TCAT 'DMLIB')                   /*CSM003*/
                CHGVAR     VAR(&TOLIB) VALUE(&SBSID *TCAT 'DMLIB')                        /*CSM003*/
                CHGVAR     VAR(&NOTFMBR) VALUE(SMDMNFQF)
             ENDDO
             IF         COND(&LIBTYPE *EQ 'DP') THEN(DO)
/**********     CHGVAR     VAR(&FROMLIB) VALUE(&SBSID *TCAT 'DPLIB')                   */ /*CSM003*/
/**********     CHGVAR     VAR(&TOLIB) VALUE(&TOSBSID *TCAT 'DPLIB')                   */ /*CSM003*/
                CHGVAR     VAR(&FROMLIB) VALUE(&OLDSBSID *TCAT 'DPLIB')                   /*CSM003*/
                CHGVAR     VAR(&TOLIB) VALUE(&SBSID *TCAT 'DPLIB')                        /*CSM003*/
                CHGVAR     VAR(&NOTFMBR) VALUE(SMDPNFQF)
             ENDDO
             IF         COND(&LIBTYPE *EQ 'DT') THEN(DO)
/**********     CHGVAR     VAR(&FROMLIB) VALUE(&SBSID *TCAT 'DTALIB')                  */ /*CSM003*/
/**********     CHGVAR     VAR(&TOLIB) VALUE(&TOSBSID *TCAT 'DTALIB')                  */ /*CSM003*/
                CHGVAR     VAR(&FROMLIB) VALUE(&OLDSBSID *TCAT 'DTALIB')                  /*CSM003*/
                CHGVAR     VAR(&TOLIB) VALUE(&SBSID *TCAT 'DTALIB')                       /*CSM003*/
                CHGVAR     VAR(&NOTFMBR) VALUE(SMDTNFQF)
             ENDDO
             IF         COND(&LIBTYPE *EQ 'DZ') THEN(DO)
/**********     CHGVAR     VAR(&FROMLIB) VALUE(&SBSID *TCAT 'DZLIB')                   */ /*CSM003*/
/**********     CHGVAR     VAR(&TOLIB) VALUE(&TOSBSID *TCAT 'DZLIB')                   */ /*CSM003*/
                CHGVAR     VAR(&FROMLIB) VALUE(&OLDSBSID *TCAT 'DZLIB')                   /*CSM003*/
                CHGVAR     VAR(&TOLIB) VALUE(&SBSID *TCAT 'DZLIB')                        /*CSM003*/
                CHGVAR     VAR(&NOTFMBR) VALUE(SMDZNFQF)
/* Check that a DZ library exists in the "from" system. */
                CHKOBJ     OBJ(&FROMLIB) OBJTYPE(*LIB)
                MONMSG     MSGID(CPF9801) EXEC(DO)
                   GOTO       CMDLBL(END)
                ENDDO
             ENDDO

/* Delete outfiles if they already exist */
             DLTF       FILE(QTEMP/UPFLIBOF)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/UPTLIBOF)
             MONMSG     MSGID(CPF0000)

/* Produce outfiles of files in "from" and "to" library. */
             DSPOBJD    OBJ(&FROMLIB/*ALL) OBJTYPE(*ALL) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/UPFLIBOF)
             DSPOBJD    OBJ(&TOLIB/*ALL) OBJTYPE(*ALL) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/UPTLIBOF)

/* Copy outfile of "from" library to keyed version of the file. */
             CPYF       FROMFILE(QTEMP/UPFLIBOF) TOFILE(UPNOTFPD) +
                          TOMBR(&NOTFMBR) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)

/* Call program to remove records found in both outfiles. */
             OVRDBF     FILE(UPNOTFPD) TOFILE(UPNOTFPD) MBR(&NOTFMBR)
             CALL       PGM(SM0006)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO

/* Call program to produce report of files not in "to" library. */
             CALL       PGM(UP0260)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO

/* Call program to produce display file for file selection. */
             CALL       PGM(UP0261) PARM(&TOLIB)

             GOTO       CMDLBL(END)
ABNOR:
/* Set up messages for Midas Information Screen  */
             RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('SMC0006') MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE('Check +
                          joblog for details')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(SCC0010) PARM('SMC0006' 'ENTER' ' ')
             MONMSG     MSGID(CPF0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
END:
             DLTOVR     FILE(UPNOTFPD)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')

             ENDPGM
