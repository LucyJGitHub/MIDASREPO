/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MS Display CAS status')                         */
/*********************************************************************/
/*                                                                   */
/*       Midas SWIFT Direct Link : Midas/CAS interface               */
/*                                                                   */
/*       MSC8050 - Display CAS status                                */
/*                                                                   */
/*       Accessed via CMD/DSPCASSTS                                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*    This source is centrally supported and must ONLY be            */
/*    amended by Core Development Personnel                          */
/*                                                                   */
/*    /COPY, Client or Country amendments must not be                */
/*    applied to this source.                                        */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CSW008 *CREATE     Date 08AUG96              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       This program displays the current CAS status                */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CSW008 - Midas/CAS interface                                */
/*                                                                   */
/*********************************************************************/
 
             PGM
 
             DCL        VAR(&SBS) TYPE(*CHAR) LEN(20) +
                          VALUE('CASSBS    *LIBL     ')
             DCL        VAR(&RETRY1) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RETRY2) TYPE(*CHAR) LEN(5)
             DCL        VAR(&CASSTS) TYPE(*CHAR) LEN(12)
             DCL        VAR(&SBSTAT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTN_INFO) TYPE(*CHAR) LEN(512)
             DCL        VAR(&ERR_INFO) TYPE(*CHAR) LEN(4) +
                          VALUE(X'00000000')
             DCL        VAR(&RTN_BIN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&NOACTA) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOACTN) TYPE(*DEC) LEN(9 0)
             DCL        VAR(&FORMAT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(C) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Check if CASmf currently active using API to retrieve subsystem   */
/* information.                                                      */
             CHGVAR     VAR(&RTN_BIN) VALUE(X'00000200')
             CHGVAR     VAR(&FORMAT) VALUE('SBSI0100')
             CHGVAR     VAR(&RETRY1) VALUE('FALSE')
             CHGVAR     VAR(&RETRY2) VALUE('FALSE')
 RETRY:      CALL       PGM(QWDRSBSD) PARM(&RTN_INFO &RTN_BIN +
                          &FORMAT &SBS &ERR_INFO)
             MONMSG     MSGID(CPF1605 CPF1606 CPF1607) EXEC(DO)
             IF         COND(&RETRY1 *EQ 'FALSE') THEN(DO)
             CHGVAR     VAR(&RETRY1) VALUE('TRUE ')
             DLYJOB     DLY(20)
             GOTO       CMDLBL(RETRY)
             ENDDO
             ELSE       CMD(DO)
             CHGVAR     VAR(&CASSTS) VALUE('*UNAVAILABLE')
             GOTO       CMDLBL(SHOW)
             ENDDO
             ENDDO
 
/* If subsystem found, get status and number of active jobs          */
             CHGVAR     VAR(&SBSTAT) VALUE(%SST(&RTN_INFO 29 10))
             CHGVAR     VAR(&NOACTA) VALUE(%SST(&RTN_INFO 73 4))
             CHGVAR     VAR(&NOACTN) VALUE(%BINARY(&NOACTA))
 
/* If subsystem and 4 jobs active CAS status *ACTIVE                 */
             IF         COND((&SBSTAT *EQ '*ACTIVE') *AND (&NOACTN +
                          *EQ 4)) THEN(DO)
             CHGVAR     VAR(&CASSTS) VALUE('*ACTIVE')
             GOTO       CMDLBL(SHOW)
             ENDDO
 
/* If subsystem inactive, or no jobs active CAS status *INACTIVE     */
             IF         COND((&SBSTAT *EQ '*INACTIVE') *OR (&NOACTN +
                          *EQ 0)) THEN(DO)
             CHGVAR     VAR(&CASSTS) VALUE('*INACTIVE')
             GOTO       CMDLBL(SHOW)
             ENDDO
 
/* If SBS active but too few jobs, try again in case in transition   */
             IF         COND(&RETRY2 *EQ 'FALSE') THEN(DO)
             CHGVAR     VAR(&RETRY2) VALUE('TRUE ')
             DLYJOB     DLY(120)
             GOTO       CMDLBL(RETRY)
             ENDDO
 
/* If still no good, CAS status *ABNORMAL                            */
             CHGVAR     VAR(&CASSTS) VALUE('*ABNORMAL')
 
 
/* Send notification message                                         */
 SHOW:       RTVMSG     MSGID(MEM6012) MSGF(MIDAS) MSG(&MESSAGE)
             CHGVAR     VAR(&MESSAGE) VALUE(&MESSAGE *BCAT &CASSTS)
             CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)
             CALL       PGM(SCC0010) PARM('DSPCASSTS' 'ENTER' ' ')
 
/* Normal end */
             GOTO       CMDLBL(END)
 
/* Abnormal end */
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
                          MSGDTA('MSC8050P ended abnormally - see +
                          job log') TOPGMQ(*PRV) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
