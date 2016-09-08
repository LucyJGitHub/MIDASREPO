/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Reporting/update utility for MD-38430')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       UTCSD0774 - Reporting/Updating Program for MD038430         */
/*                                                                   */
/*       (C) Misys International Banking Systems Ltd. 2016           */
/*                                                                   */
/*       Last Amend No. MD038430           Date 19May16              */
/*       Prev Amend No. Xnnnnn             Date ddMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD038430 - Unable to grant BFTC HKG user Company Codes.     */
/*                  Report and update SDCOMPPD & GZSDCOMPPD records, */
/*                  plus all the files using company code values,    */
/*                  with blank spaces formatted with 0.              */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PARM)

             DCL        VAR(&PARM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ERR) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

             CHGJOB     SWS(XXXXXX00)
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
             CHGVAR     VAR(&DPLIB) VALUE(&PREFIX *CAT 'DPLIB   ')
             CHGVAR     VAR(&DMLIB) VALUE(&PREFIX *CAT 'DMLIB   ')
             IF         COND((&PARM *NE 'A') *AND (&PARM *NE 'a') +
                        *AND (&PARM *NE 'U') *AND (&PARM *NE 'u')) THEN(DO)
             CHGVAR     VAR(&ERR) VALUE(1)
             GOTO       CMDLBL(ABNOR)
             ENDDO

/* Make a copy of SDCOMPPD as back-up on update mode. */

             IF         COND((&PARM *EQ 'U') *OR (&PARM *EQ 'u')) THEN(DO)
             CPYF       FROMFILE(SDCOMPPD) +
                          TOFILE(&DPLIB/SDCOMPPD.B) MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG  MSGID(CPF2817) EXEC(CLRPFM SDCOMPPD.B)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                 SNDPGMMSG  MSG('Error in BACKUP of file SDCOMPPD - +
                                 Please contact your local Misys Branch') +
                                 TOMSGQ(MOPERQ MRUNQ)
                 GOTO       CMDLBL(END)
             ENDDO
             CPYF       FROMFILE(GZSDCOMPPD) +
                          TOFILE(&DPLIB/GZSDCOMP.B) MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG  MSGID(CPF2817) EXEC(CLRPFM GZSDCOMP.B)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                 SNDPGMMSG  MSG('Error in BACKUP of file GZSDCOMPPD - +
                                 Please contact your local Misys Branch') +
                                 TOMSGQ(MOPERQ MRUNQ)
                 GOTO       CMDLBL(END)
             ENDDO
             CPYF       FROMFILE(TABLET3) +
                          TOFILE(&DPLIB/TABLET3.B) MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG  MSGID(CPF2817) EXEC(CLRPFM TABLET3.B)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                 SNDPGMMSG  MSG('Error in BACKUP of file TABLET3 - +
                                 Please contact your local Misys Branch') +
                                 TOMSGQ(MOPERQ MRUNQ)
                 GOTO       CMDLBL(END)
             ENDDO
             CPYF       FROMFILE(SDBRCHPD) +
                          TOFILE(&DPLIB/SDBRCHPD.B) MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG  MSGID(CPF2817) EXEC(CLRPFM SDBRCHPD.B)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                 SNDPGMMSG  MSG('Error in BACKUP of file SDBRCHPD - +
                                 Please contact your local Misys Branch') +
                                 TOMSGQ(MOPERQ MRUNQ)
                 GOTO       CMDLBL(END)
             ENDDO
             CPYF       FROMFILE(GZSDBRCHPD) +
                          TOFILE(&DPLIB/GZSDBRCH.B) MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG  MSGID(CPF2817) EXEC(CLRPFM GZSDBRCH.B)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                 SNDPGMMSG  MSG('Error in BACKUP of file GZSDBRCHPD - +
                                 Please contact your local Misys Branch') +
                                 TOMSGQ(MOPERQ MRUNQ)
                 GOTO       CMDLBL(END)
             ENDDO
             CPYF       FROMFILE(TABLETR) +
                          TOFILE(&DPLIB/TABLETR.B) MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG  MSGID(CPF2817) EXEC(CLRPFM TABLETR.B)
             MONMSG     MSGID(CPF0000 ) EXEC(DO)
                 SNDPGMMSG  MSG('Error in BACKUP of file TABLETR - +
                                 Please contact your local Misys Branch') +
                                 TOMSGQ(MOPERQ MRUNQ)
                 GOTO       CMDLBL(END)
             ENDDO
             CPYF       FROMFILE(SDBTSMPD) +
                          TOFILE(&DPLIB/SDBTSMPD.B) MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG  MSGID(CPF2817) EXEC(CLRPFM SDBTSMPD.B)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                 SNDPGMMSG  MSG('Error in BACKUP of file SDBTSMPD - +
                                 Please contact your local Misys Branch') +
                                 TOMSGQ(MOPERQ MRUNQ)
                 GOTO       CMDLBL(END)
             ENDDO
             CPYF       FROMFILE(SDBTSFPD) +
                          TOFILE(&DPLIB/SDBTSFPD.B) MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG  MSGID(CPF2817) EXEC(CLRPFM SDBTSFPD.B)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                 SNDPGMMSG  MSG('Error in BACKUP of file SDBTSFPD - +
                                 Please contact your local Misys Branch') +
                                 TOMSGQ(MOPERQ MRUNQ)
                 GOTO       CMDLBL(END)
             ENDDO
             CPYF       FROMFILE(SDBTMHPD) +
                          TOFILE(&DPLIB/SDBTMHPD.B) MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG  MSGID(CPF2817) EXEC(CLRPFM SDBTMHPD.B)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                 SNDPGMMSG  MSG('Error in BACKUP of file SDBTMHPD - +
                                 Please contact your local Misys Branch') +
                                 TOMSGQ(MOPERQ MRUNQ)
                 GOTO       CMDLBL(END)
             ENDDO
             CPYF       FROMFILE(SDBTFHPD) +
                          TOFILE(&DPLIB/SDBTFHPD.B) MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG  MSGID(CPF2817) EXEC(CLRPFM SDBTFHPD.B)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                 SNDPGMMSG  MSG('Error in BACKUP of file SDBTFHPD - +
                                 Please contact your local Misys Branch') +
                                 TOMSGQ(MOPERQ MRUNQ)
                 GOTO       CMDLBL(END)
             ENDDO
             CPYF       FROMFILE(GLOLEMPD) +
                          TOFILE(&DPLIB/GLOLEMPD.B) MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG  MSGID(CPF2817) EXEC(CLRPFM GLOLEMPD.B)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                 SNDPGMMSG  MSG('Error in BACKUP of file GLOLEMPD - +
                                 Please contact your local Misys Branch') +
                                 TOMSGQ(MOPERQ MRUNQ)
                 GOTO       CMDLBL(END)
             ENDDO
             CPYF       FROMFILE(OLPOSOA) +
                          TOFILE(&DPLIB/OLPOSOA.B) MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG  MSGID(CPF2817) EXEC(CLRPFM OLPOSOA.B)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                 SNDPGMMSG  MSG('Error in BACKUP of file OLPOSOA - +
                                 Please contact your local Misys Branch') +
                                 TOMSGQ(MOPERQ MRUNQ)
                 GOTO       CMDLBL(END)
             ENDDO
             CPYF       FROMFILE(GZOLPOSOA) +
                          TOFILE(&DPLIB/GZOLPOSO.B) MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG  MSGID(CPF2817) EXEC(CLRPFM GZOLPOSO.B)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                 SNDPGMMSG  MSG('Error in BACKUP of file GZOLPOSOA - +
                                 Please contact your local Misys Branch') +
                                 TOMSGQ(MOPERQ MRUNQ)
                 GOTO       CMDLBL(END)
             ENDDO
             CPYF       FROMFILE(MCMPSDD) +
                          TOFILE(&DPLIB/MCMPSDD.B) MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG  MSGID(CPF2817) EXEC(CLRPFM MCMPSDD.B)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                 SNDPGMMSG  MSG('Error in BACKUP of file MCMPSDD - +
                                 Please contact your local Misys Branch') +
                                 TOMSGQ(MOPERQ MRUNQ)
                 GOTO       CMDLBL(END)
             ENDDO
             CPYF       FROMFILE(DLTCSTPD) +
                          TOFILE(&DPLIB/DLTCSTPD.B) MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG  MSGID(CPF2817) EXEC(CLRPFM DLTCSTPD.B)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                 SNDPGMMSG  MSG('Error in BACKUP of file DLTCSTPD - +
                                 Please contact your local Misys Branch') +
                                 TOMSGQ(MOPERQ MRUNQ)
                 GOTO       CMDLBL(END)
             ENDDO
             ENDDO


/* Call main program to produce the reports */

             CALL       PGM(UTSD0774) PARM(&PARM)

             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             CHGVAR     VAR(&ERR) VALUE(2)
             GOTO       CMDLBL(ABNOR)
             ENDDO
             GOTO       CMDLBL(END)

 ABNOR:
             IF         COND(&ERR *EQ ('1')) THEN(DO)
             SNDUSRMSG  MSG('Please enter parameter as A or U.') MSGTYPE(*INFO)
             ENDDO

             IF         COND(&ERR *EQ ('2')) THEN(DO)

                 CPYF       FROMFILE(&DPLIB/SDCOMPPD.B) +
                           TOFILE(&DMLIB/SDCOMPPD) MBROPT(*REPLACE)
                 MONMSG  MSGID(CPF2817)

                 CPYF       FROMFILE(&DPLIB/GZSDCOMP.B) +
                           TOFILE(&DMLIB/GZSDCOMPPD) MBROPT(*REPLACE)
                 MONMSG  MSGID(CPF2817)

                 CPYF       FROMFILE(&DPLIB/TABLET3.B) +
                           TOFILE(&DMLIB/TABLET3) MBROPT(*REPLACE)
                 MONMSG  MSGID(CPF2817)

                 CPYF       FROMFILE(&DPLIB/SDBRCHPD.B) +
                           TOFILE(&DMLIB/SDBRCHPD) MBROPT(*REPLACE)
                 MONMSG  MSGID(CPF2817)

                 CPYF       FROMFILE(&DPLIB/GZSDBRCH.B) +
                           TOFILE(&DMLIB/GZSDBRCHPD) MBROPT(*REPLACE)
                 MONMSG  MSGID(CPF2817)

                 CPYF       FROMFILE(&DPLIB/TABLETR.B) +
                           TOFILE(&DMLIB/TABLETR) MBROPT(*REPLACE)
                 MONMSG  MSGID(CPF2817)

                 CPYF       FROMFILE(&DPLIB/SDBTSMPD.B) +
                           TOFILE(&DMLIB/SDBTSMPD) MBROPT(*REPLACE)
                 MONMSG  MSGID(CPF2817)

                 CPYF       FROMFILE(&DPLIB/SDBTSFPD.B) +
                           TOFILE(&DMLIB/SDBTSFPD) MBROPT(*REPLACE)
                 MONMSG  MSGID(CPF2817)

                 CPYF       FROMFILE(&DPLIB/SDBTMHPD.B) +
                           TOFILE(&DMLIB/SDBTMHPD) MBROPT(*REPLACE)
                 MONMSG  MSGID(CPF2817)

                 CPYF       FROMFILE(&DPLIB/SDBTFHPD.B) +
                           TOFILE(&DMLIB/SDBTFHPD) MBROPT(*REPLACE)
                 MONMSG  MSGID(CPF2817)

                 CPYF       FROMFILE(&DPLIB/GLOLEMPD.B) +
                           TOFILE(&DMLIB/GLOLEMPD) MBROPT(*REPLACE)
                 MONMSG  MSGID(CPF2817)

                 CPYF       FROMFILE(&DPLIB/OLPOSOA.B) +
                           TOFILE(&DMLIB/OLPOSOA) MBROPT(*REPLACE)
                 MONMSG  MSGID(CPF2817)

                 CPYF       FROMFILE(&DPLIB/GZOLPOSO.B) +
                           TOFILE(&DMLIB/GZOLPOSOA) MBROPT(*REPLACE)
                 MONMSG  MSGID(CPF2817)

                 CPYF       FROMFILE(&DPLIB/MCMPSDD.B) +
                           TOFILE(&DMLIB/MCMPSDD) MBROPT(*REPLACE)
                 MONMSG  MSGID(CPF2817)

                 CPYF       FROMFILE(&DPLIB/DLTCSTPD.B) +
                           TOFILE(&DMLIB/DLTCSTPD) MBROPT(*REPLACE)
                 MONMSG  MSGID(CPF2817)

              MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)
              SNDPGMMSG  MSG('Error in RESTORE of files - +
                           Please contact your local Misys Branch') +
                           TOMSGQ(MOPERQ MRUNQ)
             ENDDO

             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          UTCSD0774 ended abnormally - see job +
                          log') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)

             ENDDO

 END:
             ENDPGM
