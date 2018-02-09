/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Lending Accrual Detailed Postings Extract')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC0620 - Lending Accrual Detailed Postings Extract         */
/*                                                                   */
/*       (c) Finastra International Limited 2006                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CGL075  *CREATE    Date 16Jun06              */
/*                      XXXXXX             Date DDMmmYY              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CGL075 - Detailed Accrual Summary                           */
/*                                                                   */
/*********************************************************************/
             PGM PARM(&POST)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2006')
             DCL        VAR(&POST) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
 
/*   Clear GELE files   */
 
             IF         COND(&POST *EQ '1') THEN(DO)
             CLRPFM     FILE(LEACRPPD)
             CLRPFM     FILE(GELEHH)
             CLRPFM     FILE(GELEPD)
             CLRPFM     FILE(GELEZZ)
             ENDDO
 
             IF         COND(&POST *NE '1') THEN(DO)
             CLRPFM     FILE(GELE2HH)
             CLRPFM     FILE(GELE2PD)
             CLRPFM     FILE(GELE2ZZ)
             ENDDO
 
/*  Check if Retail Module is ON  */
 
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
 
             IF         COND((%SUBSTRING(&MMOD 16 1) = 'Y') *OR +
                          (%SUBSTRING(&MMOD 23 1) = 'Y')) THEN(DO)
             CHGJOB     SWS(X1XXXXXX)
             ENDDO
 
/**/
             IF         COND(&POST *EQ '5') THEN(DO)
             OVRDBF     FILE(GELEHH) TOFILE(GELE2HH)
             OVRDBF     FILE(GELEPD) TOFILE(GELE2PD)
             OVRDBF     FILE(GELEZZ) TOFILE(GELE2ZZ)
             ENDDO
 
             CHGJOB     SWS(XX1XXXXX)
 
/* Call LE0470 and report errors if terminated abnormally  */
 
             CALL       PGM(LE0470)
 
             IF         COND((%SWITCH(XXXXXXX1)) *OR +
                          (%SWITCH(XXXXXX1X))) THEN(DO)
             SNDPGMMSG  MSG('JOB TERMINATED - DATABASE IN ERROR') +
                          TOMSGQ(MOPERQ MRUNQ)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             ENDDO
 
/* If LE0470 ended successfully, copy postings files to new extract files */
 
             ELSE       CMD(DO)
 
             IF         COND(&POST *EQ '1') THEN(DO)
             CPYF       FROMFILE(GELEPD) TOFILE(LEACRPPD) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             ENDDO
 
             IF         COND(&POST *EQ '5') THEN(DO)
             CPYF       FROMFILE(GELE2PD) TOFILE(LEACRPPD) +
                          MBROPT(*ADD)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             ENDDO
 
             ENDDO
 
/* End program */
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
