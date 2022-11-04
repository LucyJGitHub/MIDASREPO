/********************************************************************/
/*STD    CLPBASE                                                    */
/*EXI    TEXT('On-line gend Position Settlements Rept Parms')       */
/********************************************************************/
/*                                                                  */
/*       Midas - Securities Trading Module                          */
/*                                                                  */
/*       XXC118002A- On-line gend Position Settlements Rept Parms   */
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

             PGM        PARM(&WSSECU &WSEDTE &WSPDTE &WSEVTP)

             DCL        VAR(&WSSECU) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSEDTE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WSPDTE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WSEVTP) TYPE(*CHAR) LEN(2)

             DCL        VAR(&DMLIB)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&LIBR)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(C) Copyright +
                          Finastra International Systems Ltd. 2020')

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/*                                                                   */
/* Set up DM library with correct prefix.                            */
/*                                                                   */
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&LIBR) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR     VAR(&DMLIB) VALUE(&LIBR *TCAT 'DMLIB')
/*                                                                   */
/* Create XXONLGEN object - used to check if work file exists        */
/*                                                                   */
             CHKOBJ     OBJ(QTEMP/XXONLGEN) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                CRTDUPOBJ  OBJ(XXONLGEN) FROMLIB(&DMLIB) OBJTYPE(*DTAARA) +
                             TOLIB(QTEMP) NEWOBJ(XXONLGEN) DATA(*NO)
             ENDDO


             CHGDTAARA  DTAARA(QTEMP/XXONLGEN (1 10)) VALUE(&WSSECU)
             MONMSG     MSGID(CPF0000 MCH0000)

             CHGDTAARA  DTAARA(QTEMP/XXONLGEN (11 6)) VALUE(&WSEDTE)
             MONMSG     MSGID(CPF0000 MCH0000)

             CHGDTAARA  DTAARA(QTEMP/XXONLGEN (17 6)) VALUE(&WSPDTE)
             MONMSG     MSGID(CPF0000 MCH0000)

             CHGDTAARA  DTAARA(QTEMP/XXONLGEN (23 2)) VALUE(&WSEVTP)
             MONMSG     MSGID(CPF0000 MCH0000)

             GOTO       CMDLBL(END)

ABNOR:
             SNDPGMMSG  MSG('XXC118002A - On-line gend Posit Settl Rept Parms +
                          ended abnormally - see joblog') TOMSGQ(MOPERQ)

 END:        CHGVAR     VAR(&CPYFLD) VALUE('Copyright Finastra International +
                          Systems Ltd. 2020')
             MONMSG     MSGID(CPF0000)

             ENDPGM
