/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MS Rpt incom. messages lost during recry')      */
/*********************************************************************/
/*                                                                   */
/*     Midas - SWIFT DIRECT LINK                             */
/*                                                                   */
/*     MSC5040 - REPORT INCOMING MESSAGES LOST DURING RECOVERY       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*     LAST AMEND NO. S01310            DATE 06DEC90                 */
/*     PREV AMEND NO.  00000            DATE 00XXX00                 */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*     S01310 - SWIFT RATIONALISATION                                */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
 
/* Declare Message Detail Field.                                     */
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Call Lost Incoming Messages Program.                              */
             CALL       PGM(MS5040)
 
/* For Database Errors Recover Data From Local Data Area, Send       */
/* Message to MOPERQ.                                                */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
