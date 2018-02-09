/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD Leo Single Exchange Rate Input')             */
/********************************************************************/
/*                                                                  */
/*   Midas - STANDING DATA MODULE                               */
/*                                                                  */
/*   SDC0021 - LEO SINGLE EXCHANGE RATE INPUT                       */
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
/*       Prev Amend No. S01473             Date 25Aug94              */
/*                      999999             Date DDMmmYY              */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*  S01473 - Midas Leo Integration.                                 */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
 
/* Declare the variables to check the enhancements file */
     DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
     DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')
     DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) VALUE('S01467')
     DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)
     DCL        VAR(&S01467) TYPE(*CHAR) LEN(1)
     DCL        VAR(&DTAARA) TYPE(*CHAR) LEN(2)
     DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
     DCL        VAR(&DTALIB) TYPE(*CHAR) LEN(10)
     DCL        VAR(&XLIB) TYPE(*CHAR) LEN(10)
     DCL        VAR(&PARM1) TYPE(*CHAR) LEN(10)
     DCL        VAR(&PARM2) TYPE(*CHAR) LEN(10)
     DCL        VAR(&LPHA) TYPE(*CHAR) LEN(1) VALUE(' ')
     DCL        VAR(&RTCDE) TYPE(*CHAR) LEN(7) VALUE('       ')
     DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Access switchable features file to see if feature S01467     */
/* is installed  */
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&S01467) VALUE('Y'))
 
/* If feature S01467 is installed, setup LEO Libraries  */
             IF         COND(&S01467 *EQ 'Y') THEN(DO)
             RTVDTAARA  DTAARA(LOPREF) RTNVAR(&DTAARA)
 
/* If either position is blank, this is an error */
             IF         COND((%SST(&DTAARA 1 1) *EQ ' ') *OR +
                          (%SST(&DTAARA 2 1) *EQ ' ')) THEN(DO)
             CHGJOB     SWS(XXXXXXX1)
             GOTO       CMDLBL(ERROR)
             ENDDO
 
             CHGVAR     VAR(&DMLIB) VALUE(&DTAARA *CAT 'DMLIB')
             CHGVAR     VAR(&DTALIB) VALUE(&DTAARA *CAT 'DTALIB')
             CHGVAR     VAR(&XLIB) VALUE(&DTAARA *CAT 'XLIB')
 
             CHGDTAARA  DTAARA(*LDA (51 10)) VALUE(' ')
 
/* Retrieve Library for program CATUXR   */
             CHGVAR     VAR(&PARM1) VALUE('CATUXR')
             CHGVAR     VAR(&PARM2) VALUE(' ')
             CALL       PGM(SCC1110) PARM(&PARM1 &PARM2)
 
/* Error if Library name not returned   */
             IF         COND(&PARM2 *EQ ' ') THEN(DO)
             CHGJOB     SWS(XXXXXXX1)
             GOTO       CMDLBL(ERROR)
             ENDDO
 
             CHGVAR     VAR(%SUBSTRING(*LDA 51 10)) VALUE(&PARM2)
 
/* Retrieve value of Data Area LPHAS via call to SCC1111 */
             CALL       PGM(SCC1111) PARM(&LPHA ' ' '       ')
 
/* Option not allowed if Leo not in I/C */
             IF         COND(&LPHA *NE 'I') THEN(DO)
             CHGVAR     VAR(&MESSAGE) VALUE('Option invalid. Leo +
                          not in Input Cycle.')
             CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)
             CALL       PGM(SCC0010) PARM('SCC1111' 'ENTER' ' ')
             GOTO       CMDLBL(END)
             ENDDO
 
/* Send message to LSTATUS              */
             CALL       PGM(SCC1111) PARM(' ' 'A' '       ')
 
             OVRDBF     FILE(TBCCY) TOFILE(&DMLIB/TBCCY)
             OVRDBF     FILE(TBSC) TOFILE(&DMLIB/TBSC)
             OVRDBF     FILE(IMAGE80) TOFILE(&DMLIB/IMAGE80)
 
             ENDDO
 
             CHGVAR     VAR(&RTCDE) VALUE('       ')
 
             CALL       PGM(SD0021M) PARM(&RTCDE)
 
/* Error if return code not blank       */
             IF         COND(&RTCDE *NE '       ') THEN(DO)
             CHGJOB     SWS(XXXXXXX1)
             GOTO       CMDLBL(ERROR)
             ENDDO
 
ERROR:
     IF COND(%SWITCH(XXXXXXX1)) THEN(DO)
 
            SNDPGMMSG  MSG('Job terminated, database in error. +
                          Contact Systems Department.') +
                       TOMSGQ(MOPERQ MRUNQ)
 
     ENDDO
 
/* If feature S01467 is installed :     */
             IF         COND(&S01467 *EQ 'Y') THEN(DO)
 
/* Remove message from LSTATUS          */
             CALL       PGM(SCC1111) PARM(' ' 'R' '       ')
 
             DLTOVR     FILE(*ALL)
END:         CHGDTAARA  DTAARA(*LDA (51 10)) VALUE(' ')
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
