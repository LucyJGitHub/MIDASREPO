/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE Generate/Report on base rate changes')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC74 - GENERATION OF BASE RATE CHANGES                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CRE083AU           Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 106312             Date 10Apr97              */
/*                      091413             Date 09Nov95              */
/*                      S01408             DATE 11MAY95              */
/*                      084534             DATE 27FEB95              */
/*                      049412             DATE 28SEP93              */
/*                      051560             DATE 28SEP93              */
/*                      S01413             DATE 13APR93              */
/*                      E22196                  20JUN90              */
/*                      LN0395                  19JUN90              */
/*                      S01194                  12MAR90              */
/*                      S01189                  12MAR90              */
/*                      S01179                  21OCT88              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*     CRE083AU - COB Restructure - RE COB Optimisation Phase 1      */
/*     106312 - Stopped object locking whilst copying files          */
/*     091413 - Extend change 049412 to include SDBSRTPD.            */
/*     S01408 - Addition of core hook REC74MPS                       */
/*     084534 - Monitor for TABLETK being empty                      */
/*       049412 - Loss of info in case of restart of RE0740          */
/*       051560 - Must call RE0744 with OVRDBF TABLE to TABRE2       */
/*       S01413 - Header Box Standardised                            */
/*       E22196 - Increase record wait time on TABRE2 to 1800 Secs   */
/*                as records on TABLETK may be locked for update by  */
/*                concurrent COB streams for more than 60 seconds.   */
/*       LN0395 - add in another override to table to prevent        */
/*                RE0744 falling over                                */
/*       S01194 - New Standing data                                  */
/*       S01189 - COB recovery processing.                           */
/*       S01179 - AS/400 Conversion                                  */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/********    PGM                                                      /*S01189*/
             PGM     PARM(&CNAM &CSEQ)                                /*S01189*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                                    /*CRE083AU*/
             DCL        VAR(&SEVENT) TYPE(*CHAR) LEN(15)                                /*CRE083AU*/
             DCL        VAR(&SJRNRCVR) TYPE(*CHAR) LEN(10)                              /*CRE083AU*/
             DCL        VAR(&FJRNRCVR) TYPE(*CHAR) LEN(10)                              /*CRE083AU*/
             DCL        VAR(&CSEQA) TYPE(*CHAR) LEN(5)                                  /*CRE083AU*/
             DCL        VAR(&STEXT) TYPE(*CHAR) LEN(25)                                 /*CRE083AU*/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)                                   /*CRE083AU*/
             DCL        VAR(&USR) TYPE(*CHAR) LEN(10)                                   /*CRE083AU*/
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)                                    /*CRE083AU*/
             DCL        VAR(&START) TYPE(*DEC) LEN(10 0)                                /*CRE083AU*/
             DCL        VAR(&FINISH) TYPE(*DEC) LEN(10 0)                               /*CRE083AU*/
/**/                                                                                    /*CRE083AU*/
/************DCL     VAR(&MEM) TYPE(*CHAR) LEN(44)                   * *S01194*/
             DCL     VAR(&MEM) TYPE(*CHAR) LEN(50)                    /*S01194*/
             DCL     VAR(&CNAM) TYPE(*CHAR) LEN(10)                   /*S01189*/
             DCL     VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                   /*S01189*/
             DCL     VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')         /*S01189*/
             DCL     VAR(&LDA) TYPE(*CHAR) LEN(256)
/********    DCL     VAR(&RESTAT) TYPE(*CHAR) LEN(256)                /*S01189*/
/*>>049412>>*/
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             RTVDTAARA  DTAARA(SDSTAT *ALL) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,REC74MPS                                            */
                                                                      /*S01408*/
/*<<049412<<*/
             SNDPGMMSG MSG('REC74 - Generation of Base Rate Changes') +
                       TOMSGQ(MRUNQ)
/**/                                                                                    /*CRE083AU*/
/* Write current journal sequence number to file SCJSEQPD */                            /*CRE083AU*/
/**/                                                                                    /*CRE083AU*/
             CHGVAR     VAR(&CSEQA) VALUE(&CSEQ)                                        /*CRE083AU*/
             CHGVAR     VAR(&STEXT) VALUE('Start of ' *TCAT &CNAM +
                          *TCAT &CSEQA)                                                 /*CRE083AU*/
             CHGVAR     VAR(&SEVENT) VALUE(&CNAM *TCAT &CSEQA)                          /*CRE083AU*/
             SCWRTJREG  EVENT(&SEVENT) COMP(&CNAM) CMPSEQ(&CSEQ) +
                          FLAG('S') TEXT(&STEXT)                                        /*CRE083AU*/
/**/
/********    IF COND(%SST(&RESTAT 30 1)='Y') THEN(GOTO CMDLBL(PGM2))  /*S01189*/
/**********  CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT) */                   /*S01189 CRE083AU*/
/* >>> 051560 >>> */
             OVRDBF FILE(TABLE) TOFILE(TABRE2) WAITRCD(1800)
             OVRDBF FILE(BCHGZZ) TOFILE(RTZZ) MBR(BCHG)
/* <<< 051560 <<< */
/**********  IF COND(&STAT *EQ 'Y') THEN(GOTO CMDLBL(PGM2))                      /*S01189 CRE083AU*/
/**********  ELSE CMD(DO)                                                               /*CRE083AU*/
/**/
             CLRPFM FILE(BCHGHH)
             CLRPFM FILE(BCHGR1)
             CLRPFM FILE(RTZZ) MBR(BCHG)
/*                                                                     *E22196*/
/*  CHANGE DEFAULT OF WAITRCD(60) ON TABRE2 TO 1800 SECONDS TO         *E22196*/
/*  PREVENT THIS STREAM FROM ENDING IN ERROR IF A RECORD ON TABLETK    *E22196*/
/*  IS LOCKED FOR UPDATE BY ANOTHER STREAM FOR MORE THAN 60 SECONDS    *E22196*/
/************OVRDBF FILE(TABLE) TOFILE(TABRE2)                         *E22196*/
/* >>> 051560 >>> */
/*******     OVRDBF FILE(TABLE) TOFILE(TABRE2) WAITRCD(1800)   *****/
/*******                                                  END OF CHANGE E22196*/
/*******     OVRDBF FILE(BCHGZZ) TOFILE(RTZZ) MBR(BCHG)        *****/
/* <<< 051560 <<< */
/**/
/*>> 049412 >>*/                                                                        /*CRE083AU*/
/**********  CPYF       FROMFILE(TABLETK) TOFILE(&TOLIB/XTABLETK) + */                  /*CRE083AU*/
/**********               MBROPT(*ADD) CRTFILE(*YES) */                                 /*CRE083AU*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM + */                 /*CRE083AU*/
/**********               FILE(XTABLETK)) */                                     /*084534 CRE083AU*/
/*<< 049412 <<*/                                                                        /*CRE083AU*/
/**/                                                                             /*091413 CRE083AU*/
/**********  CPYF       FROMFILE(SDBSRTPD) TOFILE(&TOLIB/XSDBSRTPD) +*/                 /*CRE083AU*/
/**********               MBROPT(*ADD) CRTFILE(*YES) */                          /*091413 CRE083AU*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM + */                 /*CRE083AU*/
/**********               FILE(XSDBSRTPD)) */                                    /*091413 CRE083AU*/
/**/                                                                             /*091413 CRE083AU*/
             CALL PGM(RE0740)
/**/
             IF COND(*NOT %SWITCH(XXXXXX00)) THEN(GOTO CMDLBL(ERROR1))
/********    RTVDTAARA DTAARA(RESTAT *ALL) RTNVAR(&RESTAT)            /*S01189*/
/********    CHGDTAARA DTAARA(RESTAT (30 1)) VALUE(Y)                 /*S01189*/
/*           SNDDTAARA DTAARA(RESTAT)            S01179*/
/********    CHGDTAARA  DTAARA(RESTAT) VALUE(&RESTAT)   /*S01179*/    /*S01189*/
/**********  CHGVAR     VAR(&STAT) VALUE('Y')                                    /*S01189 CRE083AU*/
/**********  CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)                      /*S01189 CRE083AU*/
             GOTO       CMDLBL(WRTJRN)                                                  /*CRE083AU*/
/**********  ENDDO */                                                                   /*CRE083AU*/
/*                                                                     *E22196*/
/*  RESET WAIT RECORD TIME TO 60 SECONDS WHEN RE0740 HAS COMPLETED     *E22196*/
/**********  OVRDBF   FILE(TABLE) TOFILE(TABRE2) WAITRCD(60) */                  /*E22196 CRE083AU*/
/*                                                                     *E22196*/
/*PGM2:        CALL PGM(RE0744)             */                        /*LN0395*/
PGM2:                                                                 /*LN0395*/
/**********  OVRDBF FILE(TABLE) TOFILE(TABRE2) */                                /*LN0395 CRE083AU*/
/**********  OVRDBF FILE(BCHGZZ) TOFILE(RTZZ) MBR(BCHG) */                       /*LN0395 CRE083AU*/
/**********  CALL PGM(RE0744) */                                                 /*LN0395 CRE083AU*/
/**/
/**********  DLTOVR FILE(TABLE) */                                                      /*CRE083AU*/
/**/
/**********  IF COND(%SWITCH(XXXXXX00)) THEN(DO) */                                     /*CRE083AU*/
/********       RTVDTAARA DTAARA(RESTAT *ALL) RTNVAR(&RESTAT)         /*S01189*/
/********       CHGDTAARA DTAARA(RESTAT (30 1)) VALUE(' ')            /*S01189*/
/*           SNDDTAARA DTAARA(RESTAT)            S01179*/
/********    CHGDTAARA  DTAARA(RESTAT) VALUE(&RESTAT)   /*S01179*/    /*S01189*/
/**********     CHGVAR     VAR(&STAT) VALUE('N')                                 /*S01189 CRE083AU*/
/**********     CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)                   /*S01189 CRE083AU*/
/**********  ENDDO */                                                                   /*CRE083AU*/
/**/
/*           E R R O R   M E S S A G E S                       */
/**/
/**********  IF COND(%SWITCH(XXXXXXX1)) THEN(DO) */                                     /*CRE083AU*/
/**********     SNDPGMMSG MSG('FILE OUT OF BALANCE - RE0744') TOMSGQ(MOPERQ) */         /*CRE083AU*/
/**********  GOTO CMDLBL(ENDPGM) */                                                     /*CRE083AU*/
/**********  ENDDO */                                                                   /*CRE083AU*/
ERROR1:      IF COND(%SWITCH(XXXXXX1X)) THEN(DO)
                RTVDTAARA DTAARA(LDA *ALL) RTNVAR(&LDA)
/***************CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 44))            * *S01194*/
                CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))             /*S01194*/
                SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             ENDDO
             IF COND(%SWITCH(XXXXXXX1)) THEN(DO)
                SNDPGMMSG MSG('FILE OUT OF BALANCE - RE0740') TOMSGQ(MOPERQ)
             ENDDO
/*>> 049412 >>*/
             IF COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
             RCLRSC                                                   /*106312*/
/**********  CPYF       FROMFILE(XTABLETK) TOFILE(TABLETK) + */                         /*CRE083AU*/
/**********               MBROPT(*REPLACE) CRTFILE(*NO) */                              /*CRE083AU*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM + */                 /*CRE083AU*/
/**********               FILE(TABLETK)) */                                      /*084534 CRE083AU*/
/**********  CPYF       FROMFILE(XSDBSRTPD) TOFILE(SDBSRTPD) + */                       /*CRE083AU*/
/**********               MBROPT(*REPLACE) CRTFILE(*NO) */                       /*091413 CRE083AU*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM + */                 /*CRE083AU*/
/**********               FILE(SDBSRTPD)) */                                     /*091413 CRE083AU*/
/**/                                                                                    /*CRE083AU*/
/* Begin recovery from error. */                                                        /*CRE083AU*/
/**/                                                                                    /*CRE083AU*/
             RTVJOBA    JOB(&JOB) USER(&USR) NBR(&NBR)                                  /*CRE083AU*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) +
                          FROMENT(*LAST) TOENT(*FIRST) +
                          SEARCH(*DESCEND) JOB(&NBR/&USR/&JOB) +
                          RTNSEQNBR(&START) RTNRCV(&SJRNRCVR)                           /*CRE083AU*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)                                 /*CRE083AU*/
             CHGVAR     VAR(&START) VALUE(0)                                            /*CRE083AU*/
             ENDDO                                                                      /*CRE083AU*/
/**/                                                                                    /*CRE083AU*/
/* Determine starting journal sequence */                                               /*CRE083AU*/
/* number of current job. */                                                            /*CRE083AU*/
/**/                                                                                    /*CRE083AU*/
             SCRTVJEVT  EVENT(&SEVENT) FLAG('S') +
                          RECEIVER(&FJRNRCVR) SEQ(&FINISH)                              /*CRE083AU*/
/**/                                                                                    /*CRE083AU*/
/* Remove journal changes. */                                                           /*CRE083AU*/
/**/                                                                                    /*CRE083AU*/
             IF         COND((&START *NE 0) *AND +
                          (&FINISH *NE 0)) THEN(DO)                                     /*CRE083AU*/
             RMVJRNCHG  JRN(ICJRN) FILE((TABLETK) (SDBSRTPD)) +
                          FROMENT(&START) TOENT(&FINISH) +
                          RCVRNG(&SJRNRCVR &FJRNRCVR)                                   /*CRE083AU*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 +
                          CPF7041)                                                      /*CRE083AU*/
             ENDDO                                                                      /*CRE083AU*/
/**/                                                                                    /*CRE083AU*/
             ENDDO
/**********  DLTF XTABLETK */                                                           /*CRE083AU*/
/**********  DLTF       FILE(XSDBSRTPD) */                                       /*091413 CRE083AU*/
/**/                                                                                    /*CRE083AU*/
/* Write current journal sequence number to file SCJSEQPD */                            /*CRE083AU*/
/**/                                                                                    /*CRE083AU*/
WRTJRN:                                                                                 /*CRE083AU*/
             CHGVAR     VAR(&STEXT) VALUE(' ')                                          /*CRE083AU*/
             CHGVAR     VAR(&STEXT) VALUE('End of ' *TCAT &CNAM +
                          *TCAT &CSEQA)                                                 /*CRE083AU*/
             SCWRTJREG  EVENT(&SEVENT) COMP(&CNAM) CMPSEQ(&CSEQ) +
                          FLAG('E') TEXT(&STEXT)                                        /*CRE083AU*/
/*<< 049412 <<*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM:      ENDPGM
