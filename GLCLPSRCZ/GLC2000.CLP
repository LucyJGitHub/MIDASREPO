/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Turnover statements print')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger                              */
/*                                                                   */
/*       GLC2000 - TURNOVER STATEMENTS PRINT                         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC020             Date 31Mar04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       Prev Amend No. CCB009             Date 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      092969             Date 05Jul96              */
/*                      S01408             Date 04May95              */
/*                      067737             DATE 07MAR94              */
/*                      S01413 *CREATE     DATE 13APR93              */
/*                                                                   */
/*       Note: This program uses journaling as recovery method.      */
/*             If the number of records to be updated exceeds 30%,   */
/*             use a CPYF or - even better - a CRTDUPOBJ of the files*/
/*             before calling GL2000.                                */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*       CCB009 - Journal files throughout close of business         */
/*       092969 - Remove exclusive lock on acnuma on completion.     */
/*       S01408 - Addition of core hook GLC2000MP1                   */
/*       067737 - GL2000 should run when &CNDS equals 'Y'            */
/*       S01413 - Retail 3 Incorporation                             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM                                                      /*CCB009*/
             PGM        PARM(&CNAM &CSEQ)                             /*CCB009*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCLF       FILE(TABTBRE)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNO) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PRTTXT) TYPE(*CHAR) LEN(30)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*CCB009*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                /*CCB009*/
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')      /*CCB009*/
/**/                                                                  /*CCB009*/
/* Declare variable CCB009 - flag for switchable feature           */ /*CCB009*/
/**/                                                                  /*CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
/**/                                                                  /*CCB009*/
/* Declare job name, user and number for remove journal changes    */ /*CCB009*/
/**/                                                                  /*CCB009*/
             DCL        VAR(&CCB009JOB) TYPE(*CHAR) LEN(10)           /*CCB009*/
             DCL        VAR(&CCB009USR) TYPE(*CHAR) LEN(10)           /*CCB009*/
             DCL        VAR(&CCB009NBR) TYPE(*CHAR) LEN(6)            /*CCB009*/
             DCL        VAR(&CB0180DA) TYPE(*CHAR) LEN(26)            /*CCB009*/
             DCL        VAR(&START) TYPE(*DEC) LEN(10 0)              /*CCB009*/
             DCL        VAR(&FINISH) TYPE(*DEC) LEN(10 0)             /*CCB009*/
             DCL        VAR(&CSEQA) TYPE(*CHAR) LEN(5)                                    /*CSC020*/
             DCL        VAR(&STEXT) TYPE(*CHAR) LEN(50)                                   /*CSC020*/
/*/COPY WNCPYSRC,GLC2000001                                          */
 
/* Global error trap                                                 */
 
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNORMAL))
/*                                                                                        /*CSC020*/
/* Write current journal sequence number to file SCJSEQPD, using command SCWRTJREG.       /*CSC020*/
/*                                                                                        /*CSC020*/
             CHGVAR     VAR(&CSEQA) VALUE(&CSEQ)                                          /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE('Start of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                    /*CSC020*/
             SCWRTJREG  COMP(&CNAM) CMPSEQ(&CSEQ) FLAG('S') +
                          TEXT(&STEXT)                                                    /*CSC020*/
/**/                                                                  /*CCB009*/
/** Check for Switchable feature CCB009.                           */ /*CCB009*/
/**/                                                                  /*CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
/*/COPY WNCPYSRC,GLC2000004                                          */
 
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&JOBNO) +
                          PRTTXT(&PRTTXT)
             CHGJOB     PRTTXT(*BLANK)
             RCVF       DEV(*FILE) RCDFMT(TABTBREF)
/************IF         COND(CNDS = N) THEN(DO)                     067737*/
             IF         COND(&CNDS *NE Y) THEN(DO)                /*067737*/
             SNDMSG     MSG('Nothing to process by GLC2000') +
                          TOMSGQ(MRUNQ)
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
             ENDDO
             ELSE       CMD(DO)
             SNDMSG     MSG('GLC2000 - Turnover statements print') +
                          TOMSGQ(MRUNQ)
             ENDDO
/* Get system ID to build JLIB name                                  */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
             CHGVAR     VAR(&TOLIB) VALUE(&PREFIX *TCAT 'JLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC2000MP1                                          */
                                                                      /*S01408*/
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)           /*CCB009*/
/**/                                                                  /*CCB009*/
/*   If Restart, Remove Journalled Changes   */                       /*CCB009*/
/**/                                                                  /*CCB009*/
                IF         COND(&STAT *EQ 'Y') THEN(DO)               /*CCB009*/
/**/                                                                  /*CCB009*/
/* If Feature CCB009 is 'on' (close of business journaling),       */ /*CCB009*/
/**/                                                                  /*CCB009*/
             IF         COND(&CCB009 *EQ '       ') THEN(DO)          /*CCB009*/
/**/                                                                  /*CCB009*/
/* Retrieve data area CB0180DA from QTEMP.                         */ /*CCB009*/
/**/                                                                  /*CCB009*/
             RTVDTAARA  DTAARA(QTEMP/CB0180DA) RTNVAR(&CB0180DA)      /*CCB009*/
/**/                                                                  /*CCB009*/
/* If data area is not blank, calculate the job name, user and no. */ /*CCB009*/
/* of the previous run of this component.                             /*CCB009*/
/**/                                                                  /*CCB009*/
             IF         COND(&CB0180DA *NE ' ') THEN(DO)              /*CCB009*/
/**/                                                                  /*CCB009*/
             CHGVAR     VAR(&CCB009JOB) VALUE(%SST(&CB0180DA 1 10))   /*CCB009*/
             CHGVAR     VAR(&CCB009USR) VALUE(%SST(&CB0180DA 11 10))  /*CCB009*/
             CHGVAR     VAR(&CCB009NBR) VALUE(%SST(&CB0180DA 21 6))   /*CCB009*/
/**/                                                                  /*CCB009*/
/*  Retrieve the most recent journal entry sequence number         */ /*CCB009*/
/*  for the specific job.                                          */ /*CCB009*/
/**/                                                                  /*CCB009*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                          TOENT(*FIRST) SEARCH(*DESCEND) +
                          JOB(&CCB009NBR/&CCB009USR/&CCB009JOB) +
                          RTNSEQNBR(&START)                           /*CCB009*/
/**/                                                                  /*CCB009*/
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
/**/                                                                  /*CCB009*/
/*  Remove journaled changes.                                      */ /*CCB009*/
/**/                                                                  /*CCB009*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)                                    /*CCB009*/
             RMVJRNCHG  JRN(ICJRN) FILE((ACCNTAB) (RECOMD)) +
                          FROMENT(&START) TOENT(&FINISH)              /*CCB009*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041) +
                                                                      /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ELSE       CMD(DO)                                       /*CCB009*/
/* Ensure that no pending changes exist                              */
 
             RMVJRNCHG  JRN(JGLC2000) FILE((ACCNTAB) (RECOMD))
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801)
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
 
/* End journal all files if previous error occured                   */
 
/**/                                                                  /*CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),   */ /*CCB009*/
/**/                                                                  /*CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             ENDJRNPF   FILE(*ALL) JRN(JGLC2000)
             MONMSG MSGID(CPF0000)
 
/* Delete and recreate journal and receivers                         */
 
             DLTJRN     JRN(JGLC2000)
             MONMSG MSGID(CPF0000)
             CHGJOB     INQMSGRPY(*DFT)
             DLTJRNRCV  JRNRCV(JRGLC2000)
             MONMSG MSGID(CPF0000)
             CHGJOB     INQMSGRPY(*RQD)
             CRTJRNRCV  JRNRCV(&TOLIB/JRGLC2000)
             CRTJRN     JRN(&TOLIB/JGLC2000) JRNRCV(&TOLIB/JRGLC2000)
             STRJRNPF   FILE(ACCNTAB RECOMD) JRN(JGLC2000) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)
/*/COPY WNCPYSRC,GLC2000005                                          */
             ENDDO                                                    /*CCB009*/
/**/
 RETRY:      ALCOBJ     OBJ((ACNUMA *FILE *EXCL))
                        MONMSG  MSGID(CPF0000) EXEC(DO)
                        DLYJOB  DLY(60)
                        GOTO    RETRY
             ENDDO
/**/
/*/COPY WNCPYSRC,GLC2000002                                          */
 
             CHGVAR     VAR(&STAT) VALUE('Y')                         /*CCB009*/
/**/                                                                  /*CCB009*/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)           /*CCB009*/
/**/                                                                  /*CCB009*/
/*/COPY WNCPYSRC,GLC2000014                                          */
             CALL       PGM(GL2000)
/*/COPY WNCPYSRC,GLC2000003                                          */
 
             IF  COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
                SNDMSG     MSG('GL2000 ended abnormally for job ' *CAT +
                             &JOBNO *TCAT '/' *TCAT &USER *TCAT '/' +
                             *TCAT &JOB *TCAT '.') TOMSGQ(MOPERQ MRUNQ)
/*/COPY WNCPYSRC,GLC2000006                                          */
/**/                                                                  /*CCB009*/
/* If Feature CCB009 is 'on' (close of business journaling),       */ /*CCB009*/
/**/                                                                  /*CCB009*/
             IF         COND(&CCB009 *EQ '       ') THEN(DO)          /*CCB009*/
/**/                                                                  /*CCB009*/
/*  Retrieve attributes of current job.                            */ /*CCB009*/
/**/                                                                  /*CCB009*/
             RTVJOBA    JOB(&CCB009JOB) USER(&CCB009USR) +
                          NBR(&CCB009NBR)                             /*CCB009*/
/**/                                                                  /*CCB009*/
/*  Retrieve the most recent journal entry sequence number         */ /*CCB009*/
/*  for the specific job.                                          */ /*CCB009*/
/**/                                                                  /*CCB009*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                          TOENT(*FIRST) SEARCH(*DESCEND) +
                          JOB(&CCB009NBR/&CCB009USR/&CCB009JOB) +
                          RTNSEQNBR(&START)                           /*CCB009*/
/**/                                                                  /*CCB009*/
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
/**/                                                                  /*CCB009*/
/*  Remove journaled changes.                                      */ /*CCB009*/
/**/                                                                  /*CCB009*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)                                    /*CCB009*/
             RMVJRNCHG  JRN(ICJRN) FILE((ACCNTAB) (RECOMD)) +
                          FROMENT(&START) TOENT(&FINISH)              /*CCB009*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041) +
                                                                      /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ELSE       CMD(DO)                                       /*CCB009*/
                RMVJRNCHG  JRN(JGLC2000) FILE((ACCNTAB) (RECOMD))
                MONMSG     (CPF7049)
             ENDDO                                                    /*CCB009*/
/*/COPY WNCPYSRC,GLC2000007                                          */
             ENDDO
 
             ELSE       CMD(DO)
                SNDMSG     MSG('GLC2000 - Turnover statements print +
                             complete') TOMSGQ(MRUNQ)
/*/COPY WNCPYSRC,GLC2000008                                          */
             ENDDO
 
 
/*/COPY WNCPYSRC,GLC2000009                                          */
/**/                                                                  /*CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),   */ /*CCB009*/
/**/                                                                  /*CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             ENDJRNPF   FILE(*ALL) JRN(JGLC2000)
             MONMSG MSGID(CPF0000)
             DLTJRN     JRN(JGLC2000)
             MONMSG MSGID(CPF0000)
             CHGJOB     INQMSGRPY(*DFT)
             DLTJRNRCV  JRNRCV(JRGLC2000)
             MONMSG MSGID(CPF0000)
             CHGJOB     INQMSGRPY(*RQD)
             ENDDO                                                    /*CCB009*/
/*/COPY WNCPYSRC,GLC2000010                                          */
             CHGJOB     PRTTXT(&PRTTXT)
             DLCOBJ     OBJ((ACNUMA *FILE *EXCL))                     /*092969*/
 
/*/COPY WNCPYSRC,GLC2000011                                          */
                 CHGVAR     VAR(&STAT) VALUE('N')                     /*CCB009*/
/**/                                                                  /*CCB009*/
                 CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)       /*CCB009*/
/**/                                                                  /*CCB009*/
             CHGVAR     VAR(&STEXT) VALUE(' ')                                            /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE('End of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                    /*CSC020*/
             SCWRTJREG  COMP(&CNAM) CMPSEQ(&CSEQ) FLAG('E') +
                          TEXT(&STEXT)                                                    /*CSC020*/
             RETURN
 
 ABNORMAL:   SNDMSG     MSG('GLC2000 ended abnormally for job ' *CAT +
                          &JOBNO *TCAT '/' *TCAT &USER *TCAT '/' +
                          *TCAT &JOB *TCAT '.') TOMSGQ(MOPERQ MRUNQ)
             CHGJOB     SWS(XXXXXXX1)
             MONMSG     MSGID(CPF0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*/COPY WNCPYSRC,GLC2000012                                          */
/*END:********ENDPGM************************************************************************CSC020*/
 END:                                                                                     /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE(' ')                                            /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE('End of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                    /*CSC020*/
             SCWRTJREG  COMP(&CNAM) CMPSEQ(&CSEQ) FLAG('E') +
                          TEXT(&STEXT)                                                    /*CSC020*/
             RETURN                                                                       /*CSC020*/
             ENDPGM                                                                       /*CSC020*/
/*/COPY WNCPYSRC,GLC2000013                                          */
