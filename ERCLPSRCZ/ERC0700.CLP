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
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CER001             Date 25Apr05              */
/*       Prev Amend No. ULX004             Date 27Oct97        ThL   */
/*                      ER1003             Date 03Nov92        ThL   */
/*------------------------------------------------------------------*/
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
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR))
 
/* Reset External Switches */
             CHGJOB     SWS(00000000)
 
/* Retrieve Midas sbs prefix */                                 /* ER1003 */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)    /* ER1003 */
 
/* Format ER processing main component */                       /* ER1003 */
             CHGVAR     VAR(&MAINCOMP) VALUE('CALL ERC0701 +
                          PARM(' *CAT &PREFIX *CAT ')')         /* ER1003 */
 
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
             SBMJOB     JOB(CADREPORT) JOBD(*LIBL/MEODD) +
                          PRTDEV(*JOBD) OUTQ(*JOBD) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA(&MAINCOMP) +
                          INLLIBL(*JOBD) MSGQ(*LIBL/MOPERQ)                               /*CER001*/
             SNDMSG     MSG('ERC0700 - ER Interface to FRS +
                          processing starts. ') TOMSGQ(MRUNQ)
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
