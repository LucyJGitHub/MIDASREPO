/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Journal Entries for Non-Retail Accounts')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*      GLC1400A - Journal Entries for Non-Retail Accounts           */
/*                 Based on GLC1400                                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CGL037  *CREATE    Date 14Jul04              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CGL037 - Account Access Security                            */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&POPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PSARD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&CRE020) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(50)
 
             DCL        VAR(&SRTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SOPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')
             DCL        VAR(&SSARD) TYPE(*CHAR) LEN(6) +
                          VALUE('CGL037')
             CHGJOB     SWS(XXXX0XXX)
 
/* Check if CRE020 is enabled. */
 
             CHGVAR     VAR(&PRTCD) VALUE('       ')
             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&PSARD) VALUE('CRE020')
             CHGVAR     VAR(&CRE020) VALUE('N')
 
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD)
 
             IF         COND(&PRTCD *EQ '       ') THEN(DO)
                CHGVAR     VAR(&CRE020) VALUE('Y')
             ENDDO
 
             IF         COND(&PRTCD *NE '*NRF   ' *AND +
                          &PRTCD *NE '       ') THEN(DO)
                DMPCLPGM
                GOTO       CMDLBL(END)
             ENDDO
 
             OVRDBF     FILE(GLJENHL0) SHARE(*NO)
 
/* Set U5 on, so that the user is allowed to access only   */
/* non-retail accounts or retail accounts with a/c subtype */
/* 'V'(vostro) or 'I'(internal) if CGL037 is on            */
 
/* Determine if CGL037 is installed */
 
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD)
 
/* Error */
 
             IF         COND(&SRTCD *NE '       ' *AND &SRTCD *NE +
                          '*NRF   ') THEN(DO)
                SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') +
                             TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
/* CGL037 installed */
 
             IF         COND(&SRTCD *EQ '       ') THEN(DO)
                CHGJOB     SWS(XXXX1XXX)
             ENDDO
 
             CALL       PGM(GL0100D) PARM(' ')
             DLTOVR     FILE(GLJENHL0)
 
/* Print Retail Advices if CRE020 is enabled. */
 
             IF         COND(%SWITCH(XXXXXX00) *AND +
                          &CRE020 *EQ 'Y') THEN(DO)
             CHGVAR     VAR(&PCMD) VALUE('CALL PGM(REC000881) PARM(' +
                          *CAT '''GL0101R'' ''GL''' *CAT ')')
             SBMJOB     JOB(REC000881) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA(&PCMD) +
                          INLLIBL(*JOBD) MSGQ(MOPERQ)
             ENDDO
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM
