/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RR Set-up FF recov areas for market')           */
/*********************************************************************/
/*                                                                   */
/*        Midas     - Restart Recovery Module                   */
/*                                                                   */
/*     SDC1741 - SET UP RECOVERY AREAS FOR A MARKET                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*     LAST AMEND NO. 00                 DATE 00/00/00               */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MRKT &SEQN1 &SEQN2)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&MRKT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SEQN1) TYPE(*DEC) LEN(10)
             DCL        VAR(&SEQN2) TYPE(*DEC) LEN(10)
/**/
             DCLF       FILE(RCVRYL)
/**/
/* GLOBAL MONITOR MESSAGE */
/**/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO ABNOR)
/**/
/* FOR THE MARKET CENTRE CODE RECEIVED, SET UP THE STRING OF POINTS  */
/* ON LF/RCVRYL FOR WHICH CHANGES MUST BE APPLIED FOR THAT MARKET    */
/* (BETWEEN THE 'GLOBAL POINTS' &SEQN1 & &SEQN2)                     */
/**/
                CLRPFM     FILE(RCVRY)
/**/
                CALL       PGM(SD1741) PARM(&MRKT &SEQN1 &SEQN2)
                IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)
/**/
/* FORWARD RECOVER ALL FF MULTIMEMBER FILES FOR THAT MEMBER BETWEEN  */
/* EACH SET OF FROM AND TO POINTS ON PF/RCVRY                        */
/**/
 READ:          RCVF
                MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
                CALL       PGM(SDC1742) PARM(&MRKT &FRPNT &TOPNT)
                IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)
                GOTO       CMDLBL(READ)
/**/
/* ABNORMAL TERMINATION PROCESSING */
/**/
ABNOR:       SNDPGMMSG  MSG('PROGRAM SDC1741 - Set up recovery areas +
                          for an FF market - ENDED ABNORMALLY') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
END:         ENDPGM
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
