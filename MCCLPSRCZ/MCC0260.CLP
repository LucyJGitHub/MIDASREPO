/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MC Select groups for update control')           */
/*********************************************************************/
/*                                                                   */
/*   Midas - Management Accounts Module                              */
/*                                                                   */
/*   MCC0260 - Select Groups for Update Control                      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC023             Date 30Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CPK014             Date 14Nov01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      110242             DATE 07NOV96              */
/*                      052428             DATE 18MAR93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*   110242 - Change defaults for SBMJOB cmd to take *JOBD           */
/*   052428 - Submit Jobs to a separate JOBQ                         */
/*                                                                   */
/*********************************************************************/
 
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&GROUPCODE) TYPE(*CHAR) LEN(2) /* Group +
                          Code */
             DCL        VAR(&RETURNCODE) TYPE(*CHAR) LEN(1) /* +
                          Return Code */
 
/* Global error message                                              */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/* Call the Periodic drop program                                    */
             CALL       PGM(MC0260) PARM(&GROUPCODE &RETURNCODE)
 
/* If F3 is pressed, &RETURNCODE is set to 'Y', so no batch jobs     */
/* will be submitted, otherwise the following processing is run      */
             IF         COND(&RETURNCODE *NE 'Y') THEN(DO)
 
             SNDMSG     MSG('MIDAS') TOMSGQ(MSTATUS)
 
/* If update for a single Group Code is requested submit MCC0264     */
/************IF         COND(&GROUPCODE *NE '  ') THEN(SBMJOB +       /*052428*/
/************             CMD(CALL PGM(MCC0264) PARM(&GROUPCODE)) +   /*052428*/
/************             JOB(MCC0264) JOBD(MBATCH) JOBQ(MICJOBQ))    /*052428*/
/************IF         COND(&GROUPCODE *NE '  ') THEN(SBMJOB +       /*110242*/
/*************            CMD(CALL PGM(MCC0264) PARM(&GROUPCODE)) +   /*110242*/
/*************       JOB(MCC0264) JOBD(MBATCH) JOBQ(RCJOBQ))   /*052428 110242*/
/************IF         COND(&GROUPCODE *NE '  ') THEN(SBMJOB +                           /*CPK014*/
/************             CMD(CALL PGM(MCC0264) PARM(&GROUPCODE)) +                       /*CPK014*/
/************             JOB(MCC0264) JOBD(MBATCH) JOBQ(RCJOBQ) +                        /*CPK014*/
/************             RTGDTA(*JOBD) INLLIBL(*JOBD))               /*110242*/          /*CPK014*/
/************IF         COND(&GROUPCODE *NE '  ') THEN(SBMJOB +                           /*CSC023*/
/************             CMD(CALL PGM(MCC0264) PARM(&GROUPCODE)) +                       /*CSC023*/
/************             JOB(MCC0264) JOBD(MBATCH) JOBQ(RCJOBQ) +                        /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) INLLIBL(*JOBD))            /*CPK014*/ /*CSC023*/
             IF         COND(&GROUPCODE *NE '  ') THEN(SBMJOB +
                          CMD(CALL PGM(MCC0264) PARM(&GROUPCODE)) +
                          JOB(MCC0264) JOBD(MBATCH) JOBQ(RCJOBQ) +
                          USER(*JOBD) RTGDTA(*JOBD) INLLIBL(*JOBD) +
                          OUTQ(*JOBD))                                                    /*CSC023*/
 
/* Otherwise                                                         */
/* If update for all Group Codes is requested submit MCC0265         */
/************                                                         /*052428*/
/************IF         COND(&GROUPCODE *EQ '  ') THEN(SBMJOB +       /*052428*/
/************             CMD(CALL PGM(MCC0265)) JOB(MCC0265) +       /*052428*/
/************             JOBD(MBATCH) JOBQ(MICJOBQ))                 /*052428*/
/************IF         COND(&GROUPCODE *EQ '  ') THEN(SBMJOB +       /*110242*/
/*************            CMD(CALL PGM(MCC0265)) JOB(MCC0265) +       /*110242*/
/*************            JOBD(MBATCH) JOBQ(RCJOBQ))           /*052428 110242*/
/************IF         COND(&GROUPCODE *EQ '  ') THEN(SBMJOB +                           /*CPK014*/
/************             CMD(CALL PGM(MCC0265)) JOB(MCC0265) +                           /*CPK014*/
/************             JOBD(MBATCH) JOBQ(RCJOBQ) RTGDTA(*JOBD) +                       /*CPK014*/
/************             INLLIBL(*JOBD))                             /*110242*/          /*CPK014*/
/************IF         COND(&GROUPCODE *EQ '  ') THEN(SBMJOB +                           /*CSC023*/
/************             CMD(CALL PGM(MCC0265)) JOB(MCC0265) +                           /*CSC023*/
/************             JOBD(MBATCH) JOBQ(RCJOBQ) USER(*JOBD) +                         /*CSC023*/
/************             RTGDTA(*JOBD) INLLIBL(*JOBD))                        /*CPK014*/ /*CSC023*/
             IF         COND(&GROUPCODE *EQ '  ') THEN(SBMJOB +
                          CMD(CALL PGM(MCC0265)) JOB(MCC0265) +
                          JOBD(MBATCH) JOBQ(RCJOBQ) USER(*JOBD) +
                          RTGDTA(*JOBD) INLLIBL(*JOBD) OUTQ(*JOBD))                       /*CSC023*/
 
/* Must remove the MIDAS after processing has run                    */
/************SBMJOB     CMD(CALL PGM(MIDASRMV)) JOB(MIDASRMV) +       /*052428*/
/************             JOBD(MBATCH) JOBQ(MICJOBQ)                  /*052428*/
/************SBMJOB     CMD(CALL PGM(MIDASRMV)) JOB(MIDASRMV) +       /*110242*/
/*************            JOBD(MBATCH) JOBQ(RCJOBQ) */         /*052428 110242*/
/************SBMJOB     CMD(CALL PGM(MIDASRMV)) JOB(MIDASRMV) +                           /*CPK014*/
/************             JOBD(MBATCH) JOBQ(RCJOBQ) RTGDTA(*JOBD) +                       /*CPK014*/
/************             INLLIBL(*JOBD)                              /*110242*/          /*CPK014*/
/************SBMJOB     CMD(CALL PGM(MIDASRMV)) JOB(MIDASRMV) +                           /*CSC023*/
/************             JOBD(MBATCH) JOBQ(RCJOBQ) USER(*JOBD) +                         /*CSC023*/
/************             RTGDTA(*JOBD) INLLIBL(*JOBD)                         /*CPK014*/ /*CSC023*/
             SBMJOB     CMD(CALL PGM(MIDASRMV)) JOB(MIDASRMV) +
                          JOBD(MBATCH) JOBQ(RCJOBQ) USER(*JOBD) +
                          RTGDTA(*JOBD) INLLIBL(*JOBD) OUTQ(*JOBD)                        /*CSC023*/
 
/* ENDDO of processing run if F3 is not taken                        */
             ENDDO
 
             GOTO       CMDLBL(ENDPGM)
 
 ERROR:      SNDPGMMSG  MSG('Select Groups for Update Control ENDED +
                          ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
ENDPGM:      ENDPGM
