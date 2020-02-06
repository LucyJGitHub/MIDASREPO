/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE EXTEL transmission check')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Securities Trading Module                       */
/*                                                                   */
/*       SEC3109A  -  EXTEL TRANSMISSION CHECK                       */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 02Feb04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01502             Date 12Dec94              */
/*                      077466            DATE  17OCT94              */
/*                      S01117            DATE  10JAN91              */
/*                      E20718            DATE  16JAN90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       S01502 - BLI Telekurs Processing.                           */
/*                SESTAT increased in length from 128 to 133 bytes   */
/*       077466 - ABNOR PROCESSING ADDED TO ALLOW CONTROLLED         */
/*                FAILURE PROCESSING IN COB.                         */
/*       S01117 - MULTIBRANCHING                                     */
/*       E20718 - ADD EXTRA PARMS, RTGDTA(*JOBD),                    */ /*E20718*/
/*                INLLIBL(*JOBD) TO SBMJOB COMMAND.                  */ /*E20718*/
/*       **** REQUIRED FOR AS400 ONLY, DEFAULTS OK FOR S/38 ****     */ /*E20718*/
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
      DCL    &EXST        *CHAR      1         /* EXTEL status                */
      DCL    &MNTF        *CHAR      1         /* Maintenance flag            */
/************DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(128)  /*077466*/ /*S01502*/
             DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(133)             /*S01502*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*077466*/
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ABNOR))       /*077466*/
                                                                      /*077466*/
/* If EXTEL is present check transmission link */                     /*077466*/
                                                                      /*077466*/
             RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)                /*077466*/
                                                                      /*077466*/
             IF         COND(%SUBSTRING(&SESTAT 63 1) *NE 'Y') +
                          THEN(DO)                                    /*077466*/
                GOTO       CMDLBL(ENDPGM)                             /*077466*/
             ENDDO                                                    /*077466*/
                                                                      /*077466*/
/*    The job queue EXTELJOBQ has been created to have 1 active job.   +
                                                                       +
       As the transmission reception has also been submitted to the    +
       same job queue the updates will not be carried out until the    +
       transmission has completed.                                     */
 
/*  Set flag so maintenance program may not be run                     */
 
        CHGDTAARA  DTAARA(EXSTAT (146 1)) VALUE(Y)
 
/*  Skip if link & updates have finished                               +
    Status will also be F if reception not requested                   +
     or EXTEL not on system                                            */
 
        RTVDTAARA   DTAARA(EXSTAT (76 1))   RTNVAR(&EXST)
 
        IF         COND(&EXST *EQ 'F')   THEN(GOTO ENDPGM)
 
/*  Submit job to job queue EXTELJOBQ                                  */
 
/*******SBMJOB     JOB(SEC3104) JOBD(EXTELJOBD) JOBQ(MEODQ) +      */ /*E20718*/
/***********        RQSDTA('CALL SEC3104  ''       ''') MSGQ(MOPERQ)/ /*E20718*/
/************SBMJOB     JOB(SEC3104) JOBD(EXTELJOBD) JOBQ(MEODQ) +                        /*CPK014*/
/************             RTGDTA(*JOBD) RQSDTA('CALL SEC3104  +                           /*CPK014*/
/************             ''       ''') INLLIBL(*JOBD) MSGQ(MOPERQ)                       /*CPK014*/
/*                                                                    /*E20718*/
/************SBMJOB     JOB(SEC3104) JOBD(EXTELJOBD) JOBQ(MEODQ) +                        /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +                        /*CSC023*/
/************             SEC3104  ''       ''') INLLIBL(*JOBD) +                         /*CSC023*/
/************             MSGQ(MOPERQ)                                                    /*CSC023*/
 
             SBMJOB     JOB(SEC3104) JOBD(EXTELJOBD) JOBQ(MEODQ) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                          SEC3104  ''       ''') INLLIBL(*JOBD) +
                          MSGQ(MOPERQ) OUTQ(*JOBD)                                        /*CSC023*/
 
/*  Display Monitor                                                    */
 
        CALL SEC3109
 
/* Check for database error */                                        /*077466*/
                                                                      /*077466*/
             IF         COND(%SWITCH(XXXXX000) *EQ '0') THEN(GOTO +
                          CMDLBL(DBETAG))                             /*077466*/
                                                                      /*077466*/
             GOTO       CMDLBL(ENDPGM)                                /*077466*/
                                                                      /*077466*/
DBETAG:                                                               /*077466*/
/* Retrieve database error information from LDA */                    /*077466*/
                                                                      /*077466*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*077466*/
               RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)           /*077466*/
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                            TOMSGQ(MOPERQ)                            /*077466*/
             ENDDO                                                    /*077466*/
                                                                      /*077466*/
 ABNOR:                                                               /*077466*/
/* Abnormal termination processing */                                 /*077466*/
                                                                      /*077466*/
             CHGJOB     SWS(XXXXXX11)                                 /*077466*/
             MONMSG     MSGID(CPF0000)                                /*077466*/
                                                                      /*077466*/
             SNDPGMMSG  MSG('Program SEC3109A ended abnormally') +
                          TOMSGQ(MOPERQ)                              /*077466*/
             MONMSG     MSGID(CPF0000)                                /*077466*/
 
/*ENDPGM:*****ENDPGM                                                 * *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01117*/
