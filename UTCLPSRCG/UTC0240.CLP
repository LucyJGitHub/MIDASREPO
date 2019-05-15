/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT CPP for EDTVAR command')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities module                                    */
/*                                                                   */
/*       UTC0240 - CPP for EDTVAR (Edit variable)                    */
/*                                                                   */
/*      This program is the command-processing program for the       */
/*      EDTVAR command.  The command and program were both lifted    */
/*      from the IBM-supplied QUSRTOOL library of specimen           */
/*      utilities.  As such it is not as thoroughly supplied with    */
/*      comments as it might be.                                     */
/*                                                                   */
/*      Note further that the validity checking is carried out in    */
/*      this program, not in a separate validity cheker.             */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CAA002 *CREATE     Date 31OCT95              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CAA002 - Development of utility to save, edit and restore   */
/*                spooled files.                                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CHARVAR &NUMVAR &NBRDEC &EDTCDE &LDGSYM)
             DCL        VAR(&CHARVAR) TYPE(*CHAR) LEN(22) /* Return +
                          variable */
             DCL        VAR(&NUMVAR) TYPE(*DEC) LEN(15 0) /* Input +
                          variable */
             DCL        VAR(&NUMVAR2) TYPE(*DEC) LEN(15 0) /* Copy +
                          of input */
             DCL        VAR(&NBRDEC) TYPE(*DEC) LEN(1 0) /* Number +
                          of decimals */
             DCL        VAR(&EDTCDE) TYPE(*CHAR) LEN(1) /* Edit code */
             DCL        VAR(&LDGSYM) TYPE(*CHAR) LEN(4) /* Leading +
                          currency sym */
             DCL        VAR(&CURSYM) TYPE(*CHAR) LEN(1)
/* For next 2, assume QDECFMT is 'I' or 'J' */
             DCL        VAR(&DECCHAR) TYPE(*CHAR) LEN(1) VALUE(',')
             DCL        VAR(&SEPCHAR) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&NUMVARC) TYPE(*CHAR) LEN(15) /* Input +
                          as character */
             DCL        VAR(&PRTSW) TYPE(*CHAR) LEN(1) /* Print +
                          switch */
             DCL        VAR(&X) TYPE(*DEC) LEN(3 0) VALUE(1) /* +
                          Input index */
             DCL        VAR(&Y) TYPE(*DEC) LEN(3 0) VALUE(1) /* +
                          Output index */
             DCL        VAR(&Z) TYPE(*DEC) LEN(3 0) /* Separator +
                          index */
             DCL        VAR(&DECFMT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             IF         COND((&EDTCDE *EQ 'W') *OR (&EDTCDE *EQ 'Y') +
                          *OR (&EDTCDE *EQ 'Z')) THEN(DO) /* W Y Z +
                          edit */
                IF         COND(&NBRDEC *NE 0) THEN(SNDPGMMSG +
                             MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('If +
                             EDTCDE is W, Y or Z, the NBRDEC must be +
                             0') MSGTYPE(*ESCAPE))
             ENDDO      /* W Y Z edit */
             CHGVAR     VAR(&CHARVAR) VALUE(' ') /* Initialize +
                          return var */
 
/* If K M or Z edit, check 0 value */
             IF         COND((&EDTCDE *EQ 'K') *OR (&EDTCDE *EQ 'M') +
                          *OR (&EDTCDE *EQ 'Z')) THEN(DO) /* K M Z +
                          edit */
                IF         COND(&NUMVAR *EQ 0) THEN(GOTO CMDLBL(ENDPGM))
             ENDDO      /* K M Z edit code */
 
/* Rtv decimal format and set values */
             RTVSYSVAL  SYSVAL(QDECFMT) RTNVAR(&DECFMT)
             IF         COND(&DECFMT *EQ ' ') THEN(DO)
                CHGVAR     VAR(&DECCHAR) VALUE('.')
                CHGVAR     VAR(&SEPCHAR) VALUE(',')
             ENDDO
 
/* Initialize work area and index */
             CHGVAR     VAR(&Z) VALUE(1 + &NBRDEC) /* Separator +
                          index */
             CHGVAR     VAR(&NUMVAR2) VALUE(&NUMVAR) /* Work +
                          variable */
             IF         COND(&NUMVAR *LT 0) THEN(CHGVAR +
                          VAR(&NUMVAR2) VALUE(0 - &NUMVAR)) /* Make +
                          positive */
             CHGVAR     VAR(&NUMVARC) VALUE(&NUMVAR2) /* Make into +
                          character */
                        /* Put in currency symbol if needed */
             IF         COND(&LDGSYM *EQ '*YES') THEN(DO) /* +
                          Currency symbol */
                RTVSYSVAL  SYSVAL(QCURSYM) RTNVAR(&CURSYM)
                CHGVAR     VAR(%SST(&CHARVAR &Y 1)) VALUE(&CURSYM) /* +
                             Insert */
                CHGVAR     VAR(&Y) VALUE(&Y + 1) /* Bump output index */
             ENDDO      /* Currency symbol */
 
/* Move one character at a time */
 LOOP:       IF         COND((16 - &X) *EQ &NBRDEC) THEN(DO) /* +
                          Decimal place */
                CHGVAR     VAR(%SST(&CHARVAR &Y 1)) VALUE(&DECCHAR) /* +
                             Insert dec */
                CHGVAR     VAR(&Y) VALUE(&Y + 1) /* Bump output index */
                CHGVAR     VAR(&PRTSW) VALUE('Y') /* Set to print */
             ENDDO      /* Decimal place */
             IF         COND(&DECFMT *EQ 'J') THEN(DO) /* J format - +
                          ldg 0 */
                IF         COND((15 - &X) *EQ &NBRDEC) THEN(CHGVAR +
                             VAR(&PRTSW) VALUE('Y'))
             ENDDO      /* J format ldg 0 */
 
/* If EDTCDE W or Y set prt switch after 1st */
             IF         COND((&EDTCDE *EQ 'W') *OR (&EDTCDE *EQ +
                          'Y')) THEN(DO)
                IF         COND(&Z *EQ 11) THEN(CHGVAR VAR(&PRTSW) +
                             VALUE('Y'))
             ENDDO      /* W or Y edit code */
             IF         COND((&PRTSW *EQ 'Y') *OR (%SST(&NUMVARC &X +
                          1) *NE '0')) THEN(DO) /* Prt */
                CHGVAR     VAR(%SST(&CHARVAR &Y 1)) VALUE(%SST(&NUMVARC +
                             &X 1))
                CHGVAR     VAR(&Y) VALUE(&Y + 1) /* Bump output index */
                CHGVAR     VAR(&PRTSW) VALUE('Y') /* Set on the print +
                             switch */
                           /* Put in separator character for J and K */
                IF         COND((&EDTCDE *EQ 'J') *OR (&EDTCDE *EQ +
                             'K')) THEN(DO)
                   IF         COND((&Z *EQ 3) *OR (&Z *EQ 6) *OR (&Z *EQ +
                                9) *OR (&Z *EQ 12)) THEN(DO) /* Separator +
                                loc */
                      CHGVAR     VAR(%SST(&CHARVAR &Y 1)) VALUE(&SEPCHAR) /* +
                                   Sep char */
                      IF         COND(&SEPCHAR *NE ' ') THEN(CHGVAR VAR(&Y) +
                                   VALUE(&Y + 1))
                   ENDDO      /* Separator loc */
                ENDDO      /* Use separator symbol */
 
/* Insert date or time separator if needed */
                IF         COND((&EDTCDE *EQ 'W') *OR (&EDTCDE *EQ +
                             'Y')) THEN(DO)
                   IF         COND((&Z *EQ 11) *OR (&Z *EQ 13)) THEN(DO) +
                                /* Date sep */
                      IF         COND(&EDTCDE *EQ W) THEN(CHGVAR +
                                   VAR(%SST(&CHARVAR &Y 1)) VALUE(':'))
                      IF         COND(&EDTCDE *EQ Y) THEN(CHGVAR +
                                   VAR(%SST(&CHARVAR &Y 1)) VALUE('/'))
                      CHGVAR     VAR(&Y) VALUE(&Y + 1) /* Next output +
                                   position */
                   ENDDO      /* Separator loc */
                ENDDO      /* Date or time separator */
             ENDDO      /* Print */
             CHGVAR     VAR(&Z) VALUE(&Z + 1) /* Bump separator +
                          symbol index */
             CHGVAR     VAR(&X) VALUE(&X + 1) /* Input index */
                        /* Force one zero in units position */
             IF         COND(&X *EQ 15) THEN(CHGVAR VAR(&PRTSW) +
                          VALUE('Y')) /* Force last */
             IF         COND(&X *NE 16) THEN(GOTO CMDLBL(LOOP)) /* +
                          Next character */
                        /* If variable is negative, insert minus */
             IF         COND(&NUMVAR *LT 0) THEN(CHGVAR +
                          VAR(%SST(&CHARVAR &Y 1)) VALUE('-'))
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
