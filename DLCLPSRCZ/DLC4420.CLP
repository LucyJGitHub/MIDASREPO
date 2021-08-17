/********************************************************************/
/*STD    CLPBASE                                                    */
/*EXI *  TEXT('Midas DL Update Forward Revaluation Details')        */
/********************************************************************/
/*                                                                  */
/*       Midas - Dealing Module                                     */
/*                                                                  */
/*       DLC4420 - Update Forward Revaluation Details               */
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
             DCL        VAR(&WRDNB) TYPE(*CHAR) LEN(5)
             DCL        VAR(&WDNWD) TYPE(*CHAR) LEN(5)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MEM)   TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')
             DCLF       FILE(SDBANKPD) RCDFMT(*ALL)

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

             CHGJOB     SWS(XXXXXX00)

/* Get Next Working Day and convert to alpha */

             RCVF
             CHGVAR     VAR(&WRDNB) VALUE(&BJRDNB)
             CHGVAR     VAR(&WDNWD) VALUE(&BJDNWD)

/* Take Security Copy */

             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
             CHGVAR     VAR(&DPLIB) VALUE(&PREFIX *CAT 'DPLIB')
             DLTF       FILE(&DPLIB/XDEALSBX1)
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(DEALSBX1) TOFILE(&DPLIB/XDEALSBX1) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPC2957)

/* Create Subset of DEALSBX1 with value date >= RUN DAY and < NEXT WORK DAY */

             OVRDBF     FILE(DEALSBX1) SHARE(*YES)
             OPNQRYF    FILE((DEALSBX1)) OPTION(*ALL) QRYSLT('LVDAT +
                          *GT ' *CAT &WRDNB *CAT ' *AND LVDAT *LT ' +
                          *CAT &WDNWD) SEQONLY(*NO)

/* Update DEALSBX1 */

             CALL       PGM(DL4420)

             DLTOVR     FILE(DEALSBX1)
             CLOF       OPNID(DEALSBX1)

/* Database Error */

             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             SNDPGMMSG  MSG('Database error - DLC4420') TOMSGQ(MRUNQ +
                          MOPERQ)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
/* Restore copy */
             CPYF       FROMFILE(XDEALSBX1) TOFILE(DEALSBX1) +
                          MBROPT(*REPLACE)
/* Empty copy */
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(DEALSBX1))
             ENDDO

/* Delete copy */
             DLTF       FILE(XDEALSBX1)

             GOTO       CMDLBL(END)

ABNOR:
/* Abnormal termination */

             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          DLC4420 ended abormally - see joblog') +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)

 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited 2002')
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDPGM
