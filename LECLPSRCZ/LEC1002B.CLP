/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE UPDTE MNTH TO DATE ON FACLTIES FLE')         */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*       LEC1002B - MONTHLY FACILITY PROCESSING AND REPORTING       */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*       Last Amend No. MD021980            Date 23Aug13             */
/*       Prev Amend No. MD021155            Date 10Jul13             */
/*                      CLE075AB            Date 06Aug12             */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      BHF116              DATE  08JUN90           */
/*                      S01189              DATE  07FEB90           */
/*                      S01194              DATE  07FEB90           */
/*                      S01179              DATE  14/09/88          */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD021980 - FCLTYFN and FCLTYFM cleared in month end COB     */
/*       MD021155 - COB Restructure - Reinstate call to LE0870 and   */
/*                  LEC1002B program split                           */
/*       CLE075AB - COB Restructure - LE COB Optimisation Phase 1    */
/*       BHF116 - CHANGE CALL TO LE0870 TO SEQ=' ', BRNCH=ALL       */
/*       S01189 - COB RECOVERY PROCESSING                           */
/*       S01194 - NEW STANDING DATA                                 */
/*       S01179 - AS400 INCORPORATION                               */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM                                                  */  /*S01189*/
             PGM        PARM(&CNAM &CSEQ)                             /*S01189*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) +
                        VALUE('MONTHLY FACILITY REPORTING')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)                  /*S01189*/
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)                 /*S01189*/
/************DCL        VAR(&LESTAT) TYPE(*CHAR) LEN(256)*/           /*S01189*/
                                                                                        /*MD021155*/
/* Journalling variables */                                                             /*MD021155*/
                                                                                        /*MD021155*/
             DCL        VAR(&CSEQA) TYPE(*CHAR) LEN(5)                                  /*MD021155*/
             DCL        VAR(&STEXT) TYPE(*CHAR) LEN(26)                                 /*MD021155*/
             DCL        VAR(&SEVENT) TYPE(*CHAR) LEN(15)                                /*MD021155*/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)                                   /*MD021155*/
             DCL        VAR(&USR) TYPE(*CHAR) LEN(10)                                   /*MD021155*/
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)                                    /*MD021155*/
             DCL        VAR(&START) TYPE(*DEC) LEN(10 0)                                /*MD021155*/
             DCL        VAR(&FINISH) TYPE(*DEC) LEN(10 0)                               /*MD021155*/
             DCL        VAR(&SJRNRCVR) TYPE(*CHAR) LEN(10)                              /*MD021155*/
             DCL        VAR(&FJRNRCVR) TYPE(*CHAR) LEN(10)                              /*MD021155*/
/**/
/************DCLDTAARA  DTAARA(LDA)                                 *  *S01179*/
/************DCLDTAARA  DTAARA(LESTAT)                              *  *S01179*/
                                                                                        /*MD021155*/
/* Global monitor message */                                                            /*MD021155*/
                                                                                        /*MD021155*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                                                /*MD021155*/
                                                                                        /*MD021155*/
/* Write current journal sequence number to file SCJSEQPD, using */                     /*MD021155*/
/* command SCWRTJREG */                                                                 /*MD021155*/
                                                                                        /*MD021155*/
             CHGVAR     VAR(&CSEQA) VALUE(&CSEQ)                                        /*MD021155*/
             CHGVAR     VAR(&STEXT) VALUE('Start of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                  /*MD021155*/
             CHGVAR     VAR(&SEVENT) VALUE(&CNAM *TCAT &CSEQA)                          /*MD021155*/
             SCWRTJREG  EVENT(&SEVENT) COMP(&CNAM) CMPSEQ(&CSEQ) +
                          FLAG('S') TEXT(&STEXT)                                        /*MD021155*/
                                                                                        /*MD021155*/
/**/
/*  IF P/MFU INDICATOR 'OLD' THEN CLEAR PF/FCLUPxx,                 */
/*   UPDATE FILES AND P/MFU INDICATOR TO 'NEW'                      */
/**/
/************RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)*/              /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE(' ')                         /*S01189*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
/**/
/************IF         COND(%SUBSTRING(&LESTAT 9 3) *EQ 'OLD') +
 ***********************THEN(DO)****/                                 /*S01189*/
             IF         COND(&BUSY = 'N') THEN(DO)                    /*S01189*/
/**/
                CLRPFM     FILE(FCLUPHH)       /* NEW LF/FCLTY FILE */
                CLRPFM     FILE(FCLUPFM)       /* OUTPUT FROM LE0860*/
                CLRPFM     FILE(FCLUPFN)
                CLRPFM     FILE(FCLUPZZ)
/**/
                SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
/**/
/***************OVRDBF     FILE(TABLE) TOFILE(TABLEEI)   */           /*S01194*/
             OVRDBF     FILE(FCLUPFM) FRCRATIO(5000) SEQONLY(*YES)                      /*CLE075AB*/
             OVRDBF     FILE(FCLUPFN) FRCRATIO(5000) SEQONLY(*YES)                      /*CLE075AB*/
                CALL       PGM(LE0860)
/***************DLTOVR     FILE(TABLE)                   */           /*S01194*/
/**/
                IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/
/******************OVRDBF     FILE(TABLE)  TOFILE(TABLEEI) */         /*S01194*/
/******************CALL       PGM(LE0870)                          */ /*BHF116*/
/**********        CALL       PGM(LE0870) PARM('     ' 'ALL')      */            /*BHF116 CLE075AB*/
/******************DLTOVR     FILE(TABLE)                  */         /*S01194*/
/**/
/**********        IF         COND(%SWITCH(XXXXXX00)) THEN(DO) */                       /*MD021155*/
/**/
/*********************ALCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))*/      /*S01189*/
/************RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)*/              /*S01189*/
/* P/MFU 'NEW'                                                      */
/************************CHGVAR     VAR(%SUBSTRING(&LESTAT 9 3)) +
 ***********************************VALUE('NEW')*/                    /*S01189*/
/************CHGDTAARA  DTAARA(LESTAT) VALUE(&LESTAT)*/               /*S01189*/
                      CHGVAR     VAR(&BUSY) VALUE('Y')                /*S01189*/
                      CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)       /*S01189*/
/*********************DLCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))*/      /*S01189*/
/**/
/**********        ENDDO */                                                             /*MD021155*/
/**/
                ENDDO
/**/
             ENDDO
/**/
/*   CLEAR FCLTY - COPY FCLUP TO FCLTY - CLEAR FCLUP - RESET IND */
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/
/************RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)*/              /*S01189*/
                CHGVAR     VAR(&BUSY) VALUE(' ')                      /*S01189*/
                CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)             /*S01189*/
/***************IF         COND(%SUBSTRING(&LESTAT 9 3) *EQ 'NEW') +
 **************************THEN(DO)****/                              /*S01189*/
                IF         COND(&BUSY = 'Y') THEN(DO)                 /*S01189*/
/**/
                   CLRPFM     FILE(FCLTYHH)
                   CLRPFM     FILE(FCLTYFM)
                   CLRPFM     FILE(FCLTYFN)
                   CLRPFM     FILE(FCLTYZZ)
/**/
/* UPDATE PF/FCLTYxx                                                 */
                   CPYF       FROMFILE(FCLUPHH) TOFILE(FCLTYHH) +
                              MBROPT(*ADD) FMTOPT(*NOCHK)
/**/
                   CPYF       FROMFILE(FCLUPFM) TOFILE(FCLTYFM) +
                              MBROPT(*ADD) FMTOPT(*NOCHK)
                   MONMSG     MSGID(CPF2817)
/**/
                   CPYF       FROMFILE(FCLUPFN) TOFILE(FCLTYFN) +
                              MBROPT(*ADD) FMTOPT(*NOCHK)
                   MONMSG     MSGID(CPF2817)
/**/
                   CPYF       FROMFILE(FCLUPZZ) TOFILE(FCLTYZZ) +
                              MBROPT(*ADD) FMTOPT(*NOCHK)
/**/
/* UPDATE P/MFU IND.                                                 */
/******************ALCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))*/         /*S01189*/
/************RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)*/              /*S01189*/
/******************CHGVAR     VAR(%SUBSTRING(&LESTAT 9 3)) +
 *****************************VALUE('OLD')***/                        /*S01189*/
/************CHGDTAARA  DTAARA(LESTAT) VALUE(&LESTAT)*/               /*S01189*/
                   CHGVAR     VAR(&BUSY) VALUE('N')                   /*S01189*/
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)          /*S01189*/
/******************DLCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))*/         /*S01189*/
/**/
/* Transferred clearing of FCLUP* and MNHST* files to generic */                        /*MD021155*/
/* components after the call to LEC1002C in Secondary COB */                            /*MD021155*/
/**********        CLRPFM     FILE(FCLUPHH) */                                          /*MD021155*/
/**********        CLRPFM     FILE(FCLUPFM) */                                          /*MD021155*/
/**********        CLRPFM     FILE(FCLUPFN) */                                          /*MD021155*/
/**********        CLRPFM     FILE(FCLUPZZ) */                                          /*MD021155*/
/**/
/**********        CLRPFM     FILE(MNHSTHH) /*  CREATED IN LEC1001  */                  /*MD021155*/
/**********        CLRPFM     FILE(MNHSTMN) */                                          /*MD021155*/
/**********        CLRPFM     FILE(MNHSTT2) */                                          /*MD021155*/
/**/
                ENDDO
/**/
             ENDDO
/* Write current journal sequence number to file SCJSEQPD.                              /*MD021155*/
                                                                                        /*MD021155*/
             CHGVAR     VAR(&STEXT) VALUE(' ')                                          /*MD021155*/
             CHGVAR     VAR(&STEXT) VALUE('End of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                  /*MD021155*/
             SCWRTJREG  EVENT(&SEVENT) COMP(&CNAM) CMPSEQ(&CSEQ) +
                          FLAG('E') TEXT(&STEXT)                                        /*MD021155*/
                                                                                        /*MD021155*/
/**/
             GOTO       CMDLBL(ENDPGM)                                                  /*MD021155*/
                                                                                        /*MD021155*/
ABNOR:                                                                                  /*MD021155*/
             CHGJOB     SWS(XXXXXX11)                                                   /*MD021980*/
                                                                                        /*MD021155*/
/* If abnormal, retrieve attributes of current job */                                   /*MD021155*/
                                                                                        /*MD021155*/
             RTVJOBA    JOB(&JOB) USER(&USR) NBR(&NBR)                                  /*MD021155*/
                                                                                        /*MD021155*/
/* Retrieve the most recent journal entry sequence number */                            /*MD021155*/
/* for the specific job */                                                              /*MD021155*/
                                                                                        /*MD021155*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                          TOENT(*FIRST) SEARCH(*DESCEND) +
                          JOB(&NBR/&USR/&JOB) RTNSEQNBR(&START) +
                          RTNRCV(&SJRNRCVR)                                             /*MD021155*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)                                 /*MD021155*/
             CHGVAR     VAR(&START) VALUE(0)                                            /*MD021155*/
             ENDDO                                                                      /*MD021155*/
                                                                                        /*MD021155*/
/* Determine starting journal sequence number of current job */                         /*MD021155*/
                                                                                        /*MD021155*/
             SCRTVJEVT  EVENT(&SEVENT) FLAG('S') RECEIVER(&FJRNRCVR) +
                           SEQ(&FINISH)                                                 /*MD021155*/
                                                                                        /*MD021155*/
/* Remove journal changes */                                                            /*MD021155*/
                                                                                        /*MD021155*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)                                                      /*MD021155*/
             RMVJRNCHG  JRN(ICJRN) FILE((FCLTYHH) (FCLTYFM) +
                          (FCLTYFN) (FCLTYZZ)) RCVRNG(&SJRNRCVR +
                          &FJRNRCVR) FROMENT(&START) TOENT(&FINISH)                     /*MD021155*/
             MONMSG     MSGID(CPF0000)                                                  /*MD021155*/
             ENDDO                                                                      /*MD021155*/
                                                                                        /*MD021155*/
ENDPGM:                                                                                 /*MD021155*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/***ENDPGM:      ENDPGM */                                                              /*MD021155*/
                 ENDPGM                                                                 /*MD021155*/
