/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas UP Shell - Copy DTALIB action files')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC2006 - Shell for copy of DTALIB action files             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CUP021             Date 04Feb11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. CUP033             Date 18Sep06              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSM005             Date 21Sep05              */
/*                      CPK018             Date 23Feb04              */
/*                      CUP024             Date 13Jun03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CPK015             Date 05Mar02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      CUP003 *CREATE     Date 01Oct99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CUP021 - Rewrite of Action File processing.                 */
/*       CUP033 - Removal of System Value /COPYs.                    */
/*       CSM005 - Changes to /COPYs.  Recompile.                     */
/*       CPK018 - MidasPlus packaging.  Remove CHKLIBLE processing.  */
/*       CUP024 - Migration of Bridge ICD to the System Values file. */
/*       CPK015 - 4.01 packaging. Add MONMSG to error processing.    */
/*       CUP003 - Create shell for existing utility.                 */
/*                                                                   */
/*********************************************************************/
/**********  PGM                                                                       */ /*CUP033*/
/**********  PGM        PARM(&PFXSVAL &BRGSVAL &DTASVAL)                    */ /*CUP033*/ /*CUP021*/
             PGM        PARM(&PFXSVAL &DTASVAL)                                           /*CUP021*/
 
             DCL        VAR(&PFXSVAL) TYPE(*CHAR) LEN(20)                                 /*CUP033*/
/**********  DCL        VAR(&BRGSVAL) TYPE(*CHAR) LEN(20)                   */ /*CUP033*/ /*CUP021*/
             DCL        VAR(&DTASVAL) TYPE(*CHAR) LEN(20)                                 /*CUP033*/
/**COPY*UPCPYSRC,UPSVALDCL*                                          */        /*CUP024*/ /*CUP033*/
             DCL        VAR(&SBSID) TYPE(*CHAR) LEN(2)                                    /*CUP033*/
/**********  DCL        VAR(&PTFUPG) TYPE(*CHAR) LEN(10)                    */ /*CUP033*/ /*CUP021*/
             DCL        VAR(&PTFDTA) TYPE(*CHAR) LEN(10)                                  /*CUP033*/
             DCL        VAR(&BLANKSVAL) TYPE(*CHAR) LEN(1) VALUE('N')                     /*CUP033*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(1)
/**********  DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)                     */ /*CPK018*/ /*CUP021*/
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
/************RCVF                                                                      */ /*CUP024*/
/**COPY*UPCPYSRC,UPSVALCAL1*                                         */ /*  */ /*CUP024*/ /*CUP033*/
 
/**Check*if*all*relevant*fields*have*been*entered*in*ICD**/ /*                         */ /*CUP033*/
/**********  IF         COND(&PTFDTA *EQ ' ' *OR &SBSID *EQ ' ') +                     */ /*CPK018*/
/**********               THEN(DO)                                                     */ /*CPK018*/
/**********  IF         COND(&PTFDTA *EQ ' ' *OR &PTFUPG *EQ ' ' *OR +                 */ /*CUP033*/
/**********               &SBSID *EQ ' ') THEN(DO)                          */ /*CPK018*/ /*CUP033*/
 
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
 
/**********  IF         COND(&GISVAL *EQ &BRGSVAL) THEN(DO)                 */ /*CUP033*/ /*CUP021*/
/**********     IF         COND(&GIVAL *EQ ' ') THEN(DO)                    */ /*CUP033*/ /*CUP021*/
/**********        CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                    */ /*CUP033*/ /*CUP021*/
/**********     ENDDO                                                       */ /*CUP033*/ /*CUP021*/
/**********     ELSE       CMD(DO)                                          */ /*CUP033*/ /*CUP021*/
/**********        CHGVAR     VAR(&PTFUPG) VALUE(&GIVAL)                    */ /*CUP033*/ /*CUP021*/
/**********     ENDDO                                                       */ /*CUP033*/ /*CUP021*/
/**********  ENDDO                                                          */ /*CUP033*/ /*CUP021*/
 
             IF         COND(&GISVAL *EQ &DTASVAL) THEN(DO)                               /*CUP033*/
                IF         COND(&GIVAL *EQ ' ') THEN(DO)                                  /*CUP033*/
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                                  /*CUP033*/
                ENDDO                                                                     /*CUP033*/
                ELSE       CMD(DO)                                                        /*CUP033*/
                   CHGVAR     VAR(&PTFDTA) VALUE(&GIVAL)                                  /*CUP033*/
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
                CALL       PGM(SCC0010) PARM('UPC2006' 'ENTER' ' ')
                GOTO       CMDLBL(END)
             ENDDO
 
/* Set up library list */
             CALL       PGM(UPC0014) PARM(&SBSID)
/**CHKLIBLE:                                                                           */ /*CPK018*/
/**********  CHGVAR     VAR(&RETURN) VALUE(' ')                                        */ /*CPK018*/
/**********  CHKLIBLE   LIBS(&PTFUPG) RETURN(&RETURN)                                  */ /*CPK018*/
/**********  IF         COND(&RETURN *EQ 'F') THEN(DO)                                 */ /*CPK018*/
/**********     EDTLIBL                                                                */ /*CPK018*/
/**********     GOTO CHKLIBLE                                                          */ /*CPK018*/
/**********  ENDDO                                                                     */ /*CPK018*/
 
/**********  RMVLIBLE   LIB(&PTFUPG)                                                   */ /*CUP021*/
/**********  MONMSG     MSGID(CPF0000)                                                 */ /*CUP021*/
/**********  ADDLIBLE   LIB(&PTFUPG) POSITION(*FIRST)                                  */ /*CUP021*/
 
/**********  CHGVAR     VAR(&TOLIB) VALUE(&SBSID *TCAT 'DPLIB')             */ /*CPK018*/ /*CUP021*/
 
/**********  OVRDBF     FILE(UPGPACTFPD) TOFILE(UPACTFPD) +                            */ /*CUP021*/
/**********               OVRSCOPE(*JOB)                                    */ /*CPK018*/ /*CUP021*/
/**********  CALL       PGM(UPC0785) PARM(&PTFDTA &SBSID &RETURN)                      */ /*CPK018*/
/**********  CALL       PGM(UPC0785) PARM(&PTFDTA &TOLIB &RETURN)           */ /*CPK018*/ /*CUP021*/
/**********  DLTOVR     FILE(UPACTFPD) LVL(*JOB)                            */ /*CPK018*/ /*CUP021*/
/**********  MONMSG     MSGID(CPF0000)                                      */ /*CPK018*/ /*CUP021*/
/**********  IF         COND(&RETURN *EQ 'F') THEN(DO)                      */ /*CPK018*/ /*CUP021*/
/**********     GOTO       CMDLBL(ABNOR)                                    */ /*CPK018*/ /*CUP021*/
/**********  ENDDO                                                          */ /*CPK018*/ /*CUP021*/
 
/* Copy delivered Action File to system copy. */                                          /*CUP021*/
             CPYF       FROMFILE(&PTFDTA/UPAFCPPD) TOFILE(UPAFDVPD) +
                          MBROPT(*REPLACE)                                                /*CUP021*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)                           /*CUP021*/
                CLRPFM     FILE(UPAFDVPD)                                                 /*CUP021*/
             ENDDO                                                                        /*CUP021*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(DO)                           /*CUP021*/
                CLRPFM     FILE(UPAFDVPD)                                                 /*CUP021*/
             ENDDO                                                                        /*CUP021*/
 
             GOTO       CMDLBL(END)
 ABNOR:
/* Set up messages for Midas Information Screen  */
             RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('UPC2006') MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000)                                                    /*CPK015*/
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE('Check +
                          joblog for details')
             MONMSG     MSGID(CPF0000)                                                    /*CPK015*/
             CALL       PGM(SCC0010) PARM('UPC2006' 'JOBLOG' 'Y')
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*CPK015*/
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
