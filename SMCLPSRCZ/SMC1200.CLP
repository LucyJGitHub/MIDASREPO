/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SM Restore PTF source')                         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Implementation module                               */
/*                                                                   */
/*       SMC1200 - Restore PTF source                                */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD054605           Date 17Oct19              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/*                      CSC043             Date 18Jun10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      BUG27240           Date 12Mar10              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      CUP033             Date 18Sep06              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSM005             Date 21Sep05              */
/*                      CUP016  *CREATE    Date 01Apr03              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD054605 - Deliverable Data Split for SDSVALPD              */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC043 - MidasPlus IASP Enablement                          */
/*       BUG27240- Applied CPK029 file locking fix                   */
/*       CPK029 - Stop lock on file.                                 */
/*       CUP033 - Removal of System Value /COPYs                     */
/*       CSM005 - Changes to /COPYs.  Recompile.                     */
/*       CUP016 - Bring Implementation software into core.           */
/*                                                                   */
/*********************************************************************/
/**********  PGM                                                                       */ /*CUP033*/
/**********  PGM        PARM(&BRGSVAL)  */                                         /*CUP033 CSC043*/
             PGM        PARM(&BRGSVAL &IASPYNSVAL &IASPSVAL)                              /*CSC043*/

             DCL        VAR(&BRGSVAL) TYPE(*CHAR) LEN(20)                                 /*CUP033*/
             DCL        VAR(&IASPYNSVAL) TYPE(*CHAR) LEN(20)                              /*CSC043*/
             DCL        VAR(&IASPSVAL) TYPE(*CHAR) LEN(20)                                /*CSC043*/
             DCL        VAR(&IASP_YN) TYPE(*CHAR) LEN(1)                                  /*CSC043*/
             DCL        VAR(&IASP) TYPE(*CHAR) LEN(10)                                    /*CSC043*/
/**COPY*UPCPYSRC,UPSVALDCL*                                          */ /*             */ /*CUP033*/
             DCL        VAR(&PTFUPG) TYPE(*CHAR) LEN(10)                                  /*CUP033*/
             DCL        VAR(&BLANKSVAL) TYPE(*CHAR) LEN(1) VALUE('N')                     /*CUP033*/
             DCL        VAR(&DEVD) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
/* Parameters for QCLSCAN. */
             DCL        VAR(&STRLEN) TYPE(*DEC) LEN(3 0) VALUE(10)
             DCL        VAR(&STRPOS) TYPE(*DEC) LEN(3 0) VALUE(1)
             DCL        VAR(&PATTERN) TYPE(*CHAR) LEN(3) VALUE('IMP')
             DCL        VAR(&PATLEN) TYPE(*DEC) LEN(2) VALUE(3)
             DCL        VAR(&TRANSLATE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TRIM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WILD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RESULT) TYPE(*DEC) LEN(3)

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')

/**********  DCLF       FILE(UPSVALJ0)  */                                         /*CUP033 CSC043*/
/**********  DCLF       FILE(UPSVALJ0) OPNID(Z) */                             /*CSC043* *MD054605*/
             DCLF       FILE(UPSVALJ0) OPNID(Z) ALWNULL(*YES)                           /*MD054605*/
/**********  DCLF       FILE(UPGSVALJ0) OPNID(G) */                            /*CSC043* *MD054605*/
             DCLF       FILE(UPGSVALJ0) OPNID(G) ALWNULL(*YES)                          /*MD054605*/

/* Global monitor message. */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)

/* Create Midas Info Screen data area in QTEMP */
             DLTDTAARA  DTAARA(QTEMP/MIDASMSG)
             MONMSG MSGID(CPF2105)
             CRTDTAARA  DTAARA(QTEMP/MIDASMSG) TYPE(*CHAR) LEN(800) +
                          TEXT('Midas Info Screen Data Area')

/**COPY*UPCPYSRC,UPSVALCAL1*                                         */ /*             */ /*CUP033*/
/**********  IF         COND(&PTFUPG *EQ ' ') THEN(DO)                                 */ /*CUP033*/

VALIDATE:                                                                                 /*CUP033*/
/**********  RCVF  */                                                              /*CUP033 CSC043*/
             RCVF       OPNID(Z)                                                          /*CSC043*/
             MONMSG     MSGID(CPF0864) EXEC(DO)                                           /*CUP033*/
                GOTO       CMDLBL(CHECK)                                                  /*CUP033*/
             ENDDO                                                                        /*CUP033*/

/**********  IF         COND(&GISVAL *EQ &BRGSVAL) THEN(DO)  */                    /*CUP033 CSC043*/
/**********     IF         COND(&GIVAL *EQ ' ') THEN(DO)     */                    /*CUP033 CSC043*/
             IF         COND(&Z_GISVAL *EQ &BRGSVAL) THEN(DO)                             /*CSC043*/
                IF         COND(&Z_GIVAL *EQ ' ') THEN(DO)                                /*CSC043*/
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                                  /*CUP033*/
                ENDDO                                                                     /*CUP033*/
                ELSE       CMD(DO)                                                        /*CUP033*/
/**********        CHGVAR     VAR(&PTFUPG) VALUE(&GIVAL)  */                       /*CUP033 CSC043*/
                   CHGVAR     VAR(&PTFUPG) VALUE(&Z_GIVAL)                                /*CSC043*/
                ENDDO                                                                     /*CUP033*/
/**********     GOTO       CMDLBL(CHECK)                                    */ /*CUP033*/ /*CPK029*/
             ENDDO                                                                        /*CUP033*/

             GOTO       CMDLBL(VALIDATE)                                                  /*CUP033*/

 CHECK:                                                                                   /*CUP033*/
             IF         COND(&BLANKSVAL *EQ 'Y') THEN(DO)                                 /*CUP033*/
/* Set up messages for Midas Information Screen  */
                RTVMSG     MSGID(UPM0003) MSGF(UTMSGF) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
                RTVMSG     MSGID(UPM0004) MSGF(UTMSGF) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (151 50)) VALUE(&MESSAGE)
                CALL       PGM(SCC0010) PARM('SMC1200' 'ENTER' ' ')
                GOTO       CMDLBL(ENDPGM)
             ENDDO

VALIDATE2:                                                                                /*CSC043*/
             RCVF       OPNID(G)                                                          /*CSC043*/
             MONMSG     MSGID(CPF0864) EXEC(DO)                                           /*CSC043*/
                GOTO       CMDLBL(CHECK2)                                                 /*CSC043*/
             ENDDO                                                                        /*CSC043*/
                                                                                          /*CSC043*/
             IF         COND(&G_GISVAL *EQ &IASPYNSVAL) THEN(DO)                          /*CSC043*/
                IF         COND(&G_GIVAL *EQ ' ') THEN(DO)                                /*CSC043*/
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                                  /*CSC043*/
                ENDDO                                                                     /*CSC043*/
                ELSE       CMD(DO)                                                        /*CSC043*/
                   CHGVAR     VAR(&IASP_YN) VALUE(&G_GIVAL)                               /*CSC043*/
                ENDDO                                                                     /*CSC043*/
             ENDDO                                                                        /*CSC043*/
                                                                                          /*CSC043*/
             IF         COND(&G_GISVAL *EQ &IASPSVAL) THEN(DO)                            /*CSC043*/
             IF         COND((&G_GIVAL *EQ ' ') *AND (&IASP_YN *EQ +
                          'Y')) THEN(DO)                                                  /*CSC043*/
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                                  /*CSC043*/
                ENDDO                                                                     /*CSC043*/
                ELSE       CMD(DO)                                                        /*CSC043*/
                   CHGVAR     VAR(&IASP) VALUE(&G_GIVAL)                                  /*CSC043*/
                ENDDO                                                                     /*CSC043*/
             ENDDO                                                                        /*CSC043*/
                                                                                          /*CSC043*/
             GOTO       CMDLBL(VALIDATE2)                                                 /*CSC043*/
                                                                                          /*CSC043*/
 CHECK2:                                                                                  /*CSC043*/
             IF         COND(&BLANKSVAL *EQ 'Y') THEN(DO)                                 /*CSC043*/
/*                                                                                        /*CSC043*/
/** Set up messages for Midas Information Screen */                                       /*CSC043*/
/*                                                                                        /*CSC043*/
                RTVMSG     MSGID(UPM0003) MSGF(UTMSGF) MSG(&MESSAGE)                      /*CSC043*/
                CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)                      /*CSC043*/
                RTVMSG     MSGID(UPM0004) MSGF(UTMSGF) MSG(&MESSAGE)                      /*CSC043*/
                CHGDTAARA  DTAARA(MIDASMSG (151 50)) VALUE(&MESSAGE)                      /*CSC043*/
                CALL       PGM(SCC0010) PARM('SMC1200' 'ENTER' ' ')                       /*CSC043*/
                GOTO       CMDLBL(ENDPGM)                                                 /*CSC043*/
             ENDDO                                                                        /*CSC043*/
                                                                                          /*CSC043*/
DEVICENAME:
             ?          DEVICENAME
             MONMSG     MSGID(CPF6801) EXEC(DO)
                GOTO       CMDLBL(ENDPGM)
             ENDDO
             RTVDTAARA  DTAARA(QTEMP/DEVD) RTNVAR(&DEVD)

/* Check device is valid. */
             CHKOBJ     OBJ(&DEVD) OBJTYPE(*DEVD)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE('Device' +
                             *BCAT &DEVD *BCAT 'does not exist.')
                CALL       PGM(SCC0010) PARM('SMC1200' 'ENTER' ' ')
                GOTO       CMDLBL(DEVICENAME)
             ENDDO

/* Attempt to build source name based on the implementation library. */
             CALL       PGM(QCLSCAN) PARM(&PTFUPG &STRLEN &STRPOS +
                          &PATTERN &PATLEN &TRANSLATE &TRIM &WILD +
                          &RESULT)
/* Depending on whether the name was found then change restore prompt. */
             IF         COND(&RESULT *GT 0) THEN(DO)
                CHGVAR     VAR(%SST(&PTFUPG &RESULT 3)) VALUE('SRC')
/* Update the ICD. */
                CALL       PGM(SM1200) PARM(&PTFUPG)
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   GOTO       CMDLBL(ABNOR)
                ENDDO
             ENDDO
             ELSE       CMD(DO)
                CHGVAR     VAR(&PTFUPG) VALUE('SRCLIB')
             ENDDO

/* Prompt for restore of source library. */
/*                                                                                        /*CSC043*/
/** If IASP environment */                                                                /*CSC043*/
/*                                                                                        /*CSC043*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC043*/
             RSTLIB     ??SAVLIB(&PTFUPG) ?*DEV(&DEVD) +
                          ??RSTLIB(&PTFUPG) RSTASPDEV(&IASP) +
                          OUTPUT(*PRINT)                                                  /*CSC043*/
             MONMSG     MSGID(CPF6801) EXEC(DO)                                           /*CSC043*/
                GOTO       CMDLBL(ENDPGM)                                                 /*CSC043*/
             ENDDO                                                                        /*CSC043*/
             ENDDO                                                                        /*CSC043*/
             ELSE       CMD(DO)                                                           /*CSC043*/
             RSTLIB     ??SAVLIB(&PTFUPG) ?*DEV(&DEVD) ??RSTLIB(&PTFUPG) +
                          OUTPUT(*PRINT)
             MONMSG     MSGID(CPF6801) EXEC(DO)
                GOTO       CMDLBL(ENDPGM)
             ENDDO
             ENDDO                                                                        /*CSC043*/

             GOTO       CMDLBL(ENDPGM)

/* Abnormal program end. */
ABNOR:
             CHGVAR     VAR(&MEM) VALUE('SMC1200 - Job has Ended +
                          Abnormally')
             MONMSG     MSGID(CPF0000)
             SNDPGMMSG  MSG(&MEM) TOMSGQ(SETUP)
             MONMSG     MSGID(CPF0000)
/* Set up messages for Midas Information Screen  */
             RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('SMC1200') MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE('Check +
                          joblog for details')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(SCC0010) PARM('SMC1200' 'JOBLOG' 'Y')
             MONMSG     MSGID(CPF0000)
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
