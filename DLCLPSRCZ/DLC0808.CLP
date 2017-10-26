/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Deal input gaps report')                     */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC0808 - DEAL NUMBER INPUT GAPS                           */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*       Last Amend No. CDL098             Date 06Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.02 --------------------------------------------*/
/*       Prev Amend No. 169253             Date 21Feb02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      E266               Date 14Mar90              */
/*                      E243              Date  23Feb90             */
/*                      S01117            DATE  17/07/89            */
/*                      S01179            DATE  12/09/88            */
/*                                                                  */
/********************************************************************/
/*       CDL098 - Cancelled Deal Numbers                             */
/*       169253 - Call DL0850 before calling DL0851. New PF is       */
/*                created and used for DL0850.                       */
/*       E266    -  PROG SHOULD RECEIVE SEQ, LEVEL, ENTITY PARMS    */
/*                  AND CALL DL0851 WITH SEQ. NO.                   */
/*       E243    -  REMOVE EXTRA UNWANTED PARAMETERS                */
/*       S01117  -  RELEASE 10 RCF PROCESSING                       */
/*       S01179  -  AS400 CONVERSION                                */
/********************************************************************/
/************PGM                                                      /*S01117*/
/************PGM                                              /*S01117 *E266*/
             PGM PARM(&RSEQ &RLEV &RENT)                              /*E266*/
 
/* &RLEV, &RENT ARE STANDARD RCF PARAMETERS NOT USED BY THIS PROGRAM  /*S01117*/
/************PGM PARM(&RSEQ &RLEV &RENT)*******                       /*E243*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**DCL*VAR(&RSEQ)*TYPE(*CHAR) LEN(5) /* RCF sequence number * *S01117* /*E243*/
/**DCL*VAR(&RLEV)*TYPE(*CHAR) LEN(1) /* RCF level flag (S/C/B/*S01117* /*E243*/
/**DCL*VAR(&RENT)*TYPE(*CHAR) LEN(3) /* RCF entity code (all/ *S01117* /*E243*/
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number *          /*E266*/
   DCL VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level flag *               /*E266*/
   DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code *              /*E266*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)
/**********  DCLDTAARA  DTAARA(LDA)                                     S01179*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                /*S01179*/
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(2)                                     /*CDL098*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*CDL098*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CDL098*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                                      /*CDL098*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CDL098*/
             DCL        VAR(&CDL098) TYPE(*CHAR) LEN(1)                                   /*CDL098*/
/*/COPY WNCPYSRC,DLC0808001                                          */
/**/
             CHGJOB     SWS(00000000)
/**/
             SNDMSG     MSG('DEAL NUMBERS INPUT GAPS REPORT') +
                        TOMSGQ(MRUNQ)
/**********  OVRDBF     FILE(TABLE)   TOFILE(TABDLEI)                 /*S01194*/
/**********  CALL       PGM(DL0851)                                   /*S01117*/
/**********  CALL       PGM(DL0851) PARM(&RSEQ)             /*S01117* /*E243*/
/************CALL       PGM(DL0851)                          /*S01117* *E266*/
             CLRPFM     FILE(DLNOTRPD) MBR(DLNOTRPD)                  /*169253*/
             CLRPFM     FILE(DLGAPNPD)                                /*169253*/
             CALL       PGM(DL0850)                                   /*169253*/
             CALL       PGM(DL0851) PARM(&RSEQ)                       /*E266*/
             CLRPFM     FILE(DLGAPNPD)                                /*169253*/
/**********  DLTOVR     FILE(TABLE)                                   /*S01194*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CDL098*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CDL098*/
             CHGVAR     VAR(&SAR) VALUE('CDL098')                                         /*CDL098*/
             CHGVAR     VAR(&CDL098) VALUE('N')                                           /*CDL098*/
/**  Check if Enhancement is installed */                                                 /*CDL098*/
                                                                                          /*CDL098*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CDL098*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                         VAR(&CDL098) VALUE('Y'))                                         /*CDL098*/
/**/                                                                                      /*CDL098*/
             IF         COND(&CDL098 *EQ 'Y') THEN(DO)                                    /*CDL098*/
/**/                                                                                      /*CDL098*/
/* DEAL CANCELLATION LIST                                                                 /*CDL098*/
             CALL       PGM(DLC000112) PARM(&TYPE &RSEQ &RLEV &RENT)                      /*CDL098*/
/**/                                                                                      /*CDL098*/
             ENDDO       /*CDL098*/
/**/
/*/COPY WNCPYSRC,DLC0808002                                          */
             IF         COND(%SWITCH(XXXXXX00)) THEN(RETURN)
             ELSE       CMD(DO)
/**/
/*                 FOR DATABASE ERRORS RECOVER DATA FROM LDA       */
/**/
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*************  RCVDTAARA  DTAARA(LDA)                                  S01179*/
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                   /*S01179*/
/*************  CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 44))         /*S01117*/
                CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))         /*S01117*/
/*************  SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +  /*S01117*/
                SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                               TOMSGQ(MOPERQ MRUNQ)
                ENDDO
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
