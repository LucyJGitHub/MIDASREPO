/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas XX OPNQRYF for XXF691')                         */
/*********************************************************************/
/*                                                                   */
/*   Midas - Management Accounts Module                              */
/*                                                                   */
/*   XXCF691 - OPNQRYF for XXF691                                    */
/*                                                                   */
/*       (C) Copyright Finastra Systems Technology, Inc. 2020        */
/*                                                                   */
/*       Last Amend No. EML108            Date 14Jan20               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*   EML108 - Upgrade FMD003 and fixes to FBM2.1SP21                 */
/*   UMD001 - Upgrade FMD003 to Midas Plus 1.2.1 SP19                */
/*   230735 - OPNQRYF for XXF691 - to add new records from SDACRCPD  */
/*                                                                   */
/*********************************************************************/

             PGM        PARM(&GRCD &PBAS &SCS &RDNB &RSNO &RSCD &ACCD &RTCD)

             DCL        VAR(&BISCPY) TYPE(*CHAR) LEN(64) VALUE('(C) +
                          Copyright Finastra Systems Technology, +
                          Inc. 2020')

             DCL        VAR(&GRCD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PBAS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SCS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RDNB) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&RSNO) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RSCD) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ACCD) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(1)

             DCL        VAR(&CCSOYD) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PRVYRN) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&PRVYR) TYPE(*CHAR) LEN(5)
             DCL        VAR(&CRDNB) TYPE(*CHAR) LEN(5)
             DCL        VAR(&OPQF) TYPE(*CHAR) LEN(2000)
             DCL        VAR(&SECTIONS) TYPE(*CHAR) LEN(16)
             DCL        VAR(&PKEY) TYPE(*CHAR) LEN(7)
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)
             DCL        VAR(&ERCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&NRRCD) TYPE(*DEC) LEN(10 0)

             DCLF       FILE(GLPERDL5) /*        Period file */

/**  Global Monitor Message:                                       */
/**   If an unmonitorred message occurs perform error processing   */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/* Set up copyright                                                  */
             CHGVAR     VAR(&BISCPY) VALUE('(C) Copyright Finastra +
                          Systems Technology, Inc. 2020')

             CLRPFM     FILE(UPWORKX0)
             MONMSG     MSGID(CPF3133)

             CALL       PGM(AOHBCGR0) PARM(&ERCD '*KEY' &GRCD +
                          &DSFDY)
             IF         COND(&ERCD *NE '       ') THEN(GOTO +
                          CMDLBL(ABNOR))
             CHGVAR     VAR(&PKEY) VALUE(%SST(&DSFDY 33 1))
             CALL       PGM(AORPERR0) PARM(&ERCD '*SETLL' &PKEY   +
                          000 &DSFDY)
             IF         COND(&ERCD *NE '       ') THEN(GOTO +
                          CMDLBL(ABNOR))
             CHGVAR     VAR(&CRDNB) VALUE(&RDNB)

             RCVF

             CHGVAR     VAR(&CCSOYD) VALUE(&DTSOYD)
             CHGVAR     VAR(&PRVYRN) VALUE(&DTSOYD - 1)
             CHGVAR     VAR(&PRVYR) VALUE(&PRVYRN)

             CLOF       OPNID(MCWORKX1)
             MONMSG     MSGID(CPF4520)
             CHGVAR     VAR(&OPQF) VALUE('OPNQRYF FILE((ACCNTAB))')
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'FORMAT(MCWORKX1)')
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'QRYSLT(''ACOD *EQ ' *CAT &ACCD *CAT +
                          ''')')

/* Set up MAPFLDs */
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT 'MAPFLD((MBRCA +
                          BRCA) (MCCY CCY) (MACOD ACOD) (MCNUM +
                          CNUM) (MACSQ ACSQ))')
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT 'GRPFLD(BRCA +
                          CNUM ACOD CCY ACSQ)')
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'KEYFLD(BRCA CNUM CCY ACOD ACSQ)')
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT 'OPNID(MCWORKX1)')

             CALL       PGM(QCMDEXC) PARM(&OPQF 2000)
             CPYFRMQRYF FROMOPNID(MCWORKX1) TOFILE(MCWORKX1) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)

             CLOF       OPNID(MCWORKX2)
             MONMSG     MSGID(CPF4520)

             CHGVAR     VAR(&OPQF) VALUE(*BLANKS)

             CHGVAR     VAR(&OPQF) VALUE('OPNQRYF FILE((GLHIBLPD' +
                          *BCAT &GRCD *TCAT '))')
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'FORMAT(MCWORKX2)')
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'QRYSLT(''HBEPDD *EQ ' *CAT &PRVYR *CAT ' +
                          *AND HBACCD *EQ ''''' *CAT &ACCD *CAT ''''''')')

/* Set up MAPFLDs */
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT 'MAPFLD((M2CGCD +
                          HBCGCD) (M2BRCA HBBRCD) (M2CCY HBCYCD) +
                          (M2ACOD HBACCD) (M2CNUM HBCUST) (M2ACSQ +
                          HBACSN)  (M2TDOB ''%SUM(HBPDCB)''))')
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT 'GRPFLD(HBCGCD +
                          HBBRCD HBCUST HBACCD HBCYCD HBACSN)')

             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT 'OPNID(MCWORKX2)')

             CALL       PGM(QCMDEXC) PARM(&OPQF 2000)
             CPYFRMQRYF FROMOPNID(MCWORKX2) TOFILE(MCWORKX2) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)


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

             CHGVAR     VAR(&OPQF) VALUE(*BLANKS)
/* Set up command string for OPNQRYF for UPWORKX0                    */
             CHGVAR     VAR(&OPQF) VALUE('OPNQRYF FILE((GLACPHPD)) +
                          FORMAT(UPWORKX0) QRYSLT(''(SECLIST *CT +
                          ACSC *AND')

             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT 'ACOD *EQ ' +
                          *CAT &ACCD *CAT ' *AND')

             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT 'EVDT *GE' +
                          *BCAT &CCSOYD *BCAT '*AND EVDT *LT' *BCAT +
                          &CRDNB *CAT ')')

             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT '*OR +
                          (ACSC *EQ ''''  '''' *AND PTIM *EQ 0 *AND')

             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT 'EVDT *GE' +
                          *BCAT &CCSOYD *BCAT '*AND EVDT *LT' *BCAT +
                          &CRDNB *CAT ')'')')

             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'GRPFLD(BRCA CNUM ACOD CCY ACSQ VOIN DRCR +
                          ACSC EVDT)')

             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'KEYFLD(BRCA CNUM CCY ACOD ACSQ EVDT)')

             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT ' +
                          MAPFLD((GRCD ''''''' *CAT &GRCD *TCAT +
                          ''''''') (WAMT ''PSTA - (PSTA * DRCR * +
                          2)'') (SECLIST ''''''' *CAT &SECTIONS +
                          *TCAT ''''''') (EVDT')

             IF         COND(&PBAS *EQ 'P') THEN(CHGVAR +
                          VAR(&OPQF) VALUE(&OPQF *BCAT 'PSTD)'))
             ELSE       CMD(CHGVAR VAR(&OPQF) VALUE(&OPQF +
                          *BCAT 'VALD)'))

             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT '(PAMT +
                          ''%SUM(WAMT)'')) OPNID(UPWORKX0) OPTALLAP(*YES)')

             CALL       PGM(QCMDEXC) PARM(&OPQF 2000)

             CPYFRMQRYF FROMOPNID(UPWORKX0) TOFILE(UPWORKX0) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)

             CLOF       OPNID(UPWORKX0)
             MONMSG     MSGID(CPF4520)

             CHGVAR     VAR(%SST(&OPQF 15 8)) VALUE('APOSTPD ')

             CALL       PGM(QCMDEXC) PARM(&OPQF 2000)

             CPYFRMQRYF FROMOPNID(UPWORKX0) TOFILE(UPWORKX0) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)
             CLOF       OPNID(UPWORKX0)
             MONMSG     MSGID(CPF4520)

             CHGVAR     VAR(&OPQF) VALUE(*BLANKS)
             CHGVAR     VAR(&OPQF) VALUE('OPNQRYF +
                          FILE(UPWORKX0)')
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'KEYFLD(BRCA CNUM CCY ACOD ACSQ EVDT)')
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'OPNID(UPWORKX0) OPTALLAP(*YES)')
             CALL       PGM(QCMDEXC) PARM(&OPQF 2000)
             CPYFRMQRYF FROMOPNID(UPWORKX0) TOFILE(UPWORKX1) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             CLOF       OPNID(UPWORKX0)
             MONMSG     MSGID(CPF4520)

             RTVMBRD    FILE(MCWORKX1) NBRCURRCD(&NRRCD)
             IF         COND(&NRRCD *NE 0) THEN(CALL PGM(XXF691) +
                          PARM(&GRCD &DTSPDD &DTEPDD &DTST1D +
                          &DTST2D &DTSOYD &RSNO &RTCD))
             DLTOVR     FILE(*ALL)
             IF         COND(&RTCD *NE ' ') THEN(GOTO CMDLBL(ABNOR))

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
