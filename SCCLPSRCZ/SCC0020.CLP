/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Display joblog')                             */
/*********************************************************************/
/*                                                                   */
/*      Midas - System Control Module                        */
/*                                                                   */
/*      SCC0020 - DISPLAY JOBLOG                                     */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*      PREV AMEND NO. RT0138                DATE 06JUN91            */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*      MD046248 - Finastra Rebranding                               */
/*      RT0138  -  New program to display the current joblog for the */
/*                 user to identify problems which have occurred.    */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CALLPGM &FORMAT)
 
             DCL        VAR(&REPLY) TYPE(*CHAR) LEN(1) VALUE('Y')
             DCL        VAR(&CALLPGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FORMAT) TYPE(*CHAR) LEN(10)
 
/*  COPYRIGHT STATEMENT VARIABLE  */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/*  CALL SCC0010 TO GIVE USER THE OPTION TO VIEW THE JOBLOG  */
 
             CALL       PGM(SCC0010) PARM(&CALLPGM &FORMAT &REPLY)
             IF         COND(&REPLY *EQ 'Y') THEN(DSPJOBLOG)
 
/*  END OF PROGRAM PROCESSING  */
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             RCLRSC
 
             ENDPGM
