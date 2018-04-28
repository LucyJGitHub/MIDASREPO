/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE ON LINE ENQUIRIES')                          */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*       LEC03 - ON LINE ENQUIRIES                                  */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CGL029              Date  01Sep03           */
/*       Prev Amend No. CLE034             Date 05May03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01311              Date  27Feb91           */
/*                      S01194              Date  11Dec89           */
/*                      S01179              DATE  15SEP89           */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       CGL029 - Increase Account Codes to 10 digits               */
/*       CLE034 - Lending Enhancements.                             */
/*       S01311 - EXPOSURE MANAGEMENT ENQUIRIES                     */
/*                CLEAR DATA AREA EMSDS                             */
/*       S01194 - NEW STANDING DATA                                 */
/*       S01179 - AS400 INCORPORATION                               */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PARM)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(10)
/*           DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01194*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01194*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
/**********  DCL        VAR(&EMSDS) TYPE(*CHAR) LEN(161) */                        /*S01311 CGL029*/
             DCL        VAR(&EMSDS) TYPE(*CHAR) LEN(167)                                  /*CGL029*/
             DCL        VAR(&RETND) TYPE(*CHAR) LEN(1)               /*S01311*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)        /*CLE034*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                   /*CLE034*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) +
                          VALUE('CLE034')                    /*CLE034*/
/**/                                                         /*CLE034*/
/* Determine if CLE034 installed  */                         /*CLE034*/
/**/                                                         /*CLE034*/
             CALL   PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD)    /*CLE034*/
/**/                                                         /*CLE034*/
/* Error */                                                  /*CLE034*/
/**/                                                         /*CLE034*/
             IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)                /*CLE034*/
             SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') +
                                TOMSGQ(MOPERQ)               /*CLE034*/
             CHGJOB (XXXXXX11)                               /*CLE034*/
             ENDDO                                           /*CLE034*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)   /*CLE034*/
             OVRDBF     FILE(LESTALLX) TOFILE(LESTALL2) +
                        SHARE(*NO)                           /*CLE034*/
             ENDDO                                           /*CLE034*/
/**/
/*           DCLDTAARA  DTAARA(LDA)                                 *  *S01179*/
             CHGJOB     SWS(00000000)
/**/
/************OVRDBF     FILE(TABLE) TOFILE(TABLEIC)                    *S01194*/
                                                                     /*S01311*/
             CHGDTAARA  DTAARA(QTEMP/EMSDS) VALUE(' ')               /*S01311*/
             MONMSG     MSGID(CPF1015)  EXEC(DO)                     /*S01311*/
/**********     CRTDTAARA  DTAARA(QTEMP/EMSDS) TYPE(*CHAR) LEN(161) */             /*S01311 CGL029*/
                CRTDTAARA  DTAARA(QTEMP/EMSDS) TYPE(*CHAR) LEN(167)                       /*CGL029*/
             ENDDO                                                   /*S01311*/
                                                                     /*S01311*/
             CALL       PGM(&PARM)
/************DLTOVR     FILE(TABLE)     ****************               *S01194*/
/**/
/**/
/*                 FOR DATABASE ERRORS RECOVER DATA FROM LDA                  */
/**/                                                                 /*S01311*/
/*   FOR LINKED ENQUIRIES, DETERMINE IF RETURN CODE IS 'E',       */ /*S01311*/
/*   INDICATING DATABASE ERROR HAS OCCURRED                       */ /*S01311*/
/**/                                                                 /*S01311*/
             RTVDTAARA DTAARA(EMSDS) RTNVAR(&EMSDS)                  /*S01311*/
/**********  CHGVAR     VAR(&RETND) VALUE(%SST(&EMSDS 161 1))                      /*S01311 CGL029*/
             CHGVAR     VAR(&RETND) VALUE(%SST(&EMSDS 167 1))                             /*CGL029*/
/**/
/***************IF         COND(%SWITCH(XXXXXX11)) THEN(DO)       */ /*S01311*/
            IF         COND((%SWITCH(XXXXXX11)) *OR (&RETND *EQ 'E')) +
                       THEN(DO)                                      /*S01311*/
                   RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
/*          CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))    */ /*S01194*/
            CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))       /*S01194*/
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                               TOMSGQ(MOPERQ)
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                               TOPGMQ(*EXT)
/**/
                ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
