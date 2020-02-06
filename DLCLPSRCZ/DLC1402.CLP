/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL INTERIM INTEREST REPORT')                    */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC1402 - INTERIM INTEREST REPORT                          */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO. S01189            DATE  05JAN90             */
/*       PREV AMEND NO. S01117            DATE  22/09/89            */
/*       PREV AMEND NO. S01194            DATE  22/09/89            */
/*       PREV AMEND NO. S01179            DATE  14/09/88            */
/*       PREV AMEND NO. E80459            DATE  13/06/86            */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                             */
/*       S01189  -  COB recovery processing.                        */
/*       S01117  -  MULTIBRANCHING                                  */
/*       S01194  -  STANDING DATA CHANGES.                          */
/*       S01179  -  AS400 CONVERSION                                */
/*                                                                  */
/********************************************************************/
/*********** PGM        PARM(&MONTH &TYPE)                            /*S01117*/
 
/*&RLEV IS A STANDARD RCF PARAMTER NOT USED IN THIS PROGRAM           /*S01117*/
/*********** PGM PARM(&RSEQ &RLEV &RENT)                              /*S01117*/
             PGM PARM(&CNAM &CSEQ &RSEQ &RLEV &RENT &PARM)            /*S01117*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */        /*S01117*/
   DCL VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level flag (S/C/B)        /*S01117*/
   DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code (all/comp/bch)/*S01117*/
             DCL        VAR(&MONTH) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&DLSTAT) TYPE(*CHAR) LEN(256)             /*S01179*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                /*S01179*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                /*S01189*/
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')      /*S01189*/
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(100)               /*S01117*/
             CHGVAR     VAR(&MONTH) VALUE(%SUBSTRING(&PARM 1 2))      /*S01117*/
             CHGVAR     VAR(&TYPE)  VALUE(%SUBSTRING(&PARM 3 1))      /*S01117*/
/********    DCLDTAARA  DTAARA(DLSTAT)                                  S01179*/
/********    DCLDTAARA  DTAARA(LDA)                                     S01179*/
/**/
/**/                                                                  /*E80459*/
             ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))                 /*E80459*/
/*********   RCVDTAARA  DTAARA(DLSTAT)                           E80459 S01179*/
             RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)                /*S01179*/
             IF         COND(%SUBSTRING(&DLSTAT 21 1) *NE 'Y') +
                           THEN(DO)                                   /*E80459*/
                SNDPGMMSG  MSG('INTEREST TAX NOT USED - MONTHLY +
                              INTEREST REPORT NOT RUN') TOMSGQ(MRUNQ) /*E80459*/
                DLCOBJ  OBJ((DLSTAT *DTAARA *EXCLRD))                 /*E80459*/
                GOTO       ENDCLPGM                                   /*E80459*/
             ENDDO                                                    /*E80459*/
             IF         COND(&TYPE *EQ I) THEN(DO)
                SNDPGMMSG  MSG('Interest Report - Interim') TOMSGQ(MRUNQ)
                CHGJOB     SWS(00010000)
             ENDDO
/**/
             ELSE       CMD(DO)
                SNDPGMMSG  MSG('Interest Report - Chosen Month') +
                             TOMSGQ(MRUNQ)
                CHGJOB     SWS(00000000)
             ENDDO
/**/
/*********   RCVDTAARA  DTAARA(LDA)                                     S01179*/
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                      /*S01179*/
             CHGVAR     VAR(%SUBSTRING(&LDA 1 2)) VALUE(&MONTH)
/**********  SNDDTAARA  DTAARA(LDA)                                     S01179*/
             CHGDTAARA  DTAARA(LDA) VALUE(&LDA)                       /*S01179*/
/**/
/************ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))                 /*S01189*/
/**/
/*********   RCVDTAARA  DTAARA(DLSTAT)                                  S01179*/
/************RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)    /*S01179*/  /*S01189*/
             CHGVAR     VAR(&STAT) VALUE(' ')                         /*S01189*/
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)           /*S01189*/
/**/
/************IF         COND(%SUBSTRING(&DLSTAT 17 3) *EQ 'OLD') +
 *************************THEN(DO)                                    /*S01189*/
             IF         COND(&STAT *EQ 'N') THEN(DO)                  /*S01189*/
                CLRPFM     FILE(MINTTMH)
                CLRPFM     FILE(MINTTMD)
                CLRPFM     FILE(MINTTMT)
/**/
/************   OVRDBF     FILE(TABLE) TOFILE(TABDLEE)                /*S01194*/
/************   CALL       PGM(DL1415)                                /*S01117*/
                CALL       PGM(DL1415) PARM(&RSEQ &RENT)              /*S01117*/
/**/
                IF         COND(%SWITCH(XXXX00X0)) THEN(DO)
/******************CHGVAR     VAR(%SUBSTRING(&DLSTAT 17 3)) +
 ********************************VALUE('NEW')                         /*S01189*/
/*******           SNDDTAARA  DTAARA(DLSTAT)                   S01179*/
/******************CHGDTAARA  DTAARA(DLSTAT) VALUE(&DLSTAT)/*S01179*/ /*S01189*/
                   CHGVAR     VAR(&STAT) VALUE('Y')                   /*S01189*/
                   CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)     /*S01189*/
                ENDDO
/**/
             ENDDO
/**/
             IF         COND(%SWITCH(XXXX0000)) THEN(DO)
/**/
                IF         COND(%SWITCH(XXX1XXXX)) THEN(DO)
/**/
/**********        RCVDTAARA  DTAARA(DLSTAT)                            S01179*/
/******************RTVDTAARA DTAARA(DLSTAT) RTNVAR(&DLSTAT)/*S01179*/ /*S01189*/
                   CHGVAR     VAR(&STAT) VALUE(' ')                   /*S01189*/
                   CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)     /*S01189*/
/**/
/******************IF         COND(%SUBSTRING(&DLSTAT 17 3) *EQ 'NEW') +
 *******************************THEN(DO)                              /*S01189*/
                   IF         COND(&STAT *EQ 'Y') THEN(DO)            /*S01189*/
/**/
                      CLRPFM     FILE(MINTRMH)
                      CLRPFM     FILE(MINTRMD)
                      CLRPFM     FILE(MINTRMT)
/**/
                      CPYF       FROMFILE(MINTTMH) TOFILE(MINTRMH) +
                                 MBROPT(*ADD) FMTOPT(*NOCHK) COMPRESS(*NO)
                      CPYF       FROMFILE(MINTTMD) TOFILE(MINTRMD) +
                                 MBROPT(*ADD) FMTOPT(*NOCHK) COMPRESS(*NO)
                      MONMSG     MSGID(CPF2817)
                      CPYF       FROMFILE(MINTTMT) TOFILE(MINTRMT) +
                                 MBROPT(*ADD) FMTOPT(*NOCHK) COMPRESS(*NO)
/**/
                      CLRPFM     FILE(MINTTMH)
                      CLRPFM     FILE(MINTTMD)
                      CLRPFM     FILE(MINTTMT)
/**/
/*********************CHGVAR     VAR(%SUBSTRING(&DLSTAT 17 3)) +
 ***********************************VALUE('OLD')                      /*S01189*/
/*************        SNDDTAARA  DTAARA(DLSTAT)                         S01179*/
/*******************CHGDTAARA DTAARA(DLSTAT) VALUE(&DLSTAT)/*S01179*/ /*S01189*/
                      CHGVAR     VAR(&STAT) VALUE('N')                /*S01189*/
                      CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)  /*S01189*/
/**/
                   ENDDO
/**/
                ENDDO
/**/
             ENDDO
/**/
             ELSE       CMD(DO)
/**/
/*******************************************************************/
/**/
                IF         COND(%SWITCH(XXXX1XXX)) THEN( SNDPGMMSG             +
                            MSG('RUN DATE INVALID FOR MONTH SELECTED           +
                             ') TOMSGQ(MOPERQ MRUNQ))
/**/
                IF         COND(%SWITCH(XXXXX1XX)) THEN(                       +
                                SNDPGMMSG MSG('RUN DATE NOT LAST               +
                                DAY OF WORKING MONTH') TOMSGQ(MRUNQ            +
                                MOPERQ))
/**/
                IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
/**/
                   IF         COND(%SWITCH(XXXXXX0X)) THEN(                    +
                                SNDPGMMSG MSG('FILE CONTROLS OUT OF            +
                                BALANCE') TOMSGQ(MOPERQ MRUNQ))
                   ELSE       CMD(SNDPGMMSG MSG('DATBASE ERROR')               +
                                          TOMSGQ(MOPERQ MRUNQ))
/**/
                ENDDO
/**/
             ENDDO
/**/
/************DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))                 /*S01189*/
/**/
/************ENDPGM                                                 *  *E80459*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDCLPGM:    ENDPGM                                                   /*E80459*/
