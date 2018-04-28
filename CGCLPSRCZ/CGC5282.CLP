/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG Bulk PrtGen action test')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - User Defined Correspondence                         */
/*                                                                   */
/*       CGC5282  - Bulk PrtGen Extraction Control - Batch process   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC022             Date 24Feb04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CPK015             Date 18Apr02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01522             Date 01May95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSC022 - Commitment Control Changes for MidasPlus           */
/*       CPK015 - R4.01 Packaging:                                   */
/*                - DTAQ CGPRTGENBK is now a permanent object in the */
/*                  DPLIB.                                           */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTN_CODE &ACTION &MSG_REF)
/**/
/* Copyright statement defination  */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSG_REF) TYPE(*CHAR) LEN(50)
             DCL        VAR(&DILIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DBPREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&FLDLEN) TYPE(*DEC) LEN(5 0) VALUE(50)
             DCL        VAR(&WAIT) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&ORDER) TYPE(*CHAR) LEN(2)
             DCL        VAR(&KEY_LEN) TYPE(*DEC) LEN(3 0) VALUE(10)
             DCL        VAR(&KEY) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SNDR_LEN) TYPE(*DEC) LEN(3 0) VALUE(44)
             DCL        VAR(&SNDR) TYPE(*CHAR) LEN(44)
             DCL        VAR(&DELAY_TIME) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&DELAYA) TYPE(*CHAR) LEN(4)
             DCL        VAR(&TEMP) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB_INFO) TYPE(*CHAR) LEN(512)
             DCL        VAR(&FORMAT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB26) TYPE(*CHAR) LEN(26)
             DCL        VAR(&INT_JOB_ID) TYPE(*CHAR) LEN(16)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(132)
             DCL        VAR(&TXT1) TYPE(*CHAR) LEN(132)
             DCL        VAR(&TXT2) TYPE(*CHAR) LEN(512)
             DCL        VAR(&JOB_NAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OFF_SET) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&JOB_OFF_ST) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&USR_OFF_ST) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&NBR_OFF_ST) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&BULK_NBR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(5 0)
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
 /**/                                                                                     /*CSC022*/
/* */
/* Send Message to MRUNQ */
/* */
             SNDPGMMSG  MSG('CGC5282 - Bulk PrtGen Extraction Test +
                          Action') TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXXX00)
             CHGVAR     VAR(&MSG_REF) VALUE(' ')
/**/
/* Construct DILIB */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DBPREFIX)
             CHGVAR     VAR(&DILIB) VALUE(&DBPREFIX *CAT 'DILIB')
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/**/
/* Check*if*data*queue*exists**/                                                          /*CPK015*/
/**/
/**********  CALL       PGM(CGC5285) */                                                   /*CPK015*/
             RTVJOBA    JOB(&JOB_NAME)
/**/
/* If action is Start */
/**/
             IF         COND(&ACTION *EQ 'Start     ') THEN(DO)
/**/
/* Allocate CGPRTGENBK to show bulk processes active */
/**/
/**********  ALCOBJ     OBJ((&DILIB/CGPRTGENBK *DTAQ *SHRUPD)) WAIT(60) */                /*CPK015*/
             ALCOBJ     OBJ((CGPRTGENBK *DTAQ *SHRUPD)) WAIT(60)                          /*CPK015*/
/**/
/* Allocate data queue *EXCL to see if process active */
/**/
/************ALCOBJ     OBJ((&DILIB/&JOB_NAME *DTAARA *EXCL)) WAIT(60)                 */ /*CPK015*/
             ALCOBJ     OBJ((&JOB_NAME *DTAARA *EXCL)) WAIT(60)                           /*CPK015*/
             MONMSG     MSGID(CPF1002) EXEC(DO)
/**/
/* Process already active */
/**/
             CHGVAR     VAR(&RTN_CODE) VALUE('CGP1000')
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/**/
/* Change allocation to shared read */
/**/
/************ALCOBJ     OBJ((&DILIB/&JOB_NAME *DTAARA *SHRUPD)) WAIT(0)                */ /*CPK015*/
/************DLCOBJ     OBJ((&DILIB/&JOB_NAME *DTAARA *EXCL))                          */ /*CPK015*/
             ALCOBJ     OBJ((&JOB_NAME *DTAARA *SHRUPD)) WAIT(0)                          /*CPK015*/
             DLCOBJ     OBJ((&JOB_NAME *DTAARA *EXCL))                                    /*CPK015*/
/**/
/* Process is not active - if interactive submit to batch */
/**/
             RTVJOBA    TYPE(&TYPE)
             IF         COND(&TYPE *EQ '1') THEN(DO)
/* */
/* Set off set and call submit */
/* */
             CHGVAR     VAR(&BULK_NBR) VALUE(%SST(&JOB_NAME 10 1))
             IF         COND(&BULK_NBR *EQ '1') THEN(CHGVAR +
                          VAR(&OFF_SET) VALUE(201))
             IF         COND(&BULK_NBR *EQ '2') THEN(CHGVAR +
                          VAR(&OFF_SET) VALUE(227))
             IF         COND(&BULK_NBR *EQ '3') THEN(CHGVAR +
                          VAR(&OFF_SET) VALUE(253))
             IF         COND(&BULK_NBR *EQ '4') THEN(CHGVAR +
                          VAR(&OFF_SET) VALUE(279))
             IF         COND(&BULK_NBR *EQ '5') THEN(CHGVAR +
                          VAR(&OFF_SET) VALUE(305))
             IF         COND(&BULK_NBR *EQ '6') THEN(CHGVAR +
                          VAR(&OFF_SET) VALUE(331))
/* */
             CALL       PGM(CGC5283) PARM(&RTN_CODE &JOB_NAME &OFF_SET)
             IF         COND((&RTN_CODE *NE '       ')  *AND +
                             (&RTN_CODE *NE 'CGP1000')) THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/************DLCOBJ     OBJ((&DILIB/&JOB_NAME *DTAARA *SHRUPD))                        */ /*CPK015*/
             DLCOBJ     OBJ((&JOB_NAME *DTAARA *SHRUPD))                                  /*CPK015*/
             ENDDO
/* End 'Start' */
             ENDDO
/**/
/* If action is Next */
/**/
             IF         COND(&ACTION *EQ 'Next      ') THEN(DO)
/* */
/* Set count and delay time */
/* If delay time not set, set to 5 seconds */
/* */
             RTVDTAARA  DTAARA(CGDTA (51 4)) RTNVAR(&DELAYA)
             IF         COND(&DELAYA *EQ '    ') THEN(DO)
             CHGVAR     VAR(&DELAY_TIME) VALUE(5)
             ENDDO
             ELSE       CMD(DO)
             CHGVAR     VAR(&DELAY_TIME) VALUE(&DELAYA)
             ENDDO
/**/
/* Read data queue for next prompt for action */
/**/
             CHGVAR     VAR(&WAIT) VALUE(1)
             CHGVAR     VAR(&ORDER) VALUE('GE')
             CHGVAR     VAR(&KEY) VALUE(' ')
/*RDTAQ:***  CALL       PGM(QRCVDTAQ) PARM('CGPRTGENBK' &DILIB +     */                   /*CPK015*/
/**********               &FLDLEN &DATA &WAIT &ORDER &KEY_LEN &KEY + */                   /*CPK015*/
/**********               &SNDR_LEN &SNDR)                           */                   /*CPK015*/
 RDTAQ:                                                                                   /*CPK015*/
             CALL       PGM(QRCVDTAQ) PARM('CGPRTGENBK' '*LIBL' +
                          &FLDLEN &DATA &WAIT &ORDER &KEY_LEN &KEY +
                          &SNDR_LEN &SNDR)                                                /*CPK015*/
/**/
/* No information */
/**/
             IF         COND(&FLDLEN *EQ 0) THEN(DO)
             CHGVAR     VAR(&RTN_CODE) VALUE('CGP1003')
             ENDDO
/**/
/* Information */
/**/
             IF         COND(&FLDLEN *GT 0) THEN(DO)
             CHGVAR     VAR(&RTN_CODE) VALUE('CGP1004')
/**/
/* Close down requested */
/**/
             IF         COND(%SST(&DATA 1 3) *EQ 'End') THEN(DO)
             CHGVAR     VAR(&RTN_CODE) VALUE('CGP1002')
             RETURN
             ENDDO
             CHGVAR     VAR(&MSG_REF) VALUE(&DATA)
             ENDDO
/**/
/* Delay job by wait time (first time only) */
/**/
             IF         COND(&WAIT *GE 0) THEN(DO)
             DLYJOB     DLY(&DELAY_TIME)
             ENDDO
/**/
/* If no information from prior read of data queue */
/* Re-read queue for ever */
/**/
             IF         COND(&RTN_CODE *EQ 'CGP1003') THEN(DO)
             CHGVAR     VAR(&WAIT) VALUE(-1)
             GOTO       CMDLBL(RDTAQ)
             ENDDO
/**/
/* Else read all for end information on data queue */
/* and exit */
/**/
             ELSE       CMD(DO)
             CHGVAR     VAR(&WAIT) VALUE(1)
             CHGVAR     VAR(&ORDER) VALUE('EQ')
             CHGVAR     VAR(&KEY) VALUE('End')
/*ADTAQ:***  CALL       PGM(QRCVDTAQ) PARM('CGPRTGENBK' &DILIB +     */                   /*CPK015*/
/**********               &FLDLEN &DATA &WAIT &ORDER &KEY_LEN &KEY + */                   /*CPK015*/
/**********               &SNDR_LEN &SNDR)                           */                   /*CPK015*/
 ADTAQ:                                                                                   /*CPK015*/
             CALL       PGM(QRCVDTAQ) PARM('CGPRTGENBK' '*LIBL' +
                          &FLDLEN &DATA &WAIT &ORDER &KEY_LEN &KEY +
                          &SNDR_LEN &SNDR)                                                /*CPK015*/
/**/
/* No information */
/**/
             IF         COND(&FLDLEN *EQ 0) THEN(DO)
             RETURN
             ENDDO
/**/
/* Information */
/**/
             IF         COND(&FLDLEN *GT 0) THEN(DO)
             CHGVAR     VAR(&RTN_CODE) VALUE('CGP1004')
/**/
/* Close down requested */
/**/
             IF         COND(%SST(&DATA 1 3) *EQ 'End') THEN(DO)
             CHGVAR     VAR(&RTN_CODE) VALUE('CGP1002')
             RETURN
             ENDDO
             CHGVAR     VAR(&MSG_REF) VALUE(&DATA)
             ENDDO
             GOTO       CMDLBL(ADTAQ)
             ENDDO
/* End 'Next' */
             ENDDO
/**/
/* If action is Re-submit */
/**/
             IF         COND(&ACTION *EQ 'Re-submit ') THEN(DO)
/* */
/* Set off set and call submit */
/* */
             CHGVAR     VAR(&BULK_NBR) VALUE(%SST(&JOB_NAME 10 1))
             IF         COND(&BULK_NBR *EQ '1') THEN(CHGVAR +
                          VAR(&OFF_SET) VALUE(201))
             IF         COND(&BULK_NBR *EQ '2') THEN(CHGVAR +
                          VAR(&OFF_SET) VALUE(227))
             IF         COND(&BULK_NBR *EQ '3') THEN(CHGVAR +
                          VAR(&OFF_SET) VALUE(253))
             IF         COND(&BULK_NBR *EQ '4') THEN(CHGVAR +
                          VAR(&OFF_SET) VALUE(279))
             IF         COND(&BULK_NBR *EQ '5') THEN(CHGVAR +
                          VAR(&OFF_SET) VALUE(305))
             IF         COND(&BULK_NBR *EQ '6') THEN(CHGVAR +
                          VAR(&OFF_SET) VALUE(331))
/* */
             CALL       PGM(CGC5283) PARM(&RTN_CODE &JOB_NAME &OFF_SET)
             IF         COND(&RTN_CODE *NE '       ') THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/**********  DLCOBJ     OBJ((&DILIB/CGPRTGEN *DTAQ *SHRUPD)) */                           /*CPK015*/
             DLCOBJ     OBJ((CGPRTGEN *DTAQ *SHRUPD))                                     /*CPK015*/
             ENDDO
/**/
/* If action is End */
/**/
             IF         COND(&ACTION *EQ 'End       ') THEN(DO)
/**/
/* Allocate data queue *SHRUPD to see if process active */
/**/
/**********  ALCOBJ     OBJ((&DILIB/CGPRTGENBK *DTAQ *SHRUPD)) WAIT(0) */                 /*CPK015*/
             ALCOBJ     OBJ((CGPRTGENBK *DTAQ *SHRUPD)) WAIT(0)                           /*CPK015*/
             MONMSG     MSGID(CPF1002) EXEC(DO)
/**/
/* Process cannot be killed re-try later */
/**/
             CHGVAR     VAR(&RTN_CODE) VALUE('CGP1005')
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/**/
/* Send data queue entry to End process */
/**/
             CHGVAR     VAR(&DATA) VALUE(' ')
             CHGVAR     VAR(&DATA) VALUE('End')
/**********  CALL       PGM(QSNDDTAQ) PARM('CGPRTGENBK' &DILIB + */                       /*CPK015*/
/**********               &FLDLEN &DATA &KEY_LEN 'End       ')   */                       /*CPK015*/
/**********  CALL       PGM(QSNDDTAQ) PARM('CGPRTGENBK' &DILIB + */                       /*CPK015*/
/**********               &FLDLEN &DATA &KEY_LEN 'End       ')   */                       /*CPK015*/
/**********  CALL       PGM(QSNDDTAQ) PARM('CGPRTGENBK' &DILIB + */                       /*CPK015*/
/**********               &FLDLEN &DATA &KEY_LEN 'End       ')   */                       /*CPK015*/
/**********  CALL       PGM(QSNDDTAQ) PARM('CGPRTGENBK' &DILIB + */                       /*CPK015*/
/**********               &FLDLEN &DATA &KEY_LEN 'End       ')   */                       /*CPK015*/
/**********  CALL       PGM(QSNDDTAQ) PARM('CGPRTGENBK' &DILIB + */                       /*CPK015*/
/**********               &FLDLEN &DATA &KEY_LEN 'End       ')   */                       /*CPK015*/
/**********  CALL       PGM(QSNDDTAQ) PARM('CGPRTGENBK' &DILIB + */                       /*CPK015*/
/**********               &FLDLEN &DATA &KEY_LEN 'End       ')   */                       /*CPK015*/
             CALL       PGM(QSNDDTAQ) PARM('CGPRTGENBK' '*LIBL' +
                          &FLDLEN &DATA &KEY_LEN 'End       ')                            /*CPK015*/
             CALL       PGM(QSNDDTAQ) PARM('CGPRTGENBK' '*LIBL' +
                          &FLDLEN &DATA &KEY_LEN 'End       ')                            /*CPK015*/
             CALL       PGM(QSNDDTAQ) PARM('CGPRTGENBK' '*LIBL' +
                          &FLDLEN &DATA &KEY_LEN 'End       ')                            /*CPK015*/
             CALL       PGM(QSNDDTAQ) PARM('CGPRTGENBK' '*LIBL' +
                          &FLDLEN &DATA &KEY_LEN 'End       ')                            /*CPK015*/
             CALL       PGM(QSNDDTAQ) PARM('CGPRTGENBK' '*LIBL' +
                          &FLDLEN &DATA &KEY_LEN 'End       ')                            /*CPK015*/
             CALL       PGM(QSNDDTAQ) PARM('CGPRTGENBK' '*LIBL' +
                          &FLDLEN &DATA &KEY_LEN 'End       ')                            /*CPK015*/
/**/
/* If termination is interactive then show info screen */
/**/
             RTVJOBA    TYPE(&TYPE)
             IF         COND(&TYPE *EQ '1') THEN(DO)
             CHGVAR     VAR(&MSGDTA) VALUE(' ')
             CALL       PGM(CGC0380) PARM(&RTN_CODE 'CGP1006' +
                          'CGUSRMSG ' &MSGDTA '          ' ' ' +
                          'CGC5282' 'Y')
             ENDDO
/**/
/* Try to allocate data queue *EXCL */
/**/
/*ALCOBJ:****ALCOBJ     OBJ((&DILIB/CGPRTGENBK *DTAQ *EXCL)) WAIT(60) */                  /*CPK015*/
 ALCOBJ:                                                                                  /*CPK015*/
             ALCOBJ     OBJ((CGPRTGENBK *DTAQ *EXCL)) WAIT(60)                            /*CPK015*/
             MONMSG     MSGID(CPF1002) EXEC(DO)
/**/
/* Loop six times to kill jobs */
/**/
             CHGVAR     VAR(&OFF_SET) VALUE(175)
             CHGVAR     VAR(&COUNT) VALUE(0)
 LOOP1:      CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)
             CHGVAR     VAR(&OFF_SET) VALUE(&OFF_SET + 26)
             IF         COND(&COUNT *GT 6) THEN(GOTO CMDLBL(ALCOBJ))
/**/
/* Check activity of job submitted */
/**/
             CHGVAR     VAR(&JOB_OFF_ST) VALUE(&OFF_SET)
             CHGVAR     VAR(&USR_OFF_ST) VALUE(&OFF_SET + 10)
             CHGVAR     VAR(&NBR_OFF_ST) VALUE(&OFF_SET + 20)
/**/
             RTVDTAARA  DTAARA(CGDTA (&JOB_OFF_ST 10)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB26 1 10)) VALUE(&TEMP)
             RTVDTAARA  DTAARA(CGDTA (&USR_OFF_ST 10)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB26 11 10)) VALUE(&TEMP)
             RTVDTAARA  DTAARA(CGDTA (&NBR_OFF_ST 6)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB26 21 6)) VALUE(%SST(&TEMP 1 6))
             CHGVAR     VAR(&FORMAT) VALUE('JOBI0200')
/**/
/* If not job then loop */
/**/
             IF         COND(&JOB26 *EQ ' ') THEN(GOTO CMDLBL(LOOP1))
/**/
             CALL       PGM(CGC5216) PARM(&RTN_CODE &JOB_INFO +
                          &FORMAT &JOB26 &INT_JOB_ID)
/**/
/* If inactive loop1 */
/**/
             IF         COND((&RTN_CODE *EQ 'CGP1007') *OR +
                             (%SST(&JOB_INFO 51 10) *EQ '*OUTQ  ') +
                        ) THEN(DO)
             GOTO       CMDLBL(LOOP1)
             ENDDO
/**/
/* Kill process defined in CGDTA */
/**/
             RTVDTAARA  DTAARA(CGDTA (&JOB_OFF_ST 10)) RTNVAR(&JOB)
             RTVDTAARA  DTAARA(CGDTA (&USR_OFF_ST 10)) RTNVAR(&USER)
             RTVDTAARA  DTAARA(CGDTA (&NBR_OFF_ST 6)) RTNVAR(&JOBNBR)
/**/
/* If termination is interactive then show info screen */
/**/
             RTVJOBA    TYPE(&TYPE)
             IF         COND(&TYPE *EQ '1') THEN(DO)
             CHGVAR     VAR(&MSGDTA) VALUE(' ')
             CHGVAR     VAR(&MSGDTA) VALUE(&JOB *CAT &USER *CAT +
                          &JOBNBR)
             CALL       PGM(CGC0380) PARM(&RTN_CODE 'CGP1008' +
                          'CGUSRMSG ' &MSGDTA '          ' ' ' +
                          'CGC5282' 'Y')
             ENDDO
/**/
/* If jobq then *IMMED */
/**/
             IF         COND((%SST(&JOB_INFO 51 10) *EQ '*JOBQ  ') +
                        ) THEN(DO)
             ENDJOB     JOB(&JOBNBR/&USER/&JOB) OPTION(*IMMED)
             MONMSG     MSGID(CPF1362 CPF1363 CPF1361 CPF1352)
             GOTO       CMDLBL(LOOP1)
             ENDDO
/**/
/* If active then *CNTRLD for 10 minutes */
/**/
             IF         COND((%SST(&JOB_INFO 51 10) *EQ '*ACTIVE') +
                        ) THEN(DO)
             ENDJOB     JOB(&JOBNBR/&USER/&JOB) OPTION(*CNTRLD) +
                          DELAY(600)
             MONMSG     MSGID(CPF1362 CPF1363 CPF1361 CPF1352)
             GOTO       CMDLBL(LOOP1)
             ENDDO
/**/
             GOTO       CMDLBL(LOOP1)
             ENDDO
/**/
/* Loop six times to kill jobs */
/**/
             CHGVAR     VAR(&OFF_SET) VALUE(175)
             CHGVAR     VAR(&COUNT) VALUE(0)
 LOOP2:      CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)
             CHGVAR     VAR(&OFF_SET) VALUE(&OFF_SET + 26)
             IF         COND(&COUNT *GT 6) THEN(GOTO CMDLBL(ENDLP2))
/**/
/* Check activity of job submitted */
/**/
             CHGVAR     VAR(&JOB_OFF_ST) VALUE(&OFF_SET)
             CHGVAR     VAR(&USR_OFF_ST) VALUE(&OFF_SET + 10)
             CHGVAR     VAR(&NBR_OFF_ST) VALUE(&OFF_SET + 20)
/**/
             RTVDTAARA  DTAARA(CGDTA (&JOB_OFF_ST 10)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB26 1 10)) VALUE(&TEMP)
             RTVDTAARA  DTAARA(CGDTA (&USR_OFF_ST 10)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB26 11 10)) VALUE(&TEMP)
             RTVDTAARA  DTAARA(CGDTA (&NBR_OFF_ST 6)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB26 21 6)) VALUE(%SST(&TEMP 1 6))
             CHGVAR     VAR(&FORMAT) VALUE('JOBI0200')
/**/
/* If job specified */
/**/
             IF         COND(&JOB26 *NE ' ') THEN(DO)
             CALL       PGM(CGC5216) PARM(&RTN_CODE &JOB_INFO +
                          &FORMAT &JOB26 &INT_JOB_ID)
/**/
/* If jobq then *IMMED */
/**/
             IF         COND((%SST(&JOB_INFO 51 10) *EQ '*JOBQ  ') +
                        ) THEN(DO)
             RTVDTAARA  DTAARA(CGDTA (&JOB_OFF_ST 10)) RTNVAR(&JOB)
             RTVDTAARA  DTAARA(CGDTA (&USR_OFF_ST 10)) RTNVAR(&USER)
             RTVDTAARA  DTAARA(CGDTA (&NBR_OFF_ST 6)) RTNVAR(&JOBNBR)
             ENDJOB     JOB(&JOBNBR/&USER/&JOB) OPTION(*IMMED)
             MONMSG     MSGID(CPF1362 CPF1363 CPF1361 CPF1352)
             GOTO       CMDLBL(LOOP2)
             ENDDO
             ENDDO
             GOTO       CMDLBL(LOOP2)
 ENDLP2:
/**/
/* Delete data queue */
/**/
/**********  DLTDTAQ    DTAQ(&DILIB/CGPRTGENBK) */                                        /*CPK015*/
             CALL       PGM(QCLRDTAQ) PARM('CGPRTGENBK' '*LIBL ')                         /*CPK015*/
             CHGDTAARA  DTAARA(CGDTA (201 156)) VALUE(' ')
/**/
             ENDDO
/* End 'End' */
             GOTO       CMDLBL(ENDCLPGM)
/**/
/* Abnormal termination processing                       */
/* Terminate with escape message */
/**/
ABNORMAL:
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**********  DLCOBJ     OBJ((&DILIB/CGPRTGENBK *DTAQ *SHRUPD)) */                         /*CPK015*/
             DLCOBJ     OBJ((CGPRTGENBK *DTAQ *SHRUPD))                                   /*CPK015*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**********  DLCOBJ     OBJ((&DILIB/CGPRTGENBK *DTAQ *EXCL)) */                           /*CPK015*/
             DLCOBJ     OBJ((CGPRTGENBK *DTAQ *EXCL))                                     /*CPK015*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/************DLCOBJ     OBJ((&DILIB/&JOB_NAME *DTAARA *EXCL))                          */ /*CPK015*/
             DLCOBJ     OBJ((&JOB_NAME *DTAARA *EXCL))                                    /*CPK015*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/************DLCOBJ     OBJ((&DILIB/&JOB_NAME *DTAARA *SHRUPD))                        */ /*CPK015*/
             DLCOBJ     OBJ((&JOB_NAME *DTAARA *SHRUPD))                                  /*CPK015*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 /**/                                                                                     /*CSC022*/
 /** Execute rollback if SAR CSC022 is not enrolled or */                                 /*CSC022*/
 /**   job is not currently running in batch mode */                                      /*CSC022*/
 /**/                                                                                     /*CSC022*/
             IF         COND(&CSC022 *EQ 'N') THEN(DO)                                    /*CSC022*/
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC5282 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC5282 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO                                                                        /*CSC022*/
             ELSE       CMD(DO)                                                           /*CSC022*/
             IF         COND(&CRSKIP *EQ 'N') THEN(DO)                                    /*CSC022*/
                        ROLLBACK                                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ELSE       DO                                                                /*CSC022*/
                        CHGJOB     SWS(XXXXXX11)                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ENDDO                                                                        /*CSC022*/
                                                                                          /*CSC022*/
/**/
 ENDCLPGM:
             ENDPGM
