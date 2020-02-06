/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL A/cs maint and Stmt/Int Cap ctl')            */
/********************************************************************/
/*                                                                  */
/*       Midas     General Ledger Module                        */
/*                                                                  */
/*       GLC2073 - CONTROL ACCOUNTS MAINTENANCE AND                 */
/*                 INTEREST/CAPITALISATION REQUEST INPUTS           */
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
/*       Prev Amend No. S01408             Date 30Oct95              */
/*                      S01413             Date 13Apr93              */
/*                      S01383                  27APR92             */
/*                      LN0756                  14SEP90             */
/*                      LN0575                  31JUL90             */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       S01408 - ADDITION OF CORE HOOK GLC2073001                  */
/*                ADDITION OF CORE HOOK GLC2073END                  */
/*       S01413 - Retail 3 Incorporation.                           */
/*       S01383 - Basic Rate Tax Incorporation                      */
/*       LN0756 - Program should set U5 ON if either                */
/*                MICROFICHE or Optical Disk are ON                 */
/*       LN0575 - Program recreated because of level check          */
/*                on SDMMODPD                                       */
/*                                                                  */
/********************************************************************/
 
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PGM &MODE &MODULE)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&PGM) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MODULE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SRTCD) TYPE(*CHAR) LEN(7)                /*S01383*/
             DCL        VAR(&SOPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                            /*S01383*/
             DCL        VAR(&SSARD) TYPE(*CHAR) LEN(6) +
                          VALUE('S01383')                             /*S01383*/
             DCLF       FILE(SDMMODPD)
 
/* Set off all switches */
 
             CHGJOB     SWS(00000000)
 
/**Set*up*LDA*for*GLINPUT*and*GL0271**/                               /*S01413*/
/* Set up LDA for GLINPUT and GL0290 */                               /*S01413*/
 
/************IF         COND(&PGM *EQ 'GL0271') THEN(CHGDTAARA +
                          DTAARA(LDA (1 6)) VALUE('GL0271')) */       /*S01413*/
             IF         COND(&PGM *EQ 'GL0290') THEN(CHGDTAARA +
                          DTAARA(LDA (1 6)) VALUE('GL0290'))
             IF         COND(&MODULE *EQ 'R') THEN(CHGDTAARA +
                          DTAARA(LDA (8 1)) VALUE('R'))
             IF         COND(&MODULE *EQ 'G') THEN(CHGDTAARA +
                          DTAARA(LDA (8 1)) VALUE('G'))
             IF         COND(&MODULE *EQ 'B') THEN(CHGDTAARA +
                          DTAARA(LDA (8 1)) VALUE('B'))
             CHGDTAARA  DTAARA(LDA (132 1)) VALUE(&MODE)
 
/*/COPY WNCPYSRC,GLC2073001                                        */ /*S01408*/
 
/**If*Microfiche*present*set*on*U5**/                                 /*LN0756*/
/* If Microfiche or Optical Disk present set on U5 */                 /*LN0756*/
 
             RCVF
             MONMSG     MSGID(CPF0864)
/*********   IF         COND(&BGMFIC *EQ 'Y') THEN(DO)                /*LN0756*/
             IF         COND((&BGMFIC *EQ 'Y') +
                        *OR (&BGOPDK *EQ 'Y')) THEN(DO)               /*LN0756*/
                   CHGJOB     SWS(XXXX1XXX)
             ENDDO
/************IF         COND(&BGRTBN *EQ 'Y') THEN(DO) */             /*S01413*/
             IF         COND(&BGNXST *EQ 'Y') THEN(DO)                /*S01413*/
                   CHGJOB     SWS(X1XXXXXX)
             ENDDO
/**/                                                                  /*S01383*/
/* DETERMINE IF BRT SAR INSTALLED */                                  /*S01383*/
/**/                                                                  /*S01383*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD)      /*S01383*/
/**/                                                                  /*S01383*/
/* BRT SAR INSTALLED */                                               /*S01383*/
/**/                                                                  /*S01383*/
             IF         COND(&SRTCD *EQ '       ') THEN(DO)           /*S01383*/
                CHGJOB SWS(XX1XXXXX)                                  /*S01383*/
             ENDDO                                                    /*S01383*/
/**/                                                                  /*S01383*/
/* CLOSE SCSARDPD FILE            */                                  /*S01383*/
/**/                                                                  /*S01383*/
             CHGVAR     VAR(&SOPTN) VALUE('*FREE')                    /*S01383*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD)      /*S01383*/
 
/**Open*files*for*GL0271/GL0290*and*their*called*programs */          /*S01413*/
/* Open files for GL3271/GL0290 and their called programs */          /*S01413*/
 
/************CALL       PGM(GLOPEN1) PARM(GLOPEN2) */                 /*S01413*/
             OVRDBF     FILE(MEMO) TOFILE(MEMOS)                      /*S01413*/
             CALL       PGM(GLOPEN1)                                  /*S01413*/
 
/* Call input */
 
/************CALL       PGM(GLINPUT) */                               /*S01413*/
             IF         COND(&PGM *EQ 'GL0290') THEN(CALL +
                          PGM(GLINPUT))                               /*S01413*/
             IF         COND(&PGM *EQ 'GLC3271') THEN(CALL +
                          PGM(GLC3271))                               /*S01413*/
             RCLRSC
 
             DLTOVR     FILE(MEMO)                                    /*S01413*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,GLC2073END                                        */ /*S01408*/
 
             ENDPGM
