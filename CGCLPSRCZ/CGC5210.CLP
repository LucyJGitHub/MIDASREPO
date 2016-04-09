/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CG Print Immediates Extract Control')           */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC5210  - Print Immediates Extract Control                 */
/*                                                                   */
/*       Function:  This program receives requests for creation of   */
/*                  items to be printed immediately.                 */
/*                                                                   */
/*                  The program runs continuously as a background    */
/*                  batch job.                                       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CER059             Date 19Jul10              */
/*       Prev Amend No. BUG21881           Date 15Dec08              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG12778           Date 29Nov06              */
/*                      235570             Date 30Aug05              */
/*                      CSC022             Date 24Feb04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01522             Date 05Dec94              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*     BUG21881 - CPF0818 on job UDC_IMMEDS. Applied fix BUG12778    */
/*     BUG12778 - A runtime error occured with the message           */
/*               CPF0818 Value cannot be converted to type implied   */
/*               by the receiver                                     */
/*       235570 - Receiver value too small to hold result problem    */
/*                encountered when positions 112 to 114 of CGDTA     */
/*                equal to 999. Applied fix 229331.                  */
/*       CSC022 - Commitment Control Changes for MidasPlus           */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTN_CODE)
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
             DCL        VAR(&RTN_CODE)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRV_MSG)     TYPE(*CHAR) LEN(7)                              /*235570*/
/* */
/* Parameters received for RCF                                       */
/* */
             DCL        VAR(&RSEQ)        TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLVL)        TYPE(*CHAR) LEN(1)
             DCL        VAR(&RBCH)        TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM)       TYPE(*CHAR) LEN(100)
             DCL        VAR(&RARCH)       TYPE(*CHAR) LEN(1)
 
/* */
/* General                                                           */
/* */
             DCL        VAR(&RTN_CODE)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&DATA)        TYPE(*CHAR) LEN(50)
             DCL        VAR(&DTQE)        TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSG_PRTY)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB_NO)      TYPE(*CHAR) LEN(6)
             DCL        VAR(&MBR_NAME)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&RECS)        TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&NUMA)        TYPE(*CHAR) LEN(3)
             DCL        VAR(&NUM)         TYPE(*DEC)  LEN(3 0)
             DCL        VAR(&ACC_PTH)     TYPE(*CHAR) LEN(10)
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
/* CHGJOB switches */
/* */
             CHGJOB     SWS(XXXXXX00)
/* */
/* Get next number to make member unique                             */
/* */
             RTVDTAARA  DTAARA(CGDTA (112 3)) RTNVAR(&NUMA)
             IF         COND(&NUMA *EQ '   ') THEN(DO)
             CHGVAR     VAR(&NUM) VALUE(1)
             ENDDO
             ELSE       CMD(DO)                                                         /*BUG12778*/
             IF         COND(&NUMA *EQ '999') THEN(DO)                                    /*235570*/
             CHGVAR     VAR(&NUM) VALUE(1)                                                /*235570*/
             ENDDO                                                                        /*235570*/
             ELSE       CMD(DO)
             CHGVAR     VAR(&NUM) VALUE(&NUMA)
             CHGVAR     VAR(&NUM) VALUE(&NUM + 1)
             ENDDO
             ENDDO                                                                      /*BUG12778*/
             CHGVAR     VAR(&NUMA) VALUE(&NUM)
             CHGDTAARA  DTAARA(CGDTA (112 3)) VALUE(&NUMA)
/* */
/* Obtain the Job Number and set up the Member Name to add.          */
/* */
             RTVJOBA    NBR(&JOB_NO)
             CHGVAR     VAR(&MBR_NAME) VALUE('          ')
             CHGVAR     VAR(&MBR_NAME) VALUE('I' *TCAT &JOB_NO)
             CHGVAR     VAR(&MBR_NAME) VALUE(&MBR_NAME *TCAT &NUMA)
/* */
/* Add the new member to the print process extract file and override */
/* to it.                                                            */
/* */
             ADDPFM     FILE(CGPGENPD) MBR(&MBR_NAME) +
                          TEXT('Correspondence Items to Print')
             MONMSG     MSGID(CPF7306) EXEC(DO)                                           /*235570*/
             RCVMSG     MSGTYPE(*DIAG) MSGID(&PRV_MSG)                                    /*235570*/
             IF         COND(&PRV_MSG *EQ 'CPF5812') THEN(DO)                             /*235570*/
             RMVM       FILE(CGPGENPD) MBR(&MBR_NAME)                                     /*235570*/
             ADDPFM     FILE(CGPGENPD) MBR(&MBR_NAME) +
                          TEXT('Correspondence Items to Print')                           /*235570*/
             ENDDO                                                                        /*235570*/
             ENDDO                                                                        /*235570*/
             OVRDBF     FILE(CGPGENPD) MBR(&MBR_NAME)
/* */
/* Open query file to select reference records with status IMED      */
/* */
             OVRDBF     FILE(CGUDCRL0) SHARE(*NO)
             OVRDBF     FILE(CGUDCRPD) SHARE(*YES)
             OPNQRYF    FILE((CGUDCRPD)) OPTION(*ALL) QRYSLT('DRISTS +
                          *EQ ''IMED''')
/* */
/* Set up Access path to use                                         */
/* */
             CHGVAR     VAR(&ACC_PTH) VALUE('CGPGENL3')
/* */
/* Set up RCF parameters                                             */
/* */
             CHGVAR     VAR(&RSEQ) VALUE('     ')
             CHGVAR     VAR(&RLVL) VALUE('S')
             CHGVAR     VAR(&RBCH) VALUE('   ')
             CHGVAR     VAR(&RPARM) VALUE(' ')
             CHGVAR     VAR(%SST(&RPARM 93 1)) VALUE('Y')
             CHGVAR     VAR(%SST(&RPARM 94 1)) VALUE('C')
             CHGVAR     VAR(&RARCH) VALUE('C')
/* */
/* Call the Print Immediates extract control                         */
/* */
             CALL      PGM(CG5100) PARM(&RSEQ &RLVL &RBCH &RPARM +
                                                          &RECS &RARCH)
             CLOF      OPNID(CGUDCRPD)
             MONMSG    MSGID(CPF0000 MCH0000)
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
/* If Records have been extracted...                                 */
/* ... Format and Send Data Queue entry use prompt program           */
/* */
             IF         COND(&RECS *EQ 'Y') THEN(DO)
             CHGVAR     VAR(&DTQE) VALUE(&MBR_NAME *CAT &ACC_PTH +
                          *CAT &RSEQ *CAT &RLVL *CAT &RBCH *CAT &RARCH)
             CHGVAR     VAR(&MSG_PRTY) VALUE('Normal')
             CALL       PGM(CGC5204) PARM(&RTN_CODE &DTQE &MSG_PRTY)
             ENDDO
             ELSE       CMD(DO)
             RMVM       FILE(CGPGENPD) MBR(&MBR_NAME)
             ENDDO
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
             RMVM       FILE(CGPGENPD) MBR(&MBR_NAME)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC5210 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC5210 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO                                                                        /*CSC022*/
                                                                                          /*CSC022*/
 
/**/
 ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
