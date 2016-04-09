/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MR MidasPlus Extracts - After Post 4')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - MidasPlus Reporting Module                          */
/*                                                                   */
/*       MRC0002 - MidasPlus Extracts - After Post 4                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2004           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Last Amend No. CAP204             Date 03Mar10              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CMR001             Date 01Sep04              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CAP204 - Retail Account Transfer                            */
/*       CMR001 - MidasPlus Reporting                                */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2004')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('MRC0002 - MidasPlus Extracts - After Post 4') +
                          TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(00000000)
 
             CLRPFM     FILE(MRPOSTPD) MBR(EODPOPD)
/**********  CLRPFM     FILE(MRPOSTPD) MBR(ACPO1  )                  */                   /*CAP204*/
             CLRPFM     FILE(MRPOSTPD) MBR(GLACPML0)                                      /*CAP204*/
             CLRPFM     FILE(MRPOSTPD) MBR(ACPO2  )
             CLRPFM     FILE(MRPOSTPD) MBR(ACPO3  )
             CLRPFM     FILE(MRPOSTPD) MBR(ACPO4  )
             CLRPFM     FILE(MRPOSTPD) MBR(ACPO5  )
 
             GOTO       CMDLBL(ENDP)
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MRC0002 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
 
ENDP:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDPGM
