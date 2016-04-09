/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Deals file enquiry')                         */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC0306 - DEALS FILE ENQUIRY                               */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG1832            Date 19Feb02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01194             Date 01Aug89              */
/*                      S01104             Date 22Sep86              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       BUG1832- Projected Account Movements Enquiry Problems       */
/*       S01194  -  NEW STANDING DATA                               */
/*       S01104  -  CLEAR DATA AREA FOR LINKING TO DL0120           */
/*                                                                  */
/********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
/**/                                                                  /*S01104*/
             DLTDTAARA  DTAARA(DLSDS)                                 /*S01104*/
             MONMSG     MSGID(CPF0000)                                /*S01104*/
/************CRTDTAARA  DTAARA(DLSDS.QTEMP) TYPE(*CHAR) LEN(161)*S01104*S01179*/
/**********  CRTDTAARA  DTAARA(QTEMP/DLSDS) TYPE(*CHAR) LEN(161)     */       /*S01179*/ /*BUG1832*/
             CRTDTAARA  DTAARA(QTEMP/DLSDS) TYPE(*CHAR) LEN(167)                         /*BUG1832*/
             CHGJOB     SWS(00000000)                                 /*S01104*/
/**/
/************OVRDBF     FILE(TABLE) TOFILE(TABDLI)                    /*S01194*/
/*/COPY WNCPYSRC,DLC0306001                                          */
             CALL       PGM(DL0170)
/*/COPY WNCPYSRC,DLC0306002                                          */
/************DLTOVR     FILE(TABLE)                                   /*S01194*/
/**/
             RTVJOBA    JOB(&JOB) SWS(&SWS)
             IF         COND((%SUBSTRING(&SWS 7 1) = '1') *OR +
                        (%SUBSTRING(&SWS 8 1) = '1')) THEN(DO)
             SNDPGMMSG  MSG('Job Terminated - Database in Error') +
                        TOMSGQ(MOPERQ)
             SNDPGMMSG  MSG('Job Terminated - Database in Error') +
                        TOMSGQ(&JOB)
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
