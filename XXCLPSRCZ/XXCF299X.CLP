/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas MC OPNQRYF for Movement Extract')               */
/*********************************************************************/
/*                                                                   */
/*   Midas - Management Accounts Module                              */
/*                                                                   */
/*   XXCF299X - OPNQRYF for Movement Extract                         */
/*                                                                   */
/*       (c) Copyright Finastra Systems Technology, Inc. 2020        */
/*                                                                   */
/*       Last Amend No. EML108             Date 14Jan20              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       EML108 - Upgrade FMD003 and fixes to FBM2.1SP21             */
/*       UMD001 - Upgrade FMD003 to Midas Plus 1.2.1 SP19            */
/*       231735 - Separate GE-XB postings update to Opening and      */
/*                Closing Balances and Average Balance Calculation.  */
/*       FMD003 - Automatic Management Account Balances Update       */
/*                                                                   */
/*********************************************************************/


             PGM        PARM(&PSET &PBAS &SDAT &SCS &ANL &RDAT +
                          &XRTCD &GRCD)

             DCL        VAR(&BISCPY) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Copyright Finastra Systems Technology, +
                          Inc. 2020')
             DCL        VAR(&PSET) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PBAS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SDAT) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RDAT) TYPE(*CHAR) LEN(5)
             DCL        VAR(&SCS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&ANL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&STIM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&OPNQRYF) TYPE(*CHAR) LEN(2000)
             DCL        VAR(&SECTIONS) TYPE(*CHAR) LEN(16)
             DCL        VAR(&I) TYPE(*DEC) LEN(3 0) VALUE(1)
             DCL        VAR(&J) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&I2) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&J2) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&KU) TYPE(*CHAR) LEN(40) VALUE('ACODCCY +
                          BRCACNUMACSQPRFCBOKCOTTPOTSTASOC')
             DCL        VAR(&KS) TYPE(*CHAR) LEN(40)
             DCL        VAR(&KEYFLD) TYPE(*CHAR) LEN(100)
             DCL        VAR(&XRTCD)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&GRCD)  TYPE(*CHAR) LEN(2)

/**  Global Monitor Message:                                       */
/**   If an unmonitorred message occurs perform error processing   */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/* Set up copyright                                                  */
             CHGVAR     VAR(&BISCPY) VALUE('(C) Copyright Finastra +
                          Systems Technology, Inc 2020')

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

/* Sort keys into order specified in &ANL                            */
 LOOP1:      IF         COND(&I *GT 10) THEN(GOTO CMDLBL(EXIT1))
             IF         COND(%SST(&ANL &I 1) *NE ' ') THEN(DO)
                CHGVAR     VAR(&J) VALUE(%SST(&ANL &I 1))
                CHGVAR     VAR(&I2) VALUE(1 + ((&I - 1) * 4))
                CHGVAR     VAR(&J2) VALUE(1 + (&J * 4))
                CHGVAR     VAR(%SST(&KS &J2 4)) VALUE(%SST(&KU &I2 4))
                ENDDO
             CHGVAR     VAR(&I) VALUE(&I + 1)
             GOTO       CMDLBL(LOOP1)

/* Set up keylist parameter for OPNQRYF                              */
 EXIT1:      CHGVAR     VAR(&I) VALUE(1)
 LOOP2:      IF         COND(&I *GT 40) THEN(GOTO CMDLBL(EXIT2))
             IF         COND(%SST(&KS &I 4) *NE '    ') THEN(CHGVAR +
                          VAR(&KEYFLD) VALUE(&KEYFLD *BCAT '(' +
                          *TCAT %SST(&KS &I 4) *TCAT ')'))
             CHGVAR     VAR(&I) VALUE(&I + 4)
             GOTO       CMDLBL(LOOP2)

 EXIT2:      CLOF       OPNID(UPDBALPD)
             MONMSG     MSGID(CPF4520)

/* Set up command string for OPNQRYF for UPDBALPD                    */
             CHGVAR     VAR(&OPNQRYF) VALUE('OPNQRYF +
                          FILE((GLACPHPD)) FORMAT(UPDBALPD) +
                          QRYSLT(''SECLIST *CT ACSC *AND')

             CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT 'EVDT +
                          *GT' *BCAT &SDAT *BCAT '*AND' *BCAT 'EVDT +
                          *LT' *BCAT &RDAT *BCAT ''')')

             CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT 'GRPFLD(' +
                          *TCAT &KEYFLD )

             IF         COND(&PBAS *EQ 'P') THEN(CHGVAR +
                          VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT +
                          '(PSTD)'))
             ELSE       CMD(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +
                          *BCAT '(VALD)'))

             CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(VOIN) +
                          (DRCR) (GETP) (ACSC)) MAPFLD((WAMT ''PSTA +
                          - (PSTA * DRCR * 2)'') (WTIME ''(PSTD * +
                          1000000 + PTIM)'') (SECLIST ''''''' *CAT +
                          &SECTIONS *TCAT ''''''') (ACODQQ 0) (EVDT')

             IF         COND(&PBAS *EQ 'P') THEN(CHGVAR +
                          VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT 'PSTD)'))
             ELSE       CMD(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +
                          *BCAT 'VALD)'))
/*/COPY WNCPYSRC,MCC0299003                                          */

             IF         COND(%SST(&ANL 1 1) *EQ ' ') THEN(CHGVAR +
                          VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(ACOD 0)'))
             IF         COND(%SST(&ANL 2 1) *EQ ' ') THEN(CHGVAR +
                          VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(CCY +
                          ''''''   '''''')'))
             IF         COND(%SST(&ANL 3 1) *EQ ' ') THEN(CHGVAR +
                          VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(BRCA +
                          ''''''   '''''')'))
/**********  IF         COND(%SST(&ANL 4 1) *EQ ' ') THEN(CHGVAR +        */              /*EML108*/
/**********               VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(CNUM 0)')) */              /*EML108*/
             IF         COND(%SST(&ANL 4 1) *EQ ' ') THEN(CHGVAR +
                          VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(CNUM +
                          ''''''      '''''')'))                                          /*EML108*/
             IF         COND(%SST(&ANL 5 1) *EQ ' ') THEN(CHGVAR +
                          VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(ACSQ 0)'))
             IF         COND(%SST(&ANL 6 1) *EQ ' ') THEN(CHGVAR +
                          VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(PRFC +
                          ''''''    '''''')'))
             IF         COND(%SST(&ANL 7 1) *EQ ' ') THEN(CHGVAR +
                          VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(BOKC +
                          ''''''  '''''')'))
             IF         COND(%SST(&ANL 8 1) *EQ ' ') THEN(CHGVAR +
                          VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(OTTP +
                          ''''''           '''''')'))
             IF         COND(%SST(&ANL 9 1) *EQ ' ') THEN(CHGVAR +
                          VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(OTST +
                          ''''''           '''''')'))
/**********  IF         COND(%SST(&ANL 10 1) *EQ ' ') THEN(CHGVAR +       */              /*EML108*/
/**********               VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(ASOC 0)')) */              /*EML108*/
             IF         COND(%SST(&ANL 10 1) *EQ ' ') THEN(CHGVAR +
                          VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(ASOC +
                          ''''''      '''''')'))                                          /*EML108*/

/*/COPY WNCPYSRC,MCC0299004                                          */
             CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(PDTM +
                          ''%MAX(WTIME)'') (CPNB 0) (PAMT +
                          ''%SUM(WAMT)'')) OPNID(UPDBALPD) +
                          OPTALLAP(*YES)')
/*/COPY WNCPYSRC,MCC0299005                                          */

             CALL       PGM(QCMDEXC) PARM(&OPNQRYF 2000)

             CPYFRMQRYF FROMOPNID(UPDBALPD) TOFILE(UPDBALPD) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)

             CLOF       OPNID(UPDBALPD)
             MONMSG     MSGID(CPF4520)

             CHGVAR     VAR(%SST(&OPNQRYF 15 8)) VALUE('APOSTPD ')

             CALL       PGM(QCMDEXC) PARM(&OPNQRYF 2000)

             CPYFRMQRYF FROMOPNID(UPDBALPD) TOFILE(UPDBALPD) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)

             CLOF       OPNID(UPDBALPD)
             MONMSG     MSGID(CPF4520)

             CHGVAR     VAR(&OPNQRYF) VALUE('OPNQRYF FILE((GLPERDPD) +
                          (UPDBALPD)) FORMAT(UPDBALPD) +
                          QRYSLT(''DTPSTC *EQ PSET'')')

             CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT +
                          'JFLD((DTEPDD EVDT *GE) +
                          (SPDD EVDT *LE)) JORDER(*FILE)')

             CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT 'KEYFLD(' +
                          *TCAT &KEYFLD *TCAT '(CPNB) (EVDT))')

             CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT +
                          'MAPFLD((CPNB ''DTPDCT *CAT DTPDYR *CAT +
                          DTPDNY'') (ONE 1) (PSET ''''''' *CAT +
                          &PSET *CAT ''''''' *CHAR 1) (SPDD +
                          ''DTSPDD * %MIN(%MAX(DTRPDN 0) 1)'')) +
                          OPNID(UPDBALPD)')

             CALL       PGM(QCMDEXC) PARM(&OPNQRYF 2000)
             GOTO       CMDLBL(PGMEND)
/**/
/**  Error Processing:                                             */
/**   Dump the program if error occurred in this program           */
/**/
 ABNOR:      DMPCLPGM
             CHGVAR     VAR(&XRTCD) VALUE('Y')
             CHGJOB     SWS(XXXXXX11)
             SNDMSG     MSG('Job terminated - OPNQRYF for Movement +
                        Extract ended in error') TOMSGQ(MOPERQ MRUNQ)

/**/
/**  End of Program:   */
 PGMEND:
             ENDPGM
