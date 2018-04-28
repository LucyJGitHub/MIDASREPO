/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Customer Account Balances enq (non-re)')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC06A - Customer Account Balances Enquiry (Non-Retail)     */
/*                Based on GLC06                                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. 239795             Date 16May06              */
/*       Prev Amend No. CGL037  *CREATE    Date 14Jul04              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       239795 - Create data area DLSDS in QTEMP to avoid database */
/*                error when selecting DL transactions from         */
/*                Account Movements screen.                         */
/*       CGL037 - Account Access Security                            */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
             DCL        VAR(&MMOD)   TYPE(*CHAR) LEN(256)
             DCL        VAR(&LDA)    TYPE(*CHAR) LEN(256)
             DCL        VAR(&EMSDS)  TYPE(*CHAR) LEN(167)
             DCL        VAR(&PGN1D)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&RETND)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM)    TYPE(*CHAR) LEN(50)
             DCL        VAR(&SRTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SOPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')
             DCL        VAR(&SSARD) TYPE(*CHAR) LEN(6) +
                          VALUE('CGL037')
             OVRDBF     FILE(ACCNT)  TOFILE(ACCNT)  SHARE(*NO)
             OVRDBF     FILE(SDMMODPD) TOFILE(SDMMODPD) SHARE(*NO)
 
/* If positions 2 to 9 on dtaara/EMSDS are blank, this is the */
/* first enquiry in the stack, so clear dtaara/EMSDS and set  */
/* positions 2 to 9 to 'GLC06A' to indicate that this is      */
/* first enquiry in stack                                     */
 
             RTVDTAARA  DTAARA(EMSDS) RTNVAR(&EMSDS)
             CHGVAR     VAR(&PGN1D) VALUE(%SST(&EMSDS 2 8))
             IF         COND(&PGN1D *EQ '        ') THEN(DO)
                CHGDTAARA  DTAARA(EMSDS) VALUE(' ')
                CHGDTAARA  DTAARA(EMSDS (2 8)) VALUE('GLC06A  ')
             ENDDO
 
             CHGDTAARA  DTAARA(*LDA) VALUE(' ')
/**/                                                                                      /*239795*/
             CHKOBJ     OBJ(QTEMP/DLSDS) OBJTYPE(*DTAARA)                                 /*239795*/
             MONMSG     MSGID(CPF9800) EXEC(DO)                                           /*239795*/
             CRTDTAARA  DTAARA(QTEMP/DLSDS) TYPE(*CHAR) LEN(167)                          /*239795*/
             ENDDO                                                                        /*239795*/
             CHGDTAARA  DTAARA(QTEMP/DLSDS) VALUE(' ')                                    /*239795*/
/**/                                                                                      /*239795*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
             IF         COND((%SUBSTRING(&MMOD 16 1) = Y) *OR +
                          (%SST(&MMOD 23 1) = Y)) THEN(CHGJOB +
                          SWS('1XXXXXXX'))
 
             IF         COND(%SUBSTRING(&MMOD 50 1) = Y) THEN(CHGJOB +
                          SWS('X1XXXXXX'))
             OVRDBF     FILE(MEMO) TOFILE(MEMOS) SHARE(*NO)
 
/* Determine if CGL037 is installed */
 
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD)
 
/* Error */
 
             IF         COND(&SRTCD *NE '       ' *AND &SRTCD *NE +
                          '*NRF   ') THEN(DO)
                SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') +
                             TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
/* CGL037 Installed */
 
             IF         COND(&SRTCD *EQ '       ') THEN(DO)
                CHGJOB     SWS(XXXX1XXX)
             ENDDO
 
             CALL       PGM(GL0061)
             DLTOVR     FILE(MEMO)
 
/* For linked enquiries, if this is first enquiry in stack,  */
/* determine if return code is 'E' indicating database error */
/* has occurred                                              */
 
             RTVDTAARA  DTAARA(EMSDS) RTNVAR(&EMSDS)
             CHGVAR     VAR(&PGN1D) VALUE(%SST(&EMSDS 2 8))
             CHGVAR     VAR(&RETND) VALUE(%SST(&EMSDS 167 1))
 
             IF         COND((&PGN1D *EQ 'GLC06A  ') *AND (&RETND *EQ 'E')) +
                          THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT)
             ENDDO
 
/* Reset all of EMSDS to blank */
 
             CHGDTAARA  DTAARA(EMSDS) VALUE(' ')
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
