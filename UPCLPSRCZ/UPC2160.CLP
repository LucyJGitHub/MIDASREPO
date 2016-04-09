/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Shell for JOBD library list changes')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC2160 - Shell for job description library list changes    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Last Amend No. BUG27240           Date 12Mar10              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. CUP033             Date 18Sep06              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CPK023             Date 06Dec05              */
/*                      CSM005             Date 21Sep05              */
/*                      CUP024             Date 13Jun03              */
/*                      CSC017             Date 25Feb03              */
/* Midas Release 4.01.03 --------------------------------------------*/
/*                      CUP016             Date 02Dec02              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CPK015             Date 05Mar02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CUP001 *CREATE     Date 11Sep98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG27240- Applied CPK029 file locking fix                   */
/*       CPK029 - Stop lock on file.                                 */
/*       CUP033 - Removal of System Value /COPYs                     */
/*       CPK023 - No specific library reference for UPSTAT.          */
/*       CSM005 - Changes to /COPYs.  Recompile.                     */
/*       CUP024 - Migration of Bridge ICD to the System Values file. */
/*       CSC017 - Changes for 250 library list.                      */
/*       CUP016 - Add implementation software to core.               */
/*       CPK015 - 4.01 packaging. Add MONMSG to error processing.    */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/*********************************************************************/
/************PGM                                                                       */ /*CUP016*/
/**********  PGM        PARM(&MODE)                                         */ /*CUP016*/ /*CUP033*/
             PGM        PARM(&MODE &PFXSVAL)                                              /*CUP033*/
 
             DCL        VAR(&PFXSVAL) TYPE(*CHAR) LEN(20)                                 /*CUP033*/
/**COPY*UPCPYSRC,UPSVALDCL*                                          */ /*  */ /*CUP024*/ /*CUP033*/
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(4)                                     /*CUP016*/
             DCL        VAR(&SBSID) TYPE(*CHAR) LEN(2)                                    /*CUP033*/
             DCL        VAR(&BLANKSVAL) TYPE(*CHAR) LEN(1) VALUE('N')                     /*CUP033*/
 
             DCL        VAR(&LIBGRP) TYPE(*CHAR) LEN(2)                                   /*CUP016*/
/**********  DCL        VAR(&UPSTAT) TYPE(*CHAR) LEN(256)                   */ /*CUP016*/ /*CUP033*/
             DCL        VAR(&SC24X7) TYPE(*CHAR) LEN(256)                                 /*CSC017*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
/**********  DCL        VAR(&RETURN) TYPE(*CHAR) LEN(1)                                */ /*CUP033*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/************DCLF       FILE(UPUICDPD)                                                 */ /*CUP024*/
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
 
/**********  IF         COND(&MODE *EQ '*UPG') THEN(DO)                     */ /*CUP016*/ /*CPK023*/
             IF         COND(&MODE *EQ '*UPG' *OR &MODE *EQ '*IMP') +
                          THEN(DO)                                                        /*CPK023*/
/************   RCVF                                                                   */ /*CUP024*/
/**COPY*UPCPYSRC,UPSVALCAL1*                                         */ /*  */ /*CUP024*/ /*CUP033*/
/**Check*if*all*relevant*fields*have*been*entered*in*ICD**/ /*                         */ /*CUP033*/
/************IF         COND(&PTFUPG *EQ ' ' *OR &SBSID *EQ ' ') +                     */ /*CUP016*/
/************             THEN(DO)                                                     */ /*CUP016*/
/**********     IF         COND(&SBSID *EQ ' ') THEN(DO)                    */ /*CUP016*/ /*CUP033*/
 
VALIDATE:                                                                                 /*CUP033*/
                RCVF                                                                      /*CUP033*/
                MONMSG     MSGID(CPF0864) EXEC(DO)                                        /*CUP033*/
                   GOTO       CMDLBL(CHECK)                                               /*CUP033*/
                ENDDO                                                                     /*CUP033*/
 
                IF         COND(&GISVAL *EQ &PFXSVAL) THEN(DO)                            /*CUP033*/
                   IF         COND(&GIVAL *EQ ' ') THEN(DO)                               /*CUP033*/
                      CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                               /*CUP033*/
                   ENDDO                                                                  /*CUP033*/
                   ELSE       CMD(DO)                                                     /*CUP033*/
                      CHGVAR     VAR(&SBSID) VALUE(&GIVAL)                                /*CUP033*/
                   ENDDO                                                                  /*CUP033*/
/**********        GOTO       CMDLBL(CHECK)                                 */ /*CUP033*/ /*CPK029*/
                ENDDO                                                                     /*CUP033*/
 
                GOTO       CMDLBL(VALIDATE)                                               /*CUP033*/
 
 CHECK:                                                                                   /*CUP033*/
                IF         COND(&BLANKSVAL *EQ 'Y') THEN(DO)                              /*CUP033*/
/* Set up messages for Midas Information Screen  */
                   RTVMSG     MSGID(UPM0003) MSGF(UTMSGF) MSG(&MESSAGE)
                   CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
                   RTVMSG     MSGID(UPM0004) MSGF(UTMSGF) MSG(&MESSAGE)
                   CHGDTAARA  DTAARA(MIDASMSG (151 50)) VALUE(&MESSAGE)
                   CALL       PGM(SCC0010) PARM('UPC2160' 'ENTER' ' ')
                   GOTO       CMDLBL(END)
                ENDDO
                CHGVAR     VAR(&LIBGRP) VALUE(&SBSID)                                     /*CUP016*/
             ENDDO                                                                        /*CUP016*/
 
/* Set up library list. */                                                                /*CUP033*/
             CALL       PGM(UPC0014) PARM(&SBSID)                                         /*CUP033*/
 
/**********  IF         COND(&MODE *EQ '*IMP') THEN(DO)                     */ /*CUP016*/ /*CPK023*/
/**********     RTVDTAARA  DTAARA(UPSTAT) RTNVAR(&UPSTAT)                              */ /*CPK023*/
/**********     CHGVAR     VAR(&LIBGRP) VALUE(%SST(&UPSTAT 62 2))                      */ /*CPK023*/
/**********     IF         COND(&LIBGRP *EQ '  ') THEN(DO)                             */ /*CPK023*/
/************      RCVF                                                                */ /*CUP024*/
/**COPY*UPCPYSRC,UPSVALCAL1*                                         */ /*  */ /*CUP024*/ /*CPK023*/
/**********        IF         COND(&SBSID *EQ ' ') THEN(DO)                            */ /*CPK023*/
/**********           RTVMSG     MSGID(UPM0003) MSGF(UTMSGF) MSG(&MESSAGE)             */ /*CPK023*/
/**********           CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)             */ /*CPK023*/
/**********           RTVMSG     MSGID(UPM0004) MSGF(UTMSGF) MSG(&MESSAGE)             */ /*CPK023*/
/**********           CHGDTAARA  DTAARA(MIDASMSG (151 50)) VALUE(&MESSAGE)             */ /*CPK023*/
/**********           CALL       PGM(SCC0010) PARM('UPC2160' 'ENTER' ' ')              */ /*CPK023*/
/**********           GOTO       CMDLBL(END)                                           */ /*CPK023*/
/**********        ENDDO                                                               */ /*CPK023*/
/**********        CHGVAR     VAR(&LIBGRP) VALUE(&SBSID)                               */ /*CPK023*/
/**********     ENDDO                                                                  */ /*CPK023*/
/**********  ENDDO                                                          */ /*CUP016*/ /*CPK023*/
 
             IF         COND(&MODE *EQ '*247') THEN(DO)                                   /*CUP016*/
/************   RTVDTAARA  DTAARA(UPSTAT) RTNVAR(&UPSTAT)                   */ /*CUP016*/ /*CSC017*/
/************   CHGVAR     VAR(&LIBGRP) VALUE(%SST(&UPSTAT 64 2))           */ /*CUP016*/ /*CSC017*/
                RTVDTAARA  DTAARA(SC24X7) RTNVAR(&SC24X7)                                 /*CSC017*/
                CHGVAR     VAR(&LIBGRP) VALUE(%SST(&SC24X7 3 2))                          /*CSC017*/
                IF         COND(&LIBGRP *EQ ' ') THEN(DO)                                 /*CUP016*/
                   GOTO       CMDLBL(ABNOR)                                               /*CUP016*/
                ENDDO                                                                     /*CUP016*/
             ENDDO                                                                        /*CUP016*/
 
/*CHKLIBLE:**                                                                          */ /*CUP016*/
/************CHGVAR     VAR(&RETURN) VALUE(' ')                                        */ /*CUP016*/
/************CHKLIBLE   LIBS(&PTFUPG) RETURN(&RETURN)                                  */ /*CUP016*/
/************IF         COND(&RETURN *EQ 'F') THEN(DO)                                 */ /*CUP016*/
/************   EDTLIBL                                                                */ /*CUP016*/
/************   GOTO CHKLIBLE                                                          */ /*CUP016*/
/************ENDDO                                                                     */ /*CUP016*/
/************                                                                          */ /*CUP016*/
/************RMVLIBLE   LIB(&PTFUPG)                                                   */ /*CUP016*/
/************MONMSG     MSGID(CPF0000)                                                 */ /*CUP016*/
/************ADDLIBLE   LIB(&PTFUPG) POSITION(*FIRST)                                  */ /*CUP016*/
 
/************CALL       PGM(UPC0280) PARM(&PTFUPG &SBSID &RETURN)                      */ /*CUP016*/
/************CALL       PGM(UPC0280) PARM(&LIBGRP &RETURN)                  */ /*CUP016*/ /*CSC017*/
/*If*the*program*ended*abnormally*then*display*general*message**/ /*                   */ /*CSC017*/
/************IF         COND(&RETURN *NE ' ') THEN(DO)                                 */ /*CSC017*/
/************   RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +                               */ /*CSC017*/
/************             MSGDTA('UPC0280') MSG(&MESSAGE)                              */ /*CSC017*/
/************   CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)                   */ /*CSC017*/
/************   CALL       PGM(SCC0010) PARM('UPC0280' 'JOBLOG' 'Y')                   */ /*CSC017*/
/************   GOTO       CMDLBL(END)                                                 */ /*CSC017*/
/************ENDDO                                                                     */ /*CSC017*/
 
/* Prompt for change according to mode. */                                                /*CSC017*/
             ?          CHGJOBDLBL ?*SYSPREFIX(&LIBGRP) ??MODE(*N)                        /*CSC017*/
             MONMSG     MSGID(CPF6801)                                                    /*CSC017*/
 
             GOTO       CMDLBL(END)
 ABNOR:
/* Set up messages for Midas Information Screen  */
 
             RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('UPC2160') MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000)                                                    /*CPK015*/
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE('Check +
                          joblog for details')
             MONMSG     MSGID(CPF0000)                                                    /*CPK015*/
             CALL       PGM(SCC0010) PARM('UPC2160' 'JOBLOG' 'Y')
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*CPK015*/
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
