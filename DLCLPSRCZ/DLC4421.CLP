/********************************************************************/
/*STD    CLPBASE                                                    */
/*EXI *  TEXT('Midas DL Drop FX Deal Extension Records')            */
/********************************************************************/
/*                                                                  */
/*       Midas - Dealing Module                                     */
/*                                                                  */
/*       DLC4421 - Drop FX Deal Extension Records                   */
/*                                                                  */
/*       (c) Finastra International Limited 2002                    */
/*                                                                  */
/*       Last Amend No. LLE028  *CREATE    Date 24Feb20             */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       LLE028  -  Store FX Revaluation Amounts and Rates          */
/*                                                                  */
/********************************************************************/
             PGM
             DCL        VAR(&MEM)   TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

             CHGJOB     SWS(00000000)

/* Drop extension file records */

             CALL       PGM(DL4421)

/* Database Error */

             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             SNDPGMMSG  MSG('Database error - DLC4421') TOMSGQ(MRUNQ +
                          MOPERQ)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             ENDDO

/* Reorganise the the deals extension file */

             RGZPFM     FILE(DEALSBX1)
             MONMSG     MSGID(CPF0000)

             GOTO       CMDLBL(END)

 ABNOR:
/* Abnormal termination */

             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          DLC4421 ended abormally - see joblog') +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)

 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited 2002')
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDPGM
