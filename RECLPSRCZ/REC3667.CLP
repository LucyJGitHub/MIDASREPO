/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE Retail history upd for overdraft interest')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC3667 - History Update For Overdraft Interest             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. MD021155           Date 03Jul13              */
/*       Prev Amend No. CRE083BN           Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSC020             Date 31Mar04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             Date 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      CRE001  *CREATE    Date 18Feb97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD021155 - COB Restructure Phase 1 remnants                 */
/*                - End processing may cause loop (not introduced    */
/*                  by COBOP)                                        */
/*       CRE083BN - COB Restructure - RE COB Optimisation Phase 1    */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*       CCB009 - Journal files throughout close of business         */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       CRE001 - Overdraft Interest Calculations                    */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&CNAM &CSEQ)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
/**********  DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)           */             /*CCB009 CRE083BN*/
/**********  DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)    */                   /*CCB009 CRE083BN*/
/*                                                                      CCB009*/
/* Declare job name, user and number for remove journal changes         CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009JOB) TYPE(*CHAR) LEN(10)           /*CCB009*/
             DCL        VAR(&CCB009USR) TYPE(*CHAR) LEN(10)           /*CCB009*/
             DCL        VAR(&CCB009NBR) TYPE(*CHAR) LEN(6)            /*CCB009*/
             DCL        VAR(&CB0180DA) TYPE(*CHAR) LEN(26)            /*CCB009*/
             DCL        VAR(&START) TYPE(*DEC) LEN(10 0)              /*CCB009*/
             DCL        VAR(&FINISH) TYPE(*DEC) LEN(10 0)             /*CCB009*/
             DCL        VAR(&CSEQA) TYPE(*CHAR) LEN(5)                                    /*CSC020*/
             DCL        VAR(&STEXT) TYPE(*CHAR) LEN(50)                                   /*CSC020*/
/*/COPY WNCPYSRC,REC3667001                                          */
/**/
             MONMSG MSGID(CPF0000 MCH0000 RPG0000) +
                    EXEC(GOTO CMDLBL(ABNOR))
/**/
             SNDPGMMSG  MSG('REC3667 - Overdraft Retail History +
                          Update') TOMSGQ(MRUNQ)
/*                                                                                        /*CSC020*/
/* Write current journal sequence number to file SCJSEQPD, using command SCWRTJREG.       /*CSC020*/
/*                                                                                        /*CSC020*/
             CHGVAR     VAR(&CSEQA) VALUE(&CSEQ)                                          /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE('Start of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                    /*CSC020*/
             SCWRTJREG  COMP(&CNAM) CMPSEQ(&CSEQ) FLAG('S') +
                          TEXT(&STEXT)                                                    /*CSC020*/
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
/**********  CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                       */              /*CCB009 CRE083BN*/
/**/
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &BUSY)
/**/
             RTVDTAARA  DTAARA(SDSTAT *ALL) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
/**/
             CHGVAR     VAR(&JLIB) VALUE(&PRE *TCAT 'JLIB')
/**/
             CHGJOB     SWS('00000000')
/*/COPY WNCPYSRC,REC3667002                                          */
/**/
             OVRDBF     FILE(REODHSLL) TOFILE(REODHSL1) SHARE(*NO)
/**/
             IF         COND(&BUSY = 'Y') THEN(DO)
/*                                                                      CCB009*/
/* If Feature CCB009 is 'on' (close of business journaling),            CCB009*/
/*                                                                      CCB009*/
/**********  IF         COND(&CCB009 *EQ '       ') THEN(DO)         */          /*CCB009 CRE083BN*/
/*                                                                      CCB009*/
/* Retrieve data area CB0180DA from QTEMP.                              CCB009*/
/*                                                                      CCB009*/
             RTVDTAARA  DTAARA(QTEMP/CB0180DA) RTNVAR(&CB0180DA)
/*                                                                      CCB009*/
/* If data area is not blank, calculate the job name, user and number   CCB009*/
/* of the previous run of this component.                               CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CB0180DA *NE ' ') THEN(DO)              /*CCB009*/
/*                                                                      CCB009*/
             CHGVAR     VAR(&CCB009JOB) VALUE(%SST(&CB0180DA 1 10))                       /*CCB009*/
                                                                                          /*CCB009*/
             CHGVAR     VAR(&CCB009USR) VALUE(%SST(&CB0180DA 11 10))                      /*CCB009*/
                                                                                          /*CCB009*/
             CHGVAR     VAR(&CCB009NBR) VALUE(%SST(&CB0180DA 21 6))                       /*CCB009*/
                                                                                          /*CCB009*/
/*                                                                      CCB009*/
/*  Retrieve the most recent journal entry sequence number              CCB009*/
/*  for the specific job.                                               CCB009*/
/*                                                                      CCB009*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                          TOENT(*FIRST) SEARCH(*DESCEND) +
                          JOB(&CCB009NBR/&CCB009USR/&CCB009JOB) +
                          RTNSEQNBR(&START)                           /*CCB009*/
/*                                                                      CCB009*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)               /*CCB009*/
             CHGVAR     VAR(&START) VALUE(0)                          /*CCB009*/
             ENDDO                                                    /*CCB009*/
/***********************************************************************CCB009**************CSC020*/
/***Retrieve*the*first*journal*entry*sequence*number********************CCB009**************CSC020*/
/***for*the*specific*job.***********************************************CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/************RTVJRNE****JRN(ICJRN)*RCVRNG(*CURCHAIN)*FROMENT(*FIRST)*+**********************CSC020*/
/*************************TOENT(*LAST)*SEARCH(*ASCEND)*+************************************CSC020*/
/*************************JOB(&CCB009NBR/&CCB009USR/&CCB009JOB)*+***************************CSC020*/
/*************************RTNSEQNBR(&FINISH)****************************CCB009**************CSC020*/
/************MONMSG*****MSGID(CPF0000*MCH0000)*EXEC(DO)*****************CCB009**************CSC020*/
/************CHGVAR*****VAR(&FINISH)*VALUE(0)***************************CCB009**************CSC020*/
/************ENDDO******************************************************CCB009**************CSC020*/
/*                                                                                          CSC020*/
/*  Determine starting journal sequence number of job.                                      CSC020*/
/*                                                                                          CSC020*/
             SCRTVJCMP  COMP(&CNAM) CSEQ(&CSEQ) FLAG('S') +
                          JOB(&CCB009JOB) USER(&CCB009USR) +
                          NUMBER(&CCB009NBR) SEQ(&FINISH)                                 /*CSC020*/
/*                                                                      CCB009*/
/*  Remove journaled changes.                                           CCB009*/
/*                                                                      CCB009*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)                                    /*CCB009*/
             RMVJRNCHG  JRN(ICJRN) FILE((REHISPD) (REODHSPD) +
                          (ACCNTAB) (ACCNTBXC)) FROMENT(&START) +
                          TOENT(&FINISH)                              /*CCB009*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
/**********  ENDDO                                                */             /*CCB009 CRE083BN*/
/**********  ELSE       CMD(DO)                                   */             /*CCB009 CRE083BN*/
/**********      RMVJRNCHG  JRN(JREC3667) FILE((REHISPD) (REODHSPD) +*/                 /*CRE083BN*/
/**********                                    (ACCNTAB) (ACCNTBXC))*/                  /*CRE083BN*/
/**********      MONMSG     MSGID(CPF0000)                        */                    /*CRE083BN*/
/**********  ENDDO                                                */             /*CCB009 CRE083BN*/
             ENDDO
/**/
/******************************************************************/             /*CCB009 CRE083BN*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),***/             /*CCB009 CRE083BN*/
/******************************************************************/             /*CCB009 CRE083BN*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)  */                 /*CCB009 CRE083BN*/
/**********  ENDJRNPF   FILE(*ALL) JRN(JREC3667)        */                              /*CRE083BN*/
/**********  MONMSG MSGID(CPF0000)                      */                              /*CRE083BN*/
/**********  ENDDO                                      */                       /*CCB009 CRE083BN*/
/******************************************************************/                    /*CRE083BN*/
/**********  ENDCMTCTL                          */                                      /*CRE083BN*/
/**********  MONMSG     MSGID(CPF8350)          */                                      /*CRE083BN*/
/******************************************************************/                    /*CRE083BN*/
/******************************************************************/             /*CCB009 CRE083BN*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),***/             /*CCB009 CRE083BN*/
/******************************************************************/             /*CCB009 CRE083BN*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)      */             /*CCB009 CRE083BN*/
/**********  DLTJRN     JRN(JREC3667)                             */                    /*CRE083BN*/
/**********  MONMSG     MSGID(CPF0000)                            */                    /*CRE083BN*/
/******************************************************************/                    /*CRE083BN*/
/**********  CHGJOB     INQMSGRPY(*DFT)                           */                    /*CRE083BN*/
/**********  DLTJRNRCV  JRNRCV(JRREC3667)                         */                    /*CRE083BN*/
/**********  MONMSG     MSGID(CPF0000)                            */                    /*CRE083BN*/
/**********  CHGJOB     INQMSGRPY(*RQD)                           */                    /*CRE083BN*/
/******************************************************************/                    /*CRE083BN*/
/**********  CRTJRNRCV  JRNRCV(&JLIB/JRREC3667)                   */                    /*CRE083BN*/
/******************************************************************/                    /*CRE083BN*/
/**********  CRTJRN     JRN(&JLIB/JREC3667) JRNRCV(&JLIB/JRREC3667)*/                   /*CRE083BN*/
/******************************************************************/                    /*CRE083BN*/
/**********  STRJRNPF   FILE(REHISPD REODHSPD ACCNTAB ACCNTBXC) + */                    /*CRE083BN*/
/**********             JRN(JREC3667) IMAGES(*BOTH) OMTJRNE(*OPNCLO)*/                  /*CRE083BN*/
/**********  ENDDO                                                */             /*CCB009 CRE083BN*/
/**/
/*/COPY WNCPYSRC,REC3667003                                          */
/**********  STRCMTCTL *CHG                                           /*CPK009*/
/**********  STRCMTCTL *CHG  CMTSCOPE(*JOB)                                      /*CPK009 CRE083BN*/
/**********  MONMSG     MSGID(CPF8351)                                                  /*CRE083BN*/
/**/
             CHGVAR     VAR(&BUSY) VALUE('Y')
/**/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &BUSY)
/**/
             CALL       PGM(RE3667)
/**/
/*   UNSUCCESSFUL COMPLETION  */
/**/
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
/**/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(REUSRMSG) MSGDTA(&MEM) +
                            TOMSGQ(MOPERQ MRUNQ)
/**/
/*                                                                      CCB009*/
/* If Feature CCB009 is 'on' (close of business journaling),            CCB009*/
/*                                                                      CCB009*/
/**********  IF         COND(&CCB009 *EQ '       ') THEN(DO)      */             /*CCB009 CRE083BN*/
/*                                                                      CCB009*/
/*  Retrieve attributes of current job.                                 CCB009*/
/*                                                                      CCB009*/
             RTVJOBA    JOB(&CCB009JOB) USER(&CCB009USR) +
                          NBR(&CCB009NBR)                             /*CCB009*/
/*                                                                      CCB009*/
/*  Retrieve the most recent journal entry sequence number              CCB009*/
/*  for the specific job.                                               CCB009*/
/*                                                                      CCB009*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                          TOENT(*FIRST) SEARCH(*DESCEND) +
                          JOB(&CCB009NBR/&CCB009USR/&CCB009JOB) +
                          RTNSEQNBR(&START)                           /*CCB009*/
/*                                                                      CCB009*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)               /*CCB009*/
             CHGVAR     VAR(&START) VALUE(0)                          /*CCB009*/
             ENDDO                                                    /*CCB009*/
/***********************************************************************CCB009**************CSC020*/
/***Retrieve*the*first*journal*entry*sequence*number********************CCB009**************CSC020*/
/***for*the*specific*job.***********************************************CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/************RTVJRNE****JRN(ICJRN)*RCVRNG(*CURCHAIN)*FROMENT(*FIRST)*+**********************CSC020*/
/*************************TOENT(*LAST)*SEARCH(*ASCEND)*+************************************CSC020*/
/*************************JOB(&CCB009NBR/&CCB009USR/&CCB009JOB)*+***************************CSC020*/
/*************************RTNSEQNBR(&FINISH)****************************CCB009**************CSC020*/
/************MONMSG*****MSGID(CPF0000*MCH0000)*EXEC(DO)*****************CCB009**************CSC020*/
/************CHGVAR*****VAR(&FINISH)*VALUE(0)***************************CCB009**************CSC020*/
/************ENDDO******************************************************CCB009**************CSC020*/
/*                                                                                          CSC020*/
/*  Determine starting journal sequence number of current job.                              CSC020*/
/*                                                                                          CSC020*/
             SCRTVJCMP  COMP(&CNAM) CSEQ(&CSEQ) FLAG('S') +
                          JOB(&CCB009JOB) USER(&CCB009USR) +
                          NUMBER(&CCB009NBR) SEQ(&FINISH)                                 /*CSC020*/
/*                                                                      CCB009*/
/*  Remove journaled changes.                                           CCB009*/
/*                                                                      CCB009*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)                                    /*CCB009*/
             RMVJRNCHG  JRN(ICJRN) FILE((REHISPD) (REODHSPD) +
                          (ACCNTAB) (ACCNTBXC)) FROMENT(&START) +
                          TOENT(&FINISH)                              /*CCB009*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*CCB009*/
             ENDDO                                                    /*CCB009*/
/*********   ENDDO                                                */             /*CCB009 CRE083BN*/
/*********   ELSE       CMD(DO)                                   */             /*CCB009 CRE083BN*/
/*********       RMVJRNCHG  JRN(JREC3667) FILE((REHISPD) (REODHSPD) +*/                 /*CRE083BN*/
/*********                                     (ACCNTAB) (ACCNTBXC))*/                  /*CRE083BN*/
/*********       MONMSG     MSGID(CPF0000)                        */                    /*CRE083BN*/
/*********   ENDDO                                                */             /*CCB009 CRE083BN*/
/**/
/*/COPY WNCPYSRC,REC3667004                                          */
                 GOTO       CMDLBL(ABNOR2)
/**/
             ENDDO
/**/
/*   SUCCESSFUL COMPLETION */
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/
/******************************************************************/             /*CCB009 CRE083BN*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),***/             /*CCB009 CRE083BN*/
/******************************************************************/             /*CCB009 CRE083BN*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)      */             /*CCB009 CRE083BN*/
/**********      ENDJRNPF   FILE(*ALL) JRN(JREC3667)              */                    /*CRE083BN*/
/**********      MONMSG     MSGID(CPF0000)                        */                    /*CRE083BN*/
/**********  ENDDO                                                */             /*CCB009 CRE083BN*/
/******************************************************************/                    /*CRE083BN*/
/**********      ENDCMTCTL                                        */                    /*CRE083BN*/
/**********      MONMSG     MSGID(CPF8350)                        */                    /*CRE083BN*/
/******************************************************************/                    /*CRE083BN*/
/******************************************************************/             /*CCB009 CRE083BN*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),***/             /*CCB009 CRE083BN*/
/******************************************************************/             /*CCB009 CRE083BN*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)      */             /*CCB009 CRE083BN*/
/**********      DLTJRN     JRN(JREC3667)                         */                    /*CRE083BN*/
/**********      MONMSG     MSGID(CPF0000)                        */                    /*CRE083BN*/
/******************************************************************/                    /*CRE083BN*/
/**********  CHGJOB     INQMSGRPY(*DFT)                           */                    /*CRE083BN*/
/**********      DLTJRNRCV  JRNRCV(JRREC3667)                     */                    /*CRE083BN*/
/**********      MONMSG     MSGID(CPA0000 CPF0000)                */                    /*CRE083BN*/
/**********  CHGJOB     INQMSGRPY(*RQD)                           */                    /*CRE083BN*/
/**********  ENDDO                                                */             /*CCB009 CRE083BN*/
/******************************************************************/                    /*CRE083BN*/
                 CHGVAR     VAR(&BUSY) VALUE('N')
/**/
                 CALL       PGM(CB0150) PARM(&CNAM &CSEQ &BUSY)
/**/
                 GOTO       CMDLBL(ENDPGM)
/**/
             ENDDO
/**/
ABNOR:
/**/
SNDPGMMSG  MSGID(MEM0001) MSGF(REUSRMSG) MSGDTA(&MEM)                  +
           TOMSGQ(MOPERQ MRUNQ)
/**/
ABNOR2:
/**/
DMPCLPGM
/**/
/**********ENDCMTCTL                                                                    /*CRE083BN*/
/**********      MONMSG     MSGID(CPF8350)                                              /*CRE083BN*/
/**/
CHGJOB     SWS('00000011')
             GOTO       CMDLBL(ENDPGM2)                                                 /*MD021155*/
/**/
ABNOREND:
/**/
ENDPGM:
/*                                                                                        /*CSC020*/
/* Write current journal sequence number to file SCJSEQPD, using command SCWRTJREG.       /*CSC020*/
/*                                                                                        /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE(' ')                                            /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE('End of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                    /*CSC020*/
             SCWRTJREG  COMP(&CNAM) CMPSEQ(&CSEQ) FLAG('E') +
                          TEXT(&STEXT)                                                    /*CSC020*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
ENDPGM2:                                                                                /*MD021155*/
             ENDPGM
