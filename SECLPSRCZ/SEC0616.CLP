/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SE Amortization By security Report')            */
/********************************************************************/
/*                                                                   */
/*       Midas     - Securities Trading Module                   */
/*                                                                   */
/*       SEC0616 - AMORTISATION BY SECURITY REPORT                   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CSE105             Date 06Dec10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CSE006             Date 21Jul99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      E47991             Date 01Feb93              */
/*                      S01397             DATE 10SEP92              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSE105 - Portuguese Upgrade - Discount/Premium Amortisation */
/*                on Trade Date                                      */
/*       CSE006 - REPURCHASE AGREEMENTS ENHANCEMENTS                 */
/*       E47991 - PROGRAM SHOULD BE CALLED WITH 3 PARAMETERS         */
/*       S01397 - Rel 10 Incorporation of BNZ SARs A46008 and A46013.*/
/*              - Created for Amortisation by Security report        */
/*                                                                   */
/*********************************************************************/
 
/************PGM PARM(&RSEQ &RENT)                                 */ /*E47991*/
             PGM PARM(&RSEQ &RLEV &RENT)                              /*E47991*/
 
             DCL (&LDA)  TYPE(*CHAR) LEN(256)
             DCL (&RSEQ) TYPE(*CHAR) LEN(5)
             DCL (&RLEV) TYPE(*CHAR) LEN(1)                           /*E47991*/
             DCL (&RENT) TYPE(*CHAR) LEN(3)
             DCL (&MEM)  TYPE(*CHAR) LEN(44)
             DCL (&PARM) TYPE(*CHAR) LEN(8)                          /*CSE006*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/*/COPY WNCPYSRC,SEC0616001                                          */
                                                                                          /*CSE105*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                                      /*CSE105*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CSE105*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CSE105*/
             DCL        VAR(&CSE105) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CSE105*/
                                                                                          /*CSE105*/
/* General error return code */                                                           /*CSE105*/
                                                                                          /*CSE105*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*CSE105*/
                                                                                          /*CSE105*/
/* System value variables */                                                              /*CSE105*/
                                                                                          /*CSE105*/
             DCL        VAR(&SVALK1) TYPE(*CHAR) LEN(20)                                  /*CSE105*/
             DCL        VAR(&SVAL1) TYPE(*CHAR) LEN(200)                                  /*CSE105*/
             DCL        VAR(&SVALK2) TYPE(*CHAR) LEN(20)                                  /*CSE105*/
             DCL        VAR(&SVAL2) TYPE(*CHAR) LEN(200)                                  /*CSE105*/
             DCL        VAR(&SVALK3) TYPE(*CHAR) LEN(20)                                  /*CSE105*/
             DCL        VAR(&SVAL3) TYPE(*CHAR) LEN(200)                                  /*CSE105*/
             DCL        VAR(&SVALK4) TYPE(*CHAR) LEN(20)                                  /*CSE105*/
             DCL        VAR(&SVAL4) TYPE(*CHAR) LEN(200)                                  /*CSE105*/
             DCL        VAR(&SVALK5) TYPE(*CHAR) LEN(20)                                  /*CSE105*/
             DCL        VAR(&SVAL5) TYPE(*CHAR) LEN(200)                                  /*CSE105*/
             DCL        VAR(&SVALK6) TYPE(*CHAR) LEN(20)                                  /*CSE105*/
             DCL        VAR(&SVAL6) TYPE(*CHAR) LEN(200)                                  /*CSE105*/
             DCL        VAR(&SVALK7) TYPE(*CHAR) LEN(20)                                  /*CSE105*/
             DCL        VAR(&SVAL7) TYPE(*CHAR) LEN(200)                                  /*CSE105*/
             DCL        VAR(&SVALK8) TYPE(*CHAR) LEN(20)                                  /*CSE105*/
             DCL        VAR(&SVAL8) TYPE(*CHAR) LEN(200)                                  /*CSE105*/
             DCL        VAR(&SVALK9) TYPE(*CHAR) LEN(20)                                  /*CSE105*/
             DCL        VAR(&SVAL9) TYPE(*CHAR) LEN(200)                                  /*CSE105*/
             DCL        VAR(&SVALK10) TYPE(*CHAR) LEN(20)                                 /*CSE105*/
             DCL        VAR(&SVAL10) TYPE(*CHAR) LEN(200)                                 /*CSE105*/
             DCL        VAR(&SVALK11) TYPE(*CHAR) LEN(20)                                 /*CSE105*/
             DCL        VAR(&SVAL11) TYPE(*CHAR) LEN(200)                                 /*CSE105*/
             DCL        VAR(&SVALK12) TYPE(*CHAR) LEN(20)                                 /*CSE105*/
             DCL        VAR(&SVAL12) TYPE(*CHAR) LEN(200)                                 /*CSE105*/
             DCL        VAR(&SVALK13) TYPE(*CHAR) LEN(20)                                 /*CSE105*/
             DCL        VAR(&SVAL13) TYPE(*CHAR) LEN(200)                                 /*CSE105*/
             DCL        VAR(&SVALK14) TYPE(*CHAR) LEN(20)                                 /*CSE105*/
             DCL        VAR(&SVAL14) TYPE(*CHAR) LEN(200)                                 /*CSE105*/
             DCL        VAR(&SVALK15) TYPE(*CHAR) LEN(20)                                 /*CSE105*/
             DCL        VAR(&SVAL15) TYPE(*CHAR) LEN(200)                                 /*CSE105*/
             DCL        VAR(&SVALK16) TYPE(*CHAR) LEN(20)                                 /*CSE105*/
             DCL        VAR(&SVAL16) TYPE(*CHAR) LEN(200)                                 /*CSE105*/
             DCL        VAR(&SVALK17) TYPE(*CHAR) LEN(20)                                 /*CSE105*/
             DCL        VAR(&SVAL17) TYPE(*CHAR) LEN(200)                                 /*CSE105*/
             DCL        VAR(&SVALK18) TYPE(*CHAR) LEN(20)                                 /*CSE105*/
             DCL        VAR(&SVAL18) TYPE(*CHAR) LEN(200)                                 /*CSE105*/
             DCL        VAR(&SVALK19) TYPE(*CHAR) LEN(20)                                 /*CSE105*/
             DCL        VAR(&SVAL19) TYPE(*CHAR) LEN(200)                                 /*CSE105*/
             DCL        VAR(&SVALK20) TYPE(*CHAR) LEN(20)                                 /*CSE105*/
             DCL        VAR(&SVAL20) TYPE(*CHAR) LEN(200)                                 /*CSE105*/
                                                                                          /*CSE105*/
             DCL        VAR(&SESVAL) TYPE(*CHAR) LEN(1)                                   /*CSE105*/
 
/***  SETUP AND SEND PGM MESSAGE  ***/
 
             CHGVAR (&MEM) VALUE('SEC0616 - Amortisation Report')
 
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
             CHGJOB SWS(00000000)
 
/***  POSITION FILE TO THE PARTICULAR BRANCH  ***/
 
             IF ((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) +
             THEN(DO)
               OVRDBF (BKAMT) POSITION(*KEY 1 BKAMTDF &RENT)
               OPNDBF (BKAMT) OPTION(*ALL)
               MONMSG MSGID(CPF0000) +
                 EXEC(DLTOVR (BKAMT))
               CLOF   (BKAMT)
               MONMSG MSGID(CPF0000)
             ENDDO
 
                OVRDBF     FILE(BKAMTX) TOFILE(BKAMT) SHARE(*NO)      /*CSE006*/
/***  CALL PROGRAM  ***/
 
/*/COPY WNCPYSRC,SEC0616002                                          */
                                                                                          /*CSE105*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CSE105*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CSE105*/
             CHGVAR     VAR(&SAR) VALUE('CSE105')                                         /*CSE105*/
                                                                                          /*CSE105*/
/* Check if CSE105 is installed.                                                          /*CSE105*/
                                                                                          /*CSE105*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CSE105*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*CSE105*/
                CHGVAR     VAR(&CSE105) VALUE('Y')                                        /*CSE105*/
             ENDDO                                                                        /*CSE105*/
                                                                                          /*CSE105*/
/* CSE105 is installed...                                                                 /*CSE105*/
                                                                                          /*CSE105*/
             IF         COND(&CSE105 *EQ 'Y') THEN(DO)                                    /*CSE105*/
                                                                                          /*CSE105*/
/* Get the Trade/Value Date flag...                                                       /*CSE105*/
                                                                                          /*CSE105*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CSE105*/
                                                                                          /*CSE105*/
             CALL       PGM(AOSVALR0) PARM(&RTCD +
                          'DiscPremAmortPostn  ' &SVAL1 &SVALK2 +
                          &SVAL2 &SVALK3 &SVAL3 &SVALK4 &SVAL4 +
                          &SVALK5 &SVAL5 &SVALK6 &SVAL6 &SVALK7 +
                          &SVAL7 &SVALK8 &SVAL8 &SVALK9 &SVAL9 +
                          &SVALK10 &SVAL10)                                               /*CSE105*/
                                                                                          /*CSE105*/
/* If there is an error finding any system value then end abnormally */                   /*CSE105*/
                                                                                          /*CSE105*/
             IF         COND(&RTCD *NE '       ') THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*CSE105*/
                                                                                          /*CSE105*/
             CHGVAR     VAR(&SESVAL) VALUE(%SST(&SVAL1 1 1))                              /*CSE105*/
                                                                                          /*CSE105*/
             IF         COND(&SESVAL *EQ '       ') THEN(CHGVAR +
                          VAR(&SESVAL) VALUE('V'))                                        /*CSE105*/
                                                                                          /*CSE105*/
/* Call the 2 programs accordingly...                                                     /*CSE105*/
                                                                                          /*CSE105*/
             IF         COND(&SESVAL *NE 'T') THEN(DO)                                    /*CSE105*/
                CALL (SE1140) PARM(&RSEQ &RENT)                                           /*CSE105*/
             ENDDO                                                                        /*CSE105*/
                                                                                          /*CSE105*/
             IF         COND(&SESVAL *NE 'V') THEN(DO)                                    /*CSE105*/
                                                                                          /*CSE105*/
/** Position file to the particular branch                                                /*CSE105*/
                                                                                          /*CSE105*/
             IF ((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) THEN(DO)                       /*CSE105*/
                OVRDBF     FILE(BKAMTV0) POSITION(*KEY 1 BKAMTV0F +
                             &RENT)                                                       /*CSE105*/
                OPNDBF (BKAMTV0) OPTION(*ALL)                                             /*CSE105*/
                MONMSG     MSGID(CPF0000) EXEC(DLTOVR FILE(BKAMTV0))                      /*CSE105*/
                CLOF   (BKAMTV0)                                                          /*CSE105*/
                MONMSG MSGID(CPF0000)                                                     /*CSE105*/
             ENDDO                                                                        /*CSE105*/
                                                                                          /*CSE105*/
             CALL (SE9006) PARM(&RSEQ &RENT)                                              /*CSE105*/
             ENDDO                                                                        /*CSE105*/
                                                                                          /*CSE105*/
             ENDDO                                                                        /*CSE105*/
                                                                                          /*CSE105*/
/* CSE105 is NOT installed...                                                             /*CSE105*/
                                                                                          /*CSE105*/
             ELSE       CMD(DO)                                                           /*CSE105*/
                                                                                          /*CSE105*/
             CALL (SE1140) PARM(&RSEQ &RENT)
/*/COPY WNCPYSRC,SEC0616003                                          */
                                                                                          /*CSE105*/
             ENDDO                                                                        /*CSE105*/
                                                                                          /*CSE105*/
 ABNOR:                                                                                   /*CSE105*/
 
/***  ABNORMAL TERMINATION MESSAGE - DATABASE ERROR  ***/
 
             IF (%SWITCH(XXXXXX11)) +
             THEN(DO)
               RTVDTAARA (LDA) RTNVAR(&LDA)
               CHGVAR (&MEM) VALUE(%SST(&LDA 134 50))
               SNDPGMMSG MSGID(MEM0001) MSGF(GBMIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
               SNDPGMMSG MSG('SEC0616 - Database Error') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
