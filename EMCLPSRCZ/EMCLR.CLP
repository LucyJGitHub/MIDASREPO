/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas EM Reset 'EM0100 Active' Flag in EMSTAT')       */
/********************************************************************/
/*                                                                  */
/*     Midas - STANDING DATA MODULE                         */
/*                                                                  */
/*     EMCLR - RESET 'EM0100 ACTIVE' FLAG IN EMSTAT                 */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   LAST AMEND NO.  00               DATE  00/00/00                */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             MONMSG     MSGID(CPF0000 MCH0000) CMPDTA(*NONE) +
                          EXEC(GOTO CMDLBL(ABNORMAL))
/**/
             CHGDTAARA  DTAARA(EMSTAT (2 1)) VALUE('N')
             GOTO       CMDLBL(EOPGM)
/**/
 ABNORMAL:   SNDPGMMSG  MSG('ERROR OCCURRED IN EMCLR') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 EOPGM:      ENDPGM
