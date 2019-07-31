/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SM Shell for rebuild of multi-member LFs')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Implementation module                               */
/*                                                                   */
/*       SMC2050 - Shell for rebuild of multi-member LFs             */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. CSM010             Date 22Jun07              */
/*                      CER001             Date 18Apr07              */
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
/*       CSM010 - Applied by CER001.                                 */
/*       CER001 - Changes for renamed regional files.                */
/*       CUP033 - Removal of System Value /COPYs.                    */
/*       CSM005 - Changes to /COPYs.  Recompile.                     */
/*       CSM003 - Use system value rather than UPSTAT.               */
/*       CUP016 - Add implementation software to core.               */
/*                                                                   */
/*********************************************************************/
/**********  PGM                                                                       */ /*CUP033*/
             PGM        PARM(&PFXSVAL &BRGSVAL)                                           /*CUP033*/
 
             DCL        VAR(&PFXSVAL) TYPE(*CHAR) LEN(20)                                 /*CUP033*/
             DCL        VAR(&BRGSVAL) TYPE(*CHAR) LEN(20)                                 /*CUP033*/
/**COPY*UPCPYSRG,UPSVALDCL*                                          */ /*             */ /*CUP033*/
             DCL        VAR(&SBSID) TYPE(*CHAR) LEN(2)                                    /*CUP033*/
             DCL        VAR(&PTFUPG) TYPE(*CHAR) LEN(10)                                  /*CUP033*/
             DCL        VAR(&BLANKSVAL) TYPE(*CHAR) LEN(1) VALUE('N')                     /*CUP033*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&UPSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&WRAP) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
             DCLF       FILE(UPSVALJ0)                                                    /*CUP033*/
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES)
             CHGJOB     SWS(XXXXXX00)
 
/* Change 'message queue full' handling so that job doesn't crash */
             RTVJOBA    JOBMSGQFL(&WRAP)
             CHGJOB     JOBMSGQFL(*PRTWRAP)
 
/* Create data area /MIDASMSG in QTEMP */
             DLTDTAARA  DTAARA(QTEMP/MIDASMSG)
             MONMSG     MSGID(CPF0000)
             CRTDTAARA  DTAARA(QTEMP/MIDASMSG) TYPE(*CHAR) LEN(800) +
                          VALUE(' ')
/**COPY*UPCPYSRC,UPSVALCAL1*                                         */ /*             */ /*CUP033*/
 
/**Check*if*all*relevant*fields*have*been*entered*in*ICD**/ /*                         */ /*CUP033*/
/**********  IF         COND(&PTFUPG *EQ ' ' *OR &SBSID *EQ ' ') +                     */ /*CUP033*/
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
                CALL       PGM(SCC0010) PARM('SMC2050' 'ENTER' ' ')
                GOTO       CMDLBL(END)
             ENDDO
 
/**********  RTVDTAARA  DTAARA(&PTFUPG/UPSTAT) RTNVAR(&UPSTAT)                        */ /*CSM003*/
/**********  CHGVAR     VAR(&PREFIX) VALUE(%SST(&UPSTAT 62 2))                        */ /*CSM003*/
/**********  IF         COND(&PREFIX *EQ '  ') THEN(DO)                               */ /*CSM003*/
             CHGVAR     VAR(&PREFIX) VALUE(&SBSID)
/**********  ENDDO                                                                    */ /*CSM003*/
 
             CALL       PGM(UPC0014) PARM(&PREFIX)
 
             CHGVAR     VAR(&RETURN) VALUE(' ')
 
/*******************************************************************/                     /*CER001*/
/*                                                                 */                     /*CER001*/
/*  SM000018 - Change file names for regional changes.             */                     /*CER001*/
/*                                                                 */                     /*CER001*/
/*******************************************************************/                     /*CER001*/
                                                                                          /*CER001*/
             CALL       PGM(SM000018)                                                     /*CER001*/
 
/*******************************************************************/
/*                                                                 */
/*  SM0264 - Change library names for FILEMULMBR                   */
/*                                                                 */
/*******************************************************************/
 
             CALL       PGM(SM0264)
 
/*******************************************************************/
/*                                                                 */
/*  UPC0265 - Rebuild multi-member logical files                   */
/*                                                                 */
/*******************************************************************/
 
             CALL       PGM(UPC0265) PARM(&PTFUPG &RETURN)
/*If the program ended with error then take appropriate action */
             IF         COND(&RETURN *EQ 'C') THEN(DO)
                GOTO       CMDLBL(END)
             ENDDO
/*******************************************************************/
/*                                                                 */
/*  SMC0266 - Rebuild logical file members                         */
/*                                                                 */
/*******************************************************************/
 
             CALL       PGM(SMC0266) PARM(&RETURN)
/*If the program ended with error then take appropriate action */
             IF      COND(&RETURN *EQ 'C') THEN(DO)
                GOTO       CMDLBL(END)
             ENDDO
 
/*******************************************************************/
/*                                                                 */
/*  SMC0267 - Rebuild logical file members, special cases          */
/*                                                                 */
/*******************************************************************/
 
             CALL       PGM(SMC0267) PARM(&RETURN &PREFIX)
/*If the program ended with error then take appropriate action */
             IF      COND(&RETURN *EQ 'C') THEN(DO)
                GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(END)
 ABNOR:
/* Set up messages for Midas Information Screen  */
 
             RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('SMC2050') MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000)
 
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE('Check +
                          joblog for details')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(SCC0010) PARM('SMC2050' 'JOBLOG' 'Y')
             MONMSG     MSGID(CPF0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             CHGJOB     JOBMSGQFL(&WRAP)
 
             ENDPGM
