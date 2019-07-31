/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas EU EMU base currency conversion - part I')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - EMU Module                                          */
/*                                                                   */
/*       CL/EUC0020 - Midas EMU Base Currency Conversion - Part I    */
/*                                                                   */
/*       Function:  This new COB component will do the following     */
/*       (I/C INT)  processings.                                     */
/*                      1.  Conversion of Transaction Base Currency  */
/*                  for Accounting Equivalents                       */
/*                      2.  Base Currency for Accounting Equivalents */
/*                  Conversion Report                                */
/*                      3.  Base Currency Equivalent Account Balance */
/*                  Transfer Entry Generation                        */
/*                                                                   */
/*       Calls :   EU0020 - BCA Equivalents Conversion Program       */
/*                 EU0030 - BCAE Conversion Report                   */
/*                 EU0040 - BCE Account Balance Transfer             */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CLE134             Date 01Aug12              */
/*                      AR999702           Date 05Jul12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSC020             Date 31Mar04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             DATE 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                    .  CGL008            Date 03Mar99              */
/*                       CEU001 *CREATE    Date 08Sep97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       AR999702 - Insert of corrective batch in Live with batch    */
/*                  number in PEA displays an error                  */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*       CCB009 - Journal files throughout close of business         */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       CGL008 - Security on Journal Entry. Recompile.              */
/*       CEU001 - EMU Base Currency For Accounting Conversion        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
/*/COPY WNCPYSRC,EUC0020INT                                          */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&CNAM)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ)   TYPE(*DEC)  LEN(5)
             DCL        VAR(&STAT)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&JLIB)   TYPE(*CHAR) LEN(6) VALUE('  JLIB')
             DCL        VAR(&RTCD)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&DSFY)   TYPE(*CHAR) LEN(200)
             DCL        VAR(&PGRP)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&PDNY)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&PCOD)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&CENT)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&YEAR)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&EXPR)   TYPE(*CHAR) LEN(55)  +
               VALUE('HBPDNY = ''  '' *AND HBPDCT = ''  '' +
                      *AND HBPDYR = ''  ''')
             DCL        VAR(&MEM)    TYPE(*CHAR) LEN(50)
             DCL        VAR(&SYSID)  TYPE(*CHAR) LEN(2)
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
/** Global monitor message */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/*                                                                                        /*CSC020*/
/* Write current journal sequence number to file SCJSEQPD, using command SCWRTJREG.       /*CSC020*/
/*                                                                                        /*CSC020*/
             CHGVAR     VAR(&CSEQA) VALUE(&CSEQ)                                          /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE('Start of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                    /*CSC020*/
             SCWRTJREG  COMP(&CNAM) CMPSEQ(&CSEQ) FLAG('S') +
                          TEXT(&STEXT)                                                    /*CSC020*/
             SNDPGMMSG  MSG('EUC0020 - EMU Base Currency +
                          Conversion Part I') TOMSGQ(MRUNQ)
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
             RTVDTAARA  DTAARA(*LIBL/SDSTAT (6 2)) RTNVAR(&SYSID)
/**/
/** Check LDA if existing */
/**/
             CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                          CRTDTAARA  DTAARA(QTEMP/LDA)  +
                          TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('MIDAS SD AS400 LOCAL +
                          DATA AREA EQUIVALENT')
             ENDDO
/**/
/** Initialize job switches */
/**/
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,EUC0020MPS                                          */
 
/**/
/** Check for component restart */
/**/
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
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
             RMVJRNCHG  JRN(ICJRN) FILE((ABDEALPP) (FXDEALPP) +
                          (MMDELDPP) (MMDENBPP) (MMDENSPP) +
                          (DEALSDA) (DEALSDB) (DEALSDC) (DEALSDD) +
                          (DEALSDE) (DEALSDF) (DEALSDG) (CLOANCL) +
                          (CLOANHH) (CLOANCK) (CLOANZ1) (OTPAYDD) +
                          (INPAYDD) (NTRANDD) (CQCODDD) (CQCOCDD) +
                          (CQPACDD) (CQPADDD) (TRADSD) (POSETD) +
                          (EUBCATPD) (GLJENHPD) (GLJENPPD) +
                          (GLJENSPD)) FROMENT(&START) +
                          TOENT(&FINISH)                              /*CCB009*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041)        /*CCB009*/
                                                                      /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ELSE       CMD(DO)                                       /*CCB009*/
               CHKOBJ     OBJ(JREUC0020) OBJTYPE(*JRNRCV)
               MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(NOJRNRCV))
               CHKOBJ     OBJ(JEUC0020) OBJTYPE(*JRN)
               MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(NOJRN))
               RMVJRNCHG  JRN(JEUC0020)  FILE((ABDEALPP) (FXDEALPP) +
                 (MMDELDPP) (MMDENBPP) (MMDENSPP) (DEALSDA) (DEALSDB) +
                 (DEALSDC) (DEALSDD) (DEALSDE) (DEALSDF) (DEALSDG) +
                 (CLOANCL) (CLOANHH) (CLOANCK) (CLOANZ1) (OTPAYDD) +
                 (INPAYDD) (NTRANDD) (CQCODDD) (CQCOCDD) (CQPACDD) +
                 (CQPADDD) (TRADSD) (POSETD) (EUBCATPD) (GLJENHPD) +
                 (GLJENPPD) (GLJENSPD))
               MONMSG     MSGID(CPF7042 CPF7049)
             ENDDO                                                    /*CCB009*/
               ENDCMTCTL
               MONMSG     MSGID(CPF0000)
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
               ENDJRNPF   (*ALL) JRN(JEUC0020)
               MONMSG     MSGID(CPF7032)
             ENDDO                                                    /*CCB009*/
               DLTJRN     JRN(JEUC0020)
NOJRN:         CHGJOB     INQMSGRPY(*DFT)
               DLTJRNRCV  JRNRCV(JREUC0020)
               CHGJOB     INQMSGRPY(*RQD)
NOJRNRCV:      ENDDO
/**/
/** Start of normal first run processing */
/**/
             CHGVAR     VAR(&STAT) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
/**/
/** Create journal and journal receiver */
/**/
             CLRPFM     FILE(EUBCATPD)
             CLRPFM     FILE(GLJENHPD)
             CLRPFM     FILE(GLJENSPD)
             CLRPFM     FILE(GLJENPPD)
             CLRPFM     FILE(GLJENHQD)                                                  /*AR999702*/
             CLRPFM     FILE(GLJENPQD)                                                  /*AR999702*/
             CHGVAR     VAR(%SUBSTRING(&JLIB 1 2)) VALUE(&SYSID)
             CRTJRNRCV  JRNRCV(&JLIB/JREUC0020)
             CRTJRN     JRN(&JLIB/JEUC0020) JRNRCV(&JLIB/JREUC0020)
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             STRJRNPF   FILE(ABDEALPP FXDEALPP MMDELDPP MMDENBPP +
               MMDENSPP DEALSDA DEALSDB DEALSDC DEALSDD DEALSDE +
               DEALSDF DEALSDG CLOANCL CLOANHH CLOANCK CLOANZ1 +
               OTPAYDD INPAYDD NTRANDD CQCODDD CQCOCDD +
               CQPACDD CQPADDD TRADSD POSETD EUBCATPD GLJENHPD +
               GLJENPPD GLJENSPD) JRN(JEUC0020) IMAGES(*BOTH)
             ENDDO                                                    /*CCB009*/
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))            /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
             CALL       PGM(AOMMODR0) PARM(&RTCD '*FIRST' &DSFY)
             IF         COND(%SST(&DSFY 100 1) = 'Y') THEN(DO)
                CHGVAR     VAR(&DSFY) VALUE(*BLANKS)
                CALL       PGM(AOPCACR0) PARM(&RTCD '*FIRST' &DSFY)
                CHGVAR     VAR(&PGRP) VALUE(%SST(&DSFY 15 2))
                CHGVAR     VAR(&DSFY) VALUE(*BLANKS)
                CALL       PGM(AOHBCGR0) PARM(&RTCD '*KEY' &PGRP &DSFY)
                CHGVAR     VAR(&PCOD) VALUE(%SST(&DSFY 33 1))
                CHGVAR     VAR(&DSFY) VALUE(*BLANKS)
                CALL       PGM(AORPERR0) PARM(&RTCD '*KEY' &PCOD +
                  0 &DSFY)
                CHGVAR     VAR(&CENT) VALUE(%SST(&DSFY 2 2))
                CHGVAR     VAR(&YEAR) VALUE(%SST(&DSFY 4 2))
                CHGVAR     VAR(&PDNY) VALUE(%SST(&DSFY 6 2))
                CHGVAR     VAR(%SST(&EXPR 11 2)) VALUE(&PDNY)
                CHGVAR     VAR(%SST(&EXPR 30 2)) VALUE(&CENT)
                CHGVAR     VAR(%SST(&EXPR 49 2)) VALUE(&YEAR)
                OVRDBF     FILE(GLHIBLL0) TOFILE(GLHIBLL0) MBR(&PGRP) +
                           SHARE(*YES)
                OPNQRYF    FILE((GLHIBLL0 &PGRP)) OPTION(*INP) +
                  QRYSLT(&EXPR) KEYFLD(*FILE)
             ENDDO
             CALL       PGM(EU0020)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO
             CALL       PGM(EU0030)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO
             CALL       PGM(EU0040)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO
/*/COPY WNCPYSRC,EUC0020001                                          */
             ENDCMTCTL
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             ENDJRNPF   FILE(*ALL) JRN(JEUC0020)
             ENDDO                                                    /*CCB009*/
             DLTJRN     JRN(JEUC0020)
             CHGJOB     INQMSGRPY(*DFT)
             DLTJRNRCV  JRNRCV(JREUC0020)
             CHGJOB     INQMSGRPY(*RQD)
 
/*/COPY WNCPYSRC,EUC0020MPE                                          */
 
             GOTO       CMDLBL(END)
/**/
/** Database error processing */
/**/
 ABNOR:
/*/COPY WNCPYSRC,EUC0020ERR                                          */
 
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
               TOMSGQ(MOPERQ MRUNQ)
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('EUC0020 ENDED ABNORMALLY') +
               TOMSGQ(MOPERQ MRUNQ)
 
 END:        DLTOVR     FILE(GLHIBLPD)
             MONMSG     MSGID(CPF0000)
             CLOF       OPNID(GLHIBLPD)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,EUC0020END                                          */
 
/*                                                                                        /*CSC020*/
/* Write current journal sequence number to file SCJSEQPD, using command SCWRTJREG.       /*CSC020*/
/*                                                                                        /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE(' ')                                            /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE('End of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                    /*CSC020*/
             SCWRTJREG  COMP(&CNAM) CMPSEQ(&CSEQ) FLAG('E') +
                          TEXT(&STEXT)                                                    /*CSC020*/
             RETURN                                                                       /*CSC020*/
             ENDPGM
