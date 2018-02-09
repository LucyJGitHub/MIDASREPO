/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas I/C List cross currencies maintained')          */
/********************************************************************/
/*                                                                  */
/*        Midas     - Treasury Management module                */
/*                                                                  */
/*       TMC3310  - LIST CROSS CURRENCIES MAINTAINED - I/C          */
/*                                                                  */
/*       Function: This program controls the process by which the   */
/*       (I/C)     list of cross currencies that are maintained by  */
/*       (COB)     the system is called from Midas enquiries menu.  */
/*                                                                  */
/*       Called by: Main menu                                       */
/*                                                                  */
/*       Calls    : TM3310  - List cross currencies maintained file */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCB020  *CREATE    Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      XXXXXX             Date                      */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure    */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM PARM(&RSEQ &RLEV &RENT)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */
   DCL VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level flag (S/C/B)        */
   DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code (all/comp/bch)*/
   DCL VAR(&TYPP) TYPE(*CHAR) LEN(2) /* Blank for I/C                 */
/***DCL*VAR(&MPHAS) TYPE(*CHAR) LEN(1) /* EOD / I/C flag                               */
   DCL VAR(&COBST) TYPE(*CHAR) LEN(4)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             RTVJOBA    SWS(&SWS)
             CHGVAR     VAR(&SWS) VALUE('00000000')
             CHGJOB     SWS(&SWS)
/**********  RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                                   */
             CALL       PGM(CBC001001) PARM(&COBST)
/**********  IF         COND(%SUBSTRING(&MPHAS 1 1) *EQ A) THEN(DO)                    */
             IF         COND(&COBST *EQ '*NO') THEN(DO)
                 CHGVAR     VAR(&TYPP) VALUE('  ')
             ENDDO
/**********  IF         COND(%SUBSTRING(&MPHAS 1 1) *NE A) THEN(DO)                    */
             IF         COND(&COBST *EQ '*YES') THEN(DO)
                 CHGVAR     VAR(&TYPP) VALUE('ED')
             ENDDO
             CALL       PGM(TM3310) PARM(&RSEQ &TYPP)
/*   ERROR MESSAGES                                           */
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                SNDPGMMSG  MSG('JOB TERMINATED-DATABASE IN ERROR') +
                           TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             ENDDO
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
