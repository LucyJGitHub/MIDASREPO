/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Loan Statement Print.')                      */
/*******************************************************************/
/*                                                                 */
/*       Midas     - Dealing Module                            */
/*                                                                 */
/*       DLC9015 - LOAN STATEMENT PRINT.                           */
/*                                                                 */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                 */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*          LAST AMEND : 048524         DATE : 04FEB93             */
/*          PREV AMEND : S01390         DATE : 04AUG92             */
/*                       S01179         DATE : 17/01/89            */
/*                       AUS006         DATE : 18DEC90             */
/*                                                                 */
/*-----------------------------------------------------------------*/
/*                                                                 */
/*       048524 - On investigation it was found that CASK -        */
/*                Customer Alpha Sort Code is an optional          */
/*                field so processing is changed to base on        */
/*                CSNM - Customer Short Name which is mand-        */
/*                atory avoiding errors in Stmt print.             */
/*       S01390 - Release 10 Changes for Australianisation         */
/*       S01179 - AS/400 CONVERSION                                */
/*       AUS006 - AUSTRALIAN PRODUCT - INTEREST HISTORY            */
/*                                                                 */
/*********************************************************************/
 
/*****PGM                                                            * *S01390*/
      PGM        PARM(&RSEQ &RLVL &RENT)                              /*S01390*/
 
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)                * *S01390*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01390*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01390*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)                 /*S01390*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01390*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*S01390*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*S01390*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*S01390*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*S01390*/
/**/                                                                  /*S01390*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*S01390*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*S01390*/
             CHGVAR     VAR(&SAR) VALUE('AUS006')                     /*S01390*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*S01390*/
             IF         COND(&RTCD *NE '       ') THEN(GOTO +
                          CMDLBL(END))                                /*S01390*/
 
             SNDPGMMSG  MSG('DLC9015 - Loan statement print') +
                          TOMSGQ(MRUNQ)
 
             OVRDBF     FILE(STHSTAA) SHARE(*YES)
 
/************OPNQRYF    FILE((STHSTAA)) QRYSLT('CHQI  *EQ "L"') +    * *S01390*/
/************             KEYFLD((BRCD) (CCY) (CASK *ASCEND) +       * *S01390*/
/************             (DLNO) (EDAT) (SQNO)) /* Select records +  * *S01390*/
/************             where position 68 of the file is = to 'L' +* *S01390*/
/************             ie Loan statement records.  The file is +  * *S01390*/
/************             read in the sequence of branch code, +     * *S01390*/
/************             currency, customer alpha sort key, deal +  * *S01390*/
/************             number event date and asequence number. */  /*S01390*/
/***         OPNQRYF    FILE((STHSTAA)) QRYSLT('CHQI  *EQ "L"') +    * *048524*/
/***                      KEYFLD((BRCA) (CCY) (CASK *ASCEND) +       * *048524*/
/***                      (DLNO) (EDAT) (SQNO)) /* Select records +  * *048524*/
/***                      where position 68 of the file is = to 'L' +* *048524*/
/***                      ie Loan statement records.  The file is +  * *048524*/
/***                      read in the sequence of branch code, +     * *048524*/
/***                      currency, customer alpha sort key, deal +  * *048524*/
/***                      number event date and asequence number. */  /*048524*/
                                                             /*S01390* *048524*/
             OPNQRYF    FILE((STHSTAA)) QRYSLT('CHQI  *EQ "L"') +
                          KEYFLD((BRCA) (CCY) (CSNM *ASCEND) +
                          (DLNO) (EDAT) (SQNO)) /* Select records +
                          where position 68 of the file is = to 'L' +
                          ie Loan statement records.  The file is +
                          read in the sequence of branch code, +
                          currency, customer short name, deal +
                          number event date and asequence number. */  /*048524*/
/**/                                                                  /*048524*/
 
/**/                                                                  /*S01390*/
/*           CALL       PGM(DL9015.*LIBL)                               S01179*/
/************CALL       PGM(DL9015)                           *S01179* *S01390*/
                CALL       PGM(DL9015) PARM(&RSEQ &RENT)              /*S01390*/
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CLOF       OPNID(STHSTAA)
             DLTOVR     FILE(STHSTAA)
 
/*   UNSUCCESSFUL COMPLETION - SEND ERROR MESSAGE   */
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
/**********     RTVDTAARA  DTAARA(LDA (129 44)) RTNVAR(&MEM)         * *S01390*/
                RTVDTAARA  DTAARA(LDA (132 50)) RTNVAR(&MEM)          /*S01390*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MRUNQ)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MOPERQ)
             ENDDO
             GOTO END
 
 ABNOR:      SNDPGMMSG  MSG('DL9015 DID NOT COMPLETE') TOMSGQ(MOPERQ +
                          MRUNQ)
 
/***END:         ENDPGM                                              * *S01390*/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01390*/
