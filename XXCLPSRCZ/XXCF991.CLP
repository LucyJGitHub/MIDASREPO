/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas XX OPNQRYF for Todays  Movement Extract')       */
/*********************************************************************/
/*                                                                   */
/*   Midas - Management Accounts Module                              */
/*                                                                   */
/*   XXCF991 - OPNQRYF for Today's Movement Extract                  */
/*                                                                   */
/*       (C) Copyright Finastra Systems Technology, Inc. 2020        */
/*                                                                   */
/*       Last Amend No. EML108             Date 14Jan20              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       EML108 - Upgrade FMD003 and fixes to FBM2.1SP21             */
/*       UMD001 - Upgrade FMD003 to Midas Plus 1.2.1 SP19            */
/*       231735 - Separate GE-XB postings update to Opening and      */
/*                Closing Balances and Average Balance Calculation.  */
/*   FMD003 - Daily Automatic Balance Update                         */
/*                                                                   */
/*********************************************************************/
/*               C R E A T I O N  P A R A M E T E R S                */
/*                                                                   */
/*********************************************************************/

             PGM        PARM(&GRCD &PBAS &NDAT &SCS &ANL &RTCD)

             DCL        VAR(&BISCPY) TYPE(*CHAR) LEN(64) VALUE('(C) +
                          Copyright Finastra Systems Technology, +
                          Inc. 2020')

             DCL        VAR(&GRCD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PBAS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NDAT) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&RDAT) TYPE(*CHAR) LEN(5)
             DCL        VAR(&SCS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&ANL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OPNQRYF) TYPE(*CHAR) LEN(2000)
             DCL        VAR(&OPQF) TYPE(*CHAR) LEN(2000)
             DCL        VAR(&SECTIONS) TYPE(*CHAR) LEN(16)

             DCL        VAR(&I) TYPE(*DEC) LEN(3 0) VALUE(1)
             DCL        VAR(&J) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&I2) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&J2) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&KU) TYPE(*CHAR) LEN(40) VALUE('ACODCCY +
                          BRCACNUMACSQPRFCBOKCOTTPOTSTASOC')
             DCL        VAR(&KS) TYPE(*CHAR) LEN(40)
             DCL        VAR(&KEYFLD) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(1)

             DCL        VAR(&PKEY) TYPE(*CHAR) LEN(7)
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)
             DCL        VAR(&ERCD) TYPE(*CHAR) LEN(7)

             DCLF       FILE(GLPERDL5) /*        Period file */

/**  Global Monitor Message:                                       */
/**   If an unmonitorred message occurs perform error processing   */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/* Set up copyright                                                  */
             CHGVAR     VAR(&BISCPY) VALUE('(c) Copyright Finastra +
                          Systems Technology, Inc. 2020')

             CLRPFM     FILE(UPWORKX0)
             MONMSG     MSGID(CPF3133)

             CALL       PGM(AOHBCGR0) PARM(&ERCD '*KEY' &GRCD +
                          &DSFDY)
             CHGVAR     VAR(&PKEY) VALUE(%SST(&DSFDY 33 1))
             CALL       PGM(AORPERR0) PARM(&ERCD '*SETLL' &PKEY   +
                          000 &DSFDY)
             RCVF

             CLOF       OPNID(MCWORKX2)
             MONMSG     MSGID(CPF4520)
             CHGVAR     VAR(&OPQF) VALUE('OPNQRYF FILE((GLHIBLPD' +
                          *BCAT &GRCD *TCAT '))')
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'FORMAT(MCWORKX2)')
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'QRYSLT(''HBPDCT *EQ ''''' *TCAT &DTPDCT +
                          *TCAT ''''' *AND HBPDYR *EQ ''''' *TCAT +
                          &DTPDYR *TCAT ''''' *AND HBPDNY *EQ ''''' +
                          *TCAT &DTPDNY *TCAT ''''''')')

/* Set up MAPFLDs */

             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT 'MAPFLD((M2CGCD +
                          HBCGCD) (M2BRCA HBBRCD) (M2CCY HBCYCD) +
                          (M2ACOD HBACCD) (M2CNUM HBCUST) (M2ACSQ +
                          HBACSN) (M2TDOB ''%SUM(HBPDCB)''))')
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT 'GRPFLD(HBCGCD +
                          HBBRCD HBCUST HBACCD HBCYCD HBACSN)')

             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT 'OPNID(MCWORKX2)')

             CALL       PGM(QCMDEXC) PARM(&OPQF 2000)
             CPYFRMQRYF FROMOPNID(MCWORKX2) TOFILE(MCWORKX2) +
                          TOMBR(&GRCD) MBROPT(*REPLACE) FMTOPT(*NOCHK)

             CHGVAR     VAR(&RDAT) VALUE(&NDAT)

/* Set up list of sections to include                                */
             IF         COND(%SST(&SCS 1 1) *EQ 'Y') THEN(CHGVAR +
                          VAR(&SECTIONS) VALUE(&SECTIONS *TCAT 'AS'))
             IF         COND(%SST(&SCS 2 1) *EQ 'Y') THEN(CHGVAR +
                          VAR(&SECTIONS) VALUE(&SECTIONS *TCAT 'LI'))
             IF         COND(%SST(&SCS 3 1) *EQ 'Y') THEN(CHGVAR +
                          VAR(&SECTIONS) VALUE(&SECTIONS *TCAT 'IN'))
             IF         COND(%SST(&SCS 4 1) *EQ 'Y') THEN(CHGVAR +
                          VAR(&SECTIONS) VALUE(&SECTIONS *TCAT 'EX'))
             IF         COND(%SST(&SCS 5 1) *EQ 'Y') THEN(CHGVAR +
                          VAR(&SECTIONS) VALUE(&SECTIONS *TCAT 'CO'))
             IF         COND(%SST(&SCS 6 1) *EQ 'Y') THEN(CHGVAR +
                          VAR(&SECTIONS) VALUE(&SECTIONS *TCAT 'ME'))
             IF         COND(%SST(&SCS 7 1) *EQ 'Y') THEN(CHGVAR +
                          VAR(&SECTIONS) VALUE(&SECTIONS *TCAT 'TR'))
             IF         COND(%SST(&SCS 8 1) *EQ 'Y') THEN(CHGVAR +
                          VAR(&SECTIONS) VALUE(&SECTIONS *TCAT 'CN'))
             CLOF       OPNID(UPWORKX0)
             MONMSG     MSGID(CPF4520)

/* Set up command string for OPNQRYF for UPWORKX0                    */
             CHGVAR     VAR(&OPNQRYF) VALUE('OPNQRYF +
                          FILE((APOSTPD)) FORMAT(UPWORKX0) +
                          QRYSLT(''SECLIST *CT ACSC *AND')

             IF         COND(&GRCD *EQ 'HO') THEN(CHGVAR +
                          VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT 'SPOS +
                          *NE ''''  GE-XB'''' *AND'))

             IF         COND(&PBAS *EQ 'V') THEN(CHGVAR VAR(&OPNQRYF) +
                          VALUE(&OPNQRYF *BCAT 'VALD *EQ' *BCAT +
                          &RDAT *BCAT ''')'))

             IF         COND(&PBAS *EQ 'P') THEN(CHGVAR VAR(&OPNQRYF) +
                          VALUE(&OPNQRYF *BCAT 'PSTD *EQ' *BCAT +
                          &RDAT *BCAT ''')'))

             CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT +
                          'GRPFLD(BRCA CNUM ACOD CCY ACSQ VOIN DRCR +
                           ACSC EVDT)')

             CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT +
                          'KEYFLD(BRCA CNUM ACOD CCY ACSQ)')

             CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT ' +
                          MAPFLD((GRCD ''''''' *CAT &GRCD *TCAT +
                          ''''''') (WAMT ''PSTA - (PSTA * DRCR * +
                          2)'') (SECLIST ''''''' *CAT &SECTIONS +
                          *TCAT ''''''') (EVDT')

             IF         COND(&PBAS *EQ 'P') THEN(CHGVAR +
                          VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT 'PSTD)'))
             ELSE       CMD(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +
                          *BCAT 'VALD)'))

             CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(PAMT +
                          ''%SUM(WAMT)'')) OPNID(UPWORKX0) OPTALLAP(*YES)')

             CALL       PGM(QCMDEXC) PARM(&OPNQRYF 2000)

             CPYFRMQRYF FROMOPNID(UPWORKX0) TOFILE(UPWORKX0) +
                          TOMBR(&GRCD) MBROPT(*REPLACE) FMTOPT(*NOCHK)

             CLOF       OPNID(UPWORKX0)
             MONMSG     MSGID(CPF4520)
             GOTO       CMDLBL(PGMEND)
/**/
/**  Error Processing:                                             */
/**   Dump the program if error occurred in this program           */
/**/
 ABNOR:      DMPCLPGM
             CHGVAR     VAR(&RTCD) VALUE('C')
             CHGJOB     SWS(XXXXXX11)
             SNDMSG     MSG('Job terminated - OPNQRYF for Daily Movement +
                        Extract ended in error') TOMSGQ(MOPERQ MRUNQ)

/**/
/**  End of Program:   */
 PGMEND:
             ENDPGM
