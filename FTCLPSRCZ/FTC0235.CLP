/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT CCT calling program for prompt')             */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Funds Transfer Module                           */
/*                                                                   */
/*       FTC0235 - CCT calling program for prompt FT0570.            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2004           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Last Amend No. BUG25160           Date 23Jul09              */
/* Midas Release 4.04 -----------------------------------------------*/
/*       Prev Amend No. 226942 *CREATE     Date 21May04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       BUG25160 - Apply core fix 226942.                           */
/*       226942 - Make RFT/CCT Authorised/Unauthorised reports       */
/*                available in the system.                           */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM &ACTN &CMD)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2004')
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
/** Update position 4 of &RPARM to indicate that the report */
/** is by booking branch */
/**/
             CHGVAR     VAR(%SST(&RPARM 4 1)) VALUE('1')
/**/
             CHGVAR     VAR(%SST(&RPARM 20 3)) VALUE('CCT')
/** Call FT0570 with corresponding parameters */
/**/
             CALL       PGM(FT0570) PARM(&RSEQ &RLEV &RENT &RPARM +
                        &ACTN &CMD)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
                SNDPGMMSG  MSG('CALL TO PROGRAM FT0570 ENDED IN +
                           ERROR') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
/**/
             GOTO       CMDLBL(END)
/**/
ABNOR:
             SNDPGMMSG  MSG('CALL TO PROGRAM FTC0235 ENDED IN +
                           ERROR') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
