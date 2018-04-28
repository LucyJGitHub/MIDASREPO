/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Transfer of f/c income and expense')         */
/********************************************************************/
/*                                                                  */
/*        Midas - General Ledger Module                     */
/*                                                                  */
/*       GLC39 - TRANSFER OF F/C INCOME AND EXPENSE                 */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CGL023             Date 31Jul03             */
/*       Prev Amend No. CSC020             Date 31Mar04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CCM003             Date  01Feb01             */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             DATE  01Jun00             */
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CMC001             DATE  04JUL96            */
/*                      S01408             DATE  04AUG95            */
/*                      S01408             DATE  04MAY95            */
/*                      LN0870             DATE  16OCT90            */
/*                      E15192             DATE  01OCT90            */
/*                      S01189             DATE 04/04/89            */
/*                      S01117             DATE 01/03/89            */
/*                      E10877             DATE 12/05/87            */
/*                      S01099             DATE 04/07/86            */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       CGL023 - Retention of Currency of Balance.                 */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*       CCM003  -  Download of Transfer F/C income and expense.    */
/*       CCB009 - Journal files throughout close of business         */
/*       CMC001  -  Management Accounts Enhancement for PCA:        */
/*                  Do not process if it is a Bccy transfer.        */
/*       S01408  -  Addition of core hook GLC39INT                  */
/*                  Addition of core hook GLC39001                  */
/*       S01408  -  Addition of core hook GLC39MP1                  */
/*       LN0870  -  PREVENT LOOP IF DBF ERROR                       */
/*       E15192  -  Split Bccy and Fccy trans into two processes    */
/*       S01189  -  COB RECOVERY PROCESSING.                        */
/*       S01117  -  MULTIBRANCHING                                  */
/*       E10877  -  MONMSG ADDED TO END JOURNALLING                 */
/*       S01099  -  REWRITTEN TO INTRODUCE JOURNALLING              */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/********    PGM                                                      /*S01189*/
/**********  PGM        PARM(&CNAM &CSEQ)                 /*S01189*/  /*E15192*/
             PGM        PARM(&CNAM &CSEQ &FORB)                       /*E15192*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(6) VALUE('  JLIB')  /*S1099*/
/********    DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)       /*S1099*/ /*S01189*/
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)                 /*S1099*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                /*S01189*/
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')      /*S01189*/
             DCL        VAR(&FORB) TYPE(*CHAR) LEN(1)                 /*E15192*/
             DCL        VAR(&RTCD)  TYPE(*CHAR) LEN(7) VALUE(' ')     /*CMC001*/
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)              /*CMC001*/
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
/*                                                                      CCB009*/
/* Declare job name, user and number for remove journal changes         CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009JOB) TYPE(*CHAR) LEN(10)           /*CCB009*/
             DCL        VAR(&CCB009USR) TYPE(*CHAR) LEN(10)           /*CCB009*/
             DCL        VAR(&CCB009NBR) TYPE(*CHAR) LEN(6)            /*CCB009*/
             DCL        VAR(&CB0180DA) TYPE(*CHAR) LEN(26)            /*CCB009*/
             DCL        VAR(&START) TYPE(*DEC) LEN(10 0)              /*CCB009*/
             DCL        VAR(&FINISH) TYPE(*DEC) LEN(10 0)             /*CCB009*/
/*                                                                      CGL023*/
/* Declare parameters to AOSVALR0                                       CGL023*/
/*                                                                      CGL023*/
             DCL        VAR(&CGL023) TYPE(*CHAR) LEN(1) VALUE('N')    /*CGL023*/
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7) VALUE('       +
                          ')                                          /*CGL023*/
             DCL        VAR(&POP01) TYPE(*CHAR) LEN(20) +
                          VALUE('RetainCcyofBalance')                 /*CGL023*/
             DCL        VAR(&POP02) TYPE(*CHAR) LEN(20)               /*CGL023*/
             DCL        VAR(&POP03) TYPE(*CHAR) LEN(20)               /*CGL023*/
             DCL        VAR(&POP04) TYPE(*CHAR) LEN(20)               /*CGL023*/
             DCL        VAR(&POP05) TYPE(*CHAR) LEN(20)               /*CGL023*/
             DCL        VAR(&POP06) TYPE(*CHAR) LEN(20)               /*CGL023*/
             DCL        VAR(&POP07) TYPE(*CHAR) LEN(20)               /*CGL023*/
             DCL        VAR(&POP08) TYPE(*CHAR) LEN(20)               /*CGL023*/
             DCL        VAR(&POP09) TYPE(*CHAR) LEN(20)               /*CGL023*/
             DCL        VAR(&POP10) TYPE(*CHAR) LEN(20)               /*CGL023*/
             DCL        VAR(&PVL01) TYPE(*CHAR) LEN(200)              /*CGL023*/
             DCL        VAR(&PVL02) TYPE(*CHAR) LEN(200)              /*CGL023*/
             DCL        VAR(&PVL03) TYPE(*CHAR) LEN(200)              /*CGL023*/
             DCL        VAR(&PVL04) TYPE(*CHAR) LEN(200)              /*CGL023*/
             DCL        VAR(&PVL05) TYPE(*CHAR) LEN(200)              /*CGL023*/
             DCL        VAR(&PVL06) TYPE(*CHAR) LEN(200)              /*CGL023*/
             DCL        VAR(&PVL07) TYPE(*CHAR) LEN(200)              /*CGL023*/
             DCL        VAR(&PVL08) TYPE(*CHAR) LEN(200)              /*CGL023*/
             DCL        VAR(&PVL09) TYPE(*CHAR) LEN(200)              /*CGL023*/
             DCL        VAR(&PVL10) TYPE(*CHAR) LEN(200)              /*CGL023*/
/*                                                                      CGL023*/
/* Declare parameters to SD2001                                         CGL023*/
             DCL        VAR(&FEOY) TYPE(*CHAR) LEN(1) VALUE(' ')      /*CGL023*/
             DCL        VAR(&EROR) TYPE(*CHAR) LEN(1) VALUE(' ')      /*CGL023*/
             DCL        VAR(&CSEQA) TYPE(*CHAR) LEN(5)                                    /*CSC020*/
             DCL        VAR(&STEXT) TYPE(*CHAR) LEN(50)                                   /*CSC020*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC39INT                                            */
                                                                      /*S01408*/
             MONMSG MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)   /*E10877*/
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
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
/*                                                                      CCB009*/
/* If Feature CCB009 is 'on' (close of business journaling),            CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *EQ '       ') THEN(DO)          /*CCB009*/
/*                                                                      CCB009*/
/* Retrieve current job attributes.                                     CCB009*/
/*                                                                      CCB009*/
             RTVJOBA    JOB(&CCB009JOB) USER(&CCB009USR) +
                          NBR(&CCB009NBR)                             /*CCB009*/
             ENDDO                                                    /*CCB009*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC39001                                            */
                                                                      /*S01408*/
/**/                                                                   /*S1099*/
             IF         COND(&FORB *EQ 'F') THEN(DO)                  /*E15192*/
/*                                                                      CGL023*/
/* Check if the current setting of Retain Ccy of Balance is 'Y'         CGL023*/
             CALL       PGM(AOSVALR0) PARM(&PRTCD &POP01 &PVL01 +
                          &POP02 &PVL02 &POP03 &PVL03 &POP04 &PVL04 +
                          &POP05 &PVL05 &POP06 &PVL06 &POP07 &PVL07 +
                          &POP08 &PVL08 &POP09 &PVL09 &POP10 &PVL10)  /*CGL023*/
             IF         COND(&PRTCD *EQ '       ') THEN(DO)           /*CGL023*/
               CHGVAR     VAR(&CGL023) VALUE(%SUBSTRING(&PVL01 1 1))  /*CGL023*/
             ENDDO                                                    /*CGL023*/
             ELSE       CMD(DO)                                       /*CGL023*/
               SNDPGMMSG  MSG('Database Error in File SDSVALPD, Key +
                          RetainCcyofBalance') TOMSGQ(MRUNQ)          /*CGL023*/
               GOTO       CMDLBL(ABNOR)                               /*CGL023*/
             ENDDO                                                    /*CGL023*/
/*                                                                      CGL023*/
/* Financial Year End ?                                                 CGL023*/
             CALL       PGM(SD2001) PARM(&FEOY &EROR)                 /*CGL023*/
             IF         COND(&EROR *EQ 'Y') THEN(DO)                  /*CGL023*/
               SNDPGMMSG  MSG('Pgm SD2001 ended in error') +
                          TOMSGQ(MRUNQ)                               /*CGL023*/
               GOTO       CMDLBL(ABNOR)                               /*CGL023*/
             ENDDO                                                    /*CGL023*/
/*                                                                      CGL023*/
/* DO NOT process if Retain Ccy of Balance is 'Y' and                   CGL023*/
/* it is NOT financial year end.                                        CGL023*/
             IF         COND(&CGL023 *EQ 'Y' *AND &FEOY *NE 'Y') +
                          THEN(GOTO CMDLBL(ENDPGM))                   /*CGL023*/
                                                                      /*CGL023*/
             SNDPGMMSG  MSG('GLC39 - Transfer of F/C Income and Expense') +
                          TOMSGQ(MRUNQ)
/**/
             CLRPFM     FILE(GEXFHH)
             CLRPFM     FILE(GEXFPD)
             CLRPFM     FILE(GEXFZZ)
/*/COPY WNCPYSRC,GLC39014                                            */
 
             ENDDO                                                    /*E15192*/
 
             ELSE       CMD(DO)                                       /*E15192*/
/**/
/**  Check if Management Accounts Enhancement is installed.  If it */ /*CMC001*/
/**  is, then skip further processing of base ccy transfers.       */ /*CMC001*/
                                                                      /*CMC001*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CMC001' +
                          &DSFDY)                                     /*CMC001*/
             IF         COND(&RTCD *EQ ' ') THEN(GOTO CMDLBL(ENDPGM)) /*CMC001*/
 
             SNDPGMMSG  MSG('GLC39 - Transfer of base ccy Income and +
                          Expense') TOMSGQ(MRUNQ)                     /*E15192*/
 
             CLRPFM     FILE(GEXBHH)                                  /*E15192*/
             CLRPFM     FILE(GEXBPD)                                  /*E15192*/
             CLRPFM     FILE(GEXBZZ)                                  /*E15192*/
             OVRDBF     FILE(GEXFHH) TOFILE(GEXBHH)                   /*E15192*/
             OVRDBF     FILE(GEXFPD) TOFILE(GEXBPD)                   /*E15192*/
             OVRDBF     FILE(GEXFZZ) TOFILE(GEXBZZ)                   /*E15192*/
 
             ENDDO                                                    /*E15192*/
/**/                                                                   /*S1099*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)            /*S1099*/
/********    RTVDTAARA  DTAARA(GLSTAT (57 1)) RTNVAR(&BUSY) /*S1099*/ /*S01189*/
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)           /*S01189*/
/*   IF RESTART, REMOVE JOURNALLED CHANGES   */                        /*S1099*/
/********    IF         COND(&BUSY = 'Y') THEN(DO)          /*S1099*/ /*S01189*/
             IF         COND(&STAT *EQ 'Y') THEN(DO)                  /*S01189*/
/*/COPY WNCPYSRC,GLC39004                                            */
/*                                                                      CCB009*/
/* If Feature CCB009 is 'on' (close of business journaling),            CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *EQ '       ') THEN(DO)          /*CCB009*/
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
             CHGVAR     VAR(&CCB009USR) VALUE(%SST(&CB0180DA 11 10)) +
                                                                      /*CCB009*/
             CHGVAR     VAR(&CCB009NBR) VALUE(%SST(&CB0180DA 21 6)) +
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
             RMVJRNCHG  JRN(ICJRN) FILE((ACCNTAB)) FROMENT(&START) +
                          TOENT(&FINISH)                              /*CCB009*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041) +
                                                                      /*CCB009*/
             CHGPF      FILE(ACCNTAB) FRCRATIO(*NONE)                 /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ELSE       CMD(DO)                                       /*CCB009*/
                CHKOBJ     OBJ(JRGLC39) OBJTYPE(*JRNRCV)               /*S1099*/
                MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(NOJRNRCV))  /*S1099*/
                CHKOBJ     OBJ(JGLC39) OBJTYPE(*JRN)                   /*S1099*/
                MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(NOJRN))     /*S1099*/
                RMVJRNCHG  JRN(JGLC39) FILE(ACCNTAB)                   /*S1099*/
                MONMSG     (CPF7042 CPF7049)                           /*S1099*/
                ENDJRNPF   FILE(*ALL) JRN(JGLC39)                      /*S1099*/
                CHGPF      FILE(ACCNTAB) FRCRATIO(*NONE)               /*S1099*/
                MONMSG     MSGID(CPF7032)                              /*S1099*/
                DLTJRN     JRN(JGLC39)                                 /*S1099*/
NOJRN:          CHGJOB     INQMSGRPY(*DFT)                             /*S1099*/
                DLTJRNRCV  JRNRCV(JRGLC39)                             /*S1099*/
                CHGJOB     INQMSGRPY(*RQD)                             /*S1099*/
             ENDDO                                                    /*CCB009*/
/*/COPY WNCPYSRC,GLC39005                                            */
/*NOJRNRCV:*****CHGDTAARA  DTAARA(GLSTAT (57 1)) VALUE('N') /*S1099*/ /*S01189*/
 NOJRNRCV:      CHGVAR     VAR(&STAT) VALUE('N')                      /*S01189*/
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)        /*S01189*/
             ENDDO                                                     /*S1099*/
/*   CREATE JOURNAL & RECEIVER   */                                    /*S1099*/
/********    CHGDTAARA  DTAARA(GLSTAT (57 1)) VALUE('Y')    /*S1099*/ /*S01189*/
             CHGVAR     VAR(&STAT) VALUE('Y')                         /*S01189*/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)           /*S01189*/
             CHGVAR     VAR(%SUBSTRING(&JLIB 1 2)) VALUE(&SYSID)       /*S1099*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC39MP1                                            */
                                                                      /*S01408*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             CRTJRNRCV  JRNRCV(&JLIB/JRGLC39)                          /*S1099*/
             CRTJRN     JRN(&JLIB/JGLC39) JRNRCV(&JLIB/JRGLC39)        /*S1099*/
             CHGPF      FILE(ACCNTAB) FRCRATIO(500)                    /*S1099*/
             STRJRNPF   FILE(ACCNTAB) JRN(JGLC39) IMAGES(*BOTH)        /*S1099*/
             ENDDO                                                    /*CCB009*/
/*/COPY WNCPYSRC,GLC39006                                            */
/**/
/*           OVRDBF     FILE(TABLE) TOFILE(TABGL)        */            /*S1099*/
/*           OVRDBF     FILE(TABC) TOFILE(TABGL)         */            /*S1099*/
/*/COPY WNCPYSRC,GLC39003                                            */
/********    CALL       PGM(GL0800)    */                             /*E15192*/
             CALL       PGM(GL0800) PARM(&FORB)                       /*E15192*/
/*/COPY WNCPYSRC,GLC39015                                            */
/*           DLTOVR     FILE(TABLE TABC)                 */            /*S1099*/
/**/
             IF         COND(%SWITCH(XXXXXX0X)) THEN(DO)
/**/
                IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
/**/
                SNDPGMMSG  MSG('File Out of Balance - ACCNT') +
                             TOMSGQ(MRUNQ)
                SNDPGMMSG  MSG('File Out of Balance - ACCNT') +
                             TOMSGQ(MOPERQ)
                GOTO ENDPGM                                            /*S1099*/
/**/
                ENDDO
/**/
             ENDDO
/**/
             ELSE       CMD(DO)
/**/
/**/                                                                  /*S01194*/
/***********    SNDPGMMSG  MSG('TABLE FILE DATA ERROR') TOMSGQ(MRUNQ) */
/***********    SNDPGMMSG  MSG('TABLE FILE DATA ERROR') TOMSGQ(MOPERQ)*/
/**/                                                                  /*S01194*/
                GOTO ABNOR                                             /*S1099*/
/**/
             ENDDO
             IF         COND(&FORB *EQ 'F') THEN(DO)                  /*CCM003*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CCM003' +
                          &DSFDY)                                     /*CCM003*/
             IF         COND(&RTCD *EQ ' ') THEN(DO)                  /*CCM003*/
             OVRDBF     FILE(GEXFPD) SHARE(*YES)                      /*CCM003*/
             OPNQRYF    FILE((GEXFPD)) KEYFLD((BRCA) (CNUM) (CCY))    /*CCM003*/
             CPYF       FROMFILE(DLETPLPD) TOFILE(QTEMP/PLWORKPP) +
                          MBROPT(*NONE) CRTFILE(*YES)                 /*CCM003*/
             CLRPFM     FILE(QTEMP/PLWORKPP)                          /*CCM003*/
             OVRDBF     FILE(DLETPLPD) TOFILE(QTEMP/PLWORKPP)         /*CCM003*/
             CALL       PGM(DL0013)                                   /*CCM003*/
             DLTOVR     FILE(GEXFPD)                                  /*CCM003*/
             DLTOVR     FILE(DLETPLPD)                                /*CCM003*/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO +
                          CMDLBL(ABNOR))                              /*CCM003*/
             CPYF       FROMFILE(QTEMP/PLWORKPP) TOFILE(DLETPLPD) +
                          MBROPT(*ADD)                                /*CCM003*/
             ENDDO                                                    /*CCM003*/
             ENDDO                                                    /*CCM003*/
/*/COPY WNCPYSRC,GLC39002                                            */
/**/
/*   SUCCESSFUL COMPLETION - DELETE JOURNAL & RECEIVER   */            /*S1099*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
                ENDJRNPF   FILE(*ALL) JRN(JGLC39)                      /*S1099*/
                CHGPF      FILE(ACCNTAB) FRCRATIO(*NONE)               /*S1099*/
                DLTJRN     JGLC39                                      /*S1099*/
                CHGJOB     INQMSGRPY(*DFT)                             /*S1099*/
                DLTJRNRCV  JRGLC39                                     /*S1099*/
                CHGJOB     INQMSGRPY(*RQD)                             /*S1099*/
             ENDDO                                                    /*CCB009*/
/*/COPY WNCPYSRC,GLC39007                                            */
/********       CHGDTAARA  DTAARA(GLSTAT (57 1)) VALUE('N') /*S1099*/ /*S01189*/
                CHGVAR     VAR(&STAT) VALUE('N')                      /*S01189*/
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)        /*S01189*/
/*/COPY WNCPYSRC,GLC39008                                            */
             GOTO ENDPGM                                               /*S1099*/
/*   UNSUCCESSFUL COMPLETION - REMOVE JOURNALLED CHANGES   */          /*S1099*/
/*/COPY WNCPYSRC,GLC39009                                            */
 ABNOR:      RMVJRNCHG  JRN(JGLC39) FILE(ACCNTAB)                      /*S1099*/
/*/COPY WNCPYSRC,GLC39010                                            */
             MONMSG MSGID(CPF0000 RPG0000 MCH0000)                    /*LN0870*/
 /*          MONMSG     (CPF7049)                 */     /*S1099*/    /*LN0870*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             ENDJRNPF   FILE(*ALL) JRN(JGLC39)                         /*S1099*/
             MONMSG MSGID(CPF0000 RPG0000 MCH0000)                    /*LN0870*/
             CHGPF      FILE(ACCNTAB) FRCRATIO(*NONE)                  /*S1099*/
             MONMSG MSGID(CPF0000 RPG0000 MCH0000)                    /*LN0870*/
             DLTJRN     JRN(JGLC39)                                    /*S1099*/
             MONMSG MSGID(CPF0000 RPG0000 MCH0000)                    /*LN0870*/
             CHGJOB     INQMSGRPY(*DFT)                                /*S1099*/
             MONMSG MSGID(CPF0000 RPG0000 MCH0000)                    /*LN0870*/
             DLTJRNRCV  JRNRCV(JRGLC39)                                /*S1099*/
             MONMSG MSGID(CPF0000 RPG0000 MCH0000)                    /*LN0870*/
             CHGJOB     INQMSGRPY(*RQD)                                /*S1099*/
             MONMSG MSGID(CPF0000 RPG0000 MCH0000)                    /*LN0870*/
             ENDDO                                                    /*CCB009*/
             ELSE       CMD(DO)                                       /*CCB009*/
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
             RMVJRNCHG  JRN(ICJRN) FILE((ACCNTAB)) FROMENT(&START) +
                          TOENT(&FINISH)                              /*CCB009*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041) +
                                                                      /*CCB009*/
             CHGPF      FILE(ACCNTAB) FRCRATIO(*NONE)                 /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
/*/COPY WNCPYSRC,GLC39011                                            */
 
             IF         COND(&FORB *EQ 'F') THEN(DO)                  /*E15192*/
             CLRPFM     FILE(GEXFHH)                                   /*S1099*/
             MONMSG MSGID(CPF0000 RPG0000 MCH0000)                    /*LN0870*/
             CLRPFM     FILE(GEXFPD)                                   /*S1099*/
             MONMSG MSGID(CPF0000 RPG0000 MCH0000)                    /*LN0870*/
             CLRPFM     FILE(GEXFZZ)                                   /*S1099*/
             MONMSG MSGID(CPF0000 RPG0000 MCH0000)                    /*LN0870*/
             ENDDO                                                    /*E15192*/
             ELSE       CMD(DO)                                       /*E15192*/
             CLRPFM     FILE(GEXBHH)                                  /*E15192*/
             MONMSG MSGID(CPF0000 RPG0000 MCH0000)                    /*LN0870*/
             CLRPFM     FILE(GEXBPD)                                  /*E15192*/
             MONMSG MSGID(CPF0000 RPG0000 MCH0000)                    /*LN0870*/
             CLRPFM     FILE(GEXBZZ)                                  /*E15192*/
             MONMSG MSGID(CPF0000 RPG0000 MCH0000)                    /*LN0870*/
             ENDDO                                                    /*E15192*/
 
/********    CHGDTAARA  DTAARA(GLSTAT (57 1)) VALUE('N')    /*S1099*/ /*S01189*/
             CHGVAR     VAR(&STAT) VALUE('N')                         /*S01189*/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)           /*S01189*/
             CHGJOB     SWS(XXXXXXX1)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*/COPY WNCPYSRC,GLC39012                                            */
/*ENDPGM:*****ENDPGM******************************************************S1099*************CSC020*/
 ENDPGM:                                                                                  /*CSC020*/
/*                                                                                        /*CSC020*/
/* Write current journal sequence number to file SCJSEQPD, using command SCWRTJREG.       /*CSC020*/
/*                                                                                        /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE(' ')                                            /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE('End of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                    /*CSC020*/
             SCWRTJREG  COMP(&CNAM) CMPSEQ(&CSEQ) FLAG('E') +
                          TEXT(&STEXT)                                                    /*CSC020*/
             RETURN                                                                       /*CSC020*/
             ENDPGM                                                                       /*CSC020*/
/*/COPY WNCPYSRC,GLC39013                                            */
