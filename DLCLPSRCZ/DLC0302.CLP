/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL CUST/PARENT EXPOSURE/LIMITS ENQ.')           */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC0302 - CUSTOMER/PARENT EXPOSURE AGAINST LIMITS ENQUIRY  */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CGL029             Date 01Sep03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 19Aug96              */
/*                      S01433             Date  09Sep93             */
/*                      S01332                  DATE  15MAY91       */
/*                      S01194                  DATE  29/09/89      */
/*                      E14948                  DATE  04/11/88      */
/*                                                                  */
/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/*       MD046248 - Finastra Rebranding                              */
/*       CGL029 - Increase Account Code to 10 digits                 */
/*       S01408  -  Core Hook DLC0302004 Added                      */
/*               -  Core Hook DLC0302003 Added                      */
/*               -  Core Hook DLC0302002 Added                      */
/*               -  Core Hook DLC0302001 Added                      */
/*               -  Core Hook DLC0302MPS Added                      */
/*               -  Core Hook DLC0302END Added                      */
/*       S01433  -  ENHANCED DEALING LIMITS                         */
/*                  (NB. This function is to remain switchable until*/
/*                   after Alpha-site testing, when it will become  */
/*                   mandatory. At this point DL0130A will be       */
/*                   renamed to DL0130 and the old version discarded*/
/*                   When this is complete S01433 should be removed */
/*                   from this program.)                            */
/*                                                                  */
/*       S01332  -  EM REL 10 ENHANCEMENTS                          */
/*                                                                  */
/*       S01194  -  NEW STANDING DATA FILES                         */
/*                                                                  */
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
/**********  DCL        VAR(&EMSDS) TYPE(*CHAR) LEN(161)             */        /*S01332*/ /*CGL029*/
             DCL        VAR(&EMSDS) TYPE(*CHAR) LEN(167)                                  /*CGL029*/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,DLC0302001                                           /*S01408*/
/*                                                                    /*S01408*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                /*S01433*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                /*S01433*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                 /*S01433*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)            /*S01433*/
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,DLC0302002                                           /*S01408*/
/*                                                                    /*S01408*/
/**/
/*********** OVRDBF     FILE(TABLE) TOFILE(TABDLI)                    /*S01194*/
                                                        /* E14948 */
             CHGJOB     SWS(XXXXXX00)
                                                        /* E14948 */
             CHGDTAARA  DTAARA(QTEMP/EMSDS) VALUE(' ')               /*S01332*/
             MONMSG     MSGID(CPF1015)  EXEC(DO)                     /*S01332*/
/**********     CRTDTAARA  DTAARA(QTEMP/EMSDS) TYPE(*CHAR) LEN(161)  */        /*S01332*/ /*CGL029*/
                CRTDTAARA  DTAARA(QTEMP/EMSDS) TYPE(*CHAR) LEN(167)                       /*CGL029*/
             ENDDO                                                   /*S01332*/
                                                                     /*S01332*/
/*********** CALL       PGM(DL0130)                                   /*S01433*/
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,DLC0302MPS                                           /*S01408*/
/*                                                                    /*S01408*/
                                                                      /*S01433*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*S01433*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*S01433*/
             CHGVAR     VAR(&SAR) VALUE('S01433')                     /*S01433*/
                                                                      /*S01433*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*S01433*/
                                                                      /*S01433*/
             IF         COND(&RTCD *EQ '       ') THEN(CALL +
                        PGM(DL0130A))                                 /*S01433*/
             ELSE       CMD(CALL PGM(DL0130))                         /*S01433*/
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,DLC0302003                                           /*S01408*/
/*                                                                    /*S01408*/
                                                                      /*S01433*/
/*********** DLTOVR     FILE(TABLE)                                   /*S01194*/
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
/** Call AOSARDR0 with an option of '*FREE' to close the file.       */
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,DLC0302004                                           /*S01408*/
/*                                                                    /*S01408*/
             CHGVAR     VAR(&OPTN) VALUE('*FREE')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,DLC0302END                                           /*S01408*/
/*                                                                    /*S01408*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
