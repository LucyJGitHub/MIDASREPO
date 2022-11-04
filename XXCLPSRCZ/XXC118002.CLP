/********************************************************************/
/*STD    CLPBASE                                                    */
/*EXI    TEXT('Midas SE Pos Sett Generated Rpt')                    */
/********************************************************************/
/*                                                                  */
/*       Midas - Securities Trading Module                          */
/*                                                                  */
/*       XXC118002 - Position Settlement Generated Report (I/C)     */
/*                                                                  */
/*       Called By: XX118001 - On-Line Positions Generation         */
/*                                                                  */
/*       (c) Finastra International Limited 2022                    */
/*                                                                  */
/*       Last Amend No. HUT118  *CREATE   Date 03Nov22              */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       HUT118 - Online Generation of Position Settlements         */
/*                                                                  */
/********************************************************************/

             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)

             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RETRN7) TYPE(*CHAR) LEN(7) VALUE('       ')
             DCL        VAR(&FMT200) TYPE(*CHAR) LEN(200) VALUE(' ')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50) VALUE(' ')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(C) Copyright +
                          Finastra International Systems Ltd. 2020')

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/* ensure dataarea QTEMP/LDA Exists */

             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             MONMSG     MSGID(CPF0000)

             CHGJOB     SWS(00000000)

/* ensure feature HUT118 is active */

             CALL       PGM(AOSARDR0) PARM(&RETRN7 '*VERIFY' 'HUT118' &FMT200)

             IF         COND(&RETRN7 *NE '       ') THEN(GOTO +
                          CMDLBL(END))

/* call Report Program */

             CLRPFM     FILE(XXPOSEX4)
             CALL       PGM(XX118002) PARM(&RSEQ &RPARM)

/* Database error processing */

             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) TOPGMQ(*EXT) +
                             TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO

             GOTO       CMDLBL(END)

ABNOR:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('XXC118002 - Position Settlement Generated Report +
                          ended abnormally - see joblog') TOMSGQ(MOPERQ) /*HUT105*/

 END:        CHGVAR     VAR(&CPYFLD) VALUE('Copyright Finastra International +
                          Systems Ltd. 2020')
             MONMSG     MSGID(CPF0000)

             ENDPGM
