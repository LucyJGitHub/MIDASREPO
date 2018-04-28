/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas EM Daily Delivery Risk Enquiry')                */
/********************************************************************/
/*                                                                  */
/*        Midas     - Exposure Management Module                */
/*                                                                  */
/*      EMC0302 DAILY DELIVERY RISK ENQUIRY                         */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CGL029             Date 01Sep03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. X00000             Date 00XXX00              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                   */
/*       CGL029 - Increase Account Code to 10 digits                 */
/*                                                                  */
/********************************************************************/
             PGM
/**/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CNUM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&BRCA) TYPE(*CHAR) LEN(3)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&CCY) TYPE(*CHAR) LEN(3)
             DCL        VAR(&FX) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CP) TYPE(*CHAR) LEN(1)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01194*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
/**/
             CHGJOB SWS(00000000)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
/**/
/*  CREATE THE DATA-AREA SESDS (IF IT DOESN'T ALREADY EXIST).        */
/**/
             CHKOBJ     OBJ(SESDS) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9800) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/SESDS) TYPE(*CHAR) LEN(37)
             ENDDO
/**/
/*  CLEAR DTAARA/SESDS AND SET ORIGINAL PGM. TO ENQUIRY PGM.         */
/*                     AND SET ZONED FIELDS                          */
/**/
             CHGDTAARA  DTAARA(SESDS) VALUE(' ')
             CHGDTAARA  DTAARA(SESDS (1 8)) VALUE('EM1500  ')
             CHGDTAARA  DTAARA(SESDS (13 6)) VALUE('000000')
/**/
/*  CREATE THE DATA-AREA EMSDS (IF IT DOESN'T ALREADY EXIST).        */
/**/
             CHKOBJ     OBJ(EMSDS) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9800) EXEC(DO)
/**********  CRTDTAARA  DTAARA(QTEMP/EMSDS) TYPE(*CHAR) LEN(161)     */                   /*CGL029*/
             CRTDTAARA  DTAARA(QTEMP/EMSDS) TYPE(*CHAR) LEN(167)                          /*CGL029*/
             ENDDO
/**/
/*  CLEAR DTAARA/EMSDS AND SET ORIGINAL PGM. TO ENQUIRY PGM.         */
/**/
             CHGDTAARA  DTAARA(EMSDS) VALUE(' ')
             CHGDTAARA  DTAARA(EMSDS (2 9)) VALUE('EM1500  ')
/**/
/*  CREATE THE DATA-AREA DLSDS (IF IT DOESN'T ALREADY EXIST).        */
/**/
             CHKOBJ     OBJ(DLSDS) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9800) EXEC(DO)
/**********  CRTDTAARA  DTAARA(QTEMP/DLSDS) TYPE(*CHAR) LEN(161)     */                   /*CGL029*/
             CRTDTAARA  DTAARA(QTEMP/DLSDS) TYPE(*CHAR) LEN(167)                          /*CGL029*/
             ENDDO
/**/
/*  CLEAR DTAARA/DLSDS AND SET ORIGINAL PGM. TO ENQUIRY PGM.         */
/*                     AND SET ZONED FIELDS                          */
/**/
             CHGDTAARA  DTAARA(DLSDS) VALUE(' ')
             CHGDTAARA  DTAARA(DLSDS (2 9)) VALUE('EM1500  ')
/**/
             CALL       PGM(EM1500) PARM(&RTCD &CNUM &BRCA &DATE +
                          &CCY &FX &MM &LE &CP)
/**/
             RCLRSC
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                        */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
             CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50)) /*S01194*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
