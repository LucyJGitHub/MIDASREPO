/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL DEAL AMENDMENTS BY DEAL ENQUIRY')            */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC0307 - DEAL AMENDMENTS BY DEAL ENQUIRY                  */
/*                                                                  */
/*       (c) Finastra International Limited 2001                    */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG1832            Date 19Feb02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01311             Date  14Feb91             */
/*                      S01194             Date  01Aug89             */
/*                      E14948             DATE  04/11/88           */
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG1832- Projected Account Movements Enquiry Problems       */
/*       S01311  -  CLEAR DATA AREA DLSDS                           */
/*       S01194  -  NEW STANDING DATA                               */
/*       E14948  -  SWITCHES U7 & U8 WERE NOT BEING SET OFF BEFORE  */
/*                  RPG PROGRAMS WERE CALLED                        */
/*                                                                  */
/********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
/**/
/************OVRDBF     FILE(TABLE) TOFILE(TABDLI)                    /*S01194*/
                                                        /* S01311 */
             CHGDTAARA  DTAARA(QTEMP/DLSDS) VALUE(' ')
             MONMSG     MSGID(CPF1015)  EXEC(+
                    DO)
/**********  CRTDTAARA  DTAARA(QTEMP/DLSDS) TYPE(*CHAR) LEN(161)     */                  /*BUG1832*/
             CRTDTAARA  DTAARA(QTEMP/DLSDS) TYPE(*CHAR) LEN(167)                         /*BUG1832*/
                    ENDDO
                                                       /* S01311 */
                                                        /* E14948 */
             CHGJOB     SWS(XXXXXX00)
                                                        /* E14948 */
                                                        /* S01311 */
 /***********CALL       PGM(DL0180)                                  */
             CALL       PGM(DL0181)
                                                        /* S01311 */
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
                          Finastra International Limited')
             ENDPGM
