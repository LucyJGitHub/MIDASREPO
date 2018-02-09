/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas 'Accrual Summary'')                             */
/*********************************************************************/
/*                                                                   */
/*       Midas     Retail Module                                 */
/*                                                                   */
/*       REC3666A  -  GENERATE ENTRIES - SUMMARY.                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CRE083AC           Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CGL075             Date 16Jun06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      060266              DATE 03SEP92             */
/*                      S01413 *CREATE      DATE 13APR93             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CRE083AC - COB Restructure - RE COB Optimisation Phase 1    */
/*       CGL075 - Detailed Accrual Summary                           */
/*       060266 - Missing retail accrual summary                     */
/*       S01413 - Retail 3 Incorporation.                            */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM                                                      /*060266*/
             PGM        PARM(&MODE)                                   /*060266*/
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(3)                 /*060266*/
/*********** DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)             /*060266*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE('       ')  /*CGL075*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')  /*CGL075*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6) VALUE('CGL075')    /*CGL075*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)               /*CGL075*/
                                                                                        /*CRE083AC*/
/* Declare parameters to AOSVALR0     */                                                /*CRE083AC*/
                                                                                        /*CRE083AC*/
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7) VALUE('       +
                          ')                                                            /*CRE083AC*/
             DCL        VAR(&POP01) TYPE(*CHAR) LEN(20) +
                          VALUE('RetailAccrualSummary')                                 /*CRE083AC*/
             DCL        VAR(&POP02) TYPE(*CHAR) LEN(20)                                 /*CRE083AC*/
             DCL        VAR(&POP03) TYPE(*CHAR) LEN(20)                                 /*CRE083AC*/
             DCL        VAR(&POP04) TYPE(*CHAR) LEN(20)                                 /*CRE083AC*/
             DCL        VAR(&POP05) TYPE(*CHAR) LEN(20)                                 /*CRE083AC*/
             DCL        VAR(&POP06) TYPE(*CHAR) LEN(20)                                 /*CRE083AC*/
             DCL        VAR(&POP07) TYPE(*CHAR) LEN(20)                                 /*CRE083AC*/
             DCL        VAR(&POP08) TYPE(*CHAR) LEN(20)                                 /*CRE083AC*/
             DCL        VAR(&POP09) TYPE(*CHAR) LEN(20)                                 /*CRE083AC*/
             DCL        VAR(&POP10) TYPE(*CHAR) LEN(20)                                 /*CRE083AC*/
             DCL        VAR(&PVL01) TYPE(*CHAR) LEN(200)                                /*CRE083AC*/
             DCL        VAR(&PVL02) TYPE(*CHAR) LEN(200)                                /*CRE083AC*/
             DCL        VAR(&PVL03) TYPE(*CHAR) LEN(200)                                /*CRE083AC*/
             DCL        VAR(&PVL04) TYPE(*CHAR) LEN(200)                                /*CRE083AC*/
             DCL        VAR(&PVL05) TYPE(*CHAR) LEN(200)                                /*CRE083AC*/
             DCL        VAR(&PVL06) TYPE(*CHAR) LEN(200)                                /*CRE083AC*/
             DCL        VAR(&PVL07) TYPE(*CHAR) LEN(200)                                /*CRE083AC*/
             DCL        VAR(&PVL08) TYPE(*CHAR) LEN(200)                                /*CRE083AC*/
             DCL        VAR(&PVL09) TYPE(*CHAR) LEN(200)                                /*CRE083AC*/
             DCL        VAR(&PVL10) TYPE(*CHAR) LEN(200)                                /*CRE083AC*/
                                                                                        /*CRE083AC*/
/* Journalling variables */                                                             /*CRE083AC*/
             DCL        VAR(&CSEQA) TYPE(*CHAR) LEN(5)                                  /*CRE083AC*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                                  /*CRE083AC*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10) +
                           VALUE('REC3666A')                                            /*CRE083AC*/
             DCL        VAR(&STEXT) TYPE(*CHAR) LEN(25)                                 /*CRE083AC*/
             DCL        VAR(&SEVENT) TYPE(*CHAR) LEN(15)                                /*CRE083AC*/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)                                   /*CRE083AC*/
             DCL        VAR(&USR) TYPE(*CHAR) LEN(10)                                   /*CRE083AC*/
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)                                    /*CRE083AC*/
             DCL        VAR(&START) TYPE(*DEC) LEN(10 0)                                /*CRE083AC*/
             DCL        VAR(&FINISH) TYPE(*DEC) LEN(10 0)                               /*CRE083AC*/
             DCL        VAR(&SJRNRCVR) TYPE(*CHAR) LEN(10)                              /*CRE083AC*/
             DCL        VAR(&FJRNRCVR) TYPE(*CHAR) LEN(10)                              /*CRE083AC*/
                                                                                        /*CRE083AC*/
             DCLF       FILE(TABTBRE)                                                   /*CRE083AC*/
             RCVF       RCDFMT(TABTBREF)                                                /*CRE083AC*/
/* Global monitor message */                                                            /*CRE083AC*/
                                                                                        /*CRE083AC*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                                                /*CRE083AC*/
             CHGJOB SWS(00000000)                                                       /*CRE083AC*/
                                                                                        /*CRE083AC*/
/* Start Journalling */                                                                 /*CRE083AC*/
             IF         COND(&MODE *EQ 'ONE') +
                  THEN(CHGVAR VAR(&CSEQ) VALUE(00001))                                  /*CRE083AC*/
             IF         COND(&MODE *EQ 'TWO') +
                  THEN(CHGVAR VAR(&CSEQ) VALUE(00002))                                  /*CRE083AC*/
                                                                                        /*CRE083AC*/
             CHGVAR     VAR(&CSEQA) VALUE(&CSEQ)                                        /*CRE083AC*/
             CHGVAR     VAR(&STEXT) VALUE('Start of ' *CAT &CNAM +
                           *CAT &CSEQA)                                                 /*CRE083AC*/
             CHGVAR     VAR(&SEVENT) VALUE(&CNAM *TCAT &CSEQA)                          /*CRE083AC*/
             SCWRTJREG  EVENT(&SEVENT) COMP(&CNAM) CMPSEQ(&CSEQ) +
                           FLAG('S') TEXT(&STEXT)                                       /*CRE083AC*/
                                                                                        /*CRE083AC*/
/* Check if the current setting of RetailAccrualSummary is 'Y'    */                    /*CRE083AC*/
                                                                                        /*CRE083AC*/
             CALL       PGM(AOSVALR0) PARM(&PRTCD &POP01 &PVL01 +
                          &POP02 &PVL02 &POP03 &PVL03 &POP04 &PVL04 +
                          &POP05 &PVL05 &POP06 &PVL06 &POP07 &PVL07 +
                          &POP08 &PVL08 &POP09 &PVL09 &POP10 &PVL10)                    /*CRE083AC*/
                                                                                        /*CRE083AC*/
/* Check if this component must run. */                                                 /*CRE083AC*/
             IF         COND((&ACSM *EQ 'Y') *OR ((&PRTCD *EQ +
                          '       ') *AND (&PVL01 *EQ 'Y'))) +
                          THEN(DO)                                                      /*CRE083AC*/
                                                                                        /*CRE083AC*/
/*/COPY WNCPYSRC,REC3666A01                                          */
/**/
/************** RTVDTAARA DTAARA(SDSTAT *ALL) RTNVAR(&SDSTAT)         /*060266*/
/*********** IF         COND(%SST(&SDSTAT 110 5) = 'ANWD2') THEN(DO)  /*060266*/
             IF         COND(&MODE *EQ 'TWO') THEN(DO)                /*060266*/
                   OVRDBF     FILE(GEIERPD) TOFILE(GEIER2PD)
                   OVRDBF     FILE(GEIERZZ) TOFILE(GEIER2ZZ)
                   OVRDBF     FILE(GEIERPD0) TOFILE(GEIER2PD0) SHARE(*YES)
             ENDDO
             ELSE       CMD(DO)
                   OVRDBF     FILE(GEIERPD0) SHARE(*YES)
             ENDDO
             OPNQRYF    FILE((GEIERPD0 *FIRST)) FORMAT(*FILE) +
                          KEYFLD((BRCA) (CCY) (ACOD) (DRCR))
             CALL       PGM(RE3666A)
 
             CLOF       OPNID(GEIERPD0)
             DLTOVR     FILE(GEIERPD0)
/*/COPY WNCPYSRC,REC3666A02                                          */
/**/
 
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CGL075*/
             IF         COND(&RTCD *NE '       ') THEN(DO)            /*CGL075*/
 
             CLRPFM     FILE(GEIERPD0)
             CLRPFM     FILE(GEIER2PD0)
 
             ENDDO                                                    /*CGL075*/
                                                                                        /*CRE083AC*/
/* Close DO of check if this component must run.*/                                      /*CRE083AC*/
             ENDDO                                                                      /*CRE083AC*/
 
             GOTO       CMDLBL(END)                                                     /*CRE083AC*/
                                                                                        /*CRE083AC*/
 ABNOR:                                                                                 /*CRE083AC*/
             CHGJOB     SWS(XXXXXX11)                                                   /*CRE083AC*/
                                                                                        /*CRE083AC*/
/* Retrieve attributes of current job */                                                /*CRE083AC*/
                                                                                        /*CRE083AC*/
             RTVJOBA    JOB(&JOB) USER(&USR) NBR(&NBR)                                  /*CRE083AC*/
                                                                                        /*CRE083AC*/
/* Retrieve the most recent journal entry sequence number for the */                    /*CRE083AC*/
/* specific job. */                                                                     /*CRE083AC*/
                                                                                        /*CRE083AC*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                           TOENT(*FIRST) SEARCH(*DESCEND) +
                           JOB(&NBR/&USR/&JOB) RTNSEQNBR(&START) +
                           RTNRCV(&SJRNRCVR)                                            /*CRE083AC*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)                                 /*CRE083AC*/
                  CHGVAR     VAR(&START) VALUE(0)                                       /*CRE083AC*/
             ENDDO                                                                      /*CRE083AC*/
                                                                                        /*CRE083AC*/
/* Determine starting journal sequence number of current job. */                        /*CRE083AC*/
                                                                                        /*CRE083AC*/
             SCRTVJEVT  EVENT(&SEVENT) FLAG('S') RECEIVER(&FJRNRCVR) +
                           SEQ(&FINISH)                                                 /*CRE083AC*/
                                                                                        /*CRE083AC*/
/* Remove journal changes. */                                                           /*CRE083AC*/
                                                                                        /*CRE083AC*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                           THEN(DO)                                                     /*CRE083AC*/
                  IF         COND(&MODE *EQ 'TWO') THEN(DO)
                       RMVJRNCHG  JRN(ICJRN) FILE((GEIERPD) +
                                    (GEIER2PD) (GEIERZZ) (GEIER2ZZ) +
                                    (GEIERPD0) (GEIER2PD0)) +
                                    FROMENT(&START) TOENT(&FINISH) +
                                    RCVRNG(&SJRNRCVR &FJRNRCVR)                         /*CRE083AC*/
                       MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041)                /*CRE083AC*/
                  ENDDO                                                                 /*CRE083AC*/
                  ELSE       CMD(DO)                                                    /*CRE083AC*/
                       RMVJRNCHG  JRN(ICJRN) FILE((GEIERPD0) +
                                    (GEIERPD) (GEIERZZ)) +
                                    FROMENT(&START) TOENT(&FINISH) +
                                    RCVRNG(&SJRNRCVR &FJRNRCVR)                         /*CRE083AC*/
                       MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041)                /*CRE083AC*/
                  ENDDO                                                                 /*CRE083AC*/
             ENDDO                                                                      /*CRE083AC*/
                                                                                        /*CRE083AC*/
/* Abnormal termination */                                                              /*CRE083AC*/
                                                                                        /*CRE083AC*/
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            REC3666A ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)                                        /*CRE083AC*/
               MONMSG     MSGID(CPF0000 MCH0000)                                        /*CRE083AC*/
/**/
END:                                                                                    /*CRE083AC*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
                                                                                        /*CRE083AC*/
/* Write current journal sequence number to file SCJSEQPD */                            /*CRE083AC*/
                                                                                        /*CRE083AC*/
             CHGVAR     VAR(&STEXT) VALUE(' ')                                          /*CRE083AC*/
             CHGVAR     VAR(&STEXT) VALUE('End of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                  /*CRE083AC*/
             SCWRTJREG  EVENT(&SEVENT) COMP(&CNAM) CMPSEQ(&CSEQ) +
                           FLAG('E') TEXT(&STEXT)                                       /*CRE083AC*/
                                                                                        /*CRE083AC*/
             ENDPGM
/**/
