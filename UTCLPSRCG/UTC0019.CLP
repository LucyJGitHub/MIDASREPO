/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT CHKAPOST main program')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas     Utilities Module                                  */
/*                                                                   */
/*       UTC0019 - Check apostrophe                                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK018  *MOVED     Date 26Apr04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01516             Date 18Jul94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK018 - MidasPlus packaging.  Moved to global layer.       */
/*       S01516 - Incorporation of enhanced CRTOBJ into core         */
/*                                                                   */
/*********************************************************************/
/* TAACLPMC - Check apostrophe - CPP for CHKAPOST   */
             PGM        PARM(&VAR &RTNVAR)
             DCL        &VAR *CHAR LEN(500)
             DCL        &RTNVAR *CHAR LEN(500)
             DCL        &WRKVAR *CHAR LEN(500)
             DCL        &APOST *CHAR LEN(1) VALUE('''')
             DCL        &APOST2 *CHAR LEN(2) VALUE('''''')
             DCL        &IX *DEC LEN(3 0)
             DCL        &OX *DEC LEN(3 0)
             DCL        &LASTCHAR *DEC LEN(3 0)
             DCL        &ERRORSW *LGL                     /* Std err */
             DCL        &MSGID *CHAR LEN(7)               /* Std err */
             DCL        &MSGDTA *CHAR LEN(100)            /* Std err */
             DCL        &MSGF *CHAR LEN(10)               /* Std err */
             DCL        &MSGFLIB *CHAR LEN(10)            /* Std err */
             DCL        &KEYVAR *CHAR LEN(4)              /* Std err */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO STDERR1) /* Std err */
             CHGVAR     &RTNVAR ' ' /* Inlz output to blank */
             IF         (&VAR *EQ ' ') GOTO ENDPGM /* All blank */
             CHGVAR     &WRKVAR &VAR
             CHGVAR     &IX 500 /* Set to rightmost */
 SCANRGT:               /* Scan right for first character */
             IF         (%SST(&WRKVAR &IX 1) *EQ ' ') DO /* If blank */
             CHGVAR     &IX (&IX - 1)
             GOTO       SCANRGT
             ENDDO      /* If blank */
 CHKRGT:                /* Blank out trailing apostrophes */
             IF         (%SST(&WRKVAR &IX 1) *EQ &APOST) DO /* Apost */
             CHGVAR     %SST(&WRKVAR &IX 1) ' ' /* Set to blank */
             CHGVAR     &IX (&IX - 1)
             IF         (&IX *NE 0) GOTO CHKRGT
             ENDDO      /* Apostrophe */
             CHGVAR     &LASTCHAR &IX /* Save last good char loc */
             CHGVAR     &IX 1
 CHKLFT:                /* Blank out leading apostrophes */
             IF         (%SST(&WRKVAR &IX 1) *EQ &APOST) DO /* Apost */
             CHGVAR     %SST(&WRKVAR &IX 1) ' ' /* Set to blank */
             CHGVAR     &IX (&IX + 1)
             IF         (&IX *NE &LASTCHAR) GOTO CHKLFT
             ENDDO      /* Apostrophe */
             CHGVAR     &OX 1
 CHKMOV:                /* Move to output area and ensure bal apost */
             IF         (%SST(&WRKVAR &IX 1) *NE &APOST) DO /* Char */
             CHGVAR     %SST(&RTNVAR &OX 1) %SST(&WRKVAR &IX 1)
             CHGVAR     &IX (&IX + 1)
             CHGVAR     &OX (&OX + 1)
             GOTO       CHKEND
             ENDDO      /* Char */
             IF         (%SST(&WRKVAR &IX 2) *EQ &APOST2) DO
             CHGVAR     %SST(&RTNVAR &OX 2) %SST(&WRKVAR &IX 2)
             CHGVAR     &IX (&IX + 2)
             CHGVAR     &OX (&OX + 2)
             GOTO       CHKEND
             ENDDO      /* 2 Apostrophes */
                        /* Insert double when single is found */
             CHGVAR     %SST(&RTNVAR &OX 2) &APOST2
             CHGVAR     &IX (&IX + 1)
             CHGVAR     &OX (&OX + 2)
 CHKEND:                /* Check for end of record */
             IF         (&OX *NE 501) DO /* Not end of output */
             IF         (&IX *LE &LASTCHAR) GOTO CHKMOV
             ENDDO      /* Not end of output */
 ENDPGM:     RETURN     /* Normal end of program */
 STDERR1:               /* Standard error handling routine */
             IF         &ERRORSW SNDPGMMSG MSGID(CPF9999) +
                          MSGF(QCPFMSG) MSGTYPE(*ESCAPE) /* Func chk */
             CHGVAR     &ERRORSW '1' /* Set to fail if error occurs */
 STDERR2:    RCVMSG     MSGTYPE(*DIAG) RMV(*NO) KEYVAR(&KEYVAR) +
                          MSGDTA(&MSGDTA) MSGID(&MSGID) MSGF(&MSGF) +
                          SNDMSGFLIB(&MSGFLIB)
             IF         (&KEYVAR *EQ '    ') GOTO STDERR3
             RMVMSG     MSGKEY(&KEYVAR)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*DIAG)
             GOTO       STDERR2 /* Loop back for addl diagnostics */
 STDERR3:    RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF) SNDMSGFLIB(&MSGFLIB)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*ESCAPE)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
