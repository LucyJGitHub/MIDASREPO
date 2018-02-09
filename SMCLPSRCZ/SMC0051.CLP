/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SM Run SFPRECHECK')                             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Implementation module                               */
/*                                                                   */
/*       SMC0051 - Run SFPRECHECK                                    */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR790665           Date 17Jun11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CUP033             Date 30Jun06              */
/*                      CSM005             Date 21Sep05              */
/*                      CSM003             Date 30May05              */
/*                      CPK018             Date 23Feb04              */
/*                      CUP016 *CREATE     Date 01Apr03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR790665 - Handle more than one program library.            */
/*       CUP033 - Removal of System Value /COPYs.                    */
/*       CSM005 - Changes to /COPYs.  Recompile.                     */
/*       CSM003 - Use system value rather than UPSTAT.               */
/*       CPK018 - MidasPlus packaging.  Remove CHKLIBLE processing.  */
/*       CUP016 - Add implementation software to core.               */
/*                                                                   */
/*********************************************************************/
/**********  PGM                                                                       */ /*CUP033*/
             PGM        PARM(&OPFXSVAL &CORLIBSVAL)                                       /*CUP033*/
 
             DCL        VAR(&OPFXSVAL) TYPE(*CHAR) LEN(20)                                /*CUP033*/
             DCL        VAR(&CORLIBSVAL) TYPE(*CHAR) LEN(20)                              /*CUP033*/
/**COPY*UPCPYSRC,UPSVALDCL*                                          */ /*             */ /*CUP033*/
             DCL        VAR(&OLDSBSID) TYPE(*CHAR) LEN(2)                                 /*CUP033*/
             DCL        VAR(&LIBLIST) TYPE(*CHAR) LEN(200)                              /*AR790665*/
             DCL        VAR(&LIBPOS) TYPE(*DEC) LEN(3 0) VALUE(1)                       /*AR790665*/
             DCL        VAR(&CORLIB) TYPE(*CHAR) LEN(10)                                  /*CUP033*/
             DCL        VAR(&BLANKSVAL) TYPE(*CHAR) LEN(1) VALUE('N')                     /*CUP033*/
             DCL        VAR(&FAIL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
/**********  DCL        VAR(&PGMLIB) TYPE(*CHAR) LEN(10)                               */ /*CSM003*/
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
/**COPY*UPCPYSRC,UPSVALCAL3*                                         */ /*  */ /*CSM003*/ /*CUP033*/
 
/**Check*if*all*relevant*fields*have*been*entered*in*ICD**/ /*                         */ /*CSM003*/
/**********  IF         COND(&SBSID *EQ ' ' *OR &PTFUPG *EQ ' ') +                     */ /*CSM003*/
/**********               THEN(DO)                                                     */ /*CSM003*/
/**********  IF         COND(&OLDSBSID *EQ ' ' *OR &CORLIB *EQ ' ') +                  */ /*CSM003*/
/**********               THEN(DO)                                          */ /*CSM003*/ /*CSM003*/
/**Set*up*messages*fo* Midas*Information*Screen***/ /*                                 */ /*CSM003*/
 
VALIDATE:                                                                                 /*CUP033*/
             RCVF                                                                         /*CUP033*/
             MONMSG     MSGID(CPF0864) EXEC(DO)                                           /*CUP033*/
                GOTO       CMDLBL(CHECK)                                                  /*CUP033*/
             ENDDO                                                                        /*CUP033*/
 
             IF         COND(&GISVAL *EQ &OPFXSVAL) THEN(DO)                              /*CUP033*/
                IF         COND(&GIVAL *EQ ' ') THEN(DO)                                  /*CUP033*/
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                                  /*CUP033*/
                ENDDO                                                                     /*CUP033*/
                ELSE       CMD(DO)                                                        /*CUP033*/
                   CHGVAR     VAR(&OLDSBSID) VALUE(&GIVAL)                                /*CUP033*/
                ENDDO                                                                     /*CUP033*/
             ENDDO                                                                        /*CUP033*/
 
             IF         COND(&GISVAL *EQ &CORLIBSVAL) THEN(DO)                            /*CUP033*/
                IF         COND(&GIVAL *EQ ' ') THEN(DO)                                  /*CUP033*/
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                                  /*CUP033*/
                ENDDO                                                                     /*CUP033*/
                ELSE       CMD(DO)                                                        /*CUP033*/
/**********        CHGVAR     VAR(&CORLIB) VALUE(&GIVAL)                  */ /*CUP033*/ /*AR790665*/
                   CHGVAR     VAR(&LIBLIST) VALUE(&GIVAL)                               /*AR790665*/
                ENDDO                                                                     /*CUP033*/
             ENDDO                                                                        /*CUP033*/
 
             GOTO       CMDLBL(VALIDATE)                                                  /*CUP033*/
 
 CHECK:                                                                                   /*CUP033*/
             IF         COND(&BLANKSVAL *EQ 'Y') THEN(DO)                                 /*CUP033*/
                RTVMSG     MSGID(UPM0003) MSGF(UTMSGF) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
                RTVMSG     MSGID(UPM0004) MSGF(UTMSGF) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (151 50)) VALUE(&MESSAGE)
                CALL       PGM(SCC0010) PARM('SMC0051' 'ENTER' ' ')
                GOTO       CMDLBL(END)
             ENDDO
 
/* Set up library list */
/**********  CALL       PGM(UPC0014) PARM(&SBSID)                                      */ /*CSM003*/
             CALL       PGM(UPC0014) PARM(&OLDSBSID)                                      /*CSM003*/
 
/**Retrieve*name*of*program*library*from*data*area*UPSTAT.**/ /*                       */ /*CSM003*/
/**********  RTVDTAARA  DTAARA(UPSTAT (80 10)) RTNVAR(&PGMLIB)                         */ /*CSM003*/
/**CHKLIBLE:***                                                                        */ /*CPK018*/
/**********  CHGVAR     VAR(&FAIL) VALUE(' ')                                          */ /*CPK018*/
/**********  CHKLIBLE   LIBS(SFPRECHECK &PGMLIB) RETURN(&FAIL)                         */ /*CPK018*/
/**********  IF         COND(&FAIL *EQ 'F') THEN(DO)                                   */ /*CPK018*/
/**********     EDTLIBL                                                                */ /*CPK018*/
/**********     GOTO       CMDLBL(CHKLIBLE)                                            */ /*CPK018*/
/**********  ENDDO                                                                     */ /*CPK018*/
/**********  RMVLIBLE   LIB(&PGMLIB)                                                   */ /*CSM003*/
                                                                                        /*AR790665*/
/* Loop through the system value to find all program libraries. */                      /*AR790665*/
RSTLIB:                                                                                 /*AR790665*/
             IF         COND(%SST(&LIBLIST &LIBPOS 10) *NE ' ') +
                          THEN(DO)                                                      /*AR790665*/
             CHGVAR     VAR(&CORLIB) VALUE(%SST(&LIBLIST &LIBPOS 10))                   /*AR790665*/
             RMVLIBLE   LIB(&CORLIB)                                                      /*CSM003*/
             MONMSG     MSGID(CPF0000)
/**********  ADDLIBLE   LIB(&PGMLIB)                                                   */ /*CSM003*/
             ADDLIBLE   LIB(&CORLIB)                                                      /*CSM003*/
             CHGVAR     VAR(&LIBPOS) VALUE(&LIBPOS + 10)                                /*AR790665*/
             GOTO       CMDLBL(RSTLIB)                                                  /*AR790665*/
             ENDDO                                                                      /*AR790665*/
             RMVLIBLE   LIB(SFPRECHECK)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(SFPRECHECK)
 
             CALL       PGM(SFPRECHECK)
 
             GOTO       CMDLBL(END)
 ABNOR:
/* Set up messages for Midas Information Screen  */
             RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('SMC0051') MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE('Check +
                          joblog for details')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(SCC0010) PARM('SMC0051' 'ENTER' ' ')
             MONMSG     MSGID(CPF0000)
 
END:
/**********  RMVLIBLE   LIB(&PGMLIB)                                                   */ /*CSM003*/
             RMVLIBLE   LIB(&CORLIB)                                                      /*CSM003*/
             MONMSG     MSGID(CPF0000)
             RMVLIBLE   LIB(SFPRECHECK)
             MONMSG     MSGID(CPF0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
