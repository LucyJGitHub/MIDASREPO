/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas BoE Extract/Validation - All Modules')          */
/*********************************************************************/
/*                                                                   */
/*   MIDAS - Bank of England                                         */
/*                                                                   */
/*   BYC2000 - Extract/Validation - All Modules                      */
/*                                                                   */
/*   (c) Finastra International Limited 1998                         */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*       Prev Amend No. LLN022A            Date : 24jAN0             */
/*                      LLN016             Date : 15mAY0             */
/*                  LLN012       Date: 23APR99                       */
/*                  LLN009       Date: 15APR98                       */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*   MD046248 - Finastra Rebranding                                  */
/*   LLN022A - BOE Upgrade to MidasPlus                              */
/*   LLN016 - Upgrade BoE to DBAR3.                                  */
/*   LLN012 - Financial Services Authority - Liquidity Report        */
/*            This component will run on-request. If it is requested */
/*            in 'EXTRACT' mode then the extract will only be done if*/
/*            it is not being run automatically already by the CoB.  */
/*            Also call new extract components required for Liquidity*/
/*            Reporting.                                             */
/*   LLN009 - DBA2 Upgrade.                                          */
/*            Make the unpacked file an optional feature.            */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&LMODE &LRSEQ &LRLVL &LRENT)
 
             DCL        VAR(&LRTCD) TYPE(*CHAR) LEN(7)  /* Return code      */
             DCL        VAR(&LMODE) TYPE(*CHAR) LEN(7)  /* Run mode         */
             DCL        VAR(&LRSEQ) TYPE(*CHAR) LEN(5)  /* Report sequence  */
             DCL        VAR(&LRLVL) TYPE(*CHAR) LEN(1)  /* Report level     */
             DCL        VAR(&LRENT) TYPE(*CHAR) LEN(3)  /* Report entity    */
             DCL        VAR(&LEXFL) TYPE(*CHAR) LEN(1)  /* Extract fail?    */
             DCL        VAR(&LMMOD) TYPE(*CHAR) LEN(128)/* Module check     */
             DCL        VAR(&LPHAS) TYPE(*CHAR) LEN(1)      /* Midas Phase  */
             DCL        VAR(&LLN012) TYPE(*CHAR) LEN(1)     /* LLN012 flag */
             DCL        VAR(&LFLAG1) TYPE(*CHAR) LEN(1)     /* Flags */
             DCL        VAR(&LFLAG2) TYPE(*CHAR) LEN(1)     /* Flags */
             DCL        VAR(&LPHAS) TYPE(*CHAR) LEN(1)                                    /*LLN012*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                        Finastra International Limited 2006')
 
 
/*  Global Monitor Message  */
             MONMSG     MSGID(CPF0000 RPG0000 CPD0000) EXEC(GOTO +
                          CMDLBL(ABNORM))
 
/*  Check if switchable feature LLN007 - Bank of England is on  */
             CALL       PGM(AOSARDR0) PARM(&LRTCD '*VERIFY' 'LLN007' +
                          ' ')
             IF         COND(&LRTCD *EQ '*NRF') THEN(DO)
               SNDPGMMSG  MSG('The Bank of England module is not +
                          available') TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(ABNORM)
             ENDDO
             IF         COND((&LRTCD *NE ' ') *AND (&LRTCD *NE '*NRF')) +
                        THEN(DO)
               SNDPGMMSG  MSG('Error occured in BYC2000 on call to +
                          program AOSARDR0') TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(ABNORM)
             ENDDO
 
 
/*  Check if switchable feature LLN012 - BoE Liquidity is on  */                          /*LLN012*/
             CALL       PGM(AOSARDR0) PARM(&LRTCD '*VERIFY' 'LLN012' +
                          ' ')                                                            /*LLN012*/
             IF         COND(&LRTCD *EQ ' ') THEN(CHGVAR +
                          VAR(&LLN012) VALUE('Y'))                                        /*LLN012*/
                                                                                          /*LLN012*/
                                                                                          /*LLN012*/
/* Retrieve midas phase */                                                                /*LLN012*/
             RTVDTAARA  DTAARA(MPHAS (1 1)) RTNVAR(&LPHAS)                                /*LLN012*/
                                                                                          /*LLN012*/
                                                                                          /*LLN012*/
/*  'EXTRACT' requested -  Do not run if already extracted today  */                      /*LLN012*/
             IF         COND(&LPHAS *EQ 'C' *AND &LMODE *EQ +
                          'EXTRACT') THEN(DO)                                             /*LLN012*/
               RTVDTAARA  DTAARA(BYSTAT (54 1)) RTNVAR(&LFLAG1)                           /*LLN012*/
               RTVDTAARA  DTAARA(BYSTAT (55 1)) RTNVAR(&LFLAG2)                           /*LLN012*/
               IF         COND(&LFLAG1 *EQ 'Y'  *OR  &LFLAG2 *EQ 'Y') +
                          THEN(RETURN)
               CHGDTAARA  DTAARA(BYSTAT (56 1)) VALUE('Y')                                /*LLN012*/
             ENDDO                                                                        /*LLN012*/
 
/*  Reset all Extract/Validation error flags  */
             CHGDTAARA  DTAARA(BYSTAT (3 5)) VALUE(' ')
 
 
/*  Clear extract files in extract mode   */
             IF         COND(&LMODE *EQ 'EXTRACT') THEN(DO)
             CALL       PGM(BYC9020)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
              SNDPGMMSG MSG('Error has occurred on call to BYC9020') +
                        TOMSGQ(MRUNQ MOPERQ)
              GOTO      CMDLBL(ABNORM)
             ENDDO
             ENDDO
 
 
/*  Module check  */
             CALL       PGM(AOMMODR0) PARM(&LRTCD '*FIRST' &LMMOD)
             IF         COND(&LRTCD *NE ' ') THEN(GOTO CMDLBL(ABNORM))
 
 
/*  Deals Details Extract/Validation  */
             IF         COND((%SST(&LMMOD 23 1) *EQ 'Y') *OR +
                          (%SST(&LMMOD 48 1) *EQ 'Y')) THEN(DO)
               CALL     PGM(BYC2020) PARM(&LMODE &LRSEQ &LRLVL &LRENT)
               IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                SNDPGMMSG MSG('Error has occurred on call to BYC2020') +
                          TOMSGQ(MRUNQ MOPERQ)
                GOTO      CMDLBL(ABNORM)
               ENDDO
             ENDDO
 
 
/*  Loans Details Extract/Validation  */
             IF         COND(%SST(&LMMOD 28 1) *EQ 'Y') THEN(DO)
               CALL     PGM(BYC2030) PARM(&LMODE &LRSEQ &LRLVL &LRENT)
               IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                SNDPGMMSG MSG('Error has occurred on call to BYC2030') +
                          TOMSGQ(MRUNQ MOPERQ)
                GOTO      CMDLBL(ABNORM)
               ENDDO
             ENDDO
 
 
/*  Securities Trading Details Extract/Validation */
             IF         COND(%SST(&LMMOD 31 1) *EQ 'Y') THEN(DO)
               CALL     PGM(BYC2050) PARM(&LMODE &LRSEQ &LRLVL &LRENT)
               IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                SNDPGMMSG MSG('Error has occurred on call to BYC2050') +
                          TOMSGQ(MRUNQ MOPERQ)
                GOTO      CMDLBL(ABNORM)
               ENDDO
             ENDDO
 
 
/*  Accounts Details Extract/Validation  */
             CALL       PGM(BYC2010) PARM(&LMODE &LRSEQ &LRLVL &LRENT)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
              SNDPGMMSG MSG('Error has occurred on call to BYC2010')   +
                        TOMSGQ(MRUNQ MOPERQ)
              GOTO      CMDLBL(ABNORM)
             ENDDO
 
/*  If Liquidity Reporting is on then call additional extracts  */                        /*LLN012*/
             IF         COND(&LLN012 *EQ 'Y') THEN(DO)                                    /*LLN012*/
                                                                                          /*LLN012*/
/*  FRA/IRS Deals Extract/Validation  */                                                  /*LLN012*/
             IF         COND(%SST(&LMMOD 47 1) *EQ 'Y') THEN(DO)                          /*LLN012*/
               CALL    PGM(BYC2025) PARM(&LMODE &LRSEQ &LRLVL &LRENT)                     /*LLN012*/
               IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                /*LLN012*/
                SNDPGMMSG MSG('Error has occurred on call to BYC2025') +
                          TOMSGQ(MRUNQ MOPERQ)                                            /*LLN012*/
                GOTO      CMDLBL(ABNORM)                                                  /*LLN012*/
               ENDDO                                                                      /*LLN012*/
             ENDDO                                                                        /*LLN012*/
                                                                                          /*LLN012*/
/*  Futures and Options Extract/Validation  */                                            /*LLN012*/
/**********  IF         COND(%SST(&LMMOD 41 1) *EQ 'Y') THEN(DO)                  /*LLN012 LLN022A*/
/**********    CALL    PGM(BYC2045) PARM(&LMODE &LRSEQ &LRLVL &LRENT)             /*LLN012 LLN022A*/
/**********    IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                        /*LLN012 LLN022A*/
/**********     SNDPGMMSG MSG('Error has occurred on call to BYC2045') +
                          TOMSGQ(MRUNQ MOPERQ)                                    /*LLN012 LLN022A*/
/**********     GOTO      CMDLBL(ABNORM)                                          /*LLN012 LLN022A*/
/**********    ENDDO                                                              /*LLN012 LLN022A*/
/**********  ENDDO                                                                /*LLN012 LLN022A*/
                                                                                          /*LLN012*/
/*  Securities Trades Extract/Validation  */                                              /*LLN012*/
             IF         COND(%SST(&LMMOD 31 1) *EQ 'Y') THEN(DO)                          /*LLN012*/
               CALL    PGM(BYC2055) PARM(&LMODE &LRSEQ &LRLVL &LRENT)                     /*LLN012*/
               IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                /*LLN012*/
                SNDPGMMSG MSG('Error has occurred on call to BYC2055') +
                          TOMSGQ(MRUNQ MOPERQ)                                            /*LLN012*/
                GOTO      CMDLBL(ABNORM)                                                  /*LLN012*/
               ENDDO                                                                      /*LLN012*/
             ENDDO                                                                        /*LLN012*/
                                                                                          /*LLN012*/
             ENDDO                                                                        /*LLN012*/
 
/*  EXTRACT mode requested  */
             IF         COND(&LMODE *EQ 'EXTRACT') THEN(DO)
 
/***Net*items*flagged*for*netting***/
/************* CALL       PGM(BYC4050) PARM(&LRSEQ &LRLVL &LRENT)                           LLN016*/
/************* IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                  LLN016*/
/*************  SNDPGMMSG MSG('Error has occurred on call to BYC4050') +                    LLN016*/
/*************            TOMSGQ(MRUNQ MOPERQ)                                              LLN016*/
/*************  GOTO      CMDLBL(ABNORM)                                                    LLN016*/
/************* ENDDO                                                                        LLN016*/
 
/*  Create Abacus Download  Files */
               CALL     PGM(BYC2060)
               IF       COND(%SWITCH(XXXXXX11)) THEN(DO)
                SNDPGMMSG MSG('Error has occurred on call to BYC2060') +
                          TOMSGQ(MRUNQ MOPERQ)
                GOTO      CMDLBL(ABNORM)
               ENDDO
 
/*  Create Consolidated Reports  */
               CALL     PGM(BYC2070) PARM(&LRSEQ &LRLVL 'ALL')
               IF       COND(%SWITCH(XXXXXX11)) THEN(DO)
                SNDPGMMSG MSG('Error has occurred on call to BYC2070') +
                          TOMSGQ(MRUNQ MOPERQ)
                GOTO      CMDLBL(ABNORM)
               ENDDO
                                                                                          /*LLN012*/
                                                                                          /*LLN012*/
/*  Liquidity Reporting is on   */                                                        /*LLN012*/
             IF         COND(&LLN012 *EQ 'Y') THEN(DO)                                    /*LLN012*/
                                                                                          /*LLN012*/
/*  Create Liquidity Reporting Extract File  */                                           /*LLN012*/
               CALL     PGM(BYC2080)                                                      /*LLN012*/
                                                                                          /*LLN012*/
/*  Liquidity Cashflow and Maturity Data Reports  */                                      /*LLN012*/
               CALL     PGM(BYC2090) PARM(&LRSEQ &LRLVL 'ALL')                            /*LLN012*/
                                                                                          /*LLN012*/
             ENDDO                                                                        /*LLN012*/
                                                                                          /*LLN012*/
 
             ENDDO
 
 
/*  Extract/Validation Completed Normally  */
             RTVDTAARA  DTAARA(MPHAS) RTNVAR(&LPHAS)
             IF         COND(&LPHAS *EQ 'A') THEN(DO)
               CHGDTAARA  DTAARA(BYSTAT (2 1)) VALUE('N')
             ENDDO
             ELSE       CMD(DO)
               CHGDTAARA  DTAARA(BYSTAT (1 1)) VALUE('N')
             ENDDO
             CHGDTAARA  DTAARA(BYSTAT (3 5)) VALUE('     ')
                                                                                          /*LLN012*/
/*  Reset "on-request extract flag"  */                                                   /*LLN012*/
             IF         COND(&LMODE *EQ 'EXTRACT') THEN(DO)                               /*LLN012*/
               CHGDTAARA  DTAARA(BYSTAT (56 1)) VALUE('N')                                /*LLN012*/
             ENDDO                                                                        /*LLN012*/
                                                                                          /*LLN012*/
             RCLRSC
             RETURN
 
 
/*  Abnormal termination  */
 ABNORM:     CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 CPD0000 MCH0000)
             CHGDTAARA  DTAARA(BYSTAT (1 2)) VALUE('NN')
             MONMSG     MSGID(CPF0000 CPD0000 MCH0000)
             SNDPGMMSG  MSG('BYC2000 terminated abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
