/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Produce SWIFT statement msgs')                  */
/********************************************************************/
/*                                                                  */
/*        Midas     - MESSAGE MANAGEMENT                            */
/*                                                                  */
/*        MEC105     Produce S.W.I.F.T. Statement Messages          */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO.  E40395           DATE 19MAY92              */
/********************************************************************/
/*       E40395 - TAKE OUT U1 CONDITIONING DONE IN GLC1300          */
/********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
/**/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/************DCL        VAR(&MSSTAT) TYPE(*CHAR) LEN(256)               E40395*/
/************DCL        VAR(&MMOD)   TYPE(*CHAR) LEN(256)               E40395*/
/**/
             SNDPGMMSG  MSG('Produce SWIFT Statement Messages') +
                          TOMSGQ(MRUNQ)
/**/
             CHGJOB     SWS(00000000)
/**/
/************RTVDTAARA  DTAARA(MSSTAT)  RTNVAR(&MSSTAT)                 E40395*/
/**/
/************IF         COND(%SUBSTRING(&MSSTAT 1 1) *EQ 'Y') +
                          THEN(CHGJOB SWS(1XXXXXXX))                    E40395*/
/**/
             CALL       PGM(GLC1300) PARM(&CNAM &CSEQ)
 
 
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
