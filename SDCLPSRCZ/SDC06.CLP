/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SD List of Customers')                          */
/********************************************************************/
/*                                                                  */
/*       Midas     Standing Data Module                         */
/*                                                                  */
/*       SDC06 - Standing Data Audits                               */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      RT0009             Date 14May91              */
/*                    .S01117             DATE  21JAN90             */
/*                     E14791             DATE  05/10/88            */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure    */
/*       RT0009  -  'ALL' processing is no longer required.         */
/*       S01117  -  RELEASE 10 MULTIBRANCHING                       */
/*       E14791  -  'END OF DAY' MESSAGE SENT DURING INPUT CYCLE.   */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PRM01 &PRM02)
/*                                                                  */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        &PRM01        TYPE(*CHAR)  LEN(8)
             DCL        &PRM02        TYPE(*CHAR)  LEN(8)
             DCL        &MSG          TYPE(*CHAR)  LEN(75)
             DCL        &JOB          TYPE(*CHAR)  LEN(10)
             DCL        &USER         TYPE(*CHAR)  LEN(10)
             DCL        &DATE         TYPE(*CHAR)  LEN(6)
/**********  DCL        &MPHAS        TYPE(*CHAR)  LEN(1)                       */ /*E14791 CCB020*/
             DCL        VAR(&COBST) TYPE(*CHAR) LEN(4)                                    /*CCB020*/
/*                                                                  */
/**********  RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                            */ /*E14791 CCB020*/
             CALL       PGM(CBC001001) PARM(&COBST)                                       /*CCB020*/
             RTVJOBA    JOB(&JOB)  USER(&USER)  DATE(&DATE)
/**********  IF         (&MPHAS *NE 'A') THEN(DO)                               */ /*E14791 CCB020*/
             IF         COND(&COBST *EQ '*YES') THEN(DO)                                  /*CCB020*/
/*           CHGVAR     &MSG VALUE(' END OF DAY PROCESSING EXECUTING')  S01117*/
             CHGVAR     &MSG VALUE(' Standing Data audit executing')  /*S01117*/
             SNDMSG     TOMSGQ(MRUNQ) MSG(&MSG)
             ENDDO                                                    /*E14791*/
/************IF         (&PRM01 *EQ 'ALL') THEN(DO)                   /*RT0009*/
/************CALL       PGM(SDC0601) PARM(&PRM02)                     /*RT0009*/
/************CALL       PGM(SDC0602) PARM(&PRM02)                     /*RT0009*/
/************CALL       PGM(SDC0603) PARM(&PRM02)                     /*RT0009*/
/***ENDD001:****ENDDO                                                 /*RT0009*/
/*                                                                  */
/************ELSE                                                     /*RT0009*/
             CALL       &PRM01 PARM(&PRM02)
/*                                                                  */
 ENDCLPGM:
             RETURN
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM     /* END CL PGM */
