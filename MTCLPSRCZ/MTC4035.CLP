/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MT Reset pending testkey messages')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Midas Testkey Module                                */
/*                                                                   */
/*       MTC4035 - Reset Pending Testkey Message                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. BG18886            Date 28May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       Prev Amend No. 170748  *CREATE    Date 01Aug00              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BG18886 - Amend non-standard codes.                         */
/*       170748 - Wrong keys are being calculated for outgoing       */
/*                messages when more than one Testkey user send      */
/*                batches for Automated BISTKO calculation.          */
/*                                                                   */
/*********************************************************************/
 
             PGM
 
             DCL        VAR(&AUTH)   TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/** Declare variables */
/**/
             DCL        VAR(&FLDR) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SYSPRF) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&ORG) TYPE(*CHAR) LEN(1) VALUE('1')
/**/
/** Set up Testkey shared folder name */
/**/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&SYSPRF)   VALUE(%SUBSTRING(&SDSTAT 6 2))
 
/**********  CHGVAR     VAR(&FLDR) VALUE('TFLDR'**&SYSPRF**&ORG)    */ /*BG18886*/
             CHGVAR     VAR(&FLDR) VALUE('TFLDR' *CAT &SYSPRF *CAT +
                          &ORG)                                        /*BG18886*/
/**/
/** Ensure there are no messages awaiting processing by Testkey */
/**/
             CHKDLO    DLO(BISTKO.INP) FLR(&FLDR)
             MONMSG    MSGID(CPF8A82) EXEC(GOTO CMDLBL(CALLPGM))
 
             SNDPGMMSG  MSG('Message file not cleared.  +
                         Check there are no Testkeys awaited.') +
                         TOMSGQ(MOPERQ) TOPGMQ(*EXT)
 
             GOTO       CMDLBL(END)
/**/
/** Call MT4035 program to reset Testkey status of pending messages */
/**/
CALLPGM:
             CALL   PGM(MT4035) PARM(&AUTH)
 
             IF     COND(&AUTH *EQ 'N') THEN(DO)
                    SNDPGMMSG  MSG('User does not have +
                         Routing Officer Authority.') +
                         TOMSGQ(MOPERQ) TOPGMQ(*EXT)
             ENDDO
/**/
/** Terminate program */
/**/
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
