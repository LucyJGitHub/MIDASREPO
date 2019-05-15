/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Restart input cycle init menu')              */
/********************************************************************/
/*                                                                  */
/*        Midas     - System Control Module                     */
/*                                                                  */
/*       SCMENUG  - RESTART INPUT CYCLE INITIATION MENU             */
/*                                                                  */
/*      (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*  PREV AMEND NO. S01343                       DATE 15AUG91        */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*  MD046248 - Finastra Rebranding                                  */
/*  S01343  -  SC/RR/SD MODULE RENAME PROJECT.                      */
/*             - RENAMED FROM L1MNUG10                              */
/*             - SCUSRMNU RENAMED FROM MUSRMNU                      */
/*                                                                  */
/********************************************************************/
/*                                                                            */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/**/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&NUM) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RUNA) TYPE(*CHAR) LEN(7)
             DCL        VAR(&IN02) TYPE(*LGL) LEN(1) VALUE('0')
             DCL        VAR(&RUNDAT) TYPE(*CHAR) LEN(13)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCLF       FILE(SCMENUGDF) RCDFMT(SCMENUG)
/*                                                                            */
             RTVJOBA    JOB(&WSID) USER(&WSUSER)
             RTVDTAARA  DTAARA(RUNDAT) RTNVAR(&RUNDAT)
             CHGVAR     VAR(&RUNA) VALUE(%SST(&RUNDAT 1 7))
 
 RDSPLY:     SNDRCVF    RCDFMT(SCMENUG)
             CHGVAR     VAR(&IN02) VALUE('0')
/**/
/* Option 1 to restart I/C Init */
             IF         COND(&MOPTN *EQ 01) THEN(RETURN)
/**/
/* Option 2 to go to WS operator menu */
             IF         COND(&MOPTN *EQ 02) THEN(CALL PGM(SCUSRMNU))
/**/
/* If none of these  */
             IF         COND((&MOPTN *NE 01) *AND (&MOPTN *NE 02)) +
                          THEN(GOTO CMDLBL(ERROR))
/**/
             GOTO       CMDLBL(RDSPLY)
 
 ERROR:      CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&NUM) VALUE(&MOPTN)
             GOTO       CMDLBL(RDSPLY)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM     /* END CL PGM SCMENUG    */
