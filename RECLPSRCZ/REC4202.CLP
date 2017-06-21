/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE Teller/Batch Journal Print')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC4202 - Teller/Batch Transaction Journal Print            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. MD045831           Date 02Jun17              */
/*       Prev Amend No. CCB023             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      BG18886            Date 28May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      098181             Date 05May98              */
/*                      099642             DATE 02FEB98              */
/*                      096490             DATE 28NOV95              */
/*                      CRT001  *CREATE    DATE 28FEB95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD045831 - Report shows all teller transaction even though  */
/*                  single teller is specified in selection criteria */
/*       CCB023 - COB Restructure - Input Cycle Termination          */
/*                Restructuring                                      */
/*       BG18886 - Amend non-standard codes.                         */
/*       098181 - If teller branch changed, can't reprint all        */
/*                transactions for teller.                           */
/*       099642 - Add parameter SHARE(*NO) in override commands      */
/*                when &TLBT (Teller/Batch Id) is not equal to       */
/*                'ALL', in order to avoid looping in RE4202.        */
/*       096490 - Remove creation parameters which were adopting the */
/*                owners user profile.                               */
/*                Use the standard CLP creation parameters instead.  */
/*       CRT001 - Retail Teller System                               */
/*                                                                   */
/*********************************************************************/
             PGM PARM(&RSEQ &RLEV &RENT &RPARM)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL       VAR(&LDA)   TYPE(*CHAR)  LEN(256) VALUE(' ')
/**/
             DCL        VAR(&OPT)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&TLBT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&TBID) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&FSTN) TYPE(*CHAR) LEN(5)                 /*098181*/
             DCL        VAR(&QRYSLT) TYPE(*CHAR) LEN(20)              /*098181*/
             DCL        VAR(&ATBID) TYPE(*CHAR) LEN(5)                                    /*CCB023*/
/**/
/*  Global monitor message  */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
/* SEND PGM MESSAGE */
/**/
             SNDPGMMSG  MSG('TELLER/BATCH TRANSACTION JOURNAL ') +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/**/
             CHGVAR     VAR(&OPT) VALUE(%SST(&RPARM 1 1))
             CHGVAR     VAR(&TLBT) VALUE(%SST(&RPARM 2 3))
             CHGVAR     VAR(&FSTN) VALUE(%SST(&RPARM 5 5))            /*098181*/
/**********  CHGVAR     VAR(&QRYSLT) VALUE('TBTN *GE' +
                        *BCAT &FSTN)                               */              /*098181 CCB023*/
             CHGVAR     VAR(&QRYSLT) VALUE('TBTN >=' *BCAT &FSTN)                         /*CCB023*/
/**/
/* SET SWITCHES DEPENDING ON MODE */
/**/
             IF (&OPT *EQ 'T' *OR &OPT *EQ 'R') (CHGJOB SWS(10000000))
             ELSE (CHGJOB SWS(01000000))
/**/
/* If teller batch Id blanks execute the program */
/**/
             IF (&TLBT *NE 'ALL') THEN(DO)
             IF (&OPT  *NE 'B')   THEN(DO)
/**********     CHGVAR     VAR(&TBID) VALUE('T'****&TLBT)          */ /*BG18886*/
                CHGVAR     VAR(&TBID) VALUE('T' *CAT &TLBT)           /*BG18886*/
/***********    OVRDBF FILE(TTRANL1) MBR(&TBID)                    */ /*099642*/
/***********    OVRDBF FILE(TTRANL0) TOFILE(TTRANL1) MBR(&TBID)    */ /*099642*/
/***********    OVRDBF FILE(TTRANL1) MBR(&TBID) SHARE(*NO) **/ /*099642 098181*/
/***********    OVRDBF FILE(TTRANL0) TOFILE(TTRANL1) MBR(&TBID) +
                       SHARE(*NO) ***/                         /*099642 098181*/
             ENDDO
             ELSE DO
/**********     CHGVAR     VAR(&TBID) VALUE('B'****&TLBT)          */ /*BG18886*/
                CHGVAR     VAR(&TBID) VALUE('B' *CAT &TLBT)           /*BG18886*/
             ENDDO                                                    /*098181*/
/***********    OVRDBF FILE(TTRANL1) MBR(&TBID)                    */ /*099642*/
/***********    OVRDBF FILE(TTRANL0) TOFILE(TTRANL1) MBR(&TBID)    */ /*099642*/
                OVRDBF FILE(TTRANL1) MBR(&TBID) SHARE(*NO)            /*099642*/
/***********    OVRDBF FILE(TTRANL0) TOFILE(TTRANL1) MBR(&TBID) +
                       SHARE(*NO)  ***/                        /*099642 098181*/
                OVRDBF FILE(TTRANL0) TOFILE(TTRANPD) MBR(&TBID) +
                        SHARE(*YES)                                   /*098181*/
/**********     OPNQRYF FILE((TTRANPD &TBID)) QRYSLT(&QRYSLT) +
                        KEYFLD((TBRI) (TBID) (TBTN))               */              /*098181 CCB023*/
                CHGVAR  VAR(&ATBID) VALUE('A' *CAT &TBID)                                 /*CCB023*/
                                                                                          /*CCB023*/
/* Create an Alias for the specified member of TTRANPD             */                     /*CCB023*/
                                                                                          /*CCB023*/
                SCRUNSQL   SQL('CREATE ALIAS' *BCAT &ATBID *BCAT ' FOR +
                          TTRANPD(' *CAT &TBID *CAT ')')                                  /*CCB023*/
                                                                                          /*CCB023*/
                CLRPFM     FILE(TTRANX)                                                 /*MD045831*/
/* Execute the SQL command                                         */                     /*CCB023*/
                                                                                          /*CCB023*/
                SCRUNSQL   SQL('INSERT INTO TTRANX SELECT * FROM' *BCAT +
                          &ATBID *BCAT ' WHERE' *BCAT &QRYSLT *BCAT +
                          ' ORDER BY TBRI, TBID, TBTN')                                   /*CCB023*/
                                                                                          /*CCB023*/
                OVRDBF  FILE(TTRANL1) TOFILE(TTRANX) SHARE(*NO)                           /*CCB023*/
                OVRDBF  FILE(TTRANL0) TOFILE(TTRANX) SHARE(*NO)                           /*CCB023*/
                                                                                          /*CCB023*/
/*********** ENDDO  ***/                                              /*098181*/
             ENDDO
/**/
/* If teller batch Id blanks execute the program */
/**/
             IF (&TLBT *EQ 'ALL') THEN(DO)
             IF ((&OPT *EQ 'R') *OR (&OPT *EQ 'T'))  THEN(DO)
             CPYF       FROMFILE(TTRANPD) TOFILE(*LIBL/TTRANX) +
                          FROMMBR(*ALL) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK) +
                          CRTFILE(*NO) INCCHAR(*RCD 2 *EQ 'T')
/**/
             MONMSG     MSGID(CPF2817) EXEC(DO)
                GOTO       CMDLBL(ENDPGM)
             ENDDO
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
                ROLLBACK
                GOTO       CMDLBL(ENDPGM)
             ENDDO
/**/
             OVRDBF     FILE(TTRANL1) TOFILE(*LIBL/TTRANX) SHARE(*NO)
             OVRDBF     FILE(TTRANL0) TOFILE(*LIBL/TTRANX) SHARE(*NO)
             ENDDO
             ELSE IF (&OPT  *EQ 'B')   THEN(DO)
             CPYF       FROMFILE(TTRANPD) TOFILE(*LIBL/TTRANX) +
                          FROMMBR(*ALL) +
                          MBROPT(*REPLACE)  FMTOPT(*NOCHK) +
                          CRTFILE(*NO) INCCHAR(*RCD 2 *EQ 'B')
/**/
             MONMSG     MSGID(CPF2817) EXEC(DO)
                GOTO       CMDLBL(ENDPGM)
             ENDDO
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
                ROLLBACK
                GOTO       CMDLBL(ENDPGM)
             ENDDO
/**/
             OVRDBF     FILE(TTRANL0) TOFILE(*LIBL/TTRANX) SHARE(*NO)
             OVRDBF     FILE(TTRANL1) TOFILE(*LIBL/TTRANX) SHARE(*NO)
             ENDDO
             ENDDO
/**/
/*  Submit batch job for printing the journal */
/**/
             CALL       PGM(RE4202) PARM(&RSEQ &RLEV &RENT &RPARM)
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
                ROLLBACK
                GOTO       CMDLBL(ENDPGM)
             ENDDO
             DLTOVR (*ALL)
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
/**/
ERROR:       IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR    VAR(&MSGDTA) VALUE(%SUBSTRING(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MSGDTA) +
                          TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
/* FOR FILE IMBALANCE ERROR */
/**/
             IF         COND(%SWITCH(XXXXXX10)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR     VAR(&MSGDTA) VALUE(%SUBSTRING(&LDA 168 8))
                SNDPGMMSG  MSGID(MEM0002) MSGF(MIDAS) MSGDTA(&MSGDTA) +
                           TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
             GOTO       CMDLBL(ENDPGM)
/**/
ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          REC4202 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
/**/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             IF         COND(&ATBID *NE ' ') THEN(DO)                                     /*CCB023*/
             SCRUNSQL   SQL('DROP ALIAS' *BCAT &ATBID)                                    /*CCB023*/
             ENDDO                                                                        /*CCB023*/
             ENDPGM
