/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Rep last sucs. trans on primy m/c')          */
/*********************************************************************/
/*                                                                   */
/*        Midas - System Control Module                              */
/*                                                                   */
/*       SDC1775 - Control call to SDC1774                           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC023             Date 02Feb04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CPK014             Date 14Nov01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      107317             Date 21MAY96              */
/*                      081177             DATE 15DEC94              */
/*                      E29436             DATE  11OCT91             */
/*                      E20391             DATE  26NOV89             */
/*                      E13205             DATE  14/02/89            */
/*                                                                   */
/*********************************************************************/
/*       New program overview                                        */
/*                                                                   */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       107317 - This pgm should be allowed to run in batch as well */
/*                as interactively. Remove the code which prevents   */
/*                pgm from running in batch.                         */
/*       081177 - Correct member text name                           */
/*       E29436 - MOVE TO SCCLSRC FROM RR.                           */
/*       E20391 - RTGDTA(*JOBD) ADDED TO ALL SBMJOB CMDS.            */                   /*E20391*/
/*       E13205 - Depending on parameter passed do the following     */
/*              a) Run SDC1774 interactively with switch 1 on        */
/*                 this rebuilds all *IMMED paths                    */
/*                 MODE = *INTERACT                                  */
/*                 OPTION = *IMMED                                   */
/*              b) Run SDC1774 interactively with switch 1 off       */
/*                 this rebuilds all unique paths                    */
/*                 MODE = *INTERACT                                  */
/*                 OPTION = *UNIQUE                                  */
/*              c) Submit SDC1774 to MEODQ via job description       */
/*                 MEODD with switch 1 off. This rebuilds all        */
/*                 unique paths.                                     */
/*                 MODE = *BATCH                                     */
/*                 OPTION = *UNIQUE                                  */
/*              d) Submit SDC1774 to MEODQ via job description       */
/*                 MEODD with switch 1 on. This rebuilds all         */
/*                 paths and updates the file SD1724 with new        */
/*                 logicals.                                         */
/*                 MODE = *BATCH                                     */
/*                 OPTION = *ALL                                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE &OPTION)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/*           Declare variables                                       */
/**/
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(9)
             DCL        VAR(&OPTION) TYPE(*CHAR) LEN(7)
             DCL        VAR(&INT_ACT) TYPE(*CHAR) LEN(1)
/**/
/*           Global Monitor message                                  */
/**/
             MONMSG     MSGID(MCH0000 CPF0000) EXEC(GOTO CMDLBL(ABNOR))
/**/
             RTVJOBA    TYPE(&INT_ACT)
/**/
/************Check program environment                             */ /*107317*/
/************IF         COND(&INT_ACT *EQ '0') THEN(DO)            */ /*107317*/
/************SNDPGMMSG  MSGID(CPF9898) MSGF(QSYS/QCPFMSG) +        */ /*107317*/
/************             MSGDTA('Program can only be run +        */ /*107317*/
/************             interactively') TOMSGQ(MOPERQ MRUNQ)     */ /*107317*/
/************GOTO       CMDLBL(ABNOR)                              */ /*107317*/
/************ENDDO                                                 */ /*107317*/
/**/
/*           Check parameters passed                                 */
/**/
/**/
/*           Check that mode is correct                              */
/**/
             IF         COND((&MODE *NE '*BATCH') *AND +
                             (&MODE *NE '*INTERACT')) THEN(DO)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QSYS/QCPFMSG) +
                          MSGDTA('Mode parameter must be either +
                          "*BATCH" or "*INTERACT"')
             GOTO       CMDLBL(ABNOR)
             ENDDO
             ELSE       CMD(DO)
/**/
/*           Check that option is correct                            */
/**/
             IF         COND((&OPTION *NE '*UNIQUE') *AND +
                             (&OPTION *NE '*IMMED')  *AND +
                             (&OPTION *NE '*ALL'))   THEN(DO)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QSYS/QCPFMSG) +
                          MSGDTA('Option parameter must be either +
                          "*UNIQUE", "*IMMED" or "*ALL"')
             GOTO       CMDLBL(ABNOR)
             ENDDO
             ENDDO
/**/
/*           If *BATCH then only unique and all allowed              */
/**/
             IF         COND(&MODE *EQ '*BATCH') THEN(DO)
             IF         COND((&OPTION *NE '*UNIQUE') *AND +
                             (&OPTION *NE '*ALL'))   THEN(DO)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QSYS/QCPFMSG) +
                          MSGDTA('Option parameter must be either +
                          "*UNIQUE" or "*ALL" for mode "*BATCH"')
             GOTO       CMDLBL(ABNOR)
             ENDDO
             ENDDO
/**/
/*           If *INTERACT then unique and immediates only            */
/**/
             IF         COND(&MODE *EQ '*INTERACT') THEN(DO)
             IF         COND((&OPTION *NE '*UNIQUE') *AND +
                             (&OPTION *NE '*IMMED'))   THEN(DO)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QSYS/QCPFMSG) +
                          MSGDTA('Option parameter must be either +
                          "*UNIQUE" or "*IMMED" for mode "*INTERACT"')
             GOTO       CMDLBL(ABNOR)
             ENDDO
             ENDDO
/**/
/**/
             IF         COND((&MODE *EQ '*INTERACT') *AND +
                             (&OPTION *EQ '*UNIQUE')) THEN(DO)
             CHGJOB     SWS(0XXXXXXX)
             SNDPGMMSG  MSG('Rebuild all unique access paths') +
                          TOMSGQ(MRUNQ)
             CALL       PGM(SDC1774)
             ENDDO
/**/
             IF         COND((&MODE *EQ '*INTERACT') *AND +
                             (&OPTION *EQ '*IMMED')) THEN(DO)
             CHGJOB     SWS(1XXXXXXX)
             SNDPGMMSG  MSG('Rebuild all Immediate access paths') +
                          TOMSGQ(MRUNQ)
             CALL       PGM(SDC1774)
             ENDDO
/**/
             IF         COND((&MODE *EQ '*BATCH') *AND +
                             (&OPTION *EQ '*UNIQUE')) THEN(DO)
             SNDPGMMSG  MSG('Submit job to rebuild unique access +
                          paths') TOPGMQ(*PRV) TOMSGQ(MRUNQ)
/************SBMJOB     JOB(RBLD_FILES) JOBD(MEODD) JOBQ(MEODQ) +                         /*CPK014*/
/************             RQSDTA('Call SDC1774') INLLIBL(*JOBD) +                         /*CPK014*/
/************             SWS(00000000) MSGQ(MOPERQ) RTGDTA(*JOBD)    /*E20391*/          /*CPK014*/
/***********              SWS(00000000) MSGQ(MOPERQ)                  /*E20391*/
/************SBMJOB     JOB(RBLD_FILES) JOBD(MEODD) JOBQ(MEODQ) +                         /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +                        /*CSC023*/
/************             SDC1774') INLLIBL(*JOBD) SWS(00000000) +                        /*CSC023*/
/************             MSGQ(MOPERQ)                                         /*CPK014*/ /*CPK014*/
             SBMJOB     JOB(RBLD_FILES) JOBD(MEODD) JOBQ(MEODQ) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                          SDC1774') INLLIBL(*JOBD) SWS(00000000) +
                          MSGQ(MOPERQ) OUTQ(*JOBD)                                        /*CSC023*/
             ENDDO
/**/
             IF         COND((&MODE *EQ '*BATCH') *AND +
                             (&OPTION *EQ '*ALL')) THEN(DO)
             SNDPGMMSG  MSG('Submit job to rebuild all access +
                          paths') TOPGMQ(*PRV) TOMSGQ(MRUNQ)
/************SBMJOB     JOB(RBLD_FILES) JOBD(MEODD) JOBQ(MEODQ) +                         /*CPK014*/
/************             RQSDTA('Call SDC1774') INLLIBL(*JOBD) +                         /*CPK014*/
/************             SWS(10000000) MSGQ(MOPERQ) RTGDTA(*JOBD)    /*E20391*/          /*CPK014*/
/***********              SWS(10000000) MSGQ(MOPERQ)                  /*E20391*/
/************SBMJOB     JOB(RBLD_FILES) JOBD(MEODD) JOBQ(MEODQ) +                         /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +                        /*CSC023*/
/************             SDC1774') INLLIBL(*JOBD) SWS(10000000) +                        /*CSC023*/
/************             MSGQ(MOPERQ)                                         /*CPK014*/ /*CSC023*/
             SBMJOB     JOB(RBLD_FILES) JOBD(MEODD) JOBQ(MEODQ) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                          SDC1774') INLLIBL(*JOBD) SWS(10000000) +
                          MSGQ(MOPERQ) OUTQ(*JOBD)                                        /*CSC023*/
             ENDDO
/**/
             GOTO       CMDLBL(END)
/**/
 ABNOR:      SNDPGMMSG  MSG('PROGRAM SDC1775 - Control call to +
                          SDC1775  - ENDED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
END:         ENDPGM
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
