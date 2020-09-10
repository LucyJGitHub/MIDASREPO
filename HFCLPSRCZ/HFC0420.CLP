/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas HF Control of extracted records')               */
/*********************************************************************/
/*                                                                   */
/*       Midas     - History and Audit Facility Module           */
/*                                                                   */
/*       HFC0420  - CONTROL OF EXTRACTED RECORDS                     */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. EMP103             Date 16Apr20              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      112939             Date 03Feb98              */
/*                      046256             Date 26Oct92              */
/*                      S01379             DATE 17SEP92              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       EMP103 - HAF Suppress Unwanted Entries                      */
/*                (Upgrade NADF13 to FM2.1 SP23)                     */
/*                Addition of hooks EMP103_001 to EMP103_003         */
/*       MD046248 - Finastra Rebranding                              */
/*       112939 - Override message file HFMSGF for use in HF0310.    */
/*       046256 - Use HFJRNLPD layout to create JOURNAL.             */
/*       S01379 - New program for HAF.                               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/

             PGM

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')

             DCLF       FILE(HFFILEL3)

             DCL        VAR(&JNSEQ) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&JNSEQX) TYPE(*CHAR) LEN(10)
             DCL        VAR(&X) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ITEMX) TYPE(*CHAR) LEN(3)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SRLN) TYPE(*CHAR) LEN(8)
             DCL        VAR(&XP) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CURREC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&HFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LID) TYPE(*CHAR) LEN(2)
                                                                      /*112939*/
             DCL        VAR(&GROUP) TYPE(*CHAR) LEN(50)               /*112939*/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(25)                /*112939*/
             DCL        VAR(&SLEVEL) TYPE(*DEC) LEN(4)                /*112939*/
             DCL        VAR(&TIMEO) TYPE(*DEC) LEN(5)                 /*112939*/
             DCL        VAR(&ERRORC) TYPE(*DEC) LEN(1) VALUE(0)       /*112939*/
             DCL        VAR(&MULT) TYPE(*CHAR) LEN(2)                 /*112939*/
             DCL        VAR(&HFMSGF) TYPE(*CHAR) LEN(10)              /*112939*/
/*/COPY WNCPYSRC,EMP103_001                                          */  /*EMP103*/

/* */
/** GLOBAL MONITOR MESSAGE */
/* */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))


/*/COPY WNCPYSRC,EMP103_002                                          */  /*EMP103*/
/* */                                                                 /*112939*/
/* Multiple language support override for message file */             /*112939*/
/* used in HF0310 */                                                  /*112939*/
/* */                                                                 /*112939*/
             CALL       PGM(SF0410) PARM(&GROUP &USER &SLEVEL &TIMEO  +
                          &ERRORC &MULT)                              /*112939*/
                                                                      /*112939*/
             IF         COND(&MULT *EQ '  ') THEN(DO)                 /*112939*/
                CHGVAR     VAR(&MULT) VALUE('GB')                     /*112939*/
             ENDDO                                                    /*112939*/
                                                                      /*112939*/
             CHGVAR     VAR(&HFMSGF) VALUE(&MULT *CAT 'HFMSGF    ')   /*112939*/
                                                                      /*112939*/
             OVRMSGF    MSGF(HFMSGF) TOMSGF(&HFMSGF)                  /*112939*/
/* */
/* Get library ID and build the HFLIB variable */
/* */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LID)
             CHGVAR     VAR(&HFLIB) VALUE(&LID *CAT 'HFLIB')

/* */
/* Get system value and date */
/* */
             RTVSYSVAL  SYSVAL(QSRLNBR) RTNVAR(&SRLN)
             RTVJOBA    DATE(&DATE)

/* */
/* Get sequence number from JRNBATO */
/* */
             RTVDTAARA  DTAARA(JRNBATO (1 10)) RTNVAR(&JNSEQX)
             CHGVAR     VAR(&JNSEQ) VALUE(&JNSEQX)


/* */
/* Create a copy of file JOURNAL in QTEMP. JOURNAL does not exist */
/* Programs higher in the stack will have put an override in place */
/* */
/*********** CPYF       FROMFILE(JOURNAL) TOFILE(QTEMP/JOURNAL) +
/***********              FROMMBR(*ALL) TOMBR(*FROMMBR) +
/***********              MBROPT(*REPLACE) CRTFILE(*YES) FROMRCD(1) +
/***********              TORCD(10) INCCHAR(*RCD 1 *GT X'FF') ******/ /*046256*/
/************MONMSG     MSGID(CPF2817) *****************************/ /*046256*/
                                                                      /*046256*/
             CPYF       FROMFILE(HFJRNLPD) TOFILE(QTEMP/JOURNAL) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FROMRCD(1) +
                          TORCD(10) INCCHAR(*RCD 1 *GT X'FF')         /*046256*/
             MONMSG     MSGID(CPF2800)                                /*046256*/

/* */
/* Create dataarea JRN in QTEMP for use by other programs */
/* */
             CRTDTAARA  DTAARA(QTEMP/JRN) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF0000)

/* */
/* Read all records on file */
/* */
     LOOP:RCVF

/* */
/* EOF so end program */
/* */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(END))

/* */
/* If file not selected then read next record */
/* */
             IF         COND(&ENAB *NE 'E') THEN(GOTO CMDLBL(LOOP))


/* */
/*Check that the user layout exists */
/* */
             CHGVAR     VAR(&X) VALUE('F' *TCAT %SST(&FFILE 2 9))


/* */
/* Check for member DATASPYBAT */
/* */
             CHKOBJ     OBJ(&HFLIB/&X) OBJTYPE(*FILE) +
                          MBR(DATASPYBAT) AUT(*USE)

/* */
/* If member does not exist then no report required */
/* */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(LOOP))


/* */
/* Override file FIELDS to the correct file and member */
/* */
             OVRDBF     FILE(FIELDS) TOFILE(&HFLIB/&X) MBR(DATASPYBAT)

/* */
/* Override JOURNAL to the version in QTEMP */
/* */
             OVRDBF     FILE(JOURNAL) TOFILE(QTEMP/JOURNAL)

/* */
/* Override HFRGRPPD to the corect JPNPBAT* file */
/* */
             CHGVAR     VAR(&ITEMX) VALUE(&ITEM)
             CHGVAR     VAR(&XP) VALUE('HFRGBAT' *TCAT &ITEMX)
             CHKOBJ     OBJ(&HFLIB/&XP) OBJTYPE(*FILE) AUT(*USE)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(LOOP))
             OVRDBF     FILE(HFRGRPPD) TOFILE(&XP)


/* */
/* Copy the JRNBATCH member to the file JOURNAL in QTEMP */
/* */
             CPYF       FROMFILE(&HFLIB/&FFILE) +
                          TOFILE(QTEMP/JOURNAL) FROMMBR(JRNBATCH) +
                          MBROPT(*REPLACE) INCREL((*IF JOSEQN *GT +
                          &JNSEQX)) FMTOPT(*NOCHK)


/* */
/* If no records copied then no point in proceeding further as there */
/* will be nothing on the audit report. Go get next file */
/* */
             MONMSG     MSGID(CPF2817) EXEC(GOTO CMDLBL(LOOP))


/* */
/* Call HF0300 (Print control program) if there were records copied */
/* */
             RTVMBRD    FILE(QTEMP/JOURNAL) NBRCURRCD(&CURREC)
             IF         COND(&CURREC *NE 0) THEN(DO)
             CHGDTAARA  DTAARA(QTEMP/JRN (23 32)) VALUE(&FFILE)
/* */                                                                 /*046256*/
/* Create dataarea LDA in QTEMP for use by other programs */          /*046256*/
/* */                                                                 /*046256*/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)        /*046256*/
             MONMSG     MSGID(CPF0000)                                /*046256*/
                                                                      /*046256*/
/*/COPY WNCPYSRC,EMP103_003                                          */  /*EMP103*/
             CALL       PGM(HF0300) PARM(&SRLN &DATE &ITEM)
             ENDDO

/* */
/* Read next record */
/* */
             GOTO       CMDLBL(LOOP)

/* */
/** ABNORMAL ERROR PROCESSING                                      */
/* */
 ABNOR:      SNDPGMMSG  MSG('PROGRAM HFC0420 ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)

END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
