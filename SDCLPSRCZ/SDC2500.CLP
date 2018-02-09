/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas Duplicate files for CMG Software')              */
/********************************************************************/
/*                                                                  */
/*     Midas Standing Data Module                           */
/*                                                                  */
/*     SDC2500 - Duplicate Midas files for use by CMG               */
/*               software (this is a client SAR).                   */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CSC056             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 10May95              */
/*                      E40459            DATE  04JUN92             */
/*                      S01371            DATE  10APR92             */
/*                                                                  */
/********************************************************************/
/*       MD046248 - Finastra Rebranding                              */
/*       CSC056 - COB Restructure - SC COB Optimisation Phase 1     */
/*       S01408 - Addition of core hook SDC2500MP1                  */
/*       E40459 - S01362 put in a call to access program AOSARDR0,  */
/*                to check whether the SAR in question is enabled;  */
/*                however no call was coded with an option of *FREE,*/
/*                to close the file.  This meant that the file was  */
/*                open at Next-day set-up, preventing its being     */
/*                journalled.  A call to AOSARDR0 with *FREE has    */
/*                now been coded in the end processing, which       */
/*                should prevent this happening both now and for    */
/*                any calls to AOSARDR0 which may be added in the   */
/*                future.                                           */
/*     S01371 - Duplicate Midas files for CMG Software              */
/*                                                                  */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/**/
             PGM
/**/
/*   Declare Variables    */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/**********  DCL        VAR(&SRTCD) TYPE(*CHAR) LEN(7)             */                     /*CSC056*/
/**********  DCL        VAR(&SOPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY') */                /*CSC056*/
/**********  DCL        VAR(&SSARD) TYPE(*CHAR) LEN(6) VALUE('S01371') */                 /*CSC056*/
/**/
/**   Declare CMG data library */
/**/
             DCL        VAR(&CMGLIB) TYPE(*CHAR) LEN(10) +
                          VALUE('CMGGRBRD')
/**/
/**   Declare MASTER library */
/**/
             DCL        VAR(&DM_LIB) TYPE(*CHAR) LEN(10) +
                          VALUE('xxDMLIB')
/**/
/**   Declare system prefix    */
/**/
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
/**/
/* Global monitor message */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
/**/
/*   Set off Switches                     */
/**/
             CHGJOB     SWS(00000000)
/**/
/**DETERMINE*IF*SAR*INSTALLED**/                                                          /*CSC056*/
/**/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD)   */                     /*CSC056*/
/**/
/**ERROR**/                                                                               /*CSC056*/
/**/
/**********  IF         COND(&SRTCD *NE '       ' *AND &SRTCD *NE +
                          '*NRF   ') THEN(DO)                      */                     /*CSC056*/
/**********  CHGJOB     SWS(XXXXXX11)                              */                     /*CSC056*/
/**********  SNDPGMMSG  MSG('SDC2500 - JOB TERMINATED - PROGRAM ERROR') +
                                TOMSGQ(MOPERQ MRUNQ)               */                     /*CSC056*/
/**********  GOTO       CMDLBL(END)                                */                     /*CSC056*/
/**********  ENDDO                                                 */                     /*CSC056*/
/**/
/**SAR*NOT*INSTALLED**/                                                                   /*CSC056*/
/**/
/**********  IF         COND(&SRTCD *EQ '*NRF   ') THEN(DO)        */                     /*CSC056*/
/**********  GOTO       CMDLBL(END)                                */                     /*CSC056*/
/**********  ENDDO                                                 */                     /*CSC056*/
 
             SNDMSG     MSG('Duplicate Midas files for use by CMG +
                          software') TOMSGQ(MRUNQ)
/**/
/** Retrieve system prefix  */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
/**/
/** Define master library      */
/**/
             CHGVAR     VAR(%SUBSTRING(&DM_LIB 1 2)) VALUE(&PREFIX)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC2500MP1                                          */
                                                                      /*S01408*/
 
/**/
             CLRPFM     FILE(&CMGLIB/ACCNTAB)
             MONMSG     MSGID(CPF3142) EXEC(CRTDUPOBJ OBJ(ACCNTAB) +
                          FROMLIB(&DM_LIB) OBJTYPE(*FILE) +
                          TOLIB(&CMGLIB))
/**/
             CLRPFM     FILE(&CMGLIB/CLINTCB)
             MONMSG     MSGID(CPF3142) EXEC(CRTDUPOBJ OBJ(CLINTCB) +
                          FROMLIB(&DM_LIB) OBJTYPE(*FILE) +
                          TOLIB(&CMGLIB))
/**/
             CLRPFM     FILE(&CMGLIB/TABTB10)
             MONMSG     MSGID(CPF3142) EXEC(CRTDUPOBJ OBJ(TABTB10) +
                          FROMLIB(&DM_LIB) OBJTYPE(*FILE) +
                          TOLIB(&CMGLIB))
/**/
             CLRPFM     FILE(&CMGLIB/TABTG10)
             MONMSG     MSGID(CPF3142) EXEC(CRTDUPOBJ OBJ(TABTG10) +
                          FROMLIB(&DM_LIB) OBJTYPE(*FILE) +
                          TOLIB(&CMGLIB))
/**/
             CPYF       FROMFILE(&DM_LIB/ACCNTAB) +
                          TOFILE(&CMGLIB/ACCNTAB) MBROPT(*ADD) +
                          CRTFILE(*NO) FMTOPT(*NOCHK)
/**/
             CPYF       FROMFILE(&DM_LIB/CLINTCB) +
                          TOFILE(&CMGLIB/CLINTCB) MBROPT(*ADD) +
                          CRTFILE(*NO) FMTOPT(*NOCHK)
/**/
             CPYF       FROMFILE(&DM_LIB/TABTB10) +
                          TOFILE(&CMGLIB/TABTB10) MBROPT(*ADD) +
                          CRTFILE(*NO) FMTOPT(*NOCHK)
/**/
             CPYF       FROMFILE(&DM_LIB/TABTG10) +
                          TOFILE(&CMGLIB/TABTG10) MBROPT(*ADD) +
                          CRTFILE(*NO) FMTOPT(*NOCHK)
/**/
             GOTO END
/**/
/*  ABNORMAL TERMINATION PROCESSING */
/**/
 ABNOR:
             SNDPGMMSG  MSG('SDC2500 - Duplicate Midas files for use +
                          by CMG software - ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/*END:*******ENDPGM                                                  /*E40459*/
 END:                                                                /*E40459*/
/* */                                                                /*E40459*/
/***Call*AOSARDR0*with*an*option*of*'*FREE'*to*close*the*file.******/          /*E40459*/ /*CSC056*/
/**********  CHGVAR     VAR(&SOPTN) VALUE('*FREE')                 */          /*E40459*/ /*CSC056*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD)   */          /*E40459*/ /*CSC056*/
/* */                                                                /*E40459*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                  /*E40459*/
/**/
