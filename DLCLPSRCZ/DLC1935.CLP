/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL IR Swap Rates Maintenance')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - FRA/IRS Module                                      */
/*                                                                   */
/*       DLC1935 - SWAP RATES MAINTENANCE                            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC023             Date 29Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 110242             Date 07Nov96              */
/*                      CIR001             Date 13Jun95              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       110242 - Change defaults for SBMJOB cmd to take *JOBD       */
/*    CIR001 - Interest Rate Calendars                               */
/*                                                                   */
/*********************************************************************/
/**/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/**/
/* Monitor for any errors and send appropriate message to external */
/* program message queue */
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO ERROR)
/**/
/* Call Swap Rates Maintenance program  */
             CALL       PGM(DL1935)
/**/
/* Monitor for database error and send appropriate message to MOPERQ */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ)
               GOTO       CMDLBL(ERROR)
             ENDDO
/**/
             GOTO       CMDLBL(END)
/**/
ERROR:       SNDPGMMSG MSG('Transaction failed. Re-input necessary. +
                              Enter to continue.') TOPGMQ(*EXT)
             ROLLBACK
 
             RETURN
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
END:
 /* Submit job to recalculate IRS Discount Factors */
               SNDPGMMSG MSG('MIDAS') TOMSGQ(MSTATUS)
/************* SBMJOB     JOB(DLC1965) JOBD(MBATCH) USER(*JOBD) +     /*110242*/
/*************            RQSDTA('CALL DLC1965') INLLIBL(*JOBD) +     /*110242*/
/*************            MSGQ(MOPERQ) */                             /*110242*/
/************  SBMJOB     JOB(DLC1965) JOBD(MBATCH) USER(*JOBD) +                         /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL DLC1965') +                          /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(MOPERQ)                 /*110242*/          /*CSC023*/
               SBMJOB     JOB(DLC1965) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL DLC1965') +
                          INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                         /*CSC023*/
/************  SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +                        /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +                         /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(MOPERQ)                                     /*CSC023*/
               SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
                          INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                         /*CSC023*/
             ENDPGM
