/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SM Check contents of "to" DVLIB')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - Implementation module                               */
/*                                                                   */
/*       SMC0010 - Check contents of "to" DVLIB                      */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD021155           Date 09May13              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      CUP034             Date 24Jan07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CUP033             Date 30Jun06              */
/*                      CPK025             Date 03Jul06              */
/*                      CSM005             Date 21Sep05              */
/*                      CSM003             Date 30May05              */
/*                      CPK018             Date 23Feb04              */
/*                      CUP016 *CREATE     Date 01Apr03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD021155 - COB Restructure Phase 1 remnants                 */
/*                - Remove records for SMDLVCPD as it is no longer   */
/*                  multi-membered.                                  */
/*       CUP034 - Reduce size of implementation library.             */
/*       CUP033 - Removal of System Value /COPYs.                    */
/*       CPK025 - MidasPlus 1.3 packaging.  Member name wrong.       */
/*       CSM005 - Changes to /COPYs.  Recompile.                     */
/*       CSM003 - Use system value rather than UPSTAT.               */
/*       CPK018 - MidasPlus packaging.  Remove CHKLIBLE processing.  */
/*       CUP016 - Add implementation software to core.               */
/*                                                                   */
/*********************************************************************/
/**********  PGM                                                                       */ /*CUP033*/
             PGM        PARM(&PFXSVAL &OPFXSVAL &BRGSVAL)                                 /*CUP033*/
 
             DCL        VAR(&PFXSVAL) TYPE(*CHAR) LEN(20)                                 /*CUP033*/
             DCL        VAR(&OPFXSVAL) TYPE(*CHAR) LEN(20)                                /*CUP033*/
             DCL        VAR(&BRGSVAL) TYPE(*CHAR) LEN(20)                                 /*CUP033*/
 
/**COPY*UPCPYSRC,UPSVALDCL*                                          */ /*             */ /*CUP033*/
/**********  DCL        VAR(&TOSBSID) TYPE(*CHAR) LEN(2)                               */ /*CSM003*/
/**********  DCL        VAR(&FAIL) TYPE(*CHAR) LEN(1)                                  */ /*CSM003*/
             DCL        VAR(&SBSID) TYPE(*CHAR) LEN(2)                                    /*CUP033*/
             DCL        VAR(&OLDSBSID) TYPE(*CHAR) LEN(2)                                 /*CUP033*/
             DCL        VAR(&PTFUPG) TYPE(*CHAR) LEN(10)                                  /*CUP033*/
             DCL        VAR(&BLANKSVAL) TYPE(*CHAR) LEN(1) VALUE('N')                     /*CUP033*/
             DCL        VAR(&FROMDVLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FROMDTALIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TODVLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TODMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TODPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TODTALIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SQLSTM) TYPE(*CHAR) LEN(80)                                /*MD021155*/
/**********  DCL        VAR(&UPSTAT) TYPE(*CHAR) LEN(256)                              */ /*CSM003*/
             DCL        VAR(&LF) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
             DCLF       FILE(UPSVALJ0)                                                    /*CUP033*/
 
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
                                                                                        /*MD021155*/
/** Create and rename temporary source file for RUNSQLSTM. */                           /*MD021155*/
             DLTF       FILE(QTEMP/RUNSQLSTM)                                           /*MD021155*/
             MONMSG     MSGID(CPF0000)                                                  /*MD021155*/
             DLTF       FILE(QTEMP/RUNSQL)                                              /*MD021155*/
             MONMSG     MSGID(CPF0000)                                                  /*MD021155*/
             CRTSRCPF   FILE(QTEMP/RUNSQLSTM) RCDLEN(112) +
                          MBR(RUNSQLSTM) TEXT('Temporary source +
                          file for SMC0010')                                            /*MD021155*/
             RNMOBJ     OBJ(QTEMP/RUNSQLSTM) OBJTYPE(*FILE) +
                          NEWOBJ(RUNSQL)                                                /*MD021155*/
 
/**COPY*UPCPYSRC,UPSVALCAL1*                                         */ /*             */ /*CUP033*/
/**COPY*UPCPYSRC,UPSVALCAL3*                                         */ /*  */ /*CSM003*/ /*CSM003*/
/**********  IF         COND(&PTFUPG *EQ ' ' *OR &SBSID *EQ ' ') +                     */ /*CSM003*/
/**********               THEN(DO)                                                     */ /*CSM003*/
/**********  IF         COND(&PTFUPG *EQ ' ' *OR &SBSID *EQ ' ' *OR +                  */ /*CUP033*/
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
 
             IF         COND(&GISVAL *EQ &BRGSVAL) THEN(DO)                               /*CUP033*/
                IF         COND(&GIVAL *EQ ' ') THEN(DO)                                  /*CUP033*/
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                                  /*CUP033*/
                ENDDO                                                                     /*CUP033*/
                ELSE       CMD(DO)                                                        /*CUP033*/
                   CHGVAR     VAR(&PTFUPG) VALUE(&GIVAL)                                  /*CUP033*/
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
                CALL       PGM(SCC0010) PARM('SMC0010' 'ENTER' ' ')
                GOTO       CMDLBL(END)
             ENDDO
 
/* Set up library list. */                                                                /*CUP034*/
             CALL       PGM(UPC0014) PARM(&SBSID)                                         /*CUP034*/
 
/* Set up library names */
/**********  CHGVAR     VAR(&FROMDVLIB) VALUE(&SBSID *TCAT 'DVLIB')                    */ /*CSM003*/
/**********  CHGVAR     VAR(&FROMDTALIB) VALUE(&SBSID *TCAT 'DTALIB')                  */ /*CSM003*/
             CHGVAR     VAR(&FROMDVLIB) VALUE(&OLDSBSID *TCAT 'DVLIB')                    /*CSM003*/
             CHGVAR     VAR(&FROMDTALIB) VALUE(&OLDSBSID *TCAT 'DTALIB')                  /*CSM003*/
/**Retrieve*to*library*prefix*from*data*area*UPSTAT**/ /*                              */ /*CSM003*/
/**********  RTVDTAARA  DTAARA(&PTFUPG/UPSTAT) RTNVAR(&UPSTAT)                         */ /*CSM003*/
/**********  CHGVAR     VAR(&TOSBSID) VALUE(%SST(&UPSTAT 62 2))                        */ /*CSM003*/
/**If*this*is*blank*then*this*should*mean*that*this*is*an*'XX'**/ /*                   */ /*CSM003*/
/**to*'XX'*type*migration.**************************************/ /*                   */ /*CSM003*/
/**********  IF         COND(&TOSBSID *EQ '  ') THEN(DO)                               */ /*CSM003*/
/**********     CHGVAR     VAR(&TOSBSID) VALUE(%SST(&UPSTAT 60 2))                     */ /*CSM003*/
/**********  ENDDO                                                                     */ /*CSM003*/
/**********  CHGVAR     VAR(&TODVLIB) VALUE(&TOSBSID *TCAT 'DVLIB')                    */ /*CSM003*/
/**********  CHGVAR     VAR(&TODMLIB) VALUE(&TOSBSID *TCAT 'DMLIB')                    */ /*CSM003*/
/**********  CHGVAR     VAR(&TODPLIB) VALUE(&TOSBSID *TCAT 'DPLIB')                    */ /*CSM003*/
/**********  CHGVAR     VAR(&TODTALIB) VALUE(&TOSBSID *TCAT 'DTALIB')                  */ /*CSM003*/
             CHGVAR     VAR(&TODVLIB) VALUE(&SBSID *TCAT 'DVLIB')                         /*CSM003*/
             CHGVAR     VAR(&TODMLIB) VALUE(&SBSID *TCAT 'DMLIB')                         /*CSM003*/
             CHGVAR     VAR(&TODPLIB) VALUE(&SBSID *TCAT 'DPLIB')                         /*CSM003*/
             CHGVAR     VAR(&TODTALIB) VALUE(&SBSID *TCAT 'DTALIB')                       /*CSM003*/
 
/**Set*up*library*list**/ /*                                                           */ /*CPK018*/
/**CHKLIBLE:                                                                           */ /*CPK018*/
/**********  CHGVAR     VAR(&FAIL) VALUE(' ')                                          */ /*CPK018*/
/**********  CHKLIBLE   LIBS(&TODMLIB &TODPLIB &TODTALIB) RETURN(&FAIL)                */ /*CPK018*/
/**********  IF         COND(&FAIL *EQ 'F') THEN(DO)                                   */ /*CPK018*/
/**********     EDTLIBL                                                                */ /*CPK018*/
/**********     GOTO       CMDLBL(CHKLIBLE)                                            */ /*CPK018*/
/**********  ENDDO                                                                     */ /*CPK018*/
 
             RMVLIBLE   LIB(&TODMLIB)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(&TODMLIB)
 
             RMVLIBLE   LIB(&TODPLIB)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(&TODPLIB)
 
             RMVLIBLE   LIB(&TODTALIB)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(&TODTALIB)
 
/* Delete outfiles if they already exist */
             DLTF       FILE(QTEMP/FROMDVLIB)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(&PTFUPG/FILEMBR)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(&PTFUPG/FILEMULMBR)
             MONMSG     MSGID(CPF0000)
 
/* Get data about logical file members in "from" DVLIB. */
             DSPFD      FILE(&FROMDVLIB/*ALL) TYPE(*MBR) +
                          OUTPUT(*OUTFILE) FILEATR(*LF) +
                          OUTFILE(&PTFUPG/FILEMBR)
             MONMSG     MSGID(CPF3020) EXEC(DO)
                GOTO       CMDLBL(DTALIB)
             ENDDO
             CHGVAR     VAR(&LF) VALUE('*YES')
 
/* Repeat for DTALIB. */
DTALIB:
             DSPFD      FILE(&FROMDTALIB/*ALL) TYPE(*MBR) +
                          OUTPUT(*OUTFILE) FILEATR(*LF) +
                          OUTFILE(&PTFUPG/FILEMBR) OUTMBR(*FIRST *ADD)
             MONMSG     MSGID(CPF3020) EXEC(DO)
                IF         COND(&LF *NE '*YES') THEN(DO)
                   GOTO       CMDLBL(DSPOBJD)
                ENDDO
             ENDDO
/** Remove records for SMDLVCPD before copying. */                                      /*MD021155*/
             CHGVAR     VAR(&SQLSTM) VALUE('delete from' *BCAT +
                          &PTFUPG *TCAT '/FILEMBR where MBBOF = +
                          ''SMDLVCPD''')                                                /*MD021155*/
             CALL       PGM(UTWRTSQL) PARM(&SQLSTM '*CLEAR')                            /*MD021155*/
             RUNSQLSTM  SRCFILE(QTEMP/RUNSQL) SRCMBR(RUNSQLSTM) +
                          COMMIT(*NONE)                                                 /*MD021155*/
             MONMSG     MSGID(SQL9010)                                                  /*MD021155*/
 
             CPYF       FROMFILE(&PTFUPG/FILEMBR) +
                          TOFILE(&PTFUPG/FILEMULMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          INCREL((*IF MBNOMB *GT 1))
 
/* Produce outfile of files in "from" DVLIB */
DSPOBJD:
             DSPOBJD    OBJ(&FROMDVLIB/*ALL) OBJTYPE(*ALL) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/FROMDVLIB)
 
/* Produce outfile of files in "to" DVLIB */
             DSPFD      FILE(&TODVLIB/*ALL) TYPE(*BASATR) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/UPDVLBOF)
 
/* Produce query to identify files not in "to" library that          */
/*  exist in "from" library                                          */
             OPNQRYF    FILE((QTEMP/FROMDVLIB) (UPDVLBOF)) +
                          FORMAT(QADSPOBJ) JFLD((1/ODOBNM 2/ATFILE +
                          *EQ)) JDFTVAL(*ONLYDFT)
             CPYFRMQRYF FROMOPNID(FROMDVLIB) TOFILE(QTEMP/SMDVNFQF) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             CLOF       OPNID(FROMDVLIB)
 
/* Call program to produce report of files not in "to" library       */
/**********  CLRPFM     FILE(UPNOTFPD) MBR(UPDVNFQF)                                   */ /*CPK025*/
             CLRPFM     FILE(UPNOTFPD) MBR(SMDVNFQF)                                      /*CPK025*/
             MONMSG     MSGID(CPF3141)
             CPYF       FROMFILE(QTEMP/SMDVNFQF) TOFILE(UPNOTFPD) +
                          TOMBR(SMDVNFQF) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             OVRDBF     FILE(UPNOTFPD) TOFILE(UPNOTFPD) MBR(SMDVNFQF)
             CALL       PGM(UP0260)
/* Call program to produce display file for file selection */
             CALL       PGM(UP0261) PARM(&TODVLIB)
             DLTOVR     FILE(UPNOTFPD)
 
             GOTO       CMDLBL(END)
 ABNOR:
/* Set up messages for Midas Information Screen  */
             RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('SMC0010') MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE('Check +
                          joblog for details')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(SCC0010) PARM('SMC0010' 'ENTER' ' ')
             MONMSG     MSGID(CPF0000)
 
 END:
/* Remove added libraries. */
             RMVLIBLE   LIB(&TODMLIB)
             MONMSG     MSGID(CPF0000)
             RMVLIBLE   LIB(&TODPLIB)
             MONMSG     MSGID(CPF0000)
             RMVLIBLE   LIB(&TODTALIB)
             MONMSG     MSGID(CPF0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
