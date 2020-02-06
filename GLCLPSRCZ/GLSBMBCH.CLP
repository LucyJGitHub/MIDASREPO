/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Submit Accepted Batch')                      */
/********************************************************************/
/*                                                                  */
/*        Midas     - General Ledger Module                     */
/*                                                                  */
/*       GLSBMBCH - SUBMIT JOURNAL ENTRY JOBS                       */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. 260259             Date 14May09              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      245635             Date 13Feb07              */
/*                      241672A            Date 09Jan07              */
/*                      245631             Date 12Feb07              */
/*                      243716             Date 17Nov06              */
/*                      BUG13062           Date 18Jan07              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      241672             Date 28Aug06              */
/*                      BUG12386           Date 04Nov06              */
/*                      239155             Date 31May06              */
/*                      236197             Date 29Sep05              */
/*                      CRE020             Date 20Jan04              */
/*                      211296             Date 09Apr03              */
/* Midas Release 4.01 -----------------------------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      E36493             Date 27Feb92              */
/*                      S01340             Date 20Sep91              */
/*                     E23416      DATE - 10SEP90                   */
/*                     E20994      DATE - 01FEB90                   */
/*                     E20722      DATE - 08JAN90                   */
/*                     E17482      DATE - 10/05/89                  */
/*                     E17598      DATE - 26/01/89                  */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       260259 - Batch acceptance delay problem. Fix is to          */
/*                sbmjob GLC445 to MIDASJOBQ and removed MIDASRMV.   */
/*       245635 - Move SBMJOB of REC0880 to GLC445.                 */
/*       241672A- REC0800 in MSGW due to locked record in GLJENHL0.  */
/*       245631 - Submitted GLC445 in same JOBQ that REC0880 (MICJOBQ)*/
/*       243716 - Remove fix 241672 to prevent locking GLJENHL0.     */
/*              - annotated as BUG13062                              */
/*       BUG13062 - Apply core fix 243716                           */
/*       241672 - Complete job GLC445 before processing REC0880.     */
/*       BUG12386 - Change JOBQ from GLBITJOBQ to MIDASJOBQ.        */
/*       239155 - (Reopen) GLC445 should be submitted to GLBITJOBQ. */
/*                JOBQ NOW MIDASJOBQ AS PER CORE MANAGEMENT.        */
/*                Fix already catered by fix 236197.                */
/*       236197 - Amend 211296 as it is affecting other jobs in      */
/*                queue MICJOBQ when GLC445 is in message wait.      */
/*       CRE020 - Midas Plus Online Printing of Advices (GE7)        */
/*       211296 - Retail advices not generated for some batches.    */
/*       E36493 - OUTQ PARAMETER ON SUBMITS MUST BE *JOBD           */
/*       S01340 - MIS RELEASE 10 CHANGES - MESSAGE MISLEADING SINCE *  *E23416*/
/*                REAL-TIME POSTING INTRODUCED.                     *  *E23416*/
/*       E23416 - PROGRAM SHOULD CHECK FOR INTEREST ON ACCOUNTS     *  *E23416*/
/*                AS WELL AS RETAIL2                                *  *E23416*/
/*       E20994 - BATCH NUMBER FOR JOURNAL ENTRY IS NOW A CHARACTER ** *E20994*/
/*                FIELD                                             ** *E20994*/
/*       E20722 - RTGDTA(*JOBD) AND INLLIBL(*JOBD) ADDED TO ALL     ** *E20722*/
/*                SBMJOB COMMANDS                                   ** *E20722*/
/*       E17482  - BATCH NUMBER IS INPUT AS ZONED NOT PACKED FIELD  *  *E17482*/
/*                 ALSO, PARAMETERS STILL PASSED INCORRECTLY.       *  *E17482*/
/*       E17598  - PARAMETERS , JOB NAME & SNDMSG INCORRECT         *  *E17598*/
/*                                                                  */
/********************************************************************/
 
/*           PGM        PARM(&RTCD &BNUM)                              *E20994*/
/*/COPY WNCPYSRC,GLSBMBCH04                                          */
             PGM        PARM(&RTCD &BNUMA)                            /*E20994*/
/*/COPY WNCPYSRC,GLSBMBCH05                                          */
 
 
/* Declare variables :                                          */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
 
             DCL        VAR(&RTCD)    TYPE(*CHAR) LEN(7)
/*           DCL        VAR(&BNUM)    TYPE(*DEC)  LEN(3)       *E17482**E20994*/
/*           DCL        VAR(&BNUM)    TYPE(*DEC)  LEN(3 0)             *E17482*/
             DCL        VAR(&RETAIL2) TYPE(*CHAR) LEN(1)              /*S01154*/
             DCL        VAR(&IOA)     TYPE(*CHAR) LEN(1)              /*E23416*/
             DCL        VAR(&WRKSTN)  TYPE(*CHAR) LEN(10)             /*S01154*/
             DCL        VAR(&BNUMA)   TYPE(*CHAR) LEN(3)              /*E17598*/
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)                                    /*CRE020*/
             DCL        VAR(&POPTN) TYPE(*CHAR) LEN(7)                                    /*CRE020*/
             DCL        VAR(&PSARD) TYPE(*CHAR) LEN(6)                                    /*CRE020*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CRE020*/
             DCL        VAR(&CRE020) TYPE(*CHAR) LEN(1)                                   /*CRE020*/
/**********  DCL        VAR(&GLC445) TYPE(*CHAR) LEN(1)                          /*241672 BUG13062*/
/**********  DCL        VAR(&CONT) TYPE(*CHAR) LEN(1)                            /*241672 BUG13062*/
/*/COPY WNCPYSRC,GLSBMBCH01                                          */
 
/* Global message monitor :                                     */
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(TAGEND))
                                                                                         /*241672A*/
             SNDPGMMSG  MSG('GLSBMBCH - Submit journal entry +
                          jobs for batch ' *BCAT &BNUMA) TOMSGQ(MRUNQ)                   /*241672A*/
                                                                                          /*CRE020*/
/* Check if CRE020 is enabled. */                                                         /*CRE020*/
                                                                                          /*CRE020*/
             CHGVAR     VAR(&PRTCD) VALUE('       ')                                      /*CRE020*/
             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')                                      /*CRE020*/
             CHGVAR     VAR(&PSARD) VALUE('CRE020')                                       /*CRE020*/
             CHGVAR     VAR(&CRE020) VALUE('N')                                           /*CRE020*/
                                                                                          /*CRE020*/
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD &SCSARD)                  /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&PRTCD *EQ '       ') THEN(DO)                               /*CRE020*/
             CHGVAR     VAR(&CRE020) VALUE('Y')                                           /*CRE020*/
             ENDDO                                                                        /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&PRTCD *NE '       ' *AND +
                             &PRTCD *NE '*NRF   ') THEN(DO)                               /*CRE020*/
             DMPCLPGM                                                                     /*CRE020*/
             GOTO       CMDLBL(PGMEND)                                                    /*CRE020*/
             ENDDO                                                                        /*CRE020*/
 
/* Get the current job name so that errors can be sent to user  */    /*S01154*/
                                                                      /*S01154*/
             RTVJOBA    JOB(&WRKSTN) /*S01154*/
 
/* Send msg to prevent COB taking place during the batch job    */    /*S01154*/
                                                                      /*S01154*/
             SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)                  /*S01154*/
                                                                      /*S01154*/
/* Submit the Posting job :                                     */    /*S01154*/
/*                                                                      E17598*/
/*           SNDPGMMSG  MSGID(USR1000) MSGF(GLUSRMSG) TOPGMQ(*EXT) +  /*S01340*/
/*                        MSGTYPE(*STATUS)                 /*E17598*/ /*S01340*/
                                                                      /*S01154*/
/*           CHGVAR     VAR(&BNUMA) VALUE(&BNUM)        */    /*E17598**E20994*/
/*/COPY WNCPYSRC,GLSBMBCH02                                          */
/**********  SBMJOB     JOB(GLC445) JOBD(MBATCH) OUTQ(*JOBD) +                            /*211296*/
/**********               USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +                        /*211296*/
/**********               GLC445 PARM(''' *CAT &BNUMA *CAT ''' ''' +                      /*211296*/
/**********               *CAT &WRKSTN *TCAT ''')') INLLIBL(*JOBD) +                      /*211296*/
/**********               MSGQ(MOPERQ)                                         /*E36493*/ /*211296*/
/**********  SBMJOB     JOB(GLC445) JOBD(MBATCH) JOBQ(MICJOBQ) +                          /*236197*/
/**********               OUTQ(*JOBD) USER(*JOBD) RTGDTA(*JOBD) +                         /*236197*/
/**********               RQSDTA('CALL GLC445 PARM(''' *CAT &BNUMA +                      /*236197*/
/**********               *CAT ''' ''' *CAT &WRKSTN *TCAT ''')') +                        /*236197*/
/**********               INLLIBL(*JOBD) MSGQ(MOPERQ)                              /*211296 236197*/
/**********  SBMJOB     JOB(GLC445) JOBD(MBATCH) JOBQ(GLBITJOBQ) +                      /*BUG12386*/
/**********               OUTQ(*JOBD) USER(*JOBD) RTGDTA(*JOBD) +                       /*BUG12386*/
/**********               RQSDTA('CALL GLC445 PARM(''' *CAT &BNUMA +                    /*BUG12386*/
/**********               *CAT ''' ''' *CAT &WRKSTN *TCAT ''')') +                      /*BUG12386*/
/**********               INLLIBL(*JOBD) MSGQ(MOPERQ)                            /*236197 BUG12386*/
/**********  CHGDTAARA DTAARA(GLC0445 (1 1)) VALUE('R')                          /*241672 BUG13062*/
/**********  SBMJOB     JOB(GLC445) JOBD(MBATCH) JOBQ(MIDASJOBQ) +           */           /*245631*/
/**********               OUTQ(*JOBD) USER(*JOBD) RTGDTA(*JOBD) +            */           /*245631*/
/**********               RQSDTA('CALL GLC445 PARM(''' *CAT &BNUMA +         */           /*245631*/
/**********               *CAT ''' ''' *CAT &WRKSTN *TCAT ''')') +           */           /*245631*/
/**********               INLLIBL(*JOBD) MSGQ(MOPERQ)                        */  /*BUG12386 245631*/
/**********  SBMJOB     JOB(GLC445) JOBD(MBATCH) JOBQ(MICJOBQ) +     */                   /*260259*/
/**********               OUTQ(*JOBD) USER(*JOBD) RTGDTA(*JOBD) +    */                   /*260259*/
/**********               RQSDTA('CALL GLC445 PARM(''' *CAT &BNUMA + */                   /*260259*/
/**********               *CAT ''' ''' *CAT &WRKSTN *TCAT ''')') +   */                   /*260259*/
/**********               INLLIBL(*JOBD) MSGQ(MOPERQ)                */            /*245631 260259*/
             SBMJOB     JOB(GLC445) JOBD(MBATCH) JOBQ(MIDASJOBQ) +
                          OUTQ(*JOBD) USER(*JOBD) RTGDTA(*JOBD) +
                          RQSDTA('CALL GLC445 PARM(''' *CAT &BNUMA +
                          *CAT ''' ''' *CAT &WRKSTN *TCAT ''')') +
                          INLLIBL(*JOBD) MSGQ(MOPERQ)                                     /*260259*/
/*/COPY WNCPYSRC,GLSBMBCH03                                          */
/*           SBMJOB     JOB(GLC445) JOBD(MBATCH) USER(*JOBD) +        /*E36493*/
/*                        RTGDTA(*JOBD) RQSDTA('CALL GLC445 PARM(''' +/*E36493*/
/*                        *CAT &BNUMA *CAT ''' ''' *CAT &WRKSTN *TCAT /*E36493*/
/*                        ''')') INLLIBL(*JOBD) MSGQ(MOPERQ)  *E20722  *E36493*/
/*           SBMJOB     JOB(GLC445) JOBD(MBATCH) USER(*JOBD) +        /*E20722*/
/*                        RQSDTA('CALL GLC445 PARM(''' *CAT &BNUMA +  /*E20722*/
/*                        *CAT ''' ''' *CAT &WRKSTN *TCAT ''')') +    /*E20722*/
/*                        MSGQ(MOPERQ) /*E17482*/                     /*E20722*/
/*           SBMJOB     JOB(GLC445) JOBD(MBATCH) USER(*JOBD) +          E17482*/
/*                        RQSDTA('CALL GLC445 PARM(' *CAT &BNUMA +      E17482*/
/*                        *BCAT &WRKSTN *TCAT ')') MSGQ(MOPERQ) *E17598*E17482*/
/*           SBMJOB     JOB(GLC4445) JOBD(MBATCH) USER(*JOBD) +         E17598*/
/*                        RQSDTA('CALL GLC445 PARM(&BNUM &WRKSTN)') +   E17598*/
/*                        MSGQ(MOPERQ) /*S01154*/                     /*E17598*/
                                                                      /*S01154*/
/* Submit the Retail advices print if retail present            */    /*S01154*/
/* and the online printing of advices is disabled.              */                        /*CRE020*/
                                                                      /*S01154*/
             RTVDTAARA  DTAARA(MMOD (16 1)) RTNVAR(&RETAIL2)          /*S01154*/
             RTVDTAARA  DTAARA(MMOD (23 1)) RTNVAR(&IOA)              /*E23416*/
/**********  RTVDTAARA  DTAARA(GLC0445 (1 1)) RTNVAR(&GLC445)                    /*241672 BUG13062*/
/**********  IF         COND(&GLC445 *EQ 'R') THEN(DO)                           /*241672 BUG13062*/
/**********  CHGDTAARA  DTAARA(GLC0445 (2 1)) VALUE('R')                         /*241672 BUG13062*/
/**********  ENDDO                                                               /*241672 BUG13062*/
/**********  IF         COND(&RETAIL2 *EQ 'Y')  THEN(DO)      /*S01154**E23416*/
/**********  IF         COND((&RETAIL2 *EQ 'Y') *OR (&IOA *EQ 'Y')) +              /*E23416 CRE020*/
/**********               THEN(DO)                                                 /*E23416 CRE020*/
                                                                                          /*245635*/
/** Move call of REC0880 to GLC445 */                                                     /*245635*/
/** Used GOTO to retain original code just in case it is needed again */                  /*245635*/
                                                                                          /*245635*/
             GOTO       CMDLBL(SKIP88)                                                    /*245635*/
                                                                                          /*245635*/
             IF         COND((&RETAIL2 *EQ 'Y' *OR &IOA *EQ 'Y') *AND +
                              &CRE020 *EQ 'N') THEN(DO)                                   /*CRE020*/
                                                                      /*S01154*/
/**********  SBMJOB     JOB(REC0880) JOBD(MBATCH) OUTQ(*JOBD) +                           /*211296*/
/**********               USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +                        /*211296*/
/**********               REC0880 PARM(''' *CAT &BNUMA *CAT ''' ''' +                     /*211296*/
/**********               *CAT &WRKSTN *TCAT ''')') INLLIBL(*JOBD) +                      /*211296*/
/**********               MSGQ(MOPERQ)                                         /*E36493*/ /*211296*/
/*/COPY WNCPYSRC,GLSBMBCH06                                          */
/**Loop*until*GLC445*job*is*completed**/                                         /*241672 BUG13062*/
/**********  RTVDTAARA  DTAARA(GLC0445 (1 1)) RTNVAR(&GLC445)                    /*241672 BUG13062*/
/**********  IF         COND(&GLC445 *EQ 'R') THEN(DO)                           /*241672 BUG13062*/
/*GLC445:**                                                                      /*241672 BUG13062*/
/**********  RTVDTAARA  DTAARA(GLC0445 (2 1)) RTNVAR(&CONT)                      /*241672 BUG13062*/
/**********  IF         COND(&CONT *EQ 'R') THEN(DO)                             /*241672 BUG13062*/
/**********  DLYJOB     DLY(30)                                                  /*241672 BUG13062*/
/**********  GOTO       CMDLBL(GLC445)                                           /*241672 BUG13062*/
/**********  ENDDO                                                               /*241672 BUG13062*/
/**********  ENDDO                                                               /*241672 BUG13062*/
/**********                                                                      /*241672 BUG13062*/
/**********  SBMJOB     JOB(REC0880) JOBD(MBATCH) JOBQ(MICJOBQ) +                         /*236197*/
/**********               OUTQ(*JOBD) USER(*JOBD) RTGDTA(*JOBD) +                         /*236197*/
/**********               RQSDTA('CALL REC0880 PARM(''' *CAT &BNUMA +                     /*236197*/
/**********               *CAT ''' ''' *CAT &WRKSTN *TCAT ''')') +                        /*236197*/
/**********               INLLIBL(*JOBD) MSGQ(MOPERQ)                              /*211296 236197*/
/**********  SBMJOB     JOB(REC0880) JOBD(MBATCH) JOBQ(GLBITJOBQ) +                     /*BUG12386*/
/**********               OUTQ(*JOBD) USER(*JOBD) RTGDTA(*JOBD) +                       /*BUG12386*/
/**********               RQSDTA('CALL REC0880 PARM(''' *CAT &BNUMA +                   /*BUG12386*/
/**********               *CAT ''' ''' *CAT &WRKSTN *TCAT ''')') +                      /*BUG12386*/
/**********               INLLIBL(*JOBD) MSGQ(MOPERQ)                            /*236197 BUG12386*/
             SBMJOB     JOB(REC0880) JOBD(MBATCH) JOBQ(MIDASJOBQ) +
                          OUTQ(*JOBD) USER(*JOBD) RTGDTA(*JOBD) +
                          RQSDTA('CALL REC0880 PARM(''' *CAT &BNUMA +
                          *CAT ''' ''' *CAT &WRKSTN *TCAT ''')') +
                          INLLIBL(*JOBD) MSGQ(MOPERQ)                                   /*BUG12386*/
/*/COPY WNCPYSRC,GLSBMBCH08                                          */
/*           SBMJOB     JOB(REC0880) JOBD(MBATCH) USER(*JOBD) +       /*E36493*/
/*                        RTGDTA(*JOBD) RQSDTA('CALL REC0880 PARM(''' /*E36493*/
/*                        *CAT &BNUMA *CAT ''' ''' *CAT &WRKSTN *TCAT /*E36493*/
/*                        ''')') INLLIBL(*JOBD) MSGQ(MOPERQ)   /*E20722*E36493*/
/*           SBMJOB     JOB(REC0880) JOBD(MBATCH) USER(*JOBD) +      * *E20722*/
/*                        RQSDTA('CALL REC0880 PARM(''' *CAT &BNUMA +* *E20722*/
/*                        *CAT ''' ''' *CAT &WRKSTN *TCAT ''')') +   * *E20722*/
/*                        MSGQ(MOPERQ)                         /*E17482*E20722*/
/*           SBMJOB     JOB(REC0880) JOBD(MBATCH) USER(*JOBD) +         E17482*/
/*                        RQSDTA('CALL REC0880 PARM(' *CAT &BNUMA +     E17482*/
/*                        *BCAT &WRKSTN *TCAT ')') MSGQ(MOPERQ) E17598 *E17482*/
/*           SBMJOB     JOB(REC0880) JOBD(MBATCH) USER(*JOBD) +         E17598*/
/*                        RQSDTA('CALL REC0880 PARM(&BNUM &WRKSTN)') +  E17598*/
/*                        MSGQ(MOPERQ)                                /*E17598*/
             ENDDO                                                    /*S01154*/
                                                                      /*S01154*/
 SKIP88:                                                                                  /*245635*/
                                                                      /*S01154*/
/* submit job to clear 'MIDAS' from MSTATUS msgq                */    /*S01154*/
                                                                      /*S01154*/
/*/COPY WNCPYSRC,GLSBMBCH07                                          */
/**********  SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) OUTQ(*JOBD) +     */                   /*260259*/
/**********               USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +   */                   /*260259*/
/**********               MIDASRMV') INLLIBL(*JOBD) MSGQ(MOPERQ)     */            /*E36493 260259*/
/*/COPY WNCPYSRC,GLSBMBCH09                                          */
/*           SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +      /*E36493*/
/*                        RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +     /*E36493*/
/*                        INLLIBL(*JOBD) MSGQ(MOPERQ) /*S01154* E20722/*E36493*/
/*           SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +      /*E20722*/
/*                        RQSDTA('CALL MIDASRMV') MSGQ(MOPERQ)/*S01154**E20722*/
 
/* Submit the Posting job :                                     */
 
/*           SBMJOB     JOB(XXXXXXXXXX)                         */
/*           SNDPGMMSG  MSGID(USR1000) MSGF(GLUSRMSG) TOPGMQ(*EXT) +    E17598*/
/*                        MSGTYPE(*STATUS)                              E17598*/
                                                                                         /*241672A*/
             SNDPGMMSG  MSG('GLSBMBCH - Ended normally for batch ' +
                          *BCAT &BNUMA) TOMSGQ(MRUNQ)                                    /*241672A*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                   /*241672A*/
                                                                                         /*241672A*/
             GOTO       CMDLBL(PGMEND)
 TAGEND:
             SNDPGMMSG  MSG('Error in message handling program - +
                          contact System Supervisor')
                                                                                         /*241672A*/
             SNDPGMMSG  MSG('GLSBMBCH - Ended in error for batch ' +
                          *BCAT &BNUMA) TOMSGQ(MRUNQ MOPERQ)                             /*241672A*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                   /*241672A*/
 
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 PGMEND:     ENDPGM
