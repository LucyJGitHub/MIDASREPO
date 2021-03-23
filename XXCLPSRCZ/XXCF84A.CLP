/********************************************************************/
/*STD    CLPBASE                                                    */
/*EXI    TEXT('Midas XX Management Account Balances')               */
/********************************************************************/
/*                                                                  */
/*       Midas Management Accounts Module                           */
/*                                                                  */
/*       XXCF84A - Management Account Balances                      */
/*                                                                  */
/*       (C) Copyright Finastra Systems Technology, Inc. 2020       */
/*                                                                  */
/*       Last Amend No  EML108             Date 14Jan20             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       EML108 - Upgrade FMD103 and fixes to FBM2.1SP21            */
/*       UMD001 - Upgrade FMD003 to Midas Plus 1.2.1 SP19           */
/*       FMD003 - Management Accounts Automatic Balance Update      */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&RLEV &RENT &RPARM &CCCY)
/**/
             DCL        VAR(&BISCPY) TYPE(*CHAR) LEN(64) VALUE('(C) +
                          Copyright Finastra Systems Technology, +
                          Inc 2020')
/**/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
/**/
             DCL        VAR(&CCY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RSNO) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SNO) TYPE(*CHAR) LEN(1)
/**/
             DCL        VAR(&OPQF) TYPE(*CHAR) LEN(1500)

             DCL        VAR(&MCGRP) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MCTRM1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&I) TYPE(*DEC) LEN(3 0) VALUE(1)
             DCL        VAR(&J) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&WLIST) TYPE(*CHAR) LEN(300)
             DCL        VAR(&FLAG) TYPE(*LGL) VALUE('0')
             DCL        VAR(&CCCY) TYPE(*CHAR) LEN(3)

             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             CHGVAR     VAR(&BISCPY) VALUE('(c) Copyright Finastra +
                          Systems Technology, Inc. 2020')
/**/
             CHGJOB     SWS(XXXXXX00)
             CHGVAR     VAR(&CCY) VALUE(%SST(&RPARM 1 1))
             CHGVAR     VAR(&RSNO) VALUE(%SST(&RPARM 2 1))
             CHGVAR     VAR(&MCGRP) VALUE(%SST(&RPARM 5 2))
             CHGVAR     VAR(&MCTRM1) VALUE(%SST(&RPARM 11 1))
             IF         COND(&RSNO *EQ 'C') THEN(CHGVAR VAR(&SNO) +
                          VALUE('1'))
             ELSE       CMD(CHGVAR VAR(&SNO) VALUE(&RSNO))

             CLRPFM     FILE(MCBLRPX0)
             CLOF       OPNID(ACCNTAB)
             MONMSG     MSGID(CPF4520)

             CHGVAR     VAR(&OPQF) VALUE(*BLANKS)
             CHGVAR     VAR(&OPQF) VALUE('OPNQRYF')

             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'FILE((MCWORKX0' *BCAT &MCGRP *TCAT ')')

             IF         COND(&RLEV *EQ 'C') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT '(SDBRCHPD)'))

             CHGVAR     VAR(&OPQF) VALUE(&OPQF *TCAT ')')

             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'FORMAT(MCBLRPX0)')

/* Set up query selection string */
             IF         COND(&RENT *NE 'ALL' *AND &RENT *NE '   ' +
                          *AND (&RLEV *EQ 'B' *OR &RLEV *EQ 'C')) +
                          THEN(CHGVAR VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'QRYSLT(''GLENTY *EQ ''''' *TCAT &RENT +
                          *TCAT ''''' *AND M0RSNO *EQ ''''' *TCAT &SNO +
                          *TCAT ''''''')'))
             ELSE       CMD(CHGVAR VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'QRYSLT(''M0RSNO *EQ ''''' *TCAT &SNO +
                          *TCAT ''''''')'))

/* Set up key depending on value in currency field                   */
             IF         COND(&CCY *EQ 'A') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT 'KEYFLD((GLENTY) +
                          (GLCCY) (GLRSCD) (GLENT2))'))
             ELSE       CMD(CHGVAR VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'KEYFLD((GLENTY) (GLRSCD) (GLENT2) +
                          (GLCCY))'))

/* Join files as follows:                                            */

             IF         COND(&RLEV *EQ 'C') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT 'JFLD((M0BRCA A8BRCD))'))

/* Group company, branch or entity 1 depending on value of report   */
/* level                                                            */
             IF         COND(&RLEV *EQ 'C') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT 'GRPFLD(A8CMCD'))
             IF         COND(&RLEV *EQ 'B') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT 'GRPFLD(M0BRCA'))
             IF         COND(&RLEV *NE 'B' *AND &RLEV *NE 'C') +
                          THEN(CHGVAR VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'GRPFLD(GLENTY'))

             IF         COND(&CCY *EQ 'A') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT 'M0CCY'))
             IF         COND(&RSNO *EQ 'C') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT 'M0ACOD GLENT2'))
             ELSE       CMD(CHGVAR VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'M0RSCD GLENT2'))
             IF         COND(&CCY *NE 'A') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT 'M0CCY'))
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *TCAT ')')

             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT +
                          'GRPSLT(''GLLDB1 *NE 0 *OR GLLDB2 *NE 0 +
                          *OR GLLDB3 *NE 0 *OR GLLDB4 *NE 0'')')

/* Set up MAPFLDs */
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT 'MAPFLD(')

             IF         COND(&RLEV *EQ 'B') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *TCAT '(GLENTY M0BRCA)'))
             IF         COND(&RLEV *EQ 'C') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *TCAT '(GLENTY A8CMCD)'))
             IF         COND(&RLEV *NE 'B' *AND &RLEV *NE 'C') +
                          THEN(CHGVAR VAR(&OPQF) VALUE(&OPQF *TCAT +
                          '(GLENTY ''''''   '''''')'))

/* Set up MAPFLD for entity 2 from 'analysis' parameter - */

             IF         COND(&CCY *EQ 'A') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT '(GLENT2 ''' *TCAT +
                          M0CCY *TCAT ''')'))
             ELSE       CMD(CHGVAR VAR(&OPQF) VALUE(&OPQF *BCAT +
                          '(GLENT2 '''''' '''''')'))

             IF         COND(&RSNO *EQ 'C') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT '(GLRSCD M0ACOD)'))
             ELSE       CMD(CHGVAR VAR(&OPQF) VALUE(&OPQF *BCAT +
                          '(GLRSCD M0RSCD)'))
             IF         COND(&CCCY *EQ '   ') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT '(GLCCY M0CCY)'))
             ELSE       CMD(CHGVAR VAR(&OPQF) VALUE(&OPQF *BCAT +
                          '(GLCCY ''''''' *TCAT &CCCY *TCAT ''''''')'))
/* Amount is sum of calculated amounts */
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT '(GLLDB1 +
                          ''%SUM(M0TDOB)'') (GLLDB2 ''%SUM(M0TTDR)'') +
                          (GLLDB3 ''%SUM(M0TTCR)'') (GLLDB4 +
                          ''%SUM(M0TDCB)'') (GLLDB5 0)')
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT '(GLRTYP ''''''' +
                          *TCAT &MCTRM1 *TCAT ''''''')')
/* End MAPFLD string */
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *TCAT ')')

/* Set OPNID as ACCNTAB */
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT 'OPNID(ACCNTAB)')

             CALL       PGM(QCMDEXC) PARM(&OPQF 1500)

             CPYFRMQRYF FROMOPNID(ACCNTAB) TOFILE(MCBLRPX0) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
             CLOF       OPNID(ACCNTAB)
             MONMSG     MSGID(CPF4520)

             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO CMDLBL(END))
/**/
 ABNOR:      SNDPGMMSG  MSG('Balance Sheet/P & L Reporting ENDED +
                          ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG2000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG2000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG2000 MCH0000)
/**/
 END:        ENDPGM
