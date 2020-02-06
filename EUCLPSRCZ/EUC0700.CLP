/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas EU In currency - Euro GL a/c mapping input')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - EMU Module                                          */
/*                                                                   */
/*       CLP/EUC0700 - 'In' Currency - Euro GL Account Mapping Input */
/*                                                                   */
/*       Function: This maintenance is used to defined how the       */
/*                 existing GL accounts in 'In' currencies will      */
/*                 mapped to Euro accounts. Once the mapping file    */
/*                 has been created, the user will have the possi-   */
/*                 bility to create the Euro accounts in the Midas   */
/*                 file.                                             */
/*                                                                   */
/*       Called By: None                                             */
/*                                                                   */
/*       Calls  :   EU0700 - 'In' Currency Euro GL Accounts Mapping  */
/*                           Input                                   */
/*                  EU0710 - EMU Mapping GL Accounts                 */
/*                  EU0720 - EMU GL Accounts Extract                 */
/*                  EU0730 - EMU Create Euro GL Accounts             */
/*                  AOMMODR0 - Access program on Module Details      */
/*                  AOPCACR0 - Access program on PCA ICD Details     */
/*                  AOHBCGR0 - Access program on Historic Balances   */
/*                             Control Groups                        */
/*                  AORPERR0 - Access program on Period Details      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. 243018             Date 05Jul07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      239589             Date 24Apr06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      CEU028  *CREATE    Date 24Aug98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       243018 - Customer number is now alpha.                      */
/*       239589 - Correct definition of account code fields from 4 to*/
/*                10 to prevent data mapping error.                  */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       CEU028 - EMU GL Utilities                                   */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MEM)    TYPE(*CHAR) LEN(50)
             DCL        VAR(&AACT)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PGCD)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&PSET)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PYRS)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&PCTY)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&PNYR)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&MAPC)   TYPE(*CHAR) LEN(200)
             DCL        VAR(&OPNQF)  TYPE(*CHAR) LEN(2000)
             DCL        VAR(&GPFLD)  TYPE(*CHAR) LEN(200)
             DCL        VAR(&BRCA)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&CNUM)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&CCY1)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&CCY2)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&CCY3)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&CCY4)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&CCY5)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&CCY6)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&CCY7)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&CCY8)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&CCY9)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&CCY10)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&CCY11)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&ACSC)   TYPE(*CHAR) LEN(2)
/**********  DCL        VAR(&FRAC)   TYPE(*CHAR) LEN(4)                                   /*239589*/
/**********  DCL        VAR(&TOAC)   TYPE(*CHAR) LEN(4)                                   /*239589*/
             DCL        VAR(&FRAC)   TYPE(*CHAR) LEN(10)                                  /*239589*/
             DCL        VAR(&TOAC)   TYPE(*CHAR) LEN(10)                                  /*239589*/
             DCL        VAR(&FLAG)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCD)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&DSFDY)  TYPE(*CHAR) LEN(200)
 
/** Global monitor message */
 
             MONMSG   MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                        CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('EUC700 - EMU ''In'' Currency - Euro GL +
                          Account Mapping') TOMSGQ(MRUNQ)
 
/** Create LDA if not present */
 
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                             TEXT('Midas SD Local Data Area') +
                               AUT(*EXCLUDE)
                MONMSG     MSGID(CPF0000)
             ENDDO
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
/** Initialise Job Switches */
 
             CHGJOB     SWS(00000000)
 
/** Access Module Details via AOMMODR0 */
 
             CALL       PGM(AOMMODR0) PARM(&RTCD '*FIRST' &DSFDY)
             IF         COND(&RTCD *NE ' ') THEN(GOTO CMDLBL(ABNOR))
             CHGVAR     VAR(&AACT) VALUE(%SST(&DSFDY 100 1))
 
/** If the Analytical Accounting is installed */
 
             IF         COND(&AACT *EQ 'Y') THEN(DO)
 
/** Access Primary Control Group via AOPCACR0 */
 
                CALL       PGM(AOPCACR0) PARM(&RTCD '*FIRST' &DSFDY)
                IF         COND(&RTCD *NE ' ') THEN(GOTO CMDLBL(ABNOR))
                CHGVAR     VAR(&PGCD) VALUE(%SST(&DSFDY 15 2))
 
/** Access Period Set Group via AOHBCGR0 */
 
                CALL       PGM(AOHBCGR0) PARM(&RTCD '*KEY' &PGCD +
                           &DSFDY)
                IF         COND(&RTCD *NE ' ') THEN(GOTO CMDLBL(ABNOR))
                CHGVAR     VAR(&PSET) VALUE(%SST(&DSFDY 33 1))
 
/** Access Current Period/Year/Century via AORPERR0 */
 
                CALL       PGM(AORPERR0) PARM(&RTCD '*KEY' &PSET +
                           0 &DSFDY)
                IF         COND(&RTCD *NE ' ') THEN(GOTO CMDLBL(ABNOR))
                CHGVAR     VAR(&PCTY) VALUE(%SST(&DSFDY 2 2))
                CHGVAR     VAR(&PYRS) VALUE(%SST(&DSFDY 4 2))
                CHGVAR     VAR(&PNYR) VALUE(%SST(&DSFDY 6 2))
 
/** Select records as per Current Period/Year/Century in GLHIBLPD */
 
                OVRDBF     FILE(GLHIBLL0) TOFILE(GLHIBLL0) SHARE(*YES)
                MONMSG     MSGID(CPF0000)
                OPNQRYF    FILE((GLHIBLL0 &PGCD)) OPTION(*INP) +
                           FORMAT(GLHIBLL0) QRYSLT('(HBPDCT *EQ ''' +
                           *CAT &PCTY *CAT ''' *AND HBPDYR *EQ ''' +
                           *CAT &PYRS *CAT ''' *AND HBPDNY *EQ ''' +
                           *CAT &PNYR *CAT ''')') KEYFLD(*FILE)
 
             ENDDO
 
/** Call PGM/EU0700 to Map GL Account Input */
 
MAIN:        CALL       PGM(EU0700) PARM(&RTCD &MAPC)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA DTAARA(LDA (134 50)) RTNVAR(&MEM)
                MONMSG     MSGID(CPF0000 MCH0000)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                            TOMSGQ(MOPERQ MRUNQ)
                MONMSG     MSGID(CPF0000 MCH0000)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/** End the program if the user request to exit */
 
             IF         COND(&RTCD *EQ '*EXIT  ') THEN(GOTO +
                          CMDLBL(ENDPGM))
 
/** Start commitment control */
 
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))            /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
             MONMSG     MSGID(CPF0000)
 
/** Call PGM/EU0730 to Create GL Euro Account */
 
             IF         COND(&RTCD *EQ '*CREATE') THEN(DO)
                CALL       PGM(EU0730)
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   RTVDTAARA DTAARA(LDA (134 50)) RTNVAR(&MEM)
                   MONMSG     MSGID(CPF0000 MCH0000)
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                               TOMSGQ(MOPERQ MRUNQ)
                   MONMSG     MSGID(CPF0000 MCH0000)
                   GOTO       CMDLBL(ABNOR)
                ENDDO
 
/** Go back to the main Maintenance */
 
                GOTO       CMDLBL(MAIN)
 
             ENDDO
 
/** Setup Mapping Parameter */
 
             CHGVAR     VAR(&BRCA)  VALUE(%SST(&MAPC 1 3))
             CHGVAR     VAR(&CNUM)  VALUE(%SST(&MAPC 4 6))
             CHGVAR     VAR(&CCY1)  VALUE(%SST(&MAPC 10 3))
             CHGVAR     VAR(&CCY2)  VALUE(%SST(&MAPC 13 3))
             CHGVAR     VAR(&CCY3)  VALUE(%SST(&MAPC 16 3))
             CHGVAR     VAR(&CCY4)  VALUE(%SST(&MAPC 19 3))
             CHGVAR     VAR(&CCY5)  VALUE(%SST(&MAPC 22 3))
             CHGVAR     VAR(&CCY6)  VALUE(%SST(&MAPC 25 3))
             CHGVAR     VAR(&CCY7)  VALUE(%SST(&MAPC 28 3))
             CHGVAR     VAR(&CCY8)  VALUE(%SST(&MAPC 31 3))
             CHGVAR     VAR(&CCY9)  VALUE(%SST(&MAPC 34 3))
             CHGVAR     VAR(&CCY10) VALUE(%SST(&MAPC 37 3))
             CHGVAR     VAR(&CCY11) VALUE(%SST(&MAPC 40 3))
             CHGVAR     VAR(&ACSC)  VALUE(%SST(&MAPC 43 2))
/**********  CHGVAR     VAR(&FRAC)  VALUE(%SST(&MAPC 45 4))                               /*239589*/
/**********  CHGVAR     VAR(&TOAC)  VALUE(%SST(&MAPC 49 4))                               /*239589*/
             CHGVAR     VAR(&FRAC)  VALUE(%SST(&MAPC 45 10))                              /*239589*/
             CHGVAR     VAR(&TOAC)  VALUE(%SST(&MAPC 55 10))                              /*239589*/
             CHGVAR     VAR(&FLAG)  VALUE(' ')
 
/** Setup OPNQRYF command on variable &OPNQF */
 
             CHGVAR     VAR(&OPNQF) VALUE('OPNQRYF FILE((ACCNTAB) +
                          (SDACODPD)) FORMAT(ACCNTAB) QRYSLT(''')
 
/** Setup Branch Code on variable &OPNQF */
 
             CHGVAR     VAR(&GPFLD) VALUE('*AND' *BCAT 'BRCA' +
                          *BCAT '*EQ' *BCAT '''''' *CAT &BRCA *CAT +
                           '''''')
 
/** Setup Customer number on variable &OPNQF */
 
/*******     IF         COND(&CNUM *NE ' ') THEN(CHGVAR VAR(&GPFLD) +                     /*243018*/
/*******        VALUE(&GPFLD *BCAT '*AND' *BCAT 'CNUM' +                                  /*243018*/
/*******         *BCAT '*EQ' *BCAT CNUME))                                                /*243018*/
             IF         COND(&CNUM *NE ' ') THEN(CHGVAR VAR(&GPFLD) +
                          VALUE(&GPFLD *BCAT '*AND CNUME *EQ ''''' *CAT +
                           &CNUM *TCAT ''''''))                                           /*243018*/
 
/** Setup Account section on variable &OPNQF */
 
             IF         COND(&ACSC *NE ' ') THEN(CHGVAR VAR(&GPFLD) +
                VALUE(&GPFLD *BCAT '*AND' *BCAT 'A5ACSC' +
                 *BCAT '*EQ' *BCAT '''''' *CAT &ACSC +
                   *CAT ''''''))
 
/** Setup From Account code on variable &OPNQF */
 
             IF         COND((&FRAC *NE ' ') *AND (&TOAC *EQ ' ')) +
                THEN(CHGVAR VAR(&GPFLD) VALUE(&GPFLD +
                 *BCAT '*AND' *BCAT 'ACOD' *BCAT '*EQ' +
                  *BCAT FRACE))
 
/** Setup Account type on variable &OPNQF */
 
             CHGVAR     VAR(&GPFLD) VALUE(&GPFLD *BCAT '*AND' *BCAT +
                          'ATYP' *BCAT '*EQ' *BCAT '''''G''''')
 
/** Setup Currency 1 */
 
             IF         COND(&CCY1 *NE ' ') THEN(DO)
                CHGVAR     VAR(&FLAG) VALUE('Y')
                CHGVAR     VAR(&OPNQF) VALUE(&OPNQF *BCAT 'CCY' *BCAT +
                            '*EQ' *BCAT '''''' *CAT &CCY1 *CAT '''''' +
                             *BCAT &GPFLD)
             ENDDO
 
/** Setup Currency 2 */
 
             IF        COND(&CCY2 *NE ' ') THEN(DO)
                IF         COND(&FLAG *EQ 'Y') THEN(DO)
                   CHGVAR     VAR(&OPNQF) VALUE(&OPNQF *BCAT '*OR ')
                ENDDO
                CHGVAR     VAR(&OPNQF) VALUE(&OPNQF *BCAT 'CCY' *BCAT +
                            '*EQ' *BCAT '''''' *CAT &CCY2 *CAT '''''' +
                             *BCAT &GPFLD)
                CHGVAR     VAR(&FLAG) VALUE('Y')
             ENDDO
 
/** Setup Currency 3 */
 
             IF         COND(&CCY3 *NE ' ') THEN(DO)
                IF         COND(&FLAG *EQ 'Y') THEN(DO)
                   CHGVAR     VAR(&OPNQF) VALUE(&OPNQF *BCAT '*OR ')
                ENDDO
                CHGVAR     VAR(&OPNQF) VALUE(&OPNQF *BCAT 'CCY' *BCAT +
                            '*EQ' *BCAT '''''' *CAT &CCY3 *CAT '''''' +
                              *BCAT &GPFLD)
                CHGVAR     VAR(&FLAG) VALUE('Y')
             ENDDO
 
/** Setup Currency 4 */
 
             IF         COND(&CCY4 *NE ' ') THEN(DO)
                IF         COND(&FLAG *EQ 'Y') THEN(DO)
                CHGVAR     VAR(&OPNQF) VALUE(&OPNQF *BCAT '*OR ')
                ENDDO
                CHGVAR     VAR(&OPNQF) VALUE(&OPNQF *BCAT 'CCY' *BCAT +
                            '*EQ' *BCAT '''''' *CAT &CCY4 *CAT '''''' +
                             *BCAT &GPFLD)
                CHGVAR     VAR(&FLAG) VALUE('Y')
             ENDDO
 
/** Setup Currency 5 */
 
             IF         COND(&CCY5 *NE ' ') THEN(DO)
                IF         COND(&FLAG *EQ 'Y') THEN(DO)
                   CHGVAR     VAR(&OPNQF) VALUE(&OPNQF *BCAT '*OR ')
                ENDDO
                CHGVAR     VAR(&OPNQF) VALUE(&OPNQF *BCAT 'CCY' *BCAT +
                            '*EQ' *BCAT '''''' *CAT &CCY5 *CAT '''''' +
                             *BCAT &GPFLD)
                CHGVAR     VAR(&FLAG) VALUE('Y')
             ENDDO
 
/** Setup Currency 6 */
 
             IF         COND(&CCY6 *NE ' ') THEN(DO)
                IF         COND(&FLAG *EQ 'Y') THEN(DO)
                   CHGVAR     VAR(&OPNQF) VALUE(&OPNQF *BCAT '*OR ')
                ENDDO
                CHGVAR     VAR(&OPNQF) VALUE(&OPNQF *BCAT 'CCY' *BCAT +
                            '*EQ' *BCAT '''''' *CAT &CCY6 *CAT '''''' +
                             *BCAT &GPFLD)
                CHGVAR     VAR(&FLAG) VALUE('Y')
             ENDDO
 
/** Setup Currency 7 */
 
             IF         COND(&CCY7 *NE ' ') THEN(DO)
                IF         COND(&FLAG *EQ 'Y') THEN(DO)
                   CHGVAR     VAR(&OPNQF) VALUE(&OPNQF *BCAT '*OR ')
                ENDDO
                CHGVAR     VAR(&OPNQF) VALUE(&OPNQF *BCAT 'CCY' *BCAT +
                            '*EQ' *BCAT '''''' *CAT &CCY7 *CAT '''''' +
                             *BCAT &GPFLD)
                CHGVAR     VAR(&FLAG) VALUE('Y')
             ENDDO
 
/** Setup Currency 8 */
 
             IF         COND(&CCY8 *NE ' ') THEN(DO)
                IF         COND(&FLAG *EQ 'Y') THEN(DO)
                   CHGVAR     VAR(&OPNQF) VALUE(&OPNQF *BCAT '*OR ')
                ENDDO
                CHGVAR     VAR(&OPNQF) VALUE(&OPNQF *BCAT 'CCY' *BCAT +
                            '*EQ' *BCAT '''''' *CAT &CCY8 *CAT '''''' +
                             *BCAT &GPFLD)
                CHGVAR     VAR(&FLAG) VALUE('Y')
             ENDDO
 
/** Setup Currency 9 */
 
             IF         COND(&CCY9 *NE ' ') THEN(DO)
                IF         COND(&FLAG *EQ 'Y') THEN(DO)
                   CHGVAR     VAR(&OPNQF) VALUE(&OPNQF *BCAT '*OR ')
                ENDDO
                CHGVAR     VAR(&OPNQF) VALUE(&OPNQF *BCAT 'CCY' *BCAT +
                            '*EQ' *BCAT '''''' *CAT &CCY9 *CAT '''''' +
                             *BCAT &GPFLD)
                CHGVAR     VAR(&FLAG) VALUE('Y')
             ENDDO
 
/** Setup Currency 10 */
 
             IF         COND(&CCY10 *NE ' ') THEN(DO)
                IF         COND(&FLAG *EQ 'Y') THEN(DO)
                   CHGVAR     VAR(&OPNQF) VALUE(&OPNQF *BCAT '*OR ')
                ENDDO
                CHGVAR     VAR(&OPNQF) VALUE(&OPNQF *BCAT 'CCY' *BCAT +
                            '*EQ' *BCAT '''''' *CAT &CCY10 *CAT +
                             '''''' *BCAT &GPFLD)
                CHGVAR     VAR(&FLAG) VALUE('Y')
             ENDDO
 
/** Setup Currency 11 */
 
             IF         COND(&CCY11 *NE ' ') THEN(DO)
                IF         COND(&FLAG *EQ 'Y') THEN(DO)
                   CHGVAR     VAR(&OPNQF) VALUE(&OPNQF *BCAT '*OR ')
                ENDDO
                CHGVAR     VAR(&OPNQF) VALUE(&OPNQF *BCAT 'CCY' *BCAT +
                            '*EQ' *BCAT '''''' *CAT &CCY11 *CAT +
                             '''''' *BCAT &GPFLD)
             ENDDO
 
/**********  CHGVAR     VAR(&OPNQF) VALUE(&OPNQF *BCAT ''')' *BCAT +
                          'KEYFLD((BRCA) (CNUM) (CCY) (ACOD) (ACSQ)) +
                           JFLD((ACODE ACOD)) MAPFLD((ACODE A5ACCD +
                            *ZONED 4 0)')                                                 /*239589*/
 
             CHGVAR     VAR(&OPNQF) VALUE(&OPNQF *BCAT ''')' *BCAT +
                          'KEYFLD((BRCA) (CNUM) (CCY) (ACOD) +
                          (ACSQ)) JFLD((ACODE ACOD)) MAPFLD((ACODE +
                          A5ACCD *ZONED 10 0)')                                           /*239589*/
                                                                                          /*239589*/
/*******     IF         COND(&CNUM *NE ' ') THEN(CHGVAR VAR(&OPNQF) +                     /*243018*/
/*******                  VALUE(&OPNQF *BCAT '(CNUME' *BCAT &CNUM +                       /*243018*/
/*******                   *BCAT '*ZONED 6 0)'))                                          /*243018*/
             IF         COND(&CNUM *NE ' ') THEN(CHGVAR VAR(&OPNQF) +
                          VALUE(&OPNQF *BCAT '(CNUME CNUM *CHAR +
                          6)'))                                                           /*243018*/
 
/**********  IF         COND((&FRAC *NE ' ') *AND (&TOAC *EQ ' ')) +
                          THEN(CHGVAR VAR(&OPNQF) VALUE(&OPNQF +
                            *BCAT '(FRACE' *BCAT &FRAC *BCAT +
                              '*ZONED 4 0)'))                                             /*239589*/
 
             IF         COND((&FRAC *NE ' ') *AND (&TOAC *EQ ' ')) +
                          THEN(CHGVAR VAR(&OPNQF) VALUE(&OPNQF +
                          *BCAT '(FRACE' *BCAT &FRAC *BCAT '*ZONED +
                          10 0)'))                                                        /*239589*/
                                                                                          /*239589*/
             CHGVAR     VAR(&OPNQF) VALUE(&OPNQF *BCAT ')')
 
/** Execute command OPNQRYF using variable &OPNQF via QCMDEXC */
 
             OVRDBF     FILE(ACCNTAB) SHARE(*YES)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(QCMDEXC) PARM(&OPNQF 2000)
 
/** Clear records on PF/EUWORKPD */
 
             CLRPFM     FILE(EUWORKPD)
 
/** Call PGM/EU0720 to Extract GL Account */
 
             IF         COND(&FRAC *NE ' ' *AND &TOAC *NE ' ') THEN(DO)
                CALL       PGM(EU0720) PARM(&FRAC &TOAC)
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                   MONMSG     MSGID(CPF0000 MCH0000)
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                               TOMSGQ(MOPERQ MRUNQ)
                   MONMSG     MSGID(CPF0000 MCH0000)
                   GOTO       CMDLBL(ABNOR)
                ENDDO
             ENDDO
 
             ELSE       CMD(DO)
 
/** Copy Open Query file to PF/EUWORKPD */
 
                CPYFRMQRYF FROMOPNID(ACCNTAB) TOFILE(EUWORKPD) +
                            MBROPT(*REPLACE)
                MONMSG     MSGID(CPF2909)
             ENDDO
 
/** Call PGM/EU0710 to Map GL Euro Account */
 
             CALL       PGM(EU0710) PARM(&MAPC)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                MONMSG     MSGID(CPF0000 MCH0000)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                            TOMSGQ(MOPERQ MRUNQ)
                MONMSG     MSGID(CPF0000 MCH0000)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             DLTOVR     FILE(ACCNTAB)
             MONMSG     MSGID(CPF0000)
             CLOF       OPNID(ACCNTAB)
             MONMSG     MSGID(CPF4520)
 
/** Go back to the main Maintenance */
 
             GOTO       CMDLBL(MAIN)
 
 ABNOR:      CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSG('Program Failed. Re-input necessary.') +
                          TOMSGQ(MOPERQ MRUNQ) TOPGMQ(*EXT)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 ENDPGM:     IF         COND(&AACT *EQ 'Y') THEN(DO)
             DLTOVR  FILE(GLHIBLPD)
             MONMSG  MSGID(CPF0000)
             CLOF    OPNID(GLHIBLPD)
             MONMSG  MSGID(CPF4520)
             ENDDO
             DLTOVR     FILE(ACCNTAB)
             MONMSG     MSGID(CPF0000)
             CLOF       OPNID(ACCNTAB)
             MONMSG     MSGID(CPF4520)
 
/** End commiment control */
 
             ENDCMTCTL
             MONMSG     MSGID(CPF0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
