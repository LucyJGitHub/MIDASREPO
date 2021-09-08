/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IR Re-run extraction with new decision')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting Module - Italy.                  */
/*                                                                   */
/*       IRC0700 - Re-run extraction with new decision tables        */
/*                                                                   */
/*       (C) Copyright Midas-Kapiti International Ltd. 1998          */
/*                                                                   */
/*       Last Amend No. LUC139             Date 21Dec20              */
/*       Prev Amend No. MMI077             Date 19Sep00              */
/*                      MMI033 *CREATE     Date 12Oct98              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       LUC139 - Upgrade UCI Italian Returns                        */
/*       MMI077 - Transfer also ERUICDPD                             */
/*       MMI033 - Midas Italy Puma/2 Extract Change 3                */
/*                                                                   */
/*********************************************************************/
/**/
             PGM

             DCL        VAR(&XXLIB) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ERDLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)

/* Reset External Switches */
             CHGJOB     SWS(00000000)

/* Get the library prefix */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&XXLIB)
             CHGVAR     VAR(&ERDLIB) VALUE(&XXLIB *CAT 'ERDLIB')
             CHGVAR     VAR(&DMLIB) VALUE(&XXLIB *CAT 'DMLIB')

             CPYF       FROMFILE(ERITACPD) TOFILE(&ERDLIB/ERITACPD) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&ERDLIB/ERITACPD))

             CPYF       FROMFILE(ERITTTPD) TOFILE(&ERDLIB/ERITTTPD) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&ERDLIB/ERITTTPD))

             CPYF       FROMFILE(IRFTDEPD) TOFILE(&ERDLIB/IRFTDEPD) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&ERDLIB/IRFTDEPD))

             CPYF       FROMFILE(ERITCDPD) TOFILE(&ERDLIB/ERITCDPD) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&ERDLIB/ERITCDPD))

 /*          CPYF       FROMFILE(IRCCDTPD) TOFILE(&ERDLIB/IRCCDTPD) +
                          MBROPT(*REPLACE)                               */ /*LUC139*/
 /*          MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&ERDLIB/IRCCDTPD))                        */ /*LUC139*/

             CPYF       FROMFILE(IRFXTBPD) TOFILE(&ERDLIB/IRFXTBPD) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&ERDLIB/IRFXTBPD))

/*           CPYF       FROMFILE(ERUICDPD) TOFILE(&ERDLIB/ERUICDPD) +
                          MBROPT(*REPLACE)              */   /*MMI077*/     /*LUC139*/
/*           MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&ERDLIB/ERUICDPD))       */   /*MMI077*/     /*LUC139*/

             CALL       PGM(ERC0700)

/*  If no errors, exit */

             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO CMDLBL(END))

/*  Error */

 ABNOR:      SNDPGMMSG  MSG('PUMA extraction not submitted') +
                          TOPGMQ(*PRV) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000)

 END:
             ENDPGM
