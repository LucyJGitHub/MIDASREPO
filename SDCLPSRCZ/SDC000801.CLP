/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SD Automated closure of Retail A/C')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       SDC000801 - Midas SD Automated closure of Retail A/C        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/*       Last Amend No. MD027217           Date 29May14              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSD023  *CREATE    Date 11Mar05              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD027217 - Not possible to authorize customer closure       */
/*       CSD023 - Automatic Customer Account Closure                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MIDACC &ERRORC)
 
             DCL        VAR(&MIDACC) TYPE(*CHAR) LEN(24)
             DCL        VAR(&ERRORC) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CMTACTIVE) TYPE(*CHAR) LEN(1) VALUE('N')
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ENDPGM))
 
/* Send program message to MRUNQ that this component is running */
             SNDPGMMSG  MSG('SDC000801 - Midas SD Automated closure +
                          of Retail A/C') TOMSGQ(MRUNQ)
 
/* Start commitment control */
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)
             MONMSG     MSGID(CPF8351) EXEC(CHGVAR VAR(&CMTACTIVE) +
                          VALUE('Y'))
 
             OVRDBF     FILE(SDAULGL0) TOFILE(SDAULGL1) SHARE(*NO)
             OVRDBF     FILE(ACCNTLXX) TOFILE(ACCBR) SHARE(*NO)
             OVRDBF     FILE(REIACXX) TOFILE(REIAC) SHARE(*NO)                          /*MD027217*/
 
/* Call SD000801 */
             CALL       PGM(SD000801) PARM(&MIDAcc &ErrorC)
 
             DLTOVR     FILE(SDAULGL0)
             DLTOVR     FILE(ACCNTLXX)
 
             SNDPGMMSG  MSG('SDC000801 - Midas SD Automated closure +
                          of Retail A/C') TOMSGQ(MRUNQ)
 
 ENDPGM:
             IF         COND(&CMTACTIVE *EQ 'N') THEN(DO)
             ENDCMTCTL
             MONMSG     MSGID(CPF0000)
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International +
                          Banking Systems Ltd.')
 
             ENDPGM
