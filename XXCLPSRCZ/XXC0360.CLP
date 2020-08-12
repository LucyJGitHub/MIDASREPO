/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas MC Extract MC Balances for Alternate Accnts')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Management Accounts Module                          */
/*                                                                   */
/*       XXC0360  - Extract Management Account Balances for          */
/*                  Alternate Spot Trade and Spot Trade Equivalent   */
/*                  Accounts in the Spot Revaluation table           */
/*                                                                   */
/*       This is a clone of MCC0360 and is amended to create         */
/*       MC postings for the Alternate Spot Trade and Spot Trade     */
/*       Equivalent Accounts. Any changes to MCC0360 should be       */
/*       considered for XXC0360. Called from MCC0360                 */
/*                                                                   */
/*       (c) Finastra International Limited 2017                     */
/*                                                                   */
/*       Last Amend No. FVT102  *CREATE    Date 09May17              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       FVT102 - Posting of P/L to Multiple Retained Earnings       */
/*                                                                   */
/*********************************************************************/
             PGM (&PSTD)

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems 2017')
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) /*        +
                          Return Code */
             DCL        VAR(&PKEY) TYPE(*CHAR) LEN(7) /*        +
                          Period Set */
             DCL        VAR(&PBAS) TYPE(*CHAR) LEN(7) /*        +
                          Posting Basis */
             DCL        VAR(&SPAC) TYPE(*CHAR) LEN(10) VALUE('0000000000')
                          /* Alternate Spot Trade Account code */
             DCL        VAR(&PGCD) TYPE(*CHAR) LEN(4) /*        +
                          Primary Control Group code */
             DCL        VAR(&PDCT) TYPE(*CHAR) LEN(2) /*        +
                          Period Century */
             DCL        VAR(&PDYR) TYPE(*CHAR) LEN(2) /*        +
                          Period Year */
             DCL        VAR(&PDNY) TYPE(*CHAR) LEN(2) /*        +
                          Period Number within Year */
             DCL        VAR(&DEVD) TYPE(*CHAR) LEN(5) /*        +
                          Diary Event Date */
             DCL        VAR(&PSTD) TYPE(*CHAR) LEN(5) /*        +
                          Posting Date */
             DCL        VAR(&BJRDNB) TYPE(*CHAR) LEN(5) /*        +
                          Posting Date */
             DCL        VAR(&BJCYCD) TYPE(*CHAR) LEN(3) VALUE('   ') +
                         /* Base Currency */
             DCL        VAR(&FTFR) TYPE(*CHAR) LEN(1) /*        +
                          FX Transfer Date? */
             DCL        VAR(&BTFR) TYPE(*CHAR) LEN(1) /*        +
                          Base Ccy Transfer Date? */
             DCL        VAR(&SRVL) TYPE(*CHAR) LEN(1) /*        +
                          Spot Revaluation Date? */
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200) /*        +
                          Return string */
             DCL        VAR(&BCCY) TYPE(*CHAR) LEN(3) VALUE('   ') +
                          /* Base ccy */

/* Read in SD Spot Revaluation Mapping Table */

             DCLF       FILE(XXSRVLPD)
/**/
/* Global monitor message */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             SNDPGMMSG  MSG('XCC0360- Extract Management A/c +
                          Balances for Alternate Spot Trade Acoounts') TOMSGQ(MRUNQ)
/**/
             CHGJOB     SWS(XXXXXX00)
/**/
/* Access Last Diary Event to check for Transfer Date */
/**/
             CALL       PGM(AODIRYR0) PARM(&RTCD '*LAST' ' '  +
                          &DSFDY)
             IF         COND(&RTCD *NE '       ') +
                          THEN(GOTO CMDLBL(ABNOR))
             CHGVAR     VAR(&DEVD) VALUE(%SST(&DSFDY 1 5))
             CHGVAR     VAR(&FTFR) VALUE(%SST(&DSFDY 8 1))
             CHGVAR     VAR(&BTFR) VALUE(%SST(&DSFDY 9 1))
             CHGVAR     VAR(&SRVL) VALUE(%SST(&DSFDY 10 1))
/**/
/* If No Transfer today Terminate Program */
/**/
             IF         COND(&FTFR *NE 'Y' *AND &BTFR *NE 'Y' *AND +
                          &SRVL *NE 'Y') THEN(GOTO CMDLBL(END))
/**/
/* Access Bank ICD for Base Currency & Run Date */
/**/
             CALL       PGM(AOBANKR0) PARM(&RTCD '*FIRST'  +
                          &DSFDY)
             IF         COND(&RTCD *NE '       ') +
                          THEN(GOTO CMDLBL(ABNOR))
             CHGVAR     VAR(&BJCYCD) VALUE(%SST(&DSFDY 13 3))
/**/
/* Set Extract paramters  */
/**/
             IF         COND(&BTFR *NE 'Y') +
                          THEN(CHGVAR VAR(&BCCY) VALUE(&BJCYCD))

/**/
/**  Access PCA ICD for Primary Mgmt A/C Control Group               */
/**/
             CALL       PGM(AOPCACR0) PARM(&RTCD '*FIRST' &DSFDY)
             IF         COND(&RTCD *NE '       ') +
                          THEN(GOTO CMDLBL(ABNOR))
             CHGVAR     VAR(&PGCD) VALUE(%SST(&DSFDY 15 2))
/**/
/**  Access Primary Control Group for Period Set & Posting Basis     */
/**/
             CALL       PGM(AOHBCGR0) PARM(&RTCD '*KEY' &PGCD &DSFDY)
             IF         COND(&RTCD *NE '       ') +
                          THEN(GOTO CMDLBL(ABNOR))
             CHGVAR     VAR(&PKEY) VALUE(%SST(&DSFDY 33 1))
             CHGVAR     VAR(&PBAS) VALUE(%SST(&DSFDY 34 1))

             IF         COND(&PBAS *EQ 'P') THEN(CHGVAR VAR(&DEVD) +
                          VALUE(&PSTD))
/**/
/**  Access Current Period Century, Year and Number                  */
/**/
             CALL       PGM(AORPERR0) PARM(&RTCD '*KEY' &PKEY 0 &DSFDY)
             IF         COND(&RTCD *NE '       ') +
                          THEN(GOTO CMDLBL(ABNOR))
             CHGVAR     VAR(&PDCT) VALUE(%SST(&DSFDY 2 2))
             CHGVAR     VAR(&PDYR) VALUE(%SST(&DSFDY 4 2))
             CHGVAR     VAR(&PDNY) VALUE(%SST(&DSFDY 6 2))

 READ:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(EOF))

/* Set up OPNQRYF to extract balances for Alternate Spot Trade Accounts  */

             CLOF       OPNID(GLHIBLPD)
             MONMSG     MSGID(CPF4520)
             CHGVAR     VAR(&SPAC) VALUE(&MBSRVL)
             OPNQRYF    FILE((GLHIBLPD &PGCD)) FORMAT(MCBLEXPD) +
                          QRYSLT('(HBPDCT *EQ ''' *CAT &PDCT *CAT +
                          ''' *AND HBPDYR *EQ ''' *CAT &PDYR *CAT +
                          ''' *AND HBPDNY *EQ ''' *CAT &PDNY *CAT +
                          ''' ) *AND (HBACCD *EQ ''' *CAT &SPAC +
                          *CAT ''') *AND (HBCYCD *EQ ''' *CAT +
                          &MBFCCY *CAT ''')') MAPFLD((BRCA HBBRCD) +
                          (CCY HBCYCD) (ACOD HBACCD) (CNUM HBCUST) +
                          (ACSQ HBACSN) (PRFC HBPCCD) (BOKC HBBKCD) +
                          (OTTP HBOTTP) (OTST HBTSTY) (ASOC HBACNB) +
                          (ACSC HBACSC) (PAMT HBPDCB) (VOIN 0) +
                          (ACODQQ 0) (GETP ''' ''') (ATYP ''' ''') +
                          (CPNB (&PDCT *CAT &PDYR *CAT &PDNY)) +
                          (EVDT &DEVD) (PDTM (&PSTD *CAT '235959')) +
                          (PNAR ''' '''))
/**/
/*  Copy OPNQRYF to MCBLEXPD  */
/**/
             CPYFRMQRYF FROMOPNID(GLHIBLPD) TOFILE(MCBLEXPD) +
                          MBROPT(*ADD) FMTOPT(*MAP *DROP)
/**/
/* Set up OPNQRYF for Base Currency Equivalent balances */
/* for the Alternate Spot Trade Equivalent Accounts     */
/* If Spot Revaluation required                        */
/**/
             IF         COND(&SRVL *EQ 'Y') THEN(DO)
/**/
             CLOF       OPNID(GLHIBLPD)
             MONMSG     MSGID(CPF4520)
             CHGVAR     VAR(&SPAC) VALUE(&MBSPAE)
             OPNQRYF    FILE((GLHIBLPD &PGCD)) FORMAT(MCBLEXPD) +
                          QRYSLT('(HBPDCT *EQ ''' *CAT &PDCT *CAT +
                          ''' *AND HBPDYR *EQ ''' *CAT &PDYR *CAT +
                          ''' *AND HBPDNY *EQ ''' *CAT &PDNY *CAT +
                          ''' ) *AND (HBACCD *EQ ''' *CAT &SPAC +
                          *CAT ''') *AND (HBCYCD *EQ ''' *CAT +
                          &BJCYCD *CAT ''')') MAPFLD((BRCA HBBRCD) +
                          (CCY HBCYCD) (ACOD HBACCD) (CNUM HBCUST) +
                          (ACSQ HBACSN) (PRFC HBPCCD) (BOKC HBBKCD) +
                          (OTTP HBOTTP) (OTST HBTSTY) (ASOC HBACNB) +
                          (ACSC HBACSC) (PAMT HBPDCB) (VOIN 0) +
                          (ACODQQ 0) (GETP ''' ''') (ATYP ''' ''') +
                          (CPNB (&PDCT *CAT &PDYR *CAT &PDNY)) +
                          (EVDT &DEVD) (PDTM (&PSTD *CAT '235959')) +
                          (PNAR ''' '''))
/**/
/*  Copy OPNQRYF to MCBLEXPD for Base Ccy Eqivalent Accounts */
/**/
             CPYFRMQRYF FROMOPNID(GLHIBLPD) TOFILE(MCBLEXPD) +
                          MBROPT(*ADD) FMTOPT(*MAP *DROP)
             ENDDO
/**/
            GOTO       CMDLBL(READ)

/* If EOF condition */
EOF:        GOTO       CMDLBL(END)
/**/
/* Abnormal Termination Processing */
/**/
 ABNOR:      SNDPGMMSG  MSG('Program XCC0360 ended abnormally') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
END:         CLOF       OPNID(GLHIBLPD)
             MONMSG     MSGID(CPF4520)
             RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems')
             ENDPGM
