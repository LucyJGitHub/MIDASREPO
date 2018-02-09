/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE Retail account activity extract')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                               */
/*                                                                   */
/*       REC3860 -  RETAIL ACCOUNT ACTIVITY EXTRACT                  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. 257276             Date 10Dec12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSC020             Date 31Mar04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             DATE 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      087796             DATE 16JAN98              */
/*                      S01408             DATE 11MAY95              */
/*                      081266             DATE 13JAN95              */
/*                      058020             DATE 28SEP93              */
/*                      S01413 *CREATE     DATE 13APR93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       257276 - Initialise trailer file RTZZ member RACT if        */
/*                PF/ACCNTAB has no records. Applied Fix 217502.     */
/*              - Applied for AR937038 (Child: AR937039)             */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*       CCB009 - Journal files throughout close of business         */
/*   087796 - If there are no accounts do not run.                   */
/*   S01408 - Addition of core hook REC3860MPS                       */
/*            Addition of core hook REC3860MP1                       */
/*            Addition of core hook REC3860MP2                       */
/*   081266 - Add Global Monitor Message Processing, so the program  */
/*            removes journalled changes and removes journals etc    */
/*            after abnormal termination.                            */
/*          - Remove indefinite loop from program - if program       */
/*            cannot end journalling after 6 attempts, terminate     */
/*          - Format code to make it easier to follow                */
/*       058020 - PGM does not stop if RPG error                     */
/*       S01413 - Retail 3 Incorporation.                            */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(6) VALUE('  JLIB')
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(7) VALUE('  DMLIB')
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&RECORD) TYPE(*DEC) LEN(10 0)             /*087796*/
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(1)                 /*081266*/
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
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*081266*/
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
/**/
             RTVDTAARA  DTAARA(*LIBL/SDSTAT (6 2)) RTNVAR(&SYSID)
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
             SNDPGMMSG  MSG('REC3860 - Retail Account Activity +
                          Extract') TOMSGQ(*LIBL/MRUNQ)
             CHGVAR     VAR(%SUBSTRING(&DMLIB 1 2)) VALUE(&SYSID)
                                                                      /*087796*/
/*  If no accounts exist do not continue  */                          /*087796*/
             RTVMBRD    FILE(ACCNTAB) NBRCURRCD(&RECORD)              /*087796*/
/**********  IF         COND(&RECORD *EQ 0) THEN(GOTO CMDLBL(ENDPGM)) */           /*087796 257276*/
             IF         COND(&RECORD *EQ 0) THEN(DO)                                      /*257276*/
             CLRPFM     FILE(*LIBL/RTZZ) MBR(RACT)                                        /*257276*/
             OVRDBF     FILE(RTZZ) TOFILE(RTZZ) MBR(RACT)                                 /*257276*/
             CALL RE3860IN                                                                /*257276*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                                                  /*257276*/
             DLTOVR     FILE(*ALL)                                                        /*257276*/
             GOTO CMDLBL(ENDPGM)                                                          /*257276*/
           ENDDO                                                                          /*257276*/
                                                                      /*087796*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,REC3860MPS                                          */
                                                                      /*S01408*/
/**/
             CLRPFM     FILE(*LIBL/RACTRF)
             CLRPFM     FILE(*LIBL/RACTRG)
             CLRPFM     FILE(*LIBL/RTZZ) MBR(RACT)
             OVRDBF     FILE(ACCNTAB) SEQONLY(*YES 100)
             OVRDBF     FILE(XACCNTAB) SEQONLY(*YES 100)
             CHGVAR     VAR(&TOLIB) VALUE(&SYSID *TCAT 'DPLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,REC3860MP2                                          */
                                                                      /*S01408*/
/**/
/*       IF RESTART, REMOVE JOURNALLED CHANGES  */
/**/
           IF         COND(&STAT = 'Y') THEN(DO)
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
             RMVJRNCHG  JRN(*LIBL/ICJRN) FILE((*LIBL/REHPOSPP)) +
                          FROMENT(&START) TOENT(&FINISH)              /*CCB009*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041) +
                                                                      /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             CHKOBJ     OBJ(*LIBL/JRREC8D) OBJTYPE(*JRNRCV)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(NOJRNRCV))
             CHKOBJ     OBJ(*LIBL/JREC8D) OBJTYPE(*JRN)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(NOJRN))
/*/COPY WNCPYSRC,REC3860001                                          */
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             RMVJRNCHG  JRN(*LIBL/JREC8D) FILE((*LIBL/REHPOSPP))
/*/COPY WNCPYSRC,REC3860002                                          */
             MONMSG     MSGID(CPF7042 CPF7049)
             ENDDO                                                    /*CCB009*/
/*/COPY WNCPYSRC,REC3860003                                          */
             CPYF       FROMFILE(&DMLIB/XACCNTAB) +
                          TOFILE(&DMLIB/ACCNTAB) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817)
/*/COPY WNCPYSRC,REC3860004                                          */
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             ENDJRNPF   FILE(*ALL) JRN(*LIBL/JREC8D)
             MONMSG     MSGID(CPF7032)
             ENDDO                                                    /*CCB009*/
             DLTJRN     JRN(*LIBL/JREC8D)
 NOJRN:      CHGJOB     INQMSGRPY(*DFT)
             DLTJRNRCV  JRNRCV(*LIBL/JRREC8D)
             CHGJOB     INQMSGRPY(*RQD)
           ENDDO
/*/COPY WNCPYSRC,REC3860005                                          */
           ELSE CMD(DO)
             CPYF       FROMFILE(&DMLIB/ACCNTAB) +
                          TOFILE(&DMLIB/XACCNTAB) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817)
/**/
NOJRNRCV:  ENDDO
/*/COPY WNCPYSRC,REC3860006                                          */
/**/
/*      CREATE JOURNAL AND JOURNAL RECEIVER   */
/**/
             CHGVAR     VAR(&STAT) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
             CHGVAR     VAR(%SUBSTRING(&JLIB 1 2)) VALUE(&SYSID)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,REC3860MP1                                          */
                                                                      /*S01408*/
             CRTJRNRCV  JRNRCV(&JLIB/JRREC8D)
             CRTJRN     JRN(&JLIB/JREC8D) JRNRCV(&JLIB/JRREC8D)
/*/COPY WNCPYSRC,REC3860007                                          */
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             STRJRNPF   FILE(*LIBL/REHPOSPP) JRN(*LIBL/JREC8D) +
                          IMAGES(*BOTH)
/*/COPY WNCPYSRC,REC3860008                                          */
             MONMSG  (CPF2817)
             ENDDO                                                    /*CCB009*/
/**/
             OVRDBF     FILE(RACTRG) SEQONLY(*YES 100)
             OVRDBF     FILE(RACTRF) SEQONLY(*YES 200)
             OVRDBF     FILE(RTZZ) TOFILE(RTZZ) MBR(RACT) +
                          SEQONLY(*YES 200)
             CALL       PGM(*LIBL/RE3860)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
             DLTOVR     FILE(*ALL)
/**/
/**/
/*      SUCCESSFUL COMPLETION - DELETE JOURNAL AND RECEIVER  */
/**/
           IF        COND(%SWITCH(XXXXXX00)) THEN(DO)
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/**/
 RETRY:      ENDJRNPF   FILE(*ALL) JRN(*LIBL/JREC8D)
/************MONMSG     MSGID(CPF7031) EXEC(GOTO CMDLBL(RETRY))    */ /*081266*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*081266*/
             CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)                 /*081266*/
            IF         COND(&COUNT *LE 6) THEN(DO)                    /*081266*/
             DLYJOB     DLY(60)                                       /*081266*/
             GOTO       CMDLBL(RETRY)                                 /*081266*/
            ENDDO                                                     /*081266*/
            ELSE       CMD(DO)                                        /*081266*/
             GOTO       CMDLBL(ABNOR)                                 /*081266*/
            ENDDO                                                     /*081266*/
           ENDDO                                                      /*081266*/
             ENDDO                                                    /*CCB009*/
/**/
/*/COPY WNCPYSRC,REC3860009                                          */
             DLTF       FILE(&DMLIB/XACCNTAB)
             MONMSG     MSGID(CPF0000)
/*/COPY WNCPYSRC,REC3860010                                          */
             DLTJRN     JRN(*LIBL/JREC8D)
             CHGJOB     INQMSGRPY(*DFT)
             DLTJRNRCV  JRNRCV(*LIBL/JRREC8D)
             CHGJOB     INQMSGRPY(*RQD)
             CHGVAR     VAR(&STAT) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
             GOTO       CMDLBL(ENDPGM)
             ENDDO
/**/
             IF        COND(%SWITCH(XXXXXXX1)) THEN(DO)
/**/
               SNDPGMMSG  MSG('FILE OUT OF BALANCE - REC3860') +
                          TOMSGQ(*LIBL/MRUNQ *LIBL/MOPERQ)
/**************GOTO       CMDLBL(ENDPGM)                           */ /*081266*/
               GOTO       CMDLBL(ABNOR)                               /*081266*/
             ENDDO
/**/
             SNDPGMMSG  MSG('DATABASE ERROR - RE3860') +
                          TOMSGQ(*LIBL/MRUNQ *LIBL/MOPERQ)
/**/
/*     UNSUCCESSFUL COMPLETION - REMOVE JOURNALED CHANGES   */
/**/
/*/COPY WNCPYSRC,REC3860011                                          */
 ABNOR:      RMVJRNCHG  JRN(*LIBL/JREC8D) FILE((*LIBL/REHPOSPP))
/*/COPY WNCPYSRC,REC3860012                                          */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*081266*/
/************MONMSG      (CPF7049)                                 */ /*081266*/
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
             RMVJRNCHG  JRN(*LIBL/ICJRN) FILE((*LIBL/REHPOSPP)) +
                          FROMENT(&START) TOENT(&FINISH)              /*CCB009*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041) +
                                                                      /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             CHGJOB SWS(XXXXXX11)                                     /*058020*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             ENDJRNPF   FILE(*ALL) JRN(*LIBL/JREC8D)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*081266*/
             ENDDO                                                    /*CCB009*/
             DLTJRN     JRN(*LIBL/JREC8D)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*081266*/
             CHGJOB     INQMSGRPY(*DFT)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*081266*/
             DLTJRNRCV  JRNRCV(*LIBL/JRREC8D)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*081266*/
             CHGJOB     INQMSGRPY(*RQD)
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
                          Finastra International Limited')
             ENDPGM
