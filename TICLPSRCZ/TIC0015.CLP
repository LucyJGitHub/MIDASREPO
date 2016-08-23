/*********************************************************************/
/*S*D****CLPBASEBND***************************************************/                 /*MD029775*/
/*STD    CLPBASE                                                     */                 /*MD030956*/
/*EXI    TEXT('Midas TI Check links to Trade Innovation')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Trade Innovation Module                             */
/*                                                                   */
/*       TIC0015 - Check links to TI                                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*    *************************************************************  */
/*    * Please note: for compilation purposes file T2PF currently *  */
/*    * exists in library MBASETI.                                *  */
/*    *************************************************************  */
/*                                                                   */
/*       Last Amend No. MD030956*REINSTATE Date 09Oct14              */
/*       Prev Amend No. MD029775*REDUNDANT Date 19Aug14              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CSC014             Date 11Apr02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CTI003  *CREATE    Date 28Mar01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD030956 - Additional changes to BFM-TI enhancement.        */
/*                  Reinstated for future use in case of downgrade.  */
/*       MD029775 - TI/Midas EOD sync will no longer be used by TI   */
/*                  Plus                                             */
/*       CSC014 - Allow support for DBCS (Recompiled)                */
/*       CTI003 - Midas/TI Interface CoB changes                     */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&TIC0500STS) TYPE(*CHAR) LEN(11)
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TIC0500CHK) TYPE(*CHAR) LEN(1)
             DCL        VAR(&EQ_C_OR_B) TYPE(*CHAR) LEN(1)
             DCL        VAR(&POS) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&KCMACT) TYPE(*DEC) LEN(5 0) VALUE(0)
             DCL        VAR(&KCMSBS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LENGTH) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&KEYWD) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MESGS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SEND) TYPE(*CHAR) LEN(80)
             DCL        VAR(&MSGTXT) TYPE(*CHAR) LEN(100)
 
/*/COPY MLCPYSRC,MLCOVRDCL                                         */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCLF       FILE(T2PF)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY MLCPYSRC,MLCOVROVR                                         */
 
/* Retrieve data area TIDTA to find if TIC0500 part of CoB has completed.*/
             RTVDTAARA  DTAARA(TIDTA (51 11)) RTNVAR(&TIC0500STS)
/* If all statuses are set to Completed then do not run program. */
             IF         COND(&TIC0500STS *EQ 'CCCCCCCCCCC') THEN(DO)
                GOTO       CMDLBL(END)
             ENDDO
/* If all statuses are set to Pending then continue processing. */
             IF         COND(&TIC0500STS *EQ 'PPPPPPPPPPP') THEN(DO)
                GOTO       CMDLBL(PROCESS)
             ENDDO
/* If neither of the above the check individual status as Bypass is acceptable. */
             CHGVAR     VAR(&POS) VALUE(1)
CHECKLOOP:
             IF         COND(&POS *GT 11) THEN(DO)
                GOTO       CMDLBL(PROCESS)
             ENDDO
 
             CHGVAR     VAR(&TIC0500CHK) VALUE(%SST(&TIC0500STS &POS +
                          1))
             IF         COND(&TIC0500CHK *NE 'C' *AND &TIC0500CHK +
                          *NE 'B') THEN(DO)
/* If not Pending then end immediately as statuses in data area look wrong */
                IF         COND(&TIC0500CHK *NE 'P') THEN(DO)
                   SNDPGMMSG  MSGID(TIM0074) MSGF(TIUSRMSG) TOMSGQ(MOPERQ +
                                 MRUNQ)
                   GOTO       CMDLBL(ABNOR)
                ENDDO
      /* ... else check if any previous flags have been Completed or Bypassed. */
                ELSE       CMD(DO)
                   IF         COND(&EQ_C_OR_B *EQ 'Y') THEN(DO)
                      SNDPGMMSG  MSGID(TIM0074) MSGF(TIUSRMSG) TOMSGQ(MOPERQ +
                                    MRUNQ)
                      GOTO       CMDLBL(ABNOR)
                   ENDDO
                ENDDO
             ENDDO
             ELSE       CMD(DO)
                CHGVAR     VAR(&EQ_C_OR_B) VALUE('Y')
                GOTO       CMDLBL(END)
             ENDDO
 
             CHGVAR     VAR(&POS) VALUE(&POS + 1)
             GOTO       CMDLBL(CHECKLOOP)
 
PROCESS:
             CHGJOB     SWS(XXXXXX00)
             SNDPGMMSG  MSGID(TIM0069) MSGF(TIUSRMSG) TOMSGQ(MRUNQ)
 
/* Delete and recreate file used for reporting purposes. */
             DLTF       FILE(QTEMP/TIC0015)
             MONMSG     MSGID(CPF0000)
             CRTPF      FILE(QTEMP/TIC0015) RCDLEN(100)
 
/* Retrieve Midas system ID from data area SDSTAT. */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
 
/* Retrieve library name to identify where data area KCMACT can be found. */
             RTVDTAARA  DTAARA(KCMSBS) RTNVAR(&KCMSBS)
 
/* Retrieve activity timeout period before temporarily changing it. */
             RTVDTAARA  DTAARA(&KCMSBS/KCMACT) RTNVAR(&KCMACT)
             CHGDTAARA  DTAARA(&KCMSBS/KCMACT) VALUE(00600)
 
/* Send RELEASE message to TI system.  This will make the later STATUS messages more reliable. */
             CHGVAR     VAR(&LENGTH) VALUE(20)
             CHGVAR     VAR(&KEYWD) VALUE('*MODE     ')
             CHGVAR     VAR(&MESGS) VALUE('RELEASE')
             CHGVAR     VAR(&SEND) VALUE(&KEYWD *CAT &MESGS)
             SNDPGMMSG  MSGID(TIM0062) MSGF(TIUSRMSG)
             CALL       PGM(KAPEQEN) PARM(&SEND &LENGTH)
 
/* Receive RELEASEOK message from TI, or handle if failed or timed out. */
             CHGVAR     VAR(&LENGTH) VALUE(0)
             CHGVAR     VAR(&SEND) VALUE(' ')
             SNDPGMMSG  MSGID(TIM0063) MSGF(TIUSRMSG)
             CALL       PGM(KAPENEQ) PARM(&SEND &LENGTH)
 
/* If component times out then end. */
             IF         COND(&LENGTH *EQ 0) THEN(DO)
                SNDPGMMSG  MSGID(TIM0044) MSGF(TIUSRMSG)
                GOTO       CMDLBL(ABNOR)
             ENDDO
             IF         COND(%SST(&SEND 11 10) *NE 'RELEASEOK') +
                             THEN(DO)
                SNDPGMMSG  MSGID(TIM0045) MSGF(TIUSRMSG)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Set up parameter for calls to check STATUS. */
             CHGVAR     VAR(&KEYWD) VALUE('*STATUS   ')
/* Read T2PF to identify servers to which status message is sent. */
READ:
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(DO)
                GOTO       CMDLBL(REPORT)
             ENDDO
 
/* Only carry out check if unit mnemonic belongs to this system. */
             IF         COND(%SST(&T2UMN 1 2) *NE &SYSID) THEN(DO)
                GOTO       CMDLBL(READ)
             ENDDO
 
/* Send status message to individual server. */
             CHGVAR     VAR(&LENGTH) VALUE(20)
             CHGVAR     VAR(&MESGS) VALUE(' ')
             CHGVAR     VAR(&MESGS) VALUE(&T2DSM)
             CHGVAR     VAR(&SEND) VALUE(&KEYWD *CAT &MESGS)
             CALL       PGM(KAPEQEN) PARM(&SEND &LENGTH)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
                SNDPGMMSG  MSGID(TIM0070) MSGF(TIUSRMSG)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Call program to receive reply. */
             CHGVAR     VAR(&LENGTH) VALUE(0)
             CHGVAR     VAR(&SEND) VALUE(' ')
             CALL       PGM(KAPENEQ) PARM(&SEND &LENGTH)
/* If there is a time out, then report. */
             IF         COND(&LENGTH *EQ 0) THEN(DO)
/* Set on switch 6 to show that a server has not returned OK message. */
                CHGJOB     SWS(XXXXX1XX)
                SNDPGMMSG  MSGID(TIM0071) MSGF(TIUSRMSG) MSGDTA(&T2DSM) +
                          TOMSGQ(MOPERQ MRUNQ)
                RTVMSG     MSGID(TIM0071) MSGF(TIUSRMSG) MSGDTA(&T2DSM) +
                          MSG(&MSGTXT)
                CALL       PGM(TI0015) PARM('*WRITE' &MSGTXT)
                GOTO       CMDLBL(READ)
             ENDDO
/* Is there a failure? */
             IF         COND(%SST(&SEND 13 4) *EQ 'FAIL') THEN(DO)
/* Set on switch 6 to show that a server has not returned OK message. */
                CHGJOB     SWS(XXXXX1XX)
                SNDPGMMSG  MSGID(TIM0072) MSGF(TIUSRMSG) MSGDTA(&T2DSM) +
                          TOMSGQ(MOPERQ MRUNQ)
                RTVMSG     MSGID(TIM0072) MSGF(TIUSRMSG) MSGDTA(&T2DSM) +
                          MSG(&MSGTXT)
                CALL       PGM(TI0015) PARM('*WRITE' &MSGTXT)
                GOTO       CMDLBL(READ)
             ENDDO
 
/* Call TI0015 to report STATUS check was successful. */
             RTVMSG     MSGID(TIM0073) MSGF(TIUSRMSG) MSGDTA(&T2DSM) +
                          MSG(&MSGTXT)
             CALL       PGM(TI0015) PARM('*WRITE' &MSGTXT)
 
             GOTO       CMDLBL(READ)
 
REPORT:
             CALL       PGM(TI0015) PARM('*REPORT' ' ')
 
             IF         COND(%SWITCH(XXXXX1XX)) THEN(DO)
                CHGJOB     SWS(XXXXX0XX)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
ABNOR:
/* Abnormal termination  */
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSGID(TIM0074) MSGF(TIUSRMSG) TOMSGQ(MOPERQ +
                          MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
END:
/* Reset activity time out data area if the link check was run. */
             IF         COND(&KCMACT *NE 0) THEN(DO)
                CHGDTAARA  DTAARA(&KCMSBS/KCMACT) VALUE(&KCMACT)
                MONMSG     MSGID(CPF0000)
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
