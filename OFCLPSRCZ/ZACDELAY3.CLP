/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas ZA CL module to apply a DLYJOB within an RPG')  */
/*********************************************************************/
/*                                                                   */
/*       Midas Standard routines                                     */
/*                                                                   */
/*       ZACDELAY3 - Function to apply a DELAYJOB                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2014           */
/*                                                                   */
/*       Last Amend No. MD024362 *CREATE   Date 16Jan14              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*      MD024362 - Subsidiaries Daily Sweeping Forecasts             */
/*                 Amendment of GLFORITD and GLFORTTD does not work. */
/*                 Delay added to manage all events regarding the    */
/*                 process speed limit of the I-series               */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&DELAYTIM) TYPE(*CHAR) LEN(128)
             DCL        VAR(&DELAY) TYPE(*DEC) LEN(6)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/** Retrieve delay definition. */
 
             RTVDTAARA  DTAARA(ZADELAYTIM *ALL) RTNVAR(&DELAYTIM) +
 
             CHGVAR     VAR(&DELAY) VALUE(%SST(&DELAYTIM 1 6)) +
 
             IF         COND(&DELAY *NE 0) THEN(DLYJOB DLY(&DELAY)) +
 
             IF         COND(&DELAY *EQ 0) THEN(DO)
             DLYJOB     DLY(10)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
 END:
             ENDPGM
