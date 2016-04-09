/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT Outgoing Payments by Dest Prompt-Book')      */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Funds Transfer Module                           */
/*                                                                   */
/*       FTC0245 - Outgoing Payments by Destination Prompt CLP       */
/*                   (By Booking Branch)                             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01494  *CREATE    DATE 25MAY94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       S01494 - BLI Funds Transfer Enhancements                    */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM &ACTN &CMD)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&ACTN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CMD) TYPE(*CHAR) LEN(1)
/**/
/** Global monitor message */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
/** Update positions 4-10 of &RPARM to indicate that the report */
/** is by booking branch */
/**/
             CHGVAR     VAR(%SST(&RPARM 4 7)) VALUE('FTM2506')
/**/
/** Call FT0245 with corresponding parameters */
/**/
             CALL       PGM(FT0245) PARM(&RSEQ &RLEV &RENT &RPARM +
                        &ACTN &CMD)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
                SNDPGMMSG  MSG('CALL TO PROGRAM FT0245 ENDED IN +
                           ERROR') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
/**/
             GOTO       CMDLBL(END)
/**/
ABNOR:
             SNDPGMMSG  MSG('CALL TO PROGRAM FTC0245 ENDED IN +
                           ERROR') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
