/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FD IR rates exceeding rate tolerance prompt')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       FDC0586 - IR  Rates Exceeding Tolerance Report              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Prev Amend No. CSD006  *CREATE    Date 30May01              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSD006 - Market Data Feeds                                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM &RACT &RCMD)
 
             DCL        VAR(&IN01) TYPE(*LGL)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RACT)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RCMD)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&ALL)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&SINCE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCLF       FILE(FDC0586DF)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Set-off Database Error Switches */
 
             CHGJOB     SWS(XXXXXX00)
 
/* SEND HEADER/TRAILER INFORMATION  */
 
             RTVDTAARA  DTAARA(RUNDAT (1 7)) RTNVAR(&DATE)
             RTVJOBA    JOB(&WSID) USER(&USER)
 
/* Setup default values for the screen */
 
             CHGVAR     VAR(&ALL) VALUE('N')
             CHGVAR     VAR(&SINCE) VALUE('N')
 
/* Send prompt screen */
 
 SEND:
             SNDRCVF
 
             IF         COND(&IN03 *EQ '1') THEN(DO)
                CHGVAR     VAR(&RCMD) VALUE('E')
                RETURN
             ENDDO
 
             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN04) VALUE('0')
 
/* Validate entries */
 
             IF         COND(&ALL *NE 'Y' *AND &ALL *NE 'N') THEN(DO)
                   CHGVAR     VAR(&IN02) VALUE('1')
                   GOTO       CMDLBL(SEND)
             ENDDO
 
             IF         COND(&SINCE *NE 'Y' *AND &SINCE *NE 'N') +
                          THEN(DO)
                   CHGVAR     VAR(&IN02) VALUE('1')
                   GOTO       CMDLBL(SEND)
             ENDDO
 
             IF         COND(&SINCE *EQ 'N' *AND &ALL *EQ 'N') +
                          THEN(DO)
                   GOTO       CMDLBL(SEND)
             ENDDO
 
             IF         COND(&SINCE *EQ 'Y' *AND &ALL *EQ 'Y') +
                          THEN(DO)
                   CHGVAR     VAR(&IN04) VALUE('1')
                   GOTO       CMDLBL(SEND)
             ENDDO
 
 
/*  Database Error Messages will be sent by RCF */
 
             RTVJOBA    JOB(&JOB) SWS(&SWS)
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                IF         COND(&ALL = 'Y') THEN(DO)
                CHGVAR     VAR(&RPARM) VALUE('ALL')
                ENDDO
                IF         COND(&SINCE = 'Y') THEN(DO)
                CHGVAR     VAR(&RPARM) VALUE(*BLANK)
                ENDDO
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             IF         COND(&IN01 *EQ '1') THEN(SNDPGMMSG MSG('IR +
                          Rates Tolerance Exceeded Report ended +
                          abnormally') TOMSGQ(MOPERQ MRUNQ))
 
             IF         COND(&IN01 *EQ '0') THEN(SNDPGMMSG MSG('IR +
                          Rates Tolerance Exceeded Report ended +
                          abnormally') TOMSGQ(MOPERQ MRUNQ))
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
