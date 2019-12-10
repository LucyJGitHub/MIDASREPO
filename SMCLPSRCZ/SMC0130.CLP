/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SM Check sbs. routing & job queue entries')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Implementation module                               */
/*                                                                   */
/*       SMC0130 - Check subsystem routing entries and job queue     */
/*                  entries                                          */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD054605           Date 17Oct19              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      CUP034             Date 24Jan07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CUP033             Date 30Jun06              */
/*                      CSM005             Date 21Sep05              */
/*                      CSM003             Date 30May05              */
/*                      CUP016 *CREATE     Date 01Apr03              */
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
/**********  PGM                                                                       */ /*CUP033*/
/**********  PGM        PARM(&PFXSVAL &OPFXSVAL)                            */ /*CUP033*/ /*CUP034*/
             PGM        PARM(&PFXSVAL &OPFXSVAL &BRGSVAL)                                 /*CUP034*/

             DCL        VAR(&PFXSVAL) TYPE(*CHAR) LEN(20)                                 /*CUP033*/
             DCL        VAR(&OPFXSVAL) TYPE(*CHAR) LEN(20)                                /*CUP033*/
             DCL        VAR(&BRGSVAL) TYPE(*CHAR) LEN(20)                                 /*CUP034*/

/**COPY*UPCPYSRC,UPSVALDCL*                                          */ /*             */ /*CUP033*/
             DCL        VAR(&SBSID) TYPE(*CHAR) LEN(2)                                    /*CUP033*/
             DCL        VAR(&OLDSBSID) TYPE(*CHAR) LEN(2)                                 /*CUP033*/
             DCL        VAR(&BRGLIB) TYPE(*CHAR) LEN(10)                                  /*CUP034*/
             DCL        VAR(&BLANKSVAL) TYPE(*CHAR) LEN(1) VALUE('N')                     /*CUP033*/
             DCL        VAR(&XLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&UPSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&LIBGRP) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SUBSYSTEM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&REPLY1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RECURSIVE) TYPE(*CHAR) LEN(1) VALUE('N')
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
/**COPY*UPCPYSRC,UPSVALCAL3*                                         */ /*  */ /*CSM003*/ /*CUP033*/

/**Check*if*all*relevant*fields*have*been*entered*in*ICD**/ /*                         */ /*CUP033*/
/**********  IF         COND(&SBSID *EQ ' ') THEN(DO)                                  */ /*CSM003*/
/**********  IF         COND(&SBSID *EQ ' ' *OR &OLDSBSID *EQ ' ') +                   */ /*CUP033*/
/**********               THEN(DO)                                          */ /*CSM003*/ /*CUP033*/
/**Set*up*messages*for*Midas*Information*Screen***/ /*                                 */ /*CUP033*/

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

             IF         COND(&GISVAL *EQ &BRGSVAL) THEN(DO)                               /*CUP034*/
                IF         COND(&GIVAL *EQ ' ') THEN(DO)                                  /*CUP034*/
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                                  /*CUP034*/
                ENDDO                                                                     /*CUP034*/
                ELSE       CMD(DO)                                                        /*CUP034*/
                   CHGVAR     VAR(&BRGLIB) VALUE(&GIVAL)                                  /*CUP034*/
                ENDDO                                                                     /*CUP034*/
             ENDDO                                                                        /*CUP034*/

             GOTO       CMDLBL(VALIDATE)                                                  /*CUP033*/

 CHECK:                                                                                   /*CUP033*/
             IF         COND(&BLANKSVAL *EQ 'Y') THEN(DO)                                 /*CUP033*/
                RTVMSG     MSGID(UPM0003) MSGF(UTMSGF) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
                RTVMSG     MSGID(UPM0004) MSGF(UTMSGF) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (151 50)) VALUE(&MESSAGE)
                CALL       PGM(SCC0010) PARM('SMC0130' 'ENTER' ' ')
                GOTO       CMDLBL(END)
             ENDDO

/* Set up library list. */                                                                /*CUP034*/
             CALL       PGM(UPC0014) PARM(&SBSID)                                         /*CUP034*/
             ADDLIBLE   LIB(&BRGLIB)                                                      /*CUP034*/
             MONMSG     MSGID(CPF0000)                                                    /*CUP034*/

RETRY:
READNEXT:
/**********  RTVDTAARA  DTAARA(&PTFUPG/UPSTAT) RTNVAR(&UPSTAT)                         */ /*CSM003*/
/**********  CHGVAR     VAR(&LIBGRP) VALUE(%SST(&UPSTAT 62 2))                         */ /*CSM003*/
/**If*this*is*blank*then*this*should*mean*that*this*is*an*'XX'**/ /*                   */ /*CSM003*/
/**to*'XX'*type*migration.**************************************/ /*                   */ /*CSM003*/
/**********  IF         COND(&LIBGRP *EQ '  ') THEN(DO)                                */ /*CSM003*/
/**********     CHGVAR     VAR(&XLIB) VALUE(&SBSID *TCAT 'XLIBOLD')                    */ /*CSM003*/
/**********  ENDDO                                                                     */ /*CSM003*/
/**********  ELSE       CMD(DO)                                                        */ /*CSM003*/
/**********     CHGVAR     VAR(&XLIB) VALUE(&SBSID *TCAT 'XLIB')                       */ /*CSM003*/
/**********  ENDDO                                                                     */ /*CSM003*/
/**********  CHGVAR     VAR(&SUBSYSTEM) VALUE('M' *TCAT &SBSID *TCAT +                 */ /*CSM003*/
/**********               'SBS')                                                       */ /*CSM003*/
             CHGVAR     VAR(&XLIB) VALUE(&OLDSBSID *TCAT 'XLIB')                          /*CSM003*/
             CHGVAR     VAR(&SUBSYSTEM) VALUE('M' *TCAT &OLDSBSID +
                          *TCAT 'SBS')                                                    /*CSM003*/

/* Display subsystem description to print */
             DSPSBSD    SBSD(&XLIB/&SUBSYSTEM) OUTPUT(*PRINT)

/* Create physical file to receive subsystem data */
             DLTF       FILE(QTEMP/UPSBSD)
             MONMSG     MSGID(CPF0000)
             CRTPF      FILE(QTEMP/UPSBSD) RCDLEN(132) TEXT('Midas +
                          UP Subsystem description - from spool file')

/* Copy spool file to physical file */
             CPYSPLF    FILE(QPRTSBSD) TOFILE(QTEMP/UPSBSD) +
                          SPLNBR(*LAST)

/* Call program to process file and produce reports */
             CHGVAR     VAR(&ERROR) VALUE(' ')
             CALL       PGM(SMC0131) PARM(&ERROR)
             IF         COND(&ERROR *EQ 'Y') THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO

             GOTO       CMDLBL(END)

 ABNOR:
/* Error handling brought in through /COPY */
             IF         COND(&RECURSIVE *NE 'Y') THEN(DO)
                CHGVAR     VAR(&RECURSIVE) VALUE('Y')
                RTVMSG  MSGID(UPM0002) MSGF(UTMSGF) MSGDTA(SMC0130) +
                          MSG(&MESSAGE)
/*/COPY UPCPYSRCG,C_UPERRA                                           */
             ENDDO

END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')

             ENDPGM
