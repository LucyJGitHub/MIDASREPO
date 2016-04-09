/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas EU EMU base currency conversion - part II')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - EMU Module                                          */
/*                                                                   */
/*       CL/EUC0050 - Midas EMU Base Currency Conversion-Part II     */
/*                                                                   */
/*       Function:  This new COB component will update the Base      */
/*       (I/C INT)  currency with the new base currency and the spot */
/*                  rates with the Euro rates.                       */
/*                                                                   */
/*       Calls :   EU0050 - Update BCCY / Spot Rates with Euro       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC020             Date 31Mar04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       Prev Amend No. CCB009             DATE 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                       CEU001 *CREATE    DATE 08Sep97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*       CCB009 - Journal files throughout close of business         */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       CEU001 - EMU Base Currency For Accounting Conversion        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
/*/COPY WNCPYSRC,EUC0050INT                                          */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&CNAM)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ)   TYPE(*DEC)  LEN(5)
             DCL        VAR(&STAT)   TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&JLIB)   TYPE(*CHAR) LEN(6) VALUE('  JLIB')
             DCL        VAR(&MEM)    TYPE(*CHAR) LEN(50)
             DCL        VAR(&SYSID)  TYPE(*CHAR) LEN(2)
/*/COPY WNCPYSRC,EUC0050001                                          */
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
             SNDPGMMSG  MSG('EUC0050 - EMU Base Currency +
                          Conversion Part II') TOMSGQ(MRUNQ)
/*/COPY WNCPYSRC,EUC0050002                                          */
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
 
/*/COPY WNCPYSRC,EUC0050MPS                                          */
 
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
             RMVJRNCHG  JRN(ICJRN) FILE((SDBANKPD) (SDCURRPD) +
                          (TABTB11) (TABTG10)) FROMENT(&START) +
                          TOENT(&FINISH)                              /*CCB009*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041) +
/*/COPY WNCPYSRC,EUC0050003                                          */
                                                                      /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ELSE       CMD(DO)                                       /*CCB009*/
               CHKOBJ     OBJ(JREUC0050) OBJTYPE(*JRNRCV)
               MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(NOJRNRCV))
               CHKOBJ     OBJ(JEUC0050) OBJTYPE(*JRN)
               MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(NOJRN))
               RMVJRNCHG  JRN(JEUC0050) FILE((SDBANKPD) (SDCURRPD) +
                          (TABTB11) (TABTG10))
               MONMSG     MSGID(CPF7042 CPF7049)
/*/COPY WNCPYSRC,EUC0050004                                          */
             ENDDO                                                    /*CCB009*/
               ENDCMTCTL
               MONMSG     MSGID(CPF0000)
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
               ENDJRNPF   (*ALL) JRN(JEUC0050)
               MONMSG     MSGID(CPF7032)
               DLTJRN     JRN(JEUC0050)
NOJRN:         CHGJOB     INQMSGRPY(*DFT)
               DLTJRNRCV  JRNRCV(JREUC0050)
               CHGJOB     INQMSGRPY(*RQD)
             ENDDO                                                    /*CCB009*/
NOJRNRCV:    ENDDO
/**/
/** Start of normal first run processing */
/**/
             CHGVAR     VAR(&STAT) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/**/
/** Create journal and journal receiver */
/**/
             CHGVAR     VAR(%SUBSTRING(&JLIB 1 2)) VALUE(&SYSID)
             CRTJRNRCV  JRNRCV(&JLIB/JREUC0050)
             CRTJRN     JRN(&JLIB/JEUC0050) JRNRCV(&JLIB/JREUC0050)
             STRJRNPF   FILE(SDBANKPD SDCURRPD TABTB11 TABTG10) +
               JRN(JEUC0050) IMAGES(*BOTH)
/*/COPY WNCPYSRC,EUC0050005                                          */
             ENDDO                                                    /*CCB009*/
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))            /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
/**/
/** Update Base Currency with New Base Currency and Spot Rates with */
/** Euro Rates                                                      */
/**/
             OVRDBF     FILE(SDCURRL1) MBR(*FIRST) LVLCHK(*NO) +
                          SHARE(*NO)
             CALL       PGM(EU0050)
             DLTOVR     FILE(SDCURRL1)
/**/
/** Database error processing */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO
             CLRPFM     EUBCACPD
             CLRPFM     EUBCATPD
             ENDCMTCTL
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             ENDJRNPF   FILE(*ALL) JRN(JEUC0050)
             MONMSG     MSGID(CPF0000)
             DLTJRN     JRN(JEUC0050)
             MONMSG     MSGID(CPF0000)
             CHGJOB     INQMSGRPY(*DFT)
             DLTJRNRCV  JRNRCV(JREUC0050)
             CHGJOB     INQMSGRPY(*RQD)
             ENDDO                                                    /*CCB009*/
 
/*/COPY WNCPYSRC,EUC0050MPE                                          */
 
             GOTO       CMDLBL(END)
 ABNOR:
/*/COPY WNCPYSRC,EUC0050ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
               TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSG('EUC0050 ENDED ABNORMALLY') +
               TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,EUC0050END                                          */
 
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
