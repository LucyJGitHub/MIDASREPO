/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas DL I/C confirmation reprint- request')          */
/********************************************************************/
/*                                                                  */
/*       Midas     DEALING  MODULE                              */
/*                                                                  */
/*       DLC0210C-INPUT CYCLE CONFIRMATIONS REPRINT REQUEST         */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Last Amend No. 205448             Date 02May02              */
/*       Prev Amend No. CCG015             Date 14Nov01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      052813             DATE  29OCT97            */
/*                      111547             DATE  26FEB97            */
/*                      S01408             DATE  01NOV96            */
/*                      S01408             DATE  13MAY96            */
/*                      097317             DATE  18DEC95            */
/*                      083798             DATE  15FEB95            */
/*                      081938             DATE  24JAN95            */
/*                      S01522             DATE  23JAN95            */
/*                      AUS009             DATE  20AUG92            */
/*                      E40890             DATE  25JUN92            */
/*                      E38769             DATE  24APR92            */
/*                      E35143                  DATE  04/02/92      */
/*                      E15504                  DATE  11/11/88      */
/*                      S01179                  DATE  10/09/88      */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       205448 - UDC module must be on for Correspondence Manager  */
/*       CCG015  -  Correspondence Manager Phase 1                  */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       052813  -  If unable to allocate MSDLRPF, wait for 60 secs.*/
/*                  and try again - if still a problem, end pgm and */
/*                  send an error message.                          */
/*               -  Add ABNOR processing to the program.            */
/*               -  Add Global Monitor message so any other         */
/*                  unmonitored errors are handled.                 */
/*               -  Job is submitted; do not send msg to *EXT       */
/*               -  Change DLSTAT posn 6 to 'N' at end of pgm.      */
/*       111547  -  You should not overide the printer file.        */
/*       S01408  -  Addition of Core Hook DLC0210C05                */
/*                  Addition of Core Hook DLC0210C04                */
/*       S01408  -  Addition of core hook DLC0210C03                */
/*                  Addition of core hook DLC0210C02                */
/*                  Addition of core hook DLC0210C01                */
/*       097317  -  Add prompt for immediates for UDC               */
/*       083798  -  Add CGUSRMSG for multi-language overrides       */
/*       081938  -  Reclaim resources after CG4000                  */
/*       S01522 - USER DEFINED CORRESPONDENCE                       */
/*       AUS009  -  AUSTRALIAN PRODUCT - USER DEFINED CONFIRMATIONS */
/*       E40890  -  APPLY RCF CHANGES                               */
/*       E38769  -  WRONG NUMBER OF PARMS                           */
/*       E35143  -  PROGRAM RE-DELIVERED TO COLLECTIONS AFTER       */
/*                  INITIALLY BEING MADE REDUNDANT.                 */
/*       E15504  -  SWIFT MESSAGE NEVER PRODUCED IF REPRINT         */
/*                  TAKEN ORIGINAL CONFIRMATION                     */
/*       S01179  -  AS400 CONVERSION                                */
/*                                                                  */
/********************************************************************/
/************PGM                                                        E40890*/
             PGM PARM(&RSEQ &RLEV &RENT)                              /*E40890*/
/*/                                                             */    /*S01408*/
/*/COPY WNCPYSRC,DLC0210C03                                     */    /*S01408*/
/*/                                                             */    /*S01408*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*E40890*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*E40890*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*E40890*/
/*********** DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)                  *052813*/
/*********** DCLDTAARA  DTAARA(DLSTAT)                                  S01179*/
/*********** DCLDTAARA  DTAARA(MMOD)                                    S01179*/
             DCL        VAR(&DLSTAT) TYPE(*CHAR) LEN(256)             /*S01179*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)               /*S01179*/
             DCL        VAR(&SWIFT) TYPE(*CHAR) LEN(1) VALUE(N)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*AUS009*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*AUS009*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*AUS009*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*AUS009*/
             DCL        VAR(&W0RTN) TYPE(*CHAR) LEN(7)                /*S01522*/
             DCL        VAR(&W0CMT) TYPE(*CHAR) LEN(3) VALUE('YES')   /*S01522*/
             DCL        VAR(&FMT)  TYPE(*CHAR) LEN(200)               /*S01522*/
             DCL        VAR(&CGUSRMSG) TYPE(*CHAR) LEN(10)            /*083798*/
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(8)              /*CCG015*/
/*/COPY WNCPYSRC,DLH00169                                            */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*052813*/
/*/COPY WNCPYSRC,DLH00170                                            */
                                                                      /*052813*/
/*     SINGLE CONFIRMATION REPRINT REQUEST - SET & RESET BUSY FLAG */
             CHGVAR     VAR(&CGUSRMSG) VALUE('GB'  *CAT 'CGUSRMSG  ') /*083798*/
             OVRMSGF    MSGF(CGUSRMSG) TOMSGF(&CGUSRMSG)              /*083798*/
/********** STRCMTCTL   LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))     /*E40890 CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
            SNDPGMMSG   MSG('I/C Confirmations Reprint Request') +
                        TOMSGQ(MRUNQ)
             ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
/*********** RCVDTAARA  DTAARA(DLSTAT)                             */ /*S01179*/
             RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)                /*S01179*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)                    /*E15504*/
/**/
             IF         COND(%SUBSTRING(&MMOD 25 1) *EQ Y) THEN(DO)   /*E15504*/
             CHGVAR     VAR(&SWIFT) VALUE(Y)                          /*E15504*/
             CHGJOB     SWS(00001000)                                 /*E15504*/
             ENDDO                                                    /*E15504*/
             ELSE       CMD(CHGJOB SWS(10000000))                     /*E15504*/
/**/
             IF         COND(%SUBSTRING(&DLSTAT 6 1) *EQ N) THEN(DO)
                CHGVAR     VAR(%SUBSTRING(&DLSTAT 6 1)) VALUE(Y)
/***********    SNDDTAARA  DTAARA(DLSTAT)                               S01179*/
                CHGDTAARA  DTAARA(DLSTAT) VALUE(&DLSTAT)              /*S01179*/
                DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
/***********    CLRPFM     FILE(MSDLRPF)                       E15504   E40890*/
/***********    OVRDBF     FILE(TABLE) TOFILE(TABDLI)                   E40890*/
/***********    CALL       PGM(DL0115)                                  E40890*/
/*********** MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)         E40890*/
/***********    ROLLBACK                                                E40890*/
/***********    SNDPGMMSG  MSG('Transaction failed. Re-input +          E40890*/
/***********          necessary. Enter to continue.') TOPGMQ(*EXT)      E40890*/
/*********** ENDDO                                                      E40890*/
/***********    DLTOVR     FILE(*ALL)                                   E40890*/
                ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
/***********    RCVDTAARA  DTAARA(DLSTAT)                               S01179*/
                RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)             /*S01179*/
                CHGVAR     VAR(%SUBSTRING(&DLSTAT 6 1)) VALUE(N)
/***********    SNDDTAARA  DTAARA(DLSTAT)                               S01179*/
                CHGDTAARA  DTAARA(DLSTAT) VALUE(&DLSTAT)              /*S01179*/
             ENDDO
/**/
             DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
/**/
/*********** IF         COND(*NOT %SWITCH(XXX00000)) THEN(DO)           E15504*/
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)         /*E15504*/
                IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
/******************CHGVAR     VAR(&MSG) VALUE('JOB TERMINATED - +      *052813*/
/******************                            DATABASE IN ERROR')     *052813*/
                   ROLLBACK
                   SNDPGMMSG  MSG('DLC0210C - JOB TERMINATED; DATABASE  IN +
                                ERROR') TOMSGQ(MOPERQ MRUNQ) +
                                MSGTYPE(*INFO)                        /*052813*/
                   GOTO       CMDLBL(ABNOR)                           /*052813*/
                ENDDO
/***************SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ)       *052813*/
             ENDDO
/**/
/*    PRINT CONFIRMATIONS - SET & RESET BUSY FLAG                   */
/*********** IF         COND(%SWITCH(XXXXX000)) THEN(DO)                E15504*/
/***********    CHGJOB     SWS(10000000)                                E15504*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)              /*E15504*/
                ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
/***********    RCVDTAARA  DTAARA(DLSTAT)                               S01179*/
                RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)             /*S01179*/
                SNDPGMMSG  MSG('Print Confirmations') TOMSGQ(MRUNQ)
/**/
                IF         COND(%SUBSTRING(&DLSTAT 6 1) *EQ N) THEN(DO)
                   CHGVAR     VAR(%SUBSTRING(&DLSTAT 6 1)) VALUE(Y)
/************      SNDDTAARA  DTAARA(DLSTAT)                            S01179*/
                   CHGDTAARA  DTAARA(DLSTAT) VALUE(&DLSTAT)           /*S01179*/
                   DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*AUS009*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*AUS009*/
             CHGVAR     VAR(&SAR) VALUE('AUS009')                     /*AUS009*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*AUS009*/
             IF         COND(&RTCD *NE '       ') THEN(DO)            /*AUS009*/
/*/                                                             */    /*S01408*/
/*/COPY WNCPYSRC,DLC0210C04                                     */    /*S01408*/
/*/                                                             */    /*S01408*/
/*********   OVRPRTF    FILE(DL0110P1) PAGESIZE(42 92) OVRFLW(42) AUS009111547*/
/*********   OVRPRTF    FILE(DL0110P2) PAGESIZE(42 92) OVRFLW(42) AUS009111547*/
/*/                                                             */    /*S01408*/
/*/COPY WNCPYSRC,DLC0210C05                                     */    /*S01408*/
/*/                                                             */    /*S01408*/
             ENDDO                                                    /*AUS009*/
/*/COPY WNCPYSRC,DLC0210C06                                          */
/************      OVRDBF     FILE(TABLE) TOFILE(TABDLI)                E40890*/
/************      RCVDTAARA  DTAARA(MMOD)                              S01179*/
/******************RTVDTAARA**DTAARA(MMOD)*RTNVAR(&MMOD)*/ /*S01179*/ /*E15504*/
/************      IF         COND(%SUBSTRING(&MMOD 25 1) *EQ Y)   */ /*E15504*/
/************         CHGVAR     VAR(&SWIFT) VALUE(Y)              */ /*E15504*/
/************CALL       PGM(DL0110) PARM(&SWIFT)                   */ /*E38769*/
/**  CALL CONFS PRINT PROGRAM WITH CORRECT PARAMETERS              */ /*E38769*/
/************CALL       PGM(DL0110) PARM('     ' 'ALL' &SWIFT) E38769   E40890*/
/* */                                                                 /*S01522*/
/* User Defined Correspondence processing  */                         /*S01522*/
/* */                                                                 /*S01522*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*S01522*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                   /*S01522*/
/* */                                                                 /*S01522*/
/** Access PF/SDMMODPD to determine whether UDC module is on          /*S01522*/
/* */                                                                 /*S01522*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)          /*S01522*/
/* */                                                                 /*S01522*/
/** Database error handling                                           /*S01522*/
/* */                                                                 /*S01522*/
             IF         COND(&RTCD *NE '       ') THEN(DO)            /*S01522*/
/************SNDPGMMSG  MSG('Error on access to ICD file SDMMODPD') +
/************             TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ) +
/************             MSGTYPE(*INFO)                       /*S01522 052813*/
             SNDPGMMSG  MSG('DLC0210C - Error on access to ICD file +
                          SDMMODPD') TOMSGQ(MOPERQ MRUNQ) +
                          MSGTYPE(*INFO)                              /*052813*/
             GOTO       CMDLBL(ABNOR)                                 /*052813*/
             ENDDO                                                    /*S01522*/
                                                                      /*S01522*/
/* */                                                                 /*S01522*/
             OVRDBF     FILE(DEALS) SHARE(*NO)                        /*081938*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)       /*S01522*/
/* */                                                                /*CCG015*/
/* If Correspondence manager is switched on, override files          /*CCG015*/
             CHGVAR     VAR(&ACTION) VALUE('*PREPARE')               /*CCG015*/
             CALL       PGM(CGC3605) PARM(&ACTION)                   /*CCG015*/
/* */                                                                /*CCG015*/
             CALL       PGM(CG4000) PARM(&W0RTN &W0CMT)               /*S01522*/
                                                                      /*S01522*/
             RCLRSC                                                   /*081938*/
             IF         COND(&W0RTN *NE '       ') THEN(DO)           /*S01522*/
/************CHGVAR     VAR(&MSG) VALUE('User Defined Correspondence +
/************             Extract failure')                    /*S01522 052813*/
             SNDPGMMSG  MSG('DLC0210C - User Defined Correspondence +
                          Extract failure') TOMSGQ(MOPERQ MRUNQ) +
                          MSGTYPE(*INFO)                              /*052813*/
             GOTO       CMDLBL(ABNOR)                                 /*052813*/
             ENDDO                                                    /*S01522*/
 
/* If Correspondence manager is switched on, call custom defined */                       /*CCG015*/
/* extract program                                                                        /*CCG015*/
             CALL       PGM(CGC3604)                                                      /*CCG015*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                  /*CCG015*/
                SNDPGMMSG  MSG('Correspondence Manager Custom-Defined +
                             +    IN Data Extract failed.') +
                             TOMSGQ(MOPERQ MRUNQ) MSGTYPE(*INFO)                          /*CCG015*/
                GOTO       CMDLBL(ABNOR)                                                  /*CCG015*/
             ENDDO                                                                        /*CCG015*/
 
             ENDDO                                                    /*S01522*/
/*/                                                             */    /*S01408*/
/*/COPY WNCPYSRC,DLC0210C01                                     */    /*S01408*/
/*/                                                             */    /*S01408*/
             CALL       PGM(DL0110) PARM(&RSEQ 'ALL' &SWIFT)          /*E40890*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
                ROLLBACK
/***************SNDPGMMSG  MSG('Rollback Initiated') TOPGMQ(*EXT)      *052813*/
                SNDPGMMSG  MSG('DLC0210C - I/C Confirmations print +
                             failed, ROLLBACK initiated') +
                             TOMSGQ(MOPERQ MRUNQ) MSGTYPE(*INFO)      /*052813*/
                GOTO       CMDLBL(ABNOR)                              /*052813*/
             ENDDO
/*/                                                             */    /*S01408*/
/*/COPY WNCPYSRC,DLC0210C02                                     */    /*S01408*/
/*/                                                             */    /*S01408*/
                CLRPFM     FILE(MSDLRPF)                              /*E40890*/
                MONMSG     MSGID(CPF0000) EXEC(DO)                    /*052813*/
                   ALCOBJ     OBJ((MSDLRPF *FILE *EXCL)) WAIT(60)     /*052813*/
                   MONMSG     MSGID(CPF0000) EXEC(DO)                 /*052813*/
                   SNDPGMMSG  MSG('DLC0210C - Single Confirmation Reprint +
                                unable to allocate file MSDLRPF.') +
                                TOMSGQ(MOPERQ MRUNQ)                  /*052813*/
                   GOTO       CMDLBL(ABNOR)                           /*052813*/
                   ENDDO                                              /*052813*/
                   CLRPFM     FILE(MSDLRPF)                           /*052813*/
                   DLCOBJ     OBJ((MSDLRPF *FILE *EXCL))              /*052813*/
                ENDDO                                                 /*052813*/
/************      DLTOVR     FILE(*ALL)                                E40890*/
                   ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
/***********       RCVDTAARA  DTAARA(DLSTAT)                            S01179*/
                   RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)          /*S01179*/
                   CHGVAR     VAR(%SUBSTRING(&DLSTAT 6 1)) VALUE(N)
/***********       SNDDTAARA  DTAARA(DLSTAT)                            S01179*/
                   CHGDTAARA  DTAARA(DLSTAT) VALUE(&DLSTAT)           /*S01179*/
                ENDDO
/**/
                DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
/*    ERROR MESSAGES                                           */
/***********    IF         COND(*NOT %SWITCH(XXXX0000)) THEN(DO)        E15504*/
                IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)      /*E15504*/
                   IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
/*********************CHGVAR     VAR(&MSG) VALUE('JOB TERMINATED - +   *052813*/
/*********************                            DATABASE IN ERROR')  *052813*/
                      ROLLBACK
                      SNDPGMMSG  MSG('DLC0210C - JOB TERMINATED; DATABASE IN +
                                   ERROR') TOMSGQ(MOPERQ MRUNQ) +
                                   MSGTYPE(*INFO)                     /*052813*/
                      GOTO       CMDLBL(ABNOR)                        /*052813*/
                   ENDDO
/******************SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ)                 *052813*/
                ENDDO
             ENDDO
             ENDCMTCTL                                                /*E40890*/
                                                                      /*097317*/
/* Prompt for immediate print */                                      /*097317*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)       /*097317*/
                CALL       PGM(CGC5217) PARM(' ')                     /*097317*/
                MONMSG     MSGID(CPF0000)                             /*097317*/
             ENDDO                                                    /*097317*/
/**/
             GOTO       CMDLBL(ENDPGM)                                /*052813*/
ABNOR:                                                                /*052813*/
             SNDPGMMSG  MSG('DLC0210C - Single Confirmation Reprint +
                          TERMINATED ABNORMALLY') TOMSGQ(MOPERQ +
                          MRUNQ)                                      /*052813*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*052813*/
             DMPCLPGM                                                 /*052813*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*052813*/
/* UDC module must be on in order to call a Correspondence Manager program                /*205448*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)                           /*205448*/
                CHGVAR     VAR(&ACTION) VALUE('*CLEAR  ')                                 /*CCG015*/
                CALL       PGM(CGC3605) PARM(&ACTION)                                     /*CCG015*/
             ENDDO                                                                        /*205448*/
 
             ROLLBACK                                                 /*052813*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*052813*/
             ENDCMTCTL                                                /*052813*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*052813*/
             CHGJOB     SWS(XXXXXX11)                                 /*052813*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*052813*/
                                                                      /*052813*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             CHGDTAARA  DTAARA(DLSTAT (6 1)) VALUE(N)                 /*052813*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*052813*/
             ENDPGM                                                   /*E38769*/
/*DPGM:******ENDPGM                                                */ /*E38769*/
