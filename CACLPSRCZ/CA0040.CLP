/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CA Control deal num gen - interactive')         */
/*********************************************************************/
/*                                                                   */
/*   Midas - Common Applications                             */
/*                                                                   */
/*   CA0040 - CONTROL DEAL NUMBER GENERATION - INTERACTIVE           */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC022             Date 24Feb04              */
/*                      CSC023             Date 29Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      173661             Date 17Aug00              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                  E35736            DATE 06FEB92                   */
/*                  S01319            DATE 03DEC91                   */
/*                  E20773            DATE 05NOV90                   */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*       MD046248 - Finastra Rebranding                              */
/*       CSC022 - Commitment Control Changes for MidasPlus           */
/*    CSC023  - MidasPlus additional packaging.  SBMJOB change.      */
/*              OUTQ must always be *JOBD.                           */
/*    173661 -  Deals were allowed to be rolledover twice due to     */
/*              ROLBK command clearing the lock status of the record.*/
/*    E35736  - Job Description MEODD changed to MBATCH because      */
/*              MEODD does not have a User name.                     */
/*    S01319  - Job queue FOJOBQ and job description FOJOBD no       */
/*              longer used.                                         */
/*    E20773  - Defaults changed on SBMJOB to INLLIBL(*CURRENT)      */
/*              & RTGDTA(QCMDB) so do not need to set up INLLIBL     */
/*              using RTVJOBA and QCAEXEC anymore. Also  RTGDTA      */
/*              needs to be specified as *JOBD.                      */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&TERM)
             DCL        VAR(&SCCMTJOB) TYPE(*CHAR) LEN(256)                               /*CSC022*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*CSC022*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CSC022*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                                      /*CSC022*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CSC022*/
             DCL        VAR(&CSC022) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CSC022*/
             DCL        VAR(&CMTNUM) TYPE(*DEC) LEN(3 0)                                  /*CSC022*/
             DCL        VAR(&CMTJOB1) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB2) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB3) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB4) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB5) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB6) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB7) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB8) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB9) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB10) TYPE(*CHAR) LEN(10)                                /*CSC022*/
             DCL        VAR(&JOBNAME) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTSKP) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CSC022*/
/**  DECLARE TERMINATION VARIABLE                                    */
             DCL        VAR(&TERM) TYPE(*CHAR) LEN(1)
 
/**  DECLARE VARIABLE TO HOLD INITIAL LIBRARY LIST                   */
/**********  DCL        VAR(&INLIBL) TYPE(*CHAR) LEN(275)          */ /*E20773*/
 
/**  DECLARE VARIABLE TO HOLD SBMJOB COMMAND INSTRUCTIONS            */
/**********  DCL        VAR(&VAR) TYPE(*CHAR) LEN(512)             */ /*E20773*/
/**********  DCL    VAR(&LEN) TYPE(*DEC) LEN(15 5) VALUE(512)      */ /*E20773*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/**/
/**  GLOBAL MONMSG                                                   */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR))
 
             CHGVAR     VAR(&CSC022) VALUE(' ')                                           /*CSC022*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CSC022*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CSC022*/
             CHGVAR     VAR(&SAR) VALUE('CSC022')                                         /*CSC022*/
                                                                                          /*CSC022*/
             CHGJOB     SWS(XXXXXX00)                                                     /*CSC022*/
                                                                                          /*CSC022*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CSC022*/
                                                                                          /*CSC022*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*CSC022*/
                 CHGVAR     VAR(&CSC022) VALUE('Y')                                       /*CSC022*/
             RTVDTAARA  DTAARA(SCCMTJOB (1 256)) RTNVAR(&SCCMTJOB)                        /*CSC022*/
             CHGVAR     VAR(&CMTNUM) VALUE(%SST(&SCCMTJOB 1 3))                           /*CSC022*/
             CHGVAR     VAR(&CMTJOB1) VALUE(%SST(&SCCMTJOB 4 10))                         /*CSC022*/
             CHGVAR     VAR(&CMTJOB2) VALUE(%SST(&SCCMTJOB 14 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB3) VALUE(%SST(&SCCMTJOB 24 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB4) VALUE(%SST(&SCCMTJOB 34 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB5) VALUE(%SST(&SCCMTJOB 44 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB6) VALUE(%SST(&SCCMTJOB 54 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB7) VALUE(%SST(&SCCMTJOB 64 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB8) VALUE(%SST(&SCCMTJOB 74 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB9) VALUE(%SST(&SCCMTJOB 84 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB10) VALUE(%SST(&SCCMTJOB 94 10))                       /*CSC022*/
                                                                                          /*CSC022*/
             RTVJOBA    JOB(&JOBNAME)                                                     /*CSC022*/
             IF         COND((&CMTNUM *GT 0) *AND (&CMTJOB1 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 1) *AND (&CMTJOB2 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 2) *AND (&CMTJOB3 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 3) *AND (&CMTJOB4 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 4) *AND (&CMTJOB5 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 5) *AND (&CMTJOB6 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 6) *AND (&CMTJOB7 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 7) *AND (&CMTJOB8 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 8) *AND (&CMTJOB9 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 9) *AND (&CMTJOB10 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
                                                                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
                                                                                          /*CSC022*/
/**/
/**  ATTEMPT TO ALLOCATE DEAL NUMBER REGENERATION PROGRAM            */
             ALCOBJ     OBJ((CA0050 *PGM *EXCL)) WAIT(0)
             MONMSG     MSGID(CPF1002) EXEC(DO)
                GOTO    CMDLBL(END)
             ENDDO
 
/**/
/**  OVERRIDE FILE FXNDLNPP                                          */
             OVRDBF     FILE(CANDLNLL) WAITRCD(*IMMED)
 
/**/
/**  CALL THE DEAL NUMBER GENERATION PROGRAM TO CREATE 10 DEAL       */
/**  NUMBERS                                                         */
/*/COPY WNCPYSRC,CA0040001                                           */
             CALL       PGM(CA0050) PARM(&TERM X'0000010F')
             MONMSG     MSGID(CPF0000) EXEC(DO)
                GOTO    CMDLBL(ERROR)
             ENDDO
 
/**/
/**  IF ERROR IS FOUND ON DEAL NUMBER GENERATION PROGRAM, END        */
/**  THIS PROGRAM                                                    */
             IF         COND(%SWITCH(XXXXX1XX)) THEN(DO)
                GOTO       CMDLBL(END)
             ENDDO
 
/**/
/**  SUBMIT DEAL NUMBER GENERATION PROGRAM TO BATCH                  */
/**********  RTVJOBA    USRLIBL(&INLIBL)                           */ /*E20773*/
/**********  CHGVAR     VAR(&VAR) VALUE('SBMJOB JOB(DLNOGEN) + */
/**********               JOBD(FOJOBD) USER(*JOBD) JOBQ(FOJOBQ) + */
/**********               RQSDTA(''CALL CA0060'') MSGQ(*NONE) + */
/**********               INLLIBL(' || &INLIBL |< ')') */
/************SBMJOB*****JOB(DLNOGEN) JOBD(FOJOBD) JOBQ(FOJOBQ) +
/***********************  USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
/***********************  CA0060') INLLIBL(*CURRENT) MSGQ(*NONE) /* +
/***********************  E20773 */                                   /*S01319*/
/************SBMJOB*****JOB(DLNOGEN) JOBD(MEODD) JOBQ(MEODQ) +
/***********************  USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
/***********************  CA0060') INLLIBL(*CURRENT) MSGQ(*NONE) /* +
/***********************  S01319 */                                   /*E35736*/
/************SBMJOB     JOB(DLNOGEN) JOBD(MBATCH) JOBQ(MEODQ) +                           /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +                        /*CSC023*/
/************             CA0060') INLLIBL(*CURRENT) MSGQ(*NONE)      /*E35736*/          /*CSC023*/
             SBMJOB     JOB(DLNOGEN) JOBD(MBATCH) JOBQ(MEODQ) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                          CA0060') INLLIBL(*CURRENT) MSGQ(*NONE) OUTQ(*JOBD)              /*CSC023*/
 
/**********  CALL       PGM(QCAEXEC) PARM(&VAR &LEN)               */ /*E20773*/
 
             GOTO       CMDLBL(END)
 
/**/
/**  HANDLE ERROR PROCESSING                                         */
 ERROR:
             CHGDTAARA  DTAARA(*LDA (171 10)) VALUE('CA0040')
             CHGDTAARA  DTAARA(*LDA (181 3)) VALUE('991')
             DMPCLPGM
             MONMSG     MSGID(CPF0000)
             CHGJOB     SWS(XXXXX1XX)
             CHGVAR     VAR(&TERM) VALUE('E')
             IF         COND(&CSC022 *NE 'Y') THEN(DO)                                    /*CSC022*/
             ROLLBACK                                                 /*173661*/
             MONMSG     MSGID(CPF0000)
             ENDDO                                                                        /*CSC022*/
             ELSE       CMD(DO)                                                           /*CSC022*/
             IF         COND(&CMTSKP *NE 'Y') THEN(DO)                                    /*CSC022*/
             ROLLBACK                                                                     /*CSC022*/
             MONMSG     MSGID(CPF0000)                                                    /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ELSE       CMD(DO)                                                           /*CSC022*/
             CHGJOB     SWS(XXXXXX11)                                                     /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ENDDO                                                                        /*CSC022*/
 
/**/
/**  DEALLOCATE DEAL NUMBER GENERATION PROGRAM AND END THIS PROGRAM  */
 END:
             DLCOBJ     OBJ((CA0050 *PGM *EXCL))
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
 
