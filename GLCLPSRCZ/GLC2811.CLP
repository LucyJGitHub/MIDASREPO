/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Fontis narrative codes table report')        */
/********************************************************************/
/*                                                                  */
/*   Midas - Midas-Fontis Interface                                 */
/*                                                                  */
/*   GLC2811    Fontis Narrative Codes Table Report                 */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   Last Amendment No. CGL004 *CREATE   Date 13MAR97               */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*   CGL004 - Midas-Fontis Interface                                */
/*                                                                  */
/********************************************************************/
 
             PGM        PARM(&RSEQ &RLVL &RENT)
/**/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(60)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/* SET UP PGM MESSAGE */
/**/
             CHGVAR     VAR(&MSG) VALUE('GLC2811 - Fontis Narrative +
                          Codes Table Audit List')
/**/
/* SEND PGM MESSAGE */
/**/
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/**/
/* CLEAR SWITCHES */
/**/
             CHGJOB     SWS(00000000)
/**/
/* CALL THE PROGRAM */
/**/
             CALL       PGM(GL2811P) PARM(' ' 'R' &RSEQ &RLVL &RENT) +
/**/
/**/
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
                ENDPGM
