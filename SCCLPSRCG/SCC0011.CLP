/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Midas information screen sort')              */
/*********************************************************************/
/*                                                                   */
/*      Midas - System Control Module                        */
/*                                                                   */
/*      SCC0011 - RETRIEVE AND CENTRE MESSAGE TEXT FOR MIDAS         */
/*                INFORMATION SCREEN.                                */
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
/*      PREV AMEND NO. E27199                DATE 12AUG91            */
/*                     E26961                DATE 05AUG91            */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*      MD046248 - Finastra Rebranding                               */
/*      E27199  -  Remove code which retrieves the default reply     */
/*                 from DTAARA/MIDASMSG as this processing is now    */
/*                 performed by the call to the Midas Information    */
/*                 Screen.                                           */
/*      E26961  -  If a program formats it's own message it cannot   */
/*                 then display it via a Midas Information Screen.   */
/*                 This program has been written to format such a    */
/*                 message and pass it to the screen program.        */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&LINE1 &LINE2 &LINE3 &LINE4 &LINE5 +
                          &LINE6 &LINE7 &LINE8 &LINE9 &LINE10 +
                          &DFTREPLY)
 
             DCL        VAR(&LINE1) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LINE2) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LINE3) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LINE4) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LINE5) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LINE6) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LINE7) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LINE8) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LINE9) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LINE10) TYPE(*CHAR) LEN(50)
             DCL        VAR(&DFTREPLY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LINE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MIDASMSG) TYPE(*CHAR) LEN(800)
             DCL        VAR(&START) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&END) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&DIFF) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&LINENUM) TYPE(*DEC) LEN(2 0) VALUE(01)
             DCL        VAR(&POSN) TYPE(*CHAR) LEN(100)
 
/*  COPYRIGHT STATEMENT VARIABLE  */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/*  RETRIEVE DATA FROM DATA AREA  */
 
             RTVDTAARA  DTAARA(MIDASMSG) RTNVAR(&MIDASMSG)
 
/*  EXTRACT MESSAGE LINES INTO WORK VARIABLES  */
 
             CHGVAR     VAR(&LINE1) VALUE(%SST(&MIDASMSG 101 50))
             CHGVAR     VAR(&LINE2) VALUE(%SST(&MIDASMSG 151 50))
             CHGVAR     VAR(&LINE3) VALUE(%SST(&MIDASMSG 201 50))
             CHGVAR     VAR(&LINE4) VALUE(%SST(&MIDASMSG 251 50))
             CHGVAR     VAR(&LINE5) VALUE(%SST(&MIDASMSG 301 50))
             CHGVAR     VAR(&LINE6) VALUE(%SST(&MIDASMSG 351 50))
             CHGVAR     VAR(&LINE7) VALUE(%SST(&MIDASMSG 401 50))
             CHGVAR     VAR(&LINE8) VALUE(%SST(&MIDASMSG 451 50))
             CHGVAR     VAR(&LINE9) VALUE(%SST(&MIDASMSG 501 50))
             CHGVAR     VAR(&LINE10) VALUE(%SST(&MIDASMSG 551 50))
 
/***EXTRACT*DEFAULT*REPLY*FOR*SCREEN***/                              /*E27199*/
 
/************CHGVAR     VAR(&DFTREPLY) VALUE(%SST(&MIDASMSG 100 1))*/ /*E27199*/
 
/*  CENTER MESSAGE LINES FOR SCREEN DISPLAY  */
 
 LINE:       IF         COND((&LINE1 *NE ' ') *AND (&LINENUM *LE +
                          01)) THEN(DO)
                CHGVAR     VAR(&LINE) VALUE(&LINE1)
                GOTO       CMDLBL(PROCESS)
             ENDDO
 
             IF         COND((&LINE2 *NE ' ') *AND (&LINENUM *LE +
                          02)) THEN(DO)
                CHGVAR     VAR(&LINE) VALUE(&LINE2)
                CHGVAR     VAR(&LINENUM) VALUE(02)
                GOTO       CMDLBL(PROCESS)
             ENDDO
 
             IF         COND((&LINE3 *NE ' ') *AND (&LINENUM *LE +
                          03)) THEN(DO)
                CHGVAR     VAR(&LINE) VALUE(&LINE3)
                CHGVAR     VAR(&LINENUM) VALUE(03)
                GOTO       CMDLBL(PROCESS)
             ENDDO
 
             IF         COND((&LINE4 *NE ' ') *AND (&LINENUM *LE +
                          04)) THEN(DO)
                CHGVAR     VAR(&LINE) VALUE(&LINE4)
                CHGVAR     VAR(&LINENUM) VALUE(04)
                GOTO       CMDLBL(PROCESS)
             ENDDO
 
             IF         COND((&LINE5 *NE ' ') *AND (&LINENUM *LE +
                          05)) THEN(DO)
                CHGVAR     VAR(&LINE) VALUE(&LINE5)
                CHGVAR     VAR(&LINENUM) VALUE(05)
                GOTO       CMDLBL(PROCESS)
             ENDDO
 
             IF         COND((&LINE6 *NE ' ') *AND (&LINENUM *LE +
                          06)) THEN(DO)
                CHGVAR     VAR(&LINE) VALUE(&LINE6)
                CHGVAR     VAR(&LINENUM) VALUE(06)
                GOTO       CMDLBL(PROCESS)
             ENDDO
 
             IF         COND((&LINE7 *NE ' ') *AND (&LINENUM *LE +
                          07)) THEN(DO)
                CHGVAR     VAR(&LINE) VALUE(&LINE7)
                CHGVAR     VAR(&LINENUM) VALUE(07)
                GOTO       CMDLBL(PROCESS)
             ENDDO
 
             IF         COND((&LINE8 *NE ' ') *AND (&LINENUM *LE +
                          08)) THEN(DO)
                CHGVAR     VAR(&LINE) VALUE(&LINE8)
                CHGVAR     VAR(&LINENUM) VALUE(08)
                GOTO       CMDLBL(PROCESS)
             ENDDO
 
             IF         COND((&LINE9 *NE ' ') *AND (&LINENUM *LE +
                          09)) THEN(DO)
                CHGVAR     VAR(&LINE) VALUE(&LINE9)
                CHGVAR     VAR(&LINENUM) VALUE(09)
                GOTO       CMDLBL(PROCESS)
             ENDDO
 
             IF         COND((&LINE10 *NE ' ') *AND (&LINENUM *LE +
                          10)) THEN(DO)
                CHGVAR     VAR(&LINE) VALUE(&LINE10)
                CHGVAR     VAR(&LINENUM) VALUE(10)
                GOTO       CMDLBL(PROCESS)
             ENDDO
 
             IF         COND(&LINENUM *EQ 11) THEN(GOTO +
                          CMDLBL(ENDPGM))
 
/*  MOVE ALONG THE STRING UNTIL A NON-BLANK CHARACTER IS FOUND  */
 
 PROCESS:    CHGVAR     VAR(&START) VALUE('1')
 
 START:      IF         COND(%SST(&LINE &START 1) *EQ ' ') THEN(DO)
                CHGVAR     VAR(&START) VALUE(&START + 1)
                IF         COND(&START *EQ 51) THEN(GOTO +
                             CMDLBL(TIDYUP))
                GOTO       CMDLBL(START)
             ENDDO
 
/*  THEN MOVE ONE BACK TO LAST BLANK CHARACTER  */
 
             CHGVAR     VAR(&START) VALUE(&START - 1)
 
/*  MOVE BACK FROM END UNTIL A NON-BLANK CHARACTER IS FOUND  */
 
             CHGVAR     VAR(&END) VALUE('50')
 
 END:        IF         COND(%SST(&LINE &END 1) *EQ ' ') THEN(DO)
                CHGVAR     VAR(&END) VALUE(&END - 1)
                GOTO       CMDLBL(END)
             ENDDO
 
/*  THEN CALCULATE NUMBER OF BLANK CHARACTERS FROM THE END  */
 
             CHGVAR     VAR(&END) VALUE(50 - &END)
 
/*  CALCULATE AVERAGE NUMBER OF SPACES AT EACH END OF STRING  */
 
             CHGVAR     VAR(&DIFF) VALUE(&START + &END)
             CHGVAR     VAR(&DIFF) VALUE(&DIFF * 0.5)
 
/*  REPOSITION STRING IN VARIABLE VIA A WORK VARIABLE  */
 
             CHGVAR     VAR(&DIFF) VALUE(&DIFF - &START + 26)
             CHGVAR     VAR(%SST(&POSN &DIFF 50)) VALUE(&LINE)
             CHGVAR     VAR(&LINE) VALUE(%SST(&POSN 26 50))
 
/*  COPY BACK TO ORIGIONAL VARIABLE  */
 
             IF         COND(&LINENUM *EQ 01) THEN(CHGVAR +
                          VAR(&LINE1) VALUE(&LINE))
             IF         COND(&LINENUM *EQ 02) THEN(CHGVAR +
                          VAR(&LINE2) VALUE(&LINE))
             IF         COND(&LINENUM *EQ 03) THEN(CHGVAR +
                          VAR(&LINE3) VALUE(&LINE))
             IF         COND(&LINENUM *EQ 04) THEN(CHGVAR +
                          VAR(&LINE4) VALUE(&LINE))
             IF         COND(&LINENUM *EQ 05) THEN(CHGVAR +
                          VAR(&LINE5) VALUE(&LINE))
             IF         COND(&LINENUM *EQ 06) THEN(CHGVAR +
                          VAR(&LINE6) VALUE(&LINE))
             IF         COND(&LINENUM *EQ 07) THEN(CHGVAR +
                          VAR(&LINE7) VALUE(&LINE))
             IF         COND(&LINENUM *EQ 08) THEN(CHGVAR +
                          VAR(&LINE8) VALUE(&LINE))
             IF         COND(&LINENUM *EQ 09) THEN(CHGVAR +
                          VAR(&LINE9) VALUE(&LINE))
             IF         COND(&LINENUM *EQ 10) THEN(CHGVAR +
                          VAR(&LINE10) VALUE(&LINE))
 
 TIDYUP:     CHGVAR     VAR(&LINE) VALUE(' ')
             CHGVAR     VAR(&POSN) VALUE(' ')
             CHGVAR     VAR(&LINENUM) VALUE(&LINENUM + 1)
             GOTO       CMDLBL(LINE)
 
/*  END OF PROGRAM PROCESSING  */
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             CHGDTAARA  DTAARA(MIDASMSG) VALUE(' ')
 
             RCLRSC
 
             ENDPGM
