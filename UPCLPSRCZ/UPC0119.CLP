/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Change subsystem routing entries - shell')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Bridge                                              */
/*                                                                   */
/*       UPC0119 - Change subsystem routing entries - shell          */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD054605           Date 17Oct19              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      BUG27240           Date 12Mar10              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      CUP033             Date 18Sep06              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CPK023             Date 06Dec05              */
/*                      CSM005             Date 21Sep05              */
/*                      CUP024             Date 13Jun03              */
/*                      CPK016             Date 25Feb03              */
/* Midas Release 4.01.03 --------------------------------------------*/
/*                      CUP016 *CREATE     Date 02Dec02              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD054605 - Deliverable Data Split for SDSVALPD              */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG27240- Applied CPK029 file locking fix                   */
/*       CPK029 - Stop lock on file.                                 */
/*       CUP033 - Removal of System Value /COPYs.                    */
/*       CPK023 - No specific library reference for UPSTAT.          */
/*       CSM005 - Changes to /COPYs.  Recompile.                     */
/*       CUP024 - Migration of Bridge ICD to the System Values file. */
/*       CPK016 - Release 5 packaging.                               */
/*       CUP016 - Add implementation software to core.               */
/*                                                                   */
/*********************************************************************/
/**********  PGM        PARM(&MODE)                                                    */ /*CUP033*/
             PGM        PARM(&MODE &PFXSVAL)                                              /*CUP033*/

             DCL        VAR(&PFXSVAL) TYPE(*CHAR) LEN(20)                                 /*CUP033*/
/**COPY*UPCPYSRC,UPSVALDCL*                                          */ /*  */ /*CUP024*/ /*CUP033*/
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&SBSID) TYPE(*CHAR) LEN(2)                                    /*CUP033*/
             DCL        VAR(&BLANKSVAL) TYPE(*CHAR) LEN(1) VALUE('N')                     /*CUP033*/

             DCL        VAR(&LIBGRP) TYPE(*CHAR) LEN(2)
/**********  DCL        VAR(&UPSTAT) TYPE(*CHAR) LEN(256)                              */ /*CUP033*/
             DCL        VAR(&SC24X7) TYPE(*CHAR) LEN(256)                                 /*CPK016*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')

/************DCLF       FILE(UPUICDPD)                                                 */ /*CUP024*/
/**********  DCLF       FILE(UPSVALJ0)                                         /*CUP033* *MD054605*/
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

/**********  IF         COND(&MODE *EQ '*UPG') THEN(DO)                                */ /*CPK023*/
             IF         COND(&MODE *EQ '*UPG' *OR &MODE *EQ '*IMP') +
                          THEN(DO)                                                        /*CPK023*/
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
             IF         COND(&BLANKSVAL *EQ 'Y') THEN(DO)                                 /*CUP033*/
/************   RCVF                                                                   */ /*CUP024*/
/**COPY*UPCPYSRC,UPSVALCAL1*                                         */ /*  */ /*CUP024*/ /*CUP033*/
/**********     IF         COND(&SBSID *EQ ' ') THEN(DO)                               */ /*CUP033*/
                   ?    SYSTEMID
                   MONMSG     MSGID(CPF6801) EXEC(DO)                                     /*CUP033*/
                      GOTO       CMDLBL(END)                                              /*CUP033*/
                   ENDDO                                                                  /*CUP033*/
                   RTVDTAARA  DTAARA(QTEMP/SYSID) RTNVAR(&SBSID)
                ENDDO
                CHGVAR     VAR(&LIBGRP) VALUE(&SBSID)
             ENDDO

/* Set up library list. */                                                                /*CUP033*/
             CALL       PGM(UPC0014) PARM(&SBSID)                                         /*CUP033*/

/**********  IF         COND(&MODE *EQ '*IMP') THEN(DO)                                */ /*CPK023*/
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
/**********           CALL       PGM(SCC0010) PARM('UPC0119' 'ENTER' ' ')              */ /*CPK023*/
/**********           GOTO       CMDLBL(END)                                           */ /*CPK023*/
/**********        ENDDO                                                               */ /*CPK023*/
/**********        CHGVAR     VAR(&LIBGRP) VALUE(&SBSID)                               */ /*CPK023*/
/**********     ENDDO                                                                  */ /*CPK023*/
/**********  ENDDO                                                                     */ /*CPK023*/

             IF         COND(&MODE *EQ '*247') THEN(DO)
/************   RTVDTAARA  DTAARA(UPSTAT) RTNVAR(&UPSTAT)                              */ /*CPK016*/
/************   CHGVAR     VAR(&LIBGRP) VALUE(%SST(&UPSTAT 64 2))                      */ /*CPK016*/
                RTVDTAARA  DTAARA(SC24X7) RTNVAR(&SC24X7)                                 /*CPK016*/
                CHGVAR     VAR(&LIBGRP) VALUE(%SST(&SC24X7 3 2))                          /*CPK016*/
                IF         COND(&LIBGRP *EQ ' ') THEN(DO)
                   GOTO       CMDLBL(ABNOR)
                ENDDO
             ENDDO

/* Call program to change routing entries. */
             CALL       PGM(UPC0120) PARM(&LIBGRP)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO

             GOTO       CMDLBL(END)

ABNOR:
/* Set up messages for Midas Information Screen  */
             RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('UPC0119') MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE('Check +
                          joblog for details')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(SCC0010) PARM('UPC0119' 'ENTER' ' ')
             MONMSG     MSGID(CPF0000)

END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')

             ENDPGM
