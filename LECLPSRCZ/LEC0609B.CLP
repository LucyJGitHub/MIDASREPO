/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Events file update for fees')                */
/********************************************************************/
/*                                                                  */
/*  Midas - Customer Lending Module                                 */
/*                                                                  */
/*  LEC0609B -  EVENTS FILE CREATION II & FEE BILLS & TELEX EXT     */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*       Last Amend No. CLE075AP           Date 06Aug12              */
/*       Prev Amend No. 262509             Date 01Aug12              */
/*                      CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      219226             Date 30Jun03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CLE014             Date 20Mar01              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                 104072             Date 09May97                  */
/*                 045634             Date 23Apr93                  */
/*                 S01270             DATE 23APR92                  */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       CLE075AP - COB Restructure - LE COB Optimisation Phase 1   */
/*       262509 - Empty STAT flag returned by COB                    */
/*       CLE134 - Past Due Call Loan Processing                      */
/*  219226 - Settlement method 09                                   */
/*  CLE014 - Customer Driven Lending Enhancements                   */
/*  104072  -  ALTHOUGH THE PROGRAM HAS RECOVERY PROCESSING CODED,  */
/*             THE SETTING OF THE RESTART FLAG ON CBCOMSPD DOES NOT */
/*             ALWAYS GET SET.                                      */
/*          -  THE CLEAR OF LVENTZZ, LVENTEL AND LVENTHH SHOULD     */
/*             NOT BE RESTRICTED TO A RESTART RUN.                  */
/*  045634  -  UPDATE ONLINE POSITIONS :                            */
/*             CHANGE EVENTS OUTPUT, ONLY OUTPUT AFTER LE0492       */
/*  S01270  -  CUSTOMER LENDING CHANGES TO LE0490 ET AL             */
/*             COMMITMENT FEE PROCESSING HAS BEEN REMOVED FROM      */
/*             CUSTOMER LENDING AND REPLACED WITH THE FEE           */
/*             ENHANCEMENTS - LE0491 REPLACES LE0490 TO PROCESS     */
/*             ONLY FACILITY UPDATES IN LEC0609. THIS PROGRAM       */
/*             LEC0609B CALLS LE0492 WHICH COMPLETES THE EVENT      */
/*             FILE UPDATE AND PRODUCES THE INFORMATION FOR         */
/*             COB BILLS & TELEXES PROCESSING                       */
/*                                                                  */
/********************************************************************/
/**********  PGM        PARM(&CNAM &CSEQ) */                                       /*S01189 CLE134*/
             PGM        PARM(&CNAM &CSEQ &RERUN)                                          /*CLE134*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) +
                        VALUE('CUSTOMER LENDING EVENTS FILE +
                        UPDATE FOR FEES ')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
/**********  DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')    */                  /*CLE075AP*/
/**********  DCL        VAR(&STAT2) TYPE(*CHAR) LEN(1) VALUE('Y')   */           /*104072 CLE075AP*/
/**/                                                                  /*CLE014*/
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7) +
                          VALUE('       ')                            /*CLE014*/
             DCL        VAR(&POPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                            /*CLE014*/
             DCL        VAR(&PSARD) TYPE(*CHAR) LEN(6) +
                          VALUE('CLE014')                             /*CLE014*/
             DCL        VAR(&CLE014) TYPE(*CHAR) LEN(1) VALUE('N')    /*CLE014*/
             DCL        VAR(&CLE033) TYPE(*CHAR) LEN(1) VALUE('N')                        /*219226*/
             DCL        VAR(&RERUN) TYPE(*CHAR) LEN(10)                                   /*CLE134*/
             DCL        VAR(&LEPDCL) TYPE(*CHAR) LEN(256)                                 /*CLE134*/
             DCL        VAR(&CSEQA) TYPE(*CHAR) LEN(5)                                  /*CLE075AP*/
             DCL        VAR(&STEXT) TYPE(*CHAR) LEN(26)                                 /*CLE075AP*/
             DCL        VAR(&SEVENT) TYPE(*CHAR) LEN(15)                                /*CLE075AP*/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)                                   /*CLE075AP*/
             DCL        VAR(&USR) TYPE(*CHAR) LEN(10)                                   /*CLE075AP*/
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)                                    /*CLE075AP*/
             DCL        VAR(&START) TYPE(*DEC) LEN(10 0)                                /*CLE075AP*/
             DCL        VAR(&FINISH) TYPE(*DEC) LEN(10 0)                               /*CLE075AP*/
             DCL        VAR(&SJRNRCVR) TYPE(*CHAR) LEN(10)                              /*CLE075AP*/
             DCL        VAR(&FJRNRCVR) TYPE(*CHAR) LEN(10)                              /*CLE075AP*/
/*/COPY WNCPYSRC,LEC0609B01                                          */
/**/                                                                  /*CLE014*/
             IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)                                /*CLE134*/
             RTVDTAARA  DTAARA(LEPDCL) RTNVAR(&LEPDCL)                                    /*CLE134*/
                 IF         COND(%SUBSTRING(&LEPDCL 1 1) *EQ 'N') +
                               THEN(GOTO CMDLBL(ENDPGM))                                  /*CLE134*/
             ENDDO                                                                        /*CLE134*/
/* Check if CLE014 is installed */                                    /*CLE014*/
/**/                                                                  /*CLE014*/
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD)      /*CLE014*/
             IF         (&PRTCD *EQ ' ') (CHGVAR (&CLE014) +
                   VALUE('Y'))                                        /*CLE014*/
             ELSE  IF (&PRTCD *NE '*NRF   ') THEN(DO)                 /*CLE014*/
                   SNDPGMMSG  MSG('LE Events File Update for Fees +
                          failure - AOSARDR0 ERROR') +
                           TOMSGQ(MOPERQ)                             /*CLE014*/
                   CHGJOB SWS(XXXXXX11)                               /*CLE014*/
                   GOTO   CMDLBL(ENDPGM)                              /*CLE014*/
             ENDDO                                                    /*CLE014*/
/**/                                                                                      /*219226*/
/* Check if CLE033 is installed */                                                        /*219226*/
/**/                                                                                      /*219226*/
             CHGVAR     VAR(&PSARD) VALUE('CLE033')                                       /*219226*/
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD)                          /*219226*/
             IF         (&PRTCD *EQ ' ') (CHGVAR (&CLE033) +
                   VALUE('Y'))                                                            /*219226*/
             ELSE  IF (&PRTCD *NE '*NRF   ') THEN(DO)                                     /*219226*/
                   SNDPGMMSG  MSG('LE Events File Update for Fees +
                          failure - AOSARDR0 ERROR') +
                           TOMSGQ(MOPERQ)                                                 /*219226*/
                   CHGJOB SWS(XXXXXX11)                                                   /*219226*/
                   GOTO   CMDLBL(ENDPGM)                                                  /*219226*/
             ENDDO                                                                        /*219226*/
                                                                                        /*CLE075AP*/
/* Write current journal sequence number to file SCJSEQPD, using */                     /*CLE075AP*/
/* command SCWRTJREG */                                                                 /*CLE075AP*/
                                                                                        /*CLE075AP*/
             CHGVAR     VAR(&CSEQA) VALUE(&CSEQ)                                        /*CLE075AP*/
             CHGVAR     VAR(&STEXT) VALUE('Start of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                  /*CLE075AP*/
             CHGVAR     VAR(&SEVENT) VALUE(&CNAM *TCAT &CSEQA)                          /*CLE075AP*/
             SCWRTJREG  EVENT(&SEVENT) COMP(&CNAM) CMPSEQ(&CSEQ) +
                          FLAG('S') TEXT(&STEXT)                                        /*CLE075AP*/
/**/
                CLRPFM     FILE(CUTX2HH)
                CLRPFM     FILE(CUTX2HP)
                CLRPFM     FILE(CUTX2ZX)
/**/
                CLRPFM     FILE(CFTLXHH)
                CLRPFM     FILE(CFTLXPR)
                CLRPFM     FILE(CFTLXZZ)
/**/                                                                  /*104072*/
                CLRPFM     FILE(LVENTEL)                              /*104072*/
                CLRPFM     FILE(LVENTZZ)                              /*104072*/
                CLRPFM     FILE(LVENTHH)                              /*104072*/
/**/                                                                  /*CLE014*/
             IF         COND(&CLE014 *EQ 'Y') THEN(DO)                /*CLE014*/
                CLRPFM     FILE(LECAFEPD)                             /*CLE014*/
             ENDDO                                                    /*CLE014*/
/**/                                                                                      /*219226*/
             IF         COND(&CLE033 *EQ 'Y') THEN(DO)                                    /*219226*/
                CLRPFM     FILE(LEHOSTPD)                                                 /*219226*/
             ENDDO                                                                        /*219226*/
/*/COPY WNCPYSRC,LEC0609B02                                          */
/**/
/**********  CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)          */                 /*CLE075AP*/
/**/
/**********  IF         COND(&STAT *EQ 'N') THEN(DO) */                                   /*262509*/
/**********  IF         COND(&STAT *NE 'Y') THEN(DO) */                          /*262509 CLE075AP*/
/**/
/**Set*restart*flag**/                                                           /*104072 CLE075AP*/
/**********  CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT2)         */          /*104072 CLE075AP*/
/*   CPYF       FROMFILE(LVENTEL) TOFILE(XLVENTEL) MBROPT(*REPLACE)    045634 */
/*   MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLVENTEL)) 045634 */
/*   CPYF       FROMFILE(LVENTZZ) TOFILE(XLVENTZZ) MBROPT(*REPLACE)    045634 */
/*   MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLVENTZZ)) 045634 */
/****CPYF**     FROMFILE(LEFEED) TOFILE(XLEFEED) MBROPT(*REPLACE)    */                 /*CLE075AP*/
/****MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLEFEED))*/                 /*CLE075AP*/
/****CPYF**     FROMFILE(CUTX1ZX) TOFILE(XCUTX1ZX) MBROPT(*REPLACE)  */                 /*CLE075AP*/
/****MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XCUTX1ZX))*/                /*CLE075AP*/
/****CPYF**     FROMFILE(CUTX1HP) TOFILE(XCUTX1HP) MBROPT(*REPLACE)  */                 /*CLE075AP*/
/****MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XCUTX1HP))*/                /*CLE075AP*/
/****CPYF**     FROMFILE(LETLXZX) TOFILE(XLETLXZX) MBROPT(*REPLACE)  */                 /*CLE075AP*/
/****MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLETLXZX))*/                /*CLE075AP*/
/****CPYF**     FROMFILE(LETLXDK) TOFILE(XLETLXDK) MBROPT(*REPLACE)  */                 /*CLE075AP*/
/****MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XLETLXDK))*/                /*CLE075AP*/
/**/
/**********   ENDDO                                                  */                 /*CLE075AP*/
/**********   ELSE CMD(DO)                                           */                 /*CLE075AP*/
/**********     CLRPFM     FILE(LVENTEL)                   /*045634*/ /*104072*/
/**********     CLRPFM     FILE(LVENTZZ)                   /*045634*/ /*104072*/
/**********     CLRPFM     FILE(LVENTHH)                   /*045634*/ /*104072*/
/**/
/*   CPYF       FROMFILE(XLVENTEL) TOFILE(LVENTEL) MBROPT(*REPLACE)    045634 */
/*   MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(LVENTEL))  045634 */
/*   CPYF       FROMFILE(XLVENTZZ) TOFILE(LVENTZZ) MBROPT(*REPLACE)    045634 */
/*   MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(LVENTZZ))  045634 */
/****CPYF**     FROMFILE(XLEFEED) TOFILE(LEFEED) MBROPT(*REPLACE)    */                 /*CLE075AP*/
/****MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(LEFEED)) */                 /*CLE075AP*/
/****CPYF**     FROMFILE(XCUTX1ZX) TOFILE(CUTX1ZX) MBROPT(*REPLACE)  */                 /*CLE075AP*/
/****MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(CUTX1ZX))*/                 /*CLE075AP*/
/****CPYF**     FROMFILE(XCUTX1HP) TOFILE(CUTX1HP) MBROPT(*REPLACE)  */                 /*CLE075AP*/
/****MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(CUTX1HP))*/                 /*CLE075AP*/
/****CPYF**     FROMFILE(XLETLXZX) TOFILE(LETLXZX) MBROPT(*REPLACE)  */                 /*CLE075AP*/
/****MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(LETLXZX))*/                 /*CLE075AP*/
/****CPYF**     FROMFILE(XLETLXDK) TOFILE(LETLXDK) MBROPT(*REPLACE)  */                 /*CLE075AP*/
/****MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(LETLXDK))*/                 /*CLE075AP*/
/****ENDDO*                                                          */                 /*CLE075AP*/
/**/
                SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
/**/
                IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/
/**********           CHGVAR     VAR(&STAT) VALUE('Y')                /*104072*/
/**********           CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)  /*104072*/
/**/
/*                BLOCK LARGE FILES                                */
/**/
                   OVRDBF     FILE(LVENTEL) SEQONLY(*YES 100)
/**/
                   CALL       PGM(LE0492)
/**/
                   DLTOVR     FILE(LVENTEL)
/**/
/**/
                ENDDO
/**/
/**********  IF         COND(%SWITCH(XXXXXX00)) THEN(DO)             */                 /*CLE075AP*/
/**********        CHGVAR     VAR(&STAT) VALUE('N')                  */                 /*CLE075AP*/
/**********        CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)    */                 /*CLE075AP*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                /*CLE075AP*/
                                                                                        /*CLE075AP*/
/* If abnormal, retrieve attributes of current job */                                   /*CLE075AP*/
                                                                                        /*CLE075AP*/
             RTVJOBA    JOB(&JOB) USER(&USR) NBR(&NBR)                                  /*CLE075AP*/
                                                                                        /*CLE075AP*/
/* Retrieve the most recent journal entry sequence number */                            /*CLE075AP*/
/* for the specific job */                                                              /*CLE075AP*/
                                                                                        /*CLE075AP*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                          TOENT(*FIRST) SEARCH(*DESCEND) +
                          JOB(&NBR/&USR/&JOB) RTNSEQNBR(&START) +
                          RTNRCV(&SJRNRCVR)                                             /*CLE075AP*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)                                 /*CLE075AP*/
             CHGVAR     VAR(&START) VALUE(0)                                            /*CLE075AP*/
             ENDDO                                                                      /*CLE075AP*/
                                                                                        /*CLE075AP*/
/* Determine starting journal sequence number of current job */                         /*CLE075AP*/
                                                                                        /*CLE075AP*/
             SCRTVJEVT  EVENT(&SEVENT) FLAG('S') RECEIVER(&FJRNRCVR) +
                           SEQ(&FINISH)                                                 /*CLE075AP*/
                                                                                        /*CLE075AP*/
/* Remove journal changes */                                                            /*CLE075AP*/
                                                                                        /*CLE075AP*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)                                                      /*CLE075AP*/
             RMVJRNCHG  JRN(ICJRN) FILE((LEFEED) (CUTX1ZX) (CUTX1HP) +
                          (LETLXZX) (LETLXDK)) RCVRNG(&SJRNRCVR +
                          &FJRNRCVR) FROMENT(&START) TOENT(&FINISH)                     /*CLE075AP*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041)                          /*CLE075AP*/
             ENDDO                                                                      /*CLE075AP*/
                                                                                        /*CLE075AP*/
             ENDDO
/**/
/* Write current journal sequence number to file SCJSEQPD, using */                     /*CLE075AP*/
/* command SCWRTJREG */                                                                 /*CLE075AP*/
                                                                                        /*CLE075AP*/
             CHGVAR     VAR(&STEXT) VALUE(' ')                                          /*CLE075AP*/
             CHGVAR     VAR(&STEXT) VALUE('End of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                  /*CLE075AP*/
             SCWRTJREG  EVENT(&SEVENT) COMP(&CNAM) CMPSEQ(&CSEQ) +
                          FLAG('E') TEXT(&STEXT)                                        /*CLE075AP*/
                                                                                        /*CLE075AP*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM:      ENDPGM
