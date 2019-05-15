/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MS Check/Toggle trace mode')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas SWIFT Direct Link : Midas/CAS interface               */
/*                                                                   */
/*       MSC8040 - Check/Toggle trace mode                           */
/*                                                                   */
/*       Accessed via CMD/WRKCASTRC                                  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*    This source is centrally supported and must ONLY be            */
/*    amended by Core Development Personnel                          */
/*                                                                   */
/*    /COPY, Client or Country amendments must not be                */
/*    applied to this source.                                        */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSW008 *CREATE     Date 08AUG96              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       This program displays or toggles the Midas/CAS trace mode   */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSW008 - Midas/CAS interface                                */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&OPTION)
 
             DCL        VAR(&OPTION) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TRACE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Access MSSTAT for current trace status                            */
             RTVDTAARA  DTAARA(MSSTAT (21 1)) RTNVAR(&TRACE)
 
/* If trace is off, switch it on                                     */
             IF         COND(&TRACE *NE 'T') THEN(DO)
             IF         COND(&OPTION *EQ '*CHECK') THEN(CHGVAR +
                          VAR(&MSGID) VALUE('MEM6009'))
             ELSE       CMD(DO)
             CHGDTAARA  DTAARA(MSSTAT (21 1)) VALUE('T')
             CHGVAR     VAR(&MSGID) VALUE('MEM6010')
             ENDDO
             ENDDO
 
/* If it's on, switch it off...                                     */
             ELSE       CMD(DO)
             IF         COND(&OPTION *EQ '*CHECK') THEN(CHGVAR +
                          VAR(&MSGID) VALUE('MEM6008'))
             ELSE       CMD(DO)
             CHGDTAARA  DTAARA(MSSTAT (21 1)) VALUE(' ')
             CHGVAR     VAR(&MSGID) VALUE('MEM6011')
             ENDDO
             ENDDO
 
/* Send notification message                                         */
             RTVMSG     MSGID(&MSGID) MSGF(MIDAS) MSG(&MESSAGE)
             CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)
             CALL       PGM(SCC0010) PARM('WRKCASTRC' 'ENTER' ' ')
 
/* Normal end */
             GOTO       CMDLBL(END)
 
/* Abnormal end */
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
                          MSGDTA('MSC8040P ended abnormally - see +
                          job log') TOPGMQ(*PRV) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
