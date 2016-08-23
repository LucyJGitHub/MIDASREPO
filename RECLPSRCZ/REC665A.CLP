/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Calculate TEG for alternates')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                               */
/*                                                                   */
/*       REC665A - CALCULATE TEG FOR ALTERNATIVE A/C'S               */
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
/*       Prev Amend No. CCB009             DATE 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             DATE 09MAY95              */
/*                      S01413 *CREATE     DATE 13APR93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*       CCB009 - Journal files throughout close of business         */
/*       S01408 - Addition of core hook REC665AMPS                   */
/*              - Addition of core hook REC665AMP1                   */
/*       S01413 - Retail 3 Incorporation                             */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/* */
/* This pgm use security copy of files instead of journaling */
/* */
/************PGM                                                        CCB009*/
             PGM        PARM(&CNAM &CSEQ)                             /*CCB009*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(6) VALUE('  JLIB')
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
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*CCB009*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                /*CCB009*/
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')      /*CCB009*/
             DCL        VAR(&CSEQA) TYPE(*CHAR) LEN(5)                                    /*CSC020*/
             DCL        VAR(&STEXT) TYPE(*CHAR) LEN(50)                                   /*CSC020*/
             DCLF       FILE(TABTBRE)
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
             RCVF       RCDFMT(TABTBREF)
             IF         COND(&TEGP *EQ 'Y') THEN(DO)
/* */
             SNDPGMMSG  MSG('REC665A - Calculate TEG for A+
             lternate A/C ') TOMSGQ(MRUNQ)
/* */
             RTVDTAARA  DTAARA(SDSTAT *ALL) RTNVAR(&SDSTAT)
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
/* */
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR     VAR(&DMLIB) VALUE(&PRE *TCAT 'DMLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,REC665AMPS                                          */
                                                                      /*S01408*/
/* */
             DLTF       FILE(XRECOMD)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XREACRD)
             MONMSG     MSGID(CPF0000)
/* */
STEP1:
             CRTDUPOBJ  OBJ(RECOMD) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
                          NEWOBJ(XRECOMD) DATA(*YES)
             MONMSG     MSGID(CPF0678 CPF2109 CPF2110 CPF2113 CPF2116 +
                          CPF2122 CPF2151 CPF2162 CPF2176 CPF2182) +
                          EXEC(DO)
             SNDPGMMSG  MSG('Error in CRTDUPOBJ of file : RECOMD by +
                          PGM : REC665A (STEP1)') TOMSGQ(MRUNQ)
             GOTO       CMDLBL(ENDPGM)
             ENDDO
/* */
STEP2:
             CRTDUPOBJ  OBJ(REACRD) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
                          NEWOBJ(XREACRD) DATA(*YES)
             MONMSG     MSGID(CPF0678 CPF2109 CPF2110 CPF2113 CPF2116 +
                          CPF2122 CPF2151 CPF2162 CPF2176 CPF2182) +
                          EXEC(DO)
             SNDPGMMSG  MSG('Error in CRTDUPOBJ of file : REACRD by +
                          PGM : REC665A (STEP2)') TOMSGQ(MRUNQ)
             GOTO       CMDLBL(ENDPGM)
             ENDDO
/* */
/*  If P/MFU indicator is 'OLD'  then                          */
/*   update file & P/MFU indicator to 'NEW'                    */
/* */
/*                                                                      CCB009*/
/* If this is a re-start,                                               CCB009*/
/*                                                                      CCB009*/
             IF         COND(&STAT *EQ 'Y') THEN(DO)                  /*CCB009*/
/*                                                                      CCB009*/
/* If Feature CCB009 is 'on' (close of business journaling),            CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *EQ '       ') THEN(DO)          /*CCB009*/
/*                                                                      CCB009*/
/* Retrieve data area CB0180DA from QTEMP.                              CCB009*/
/*                                                                      CCB009*/
             RTVDTAARA  DTAARA(QTEMP/CB0180DA) RTNVAR(&CB0180DA)      /*CCB009*/
/*                                                                      CCB009*/
/* If data area is not blank, calculate the job name, user and number   CCB009*/
/* of the previous run of this component.                               CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CB0180DA *NE ' ') THEN(DO)              /*CCB009*/
/*                                                                      CCB009*/
             CHGVAR     VAR(&CCB009JOB) VALUE(%SST(&CB0180DA 1 10))   /*CCB009*/
             CHGVAR     VAR(&CCB009USR) VALUE(%SST(&CB0180DA 11 10))  /*CCB009*/
             CHGVAR     VAR(&CCB009NBR) VALUE(%SST(&CB0180DA 21 6))   /*CCB009*/
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
             RMVJRNCHG  JRN(ICJRN) FILE((REHISPD)) FROMENT(&START) +
                          TOENT(&FINISH)                              /*CCB009*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041) +
                                                                      /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ELSE       CMD(DO)                                       /*CCB009*/
                 RMVJRNCHG  JRN(JREC665A) FILE((REHISPD))
                 MONMSG     MSGID(CPF7049 CPF9801)
                 ENDJRNPF   FILE(*ALL) JRN(JREC665A)
               MONMSG MSGID(CPF0000)
                 DLTJRN     JRN(JREC665A)
               MONMSG MSGID(CPF0000)
                 CHGJOB     INQMSGRPY(*DFT)
                 DLTJRNRCV  JRNRCV(JRREC665A)
               MONMSG MSGID(CPF0000)
                 CHGJOB     INQMSGRPY(*RQD)
             ENDDO                                                    /*CCB009*/
             CHGVAR     VAR(&STAT) VALUE('N')                         /*CCB009*/
/**/                                                                  /*CCB009*/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)           /*CCB009*/
             ENDDO                                                    /*CCB009*/
/* */
/*   Create journal & receiver   */
/* */
               CHGDTAARA  DTAARA(GLSTAT (57 1)) VALUE('Y')
               CHGVAR     VAR(%SUBSTRING(&JLIB 1 2)) VALUE(&SYSID)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,REC665AMP1                                          */
                                                                      /*S01408*/
             CHGVAR     VAR(&STAT) VALUE('Y')                         /*CCB009*/
/**/                                                                  /*CCB009*/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)           /*CCB009*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
               CRTJRNRCV  JRNRCV(&JLIB/JRREC665A)
               CRTJRN     JRN(&JLIB/JREC665A) JRNRCV(&JLIB/JRREC665A)
               STRJRNPF   FILE(REHISPD) +
                          JRN(JREC665A) IMAGES(*BOTH)
             ENDDO                                                    /*CCB009*/
               DLCOBJ     OBJ((RESTAT *DTAARA *EXCLRD))
/* */
             CALL       PGM(RE3665)
/* */
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
             CHGVAR     VAR(&STAT) VALUE('N')                         /*CCB009*/
/**/                                                                  /*CCB009*/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)           /*CCB009*/
               DLTF       FILE(XRECOMD)
               MONMSG     MSGID(CPF0000)
               DLTF       FILE(XREACRD)
               MONMSG     MSGID(CPF0000)
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
                 ENDJRNPF   FILE(*ALL) JRN(JREC665A)
               MONMSG     MSGID(CPF0000)
                 DLTJRN     JRN(JREC665A)
               MONMSG     MSGID(CPF0000)
                 CHGJOB     INQMSGRPY(*DFT)
                 DLTJRNRCV  JRNRCV(JRREC665A)
               MONMSG     MSGID(CPF0000)
                 CHGJOB     INQMSGRPY(*RQD)
             ENDDO                                                    /*CCB009*/
               CHGDTAARA  DTAARA(GLSTAT (57 1)) VALUE('N')
               GOTO       CMDLBL(ENDPGM)
             ENDDO
/* */
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
/* */
                 RTVDTAARA  DTAARA(LDA *ALL) RTNVAR(&LDA)
                 CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
/* */
                 SNDPGMMSG  MSGID(MEM0001) MSGF(REUSRMSG) MSGDTA(&MEM) +
                            TOMSGQ(MOPERQ MRUNQ)
/* */
/*                                                                      CCB009*/
/* If Feature CCB009 is 'on' (close of business journaling),            CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *EQ '       ') THEN(DO)          /*CCB009*/
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
             RMVJRNCHG  JRN(ICJRN) FILE((REHISPD)) FROMENT(&START) +
                          TOENT(&FINISH)                              /*CCB009*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041) +
                                                                      /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ELSE       CMD(DO)                                       /*CCB009*/
                 RMVJRNCHG  JRN(JREC665A) FILE((REHISPD))
                 MONMSG     MSGID(CPF7049 CPF9801)
                 ENDJRNPF   FILE(*ALL) JRN(JREC665A)
               MONMSG     MSGID(CPF0000)
                 DLTJRN     JRN(JREC665A)
               MONMSG     MSGID(CPF0000)
                 CHGJOB     INQMSGRPY(*DFT)
                 DLTJRNRCV  JRNRCV(JRREC665A)
               MONMSG     MSGID(CPF0000)
                 CHGJOB     INQMSGRPY(*RQD)
             ENDDO                                                    /*CCB009*/
                 CHGDTAARA  DTAARA(GLSTAT (57 1)) VALUE('N')
/* */
EXIT1:
             CPYF       FROMFILE(XRECOMD) TOFILE(RECOMD) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
 /* */
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDPGMMSG  MSG('Error in RESTART COPY with XRECOMD in +
                          REC3665 (EXIT1)') TOMSGQ(MRUNQ)
             ENDDO
/* */
EXIT2:
             CPYF       FROMFILE(XREACRD) TOFILE(REACRD) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
/* */
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDPGMMSG  MSG('Error in RESTART COPY with XREACRD in +
                          REC3665 (EXIT2)') TOMSGQ(MRUNQ)
             ENDDO
             CHGVAR     VAR(&STAT) VALUE('N')                         /*CCB009*/
/**/                                                                  /*CCB009*/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)           /*CCB009*/
             ENDDO
             ENDDO
             ELSE DO
             SNDPGMMSG  MSG('No records to process by RE3665') +
                          TOMSGQ(MRUNQ)
                          ENDDO
/* */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*ENDPGM:******ENDPGM***********************************************************************CSC020*/
ENDPGM:                                                                                   /*CSC020*/
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
