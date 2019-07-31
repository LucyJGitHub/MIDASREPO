/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas AO Next loan number locking prevention CL')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Access Objects                                      */
/*                                                                   */
/*       AOCLENO0 - (Next loan number locking prevention CL)         */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD021780           Date 08Aug13              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      257968             Date 28Nov08              */
/*                      257126             Date 10Oct08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSC022             Date 24Feb04              */
/*                      CAP084  *CREATE    Date 14Nov02              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD021780 - AOLENOU0 Performance Issue                       */
/*       257968 - Fix commitment control, U7 U8 logic error, and     */
/*                remove banned characters. Reverse fix 257126.      */
/*       257126 - API LELOAN is looping                              */
/*       CSC022 - Commitment Control Changes for MidasPlus           */
/*       CAP084 - Midas Plus API development                         */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&INOUT &RETCODE)
 
/*/COPY WNCPYSRC,AOCLENOINT                                          */
 
             DCL        VAR(&JBNM) TYPE(*CHAR) LEN(10)                                    /*CSC022*/
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')
             DCL        VAR(&INOUT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RETCODE) TYPE(*CHAR) LEN(5)
/**********  DCL        VAR(&RTNCD) TYPE(*CHAR) LEN(7)               */          /*CSC022 MD021780*/
             DCL        VAR(&SCCMTJOB) TYPE(*CHAR) LEN(256)                               /*CSC022*/
/**********  DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                */          /*CSC022 MD021780*/
/**********  DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                 */          /*CSC022 MD021780*/
/**********  DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)            */          /*CSC022 MD021780*/
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
             DCL        VAR(&CMTSKP) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CSC022*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
             CHGVAR     VAR(&RETCODE) VALUE('     ')
                                                                                          /*CSC022*/
/**********  CHGVAR     VAR(&CSC022) VALUE(' ')                      */          /*CSC022 MD021780*/
/**********  CHGVAR     VAR(&RTNCD) VALUE('       ')                 */          /*CSC022 MD021780*/
/**********  CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                  */          /*CSC022 MD021780*/
/**********  CHGVAR     VAR(&SAR) VALUE('CSC022')                    */          /*CSC022 MD021780*/
/*********************************************************************/          /*CSC022 MD021780*/
/**********  CALL       PGM(AOSARDR0) PARM(&RTNCD &OPTN &SAR &SCSARD)*/          /*CSC022 MD021780*/
/*********************************************************************/          /*CSC022 MD021780*/
/**********  IF         COND(&RTNCD *EQ '       ') THEN(DO)          */          /*CSC022 MD021780*/
             CHGVAR     VAR(&CSC022) VALUE('Y')                                           /*CSC022*/
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
             RTVJOBA    JOB(&JBNM)                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 0) *AND (&CMTJOB1 *EQ +
                          &JBNM)) THEN(DO)                                                /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             GOTO ENDTEST                                                                 /*257968*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 1) *AND (&CMTJOB2 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             GOTO ENDTEST                                                                 /*257968*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 2) *AND (&CMTJOB3 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             GOTO ENDTEST                                                                 /*257968*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 3) *AND (&CMTJOB4 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             GOTO ENDTEST                                                                 /*257968*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 4) *AND (&CMTJOB5 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             GOTO ENDTEST                                                                 /*257968*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 5) *AND (&CMTJOB6 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             GOTO ENDTEST                                                                 /*257968*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 6) *AND (&CMTJOB7 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             GOTO ENDTEST                                                                 /*257968*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 7) *AND (&CMTJOB8 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             GOTO ENDTEST                                                                 /*257968*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 8) *AND (&CMTJOB9 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             GOTO ENDTEST                                                                 /*257968*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 9) *AND (&CMTJOB10 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             GOTO ENDTEST                                                                 /*257968*/
             ENDDO                                                                        /*CSC022*/
                                                                                          /*CSC022*/
ENDTEST:                                                                                  /*257968*/
/**********  ENDDO                                                   */          /*CSC022 MD021780*/
 
 
/*/COPY WNCPYSRC,AOCLENOMPS                                          */
 
/**********  IF         COND(&INOUT = 'I') THEN(DO)                                        *257968*/
             IF         COND(&INOUT *EQ 'I') THEN(DO)                                     /*257968*/
                ALCOBJ     OBJ((AOLENDO *DTAARA *EXCL)) WAIT(10)
                MONMSG     MSGID(CPF1002) EXEC(DO)
                   CHGVAR     VAR(&RETCODE) VALUE('*LOCK')
                   GOTO       CMDLBL(END)
                   SNDPGMMSG  MSG('UNABLE TO ALLOCATE AN EXCLUSIVE LOAN +
                                NUMBER IN AOCLENO0')
                ENDDO
            ENDDO
 
/********** IF          COND(&INOUT = 'O') THEN(DO)                                        *257968*/
            IF         COND(&INOUT *EQ 'O') THEN(DO)                                      /*257968*/
               DLCOBJ     OBJ((AOLENDO *DTAARA *EXCL))
            ENDDO
 
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             IF         COND(&CSC022 *NE 'Y') THEN(DO)                                    /*CSC022*/
                ROLLBACK
/**********  ENDDO                                                              /*CSC022****257968*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
/**********     GOTO       CMDLBL(END)                                                    /*257968*/
                GOTO       CMDLBL(ABNOR)                                                  /*257968*/
             ENDDO
             ELSE       CMD(DO)                                                           /*CSC022*/
             IF         COND(&CMTSKP *NE 'Y') THEN(DO)                                    /*CSC022*/
/* Start of 257126 */                                                                     /*257126*/
/**********  ROLLBACK */                                                       /*CSC022*/ /*257126*/
/**********  MONMSG     MSGID(CPF8350) */                                      /*CSC022*/ /*257126*/
/* End   of 257126 */                                                                     /*257126*/
/* Start of 257968 */                                                                     /*257968*/
             ROLLBACK                                                                     /*257968*/
             MONMSG     MSGID(CPF8350)                                                    /*257968*/
/* End   of 257968 */                                                                     /*257968*/
             ENDDO                                                                        /*CSC022*/
             ELSE       CMD(DO)                                                           /*CSC022*/
             CHGJOB     SWS(XXXXXX11)                                                     /*CSC022*/
             GOTO       CMDLBL(ABNOR)                                                     /*257968*/
             ENDDO                                                                        /*257968*/
             ENDDO                                                                        /*CSC022*/
             ENDDO                                                                        /*CSC022*/
 
/*/COPY WNCPYSRC,AOCLENOMPE                                          */
 
             GOTO       CMDLBL(END)
 
ABNOR:
/*/COPY WNCPYSRC,AOCLENOERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
/**********  IF         COND(&JOBTYPE = '0') THEN(DO)                                      *257968*/
             IF         COND(&JOBTYPE *EQ '0') THEN(DO)                                   /*257968*/
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            AOCLENO ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
/* Abnormal termination - interactive job */
 
/**********  IF         COND(&JOBTYPE = '1') THEN(DO)                                      *257968*/
             IF         COND(&JOBTYPE *EQ '1') THEN(DO)                                   /*257968*/
 
             ENDDO
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,AOCLENOEND                                          */
 
             ENDPGM
