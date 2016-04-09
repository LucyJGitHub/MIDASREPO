/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IRM Futures Tmark Extract Control Pgm')         */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Interest Risk Management                        */
/*                                                                   */
/*       RMC0130 - Futures Tmark Extract Control Program             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CRM001  *CREATE    Date 06FEB95              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CRM001 - Midas/Tmark Interface                              */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&RMRUN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/**  Global Monitor Message:                                         */
/**   If an unmonitorred message occurs perform error processing     */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
/**/
/**  Call RM0009 to determine if a run is required                   */
/**/
             CALL       PGM(RM0009) PARM(&RMRUN)
/**/
             RTVJOBA    SWS(&SWS)
             IF         COND(%SST(&SWS 7 2) = '11') THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MRUNQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
/**  Proceed if RM run required                                      */
/**/
             IF         COND(&RMRUN = 'Y') THEN(DO)
/**/
/**  Override file                                                   */
                OVRDBF     FILE(RMTREXPD) TOFILE(RMFOEXPD)
                OVRDBF     FILE(POSTNKD) TOFILE(POSTNKD) MBR(*ALL)
                CLRPFM     FILE(RMFOEXPD)
/**/
/**  Call Futures Tmark Extract Program                              */
/**/
                CALL       PGM(RM0150)
/**/
                RTVJOBA    SWS(&SWS)
                IF         COND(%SST(&SWS 7 2) = '11') THEN(DO)
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MRUNQ)
                   GOTO       CMDLBL(ABNOR)
                ENDDO
/**/
             ENDDO
/**/
             GOTO       CMDLBL(PGMEND)
/**/
/**  Error Processing:                                               */
/**   Dump the program if error occurred in this program             */
/**/
 ABNOR:      DMPCLPGM
             SNDMSG     MSG('Job terminated - Futures Tmark Extract +
                        processing ended in error') +
                        TOMSGQ(MOPERQ MRUNQ)
/**/
/**  End of Program:                                                 */
PGMEND:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             RCLRSC
             ENDPGM
