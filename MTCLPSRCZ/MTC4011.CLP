/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MT Start telex message conversation')           */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Midas Telex Module                              */
/*                                                                   */
/*       MTC4011 - Start Telex Message Conversation Control          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 30Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      110242             Date 07Nov96              */
/*                      077466             DATE 17OCT94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       110242 - Change defaults for SBMJOB cmd to take *JOBD       */
/*       077466 - New program created to control the telex message   */
/*                conversation processing.                           */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ABNOR))
 
/* Start telex message conversion */
 
/************SBMJOB     JOB(MTC4010) JOBD(MBATCH) JOBQ(MTJOBQ) +      /*110242*/
/*************            RTGDTA(*JOBD) RQSDTA('CALL MTC4010') */     /*110242*/
/************SBMJOB     JOB(MTC4010) JOBD(MBATCH) JOBQ(MTJOBQ) +                          /*CPK014*/
/************             RTGDTA(*JOBD) RQSDTA('CALL MTC4010') +                          /*CPK014*/
/************             INLLIBL(*JOBD)                              /*110242*/          /*CPK014*/
/************SBMJOB     JOB(MTC4010) JOBD(MBATCH) JOBQ(MTJOBQ) +                          /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +                        /*CSC023*/
/************             MTC4010') INLLIBL(*JOBD)                             /*CPK014*/ /*CSC023*/
             SBMJOB     JOB(MTC4010) JOBD(MBATCH) JOBQ(MTJOBQ) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                          MTC4010') INLLIBL(*JOBD) OUTQ(*JOBD)                            /*CSC023*/
 
             GOTO       CMDLBL(ENDPGM)
 
/* Abnormal termination processing */
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
 
             SNDPGMMSG  MSG('Program MTC4011 ended abnormally') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000)
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
