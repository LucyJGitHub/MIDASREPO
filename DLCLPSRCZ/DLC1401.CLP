/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL MONTHLY INTEREST REPORT')                    */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC1401 - MONTHLY INTEREST REPORT                          */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01189             Date 05Jan90              */
/*                      S01117             Date 17/07/89             */
/*                    S01194                  DATE  17/07/89        */
/*                    S01179                  DATE  14/09/88        */
/*                    E10376                  DATE  26/02/87        */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*     S01189 - COB recovery processing.                            */
/*     S01117 - MULTIBRANCHING                                      */
/*     S01194 - STANDING DATA CHANGES.                              */
/*     S01179 - AS400 CONVERSION                                    *  *S01179*/
/*     E10376 - RESET SWITCHES AT BEGINNING OF PROGRAM              *  *E10376*/
/*                                                                  */
/********************************************************************/
/************PGM                                                        S01117*/
 
/************PGM                                                      /*S01189*/
             PGM        PARM(&CNAM &CSEQ)                             /*S01189*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */        /*S01117*/
   DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code (all/comp/bch)/*S01117*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                /*S01189*/
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')      /*S01189*/
             DCL        VAR(&DLSTAT) TYPE(*CHAR) LEN(256)             /*S01179*/
/*********** DCLDTAARA  DTAARA(DLSTAT)                                  S01179*/
/**/
 
/* THESE ARE MANDATORY REPORTS SO PARMS ARE PASSED HARD CODED HERE */
             CHGVAR     VAR(&RENT) VALUE('ALL')                       /*S01117*/
             CHGVAR     VAR(&RSEQ) VALUE('     ')                     /*S01117*/
 
             CHGJOB     SWS(00000000)                               /*E10376*/
             ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
/**********  RCVDTAARA  DTAARA(DLSTAT)                                  S01179*/
             RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)                /*S01179*/
             IF         COND(%SUBSTRING(&DLSTAT 21 1) *NE 'Y') +
                           THEN(DO)
                SNDPGMMSG  MSG('INTEREST TAX NOT USED - MONTHLY +
                              INTEREST REPORT NOT RUN') TOMSGQ(MRUNQ)
                DLCOBJ  OBJ((DLSTAT *DTAARA *EXCLRD))
                GOTO       ENDCLPGM
             ENDDO
/**/
/**/
             SNDPGMMSG  MSG('Monthly Interest Report') TOMSGQ(MRUNQ)
/**/
/************ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))                 /*S01189*/
/**/
/*********** RCVDTAARA  DTAARA(DLSTAT)                                  S01179*/
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
                CHGJOB     SWS(XX10XXXX)
/**/
/*************  OVRDBF     FILE(TABLE) TOFILE(TABDLEE)                /*S01194*/
/*************  CALL       PGM(DL1415)                                /*S01117*/
                CALL       PGM(DL1415) PARM(&RSEQ &RENT)              /*S01117*/
/**/
                IF         COND(%SWITCH(XXXX00X0)) THEN(DO)
/******************CHGVAR     VAR(%SUBSTRING(&DLSTAT 17 3)) +
 ********************************VALUE('NEW')                         /*S01189*/
/***********       SNDDTAARA  DTAARA(DLSTAT)                            S01179*/
/******************CHGDTAARA  DTAARA(DLSTAT) VALUE(&DLSTAT)/*S01179*/ /*S01189*/
                   CHGVAR     VAR(&STAT) VALUE('Y')                   /*S01189*/
                   CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)     /*S01189*/
                ENDDO
/**/
             ENDDO
/**/
             IF         COND(%SWITCH(XXXX0000)) THEN(DO)
/**/
/************   RCVDTAARA  DTAARA(DLSTAT)                               S01179*/
/***************RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT) /*S01179*/  /*S01189*/
                CHGVAR     VAR(&STAT) VALUE(' ')                      /*S01189*/
                CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)        /*S01189*/
/**/
/***************IF         COND(%SUBSTRING(&DLSTAT 17 3) *EQ 'NEW') +
 ****************************THEN(DO)                                 /*S01189*/
                IF         COND(&STAT *EQ 'Y') THEN(DO)               /*S01189*/
/**/
                   CLRPFM     FILE(MINTRMH)
                   CLRPFM     FILE(MINTRMD)
                   CLRPFM     FILE(MINTRMT)
/**/
                   CPYF       FROMFILE(MINTTMH) TOFILE(MINTRMH) +
                              MBROPT(*ADD) FMTOPT(*NOCHK) COMPRESS(*NO)
                   MONMSG     MSGID(CPF2817)
                   CPYF       FROMFILE(MINTTMD) TOFILE(MINTRMD) +
                              MBROPT(*ADD) FMTOPT(*NOCHK) COMPRESS(*NO)
                   MONMSG     MSGID(CPF2817)
                   CPYF       FROMFILE(MINTTMT) TOFILE(MINTRMT) +
                              MBROPT(*ADD) FMTOPT(*NOCHK) COMPRESS(*NO)
                   MONMSG     MSGID(CPF2817)
/**/
                   CLRPFM     FILE(MINTTMH)
                   CLRPFM     FILE(MINTTMD)
                   CLRPFM     FILE(MINTTMT)
/**/
/******************CHGVAR     VAR(%SUBSTRING(&DLSTAT 17 3)) +
 ********************************VALUE('OLD')                         /*S01189*/
/*************     SNDDTAARA  DTAARA(DLSTAT)                            S01179*/
/******************CHGDTAARA  DTAARA(DLSTAT) VALUE(&DLSTAT)/*S01179*/ /*S01189*/
                   CHGVAR     VAR(&STAT) VALUE('N')                   /*S01189*/
                   CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)     /*S01189*/
/**/
                ENDDO
/**/
             ENDDO
/**/
             ELSE       CMD(DO)
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
ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
