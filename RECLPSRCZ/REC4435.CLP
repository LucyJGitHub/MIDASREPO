/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE CI background task indicator')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail  Module                                      */
/*                                                                   */
/*       REC4435 - CI Background Task Initiator                      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 30Jan04              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      208846             Date 29Aug02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      164801             Date 01Jul99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      118134             Date 02Jun97              */
/*                      CRT003  *CREATE    Date 22JUL96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       208846 - Limit the submitted RE41220* jobs to a maximum     */
/*                of 5.                                              */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       164801 - Submitted jobs should use INLLIBL(*JOBD)           */
/*                not INLLIBL(*CURRENT)                              */
/*       118134 - Correct ABNOR processing to ensure termination.    */
/*       CRT003 - Cashier Interface                                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PGML &JOBD &JOBQ)
 
             DCL        VAR(&PGML)   TYPE(*CHAR) LEN(60)
             DCL        VAR(&PGMN)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PARM)   TYPE(*CHAR) LEN(50)
             DCL        VAR(&JOBD)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBQ)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPX)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&PNO)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&PCL)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&PRFX)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&XLIB)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&MEM)    TYPE(*CHAR) LEN(50)
             DCL        VAR(&CMD)    TYPE(*CHAR) LEN(80)
             DCL        VAR(&JOBSRUNJE) TYPE(*DEC) LEN(3 0)                               /*208846*/
             DCL        VAR(&JOBSRUNJF) TYPE(*DEC) LEN(3 0)                               /*208846*/
             DCL        VAR(&JOBSRUN0E) TYPE(*DEC) LEN(3 0)                               /*208846*/
             DCL        VAR(&JOBSRUN0F) TYPE(*DEC) LEN(3 0)                               /*208846*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Map the pgm name and the parameter to be used */
 
             CHGVAR     VAR(&PGMN) VALUE(%SST(&PGML 1 10))
             CHGVAR     VAR(&PARM) VALUE(%SST(&PGML 11 50))
 
/* Build the equivalent CL pgm */
 
             CHGVAR     VAR(&PPX)  VALUE(%SST(&PGMN 1 2))
             CHGVAR     VAR(&PNO)  VALUE(%SST(&PGMN 3 4))
             CHGVAR     VAR(&PCL)  VALUE(&PPX *CAT 'C' *CAT &PNO)
/**/
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)
               CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             ENDDO
 
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRFX)
             CHGVAR     VAR(&XLIB) VALUE(&PRFX *CAT 'XLIB')
             CHGVAR     VAR(&CMD) VALUE('CALL ' *CAT &PCL *CAT +
                          ' PARM(' *CAT &PARM *CAT ')')
 
/* Check to see if the maximum number of jobs are running already */                      /*208846*/
/* if the job is RE41220JE.                                       */                      /*208846*/
                                                                                          /*208846*/
             IF         COND(&PGMN *EQ 'RE41220JE') THEN(DO)                              /*208846*/
                RTVDTAARA  DTAARA(RE41220JE) RTNVAR(&JOBSRUNJE)                           /*208846*/
                IF         COND(&JOBSRUNJE *GE 5) THEN(GOTO +
                             CMDLBL(END))                                                 /*208846*/
                CHGVAR     VAR(&JOBSRUNJE) VALUE(&JOBSRUNJE + 1)                          /*208846*/
                CHGDTAARA  DTAARA(RE41220JE) VALUE(&JOBSRUNJE)                            /*208846*/
             ENDDO                                                                        /*208846*/
                                                                                          /*208846*/
/* Check to see if the maximum number of jobs are running already */                      /*208846*/
/* if the job is RE41220JF.                                       */                      /*208846*/
                                                                                          /*208846*/
             IF         COND(&PGMN *EQ 'RE41220JF') THEN(DO)                              /*208846*/
                RTVDTAARA  DTAARA(RE41220JF) RTNVAR(&JOBSRUNJF)                           /*208846*/
                IF         COND(&JOBSRUNJF *GE 5) THEN(GOTO +
                             CMDLBL(END))                                                 /*208846*/
                CHGVAR     VAR(&JOBSRUNJF) VALUE(&JOBSRUNJF + 1)                          /*208846*/
                CHGDTAARA  DTAARA(RE41220JF) VALUE(&JOBSRUNJF)                            /*208846*/
             ENDDO                                                                        /*208846*/
                                                                                          /*208846*/
/* Check to see if the maximum number of jobs are running already */                      /*208846*/
/* if the job is RE412200E.                                       */                      /*208846*/
                                                                                          /*208846*/
             IF         COND(&PGMN *EQ 'RE412200E') THEN(DO)                              /*208846*/
                RTVDTAARA  DTAARA(RE412200E) RTNVAR(&JOBSRUN0E)                           /*208846*/
                IF         COND(&JOBSRUN0E *GE 5) THEN(GOTO +
                             CMDLBL(END))                                                 /*208846*/
                CHGVAR     VAR(&JOBSRUN0E) VALUE(&JOBSRUN0E + 1)                          /*208846*/
                CHGDTAARA  DTAARA(RE412200E) VALUE(&JOBSRUN0E)                            /*208846*/
             ENDDO                                                                        /*208846*/
                                                                                          /*208846*/
/* Check to see if the maximum number of jobs are running already */                      /*208846*/
/* if the job is RE412200F.                                       */                      /*208846*/
                                                                                          /*208846*/
             IF         COND(&PGMN *EQ 'RE412200F') THEN(DO)                              /*208846*/
                RTVDTAARA  DTAARA(RE412200F) RTNVAR(&JOBSRUN0F)                           /*208846*/
                IF         COND(&JOBSRUN0F *GE 5) THEN(GOTO +
                             CMDLBL(END))                                                 /*208846*/
                CHGVAR     VAR(&JOBSRUN0F) VALUE(&JOBSRUN0F + 1)                          /*208846*/
                CHGDTAARA  DTAARA(RE412200F) VALUE(&JOBSRUN0F)                            /*208846*/
             ENDDO                                                                        /*208846*/
                                                                                          /*208846*/
/* Call the pgm */
 
/**********  SBMJOB     JOB(&PGMN) JOBD(&XLIB/&JOBD) +   **/          /*164801*/
/**********               JOBQ(&XLIB/&JOBQ) RQSDTA(&CMD) **/          /*164801*/
/************SBMJOB     JOB(&PGMN) JOBD(&XLIB/&JOBD) +                                    /*CPK014*/
/************           JOBQ(&XLIB/&JOBQ) RQSDTA(&CMD) INLLIBL(*JOBD) /*164801*/          /*CPK014*/
/************SBMJOB     JOB(&PGMN) JOBD(&XLIB/&JOBD) +                                    /*CSC023*/
/************             JOBQ(&XLIB/&JOBQ) USER(*JOBD) +                                 /*CSC023*/
/************             RQSDTA(&CMD) INLLIBL(*JOBD)                          /*CPK014*/ /*CSC023*/
             SBMJOB     JOB(&PGMN) JOBD(&XLIB/&JOBD) +
                          JOBQ(&XLIB/&JOBQ) USER(*JOBD) +
                          RQSDTA(&CMD) INLLIBL(*JOBD) OUTQ(*JOBD)                         /*CSC023*/
 
/*    Database error processing                                      */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
               SNDPGMMSG  MSGID(MEM0001) MSGF(GBMIDAS) MSGDTA(&MEM) +
                            TOMSGQ(MOPERQ MRUNQ)
               SNDPGMMSG  MSG('REC4435 ended abnormally - see +
                            joblog') TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:      CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('CI Background Task Initiator Ended +
                          Abnormally') TOMSGQ(MOPERQ MRUNQ)
             MONMSG  MSGID(CPF2469)  EXEC(DO)                         /*118134*/
                SNDPGMMSG  MSG('CI Background Task Initiator Ended +
                          Abnormally') TOMSGQ(QSYSOPR)                /*118134*/
             ENDDO                                                    /*118134*/
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
