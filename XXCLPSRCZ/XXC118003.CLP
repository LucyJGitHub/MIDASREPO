/*********************************************************************/
/*STD    CLPBASE                                                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       CLP/XXC118003 - Midas SE On-Line Positions Generation       */
/*                                                                   */
/*       Called By: XX118001 - On-Line Positions Generation         */
/*                                                                  */
/*       (c) Finastra International Limited 2022                     */
/*                                                                   */
/*       Last Amend No. HUT118  *CREATE    Date 03Nov22              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       HUT118 - Position Settlements Online Generation             */
/*                                                                   */
/*********************************************************************/

             PGM        PARM(&WSECU &WEDTE &WPDTE &WEVTP &WNPOS &WERR)

/* Declare variables                                                 */
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&WSECU) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WEDTE) TYPE(*CHAR) LEN(5)
             DCL        VAR(&WPDTE) TYPE(*CHAR) LEN(5)
             DCL        VAR(&WEVTP) TYPE(*CHAR) LEN(2)
             DCL        VAR(&WNPOS) TYPE(*DEC) LEN(6)
             DCL        VAR(&WERR) TYPE(*CHAR) LEN(7)

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra Ltd +
                          2020')

/* Declare parameters fo access object AOSARDR0                      */

             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) VALUE('HUT118')
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(60)
             DCL        VAR(&HUT118) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&QRYSEL) TYPE(*CHAR) LEN(100)
 /**/
 /* QRY DEFN */
             DCL        VAR(&QUDEPPD) TYPE(*CHAR) LEN(100) VALUE('UDSN *NE "       -
   " *AND UDDT *LE 00000 *AND RECI *EQ "D"')
             DCL        VAR(&QCDEPPD) TYPE(*CHAR) LEN(100) VALUE('CDSN *NE "       -
   " *AND DDTE *LE 00000 *AND RECI *EQ "D"')
             DCL        VAR(&QSEDEVL3) TYPE(*CHAR) LEN(200)
             DCL        VAR(&QSEDE1) TYPE(*CHAR) LEN(200) VALUE('SDSN *NE "        -
  " *AND LCD *EQ 00000 *AND SDET *EQ "  " *AND SDED *LE +
                          00000 *AND SDPD *LE 00000 *AND SDED *NE 00000 *AND RECI +
                          *EQ "D"') /*247246*/
             DCL        VAR(&QSEDE2) TYPE(*CHAR) LEN(200) VALUE('SDSN *NE "        -
  " *AND LCD *EQ 00000 *AND SDED *LE 00000 *AND SDPD *LE +
                          00000 *AND SDED *NE 00000 *AND RECI *EQ "D" *AND (SDET +
                          *EQ "PP" *OR SDET *EQ "DV" *OR SDET *EQ "MP")')
 /**/
             DCLF       FILE(SDBANKPD)
             RCVF

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO CMDLBL(ABNOR))
/**/
             CHGVAR     VAR(&QRYSEL) VALUE('PDTG *EQ 00000')
             CHGVAR     VAR(%SST(&QRYSEL 10 5)) VALUE(&BJRDNB)

/**/
/* Set up qry selection for UDEPPD */
             CHGVAR     VAR(%SST(&QUDEPPD  37 5)) VALUE(&BJRDNB)
/**/
             IF         COND((&WSECU *NE '          ') *AND (&WSECU *NE '*ALL')) +
                          THEN(DO)
                CHGVAR     VAR(%SST(&QUDEPPD  6 3)) VALUE('*EQ')
                CHGVAR     VAR(%SST(&QUDEPPD  11 10)) VALUE(&WSECU)
             ENDDO
/* Set up qry selection for UDEPPD  - End */
/**/
/* Set up qry selection for CDEPPD */
             CHGVAR     VAR(%SST(&QCDEPPD  37 5)) VALUE(&BJRDNB)
/**/
             IF         COND((&WSECU *NE '          ') *AND (&WSECU *NE '*ALL')) +
                          THEN(DO)
                CHGVAR     VAR(%SST(&QCDEPPD  6 3)) VALUE('*EQ')
                CHGVAR     VAR(%SST(&QCDEPPD  11 10)) VALUE(&WSECU)
             ENDDO
/* Set up qry selection for CDEPPD  - End */
/**/

/**/
/* Set up qry selection for SEDEVL3 - Start */
             CHGVAR     VAR(%SST(&QSEDE1   36 5)) VALUE(&BJRDNB)
             CHGVAR     VAR(%SST(&QSEDE1   75 5)) VALUE(&BJRDNB)
             CHGVAR     VAR(%SST(&QSEDE1   95 5)) VALUE(&BJRDNB)
             CHGVAR     VAR(%SST(&QSEDE2   36 5)) VALUE(&BJRDNB)
             CHGVAR     VAR(%SST(&QSEDE2   56 5)) VALUE(&BJRDNB)
             CHGVAR     VAR(%SST(&QSEDE2   76 5)) VALUE(&BJRDNB)
/**/
             IF         COND((&WSECU *NE '          ') *AND (&WSECU *NE '*ALL')) +
                          THEN(DO)
                CHGVAR     VAR(%SST(&QSEDE1   6 3)) VALUE('*EQ')
                CHGVAR     VAR(%SST(&QSEDE1   11 10)) VALUE(&WSECU)
                CHGVAR     VAR(%SST(&QSEDE2   6 3)) VALUE('*EQ')
                CHGVAR     VAR(%SST(&QSEDE2   11 10)) VALUE(&WSECU)
             ENDDO
/**/
             IF         COND(&WEVTP *NE '  ') THEN(DO)
                CHGVAR     VAR(%SST(&QSEDE1   52 3)) VALUE('*EQ')
                CHGVAR     VAR(%SST(&QSEDE1   57 2)) VALUE(&WEVTP)
             ENDDO
/**/
/* If event date is not blanks, then select for event type */
             IF         COND((&WEDTE *NE '00000') *AND (&WEDTE *NE '     ')) +
                          THEN(DO)
                CHGVAR     VAR(%SST(&QSEDE1   71 3)) VALUE('*EQ')
                CHGVAR     VAR(%SST(&QSEDE1   75 5)) VALUE(&WEDTE)
                CHGVAR     VAR(%SST(&QSEDE2   52 3)) VALUE('*EQ')
                CHGVAR     VAR(%SST(&QSEDE2   56 5)) VALUE(&WEDTE)
             ENDDO
/**/
/* If payment date is not blanks, then select for event type */
             IF         COND((&WPDTE *NE '00000') *AND (&WPDTE *NE '     ')) +
                          THEN(DO)
                CHGVAR     VAR(%SST(&QSEDE1   91 3)) VALUE('*EQ')
                CHGVAR     VAR(%SST(&QSEDE1   95 5)) VALUE(&WPDTE)
                CHGVAR     VAR(%SST(&QSEDE2   72 3)) VALUE('*EQ')
                CHGVAR     VAR(%SST(&QSEDE2   76 5)) VALUE(&WPDTE)
             ENDDO
/**/
             CHGVAR     VAR(&QSEDEVL3) VALUE(&QSEDE2)
/**/
             IF         COND(&WEVTP *NE '  ') THEN(DO)
                CHGVAR     VAR(&QSEDEVL3) VALUE(&QSEDE1)
             ENDDO
/* Set up qry selection for SEDEVL3 - End */
/**/

/* Check if SAR HUT118 is on                                         */

             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &DSFDY)
             IF         COND(&RTCD = '       ') THEN(CHGVAR VAR(&HUT118) +
                          VALUE('Y'))

             IF         COND(&HUT118 = 'Y') THEN(DO)

             CLRPFM     FILE(XXCDUDPP)
             MONMSG     MSGID(CPF0000)

/*********************************************************************/
/* Extraction program                                                */
/*********************************************************************/

             IF         COND((&WSECU *NE '          ') *AND (&WSECU *NE '*ALL')) +
                          THEN(DO)
                OVRDBF     FILE(XXCOUPV1) TOFILE(UDEPPD)
                OPNQRYF    FILE((UDEPPD)) QRYSLT(&QUDEPPD) KEYFLD((UDBA) (UDSN) +
                             (UDPT) (UDDT))
/**/
                OVRDBF     FILE(SECDEPL8) TOFILE(CDEPPD)
                OPNQRYF    FILE((CDEPPD)) QRYSLT(&QCDEPPD) KEYFLD((CDSN))
             ENDDO
/**/
             OVRDBF     FILE(SEDEVL3) TOFILE(SEDEVD)
             OPNQRYF    FILE((SEDEVD)) QRYSLT(&QSEDEVL3) KEYFLD((SDSN) (SDED) +
                          (SDET))
/**/
             CALL       PGM(XX118003) PARM(&WSECU &WEDTE &WPDTE &WEVTP)
/**/
             IF         COND((&WSECU *NE '          ') *AND (&WSECU *NE '*ALL')) +
                          THEN(DO)
                DLTOVR     XXCOUPV1
                CLOF       UDEPPD
             MONMSG     MSGID(CPF4520)
/**/
             DLTOVR     SECDEPL8
             CLOF       CDEPPD
             MONMSG     MSGID(CPF4520)
             ENDDO
/**/
             DLTOVR     SEDEVL3
             CLOF       SEDEVD
             MONMSG     MSGID(CPF4520)
/**/
/* HUT118    END                                                     */

             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))

/*********************************************************************/
/* Generation programs                                               */
/*********************************************************************/

/* Add POSETx overrides                                              */

             OVRDBF     FILE(POSETD) MBR(POSETD) SHARE(*NO)
             OVRDBF     FILE(POSETA) MBR(POSETA) SHARE(*NO)
             OVRDBF     FILE(SEDEV) SHARE(*NO)
             OVRDBF     FILE(SNDEVA) SHARE(*NO)
             OVRDBF     FILE(SECEO2) SHARE(*NO)

/* Generate Position Settlement on Depots.                           */

             CALL       PGM(XX118004) PARM('I' &WSECU &WNPOS)

             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO CMDLBL(ABNOR))

             DLTOVR     FILE(SEDEV)
             DLTOVR     FILE(SNDEVA)
             DLTOVR     FILE(SECEO2)


/* Generate Position Settlement on Customer.                         */

             OVRDBF     FILE(SEEVNT) TOFILE(SECED) SHARE(*NO)
             OVRDBF     FILE(SECET) SHARE(*NO)
             OVRDBF     FILE(SECEO) SHARE(*NO)
             OVRDBF     FILE(SEDEV) SHARE(*NO)
             OVRDBF     FILE(SNDEVA) SHARE(*NO)

             CALL       PGM(XX118008) PARM('I' &WSECU &WNPOS)

             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))

             DLTOVR     FILE(SEEVNT)
             DLTOVR     FILE(SECET )
             DLTOVR     FILE(SECEO )
             DLTOVR     FILE(SEDEV)
             DLTOVR     FILE(SNDEVA)

/* Remove POSETx overrides                                           */

             DLTOVR     FILE(POSETD)
             DLTOVR     FILE(POSETA)

             CLOF       POSETD
             MONMSG     MSGID(CPF4520)
             OPNQRYF    FILE((POSETD)) QRYSLT(&QRYSEL)
             CALL       PGM(XX118007) PARM('I')
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ABNOR)
             CLOF       POSETD
             MONMSG     MSGID(CPF4520)

             ENDDO

/*********************************************************************/
/* Database error processing                                         */
/*********************************************************************/

             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)

                ROLLBACK
                CHGVAR     VAR(&WERR) VALUE('*ERROR')
                GOTO       CMDLBL(END)
             ENDDO

             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                COMMIT
             ENDDO

             GOTO       CMDLBL(END)

 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             ROLLBACK
             CHGVAR     VAR(&WERR) VALUE('*ERROR')

 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra Ltd 2020')

             ENDPGM
