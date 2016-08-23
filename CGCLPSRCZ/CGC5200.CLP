/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG Print process driver control')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - User Defined Correspondence                     */
/*                                                                   */
/*       CGC5200  - Print Process Driver Control                     */
/*                                                                   */
/*       Function:  This program receives requests for prints, by    */
/*                  reading entries from a data queue and triggers   */
/*                  the production of the requested prints.          */
/*                                                                   */
/*                  The program runs continuously as a background    */
/*                  batch job.                                       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC022             Date 24Feb04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Prev Amend No. 175941             Date 29Dec00              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      154544             Date 05Oct99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      088008             Date 19May95              */
/*                      089152             Date 01May95              */
/*                      S01522             DATE 05DEC94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSC022 - Commitment Control Changes for MidasPlus           */
/*       175941 - Amend dtaara CGDTA to flag the field when          */
/*                UDC_PRTGEN has finished running.                   */
/*       154544 - Allocate CGUDCRL0 before calling CG5200 which      */
/*                calls CG3000 to avoid record locking with CG2000.  */
/*                Applied fix 151282.                                */
/*       088008 - Print last conf.                                   */
/*       089152 - Allow for extra Print Generators                   */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTN_CODE &DTQE)
/**/
/* Copyright statement defination  */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&DATA)        TYPE(*CHAR) LEN(50)
             DCL        VAR(&DTQE)        TYPE(*CHAR) LEN(50)
             DCL        VAR(&MBR_NAME)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&ACC_PATH)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTN_CODE)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&LAST_CNF)    TYPE(*CHAR) LEN(1)          /*088008*/
             DCL        VAR(&CTR) TYPE(*DEC) LEN(1 0) VALUE(0)        /*154544*/
/*/COPY WNCPYSRC,CGC5200005                                          */
/* */
/* Parameters received for RCF                                       */
/* */
             DCL        VAR(&RLVL)        TYPE(*CHAR) LEN(1)
             DCL        VAR(&RSEQ)        TYPE(*CHAR) LEN(5)
             DCL        VAR(&RBCH)        TYPE(*CHAR) LEN(3)
             DCL        VAR(&RARCH)       TYPE(*CHAR) LEN(1)
             DCL        VAR(&JOB_NAME) TYPE(*CHAR) LEN(10)            /*089152*/
             DCL        VAR(&NBR_BULKS) TYPE(*DEC) LEN(2 0)           /*089152*/
             DCL        VAR(&NBR_BULKA) TYPE(*CHAR) LEN(2)            /*089152*/
             DCL        VAR(&BULK_RECS) TYPE(*DEC) LEN(5 0)           /*089152*/
             DCL        VAR(&BULK_RECA) TYPE(*CHAR) LEN(5)            /*089152*/
             DCL        VAR(&NBR_RECS) TYPE(*DEC) LEN(10 0)           /*089152*/
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)                 /*089152*/
                                                                                          /*CSC022*/
             DCL        VAR(&JBNM) TYPE(*CHAR) LEN(10)                                    /*CSC022*/
             DCL        VAR(&SCCMTJOB) TYPE(*CHAR) LEN(256)                               /*CSC022*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CSC022*/
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)                                   /*CSC022*/
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
             DCL        VAR(&CRSKIP) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CSC022*/
                                                                                          /*CSC022*/
             CHGVAR     VAR(&CSC022) VALUE('N')                                           /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('N')                                           /*CSC022*/
             CHGVAR     VAR(&RTNCDE) VALUE('       ')                                     /*CSC022*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CSC022*/
             CHGVAR     VAR(&SAR) VALUE('CSC022')                                         /*CSC022*/
                                                                                          /*CSC022*/
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/**/
/*           Copyright statement definition - at runtime             */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 /**/                                                                                     /*CSC022*/
 /** Call AO Switchable features  */                                                      /*CSC022*/
 /**/                                                                                     /*CSC022*/
             CALL       PGM(AOSARDR0) PARM(&RTNCDE &OPTN &SAR &SCSARD)                    /*CSC022*/
                                                                                          /*CSC022*/
             IF         COND(&RTNCDE *EQ '       ') THEN(DO)                              /*CSC022*/
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
             IF         COND((&CMTNUM *GT 0) *AND (&CMTJOB1 *EQ +
                          &JBNM)) THEN(DO)                                                /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 1) *AND (&CMTJOB2 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 2) *AND (&CMTJOB3 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 3) *AND (&CMTJOB4 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 4) *AND (&CMTJOB5 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 5) *AND (&CMTJOB6 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 6) *AND (&CMTJOB7 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 7) *AND (&CMTJOB8 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 8) *AND (&CMTJOB9 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 9) *AND (&CMTJOB10 *EQ +
                          &JBNM))    THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CRSKIP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
                                                                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
/* */
/* CHGJOB switches */
/* */
             CHGJOB     SWS(XXXXXX00)
/* */
/* Retrieve the Member Name and Access Path from the Data Queue      */
/* entry.                                                            */
/* */
             CHGVAR     VAR(&MBR_NAME) VALUE(%SST(&DTQE 1 10))
             CHGVAR     VAR(&ACC_PATH) VALUE(%SST(&DTQE 11 10))
             CHGVAR     VAR(&RSEQ)     VALUE(%SST(&DTQE 21 5))
             CHGVAR     VAR(&RLVL)     VALUE(%SST(&DTQE 26 1))
             CHGVAR     VAR(&RBCH)     VALUE(%SST(&DTQE 27 3))
             CHGVAR     VAR(&RARCH)    VALUE(%SST(&DTQE 30 1))
             CHGVAR     VAR(&LAST_CNF) VALUE(%SST(&DTQE 31 1))        /*088008*/
/* */
/* Add the new member to the Print Process Extract file and override */
/* to it.                                                            */
/* */
             ADDLFM     FILE(&ACC_PATH) MBR(&MBR_NAME) +
                          DTAMBRS((CGPGENPD (&MBR_NAME))) +
                          TEXT('Correspondence Items to Print')
             OVRDBF     FILE(&ACC_PATH) MBR(&MBR_NAME)
/*/COPY WNCPYSRC,CGC5200003                                          */
/* */                                                                 /*088008*/
/* If print last conf...                      */                      /*088008*/
/* */                                                                 /*088008*/
             IF         COND(&LAST_CNF *EQ 'Y') THEN(DO)              /*088008*/
             ADDLFM     FILE(CGPGENL4) MBR(&MBR_NAME) +
                          DTAMBRS((CGPGENPD (&MBR_NAME))) +
                          TEXT('Correspondence Items to Print')       /*088008*/
             OVRDBF     FILE(CGPGENL4) MBR(&MBR_NAME)                 /*088008*/
/* */                                                                 /*088008*/
/* Delete all but last confs.                 */                      /*088008*/
/* */                                                                 /*088008*/
             CALL       PGM(CG5288) PARM(&RTN_CODE &MBR_NAME)         /*088008*/
/* */                                                                 /*088008*/
/* Check for Database errors trapped by program */                    /*088008*/
/* */                                                                 /*088008*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*088008*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)            /*088008*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)                 /*088008*/
             GOTO       CMDLBL(ABNORMAL)                              /*088008*/
             ENDDO                                                    /*088008*/
             ENDDO                                                    /*088008*/
/* */                                                                 /*089152*/
/* Get job name and number of bulk processes */                       /*089152*/
/* */                                                                 /*089152*/
             RTVMBRD    FILE(CGPGENPD) MBR(&MBR_NAME) +
                          NBRCURRCD(&NBR_RECS)                        /*089152*/
             RTVJOBA    JOB(&JOB_NAME)                                /*089152*/
             RTVDTAARA  DTAARA(CGDTA (192 2)) RTNVAR(&NBR_BULKA)      /*089152*/
             IF         COND(&NBR_BULKA *EQ '  ') THEN(DO)            /*089152*/
             CHGDTAARA  DTAARA(CGDTA (192 2)) VALUE('00')             /*089152*/
             CHGVAR     VAR(&NBR_BULKA) VALUE('00')                   /*089152*/
             ENDDO                                                    /*089152*/
             CHGVAR     VAR(&NBR_BULKS) VALUE(&NBR_BULKA)             /*089152*/
             RTVDTAARA  DTAARA(CGDTA (194 5)) RTNVAR(&BULK_RECA)      /*089152*/
             IF         COND(&BULK_RECA *EQ '     ') THEN(DO)         /*089152*/
             CHGDTAARA  DTAARA(CGDTA (194 5)) VALUE('00000')          /*089152*/
             CHGVAR     VAR(&BULK_RECA) VALUE('00000')                /*089152*/
             ENDDO                                                    /*089152*/
             CHGVAR     VAR(&BULK_RECS) VALUE(&BULK_RECA)             /*089152*/
             RTVDTAARA  DTAARA(CGDTA (35 1)) RTNVAR(&MODE)            /*089152*/
/* */                                                                 /*089152*/
/* If number of processes greater than 1, it the main job */          /*089152*/
/* and number of records to process is for bulk */                    /*089152*/
/* */                                                                 /*089152*/
             IF         COND((&NBR_BULKS *GE 1) *AND  +
                             (&JOB_NAME *EQ 'UDC_PRTGEN') *AND +
                             (&MODE     *NE 'Y'         ) *AND +
                             (&NBR_RECS *GE &BULK_RECS  )) +
                        THEN(DO)                                      /*089152*/
/* */                                                                 /*089152*/
/* CAll process to split file */                                      /*089152*/
/* */                                                                 /*089152*/
             CALL       PGM(CGC5287) PARM(&ACC_PATH &MBR_NAME &DTQE)  /*089152*/
             GOTO       CMDLBL(RMVM)                                  /*089152*/
             ENDDO                                                    /*089152*/
/* */
/* Call the Label printing process                                   */
/* */
             IF         COND(&RARCH *NE 'A') THEN(DO)
             CALL       PGM(CGC3500) PARM(&RTN_CODE &ACC_PATH &RBCH)
             ENDDO
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/* */
/* Set up overrides for processing                                   */
/* */
             IF         COND(&RARCH *EQ 'A') THEN(DO)
             OVRDBF     FILE(CGXDCRL0) SHARE(*NO)
             ENDDO
             ELSE       CMD(DO)
             OVRDBF     FILE(CGUDCRL0) SHARE(*NO)
             ENDDO
/*/COPY WNCPYSRC,CGC5200001                                          */
/* */                                                                 /*154544*/
/* Allocate CGUDCRL0 prior to calling CG5200 which calls CG3000 */    /*154544*/
/* */                                                                 /*154544*/
 RETRY:                                                               /*154544*/
             IF COND(&CTR *LT 10) THEN(DO)                            /*154544*/
             ALCOBJ OBJ((CGUDCRL0 *FILE *SHRRD))                      /*154544*/
             MONMSG MSGID(CPF1002) EXEC(DO)                           /*154544*/
                  CHGVAR VAR(&CTR) VALUE(&CTR + 1)                    /*154544*/
                  DLYJOB DLY(60)                                      /*154544*/
                  GOTO CMDLBL(RETRY)                                  /*154544*/
             ENDDO                                                    /*154544*/
             ENDDO                                                    /*154544*/
/* */
/* Call the Print Process Driver Program                             */
/* */
             CALL       PGM(CG5200) PARM(&RTN_CODE &MBR_NAME +
                          &ACC_PATH &RSEQ &RLVL &RBCH &RARCH)
/* */                                                                 /*154544*/
/* Deallocate CGUDCRL0 */                                             /*154544*/
/* */                                                                 /*154544*/
             DLCOBJ OBJ((CGUDCRL0 *FILE *SHRRD))                      /*154544*/
/*/COPY WNCPYSRC,CGC5200002                                          */
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/* */
/* Remove the new member and delete the override.                    */
/* */
 RMVM:                                                                /*089152*/
/* */                                                                 /*088008*/
/* If print last conf...                      */                      /*088008*/
/* */                                                                 /*088008*/
             IF         COND(&LAST_CNF *EQ 'Y') THEN(DO)              /*088008*/
             RMVM       FILE(CGPGENL4) MBR(&MBR_NAME)                 /*088008*/
             ENDDO                                                    /*088008*/
             RMVM       FILE(&ACC_PATH) MBR(&MBR_NAME)
             DLTOVR     FILE(&ACC_PATH)
             RMVM       FILE(CGPGENPD)  MBR(&MBR_NAME)
/*/COPY WNCPYSRC,CGC5200004                                          */
/* */
/* Prompt Charge processing                                          */
/* */
             CALL       PGM(CGC5274) PARM('')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*/COPY WNCPYSRC,CGC5200006                                          */
/* */
             GOTO       CMDLBL(ENDCLPGM)
/* */
/* Abnormal termination processing                       */
/**/
ABNORMAL:
 /**/                                                                                     /*CSC022*/
 /** Execute rollback if SAR CSC022 is not enrolled or */                                 /*CSC022*/
 /**   job is not currently running in batch mode */                                      /*CSC022*/
 /**/                                                                                     /*CSC022*/
             IF         COND((&CSC022 *EQ 'N') *OR ((&CSC022 *EQ 'Y' +
                          *AND &CRSKIP *EQ 'N'))) THEN(DO)                                /*CSC022*/
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                                                                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
                                                                                          /*CSC022*/
/**/
             SNDPGMMSG  MSG('Program CGC5200 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC5200 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/**/
 ENDCLPGM:
             CHGDTAARA  DTAARA(CGDTA (357 1)) VALUE('N')              /*175941*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
