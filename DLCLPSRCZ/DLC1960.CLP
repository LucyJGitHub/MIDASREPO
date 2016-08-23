/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL MM Discount Factors Rebuild Control')        */
/*********************************************************************/
/*                                                                   */
/*       Midas     - FRA/IRS Module                              */
/*                                                                   */
/*       DLC1960 - MM DISCOUNT FACTORS REBUILD CONTROL               */
/*                                                                   */
/*       Function: This Program will be submitted to batch by        */
/*         (I/C)   FDC0010 whenever the MM Interest Rates Program is */
/*                 called. If submitted a second time before the     */
/*                 first has completed, then the job will queue, (as */
/*                 JOBD MBATCH has only one active job). The field   */
/*                 'RADA' on Data Area DLMMDF will be incremented on */
/*                 entry to MM Interest Interest Rates Maintenance   */
/*                 and decremented, within this program, on each     */
/*                 successful completion of MM Discount Factors      */
/*                 Rebuild.                                          */
/*                 If FRA or IRS Revaluation, or Discount Factors    */
/*                 Reports are selected while this field is > 0 then */
/*                 a Warning Message will appear on the Report.      */
/*                 If the Program terminates abnormally, a check     */
/*                 during I/C Termination (DLC04) will discover      */
/*                 RADA > 0 and this Program will be rerun.          */
/*                 This job does not run under commitment control.   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. E28440             DATE 17SEP91              */
/*       PREV AMEND NO. S01328             DATE 07FEB91              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       E28440 - Clear down of physical file, DLMMDFPP, will be     */
/*                done in DL1960 to avoid error if file locked by    */
/*                the FRA Book positions program (DL1905).           */
/*       S01328 - FRA/IRS Revaluations - New Program.                */
/*                                                                   */
/*********************************************************************/
/**/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RADA) TYPE(*DEC) LEN(5)
             DCL        VAR(&TLRB) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DLMMDF) TYPE(*CHAR) LEN(16)
             DCLF       FILE(SDBANKPD)
/**/
/* Monitor for any errors and send appropriate message to MOPERQ */
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
/************************/                                            /*E28440*/
/***Clear*MM*Discount*Factors file before calling rebuild program */  /*E28440*/
/************CLRPFM*****FILE(DLMMDFPP)**/                             /*E28440*/
/**/
/* Call the MM Discount Factors Rebuild program */
             CALL       PGM(DL1960)
/**/
/* Monitor for database error and send appropriate message to MOPERQ */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ)
               GOTO       CMDLBL(ERROR)
             ENDDO
/**/
/*  If no error on call to MM Discount Factors Rebuild program then */
/*  retrieve MM-Discount-Factors-Rebuild Data Area, decrement RADA  */
/*  by 1 (MM Interest Rates and Discount Factors Rebuild Active).   */
             ALCOBJ     OBJ((DLMMDF *DTAARA *EXCL)) WAIT(30)
             RTVDTAARA  DTAARA(DLMMDF) RTNVAR(&DLMMDF)
             CHGVAR     VAR(&RADA) VALUE(%SST(&DLMMDF 1 5))
             CHGVAR     VAR(&RADA) VALUE(&RADA - 1)
             CHGVAR     VAR(%SST(&DLMMDF 1 5)) VALUE(&RADA)
/**/
/*  Set date and time of Discount Factors Rebuild and update */
/*  dataarea, DLMMDF.  */
             RCVF
             CHGVAR     VAR(%SST(&DLMMDF 6 5)) VALUE(&BJRDNB)
/**/
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&TLRB)
             CHGVAR     VAR(%SST(&DLMMDF 11 6)) VALUE(&TLRB)
/**/
             CHGDTAARA  DTAARA(DLMMDF) VALUE(&DLMMDF)
             DLCOBJ     OBJ((DLMMDF *DTAARA *EXCL))
             GOTO       CMDLBL(END)
/**/
 ERROR:      SNDMSG  MSG('MM Discount Factors Rebuild has +
                          terminated abnormally.  Ensure that the +
                          Discount Factors are recalulated prior to +
                          FRA or IRS Revaluation.') TOMSGQ(MOPERQ)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
 END:        ENDPGM
