/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL FORWARD RATES INPUT')                        */
/********************************************************************/
/*                                                                  */
/*     Midas - DEALING                                      */
/*                                                                  */
/*     DLC0208 - FORWARD RATES INPUT                                */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*     LAST AMEND NO.                         DATE                  */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*     NEW PROGRAM AT RELEASE 10 TO ALLOW FOR SWITCHABLE FORWARD    */
/*     RATES ENHANCEMENT (S01432)                                   */
/*                                                                  */
/********************************************************************/
             PGM
/*/COPY WNCPYSRC,DLC0208001                                          */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
/*/COPY WNCPYSRC,DLC0208002                                          */
 
 
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SAR) VALUE('S01432')
 
             CHGJOB     SWS(XXXXXX00)
 
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)
 
             IF         COND(&RTCD *EQ '       ') THEN(CALL +
                        PGM(DL0090A))
/*/COPY WNCPYSRC,DLC0208004                                          */
             ELSE       CMD(CALL PGM(DL0090))
 
 
             RTVJOBA    JOB(&JOB) SWS(&SWS)
             IF         COND((%SUBSTRING(&SWS 7 1) = '1') *OR +
                        (%SUBSTRING(&SWS 8 1) = '1')) THEN(DO)
             SNDPGMMSG  MSG('Job Terminated - Database in Error') +
                        TOMSGQ(MOPERQ)
             SNDPGMMSG  MSG('Job Terminated - Database in Error') +
                        TOMSGQ(&JOB)
/*/COPY WNCPYSRC,DLC0208005                                          */
             ENDDO
 
/** Call AOSARDR0 with an option of '*FREE' to close the file.       */
             CHGVAR     VAR(&OPTN) VALUE('*FREE')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*/COPY WNCPYSRC,DLC0208003                                          */
             ENDPGM
