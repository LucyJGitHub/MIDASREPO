/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas MX Update Export Retail Accruals')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Meridian Export Module                              */
/*                                                                   */
/*       MXC0491 - Update Export Retail Accruals                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. MD035212           Date 25May16              */
/*       Prev Amend No. AR1059293          Date 21Nov12              */
/*                      CRE083AC           Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CMX001  *CREATE    Data 01Jan00              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD035212 - Retail ICD TABTBRE is empty. MXC0491 component   */
/*                  failed.                                          */
/*       AR1059293 - Geneva Drop 01 Build Issues - Cannot compile    */
/*                   using RUNQSQL command.                          */
/*       CRE083AC - COB Restructure - RE COB Optimisation Phase 1    */
/*       CMX001 - Meridian Export                                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PGM &MODE &ACSM)

/*/COPY WNCPYSRC,MXC0491INT                                          */

             DCL        VAR(&PGM )  TYPE(*CHAR) LEN(10)
             DCL        VAR(&MODE)  TYPE(*CHAR) LEN( 3)
             DCL        VAR(&ACSM)  TYPE(*CHAR) LEN( 1)
             DCL        VAR(&MNTRAC) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
                                                                                        /*CRE083AC*/
/* Journalling variables */                                                             /*CRE083AC*/
             DCL        VAR(&CSEQA) TYPE(*CHAR) LEN(5)                                  /*CRE083AC*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)  VALUE(00001)                    /*CRE083AC*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10) +
                           VALUE('MXC0491')                                             /*CRE083AC*/
             DCL        VAR(&STEXT) TYPE(*CHAR) LEN(25)                                 /*CRE083AC*/
             DCL        VAR(&SEVENT) TYPE(*CHAR) LEN(15)                                /*CRE083AC*/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)                                   /*CRE083AC*/
             DCL        VAR(&USR) TYPE(*CHAR) LEN(10)                                   /*CRE083AC*/
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)                                    /*CRE083AC*/
             DCL        VAR(&START) TYPE(*DEC) LEN(10 0)                                /*CRE083AC*/
             DCL        VAR(&FINISH) TYPE(*DEC) LEN(10 0)                               /*CRE083AC*/
             DCL        VAR(&SJRNRCVR) TYPE(*CHAR) LEN(10)                              /*CRE083AC*/
             DCL        VAR(&FJRNRCVR) TYPE(*CHAR) LEN(10)                              /*CRE083AC*/
             DCL        VAR(&RETMOD) TYPE(*CHAR) LEN(1)                                 /*MD035212*/

             DCLF       FILE(TABTBRE)                                                   /*CRE083AC*/
/**********  RCVF       RCDFMT(TABTBREF)                                       /*CRE083AC MD035212*/
/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/* Check if Retail module is switched ON */                                             /*MD035212*/
             RTVDTAARA  DTAARA(MMOD (3 1)) RTNVAR(&RETMOD)                              /*MD035212*/
             IF         COND(&RETMOD *EQ 'Y') THEN(DO)                                  /*MD035212*/
             RCVF       RCDFMT(TABTBREF)                                                /*MD035212*/
             ENDDO                                                                      /*MD035212*/
                                                                                        /*MD035212*/
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB SWS(00000000)

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

/*/COPY WNCPYSRC,MXC0491MPS                                          */


/* END IF MAINTAIN RETAIL ACCRUALS IS NO */

             RTVDTAARA  DTAARA(MXEXPCTL (37 1)) RTNVAR(&MNTRAC)
             IF         COND(&MNTRAC *EQ 'N') THEN(GOTO CMDLBL(END))


/* INCOME & EXPENSE entries */

             IF         COND(&PGM *EQ 'REC3666') THEN(DO)

/* ANWD */

             IF         COND(&MODE *EQ 'TWO') THEN(DO)

/* ANWD */
/* NOT Accrual summary */

/** Override member for SQL to simulate CPYF functionality */                           /*CRE083AC*/
             CLRPFM     FILE(MXACREPD) MBR(POST5IE)                                     /*CRE083AC*/
             OVRDBF     FILE(MXACREPD) MBR(POST5IE)                                     /*CRE083AC*/
                                                                                        /*CRE083AC*/
             IF         COND(&ACSM *NE 'Y') THEN(DO)

/**********  CPYF       FROMFILE(GEIER2PD) TOFILE(MXACREPD) +
/**********               TOMBR(POST5IE) MBROPT(*REPLACE) +
/**********               INCREL((*IF ACSC *EQ IN) (*OR ACSC *EQ EX)) */                /*CRE083AC*/
/**********    MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
/**********               FILE(MXACREPD) MBR(POST5IE)) */                               /*CRE083AC*/

/**********  RUNSQL     SQL('INSERT INTO MXACREPD SELECT * FROM +
                          GEIER2PD WHERE ACSC=''IN'' OR +
                          ACSC=''EX''') COMMIT(*NONE) */                      /*CRE083AC AR1059293*/
             SCRUNSQL   SQL('INSERT INTO MXACREPD SELECT * FROM +
                           GEIER2PD WHERE ACSC=''IN'' OR ACSC=''EX''')                 /*AR1059293*/
               MONMSG     MSGID(SQL0000) EXEC(CLRPFM FILE(MXACREPD) +
                          MBR(POST5IE))                                                 /*CRE083AC*/
             ENDDO

/* ANWD */
/* Accrual summary */

             IF         COND(&ACSM *EQ 'Y') THEN(DO)

/**********  CPYF       FROMFILE(GEIER2PD0) TOFILE(MXACREPD) +
/**********               TOMBR(POST5IE) MBROPT(*REPLACE) +
/**********               INCREL((*IF ACSC *EQ IN) (*OR ACSC *EQ EX)) */                /*CRE083AC*/
/**********    MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
/**********               FILE(MXACREPD) MBR(POST5IE)) */                               /*CRE083AC*/

/**********  RUNSQL     SQL('INSERT INTO MXACREPD SELECT * FROM +
                          GEIER2PD0 WHERE ACSC=''IN'' OR +
                          ACSC=''EX''') COMMIT(*NONE) */                      /*CRE083AC AR1059293*/
             SCRUNSQL   SQL('INSERT INTO MXACREPD SELECT * FROM +
                           GEIER2PD0 WHERE ACSC=''IN'' OR ACSC=''EX''')                /*AR1059293*/
               MONMSG     MSGID(SQL0000) EXEC(CLRPFM FILE(MXACREPD) +
                          MBR(POST5IE))                                                 /*CRE083AC*/
             ENDDO
             ENDDO

/* NOT ANWD */

             IF         COND(&MODE *NE 'TWO') THEN(DO)

/* NOT ANWD */
/* NOT Accrual summary */

/** Override member for SQL to simulate CPYF functionality */                           /*CRE083AC*/
             CLRPFM     FILE(MXACREPD) MBR(POST1IE)                                     /*CRE083AC*/
             OVRDBF     FILE(MXACREPD) MBR(POST1IE)                                     /*CRE083AC*/
                                                                                        /*CRE083AC*/
             IF         COND(&ACSM *NE 'Y') THEN(DO)

/**********  CPYF       FROMFILE(GEIERPD) TOFILE(MXACREPD) +
/**********               TOMBR(POST1IE) MBROPT(*REPLACE) +
/**********               INCREL((*IF ACSC *EQ IN) (*OR ACSC *EQ EX)) */                /*CRE083AC*/
/**********    MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
/**********               FILE(MXACREPD) MBR(POST1IE)) */                               /*CRE083AC*/

/**********  RUNSQL     SQL('INSERT INTO MXACREPD SELECT * FROM +
                          GEIERPD WHERE ACSC=''IN'' OR +
                          ACSC=''EX''') COMMIT(*NONE) */                      /*CRE083AC AR1059293*/
             SCRUNSQL   SQL('INSERT INTO MXACREPD SELECT * FROM +
                           GEIERPD WHERE ACSC=''IN'' OR ACSC=''EX''')                  /*AR1059293*/
               MONMSG     MSGID(SQL0000) EXEC(CLRPFM FILE(MXACREPD) +
                          MBR(POST1IE))                                                 /*CRE083AC*/
             ENDDO

/* NOT ANWD */
/* Accrual summary */

             IF         COND(&ACSM *EQ 'Y') THEN(DO)

/**********  CPYF       FROMFILE(GEIERPD0) TOFILE(MXACREPD) +
/**********               TOMBR(POST1IE) MBROPT(*REPLACE) +
/**********               INCREL((*IF ACSC *EQ IN) (*OR ACSC *EQ EX)) */                /*CRE083AC*/
/**********    MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
/**********               FILE(MXACREPD) MBR(POST1IE)) */                               /*CRE083AC*/

/**********  RUNSQL     SQL('INSERT INTO MXACREPD SELECT * FROM +
                          GEIERPD0 WHERE ACSC=''IN'' OR +
                          ACSC=''EX''') COMMIT(*NONE) */                      /*CRE083AC AR1059293*/
             SCRUNSQL   SQL('INSERT INTO MXACREPD SELECT * FROM +
                           GEIERPD0 WHERE ACSC=''IN'' OR ACSC=''EX''')                 /*AR1059293*/
               MONMSG     MSGID(SQL0000) EXEC(CLRPFM FILE(MXACREPD) +
                          MBR(POST1IE))                                                 /*CRE083AC*/
             ENDDO
             ENDDO
             ENDDO


/* INTEREST CAPITALIZATION entries */

             IF         COND(&PGM *NE 'REC3666')  THEN(DO)


/**********  CPYF       FROMFILE(GEICPD) TOFILE(MXACREPD) +
/**********               TOMBR(POST1IC) MBROPT(*REPLACE) +
/**********               INCREL((*IF ACSC *EQ IN) (*AND OTST *NE +
/**********               '    ') (*OR ACSC *EQ EX) (*AND OTST *NE +
/**********               '    ')) */                                                   /*CRE083AC*/
/**********    MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
/**********               FILE(MXACREPD) MBR(POST1IC)) */                               /*CRE083AC*/

             CLRPFM     FILE(MXACREPD) MBR(POST1IC)                                     /*CRE083AC*/
             OVRDBF     FILE(MXACREPD) MBR(POST1IC)                                     /*CRE083AC*/
/**********  RUNSQL     SQL('INSERT INTO MXACREPD SELECT * FROM +
                          GEICPD WHERE (ACSC=''IN'' OR ACSC=''EX'') +
                          AND OTST <> ''    ''') COMMIT(*NONE) */             /*CRE083AC AR1059293*/
             SCRUNSQL   SQL('INSERT INTO MXACREPD SELECT * FROM +
                           GEICPD WHERE (ACSC=''IN'' OR ACSC=''EX'') +
                           AND OTST <> ''    ''')                                      /*AR1059293*/
               MONMSG     MSGID(SQL0000) EXEC(CLRPFM FILE(MXACREPD) +
                          MBR(POST1IC))                                                 /*CRE083AC*/
                                                                                        /*CRE083AC*/
/**********  CPYF       FROMFILE(GEIC2PD) TOFILE(MXACREPD) +
/**********               TOMBR(POST5IC) MBROPT(*REPLACE) +
/**********               INCREL((*IF ACSC *EQ IN) (*AND OTST *NE +
/**********               '    ') (*OR ACSC *EQ EX) (*AND OTST *NE +
/**********               '    ')) */
/**********    MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
/**********               FILE(MXACREPD) MBR(POST5IC)) */

             CLRPFM     FILE(MXACREPD) MBR(POST5IC)                                     /*CRE083AC*/
             OVRDBF     FILE(MXACREPD) MBR(POST5IC)                                     /*CRE083AC*/
/**********  RUNSQL     SQL('INSERT INTO MXACREPD SELECT * FROM +
                          GEIC2PD WHERE (ACSC=''IN'' OR +
                          ACSC=''EX'') AND OTST <> ''    ''') +
                          COMMIT(*NONE) */                                    /*CRE083AC AR1059293*/
             SCRUNSQL   SQL('INSERT INTO MXACREPD SELECT * FROM +
                           GEIC2PD WHERE (ACSC=''IN'' OR ACSC=''EX'') +
                           AND OTST <> ''    ''')                                      /*AR1059293*/
               MONMSG     MSGID(SQL0000) EXEC(CLRPFM FILE(MXACREPD) +
                          MBR(POST1IC))                                                 /*CRE083AC*/
             ENDDO


/*/COPY WNCPYSRC,MXC0491MPE                                          */

             GOTO       CMDLBL(END)

 ABNOR:
/*/COPY WNCPYSRC,MXC0491ERR                                          */

             CHGJOB     SWS(XXXXXX11)

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
                  RMVJRNCHG  JRN(ICJRN) FILE((MXACREPD)) +
                                FROMENT(&START) TOENT(&FINISH) +
                                RCVRNG(&SJRNRCVR &FJRNRCVR)                             /*CRE083AC*/
                  MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041)                     /*CRE083AC*/
             ENDDO                                                                      /*CRE083AC*/
                                                                                        /*CRE083AC*/
/* Abnormal termination */

               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0491 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)


END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')

/*/COPY WNCPYSRC,MXC0491END                                          */

             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)

/* Write current journal sequence number to file SCJSEQPD */                            /*CRE083AC*/
                                                                                        /*CRE083AC*/
             CHGVAR     VAR(&STEXT) VALUE(' ')                                          /*CRE083AC*/
             CHGVAR     VAR(&STEXT) VALUE('End of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                  /*CRE083AC*/
             SCWRTJREG  EVENT(&SEVENT) COMP(&CNAM) CMPSEQ(&CSEQ) +
                           FLAG('E') TEXT(&STEXT)                                       /*CRE083AC*/
                                                                                        /*CRE083AC*/
             ENDPGM
