/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB Submit depend'y tab. rep in batch')          */
/*********************************************************************/
/*                                                                   */
/*        Midas     - Close of Business Processing              */
/*                                                                   */
/*       CBC0205  PRODUCE DEPENDENCY TABLE REPORT IN BATCH           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. BG18886            Date 02Jun08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 29Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      110242             Date 07Nov96              */
/*                      LN0911             Date 25Oct90              */
/*                                                                   */
/*------------------------------------------------------------------ */
/*                                                                   */
/*       BG18886 - Amend non-standard codes.                         */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       110242  - Change defaults for SBMJOB cmd to take *JOBD     */
/*       LN0911  -  RTGDTA(*JOBD) ADDED TO ALL SBMJOB CMDS.         */
/*                                                                  */
/*********************************************************************/
             PGM        PARM(&NUM &COMPNM &COMPSQ &MODID)
/**/
             DCL        VAR(&NUM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&COMPNM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&COMPSQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&MODID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RQSDTA) TYPE(*CHAR) LEN(44)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**********  CHGVAR     VAR(&RQSDTA) VALUE('CALL CBC0210 ('''****&NUM +
                          ***''' '''****&COMPNM****''' '''****&COMPSQ +
                          ***''' '''****&MODID****''')')            */ /*BG18886*/
             CHGVAR     VAR(&RQSDTA) VALUE('CALL CBC0210 (''' *CAT &NUM +
                          *CAT ''' ''' *CAT &COMPNM *CAT ''' ''' *CAT &COMPSQ +
                          *CAT ''' ''' *CAT &MODID *CAT ''')')         /*BG18886*/
/**/
             SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)
/**/
/** SUBMIT JOB CBC0210 TO MBATCH TO PRODUCE REPORT    **/
/**/
                                                                      /*LN0911*/
/**********  SBMJOB     JOB(CBC0210) JOBD(MBATCH) USER(*JOBD) +
                          RQSDTA(&RQSDTA) MSGQ(MOPERQ) */
/************SBMJOB     JOB(CBC0210) JOBD(MBATCH) USER(*JOBD) +       /*110242*/
/************RQSDTA(&RQSDTA) MSGQ(MOPERQ) RTGDTA(*JOBD) */            /*110242*/
/************SBMJOB     JOB(CBC0210) JOBD(MBATCH) USER(*JOBD) +                           /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA(&RQSDTA) +                                 /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(MOPERQ)                 /*110242*/          /*CSC023*/
             SBMJOB     JOB(CBC0210) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA(&RQSDTA) +
                          INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                         /*CSC023*/
                                                                      /*LN0911*/
/**/
                                                                      /*LN0911*/
/**********  SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
                          RQSDTA('CALL MIDASRMV') MSGQ(MOPERQ) */
/************SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +      /*110242*/
/*************  RQSDTA('CALL MIDASRMV') MSGQ(MOPERQ) RTGDTA(*JOBD) */ /*110242*/
/************SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +                          /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +                         /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(MOPERQ)                 /*110242*/          /*CSC023*/
             SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
                          INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                         /*CSC023*/
                                                                      /*LN0911*/
/**/
             GOTO       CMDLBL(ENDCLPGM)
/**/
/** CHECK FOR DATABASE ERRORS TRAPPED BY THE PROGRAM        **/
/**/
ABNOR:                  SNDPGMMSG  MSG('PRODUCTION OF DEPENDENCY +
                        TABLE REPORT TERMINATED ABNORMALLY') +
                        TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
                        MONMSG     MSGID(CPF0000 MCH0000)
/**/
                        RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                        MONMSG     MSGID(CPF0000 MCH0000)
                        SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                                   MSGDTA(&MEM) TOMSGQ(MOPERQ MRUNQ)
                        MONMSG     MSGID(CPF0000 MCH0000)
 ENDCLPGM:   ENDPGM
