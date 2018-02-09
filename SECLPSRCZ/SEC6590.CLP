/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Customer charge groups maintenance')         */
/*********************************************************************/
/*                                                                   */
/*  Midas - Securities Trading Module                            */
/*                                                                   */
/*  SEC6590 - Customer Charge Groups Maintenance                     */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01496             Date 24Oct94              */
/*                      S10984             Date 22Jan93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*  S01496 - Incorporation of JYSKE Enhancements (S10984)            */
/*  S10984 - JYSZRH: CUSTOMER GROUP FOR CHARGES                      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PARM)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) +
                           VALUE('       ')                           /*S01496*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                           VALUE('*FIRST ')                           /*S01496*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(800)                /*S01496*/
             DCL       VAR(&PARM) TYPE(*CHAR) LEN(8)
             DCL       VAR(&MEM)  TYPE(*CHAR) LEN(52)
/*********** DCLF       FILE(SDSTRDPD)                             */ /*S01496*/
 
             CHGJOB SWS(00000000)
 
/*********** RCVF                                                  */ /*S01496*/
/**/                                                                  /*S01496*/
/*  Check Autocharge Option flag on Securities Trading ICD.           /*S01496*/
/**/                                                                  /*S01496*/
             CALL       PGM(AOSTRDR0) PARM(&RTCD &OPTN &FMT)          /*S01496*/
/**/                                                                  /*S01496*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*S01496*/
 
/*********** IF         COND(&BVCUGR *NE 'Y') THEN(DO)             */ /*S01496*/
             IF         COND(%SST(&FMT 175 1) *NE 'Y') THEN(DO)       /*S01496*/
                    SNDPGMMSG  MSG('Option not allowed, Charge by Customer +
                          Groups not installed') TOPGMQ(*EXT)
                    GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/* PERFORM FILE OVERIDE DEPENDING ON PROGRAM TO BE CALLED           */
             OVRDBF     FILE(SECUGRXX) TOFILE(SECUGRPD) SHARE(*NO)
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
             CALL       PGM(SE6590) PARM(&PARM)
 
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
                ROLLBACK
                SNDPGMMSG MSG('Transaction failed. Re-input +
                      necessary. Enter to continue.') TOPGMQ(*EXT)
                GOTO ENDPGM
             ENDDO
 
/*   FOR DATABASE ERRORS RECOVER DATA FROM LDA                      */
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
/***********    SNDPGMMSG  MSGID(DBM0001) MSGF(CEUSRMSG) MSGDTA(&MEM)   +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)           */ /*S01496*/
                SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) MSGDTA(&MEM)   +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)              /*S01496*/
                CHGVAR VAR(&MEM) VALUE('SEC6590 - JOB TERMINATED, +
                                        DATABASE IN ERROR')
                SNDPGMMSG MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
             ENDDO                                                    /*S01496*/
/**/
ENDPGM:      DLTOVR     *ALL
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
