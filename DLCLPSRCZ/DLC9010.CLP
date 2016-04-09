/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Statement file extract')                     */
/*******************************************************************/
/*                                                                 */
/*       Midas - Dealing Module                            */
/*                                                                 */
/*       DLC9010 - STATEMENT HISTORY EXTRACT.                      */
/*                                                                 */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                 */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC020             Date 31Mar04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*        Prev Amend No. CCB009         DATE 01Jun00               */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                     : S01408         DATE : 04MAY95             */
/*                     : S01390         DATE : 04AUG92             */
/*                     : S01179         DATE : 17/01/89            */
/*                       AUS006         DATE : 18DEC90             */
/*                                                                 */
/*-----------------------------------------------------------------*/
/*                                                                 */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*       CCB009 - Journal files throughout close of business       */
/*       S01408 - Addition of core hook DLC9010MP1                 */
/*       S01390 - Release 10 Changes for Australianisation         */
/*       S01179 - AS/400 CONVERSION                                */
/*       AUS006 - AUSTRALIAN PRODUCT - INTEREST HISTORY            */
/*                                                                 */
/*********************************************************************/
/************PGM                                                     * *S01390*/
             PGM        PARM(&CNAM &CSEQ)                             /*S01390*/
 
/************DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)                * *S01390*/
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(6) VALUE('  JLIB')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01390*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)                  /*S01390*/
             DCL        VAR(&STATUS) TYPE(*CHAR) LEN(1)               /*S01390*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*S01390*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*S01390*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*S01390*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*S01390*/
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
             DCL        VAR(&CSEQA) TYPE(*CHAR) LEN(5)                                    /*CSC020*/
             DCL        VAR(&STEXT) TYPE(*CHAR) LEN(50)                                   /*CSC020*/
/*/COPY WNCPYSRC,DLC9010001                                          */
/**/                                                                  /*S01390*/
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
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*S01390*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*S01390*/
             CHGVAR     VAR(&SAR) VALUE('AUS006')                     /*S01390*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*S01390*/
             IF         COND(&RTCD *NE '       ') THEN(GOTO +
                          CMDLBL(END))                                /*S01390*/
             SNDPGMMSG  MSG('DLC9010 - Statement History File +
                          Extract') TOMSGQ(MRUNQ)
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
/************RTVDTAARA  DTAARA(DLSTAT (17 3)) RTNVAR(&BUSY)          * *S01390*/
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STATUS)         /*S01390*/
             CLRPFM     STHSTAA
 
/************IF         COND(&BUSY *EQ 'NEW') THEN(DO)               * *S01390*/
             IF         COND(&STATUS *EQ 'Y') THEN(DO)                /*S01390*/
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
             RMVJRNCHG  JRN(ICJRN) FILE((HISTSAA) (STHSTAA)) +
                          FROMENT(&START) TOENT(&FINISH)              /*CCB009*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041) +
                                                                      /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ELSE       CMD(DO)                                       /*CCB009*/
 
/*/COPY WNCPYSRC,DLC9010002                                          */
               CHKOBJ     OBJ(JRDL9010) OBJTYPE(*JRNRCV)
               MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(NOJRNRCV))
 
               CHKOBJ     OBJ(JDL9010) OBJTYPE(*JRN)
               MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(NOJRN))
 
               RMVJRNCHG  JRN(JDL9010) FILE((HISTSAA) (STHSTAA))
               MONMSG     MSGID(CPF7042 CPF7049)
 
               ENDJRNPF   FILE(*ALL) JRN(JDL9010)
               MONMSG     MSGID(CPF7032)
 
               DLTJRN     JRN(JDL9010)
 
 NOJRN:        CHGJOB     INQMSGRPY(*DFT)
               DLTJRNRCV  JRNRCV(JRDL9010)
               CHGJOB     INQMSGRPY(*RQD)
             ENDDO                                                    /*CCB009*/
 
/***NOJRNRCV:       CHGDTAARA  DTAARA(DLSTAT (17 3)) VALUE('OLD')    * *S01390*/
 
/*/COPY WNCPYSRC,DLC9010003                                          */
/************ENDDO                                                   * *S01390*/
NOJRNRCV:    ENDDO                                                    /*S01390*/
 
/************CHGDTAARA  DTAARA(DLSTAT (17 3)) VALUE('NEW')           * *S01390*/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ 'Y')             /*S01390*/
 
             CHGVAR     VAR(%SST(&JLIB 1 2)) VALUE(&SYSID)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,DLC9010MP1                                          */
                                                                      /*S01408*/
 
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/*           CRTJRNRCV  JRNRCV(JRDL9010.&JLIB)                          S01179*/
             CRTJRNRCV  JRNRCV(&JLIB/JRDL9010)                        /*S01179*/
 
/*           CRTJRN     JRN(JDL9010.&JLIB) JRNRCV(JRDL9010.&JLIB)       S01179*/
             CRTJRN     JRN(&JLIB/JDL9010) JRNRCV(&JLIB/JRDL9010)     /*S01179*/
 
/*           JRNPF      FILE(HISTSAA STHSTAA) JRN(JDL9010) +            S01179*/
             STRJRNPF   FILE(HISTSAA STHSTAA) JRN(JDL9010) +
                          IMAGES(*BOTH)
             ENDDO                                                    /*CCB009*/
/*/COPY WNCPYSRC,DLC9010004                                          */
 
/*           CALL       PGM(DL9010.*LIBL)                               S01179*/
             CALL       PGM(DL9010)                                   /*S01179*/
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*S01097*/
 
 
/*/COPY WNCPYSRC,DLC9010005                                          */
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             ENDJRNPF FILE(*ALL) JRN(JDL9010)
 
             DLTJRN JRN(JDL9010)
 
             CHGJOB INQMSGRPY(*DFT)
 
             DLTJRNRCV JRNRCV(JRDL9010)
 
             CHGJOB INQMSGRPY(*RQD)
             ENDDO                                                    /*CCB009*/
/*/COPY WNCPYSRC,DLC9010006                                          */
 
/************CHGDTAARA DTAARA(DLSTAT (17 3)) VALUE('OLD')            * *S01390*/
             CALL      PGM(CB0150) PARM(&CNAM &CSEQ 'N')              /*S01390*/
 
/*/COPY WNCPYSRC,DLC9010007                                          */
             GOTO END
 
/*/COPY WNCPYSRC,DLC9010008                                          */
  ABNOR:     RMVJRNCHG JRN(JDL9010) FILE((HISTSAA) (STHSTAA))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*CCB009*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/*/COPY WNCPYSRC,DLC9010009                                          */
             ENDJRNPF FILE(*ALL) JRN(JDL9010)
             DLTJRN JRN(JDL9010)
             CHGJOB INQMSGRPY(*DFT)
             DLTJRNRCV JRNRCV(JRDL9010)
             CHGJOB INQMSGRPY(*RQD)
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
             RMVJRNCHG  JRN(ICJRN) FILE((HISTSAA) (STHSTAA)) +
                          FROMENT(&START) TOENT(&FINISH)              /*CCB009*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041) +
                                                                      /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
/*/COPY WNCPYSRC,DLC9010010                                          */
             CHGJOB SWS(XXXXXXX1)
/************CHGDTAARA DTAARA(DLSTAT (17 3)) VALUE('OLD')            * *S01390*/
             CALL      PGM(CB0150) PARM(&CNAM &CSEQ 'N')              /*S01390*/
/***END:         ENDPGM                                              * *S01390*/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*/COPY WNCPYSRC,DLC9010011                                          */
/*                                                                                        /*CSC020*/
/* Write current journal sequence number to file SCJSEQPD, using command SCWRTJREG.       /*CSC020*/
/*                                                                                        /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE(' ')                                            /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE('End of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                    /*CSC020*/
             SCWRTJREG  COMP(&CNAM) CMPSEQ(&CSEQ) FLAG('E') +
                          TEXT(&STEXT)                                                    /*CSC020*/
             RETURN                                                                       /*CSC020*/
             ENDPGM                                                   /*S01390*/
