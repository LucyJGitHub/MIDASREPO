/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SM Update trailer files SDFCTLPA and TABLETX')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Implementation module                               */
/*                                                                   */
/*       SMC1195 - Update trailer files SDFCTLPA and TABLETX         */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CUP003             Date 04Nov10              */
/*                      BUG27962           Date 03Aug10              */
/*                      BUG27792           Date 02Jun10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      CUP033             Date 18Sep06              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSM005             Date 21Sep05              */
/*                      CSM003             Date 30May05              */
/*                      CUP016 *CREATE     Date 01Apr03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CUP003 - Does not handle the alpha-keys on TABLETX.         */
/*       BUG27792 - New utility to update trailers post-migration    */
/*       CUP033 - Removal of System Value /COPYs                     */
/*       CSM005 - Changes to /COPYs.  Recompile.                     */
/*       CSM003 - Use system value rather than UPSTAT.               */
/*       CUP016 - Add implementation software to core.               */
/*                                                                   */
/*********************************************************************/
/**********  PGM                                                                       */ /*CUP033*/
/**********  PGM        PARM(&PFXSVAL)                                    */ /*CUP033*/ /*BUG27792*/
             PGM        PARM(&PFXSVAL &OPFXSVAL)                                        /*BUG27792*/
 
             DCL        VAR(&PFXSVAL) TYPE(*CHAR) LEN(20)                                 /*CUP033*/
             DCL        VAR(&OPFXSVAL) TYPE(*CHAR) LEN(20)                              /*BUG27792*/
/**COPY*UPCPYSRG,UPSVALDCL*                                          */ /*             */ /*CUP033*/
             DCL        VAR(&SBSID) TYPE(*CHAR) LEN(2)                                    /*CUP033*/
             DCL        VAR(&OSBSID) TYPE(*CHAR) LEN(2)                                 /*BUG27792*/
             DCL        VAR(&FMLIB) TYPE(*CHAR) LEN(10)                                 /*BUG27792*/
             DCL        VAR(&FCTLEXIST) TYPE(*CHAR) LEN(1)                              /*BUG27792*/
             DCL        VAR(&BLANKSVAL) TYPE(*CHAR) LEN(1) VALUE('N')                     /*CUP033*/
/**********  DCL        VAR(&UPSTAT) TYPE(*CHAR) LEN(256)                              */ /*CSM003*/
/**********  DCL        VAR(&PFX) TYPE(*CHAR) LEN(2)                                   */ /*CSM003*/
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
 
/**COPY*UPCPYSRC,UPSVALCAL1*                                         */ /*             */ /*CUP033*/
 
/**Check*if*all*relevant*fields*have*been*entered*in*ICD**/ /*                         */ /*CUP033*/
/**********  IF         COND(&SBSID *EQ ' ' *OR &PTFUPG *EQ ' ') +                     */ /*CUP033*/
/**********               THEN(DO)                                                     */ /*CUP033*/
 
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
/*              GOTO       CMDLBL(CHECK)                             */      /*CUP033*/ /*BUG27962*/
             ENDDO                                                                        /*CUP033*/
 
             IF         COND(&GISVAL *EQ &OPFXSVAL) THEN(DO)                            /*BUG27792*/
                IF         COND(&GIVAL *EQ ' ') THEN(DO)                                /*BUG27792*/
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                                /*BUG27792*/
                ENDDO                                                                   /*BUG27792*/
                ELSE       CMD(DO)                                                      /*BUG27792*/
                   CHGVAR     VAR(&OSBSID) VALUE(&GIVAL)                                /*BUG27792*/
                ENDDO                                                                   /*BUG27792*/
/*              GOTO       CMDLBL(CHECK)                             */    /*BUG27792*/ /*BUG27962*/
             ENDDO                                                                      /*BUG27792*/
 
             GOTO       CMDLBL(VALIDATE)                                                  /*CUP033*/
 
 CHECK:                                                                                   /*CUP033*/
             IF         COND(&BLANKSVAL *EQ 'Y') THEN(DO)                                 /*CUP033*/
/* Set up messages for Midas Information Screen  */
                RTVMSG     MSGID(UPM0003) MSGF(UTMSGF) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
                RTVMSG     MSGID(UPM0004) MSGF(UTMSGF) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (151 50)) VALUE(&MESSAGE)
                CALL       PGM(SCC0010) PARM('SMC1195' 'ENTER' ' ')
                GOTO       CMDLBL(END)
             ENDDO
 
/**Retrieve*'new'*prefix*from*data*area*UPSTAT.**/ /*                                  */ /*CSM003*/
/**********  RTVDTAARA  DTAARA(&PTFUPG/UPSTAT) RTNVAR(&UPSTAT)                         */ /*CSM003*/
/**********  CHGVAR     VAR(&PFX) VALUE(%SST(&UPSTAT 62 2))                            */ /*CSM003*/
/**If*this*is*blank*then*this*should*mean*that*this*is*an*'XX'**/ /*                   */ /*CSM003*/
/**to*'XX'*type*migration.**************************************/ /*                   */ /*CSM003*/
/**********  IF         COND(&PFX *EQ '  ') THEN(DO)                                   */ /*CSM003*/
/**********     CHGVAR     VAR(&PFX) VALUE(&SBSID)                                     */ /*CSM003*/
/**********  ENDDO                                                                     */ /*CSM003*/
 
/* Set library list. */
/**********  CALL       PGM(UPC0014) PARM(&PFX)                                        */ /*CSM003*/
             CALL       PGM(UPC0014) PARM(&SBSID)                                         /*CSM003*/
 
/* Check for existence of SDFCTLPA in 'from' system and perform copies. */              /*BUG27792*/
             CHGVAR     VAR(&FMLIB) VALUE(&OSBSID *TCAT 'DTALIB')                       /*BUG27792*/
             CHKOBJ     OBJ(&FMLIB/SDFCTLPA) OBJTYPE(*FILE)                             /*BUG27792*/
             MONMSG     MSGID(CPF9801) EXEC(DO)                                         /*BUG27792*/
                CHGVAR     VAR(&FMLIB) VALUE(&OSBSID *TCAT 'DMLIB')                     /*BUG27792*/
                CHKOBJ     OBJ(&FMLIB/SDFCTLPA) OBJTYPE(*FILE)                          /*BUG27792*/
                MONMSG     MSGID(CPF9801) EXEC(DO)                                      /*BUG27792*/
                   CHGVAR     VAR(&FCTLEXIST) VALUE('N')                                /*BUG27792*/
                   GOTO       CMDLBL(TABLETX)                                           /*BUG27792*/
                ENDDO                                                                   /*BUG27792*/
             ENDDO                                                                      /*BUG27792*/
             CPYF       FROMFILE(&FMLIB/SDFCTLPA) TOFILE(SMFCTLPA) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)                           /*BUG27792*/
             CHGVAR     VAR(&FCTLEXIST) VALUE('Y')                                      /*BUG27792*/
 
TABLETX:                                                                                /*BUG27792*/
/* Check for existence of TABLETX in 'from' system and perform copies. */               /*BUG27792*/
             CHGVAR     VAR(&FMLIB) VALUE(&OSBSID *TCAT 'DTALIB')                       /*BUG27792*/
             CHKOBJ     OBJ(&FMLIB/TABLETX) OBJTYPE(*FILE)                              /*BUG27792*/
             MONMSG     MSGID(CPF9801) EXEC(DO)                                         /*BUG27792*/
                CHGVAR     VAR(&FMLIB) VALUE(&OSBSID *TCAT 'DMLIB')                     /*BUG27792*/
             ENDDO                                                                      /*BUG27792*/
             DLTF       FILE(QTEMP/SMTBLXPDT)                                             /*CUP003*/
             MONMSG     MSGID(CPF0000)                                                    /*CUP003*/
             CRTDUPOBJ  OBJ(SMTBLXPD) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(QTEMP) NEWOBJ(SMTBLXPDT)                                  /*CUP003*/
/**********  CPYF       FROMFILE(&FMLIB/TABLETX) TOFILE(SMTBLXPD) +                    */ /*CUP003*/
/**********               MBROPT(*REPLACE) FMTOPT(*MAP *DROP)             */ /*BUG27792*/ /*CUP003*/
             CPYF       FROMFILE(&FMLIB/TABLETX) TOFILE(SMTBLXPD) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)                                 /*CUP003*/
             CPYF       FROMFILE(TABLETX) TOFILE(SMTBLXPDT) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)                                 /*CUP003*/
 
/**********  CALL       PGM(SM1195)                                                  */ /*BUG27792*/
             OVRDBF     FILE(TBLTXT) TOFILE(SMTBLXPDT)                                    /*CUP003*/
             CALL       PGM(SM000007) PARM(&FCTLEXIST)                                  /*BUG27792*/
             DLTOVR     FILE(TBLTXT)                                                      /*CUP003*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO
             CPYF       FROMFILE(SMTBLXPDT) TOFILE(TABLETX) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)                                 /*CUP003*/
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/* Set up messages for Midas Information Screen  */
             RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('SMC1195') MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE('Check +
                          joblog for details')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(SCC0010) PARM('SMC1195' 'ENTER' ' ')
             MONMSG     MSGID(CPF0000)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
