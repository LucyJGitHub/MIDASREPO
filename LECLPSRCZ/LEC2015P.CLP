/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Loan Manager i/c bulk transfer prompt')      */
/********************************************************************/
/*                                                                  */
/*  Midas   - Customer Lending Module                               */
/*                                                                  */
/*  LEC2015P - Lending I/C Bulk Transfer Prompt                     */
/*                                                                  */
/*  Function:  To call the Lending Bulk transfer prompt LE2015P and */
/*             if selected to submit the Input Cycle download of    */
/*             the latest details of the Customer Lending Master    */
/*             files and/or the Standing Data master files to the   */
/*             PC file server.                                      */
/*                                                                  */
/*  Calls:     LE2015P                                              */
/*                                                                  */
/*  Submits Job: LEC2015A                                           */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC023             Date 29Jan04              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*       Prev Amend No. 203561             Date 17Jun02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      193083             Date 26Jul01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                 CLE004  *CREATE   DATE  18APR97                  */
/*                                                                  */
/********************************************************************/
/*                                                                   */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*  203561 - Change parameters as MQM is not needed by LE2015       */
/*  193083 - Tidy up the ABNOR processing                           */
/*  CLE004 - Customer Lending Enhancements - Syndications.          */
/*                                                                  */
/********************************************************************/
             PGM
 
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1) VALUE('L')
             DCL        VAR(&SERV) TYPE(*CHAR) LEN(3)                                     /*203561*/
             DCL        VAR(&BRCH) TYPE(*CHAR) LEN(3)
/**********  DCL        VAR(&MQM) TYPE(*CHAR) LEN(10) */                                  /*203561*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&DBER) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)                                 /*193083*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/**/
/**  Global Monitor Message:                                         */
/**   If an unmonitorred message occurs perform error processing     */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(00000000)
 
/**********  CALL       PGM(LE2015P) PARM(&MODE &BRCH &MQM) */                            /*203561*/
             CALL       PGM(LE2015P) PARM(&MODE &SERV &BRCH)                              /*203561*/
 
/**/
/*    Error processing                                               */
/*    Retrieve LDA and store values                                  */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR     VAR(&DBER) VALUE(%SST(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DBER) +
                           TOMSGQ(MOPERQ MRUNQ)
             ENDDO
             ELSE       CMD(DO)
 
                IF         COND(&MODE *NE ' ') THEN(DO)
/**********  SBMJOB     CMD(CALL PGM(LEC2015A) PARM(&MODE &BRCH + */                      /*203561*/
/**********               &MQM)) JOB(LEC2015A) JOBD(MBATCH) +     */                      /*203561*/
/**********               JOBQ(TSJOBQ) USER(*JOBD) +              */                      /*203561*/
/**********               RTGDTA('PCLENDING') MSGQ(*NONE)         */                      /*203561*/
                                                                                          /*203561*/
/************      SBMJOB     CMD(CALL PGM(LEC2015A) PARM(&MODE &SERV &BRCH)) +           /*CSC023*/
/************                JOB(LEC2015A) JOBD(MBATCH) +                                 /*CSC023*/
/************                JOBQ(TSJOBQ) USER(*JOBD) +                                   /*CSC023*/
/************                RTGDTA('PCLENDING') MSGQ(*NONE)                   /*203561*/ /*CSC023*/
 
                   SBMJOB     CMD(CALL PGM(LEC2015A) PARM(&MODE &SERV &BRCH)) +
                             JOB(LEC2015A) JOBD(MBATCH) +
                             JOBQ(TSJOBQ) USER(*JOBD) +
                             RTGDTA('PCLENDING') MSGQ(*NONE) OUTQ(*JOBD)                  /*CSC023*/
                ENDDO
             ENDDO
 
             GOTO       CMDLBL(END)
 
/*     Abnormal termination                                          */
 ABNOR:
/************CHGJOB     SWS(XXXXXX11) */
/************SNDPGMMSG  MSG('Lending PC Bulk Transfer Process has + */                    /*193083*/
/************             ENDED ABNORMALLY') TOMSGQ(MOPERQ MRUNQ) */                      /*193083*/
             SNDPGMMSG  MSG('Lending PC I/C Bulk Transfer Process has +
                          ENDED ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)                         /*193083*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
                                                                                          /*193083*/
/* Call SCC0010 to inform the user that an error has occurred */                          /*193083*/
                                                                                          /*193083*/
             RTVMSG     MSGID(SCM0087) MSGF(GBMIDASMSG) MSG(&MESSAGE)                     /*193083*/
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*193083*/
                                                                                          /*193083*/
             CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)                         /*193083*/
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*193083*/
                                                                                          /*193083*/
             CALL       PGM(SCC0010) PARM('LEC2015P' 'ENTER' ' ')                         /*193083*/
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*193083*/
 
/*     Normal termination                                            */
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
