/*********************************************************************/
/*STD    CLPBASE                                                     */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                                */
/*                                                                  */
/*       DLCD802 - DAILY EVENTS BY CURRENCY INPUT CYCLE VERSION     */
/*                                                                  */
/*       (c) Finastra International Limited 2001                    */
/*                                                                  */
/*       Last Amend No. DUG503            Date  08Apr18             */
/*       Prev Amend No. DUG431            Date  27Jun05             */
/*                      DUG405            Date  30Jul04             */
/*                      DUG405 *CREATE    Date  27Jul04             */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408            DATE  13DEC95             */
/*                      AUS017             DATE 14AUG92             */
/*                      E40440             DATE 22MAY92             */
/*                      E22608             DATE 04SEP90             */
/*                      E193               DATE 22FEB90             */
/*                      S01117             DATE 02/08/89            */
/*                      S01179             DATE 12/09/88            */
/*                      S03220             DATE 16/05/88            */
/*                      S01129             DATE 03/08/87            */
/*                      S01098             DATE 22/09/86            */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       DUG503  -  UGB FED CARS Upgrade                            */
/*       DUG431  -  Amendments to 'Events by Value Date' Report     */
/*       DUG405  -  Input Cycle Events by Value Date Reporting.     */
/*                  Upgrade of S20208/S20039 from ABS 2.3 to R4.01. */
/*                  Commercial Loans part removed.                  */
/*       *Created   Based on GLC0802B (R4) & GLC9802B (ABS 2.3).    */
/*                  Remove CORE Hooks to avoid confusion.           */
/*       DUG405  -  Changes to the Events by Currency report.       */
/*                  Component now runs core versions - GL0550/551   */
/*                  and the modified versions GLD055/056.           */
/*                  Use existing core hooks GLC0802B07 & B09.       */
/*       S01408 - Addition of core hook GLC0802B01                  */
/*       AUS017  -  Australian Release - FX/MM Daily Events by      */
/*                  Customer                                        */
/*       E40440  -  DOES NOT WORK CORRECTLY FOR SINGLE BRANCH       */
/*       E22608  -  PROGRAM RENAMED FROM DLC0802B AND ALL DL        */
/*                  PROGRAMS CALLED RENAMED TO GL                   */
/*       E193    -  REMOVE NOSEX PROCESSING                         */
/*       S01196  -  REMOVE LETTERS OF CREDIT (BC)                   */
/*       S01194  -  NEW STANDING DATA FILES                         */
/*       S01117  -  RELEASE 10 MULTIBRANCHING                       */
/*       S01179  -  AS400 CONVERSION                                */
/*       S03220  -  FUNDS TRANSFER INTERFACE                        */
/*       S01129  -  INCLUDE FILES REQUIRED FOR SECURITIES TRADING 2 */
/*       S01098  -  AMENDMENT BLOCKS SELECTED LARGE FILES           */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&TYPE &RSEQ &RLEV &RENT)                 /*AUS017*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(2)                 /*AUS017*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level +
                          flag (S/C/B)             */
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity +
                          code (all/comp/bch)                 */
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*DUG405*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*DUG405*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*DUG405*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*DUG405*/
             DCL        VAR(&DUG503) TYPE(*CHAR) LEN(1) /*DUG503*/
             DCL        VAR(&DUG405) TYPE(*CHAR) LEN(1)               /*DUG405*/
             DCL        VAR(&DUG431) TYPE(*CHAR) LEN(1)               /*DUG431*/
/**/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)               /*S01179*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)                    /*S01179*/
/**/                                                                  /*S01129*/
             CHGJOB     SWS(00000000)
/**/
/* SEND PROGRAM MESSAGE.                                         */
/**/
             CHGVAR     VAR(&MEM) VALUE('I/C Events by +
                        Value Date Reporting')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/**/
/* CALL PROGRAM.                                                 */
/**/
             CHGVAR     VAR(&RTCD) VALUE('       ') /*DUG405*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY') /*DUG405*/
             CHGVAR     VAR(&SAR) VALUE('DUG503') /*DUG405*/
             CHGVAR     VAR(&DUG503) VALUE('N') /*DUG405*/
/**  Check if Enhancement is installed */                             /*DUG405*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD) +
                          /*DUG405*/

             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*DUG405*/
                CHGVAR     VAR(&DUG503) VALUE('Y') /*DUG405*/
             ENDDO                                                    /*DUG405*/


             IF         COND(&DUG503 *EQ 'Y') THEN(DO) /*DUG405*/

/* Clear Customer Exchanges Extract File */                           /*DUG431*/
             CLRPFM     FILE(GLCXXFPP)                                /*DUG431*/
             CLRPFM     FILE(GLCXXZPP)                                /*DUG431*/
/* Clear Journal Entries Extract File */                              /*DUG431*/
             CLRPFM     FILE(GLJEXFPP)                                /*DUG431*/
             CLRPFM     FILE(GLJEXZPP)                                /*DUG431*/

/* Deal events extract - Input Cycle */
             CALL       PGM(DLCD607)
/* SE events extract - Input Cycle */
             CALL       PGM(SECD101)


/* Customer Exchanges Events Extract */                               /*DUG431*/
             CALL       PGM(GLD010) PARM('I/C' '       ')             /*DUG431*/

/* Journal Entries Events Extract  */                                 /*DUG431*/
             CALL       PGM(GLD020) PARM('I/C' '       ')             /*DUG431*/

/**/                                                                  /*S01098*/

/*  CALL MODIFIED VERSION OF GL0550 (CALLED GLD955) - CONSOLIDATED */ /*DUG405*/
/*  -------------------------------------------------------------- */ /*DUG405*/
/*                                                                 */ /*DUG405*/
/* With override for DL events */                                     /*DUG405*/
             CHGJOB     SWS(XXX0XXXX)
             OVRDBF     FILE(DLEVNIL2) TOFILE(ILEVNIL3)               /*DUG405*/
/*  Call Consolidated version of value date report */                 /*DUG405*/
             IF         COND((&RLEV *EQ 'S') *OR (&RLEV *EQ ' ')) +
                          THEN(CALL PGM(GLD955) PARM(&TYPE &RSEQ))    /*DUG405*/
             DLTOVR FILE(DLEVNIL2)                                    /*DUG405*/

/* With override for SE events */                                     /*DUG405*/
             CHGJOB     SWS(XXX1XXXX)
             OVRDBF     FILE(DLEVNIL2) TOFILE(ILEVNIL4)               /*DUG405*/
/*  Call Consolidated version of value date report */                 /*DUG405*/
             IF         COND((&RLEV *EQ 'S') *OR (&RLEV *EQ ' ')) +
                          THEN(CALL PGM(GLD955) PARM(&TYPE &RSEQ))    /*DUG405*/
             DLTOVR FILE(DLEVNIL2)                                    /*DUG405*/
                                                                      /*DUG405*/
/*  CALL MODIFIED VERSION OF GL0551 (CALLED GLD956) - BY BRANCH    */ /*DUG405*/
/*  -----------------------------------------------------------    */ /*DUG405*/
/*                                                                 */ /*DUG405*/
/* With override for DL events */                                     /*DUG405*/
             CHGJOB     SWS(XXX0XXXX)
             OVRDBF     FILE(DLEVNTLI) TOFILE(ILEVNTLJ)               /*DUG405*/
/*  Call By Branch version of value date report */                    /*DUG405*/
             IF         COND(&RLEV *EQ 'B') THEN(CALL PGM(GLD956) +
                          PARM(&TYPE &RSEQ &RENT))                    /*DUG405*/
             DLTOVR FILE(DLEVNTLI)                                    /*DUG405*/

/* With override for SE events */                                     /*DUG405*/
             CHGJOB     SWS(XXX1XXXX)
             OVRDBF     FILE(DLEVNTLI) TOFILE(ILEVNTLK)               /*DUG405*/
/*  Call By Branch version of value date report */                    /*DUG405*/
             IF         COND(&RLEV *EQ 'B') THEN(CALL PGM(GLD956) +
                          PARM(&TYPE &RSEQ &RENT))                    /*DUG405*/
             DLTOVR FILE(DLEVNTLI)                                    /*DUG405*/
             ENDDO

             RTVJOBA    SWS(&SWS)
/**/
             IF         COND(%SUBSTRING(&SWS 7 2) = '11') THEN(SNDMSG +
                        MSG('Job terminated - database in error') +
                        TOMSGQ(MOPERQ))
/**/
             IF         COND(%SUBSTRING(&SWS 7 2) = '01') THEN(SNDMSG +
                        MSG('File controls out of balance') +
                        TOMSGQ(MOPERQ))
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
