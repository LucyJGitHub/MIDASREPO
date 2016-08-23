/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL MM Discount Factors Rebuild - COB')          */
/*********************************************************************/
/*                                                                   */
/*       Midas     - FRA/IRS Module                              */
/*                                                                   */
/*       DLC1962 - MM DISCOUNT FACTORS REBUILD CONTROL IN COB        */
/*                                                                   */
/*       Function: Called by DLC04 in I/C termination.               */
/*         (COB)   If RADA, on dataarea DLMMDF, indicates that a     */
/*                 Rebuild in I/C has failed (RADA <> 0) then        */
/*                 DL1960 is called to perform Rebuild.  If rebuild  */
/*                 is successful RADA will be set to 0, and the      */
/*                 time and date on DLMMDF updated appropriately.    */
/*                 If a Rebuild is not necessary then the file,      */
/*                 DLMMDFPP, is reorganised to stop it getting huge. */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. 228542             Date 05Aug04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 102674             Date 25Apr96              */
/*                      E28440             Date 30Sep91              */
/*                      S29020             DATE 30SEP91              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       102674 - Reorganisation of premium discount file fails if   */
/*                no records on file.                                */
/*       E28440 - Since clear down of physical file, DLMMDFPP, done  */
/*                record by record in DL1960 (to avoid error if file */
/*                locked by DL1905) must reorganise physical file    */
/*                every night to avoid it growing too large.         */
/*       S29020 - FRA/IRS Revaluations - New Program needed since    */
/*                SDBANKPD needs to be accessed and DLC04 already    */
/*                uses a file.                                       */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&TERM)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&DLMMDF) TYPE(*CHAR) LEN(16)
             DCL        VAR(&RADA) TYPE(*DEC) LEN(5)
             DCL        VAR(&TLRB) TYPE(*CHAR) LEN(6)
             DCL        VAR(&TERM) TYPE(*CHAR) LEN(1)
 
             DCLF       FILE(SDBANKPD)
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
/* See whether MM Discount Factors Rebuild program has failed during */
/* the day by using the count on DLMMDF.  This count is incremented  */
/* when the Interest Rates are maintained and decremented on         */
/* successful completion of the Discount Factors Rebuild (submitted  */
/* by Rates Maintenance).  Hence if the count > 0 there has been an  */
/* error and the program should now be run interactively.            */
             RTVDTAARA  DTAARA(DLMMDF) RTNVAR(&DLMMDF)
             CHGVAR     VAR(&RADA) VALUE(%SST(&DLMMDF 1 5))
             IF         COND(&RADA > 0) THEN(DO)
               SNDMSG     MSG('DL1960 - MM Discount Factors Rebuild') +
                          TOMSGQ(MRUNQ)
 
/*  Clear MM Discount Factors file before calling rebuild program */
               CLRPFM     FILE(DLMMDFPP)
               CALL       PGM(DL1960)
 
/* Monitor for database error and send appropriate message to MOPERQ */
               IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))
 
/*  If no error on call to MM Discount Factors Rebuild program then */
/*  retrieve MM-Discount-Factors-Rebuild Data Area, and set count,  */
/*  RADA, to zero.                                                  */
               CHGVAR     VAR(&RADA) VALUE(0)
               CHGVAR     VAR(%SST(&DLMMDF 1 5)) VALUE(&RADA)
 
/*  Set date and time of Discount Factors Rebuild and update */
/*  dataarea, DLMMDF.  */
               RCVF
               CHGVAR     VAR(%SST(&DLMMDF 6 5)) VALUE(&BJRDNB)
 
               RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&TLRB)
               CHGVAR     VAR(%SST(&DLMMDF 11 6)) VALUE(&TLRB)
 
               CHGDTAARA  DTAARA(DLMMDF) VALUE(&DLMMDF)
 
/* End-do; if count > 0 */
             ENDDO
                                                                      /*E28440*/
/* Reorganise physical file DLMMDFPP to avoid file getting too large    E28440*/
/************ELSE       CMD(RGZPFM FILE(DLMMDFPP))            E28440   102674 */
             ELSE       CMD(DO)                                     /* 102674 */
/**********  RGZPFM     FILE(DLMMDFPP)                              /* 102674 */          /*228542*/
/**********  MONMSG     MSGID(CPF2981)                              /* 102674 */          /*228542*/
             CALL       PGM(SCC000060) PARM('DLMMDFPP' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
             ENDDO                                                  /* 102674 */
 
/* --------------------------------------------------------------- */
 
             GOTO       CMDLBL(END)
ERROR:       CHGVAR     VAR(&TERM) VALUE('E')
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
