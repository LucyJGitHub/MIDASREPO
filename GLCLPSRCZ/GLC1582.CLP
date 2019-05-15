/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Review postings profit centre')              */
/*********************************************************************/
/*                                                                   */
/*       Midas     - GENERAL LEDGER MODULE                           */
/*                                                                   */
/*       GLC1582 - REVIEW PROFIT CENTRE ON POSTING                   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 29Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 014noV01             */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      110242            Date 07NOV96               */
/*                      RT0030            DATE 09MAY91               */
/*                      LN0911            DATE 24OCT90               */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       110242  -  Change defaults for SBMJOB cmd to take *JOBD      */
/*       RT0030  -  JOBD(MBATCH) ADDED TO SBMJOB CMD                  */
/*       LN0911  -  RTGDTA(*JOBD) ADDED TO ALL SBMJOB CMDS.           */
/*                                                                    */
/**********************************************************************/
             PGM        PARM(&ACTCOD)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&ACTCOD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTNCOD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&GLSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&STATUS) TYPE(*CHAR) LEN(1)
/* IF AMEND MODE CHECK IF AN ORDER IS PENDING*/
             IF         COND(&ACTCOD *EQ 'A')  THEN(DO)
             RTVDTAARA  DTAARA(GLSTAT) RTNVAR(&GLSTAT)
             CHGVAR     VAR(&STATUS) VALUE(%SST(&GLSTAT 68 1))
             IF         COND(&STATUS *EQ 'Y')   THEN(DO)
             SNDPGMMSG  MSG('A previous request to change profit +
                          centre is pending-Please try again +
                          later.') TOPGMQ(*EXT)
             GOTO       CMDLBL(ENDLBL)
             ENDDO
             ENDDO
/* DISPLAY REQUEST SCREENS AND STORE IN FILE */
             CALL       PGM(GL1582) PARM(&ACTCOD &RTNCOD)
/* SUBMIT JOB TO CHANGE PROFIT CENTRE IN BATCH */
             IF         COND(&ACTCOD *EQ 'A' *AND &RTNCOD *EQ 'C') +
                          THEN(DO)
                                                                      /*RT0030*/
                                                                      /*LN0911*/
/**********  SBMJOB     CMD(CALL PGM(GLC1585))                       */
/**********  SBMJOB     CMD(CALL PGM(GLC1585)) RTGDTA(*JOBD)         */
/************SBMJOB     CMD(CALL PGM(GLC1585)) JOBD(MBATCH) +         /*110242*/
/*************                                 RTGDTA(*JOBD)*/        /*110242*/
/*************                                             /*LN0911*/ /*110242*/
/*************                                             /*RT0030*/ /*110242*/
/************SBMJOB     CMD(CALL PGM(GLC1585)) JOBD(MBATCH) +                             /*CPK014*/
/************           RTGDTA(*JOBD) INLLIBL(*JOBD)                  /*110242*/          /*CPK014*/
                                                                      /*110242*/
/************SBMJOB     CMD(CALL PGM(GLC1585)) JOBD(MBATCH) +                             /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) INLLIBL(*JOBD)             /*CPK014*/ /*CSC023*/
             SBMJOB     CMD(CALL PGM(GLC1585)) JOBD(MBATCH) +
                          USER(*JOBD) RTGDTA(*JOBD) INLLIBL(*JOBD) OUTQ(*JOBD)            /*CSC023*/
/* SET GLSTAT FOR 'REQUEST PENDING' TO 'Y'  */
             CHGDTAARA  DTAARA(GLSTAT (68 1)) VALUE('Y')
             ENDDO
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 ENDLBL:     ENDPGM
