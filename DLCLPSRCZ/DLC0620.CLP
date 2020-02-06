/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Dealing Accrual Detailed Postings Extract')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC0620 - Dealing Accrual Detailed Postings Extract         */
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
 
/*   Clear GEDL files   */
 
             IF         COND(&POST *EQ '1') THEN(DO)
             CLRPFM     FILE(DLACRPPD)
             CLRPFM     FILE(GEDLHH)
             CLRPFM     FILE(GEDLPD)
             CLRPFM     FILE(GEDLZZ)
             ENDDO
 
             IF         COND(&POST *NE '1') THEN(DO)
             CLRPFM     FILE(GEDL2HH)
             CLRPFM     FILE(GEDL2PD)
             CLRPFM     FILE(GEDL2ZZ)
             ENDDO
 
/*  Check if Retail Module is ON  */
 
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
 
             IF         COND((%SUBSTRING(&MMOD 16 1) = 'Y') *OR +
                          (%SUBSTRING(&MMOD 23 1) = 'Y')) THEN(DO)
             CHGJOB     SWS(X1XXXXXX)
             ENDDO
 
/**/
             IF         COND(&POST *EQ '5') THEN(DO)
             OVRDBF     FILE(GEDLHH) TOFILE(GEDL2HH)
             OVRDBF     FILE(GEDLPD) TOFILE(GEDL2PD)
             OVRDBF     FILE(GEDLZZ) TOFILE(GEDL2ZZ)
             ENDDO
 
             CHGJOB     SWS(XX1XXXXX)
 
/* Call DL0295 and report errors if terminated abnormally  */
 
             CALL       PGM(DL0295)
 
             IF         COND((%SWITCH(XXXXXXX1)) *OR +
                          (%SWITCH(XXXXXX1X))) THEN(DO)
             SNDPGMMSG  MSG('JOB TERMINATED - DATABASE IN ERROR') +
                          TOMSGQ(MOPERQ MRUNQ)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             ENDDO
 
/* If DL0295 ended successfully, copy postings files to new extract files */
 
             ELSE       CMD(DO)
 
             IF         COND(&POST *EQ '1') THEN(DO)
             CPYF       FROMFILE(GEDLPD) TOFILE(DLACRPPD) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             ENDDO
 
             IF         COND(&POST *EQ '5') THEN(DO)
             CPYF       FROMFILE(GEDL2PD) TOFILE(DLACRPPD) +
                          MBROPT(*ADD)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             ENDDO
 
             ENDDO
 
/* End program */
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
