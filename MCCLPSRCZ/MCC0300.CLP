/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas MC Create Lfs over Postings')                   */
/*********************************************************************/
/*                                                                   */
/*   Midas - Management Accounts Module                              */
/*                                                                   */
/*   MCC0300 - Create LFs over APOSTPD & GLACPHPD                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CPK030             Date 15Apr14              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 138409             Date 24Nov98              */
/*                      121615             Date 01Jun98              */
/*                  S01408                 DATE 05MAY95              */
/*                  069474                 DATE 13APR94              */
/*   NEW PROGRAM    S01419                 DATE 17MAY93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK030 - Clean up of deliverable data library.              */
/*   138409 - Programs no longer in Midas/Q Library since DBA R2.4.  */
/*            They are all in Midas core.                            */
/*   121615 - Do not retrieve MIDASQ dtaara or run MIDASQ pgms if    */
/*            MIDASQ is not switched on                              */
/*   S01408 - Addition of core hook MCC0300MPS                       */
/*   069474 - Rename source file to MCDDSSRC                         */
/*   S01419 - Maintain Logicals over APOSTPD/GLACPHPD                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CGRP &PBAS &ANL)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&CGRP) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PBAS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ANL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FLG) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&I) TYPE(*DEC) LEN(3 0) VALUE(1)
             DCL        VAR(&J) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&K) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&L) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&I2) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&J2) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&K2) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&L2) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&KU) TYPE(*CHAR) LEN(20) +
                          VALUE('06070809101112131415')
             DCL        VAR(&LU) TYPE(*CHAR) LEN(40) VALUE('ACODCCY +
                          BRCACNUMACSQPRFCBOKCOTTPOTSTASOC')
             DCL        VAR(&KS) TYPE(*CHAR) LEN(20)
             DCL        VAR(&LS) TYPE(*CHAR) LEN(40)
             DCL        VAR(&PM) TYPE(*CHAR) LEN(45)
             DCL        VAR(&MBR1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBR2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DVLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTALIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGMDTA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(100)
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PARM0) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PARM1) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PARM2) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PARM3) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PARM4) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PARM5) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PARM6) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PARM7) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PARM8) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PARM9) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PARM10) TYPE(*CHAR) LEN(4)
             DCL        VAR(&SDMMOD) TYPE(*CHAR) LEN(128)             /*121615*/
             DCL        VAR(&MIDASQ) TYPE(*CHAR) LEN(1)               /*121615*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST +
                          ')                                          /*121615*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')      /*121615*/
             DCL        VAR(&SQLSTR) TYPE(*CHAR) LEN(5000)                                /*CPK030*/
             DCL        VAR(&KEY) TYPE(*CHAR) LEN(10)                                     /*CPK030*/
             DCL        VAR(&FIRSTKEY) TYPE(*CHAR) LEN(1)                                 /*CPK030*/
 
             MONMSG     MSGID(CPF0000 MSG0000) EXEC(GOTO CMDLBL(ERROR))
 
 
/* Set up copyright                                                  */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/* Build Logical file member Names                                   */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
             CHGVAR     VAR(&DVLIB) VALUE(&PREFIX *CAT 'DVLIB')
             CHGVAR     VAR(&DTALIB) VALUE(&PREFIX *CAT 'DTALIB')
             CHGVAR     VAR(&DPLIB) VALUE(&PREFIX *CAT 'DPLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,MCC0300MPS                                          */
                                                                      /*S01408*/
 
             CHGVAR     VAR(&MBR1) VALUE(&CGRP *TCAT 'APOST#')
             CHGVAR     VAR(&MBR2) VALUE(&CGRP *TCAT 'HPOST#')
 
/**/                                                                  /*121615*/
/* Access PF/SDMMODPD to determine which modules are live             /*121615*/
/**/                                                                  /*121615*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &SDMMOD)       /*121615*/
/**/                                                                  /*121615*/
/* Database error                                                     /*121615*/
/**/                                                                  /*121615*/
             IF         COND(&RTCD *NE '       ') THEN(DO)            /*121615*/
               SNDPGMMSG  MSG('Error on access to ICD file +
                            AOMMODPD') TOMSGQ(MOPERQ)                 /*121615*/
               GOTO       CMDLBL(ERROR)                               /*121615*/
             ENDDO                                                    /*121615*/
             CHGVAR     VAR(&MIDASQ) VALUE(%SST(&SDMMOD 53 1))
                                                                      /*121615*/
/* Build MQ/Program library                                           */
             IF         COND(&MIDASQ *EQ 'Y') THEN(DO)                /*121615*/
 
             RTVDTAARA  DTAARA(MQLIBS (1 10)) RTNVAR(&PGMDTA)
/**********  RTVDTAARA  DTAARA(&PGMDTA/O#XA01 (1 10)) RTNVAR(&PGMLIB)  *138409*/
             CHGVAR     VAR(&PGMLIB) VALUE('*LIBL     ')              /*138409*/
                ENDDO                                                 /*121615*/
 
/* Sort Key fields for Logical files                                 */
 
 LOOP1:      IF         COND(&I *GT 10) THEN(GOTO CMDLBL(EXIT1))
             IF         COND(%SST(&ANL &I 1) *NE ' ') THEN(DO)
 
                CHGVAR     VAR(&J) VALUE(%SST(&ANL &I 1))
                CHGVAR     VAR(&I2) VALUE(1 + ((&I - 1) * 2))
                CHGVAR     VAR(&K2) VALUE(1 + ((&I - 1) * 4))
                CHGVAR     VAR(&J2) VALUE(1 + (&J * 2))
                CHGVAR     VAR(&L2) VALUE(1 + (&J * 4))
                CHGVAR     VAR(%SST(&KS &J2 2)) VALUE(%SST(&KU &I2 2))
                CHGVAR     VAR(%SST(&LS &L2 4)) VALUE(%SST(&LU &K2 4))
                ENDDO
             CHGVAR     VAR(&I) VALUE(&I + 1)
             GOTO       CMDLBL(LOOP1)
 
/* Check for existance of Logical file over APOSTPD                  */
 
EXIT1:       CHKOBJ     OBJ(&DVLIB/&MBR1) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
 
/**Create*DDS*Source*Member*for*APOSTPD*                             */ /*             */ /*CPK030*/
/************CPYF       FROMFILE(&DTALIB/QDDSSRC) +                   /*069474*/
/************             TOFILE(QTEMP/QDDSSRC) FROMMBR(APOSTSRC) +   /*069474*/
/************             TOMBR(&MBR1) MBROPT(*REPLACE) +             /*069474*/
/************             CRTFILE(*YES) TORCD(5)                      /*069474*/
/**********  CPYF       FROMFILE(&DTALIB/MCDDSSRC) +                                   */ /*CPK030*/
/**********               TOFILE(QTEMP/QDDSSRC) FROMMBR(APOSTSRC) +                    */ /*CPK030*/
/**********               TOMBR(&MBR1) MBROPT(*REPLACE) +                              */ /*CPK030*/
/**********               CRTFILE(*YES) TORCD(5)                                */ /*069474 CPK030*/
 
/* Start building create index string. */                                                 /*CPK030*/
                CHGVAR     VAR(&FIRSTKEY) VALUE('Y')                                      /*CPK030*/
                CHGVAR     VAR(&SQLSTR) VALUE('create index' *BCAT +
                             &DVLIB *TCAT '/' *TCAT &MBR1 *BCAT 'on +
                             APOSTPD (')                                                  /*CPK030*/
 
/* Add Key fields to Logical file                                    */
 
             CHGVAR     VAR(&I) VALUE(1)
             CHGVAR     VAR(&L) VALUE(1)
 LOOP2:      IF         COND(&I *GT 20) THEN(GOTO CMDLBL(EXIT2))
             IF         COND(%SST(&KS &I 2) *NE '  ') THEN(DO)
 
                 CHGVAR     VAR(&K) VALUE(&I * 2 - 1)
                 CHGVAR     VAR(%SST(&PM &L 4)) VALUE(%SST(&LS &K 4))
                 CHGVAR     VAR(&L) VALUE(&L + 4)
 
                 CHGVAR     VAR(&J) VALUE(%SST(&KS &I 2))
/****************CPYF       FROMFILE(&DTALIB/QDDSSRC) +               /*069474*/
/****************            TOFILE(QTEMP/QDDSSRC) FROMMBR(APOSTSRC) +/*069474*/
/****************            TOMBR(&MBR1) MBROPT(*ADD) FROMRCD(&J) +  /*069474*/
/****************            TORCD(&J)                                /*069474*/
/**********      CPYF       FROMFILE(&DTALIB/MCDDSSRC) +                               */ /*CPK030*/
/**********                   TOFILE(QTEMP/QDDSSRC) FROMMBR(APOSTSRC) +                */ /*CPK030*/
/**********                   TOMBR(&MBR1) MBROPT(*ADD) FROMRCD(&J) +                  */ /*CPK030*/
/**********                   TORCD(&J)                                         */ /*069474 CPK030*/
                CALLSUBR   SUBR(GETKEY)                                                   /*CPK030*/
                IF         COND(&FIRSTKEY *EQ 'Y') THEN(DO)                               /*CPK030*/
                   CHGVAR     VAR(&FIRSTKEY) VALUE('N')                                   /*CPK030*/
                   CHGVAR     VAR(&SQLSTR) VALUE(&SQLSTR *BCAT &KEY)                      /*CPK030*/
                ENDDO                                                                     /*CPK030*/
                ELSE       CMD(DO)                                                        /*CPK030*/
                   CHGVAR     VAR(&SQLSTR) VALUE(&SQLSTR *BCAT ',' *BCAT +
                                &KEY)                                                     /*CPK030*/
                ENDDO                                                                     /*CPK030*/
             ENDDO
 
             CHGVAR     VAR(&I) VALUE(&I + 2)
             GOTO       CMDLBL(LOOP2)
 
 EXIT2:      IF         COND(&PBAS *EQ 'V') THEN(DO)
                        CHGVAR VAR(&J) VALUE(17)
                        CHGVAR     VAR(%SST(&PM &L 4)) VALUE('VALD')
             ENDDO
             ELSE       CMD(DO)
                        CHGVAR VAR(&J) VALUE(16)
                        CHGVAR     VAR(%SST(&PM &L 4)) VALUE('PSTD')
             ENDDO
 
/************CPYF       FROMFILE(&DTALIB/QDDSSRC) +                   /*069474*/
/************             TOFILE(QTEMP/QDDSSRC) FROMMBR(APOSTSRC) +   /*069474*/
/************             TOMBR(&MBR1) MBROPT(*ADD) FROMRCD(&J) +     /*069474*/
/************             TORCD(&J)                                   /*069474*/
/**********  CPYF       FROMFILE(&DTALIB/MCDDSSRC) +                                   */ /*CPK030*/
/**********               TOFILE(QTEMP/QDDSSRC) FROMMBR(APOSTSRC) +                    */ /*CPK030*/
/**********               TOMBR(&MBR1) MBROPT(*ADD) FROMRCD(&J) +                      */ /*CPK030*/
/**********               TORCD(&J)                                             */ /*069474 CPK030*/
 
/**********  CRTLF      FILE(&DVLIB/&MBR1) SRCFILE(QTEMP/QDDSSRC) +                    */ /*CPK030*/
/**********               TEXT('Midas MC LF for group - ' +                            */ /*CPK030*/
/**********               *CAT &CGRP) MAINT(*DLY) SHARE(*YES) +                        */ /*CPK030*/
/**********               LVLCHK(*NO)                                                  */ /*CPK030*/
 
                CALLSUBR   SUBR(GETKEY)                                                   /*CPK030*/
                CHGVAR     VAR(&SQLSTR) VALUE(&SQLSTR *BCAT ',' *BCAT +
                             &KEY *TCAT ')')                                              /*CPK030*/
                RUNSQL     SQL(&SQLSTR) COMMIT(*NONE)                                     /*CPK030*/
 
/* Flag creation of Midas/Q subset                                   */
             IF         COND(&MIDASQ *EQ 'Y') THEN(DO)                /*121615*/
             CHGVAR     VAR(&FLG) VALUE(1)
             ENDDO                                                    /*121615*/
 
             ENDDO
 
/* Check for existance of Logical file over GLACPHPD                 */
 
             CHKOBJ     OBJ(&DVLIB/&MBR2) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
 
/**Create*DDS*Source*Member*for*APOSTPD*                             */ /*             */ /*CPK030*/
/************CPYF       FROMFILE(&DTALIB/QDDSSRC) +                   /*069474*/
/************             TOFILE(QTEMP/QDDSSRC) FROMMBR(HPOSTSRC) +   /*069474*/
/************             TOMBR(&MBR2) MBROPT(*REPLACE) +             /*069474*/
/************             CRTFILE(*YES) TORCD(5)                      /*069474*/
/**********  CPYF       FROMFILE(&DTALIB/MCDDSSRC) +                                   */ /*CPK030*/
/**********               TOFILE(QTEMP/QDDSSRC) FROMMBR(HPOSTSRC) +                    */ /*CPK030*/
/**********               TOMBR(&MBR2) MBROPT(*REPLACE) +                              */ /*CPK030*/
/**********               CRTFILE(*YES) TORCD(5)                                */ /*069474 CPK030*/
 
/* Start building create index string. */                                                 /*CPK030*/
                CHGVAR     VAR(&FIRSTKEY) VALUE('Y')                                      /*CPK030*/
                CHGVAR     VAR(&SQLSTR) VALUE('create index' *BCAT +
                             &DVLIB *TCAT '/' *TCAT &MBR2 *BCAT 'on +
                             GLACPHPD (')                                                 /*CPK030*/
 
/* Add Key fields to Logical file                                    */
 
             CHGVAR     VAR(&I) VALUE(1)
             CHGVAR     VAR(&L) VALUE(1)
 LOOP3:      IF         COND(&I *GT 20) THEN(GOTO CMDLBL(EXIT3))
             IF         COND(%SST(&KS &I 2) *NE '  ') THEN(DO)
 
                 CHGVAR     VAR(&K) VALUE(&I * 2 - 1)
                 CHGVAR     VAR(%SST(&PM &L 4)) VALUE(%SST(&LS &K 4))
                 CHGVAR     VAR(&L) VALUE(&L + 4)
 
                 CHGVAR     VAR(&J) VALUE(%SST(&KS &I 2))
/****************CPYF       FROMFILE(&DTALIB/QDDSSRC) +               /*069474*/
/****************            TOFILE(QTEMP/QDDSSRC) FROMMBR(HPOSTSRC) +/*069474*/
/****************            TOMBR(&MBR2) MBROPT(*ADD) FROMRCD(&J) +  /*069474*/
/****************            TORCD(&J)                                /*069474*/
/**********      CPYF       FROMFILE(&DTALIB/MCDDSSRC) +                               */ /*CPK030*/
/**********                  TOFILE(QTEMP/QDDSSRC) FROMMBR(HPOSTSRC) +                 */ /*CPK030*/
/**********                  TOMBR(&MBR2) MBROPT(*ADD) FROMRCD(&J) +                   */ /*CPK030*/
/**********                  TORCD(&J)                                          */ /*069474 CPK030*/
                CALLSUBR   SUBR(GETKEY)                                                   /*CPK030*/
                IF         COND(&FIRSTKEY *EQ 'Y') THEN(DO)                               /*CPK030*/
                   CHGVAR     VAR(&FIRSTKEY) VALUE('N')                                   /*CPK030*/
                   CHGVAR     VAR(&SQLSTR) VALUE(&SQLSTR *BCAT &KEY)                      /*CPK030*/
                ENDDO                                                                     /*CPK030*/
                ELSE       CMD(DO)                                                        /*CPK030*/
                   CHGVAR     VAR(&SQLSTR) VALUE(&SQLSTR *BCAT ',' *BCAT +
                                &KEY)                                                     /*CPK030*/
                ENDDO                                                                     /*CPK030*/
             ENDDO
 
             CHGVAR     VAR(&I) VALUE(&I + 2)
             GOTO       CMDLBL(LOOP3)
 
 EXIT3:      IF         COND(&PBAS *EQ 'V') THEN(DO)
                        CHGVAR VAR(&J) VALUE(17)
                        CHGVAR     VAR(%SST(&PM &L 4)) VALUE('VALD')
             ENDDO
             ELSE       CMD(DO)
                        CHGVAR VAR(&J) VALUE(16)
                        CHGVAR     VAR(%SST(&PM &L 4)) VALUE('PSTD')
             ENDDO
 
/************CPYF       FROMFILE(&DTALIB/QDDSSRC) +                   /*069474*/
/************             TOFILE(QTEMP/QDDSSRC) FROMMBR(HPOSTSRC) +   /*069474*/
/************             TOMBR(&MBR2) MBROPT(*ADD) FROMRCD(&J) +     /*069474*/
/************             TORCD(&J)                                   /*069474*/
/**********  CPYF       FROMFILE(&DTALIB/MCDDSSRC) +                                   */ /*CPK030*/
/**********               TOFILE(QTEMP/QDDSSRC) FROMMBR(HPOSTSRC) +                    */ /*CPK030*/
/**********               TOMBR(&MBR2) MBROPT(*ADD) FROMRCD(&J) +                      */ /*CPK030*/
/**********               TORCD(&J)                                             */ /*069474 CPK030*/
 
/**********  CRTLF      FILE(&DVLIB/&MBR2) SRCFILE(QTEMP/QDDSSRC) +                    */ /*CPK030*/
/**********               TEXT('Midas MC LF for group - ' +                            */ /*CPK030*/
/**********               *CAT &CGRP) MAINT(*DLY) SHARE(*YES) +                        */ /*CPK030*/
/**********               LVLCHK(*NO)                                                  */ /*CPK030*/
 
                CALLSUBR   SUBR(GETKEY)                                                   /*CPK030*/
                CHGVAR     VAR(&SQLSTR) VALUE(&SQLSTR *BCAT ',' *BCAT +
                             &KEY *TCAT ')')                                              /*CPK030*/
                RUNSQL     SQL(&SQLSTR) COMMIT(*NONE)                                     /*CPK030*/
 
/* Flag creation of Midas/Q subset                                   */
             IF         COND(&MIDASQ *EQ 'Y') THEN(DO)                /*121615*/
             CHGVAR     VAR(&FLG) VALUE(1)
             ENDDO                                                    /*121615*/
 
             ENDDO
 
/* Add Logicals to MQ subset logic                                   */
 
             IF         COND(&FLG *EQ '1') THEN(DO)
                 CHGVAR     VAR(&PARM0) VALUE(%SST(&PM 1 4))
                 CHGVAR     VAR(&PARM1) VALUE(%SST(&PM 5 4))
                 CHGVAR     VAR(&PARM2) VALUE(%SST(&PM 9 4))
                 CHGVAR     VAR(&PARM3) VALUE(%SST(&PM 13 4))
                 CHGVAR     VAR(&PARM4) VALUE(%SST(&PM 17 4))
                 CHGVAR     VAR(&PARM5) VALUE(%SST(&PM 21 4))
                 CHGVAR     VAR(&PARM6) VALUE(%SST(&PM 25 4))
                 CHGVAR     VAR(&PARM7) VALUE(%SST(&PM 29 4))
                 CHGVAR     VAR(&PARM8) VALUE(%SST(&PM 33 4))
                 CHGVAR     VAR(&PARM9) VALUE(%SST(&PM 37 4))
                 CHGVAR     VAR(&PARM10) VALUE(%SST(&PM 41 4))
 
             CALL       PGM(&PGMLIB/MQ562XC) PARM('I' &CGRP &PGMDTA +
                          &PGMLIB &PARM0 &PARM1 &PARM2 &PARM3 &PARM4 +
                          &PARM5 &PARM6 &PARM7 &PARM8 &PARM9 &PARM10)
 
             ENDDO
             GOTO       CMDLBL(ENDPGM)
 
/*********************************************************************/
ERROR:
             DMPCLPGM
             RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF) MSGFLIB(&MSGFLIB)
             MONMSG     MSGID(CPF0000)
 
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000)
/*********************************************************************/
 
             SUBR       SUBR(GETKEY)                                                      /*CPK030*/
 
             IF         COND(&J *EQ 6) THEN(DO)                                           /*CPK030*/
                CHGVAR     VAR(&KEY) VALUE('ACOD')                                        /*CPK030*/
             ENDDO                                                                        /*CPK030*/
             IF         COND(&J *EQ 7) THEN(DO)                                           /*CPK030*/
                CHGVAR     VAR(&KEY) VALUE('CCY')                                         /*CPK030*/
             ENDDO                                                                        /*CPK030*/
             IF         COND(&J *EQ 8) THEN(DO)                                           /*CPK030*/
                CHGVAR     VAR(&KEY) VALUE('BRCA')                                        /*CPK030*/
             ENDDO                                                                        /*CPK030*/
             IF         COND(&J *EQ 9) THEN(DO)                                           /*CPK030*/
                CHGVAR     VAR(&KEY) VALUE('CNUM')                                        /*CPK030*/
             ENDDO                                                                        /*CPK030*/
             IF         COND(&J *EQ 10) THEN(DO)                                          /*CPK030*/
                CHGVAR     VAR(&KEY) VALUE('ACSQ')                                        /*CPK030*/
             ENDDO                                                                        /*CPK030*/
             IF         COND(&J *EQ 11) THEN(DO)                                          /*CPK030*/
                CHGVAR     VAR(&KEY) VALUE('PRFC')                                        /*CPK030*/
             ENDDO                                                                        /*CPK030*/
             IF         COND(&J *EQ 12) THEN(DO)                                          /*CPK030*/
                CHGVAR     VAR(&KEY) VALUE('BOKC')                                        /*CPK030*/
             ENDDO                                                                        /*CPK030*/
             IF         COND(&J *EQ 13) THEN(DO)                                          /*CPK030*/
                CHGVAR     VAR(&KEY) VALUE('OTTP')                                        /*CPK030*/
             ENDDO                                                                        /*CPK030*/
             IF         COND(&J *EQ 14) THEN(DO)                                          /*CPK030*/
                CHGVAR     VAR(&KEY) VALUE('OTST')                                        /*CPK030*/
             ENDDO                                                                        /*CPK030*/
             IF         COND(&J *EQ 15) THEN(DO)                                          /*CPK030*/
                CHGVAR     VAR(&KEY) VALUE('ASOC')                                        /*CPK030*/
             ENDDO                                                                        /*CPK030*/
             IF         COND(&J *EQ 16) THEN(DO)                                          /*CPK030*/
                CHGVAR     VAR(&KEY) VALUE('PSTD')                                        /*CPK030*/
             ENDDO                                                                        /*CPK030*/
             IF         COND(&J *EQ 17) THEN(DO)                                          /*CPK030*/
                CHGVAR     VAR(&KEY) VALUE('VALD')                                        /*CPK030*/
             ENDDO                                                                        /*CPK030*/
             IF         COND(&J *EQ 18) THEN(DO)                                          /*CPK030*/
                CHGVAR     VAR(&KEY) VALUE('VOIN')                                        /*CPK030*/
             ENDDO                                                                        /*CPK030*/
             IF         COND(&J *EQ 19) THEN(DO)                                          /*CPK030*/
                CHGVAR     VAR(&KEY) VALUE('DRCR')                                        /*CPK030*/
             ENDDO                                                                        /*CPK030*/
             IF         COND(&J *EQ 20) THEN(DO)                                          /*CPK030*/
                CHGVAR     VAR(&KEY) VALUE('GETP')                                        /*CPK030*/
             ENDDO                                                                        /*CPK030*/
             IF         COND(&J *EQ 21) THEN(DO)                                          /*CPK030*/
                CHGVAR     VAR(&KEY) VALUE('ACSC')                                        /*CPK030*/
             ENDDO                                                                        /*CPK030*/
 
             ENDSUBR                                                                      /*CPK030*/
 
ENDPGM:      ENDPGM
