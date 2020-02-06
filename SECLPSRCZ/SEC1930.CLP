/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SE Withholding Tax to be recl'd rpt.')          */
/********************************************************************/
/*                                                                  */
/*         Midas       Securities Trading Module                */
/*                                                                  */
/*         SEC1930 - WITHHOLDING TAX TO BE RECLAIMED REPORT         */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01496             Date 06Oct94              */
/*                 S01447                  Date 10NOV93             */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*  CCB020 - COB Restructure - Secondary COB Infrastracture         */
/*  S01496 - Incorporation of JYSKE Enhancements (S10982)           */
/*           Program recompiled due to changes in PF/SESWHTPD       */
/*  S01447 - Program created for SE Withholding Tax enhancement.    */
/*                                                                  */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE &RSEQ &RLEV &RENT)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL       VAR(&MEM)    TYPE(*CHAR)  LEN(50)
             DCL       VAR(&LDA)    TYPE(*CHAR)  LEN(256)
/**********  DCL       VAR(&PHALDA) TYPE(*CHAR)  LEN(1)                                */ /*CCB020*/
             DCL       VAR(&COBST)  TYPE(*CHAR)  LEN(4)                                   /*CCB020*/
             DCL       VAR(&MODE)   TYPE(*CHAR)  LEN(1)
             DCL       VAR(&RSEQ)   TYPE(*CHAR)  LEN(5)
             DCL       VAR(&RLEV)   TYPE(*CHAR)  LEN(1)
             DCL       VAR(&RENT)   TYPE(*CHAR)  LEN(3)
/**/
             MONMSG MSGID(CPF0000 MCH0000 RPG0000) +
                         EXEC(GOTO CMDLBL(ERROR))
/**/
/* CLEAR SWITCHES */
             CHGJOB SWS(00000000)
/**/
             SNDPGMMSG  MSG('SEC1930 - Withholding tax to be +
                          reclaimed report') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/**/
/*  IF NO LDA IS SETUP, THEN CREATE A TEMPORARY ONE                */
/**/
/**********  RTVDTAARA  DTAARA(MPHAS) RTNVAR(&PHALDA)                                  */ /*CCB020*/
             CALL PGM(CBC001001) PARM(&COBST)
/**********  IF         COND(&PHALDA *EQ 'A') THEN(DO)                                 */ /*CCB020*/
             IF         COND(&COBST *EQ '*NO') THEN(DO)                                   /*CCB020*/
               CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(*BLANKS) TEXT('Temporary data area +
                          for SE1930 report pgm')
               MONMSG     MSGID(CPF1023)
             ENDDO
/**/
             OVRDBF   FILE(SEWITRPD) TOFILE(POSETD) SHARE(*YES)
/**/
/*  EXTRACT DIVIDENDS & COUPONS WITH TAX REFUNDABLE NOT = ZERO */
/**/
             OPNQRYF    FILE((POSETD) (SECTYD) (SESWHTPD)) +
                          FORMAT(SEWITRPD SEWITRD0) QRYSLT('TASR +
                          *NE 0 *AND (PEVT *EQ "DV" *OR PEVT *EQ +
                          "CP") *AND S1CTTA *NE " "') KEYFLD((PBCA) +
                          (S1CTTA) (PDUD) (PSSH)) JFLD((POSETD/PSSH +
                          SECTYD/SESN) (POSETD/PSSH +
                          SESWHTPD/S1SESN)) JDFTVAL(*YES)
/**/
/* CALL THE PRINT PROGRAM SE1930 */
/**/
             CALL       PGM(SE1930) PARM(&RSEQ &MODE &RENT)
/**/
             CLOF       OPNID(POSETD)
ERROR:
/**/
/*   FOR DATABASE ERRORS RECOVER DATA FROM LDA                      */
/**/
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
                SNDPGMMSG  MSG('SEC1930 - Withholding tax to be +
                          reclaimed report terminated abnormally') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
 ENDPGM:     DLTOVR     *ALL
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
