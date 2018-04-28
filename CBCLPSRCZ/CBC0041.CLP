/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Sundry Postings - Posting Completion Rtne')  */
/*********************************************************************/
/*                                                                   */
/*      Midas     - General Ledger Module                            */
/*                                                                   */
/*      CBC0041- Posting Completion Routine                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2009           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Last Amend No. CGL030 *CREATE     Date 18Dec09              */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CGL030 - Sundry Postings                                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SAR &POSTPHASE)
 
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&POSTPHASE) TYPE(*CHAR) LEN(4)
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)
 
             DCL        VAR(&NOTDONE) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&QRYEQSAR) TYPE(*CHAR) LEN(100)
             DCL        VAR(&QRYNESAR) TYPE(*CHAR) LEN(100)
             DCL        VAR(&QRYCOMP) TYPE(*CHAR) LEN(100)
             DCL        VAR(&PHASEFLD) TYPE(*CHAR) LEN(10)
             DCL        VAR(&STATUSFLD) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2009')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* SET UP GLOBAL VALUES */
             RCLRSC
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CGL030' +
                          &AOFMT)
             IF         COND(&RTCD *NE '       ') THEN(GOTO +
                          CMDLBL(END))
             CHGJOB     STSMSG(*NONE)
 
             /* IDENTIFY FIELD NAMES IN REGISTER */
             IF         COND(&POSTPHASE *EQ 'POST') THEN(CHGVAR +
                          VAR(&STATUSFLD) VALUE('E1STA1'))
             IF         COND(&POSTPHASE *EQ 'ANWD') THEN(CHGVAR +
                          VAR(&STATUSFLD) VALUE('E1STA2'))
             IF         COND(&POSTPHASE *EQ 'PROJ') THEN(CHGVAR +
                          VAR(&STATUSFLD) VALUE('E1STA3'))
             IF         COND(&POSTPHASE *EQ 'POST') THEN(CHGVAR +
                          VAR(&PHASEFLD) VALUE('E1POST'))
             IF         COND(&POSTPHASE *EQ 'ANWD') THEN(CHGVAR +
                          VAR(&PHASEFLD) VALUE('E1ANWD'))
             IF         COND(&POSTPHASE *EQ 'PROJ') THEN(CHGVAR +
                          VAR(&PHASEFLD) VALUE('E1PROJ'))
 
             /* SET UP OPNQRYF CRITERIA */
             CHGVAR     VAR(&QRYEQSAR) VALUE('E1SARN *EQ ''' *CAT +
                          &SAR *TCAT '''')
             CHGVAR     VAR(&QRYNESAR) VALUE('E1SARN *NE ''' *CAT +
                          &SAR *TCAT '''')
             CHGVAR     VAR(&QRYCOMP) VALUE(&STATUSFLD *TCAT ' *NE +
                          ''C''')
             CHGVAR     VAR(&QRYCOMP) VALUE(&STATUSFLD *TCAT ' *NE +
                          ''C'' *and ' *CAT &STATUSFLD *TCAT ' *NE +
                          ''*''')
 
             /* SET UP DUMMY ONE RECORD FILE */
             DLTF       FILE(QTEMP/ONERCD)
             MONMSG CPF0000
             CRTPF      FILE(QTEMP/ONERCD) RCDLEN(256) TEXT('Dummy +
                          file with one record') AUT(*ALL)
             INZPFM     FILE(QTEMP/ONERCD) TOTRCDS(1)
 
             /* SET UP TEMP POSTING FILE WITH ONE RECORD (SO %COUNT WORKS) */
             DLTF       FILE(QTEMP/TMPGESU)
             MONMSG CPF0000
             CPYF       FROMFILE(GESUPD) TOFILE(QTEMP/TMPGESU) +
                          CRTFILE(*YES) NBRRCDS(1)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/TMPGESU)
             INZPFM     FILE(QTEMP/TMPGESU) TOTRCDS(1)
 
/* LOCK REGISTER SO ONLY ONE COMPLETION REQUEST AT A TIME */
             ALCOBJ     OBJ((GLRGSUPD *FILE *EXCL)) WAIT(32766)
 
/* UPDATE STATUS OF GIVEN SAR TO COMPLETE */
             DLTF QTEMP/TMPREG
             MONMSG     MSGID(CPF0000)
 
             OPNQRYF    FILE((GLRGSUPD)) QRYSLT(&QRYEQSAR) +
                          MAPFLD((&STATUSFLD '''C'''))
             CPYFRMQRYF FROMOPNID(GLRGSUPD) TOFILE(QTEMP/TMPREG) +
                          CRTFILE(*YES)
             CLOF       OPNID(GLRGSUPD)
             OPNQRYF    FILE((GLRGSUPD)) QRYSLT(&QRYNESAR)
             CPYFRMQRYF FROMOPNID(GLRGSUPD) TOFILE(QTEMP/TMPREG) +
                          MBROPT(*ADD)
             CLOF       OPNID(GLRGSUPD)
             CPYF       FROMFILE(QTEMP/TMPREG) TOFILE(GLRGSUPD) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF0000)
 
/* COUNT NBR OF REMAINING SARS TO COMPLETE */
             OPNQRYF    FILE((GLRGSUPD)) QRYSLT(&QRYCOMP)
             CPYFRMQRYF FROMOPNID(GLRGSUPD) TOFILE(QTEMP/TMPREG) +
                          MBROPT(*REPLACE)
             CLOF       OPNID(GLRGSUPD)
             RTVMBRD    FILE(QTEMP/TMPREG) NBRCURRCD(&NOTDONE)
 
/* ON POST 1 COMPLETION... */
IF         COND((&NOTDONE *EQ 0) *AND (&POSTPHASE *EQ +
                          'POST')) THEN(DO)
 
             /* COPY TO GENERATED ENTRIES */
             CPYF       FROMFILE(GLSUNDPD) TOFILE(GESUPD) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(GLSUNDPD)
 
             /* MERGE TO RETAIL */
             CPYF       FROMFILE(GESUPD) TOFILE(REEODPF) +
                          MBROPT(*ADD) INCREL((*IF RIND *EQ 1) +
                          (*AND RECI *EQ 'P')) FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2802)
 
             /* SET UP HEADER/TRAILER */
             OPNQRYF    FILE((QTEMP/ONERCD)) FORMAT(*LIBL/GESUHH) +
                          MAPFLD((RECI '''H''') (FLSZ 0) (ZZ156 ''' +
                          '''))
             CPYFRMQRYF FROMOPNID(ONERCD) TOFILE(GESUHH) +
                          MBROPT(*REPLACE)
             CLOF       OPNID(ONERCD)
 
             CPYF       FROMFILE(GESUPD) TOFILE(QTEMP/TMPGESU) +
                          MBROPT(*ADD)
             OPNQRYF    FILE((QTEMP/TMPGESU)) FORMAT(*LIBL/GESUZZ) +
                          GRPFLD(*NONE) MAPFLD((RECI '''Z''') +
                          (FULLCOUNT '%COUNT + 1' *ZONED 8 0) +
                          (HASHTOT '%SUM(1/PSTA)') (HRWN +
                          '*mapfld/hashtot / 1000') (HRDC +
                          '*mapfld/hashtot - (*mapfld/hrwn * +
                          1000)') (ZZ144 ''' ''') (ALL8 +
                          '*mapfld/fullcount' *CHAR 8) (LEAST5A +
                          '%SST(*mapfld/all8 4 5)' *CHAR 5) +
                          (LEAST5N '*mapfld/least5a' *ZONED 5 0) +
                          (NORE1 '*mapfld/least5n'))
             CPYFRMQRYF FROMOPNID(TMPGESU) TOFILE(GESUZZ) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             CLOF       OPNID(TMPGESU)
ENDDO
 
/* ON POST 5 COMPLETION... */
IF ((&NOTDONE *EQ 0) *AND (&POSTPHASE *EQ 'ANWD')) THEN(DO)
 
             /* COPY TO GENERATED ENTRIES */
             CPYF       FROMFILE(GLSUNDPD) TOFILE(GESU2PD) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(GLSUNDPD)
 
             /* MERGE TO RETAIL */
             CPYF       FROMFILE(GESU2PD) TOFILE(REEODPF) +
                          MBROPT(*ADD) INCREL((*IF RIND *EQ 1) +
                          (*AND RECI *EQ 'P')) FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2802)
 
             /* SET UP HEADER/TRAILER */
             OPNQRYF    FILE((QTEMP/ONERCD)) FORMAT(*LIBL/GESU2HH) +
                          MAPFLD((RECI '''H''') (FLSZ 0) (ZZ156 ''' +
                          '''))
             CPYFRMQRYF FROMOPNID(ONERCD) TOFILE(GESU2HH) +
                          MBROPT(*REPLACE)
             CLOF       OPNID(ONERCD)
 
             CPYF       FROMFILE(GESU2PD) TOFILE(QTEMP/TMPGESU) +
                          MBROPT(*ADD)
             OPNQRYF    FILE((QTEMP/TMPGESU)) FORMAT(*LIBL/GESU2ZZ) +
                          GRPFLD(*NONE) MAPFLD((RECI '''Z''') +
                          (FULLCOUNT '%COUNT + 1' *ZONED 8 0) +
                          (HASHTOT '%SUM(1/PSTA)') (HRWN +
                          '*mapfld/hashtot / 1000') (HRDC +
                          '*mapfld/hashtot - (*mapfld/hrwn * +
                          1000)') (ZZ144 ''' ''') (ALL8 +
                          '*mapfld/fullcount' *CHAR 8) (LEAST5A +
                          '%SST(*mapfld/all8 4 5)' *CHAR 5) (LEAST5N +
                          '*mapfld/least5a' *ZONED 5 0) (NORE1 +
                          '*mapfld/least5n'))
             CPYFRMQRYF FROMOPNID(TMPGESU) TOFILE(GESU2ZZ) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             CLOF       OPNID(TMPGESU)
             ENDDO
 
/* ON SHADOW COMPLETION... */
             IF         COND((&NOTDONE *EQ 0) *AND (&POSTPHASE *EQ +
                          'PROJ')) THEN(DO)
 
             /* COPY TO GENERATED ENTRIES */
             CPYF       FROMFILE(GLSUNDPD) TOFILE(GESU3PD) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(GLSUNDPD)
 
             /* SET UP HEADER/TRAILER */
             OPNQRYF    FILE((QTEMP/ONERCD)) FORMAT(*LIBL/GESU3HH) +
                          MAPFLD((RECI '''H''') (FLSZ 0) (ZZ156 ''' +
                          '''))
             CPYFRMQRYF FROMOPNID(ONERCD) TOFILE(GESU3HH) +
                          MBROPT(*REPLACE)
             CLOF       OPNID(ONERCD)
 
             CPYF       FROMFILE(GESU3PD) TOFILE(QTEMP/TMPGESU) +
                          MBROPT(*ADD)
             OPNQRYF    FILE((QTEMP/TMPGESU)) FORMAT(*LIBL/GESU3ZZ) +
                          GRPFLD(*NONE) MAPFLD((RECI '''Z''') +
                          (FULLCOUNT '%COUNT + 1' *ZONED 8 0) +
                          (HASHTOT '%SUM(1/PSTA)') (HRWN +
                          '*mapfld/hashtot / 1000') (HRDC +
                          '*mapfld/hashtot - (*mapfld/hrwn * +
                          1000)') (ZZ144 ''' ''') (ALL8 +
                          '*mapfld/fullcount' *CHAR 8) (LEAST5A +
                          '%SST(*mapfld/all8 4 5)' *CHAR 5) (LEAST5N +
                          '*mapfld/least5a' *ZONED 5 0) (NORE1 +
                          '*mapfld/least5n'))
             CPYFRMQRYF FROMOPNID(TMPGESU) TOFILE(GESU3ZZ) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             CLOF       OPNID(TMPGESU)
             ENDDO
 
             CHGJOB     STSMSG(*NORMAL)
             DLCOBJ     OBJ((GLRGSUPD *FILE *EXCL))
             GOTO       CMDLBL(END)
 
ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            CBC0041 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
