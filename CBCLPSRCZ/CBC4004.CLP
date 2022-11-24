/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CB Call Individual Programs - QUERY')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Processing                        */
/*                                                                   */
/*       CBC4004 - Midas CB Call Individual Programs - QUERY         */
/*                                                                   */
/*       (c) Finastra International Limited 2022                     */
/*                                                                   */
/*       Last Amend No. CCB019  *CREATE    Date 21Sep22              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CCB019 - Close of business Scheduler Enhancement            */
/*                Upgrade IPL089                                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&P &L &OF &OL &P0 &P1 &P2 &P3 &P4 &P5 &P6 +
                          &P7 &P8 &P9 &R)

             DCL        VAR(&P) TYPE(*CHAR) LEN(10)
             DCL        VAR(&L) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P0) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P3) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P4) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P5) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P6) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P7) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P8) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P9) TYPE(*CHAR) LEN(10)
             DCL        VAR(&R) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&R) VALUE(' ')

             RCLRSC

/** IF OUTPUT TO PRINTER */

             IF         COND(&OF *EQ ' ') THEN(DO)

/** SET UP PRINTFILE OVERRIDES */

             OVRPRTF    FILE(QPQUPRFIL) SAVE(*YES) USRDTA(&P) +
                         SPLFNAME(&P)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&R) VALUE('Y')
             GOTO       CMDLBL(END)
             ENDDO

/** EXECUTE QUERY WITH PARMS */

             IF         COND(&P1 *EQ *BLANKS) THEN(DO)
             RUNQRY     QRY(&L/&P) QRYFILE(*LIBL/&P0)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&R) VALUE('Y')
             ENDDO
             GOTO       CMDLBL(END)
             ENDDO

             IF         COND(&P2 *EQ *BLANKS) THEN(DO)
             RUNQRY     QRY(&L/&P) QRYFILE(*LIBL/&P0 *LIBL/&P1)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&R) VALUE('Y')
             ENDDO
             GOTO       CMDLBL(END)
             ENDDO

             IF         COND(&P3 *EQ *BLANKS) THEN(DO)
             RUNQRY     QRY(&L/&P) QRYFILE(*LIBL/&P0 *LIBL/&P1 *LIBL/&P2)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&R) VALUE('Y')
             ENDDO
             GOTO       CMDLBL(END)
             ENDDO

             IF         COND(&P4 *EQ *BLANKS) THEN(DO)
             RUNQRY     QRY(&L/&P) QRYFILE(*LIBL/&P0 *LIBL/&P1 *LIBL/&P2 +
                        *LIBL/&P3)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&R) VALUE('Y')
             ENDDO
             GOTO       CMDLBL(END)
             ENDDO

             IF         COND(&P5 *EQ *BLANKS) THEN(DO)
             RUNQRY     QRY(&L/&P) QRYFILE(*LIBL/&P0 *LIBL/&P1 *LIBL/&P2 +
                        *LIBL/&P3 *LIBL/&P4)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&R) VALUE('Y')
             ENDDO
             GOTO       CMDLBL(END)
             ENDDO

             IF         COND(&P6 *EQ *BLANKS) THEN(DO)
             RUNQRY     QRY(&L/&P) QRYFILE(*LIBL/&P0 *LIBL/&P1 *LIBL/&P2 +
                        *LIBL/&P3 *LIBL/&P4 *LIBL/&P5)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&R) VALUE('Y')
             ENDDO
             GOTO       CMDLBL(END)
             ENDDO

             IF         COND(&P7 *EQ *BLANKS) THEN(DO)
             RUNQRY     QRY(&L/&P) QRYFILE(*LIBL/&P0 *LIBL/&P1 *LIBL/&P2 +
                        *LIBL/&P3 *LIBL/&P4 *LIBL/&P5 *LIBL/&P6)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&R) VALUE('Y')
             ENDDO
             GOTO       CMDLBL(END)
             ENDDO

             IF         COND(&P8 *EQ *BLANKS) THEN(DO)
             RUNQRY     QRY(&L/&P) QRYFILE(*LIBL/&P0 *LIBL/&P1 *LIBL/&P2 +
                        *LIBL/&P3 *LIBL/&P4 *LIBL/&P5 *LIBL/&P6 *LIBL/&P7)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&R) VALUE('Y')
             ENDDO
             GOTO       CMDLBL(END)
             ENDDO

             IF         COND(&P9 *EQ *BLANKS) THEN(DO)
             RUNQRY     QRY(&L/&P) QRYFILE(*LIBL/&P0 *LIBL/&P1 *LIBL/&P2 +
                        *LIBL/&P3 *LIBL/&P4 *LIBL/&P5 *LIBL/&P6 *LIBL/&P7 +
                        *LIBL/&P8)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&R) VALUE('Y')
             ENDDO
             GOTO       CMDLBL(END)
             ENDDO

/** REMOVE PRINTFILE OVERRIDES */

             DLTOVR     FILE(QPQUPFRFIL)
             GOTO       CMDLBL(END)
             ENDDO



/** IF OUTPUT TO DISK */

             IF         COND(&OF *NE ' ') THEN(DO)

/** EXECUTE QUERY WITH PARMS */

             IF         COND(&P1 *EQ *BLANKS) THEN(DO)
             RUNQRY     QRY(&L/&P) QRYFILE(*LIBL/&P0) +
                        OUTFILE(&OL/&OF)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&R) VALUE('Y')
             ENDDO
             GOTO       CMDLBL(END)
             ENDDO

             IF         COND(&P2 *EQ *BLANKS) THEN(DO)
             RUNQRY     QRY(&L/&P) QRYFILE(*LIBL/&P0 *LIBL/&P1) +
                        OUTFILE(&OL/&OF)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&R) VALUE('Y')
             ENDDO
             GOTO       CMDLBL(END)
             ENDDO

             IF         COND(&P3 *EQ *BLANKS) THEN(DO)
             RUNQRY     QRY(&L/&P) QRYFILE(*LIBL/&P0 *LIBL/&P1 *LIBL/&P2) +
                        OUTFILE(&OL/&OF)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&R) VALUE('Y')
             ENDDO
             GOTO       CMDLBL(END)
             ENDDO

             IF         COND(&P4 *EQ *BLANKS) THEN(DO)
             RUNQRY     QRY(&L/&P) QRYFILE(*LIBL/&P0 *LIBL/&P1 *LIBL/&P2 +
                        *LIBL/&P3) +
                        OUTFILE(&OL/&OF)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&R) VALUE('Y')
             ENDDO
             GOTO       CMDLBL(END)
             ENDDO

             IF         COND(&P5 *EQ *BLANKS) THEN(DO)
             RUNQRY     QRY(&L/&P) QRYFILE(*LIBL/&P0 *LIBL/&P1 *LIBL/&P2 +
                        *LIBL/&P3 *LIBL/&P4) +
                        OUTFILE(&OL/&OF)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&R) VALUE('Y')
             ENDDO
             GOTO       CMDLBL(END)
             ENDDO

             IF         COND(&P6 *EQ *BLANKS) THEN(DO)
             RUNQRY     QRY(&L/&P) QRYFILE(*LIBL/&P0 *LIBL/&P1 *LIBL/&P2 +
                        *LIBL/&P3 *LIBL/&P4 *LIBL/&P5) +
                        OUTFILE(&OL/&OF)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&R) VALUE('Y')
             ENDDO
             GOTO       CMDLBL(END)
             ENDDO

             IF         COND(&P7 *EQ *BLANKS) THEN(DO)
             RUNQRY     QRY(&L/&P) QRYFILE(*LIBL/&P0 *LIBL/&P1 *LIBL/&P2 +
                        *LIBL/&P3 *LIBL/&P4 *LIBL/&P5 *LIBL/&P6) +
                        OUTFILE(&OL/&OF)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&R) VALUE('Y')
             ENDDO
             GOTO       CMDLBL(END)
             ENDDO

             IF         COND(&P8 *EQ *BLANKS) THEN(DO)
             RUNQRY     QRY(&L/&P) QRYFILE(*LIBL/&P0 *LIBL/&P1 *LIBL/&P2 +
                        *LIBL/&P3 *LIBL/&P4 *LIBL/&P5 *LIBL/&P6 *LIBL/&P7) +
                        OUTFILE(&OL/&OF)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&R) VALUE('Y')
             ENDDO
             GOTO       CMDLBL(END)
             ENDDO

             IF         COND(&P9 *EQ *BLANKS) THEN(DO)
             RUNQRY     QRY(&L/&P) QRYFILE(*LIBL/&P0 *LIBL/&P1 *LIBL/&P2 +
                        *LIBL/&P3 *LIBL/&P4 *LIBL/&P5 *LIBL/&P6 *LIBL/&P7 +
                        *LIBL/&P8) +
                        OUTFILE(&OL/&OF)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&R) VALUE('Y')
             ENDDO
             GOTO       CMDLBL(END)
             ENDDO


             ENDDO

 END:        ENDPGM
