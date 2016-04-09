/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Comm'ns/Compression Programs Start-Up.')        */
/********************************************************************/
/*                                                                  */
/*       Midas S.W.I.F.T. DIRECT LINK                       */
/*                                                                  */
/*     MSC4001 - COMMUNICATIONS/COMPRESSION PROGRAMS START-UP.      */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC023             Date 30Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CPK014             Date 06Nov01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      050313             Date 04Mar97              */
/*                   034070            DATE 04MAR97                 */
/*                   110242            DATE 07NOV96                 */
/*                   CSW095            DATE 07APR95                 */
/*                   S01408            DATE 05MAY95                 */
/*                   087358            DATE 01MAY95                 */
/*                   068100            DATE 16JAN94                 */
/*                   E22636            DATE 20JUL90                 */
/*                   E22717            DATE 20JUL90                 */
/*                   E20723            DATE 08JAN90                 */
/*                   E13834            DATE 27/06/88                */
/*                   E12829            DATE 13/05/88                */
/*                   E11801            DATE 18/03/88                */
/*                   E11656            DATE 23/09/87                */
/*                                                                  */
/*********************************************************************/
/*                                                                   */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*     CPK014 - Release 4 packaging.  Move data queues from XLIB to  */
/*               DPLIB.                                              */
/*     050313 - Do not allow to submit MSC4010 if MSC0200 is still   */
/*              running. (May occur when MSC4010 fall over due to    */
/*              hardware )                                           */
/*     034070 - Only allow this program to run if SDSTAT library ID */
/*              is same AS MSSTAT library ID to stop TEST system    */
/*              getting to LIVE SWIFT device                        */
/*     110242 - Change defaults for SBMJOB cmd to take *JOBD        */
/*     CSW095 - S.W.I.F.T. 1995 Message Changes.                     */
/*              Increase DTQB from 1019 to 1021.                     */
/*     S01408 - Addition of core hook MSC4001MP1                     */
/*     087358 - Pgm deletes/recreates data queues MSDTQA each time   */
/*              the link is started - it is not an error if the      */
/*              data queue it is deleting does not exist.            */
/*     068100 - Allow for multi-language overrides                   */
/*     E22636 - DELETE & CREATE DATA QUEUES AT START TO PREVENT      */
/*              PROBLEMS WITH DUPLICATES                             */
/*     E22717 - REMOVE E20723 AS IT PREVENTS MS4010 RUNNING IN       */
/*              ITS OWN POOL                                         */
/*     E20723  -  S/38 TO AS400 CONVERSION TO 'SBMJOB'; ALL          */
/*                OCCURANCES SHOULD BE RTGDTA(*JOBD) INLLIBL(*JOBD).*/
/*     E13834 - Send the 'COMPRESSION ALREADY ACTIVE' message to     */
/*              the screen as well as to MOPERQ.                     */
/*     E12829 - Changes the submit job command for MSC4010 so that   */
/*              it will run it its own storage pool.                 */
/*     E11801 - Allocation of a data area instead of a program object*/
/*              to avoid conflict with other systems on the same     */
/*              machine.                                             */
/*     E11656 - Allocation attempts of programs default to WAIT time */
/*              of *CLS. Now changed to 1 second                     */
/*********************************************************************/
             PGM
/*                                                                  */
/* Declare Variables.                                               */
/*                                                                  */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&MSSTAT) TYPE(*CHAR) LEN(51)
             DCL        VAR(&CJNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CUNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CJNO) TYPE(*CHAR) LEN(6)
/*                                                                    E22636*/
             DCL      VAR(&XLIB) TYPE(*CHAR) LEN(6) VALUE('  XLIB') /*E22636*/
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)              /*E22636*/
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)           /*E22636*/
             DCL        VAR(&MSLID) TYPE(*CHAR) LEN(2)              /* 034070 */
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(100)              /* 034070 */
/*/COPY WNCPYSRC,MSC4001002                                          */
/*                                                                    E22636*/
/*                                                                  */
/* Global monitor message                                           */
/*                                                                  */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/*/COPY WNCPYSRC,MSC4001001                                          */
/*                                                                  */
/* Audit Msg to MRUNQ                                               */
/*                                                                  */
             SNDPGMMSG  MSG('SWIFT Communications/Compression Program +
                          Start-up') TOMSGQ(MRUNQ)
/*                                                                     034070 */
/*   Decide if this is the live SWIFT system                           034070 */
             RTVDTAARA  DTAARA(MSSTAT (255 2)) RTNVAR(&MSLID)       /* 034070 */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)         /* 034070 */
                                                                    /* 034070 */
/*   If library ID on MSSTAT isn't same as SDSTAT then this is'nt live 034070 */
             IF         COND(&MSLID *NE &SYSID) THEN(DO)            /* 034070 */
             CHGVAR     VAR(&MSG) VALUE('MIDAS/S.W.I.F.T. Direct +
                          Link Communications can only be started +
                          on' *BCAT &MSLID *BCAT 'system')          /* 034070 */
             SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ)       /* 034070 */
             GOTO END                                               /* 034070 */
             ENDDO                                                  /* 034070 */
                                                                    /* 034070 */
/*                                                                  */
/* Test if communications program is already active.                */
/*                                                                  */
/********ALCOBJ     OBJ((MS4010 *PGM *EXCL))      *****/             /*E11656*/
/************ALCOBJ     OBJ((MS4010 *PGM *EXCL)) WAIT(1)   /*E11656*  *E11801*/
             ALCOBJ     OBJ((MS4010 *DTAARA *EXCL)) WAIT(1)          /*E11656*/
             MONMSG     MSGID(CPF0000) EXEC(DO)
/**************SNDPGMMSG  MSG('MIDAS/S.W.I.F.T. Direct Link +      */ /*E13834*/
/**************            Communications program already active')+*/ /*E13834*/
/**************             TOMSGQ(MOPERQ)                         */ /*E13834*/
               SNDPGMMSG  MSG('MIDAS/S.W.I.F.T. Direct Link +
                            Communications program already active') +
                            TOPGMQ(*EXT) TOMSGQ(MOPERQ)               /*E13834*/
               GOTO       END
             ENDDO
/************DLCOBJ     OBJ((MS4010 *PGM *EXCL))    *****/           /*E11801*/
             DLCOBJ     OBJ((MS4010 *DTAARA *EXCL))                  /*E11801*/
/**/                                                                  /*050313*/
/*   CHECK ALSO MS0200 DATA AREA                                        050313*/
/**/                                                                  /*050313*/
             ALCOBJ     OBJ((MS0200 *DTAARA *EXCL)) WAIT(1)           /*050313*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*050313*/
               SNDPGMMSG  MSG('MIDAS/S.W.I.F.T. Direct Link +
                            Compression program already active') +
                            TOPGMQ(*EXT) TOMSGQ(MOPERQ)               /*050313*/
               GOTO       END                                         /*050313*/
             ENDDO                                                    /*050313*/
             DLCOBJ     OBJ((MS0200 *DTAARA *EXCL))                   /*050313*/
/*                                                            */     /*E22636*/
/* Obtain the system identifier and set &XLIB to be used as LIB  */  /*E22636*/
/*                                                               */  /*E22636*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)          /*E22636*/
             CHGVAR     VAR(&XLIB) VALUE(&SYSID *CAT 'XLIB')         /*E22636*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,MSC4001MP1                                          */
                                                                      /*S01408*/
/************                                                               */ /*E22636*/ /*CPK014*/
/**Clear*dataq*MSDTQA*by*deleting*and*recreating*it                         */ /*E22636*/ /*CPK014*/
/************                                                              */  /*E22636*/ /*CPK014*/
/************         DLTDTAQ    DTAQ(MSDTQA)                                  /*E22636*/ /*CPK014*/
/************         MONMSG     MSGID(CPF2105)                                /*087358*/ /*CPK014*/
/************         CRTDTAQ    DTAQ(&XLIB/MSDTQA) MAXLEN(1) +                           /*CPK014*/
/************                    AUT(*CHANGE)                                  /*E22636*/ /*CPK014*/
 
/* Clear data queue MSDTQA. */                                                            /*CPK014*/
             CALL       PGM(QCLRDTAQ) PARM('MSDTQA' '*LIBL ')                             /*CPK014*/
 
/************                                                               */ /*E22636*/ /*CPK014*/
/**Clear*dataq*MSDTQB*by*deleting*and*recreating*it                         */ /*E22636*/ /*CPK014*/
/************                                                               */ /*E22636*/ /*CPK014*/
/************         DLTDTAQ    DTAQ(MSDTQB)                                  /*E22636*/ /*CPK014*/
/************         MONMSG     MSGID(CPF2105)                                /*087358*/ /*CPK014*/
/***********          CRTDTAQ    DTAQ(&XLIB/MSDTQB) MAXLEN(1019) +                        /*CSW095*/
/************                    AUT(*CHANGE)                                  /*E22636*/ /*CSW095*/
/************         CRTDTAQ    DTAQ(&XLIB/MSDTQB) MAXLEN(1021) +                        /*CPK014*/
/************                    AUT(*CHANGE)                                  /*CSW095*/ /*CPK014*/
 
/* Clear data queue MSDTQB. */                                                            /*CPK014*/
             CALL       PGM(QCLRDTAQ) PARM('MSDTQB' '*LIBL ')                             /*CPK014*/
 
/*                                                                   */
/* Submit job to run communications program.                         */
/*                                                                   */
/************SBMJOB     JOB(MSC4010) JOBD(MBATCH) USER(*JOBD) +     *  *E12829*/
/************             JOBQ(MSJOBQ) RQSDTA('CALL MSC4010')       *  *E12829*/
/************SBMJOB     JOB(MSC4010) JOBD(MBATCH) USER(*JOBD) +
/************             JOBQ(MSJOBQ) RTGDTA(MSC4010) +
/************             RQSDTA('CALL MSC4010')   */     /*E12829*/  /*E20723*/
/************SBMJOB     JOB(MSC4010) JOBD(MBATCH) JOBQ(MSJOBQ) + */   /*E22717*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL + */
/************             MSC4010') INLLIBL(*JOBD)              */    /*E20723*/
/************SBMJOB     JOB(MSC4010) JOBD(MBATCH) USER(*JOBD) +       /*110242*/
/*************            JOBQ(MSJOBQ) RTGDTA(MSC4010) +              /*110242*/
/*************            RQSDTA('CALL MSC4010')           /*E22717*/ /*110242*/
/************SBMJOB     JOB(MSC4010) JOBD(MBATCH) JOBQ(MSJOBQ) +                          /*CSC023*/
/************             USER(*JOBD) RTGDTA(MSC4010) RQSDTA('CALL +                      /*CSC023*/
/************             MSC4010') INLLIBL(*JOBD)                    /*110242*/          /*CSC023*/
             SBMJOB     JOB(MSC4010) JOBD(MBATCH) JOBQ(MSJOBQ) +
                          USER(*JOBD) RTGDTA(MSC4010) RQSDTA('CALL +
                          MSC4010') INLLIBL(*JOBD) OUTQ(*JOBD)                            /*CSC023*/
/*                                                                  */
/* Test if compression program is already active.                   */
/*                                                                  */
/************ALCOBJ     OBJ((MS0200 *PGM *EXCL))           *****/    /*E11656*/
/************ALCOBJ     OBJ((MS0200 *PGM *EXCL)) WAIT(1)   /*E11656*  *E11801*/
             ALCOBJ     OBJ((MS0200 *DTAARA *EXCL)) WAIT(1)          /*E11801*/
             MONMSG     MSGID(CPF0000) EXEC(DO)
/**************SNDPGMMSG  MSG('MIDAS/S.W.I.F.T. Direct Link +      */ /*E13834*/
/**************             Compression program already active') + */ /*E13834*/
/**************             TOMSGQ(MOPERQ)                         */ /*E13834*/
               SNDPGMMSG  MSG('MIDAS/S.W.I.F.T. Direct Link +
                            Compression program already active') +
                            TOPGMQ(*EXT) TOMSGQ(MOPERQ)               /*E13834*/
               GOTO       END
             ENDDO
/************DLCOBJ     OBJ((MS0200 *PGM *EXCL))          ******/    /*E11801*/
             DLCOBJ     OBJ((MS0200 *DTAARA *EXCL))                  /*E11801*/
/*                                                                   */
/* Submit job to run compression program.                            */
/*                                                                   */
/************SBMJOB     JOB(MSC0200) JOBD(MBATCH) USER(*JOBD) +
/************             JOBQ(MSJOBQ) RQSDTA('CALL MSC0200')  */     /*E20723*/
/***********************************************************************068100*/
/************SBMJOB*****JOB(MSC0200)*JOBD(MBATCH)*USER(*JOBD)*+*********068100*/
/*************************JOBQ(MSJOBQ)*RQSDTA('CALL*MSC0200')*+*********068100*/
/*************************RTGDTA(*JOBD)*INLLIBL(*JOBD)***********E207023068100*/
/************SBMJOB     JOB(MSC0200) JOBD(MBATCH) JOBQ(MSJOBQ) +                          /*CSC023*/
/************             USER(*JOBD) RTGDTA(MSEXTRACT) +                                 /*CSC023*/
/************             RQSDTA('CALL MSC0200') INLLIBL(*JOBD)       /*068100*/          /*CSC023*/
             SBMJOB     JOB(MSC0200) JOBD(MBATCH) JOBQ(MSJOBQ) +
                          USER(*JOBD) RTGDTA(MSEXTRACT) +
                          RQSDTA('CALL MSC0200') INLLIBL(*JOBD) OUTQ(*JOBD)               /*CSC023*/
/*                                                                   */
/*                                                                   */
             GOTO       END
/*                                                                   */
 ABNOR:      SNDPGMMSG  MSG('MIDAS/S.W.I.F.T. Direct Link +
                          Communications start-up ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*                                                                   */
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
