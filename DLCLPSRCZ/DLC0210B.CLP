/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas DL I/C confirmation reprint - all')             */
/********************************************************************/
/*                                                                  */
/*       Midas     DEALING  MODULE                                  */
/*                                                                  */
/*       DLC0210B-INPUT CYCLE CONFIRMATIONS PRINT - REPRINT ALL     */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. 205448             Date 02May02              */
/*                      CCG015             Date 14Nov01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      111547                  DATE  26FEB97       */
/*                      S01408                  DATE  01NOV96       */
/*                      102339                  DATE  23MAY96       */
/*                      S01408                  DATE  13MAY96       */
/*                      095023                  DATE  19APR96       */
/*                      097317                  DATE  18DEC95       */
/*                      083798                  DATE  15FEB95       */
/*                      081938                  DATE  24JAN95       */
/*                      S01522                  DATE  23JAN95       */
/*                      E40890                  DATE  25JUN92       */
/*                      AUS009                  DATE  23JUL92       */
/*                      040362                  DATE  29MAY92       */
/*                      E35140                  DATE  04/02/92      */
/*                      E15504                  DATE  11/11/88      */
/*                      S01179                  DATE  10/09/88      */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       205448 - UDC module must be on for Correspondence Manager  */
/*       CCG015 - Correspondence Manager Phase 1                    */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set  */
/*                to CMTSCOPE(*JOB).                                */
/*       111547  -  You should not overide the printer file.        */
/*       S01408  -  Addition of Core Hook DLC0210B05                */
/*                  Addition of Core Hook DLC0210B04                */
/*       102339  -  Commitment Control error when reprinting ALL    */
/*       S01408  -  Addition of core hook DLC0210B03                */
/*                  Addition of core hook DLC0210B02                */
/*                  Addition of core hook DLC0210B01                */
/*       095023  -  Commitment control started twice                */
/*       097317  -  Add prompt for immediates for UDC               */
/*       083798  -  Add CGUSRMSG for multi-language overrides       */
/*       081938  -  Reclaim resources after CG4000                  */
/*       S01522  -  USER DEFINED CORRESPONDENCE                     */
/*       E40890  -  APPLY RCF CHANGES.                              */
/*       AUS009  -  AUSTRALIAN PRODUCT - USER DEFINED CONFIRMATIONS */
/*       040362  -  REINTRODUCE RELEASE 10 CHANGES WHICH WERE       */
/*                  LOST WHEN THE PROGRAM WAS MADE REDUNDANT        */
/*       E35140  -  PROGRAM RE-DELIVERED TO COLLECTIONS AFTER       */
/*                  INITIALLY BEING 'REDUNDANT'.                    */
/*       E15504  -  SWIFT MESSAGE NEVER PRODUCED IF REPRINT         */
/*                  TAKEN ORIGINAL CONFIRMATION                     */
/*       S01179  -  AS400 CONVERSION                                */
/********************************************************************/
/************PGM                                                        E40890*/
             PGM PARM(&RSEQ &RLEV &RENT)                              /*E40890*/
/*/                                                             */    /*S01408*/
/*/COPY WNCPYSRC,DLC0210B03                                     */    /*S01408*/
/*/                                                             */    /*S01408*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*E40890*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*E40890*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*E40890*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*E40890*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
/************DCLDTAARA  DTAARA(DLSTAT)                                  S01179*/
/************DCLDTAARA  DTAARA(MMOD)                                    S01179*/
             DCL        VAR(&DLSTAT) TYPE(*CHAR) LEN(256)             /*S01179*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)               /*S01179*/
             DCL        VAR(&SWIFT) TYPE(*CHAR) LEN(1) VALUE(N)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*AUS009*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*AUS009*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*AUS009*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*AUS009*/
             DCL        VAR(&W0RTN) TYPE(*CHAR) LEN(7)                /*S01522*/
             DCL        VAR(&W0CMT) TYPE(*CHAR) LEN(3) VALUE('YES')   /*S01522*/
             DCL        VAR(&FMT)  TYPE(*CHAR) LEN(200)               /*S01522*/
             DCL        VAR(&CGUSRMSG) TYPE(*CHAR) LEN(10)            /*083798*/
             DCL        VAR(&ACTION)     TYPE(*CHAR) LEN(8)          /*CCG015*/
/*/COPY WNCPYSRC,DLH00168                                            */
/*    IF PRINT ALREADY ACTIVE - STOP PRINT                   */
/************RCVDTAARA  DTAARA(DLSTAT)                                  S01179*/
             RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)                /*S01179*/
             CHGVAR     VAR(&CGUSRMSG) VALUE('GB'  *CAT 'CGUSRMSG  ') /*083798*/
             OVRMSGF    MSGF(CGUSRMSG) TOMSGF(&CGUSRMSG)              /*083798*/
             IF         COND(%SUBSTRING(&DLSTAT 6 1) *EQ Y) THEN(DO)
                CALL       PGM(DL0105)
             ENDDO
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
             SNDPGMMSG  MSG('Error on access to ICD file SDMMODPD') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ) +
                          MSGTYPE(*INFO)                              /*S01522*/
             GOTO       CMDLBL(ERROR)                                 /*S01522*/
             ENDDO                                                    /*S01522*/
                                                                      /*S01522*/
/* */                                                                 /*S01522*/
/**********  STRCMTCTL LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))        083798 CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
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
/************ENDCMTCTL                                           083798 102339*/
             IF         COND(&W0RTN *NE '       ') THEN(DO)           /*S01522*/
             CHGVAR     VAR(&MSG) VALUE('User Defined Correspondence +
                          Extract failure')                           /*S01522*/
             GOTO       CMDLBL(ERROR)                                 /*S01522*/
             ENDDO                                                    /*S01522*/
/* */                                                                /*CCG015*/
/* If Correspondence manager is switched on, call custom defined     /*CCG015*/
/* extract program                                                   /*CCG015*/
/* */                                                                /*CCG015*/
             CALL       PGM(CGC3604)                                 /*CCG015*/
/* */                                                                /*CCG015*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)             /*CCG015*/
             CHGVAR     VAR(&MSG) VALUE('Correspondence Manager +
                        Custom-Defined Data Extract failed')         /*CCG015*/
             GOTO       CMDLBL(ABNOR)                                /*CCG015*/
             ENDDO                                                   /*CCG015*/
/* */                                                                /*CCG015*/
             ENDDO                                                    /*S01522*/
             ENDCMTCTL                                                /*102339*/
/* */                                                                 /*S01522*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*AUS009*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*AUS009*/
             CHGVAR     VAR(&SAR) VALUE('AUS009')                     /*AUS009*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*AUS009*/
             IF         COND(&RTCD *NE '       ') THEN(DO)            /*AUS009*/
/*/                                                             */    /*S01408*/
/*/COPY WNCPYSRC,DLC0210B04                                     */    /*S01408*/
/*/                                                             */    /*S01408*/
/*********   OVRPRTF    FILE(DL0110P1) PAGESIZE(42 92) OVRFLW(42) AUS009111547*/
/*********   OVRPRTF    FILE(DL0110P2) PAGESIZE(42 92) OVRFLW(42) AUS009111547*/
/*/                                                             */    /*S01408*/
/*/COPY WNCPYSRC,DLC0210B05                                     */    /*S01408*/
/*/                                                             */    /*S01408*/
             ENDDO                                                    /*AUS009*/
/*/COPY WNCPYSRC,DLC0210B06                                          */
/*    REPRINT ALL                                            */
             CHGJOB     SWS(01000000)
/************RCVDTAARA  DTAARA(MMOD)                                    S01179*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)                    /*S01179*/
/************IF         COND(%SUBSTRING(&MMOD 25 1) *EQ Y)              E15504*/
/************CHGVAR     VAR(&SWIFT) VALUE(Y)                            E15504*/
             IF         COND(%SUBSTRING(&MMOD 25 1) *EQ Y) +
                          THEN(CHGVAR VAR(&SWIFT) VALUE(Y))           /*E15504*/
             ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
/************RCVDTAARA  DTAARA(DLSTAT)                                  S01179*/
             RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)                /*S01179*/
             CHGVAR     VAR(%SUBSTRING(&DLSTAT 6 1)) VALUE(Y)
/************SNDDTAARA  DTAARA(DLSTAT)                                  S01179*/
             CHGDTAARA  DTAARA(DLSTAT) VALUE(&DLSTAT)                 /*S01179*/
             DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
             OVRDBF     FILE(TABLE) TOFILE(TABDLI)
             SNDPGMMSG  MSG('Input Cycle Confirmations Reprint') +
                        TOMSGQ(MRUNQ)
/**********  STRCMTCTL LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))        E40890 CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                       /*E40890 CPK009*/
             MONMSG     MSGID(CPF0000)                                /*095023*/
/* POSITION FILE TO THE PARTICULAR BRANCH                            * *E40890*/
             IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) +
             THEN(DO)                                                 /*E40890*/
                 OVRDBF    FILE(DTRIXL1) POSITION(*KEY 1 SDTIXF +
                           &RENT)                                     /*E40890*/
                 OPNDBF    FILE(DTRIXL1) OPTION(*ALL)                 /*E40890*/
                 MONMSG    MSGID(CPF0000) EXEC(DO)                    /*E40890*/
                     DLTOVR     FILE(DTRIXL1)                         /*E40890*/
                 ENDDO                                                /*E40890*/
             ENDDO                                                    /*E40890*/
/************CALL       PGM(DL0110) PARM(&SWIFT)               040362*/
/************CALL       PGM(DL0110) PARM('     ' 'ALL' &SWIFT)   040362 E40890*/
             IF         COND(&RLEV *EQ 'S') THEN(CHGVAR VAR(&RENT) +
                          VALUE('ALL'))                               /*E40890*/
/*/                                                             */    /*S01408*/
/*/COPY WNCPYSRC,DLC0210B01                                     */    /*S01408*/
/*/                                                             */    /*S01408*/
             CALL       PGM(DL0110) PARM(&RSEQ &RENT &SWIFT)          /*E40890*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
                ROLLBACK
                SNDPGMMSG  MSG('Transaction failed. Re-input +
                      necessary. Enter to continue.') TOPGMQ(*EXT)
             ENDDO
/*/                                                             */    /*S01408*/
/*/COPY WNCPYSRC,DLC0210B02                                     */    /*S01408*/
/*/                                                             */    /*S01408*/
/************DLTOVR     FILE(*ALL)                                      E40890*/
             ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
/************RCVDTAARA  DTAARA(DLSTAT)                                  S01179*/
             RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)                /*S01179*/
             CHGVAR     VAR(%SUBSTRING(&DLSTAT 6 1)) VALUE(N)
/************SNDDTAARA  DTAARA(DLSTAT)                                  S01179*/
             CHGDTAARA  DTAARA(DLSTAT) VALUE(&DLSTAT)                 /*S01179*/
             DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
/************IF         COND(&SWIFT *NE Y) THEN(DO)           E15504    E40890*/
/* REDUNDANT  PROCESSING                                                E40890*/
/*****RETURN TO ORIGINAL MODE IN CASE PRINT WAS STOPPED********         E40890*/
/************IF         COND(%SWITCH(XXXX0000)) THEN(DO)                E40890*/
/************   CHGJOB     SWS(10000000)                                E40890*/
/************   ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))                E40890*/
/************   RCVDTAARA  DTAARA(DLSTAT)                               S01179*/
/************   RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)     S01179    E40890*/
/************   IF         COND(%SUBSTRING(&DLSTAT 6 1) *EQ N) THEN(DO) E40890*/
/************      CHGVAR     VAR(%SUBSTRING(&DLSTAT 6 1)) VALUE(Y)     E40890*/
/************      SNDDTAARA  DTAARA(DLSTAT)                            S01179*/
/************      CHGDTAARA  DTAARA(DLSTAT) VALUE(&DLSTAT)   S01179    E40890*/
/************      DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))             E40890*/
/************      OVRDBF     FILE(TABLE) TOFILE(TABDLI)                E40890*/
/************CALL       PGM(DL0110) PARM(&SWIFT)               040362*/
/************CALL       PGM(DL0110) PARM('     ' 'ALL' &SWIFT) 040362   E40890*/
/************MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)         E40890*/
/************   ROLLBACK                                                E40890*/
/************   SNDPGMMSG  MSG('Transaction failed. Re-input +          E40890*/
/************         necessary. Enter to continue.') TOPGMQ(*EXT)      E40890*/
/************ENDDO                                                      E40890*/
/************      DLTOVR     FILE(*ALL)                                E40890*/
/************      ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))             E40890*/
/************      RCVDTAARA  DTAARA(DLSTAT)                            S01179*/
/************      RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)   S01179   E40890*/
/************      CHGVAR     VAR(%SUBSTRING(&DLSTAT 6 1)) VALUE(N)     E40890*/
/************      SNDDTAARA  DTAARA(DLSTAT)                            S01179*/
/************      CHGDTAARA  DTAARA(DLSTAT) VALUE(&DLSTAT)    S01179   E40890*/
/************   ENDDO                                                   E40890*/
/************   DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))                E40890*/
/************ENDDO                                                      E40890*/
/*     ERROR MESSAGES                                         */
/************IF         COND(*NOT %SWITCH(XXXX0000)) THEN(DO)                          */ /*CCG015*/
ABNOR:                                                                                    /*CCG015*/
             IF         COND(*NOT %SWITCH(XXXX0000)) THEN(DO)                             /*CCG015*/
                IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                   CHGVAR     VAR(&MSG) VALUE('JOB TERMINATED - +
                                               DATABASE IN ERROR')
 
/* UDC module must be on in order to call a Correspondence Manager program                /*205448*/
                   IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)                     /*205448*/
/* If Correspondence manager is switched on, delete overrides. */                         /*CCG015*/
                      CHGVAR     VAR(&ACTION) VALUE('*CLEAR  ')                           /*CCG015*/
                      CALL       PGM(CGC3605) PARM(&ACTION)                               /*CCG015*/
                   ENDDO                                                                  /*205448*/
 
                   ROLLBACK
                ENDDO
                SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
/************ENDDO                                             E15504   E40890*/
             ENDCMTCTL                                                /*E40890*/
                                                                      /*097317*/
/* Prompt for immediate print */                                      /*097317*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)       /*097317*/
                CALL       PGM(CGC5217) PARM(' ')                     /*097317*/
                MONMSG     MSGID(CPF0000)                             /*097317*/
             ENDDO                                                    /*097317*/
                                                                      /*097317*/
ERROR:                                                                /*S01522*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
