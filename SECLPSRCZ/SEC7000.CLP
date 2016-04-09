/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Market migration control')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Securities Trading Module                       */
/*                                                                   */
/*       SEC7000- SECURITY MARKET MIGRATION - CONTROL COMPONENT      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*      Last Amend No.  CSC022             Date 24Feb04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*      Prev Amend No.  CAP137             Date 07Feb00              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CSE015             Date 06Dec99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01511  *CREATE    Date 10Aug94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CSC022 - Commitment Control Changes for MidasPlus           */
/*       CAP137 - Conversion of SE Security inputs into modular      */
/*                structure to use as APIs.                          */
/*       CSE015 - Forward Valued Depot Movements                     */
/*       S01511 - Market Migration                                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SECURITY &MARKET &RTN)
 
 /*  DECLARE VARIABLES */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SECURITY) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MARKET) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&DOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&SRTCD) TYPE(*CHAR) LEN(7)                /*CAP137*/
             DCL        VAR(&SOPTN) TYPE(*CHAR) LEN(7)                /*CAP137*/
             DCL        VAR(&SSARD) TYPE(*CHAR) LEN(6)                /*CAP137*/
             DCL        VAR(&SSCSARD) TYPE(*CHAR) LEN(200)            /*CAP137*/
             DCL        VAR(&CAP137) TYPE(*CHAR) LEN(1)               /*CAP137*/
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
 
 /*  SET-UP 'DM' LIB STRING */
 
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR     VAR(&DOLIB) VALUE(&PRE *TCAT 'DMLIB')
 
/* SET OFF SWITCHES AND MONITOR MESSAGES                            */
 
             CHGJOB     SWS(00000000)
             MONMSG     MSGID(CPF0000)
                                                                                          /*CSC022*/
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
                                                                      /*CAP137*/
/** Check if CAP137 Switchable Feature is on.                         /*CAP137*/
                                                                      /*CAP137*/
             CHGVAR     VAR(&CAP137) VALUE('N')                       /*CAP137*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                  /*CAP137*/
             CHGVAR     VAR(&SSARD) VALUE('CAP137')                   /*CAP137*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                          &SSCSARD)                                   /*CAP137*/
             IF         COND(&SRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP137) VALUE('Y'))                    /*CAP137*/
 
/*  CALL PROGRAMS IN TURN TO UPDATE EACH FILE  */
/*---------------------------------------------*/
 
 /*  TRADSD FILE */
 
             CALL       PGM(SEC7001) PARM(&SECURITY &MARKET &DOLIB)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ERRORP)
 
 /*  SOBTRD FILE */
 
             CALL       PGM(SEC7002) PARM(&SECURITY &MARKET &DOLIB)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ERRORP)
 
 /*  BULKTD FILE */
 
             CALL       PGM(SEC7012) PARM(&SECURITY &MARKET &DOLIB)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ERRORP)
 
 /*  BKMTHD FILE */
 
             CALL       PGM(SEC7003) PARM(&SECURITY &MARKET &DOLIB)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ERRORP)
 
 /*  BKPHHD FILE */
 
             CALL       PGM(SEC7004) PARM(&SECURITY &MARKET &DOLIB)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ERRORP)
 
 /*  BKPHDD FILE */
 
             CALL       PGM(SEC7005) PARM(&SECURITY &MARKET &DOLIB)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ERRORP)
 
 /*  BKPOSD FILE */
 
             CALL       PGM(SEC7006) PARM(&SECURITY &MARKET &DOLIB)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ERRORP)
 
 /*  BPACHD FILE */
 
             CALL       PGM(SEC7007) PARM(&SECURITY &MARKET &DOLIB)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ERRORP)
 
 /*  CDEPPD FILE */
 
             CALL       PGM(SEC7008) PARM(&SECURITY &MARKET &DOLIB)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ERRORP)
 
 /*  SETLED FILE */
 
             CALL       PGM(SEC7010) PARM(&SECURITY &MARKET &DOLIB)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ERRORP)
 
 /*  UDEPPD FILE */
 
             CALL       PGM(SEC7011) PARM(&SECURITY &MARKET &DOLIB)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ERRORP)
 
 /*  DPTMVD FILE */
 
             CALL       PGM(SEC7013) PARM(&SECURITY &MARKET &DOLIB)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ERRORP)
 
 /*  ATPRPD FILE */
 
             CALL       PGM(SEC7014) PARM(&SECURITY &MARKET &DOLIB)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ERRORP)
 
 /*  CNCTRD FILE */
 
             CALL       PGM(SEC7015) PARM(&SECURITY &MARKET &DOLIB)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ERRORP)
 
 /*  TRATXD FILE */
 
             CALL       PGM(SEC7016) PARM(&SECURITY &MARKET &DOLIB)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ERRORP)
 
 /*  SEPCBD FILE */
 
             CALL       PGM(SEC7017) PARM(&SECURITY &MARKET &DOLIB)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ERRORP)
 
 /* SOBDMVD  FILE */                                                  /*CSE015*/
                                                                      /*CSE015*/
             CALL       PGM(SEC7018) PARM(&SECURITY &MARKET &DOLIB)   /*CSE015*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ERRORP)     /*CSE015*/
                                                                      /*CSE015*/
ERRORP:
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                CHGVAR  VAR(&RTN) VALUE('1')
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)
                CHGVAR    VAR(&MEM) VALUE('SEC7000  - Database Error')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
                IF         COND(&CSC022 *NE 'Y') THEN(DO)                                 /*CSC022*/
                  ROLLBACK
/**********     CHGJOB     SWS(00000000) */                                               /*CSC022*/
                ENDDO                                                                     /*CSC022*/
                ELSE       CMD(DO)                                                        /*CSC022*/
                IF         COND(&CMTSKP *NE 'Y') THEN(DO)                                 /*CSC022*/
                  ROLLBACK                                                                /*CSC022*/
                ENDDO                                                                     /*CSC022*/
                ELSE       CMD(DO)                                                        /*CSC022*/
                  CHGJOB     SWS(XXXXXX11)                                                /*CSC022*/
                ENDDO                                                                     /*CSC022*/
                ENDDO                                                                     /*CSC022*/
             ENDDO
             ELSE       CMD(DO)
                IF  COND(&CAP137 *EQ 'N') THEN(DO)                    /*CAP137*/
                  IF  COND((&CSC022 *NE 'Y') *OR ((&CSC022 *EQ +
                          'Y') *AND (&CMTSKP *NE 'Y'))) THEN(DO)                          /*CSC022*/
                    COMMIT
                  ENDDO                                                                   /*CSC022*/
                ENDDO                                                 /*CAP137*/
                 CHGVAR  VAR(&MEM) +
                         VALUE('SEC7000 - Market Migration +
                                          COMPLETED NORMALLY')
                 SNDPGMMSG MSG(&MEM) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
