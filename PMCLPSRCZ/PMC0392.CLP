/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM FF transaction daily extract')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                         */
/*                                                                   */
/*       PMC0392 - FF DAILY TRANSACTION EXTRACT                      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. 183309             Date 13Sep01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPM003             Date 25Jan96              */
/*                      064845             Date  24May93             */
/*                      R00300             DATE  28AUG90             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       183309 - Monitor for messages after CLOF and DLTOVR.        */
/*       CPM003 - Portfolio Management Upgrade to R10                */
/*       064845 - MONMSG FILE TRANS2                                 */
/*       R00300 - Message file changes.                              */
/*                                                                   */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&PMSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RUN) TYPE(*CHAR) LEN(5)
/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(52)                 *CPM003*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*CPM003*/
             DCL        VAR(&LDAWK) TYPE(*CHAR) LEN(256)
             DCLF       FILE(SDPORTPD)
             RCVF       RCDFMT(SDPORTD0)
             MONMSG     MSGID(CPF0000)
/* SET OFF SWITCHES                                              */
 
             CHGJOB     SWS(00000000)
/********************************************************************/
/*  GET RUN DATE FROM DTAARA/PMSTAT                                 */
/********************************************************************/
             RTVDTAARA  DTAARA(PMSTAT) RTNVAR(&PMSTAT)
             CHGVAR     VAR(&RUN) VALUE(%SST(&PMSTAT 6 5))
/********************************************************************/
/*  TEST DISPLAY NON-PORTFOLIO IDICATOR IN PM ICD                   */
/********************************************************************/
/*********** IF         COND(&P9DP97 *EQ 'N') THEN(DO)                /*CPM003*/
             IF         COND(&FCDP97 *EQ 'N') THEN(DO)                /*CPM003*/
             OVRDBF     FILE(TRANS2) SHARE(*YES)
             MONMSG     MSGID(CPF0000)
 
             OPNQRYF    FILE((*LIBL/TRANS2)) QRYSLT(' PTFR *NE "9997" +
                          *AND PTFR *NE "    " *AND *MAPFLD/LCD1 *EQ +
                          "' *CAT &RUN *CAT '"') KEYFLD((ISTT) +
                          (CUSC)) MAPFLD((LCDD LCD *ZONED 5) (LCD1 +
                          LCDD *CHAR 5))
             ENDDO
 
 
/*********** IF         COND(&P9DP97 *EQ 'Y') THEN(DO)                /*CPM003*/
             IF         COND(&FCDP97 *EQ 'Y') THEN(DO)                /*CPM003*/
             OVRDBF     FILE(TRANS2) SHARE(*YES)
             MONMSG     MSGID(CPF0000)
 
 
             OPNQRYF    FILE((*LIBL/TRANS2)) QRYSLT(' PTFR *NE "    +
                          " *AND *MAPFLD/LCD1 *EQ "' *CAT &RUN *CAT +
                          '"') KEYFLD((ISTT) (CUSC)) MAPFLD((LCDD +
                          LCD *ZONED 5) (LCD1 LCDD *CHAR 5))
             ENDDO
             CALL       PGM(PM0392)
             CLOF       OPNID(TRANS2)
 /* 064845 */
             MONMSG     MSGID(CPF0000)
 /* 064845*/
             DLTOVR     FILE(TRANS2)
             MONMSG     MSGID(CPF0000)                                /*183309*/
 
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */
 
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDAWK)
/************** CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDAWK 132 52))  *CPM003*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDAWK 134 50)) /*CPM003*/
/*                                                                    /*R00300*/
/************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&MEM) +
**************************TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)          */
/*********** SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) +   *CPM003*/
/***********              TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)            *CPM003*/
             SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*CPM003*/
/*                                                                    /*R00300*/
             CHGVAR     VAR(&MEM) VALUE('PMC0392  - JOB TERMINATED, +
                          DATABASE IN ERROR')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
 
/***ENDPGM:***  ENDPGM                                                 *CPM003*/
 ENDPGM:                                                              /*CPM003*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*CPM003*/
