/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas XX Management Account Balances')                */
/********************************************************************/
/*                                                                  */
/*       Midas Management Accounts Module                           */
/*                                                                  */
/*       XXCF84B - Management Account Balances                      */
/*                                                                  */
/*       (C) Copyright Finastra Systems Technology, Inc. 2020       */
/*                                                                  */
/*       Last Amend No. EML108             Date 14Jan20             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       EML108 - Upgrade FMD003 and fixes to FBM2.1SP21            */
/*       UMD001 - Upgrade FMD003 to Midas Plus 1.2.1 SP19           */
/*                Apply same coding than CGL029 from CLP/MCC84      */
/*       FMD003 - Management Accounts Automatic Balance Update      */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&RLEV &RENT &RPARM &DTPDCT &DTPDYR +
                          &DTPDNY &CCCY)
/**/
             DCL        VAR(&BISCPY) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Copyright Finastra System Technology, +
                          Inc. 2020')
/**/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
/**/
             DCL        VAR(&CCY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RSNO) TYPE(*CHAR) LEN(1)
/**/
             DCL        VAR(&OPQF) TYPE(*CHAR) LEN(1500)
             DCL        VAR(&DTPDCT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DTPDYR) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DTPDNY) TYPE(*CHAR) LEN(2)

             DCL        VAR(&MCGRP) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MCRPNC) TYPE(*CHAR) LEN(4) VALUE('    ')
             DCL        VAR(&MCRPNB) TYPE(*DEC) LEN(3) VALUE(0)
             DCL        VAR(&MCTRM1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&I) TYPE(*DEC) LEN(3 0) VALUE(1)
             DCL        VAR(&J) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&WLIST) TYPE(*CHAR) LEN(300)
             DCL        VAR(&FLAG) TYPE(*LGL) VALUE('0')
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PKEY) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CCCY) TYPE(*CHAR) LEN(3)
             DCL        VAR(&ENAM1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ENAM5) TYPE(*CHAR) LEN(10)

             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)

             CHGVAR     VAR(&BISCPY) VALUE('(C) Copyright Finastra +
                          Systems Technology, Inc. 2020')
/**/
             CHGJOB     SWS(XXXXXX00)
             CHGVAR     VAR(&CCY) VALUE(%SST(&RPARM 1 1))
             CHGVAR     VAR(&RSNO) VALUE(%SST(&RPARM 2 1))
             CHGVAR     VAR(&MCGRP) VALUE(%SST(&RPARM 5 2))
             CHGVAR     VAR(&MCRPNC) VALUE(%SST(&RPARM 7 4))
             CHGVAR     VAR(&MCTRM1) VALUE(%SST(&RPARM 11 1))
             CHGVAR     VAR(&ENAM1) VALUE('0')
             IF         COND(&MCTRM1 *EQ 'P') THEN(DO)
               CHGVAR     VAR(&ENAM1) VALUE('HBPDOB')
             ENDDO
            CHGVAR     VAR(&ENAM5) VALUE('HBPDCB')
            IF         COND(&ENAM1 *EQ ' ') THEN(CHGVAR VAR(&ENAM1) +
                         VALUE('0'))
            IF         COND(&ENAM5 *EQ ' ') THEN(CHGVAR VAR(&ENAM5) +
                         VALUE('0'))

             CLRPFM     FILE(MCBLRPX0)
             CLRPFM     FILE(MCBLRPX1)
             CLRPFM     FILE(MCBLRPX2)
/* Set up OPNQRYF parameter for QCMDEXC */
             CHGVAR     VAR(&OPQF) VALUE('OPNQRYF')

/* Set up files to use (use GLHIBLPD and GLAVBLPD member for group code). Join to */
/* SDACRCPD for report set if report set parameter is not 'C', and   */
/* to SDBRCHL1 for company if report level is 'C'.                   */
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'FILE((GLHIBLPD' *BCAT &MCGRP *TCAT ')) +
                          FORMAT(MCBLRPX1)')
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'QRYSLT(''HBPDCT *EQ ''''' *TCAT &DTPDCT +
                          *TCAT ''''' *AND HBPDYR *EQ ''''' *TCAT +
                          &DTPDYR *TCAT ''''' *AND HBPDNY *EQ ''''' +
                          *TCAT &DTPDNY *TCAT ''''''')')
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'GRPFLD(HBBRCD HBCUST HBCYCD HBACCD +
                          HBACSN)')
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'KEYFLD(G1BRCD G1CUST G1CCY G1ACCD +
                          G1ACSN)')
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT 'MAPFLD((G1BRCD +
                          HBBRCD) (G1CUST HBCUST) (G1ACCD HBACCD) +
                          (G1CCY HBCYCD) (G1ACSN HBACSN) (G1LDB1 +
                          ''%SUM(' *TCAT &ENAM1 *TCAT ')'') +
                          (G1LDB5 ''%SUM(' *TCAT &ENAM5 *TCAT ')'') +
                          (G1RTYP ''''''' *TCAT &MCTRM1 *TCAT '''''''))')

             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT 'OPNID(ACCNTAB)')
             CALL       PGM(QCMDEXC) PARM(&OPQF 1500)
             CPYFRMQRYF FROMOPNID(ACCNTAB) TOFILE(MCBLRPX1) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             CLOF       OPNID(ACCNTAB)
             MONMSG     MSGID(CPF5420)

             OVRDBF     FILE(MCAVBLV0) MBR(&MCGRP)
             IF         COND(&RSNO *NE 'C') THEN(CALL PGM(XXF992) +
                          PARM(&MCGRP &RSNO))
             DLTOVR     FILE(MCAVBLV0)
/* Set up OPNQRYF parameter for QCMDEXC */
             CHGVAR     VAR(&OPQF) VALUE('OPNQRYF')

/* Set up files to use (use GLHIBLPD and GLAVBLPD member for group code). Join to */
/* SDACRCPD for report set if report set parameter is not 'C', and   */
/* to SDBRCHL1 for company if report level is 'C'.                   */
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'FILE((MCBLRPX2)')
             IF         COND(&RLEV *EQ 'C') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT '(SDBRCHPD)'))
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *TCAT ')')
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'FORMAT(MCBLRPX0)')

/* If report level is 'B' or 'C', and entity is not blank or 'ALL'   */
/* select entity = entity parameter                                  */
             IF         COND(&RENT *NE 'ALL' *AND &RENT *NE '   ' +
                          *AND (&RLEV *EQ 'B' *OR &RLEV *EQ 'C')) +
                          THEN(CHGVAR VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'QRYSLT(''GLENTY *EQ ''''' *TCAT &RENT *TCAT +
                          ''''''')'))

/* Set up key depending on value in currency field                   */
             IF         COND(&CCY *EQ 'A') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT 'KEYFLD((GLENTY) +
                          (GLCCY) (GLRSCD) (GLENT2))'))
             ELSE       CMD(CHGVAR VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'KEYFLD((GLENTY) (GLRSCD) (GLENT2) +
                          (GLCCY))'))

/* Join files as follows:                                            */
/*    If report level is 'C', get company from SDBRCHPD              */
/*    Branch    : HBBRCD in GLHIBLPD to A8BRCD in SDBRCHPD           */

             IF         COND(&RLEV *EQ 'C') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT 'JFLD((G2BRCD A8BRCD))'))

/* Group company, branch or entity 1 depending on value of report   */
/* level                                                            */
             IF         COND(&RLEV *EQ 'C') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT 'GRPFLD(A8CMCD'))
             IF         COND(&RLEV *EQ 'B') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT 'GRPFLD(G2BRCD'))
             IF         COND(&RLEV *NE 'B' *AND &RLEV *NE 'C') +
                          THEN(CHGVAR VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'GRPFLD(GLENTY'))

/* Group on Currency if in Actual Currency                          */
             IF         COND(&CCY *EQ 'A') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT 'G2CCY'))

/* Group on either account code or report code depending on whether */
/* report set is 'C' or not.                                        */
             IF         COND(&RSNO *EQ 'C') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT 'G2ACCD GLENT2'))
             ELSE       CMD(CHGVAR VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'G2RSCD GLENT2'))

/* Group on Currency if NOT in Actual Currency                      */
             IF         COND(&CCY *NE 'A') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT 'G2CCY'))

             CHGVAR     VAR(&OPQF) VALUE(&OPQF *TCAT ')')

/* Set up MAPFLDs */
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT 'MAPFLD(')

/* If report level is 'B', set entity 1 as branch code               */
/* If report level is 'C', set entity 1 as company code              */
/* Else set entity 1 to blanks                                       */
             IF         COND(&RLEV *EQ 'B') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *TCAT '(GLENTY G2BRCD)'))
             IF         COND(&RLEV *EQ 'C') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *TCAT '(GLENTY A8CMCD)'))
             IF         COND(&RLEV *NE 'B' *AND &RLEV *NE 'C') +
                          THEN(CHGVAR VAR(&OPQF) VALUE(&OPQF *TCAT +
                          '(GLENTY ''''''   '''''')'))

/* Set up MAPFLD for entity 2 from 'analysis' parameter - */

             IF         COND(&CCY *EQ 'A') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT '(GLENT2 ''' *TCAT +
                          G2CCY *TCAT ''')'))
             ELSE       CMD(CHGVAR VAR(&OPQF) VALUE(&OPQF *BCAT +
                          '(GLENT2 '''''' '''''')'))

/* Report code from GLHIBLPD or SDACRCPD depending on report set */
             IF         COND(&RSNO *EQ 'C') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT '(GLRSCD G2ACCD)'))
             ELSE       CMD(CHGVAR VAR(&OPQF) VALUE(&OPQF *BCAT +
                          '(GLRSCD G2RSCD)'))

/* Currency from GLHIBLPD */
             IF         COND(&CCCY *EQ '   ') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT '(GLCCY G2CCY)'))
             ELSE       CMD(CHGVAR VAR(&OPQF) VALUE(&OPQF *BCAT +
                          '(GLCCY ''''''' *TCAT &CCCY *TCAT ''''''')'))

/* Amount is sum of calculated amounts */
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT '(GLLDB1 +
                          ''%SUM(G2LDB1)'') (GLLDB2 ''%SUM(G2LDB2)'') +
                           (GLLDB3 ''%SUM(G2LDB3)'') (GLLDB4 +
                          ''%SUM(G2LDB4)'') (GLLDB5 ''%SUM(G2LDB5)'')')
                 CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT '(GLRTYP ''''''' +
                              *TCAT &MCTRM1 *TCAT ''''''')')

/* End MAPFLD string */
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *TCAT ')')

/* Set OPNID as ACCNTAB */
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT 'OPNID(ACCNTAB)')

             CALL       PGM(QCMDEXC) PARM(&OPQF 1500)

             CPYFRMQRYF FROMOPNID(ACCNTAB) TOFILE(MCBLRPX0) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             CLOF       OPNID(ACCNTAB)
             GOTO       CMDLBL(END)

 ABNOR:      SNDPGMMSG  MSG('Balance Sheet/P & L Reporting ENDED +
                          ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
END:         ENDPGM
