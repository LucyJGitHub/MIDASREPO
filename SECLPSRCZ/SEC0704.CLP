/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Expected Coupons Report')                    */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/*       SEC0704 - EXPECTED COUPONS REPORT                          */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. CSE104             Date 08Aug23              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01117             Date 09Jan91              */
/*                      S01179             Date 16/09/88             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       CSE104 - Securities events by Event Date Report            */
/*       MD046248 - Finastra Rebranding                              */
/*         S01117 - MULTIBRANCHING                                  */
/*         S01179 -     RELEASE                                     */
/*                                                                  */
/********************************************************************/

/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM                                                     * *S01117*/
             PGM        PARM(&RSEQ &RLEV &RENT)                       /*S01117*/

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
/* S01179                                                              *S01179*/
/*********   DCLDTAARA  DTAARA(LDA)                          ********  *S01179*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                /*S01179*/

/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)                * *S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
             DCL        VAR(&CSE104) TYPE(*CHAR) LEN(1)                                   /*CSE104*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CSE104*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                                      /*CSE104*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CSE104*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')                          /*CSE104*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                                    /*CSE104*/
                                                                                          /*CSE104*/
/* SEND PGM MESSAGE */

             CHGVAR     VAR(&MEM) VALUE('SEC0704 - Expected +
                          Coupons Report')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ)

/* CLEAR SWITCHES */

             CHGJOB     SWS(00000000)

/**/                                                                                      /*CSE104*/
/** Access SAR file to determine if switchable feature CSE104     */                      /*CSE104*/
/**/                                                                                      /*CSE104*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CSE104*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CSE104*/
             CHGVAR     VAR(&SAR) VALUE('CSE104')                                         /*CSE104*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CSE104*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CSE104) VALUE('Y'))                                        /*CSE104*/
/* CLEAR FILES */

             CLRPFM     FILE(UDPCDD)
             CLRPFM     FILE(UDPCDA)
             CLRPFM     FILE(CDPCDD)
             CLRPFM     FILE(CDPCDA)

/* OVERRIDE FOR OPEN FILE ERROR */

/************OVRDBF     FILE(TABSE) SHARE(*NO)                       * *S01117*/

/* CALL EXTRACT PROGRAM */

                CALL       PGM(SE1520)

/* IF NO ERRORS CALL EXPECTED COUPONS REPORT PROGRAM */

             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/***************CALL       PGM(SE0830)                               * *S01117*/
                CALL       PGM(SE0830) PARM(&RSEQ &RENT)              /*S01117*/
             ENDDO

/* IF NO ERRORS CALL EXPECTED COUPONS SUMMARY PROGRAM */

             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/***************CALL       PGM(SE0835)                               * *S01117*/
                                                                                          /*CSE104*/
             IF         COND(&CSE104 *EQ 'Y') THEN(DO)                                    /*CSE104*/
             OVRDBF     FILE(UCDCD) TOFILE(SEUCDCL0) OVRSCOPE(*JOB)                       /*CSE104*/
             OVRPRTF    FILE(SE0830AU) TOFILE(SE0830A2) OVRSCOPE(*JOB)                    /*CSE104*/
             OVRPRTF    FILE(SE0830P1) TOFILE(SE0830P2) OVRSCOPE(*JOB)                    /*CSE104*/
             CALL       PGM(SE0830) PARM(&RSEQ &RENT)                                     /*CSE104*/
             ENDDO                                                                        /*CSE104*/
                                                                                          /*CSE104*/
                CALL       PGM(SE0835) PARM(&RSEQ &RENT)              /*S01117*/
             ENDDO

/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */

ERROR:       IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/* S01179                                                              *S01179*/
/*********      RCVDTAARA  DTAARA(LDA)                      *********  *S01179*/
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                   /*S01179*/
/***************CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))  * *S01117*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))   /*S01117*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)
                CHGVAR     VAR(&MEM) VALUE('SEC0704 - Database Error')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             ENDDO

/* FILE CONTROLS OUT OF BALANCE */

             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
               CHGVAR    VAR(&MEM) VALUE('SEC0704 - File Controls Out +
                          of Balance')
               SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             ENDDO

/*END:*********ENDPGM                                                * *S01117*/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01117*/
