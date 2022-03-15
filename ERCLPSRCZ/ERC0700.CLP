/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ER - Submit Interface to FRS')                  */
/********************************************************************/
/*                                                                  */
/*     MIDAS/ABS - EUROPEAN REPORTING                               */
/*                                                                  */
/*     ERC0700 - EUROPEAN REPORTING                                 */
/*               SUBMIT EUROPEAN REPORTING INTERFACE MAIN COMPONENT */
/*                                                                  */
/*       (c) Finastra International Limited 2005                     */
/*                                                                  */
/*       Last Amend No. MD059459           Date 13Jan22              */
/*       Prev Amend No. MD058100           Date 20May21              */
/*                      LUC139 *Update     Date 07May21              */
/*                      LUC139             Date 04Jan21              */
/*                      MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CER001             Date 25Apr05              */
/*                      ULX004             Date 27Oct97              */
/*                      ER1003             Date 03Nov92        ThL   */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD059459 - Upgrade Italian Returns to FM 2021.B             */
/*                  Avoid calling AOSARDR0 from CADREPORT            */
/*                - Added LUC139 codes from SP08                     */
/* MD058100 - Rollup of additional BoI onsite fixes at FbMidas       */
/* LUC139   - Create logical files in ERDLIB based over DTALIB       */
/* LUC139   - Upgrade UCI Italian Returns                            */
/*       MD046248 - Finastra Rebranding                              */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/* ULX004 - Change Submit Job parameter                             */
/* ER1003 - Change Submit Job parameter                             */
/*                                                                  */
/*********************************************************************/
/**/
             PGM

             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2) /* Midas +
                          subsystem prefix                        ER1003 */
             DCL        VAR(&MAINCOMP) TYPE(*CHAR) LEN(256) /* Midas +
                          ER Main Component                       ER1003 */
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*LUC139*/
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)              /*LUC139*/
             DCL        VAR(&DVLIB) TYPE(*CHAR) LEN(10)               /*LUC139*/
             DCL        VAR(&ERDLIB) TYPE(*CHAR) LEN(10)              /*LUC139*/

             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR))

/* Reset External Switches */
             CHGJOB     SWS(00000000)

/* Retrieve Midas sbs prefix */                                 /* ER1003 */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)    /* ER1003 */
                                                                      /*LUC139*/
/* Duplicate logical files that access DTALIB physicals               /*LUC139*/
                                                                      /*LUC139*/
             CHGVAR     VAR(&DVLIB) VALUE(&PREFIX *CAT 'DVLIB')       /*LUC139*/
             CHGVAR     VAR(&ERDLIB) VALUE(&PREFIX *CAT 'ERDLIB')     /*LUC139*/
                                                                      /*LUC139*/
             CRTDUPOBJ  OBJ(MUSER) FROMLIB(&DVLIB) OBJTYPE(*FILE) +
                          TOLIB(&ERDLIB)                              /*LUC139*/
             MONMSG     MSGID(CPF2130)                                /*LUC139*/

/* Format ER processing main component */                       /* ER1003 */
             CHGVAR     VAR(&MAINCOMP) VALUE('CALL ERC0701 +
                          PARM(' *CAT &PREFIX *CAT ')')         /* ER1003 */
                                                                      /*LUC139*/
/**For*Italian*Reporting,*duplicate*logical*files*that*access***     */          /*LUC139 MD059459*/
/**physical*in*the*DTALIB***************************************     */          /*LUC139 MD059459*/
                                                                      /*LUC139*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'UIT021' +
                          &DSFDY)                                     /*LUC139*/
             IF         COND(&RTCD *EQ ' ') THEN(DO)                  /*LUC139*/
/**********  CRTDUPOBJ  OBJ(SCCSECL1) FROMLIB(&DVLIB) OBJTYPE(*FILE) +*/                /*MD059459*/
/**********               TOLIB(&ERDLIB)                             */          /*LUC139 MD059459*/
/**********  MONMSG     MSGID(CPF2130)                               */          /*LUC139 MD059459*/
/**********  CRTDUPOBJ  OBJ(SCSARDL1) FROMLIB(&DVLIB) OBJTYPE(*FILE) +*/                /*MD059459*/
/**********               TOLIB(&ERDLIB)                                         /*LUC139 MD059459*/
/**********  MONMSG     MSGID(CPF2130)                               */          /*LUC139 MD059459*/
/**********  CRTDUPOBJ  OBJ(SCSARSL1) FROMLIB(&DVLIB) OBJTYPE(*FILE) +*/                /*MD059459*/
/**********               TOLIB(&ERDLIB)                             */          /*LUC139 MD059459*/
/**********  MONMSG     MSGID(CPF2130)                               */          /*LUC139 MD059459*/
/**********  CRTDUPOBJ  OBJ(GPCSECL1) FROMLIB(*LIBL) OBJTYPE(*FILE) +*/                 /*MD059459*/
/**********               TOLIB(&ERDLIB)                             */          /*LUC139 MD059459*/
/**********  MONMSG     MSGID(CPF2130)                               */          /*LUC139 MD059459*/
             CHGVAR     VAR(&MAINCOMP) VALUE('CALL XXCL0701 +
                          PARM(' *CAT &PREFIX *CAT ')')               /*LUC139*/
             ENDDO                                                    /*LUC139*/
             ELSE       CMD(DO)                                       /*LUC139*/
             DLTF       FILE(&ERDLIB/MUSER)                           /*LUC139*/
             MONMSG     MSGID(CPF2105)                                /*LUC139*/
             ENDDO                                                    /*LUC139*/
                                                                                        /*MD059459*/
/** If MMI033 is on create IRMIHOPD in ERDLIB to inform the                             /*MD059459*/
/** batch job CADREPORT that MMI033 is switched on.                                     /*MD059459*/
                                                                                        /*MD059459*/
             DLTF       FILE(&ERDLIB/IRMIHOPD)                                          /*MD059459*/
             MONMSG     MSGID(CPF2105)                                                  /*MD059459*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'MMI033' +
                          &DSFDY)                                                       /*MD059459*/
             IF         COND(&RTCD *EQ ' ') THEN(DO)                                    /*MD059459*/
             CRTDUPOBJ  OBJ(IRMIHOPD) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&ERDLIB)                                                /*MD059459*/
             ENDDO                                                                      /*MD059459*/
                                                                                        /*MD059459*/
/** If MMI059 is on create IRTABEPD in ERDLIB to inform the                             /*MD059459*/
/** batch job CADREPORT that MMI059 is switched on.                                     /*MD059459*/
                                                                                        /*MD059459*/
             DLTF       FILE(&ERDLIB/IRTABEPD)                                          /*MD059459*/
             MONMSG     MSGID(CPF2105)                                                  /*MD059459*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'MMI059' +
                          &DSFDY)                                                       /*MD059459*/
             IF         COND(&RTCD *EQ ' ') THEN(DO)                                    /*MD059459*/
             CRTDUPOBJ  OBJ(IRTABEPD) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(&ERDLIB)                                                /*MD059459*/
             ENDDO                                                                      /*MD059459*/

/* Submit FRS Interface                                           */
/*  Job submitted to avoid interference with MIDAS COB            */
/*  Any error when submit command executed will cause this        */
/*  component to be restartable within MIDAS COB                  */
/*  During execution of interface , any restart procedure has to  */
/*  be done manually.                                             */

/************SBMJOB     JOB(ERREPORT) JOBD(*LIBL/ERJOBD) +
                          PRTDEV(*JOBD) OUTQ(*JOBD) RTGDTA(*JOBD) +
                          RQSDTA(&MAINCOMP) INLLIBL(*JOBD) +
                          MSGQ(*LIBL/ERMSGQ)                  ER1003   ULX004*/
 /********** SBMJOB     JOB(CADREPORT) JOBD(*LIBL/CADJOBD) +
                          PRTDEV(*JOBD) OUTQ(*JOBD) RTGDTA(*JOBD) +
                          RQSDTA(&MAINCOMP) INLLIBL(*JOBD) +
                          MSGQ(*LIBL/CADMSGQ)                             */      /* ULX004 CER001*/
/*********** SBMJOB     JOB(CADREPORT) JOBD(*LIBL/MEODD) +           */                   /*LUC139*/
/**********               PRTDEV(*JOBD) OUTQ(*JOBD) USER(*JOBD) +    */                   /*LUC139*/
/**********               RTGDTA(*JOBD) RQSDTA(&MAINCOMP) +          */                   /*LUC139*/
/**********               INLLIBL(*JOBD) MSGQ(*LIBL/MOPERQ)          */            /*CER001 LUC139*/
             SBMJOB     JOB(CADREPORT) JOBD(*LIBL/ERJOBD) +
                          PRTDEV(*JOBD) OUTQ(*JOBD) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA(&MAINCOMP) +
                          INLLIBL(*JOBD) MSGQ(*LIBL/MOPERQ)                               /*LUC139*/
/**********  SNDMSG     MSG('ERC0700 - ER Interface to FRS +                            /*MD059459*/
/**********               processing starts. ') TOMSGQ(MRUNQ)                           /*MD059459*/
             SNDMSG     MSG('ERC0700 - ER Interface to FRS +
                          processing starts. ') TOMSGQ(ERMSGQ)                          /*MD059459*/
             MONMSG     MSGID(CPF0000 MCH0000)
             GOTO EOJ

 ERROR:      CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000)
             SNDPGMMSG  MSGID(DBM0004) MSGF(DRSMM) MSGDTA('ERC0700   +
                          001') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000)

EOJ:         ENDPGM
