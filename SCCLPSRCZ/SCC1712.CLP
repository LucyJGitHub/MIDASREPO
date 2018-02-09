/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SC Save master/journal libraries')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Restart Recovery Module                             */
/*                                                                   */
/*       SCC1712 - SAVE MASTER LIBRARY                               */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR1033813          Date 18Sep12              */
/*                      CBF002             Date 04Jul11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      CSC039             Date 18Aug08              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      CRE026             Date 21May07              */
/*                      BUG9619            Date 21May07              */
/*                      CSC033 *REVISE     Date 25Mar07              */
/*                      xxxxxx             Date xxxxxxx              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*     AR1033813 - Zone schemas/libraries to be backed-up will not   */
/*                 be processed if there is an error in finding      */
/*                 any system value                                  */
/*     CBF002 - BF Infrastructure: Backup and Recovery               */
/*     CSC039 - Include parameter DTACPR in save commands to reduce  */
/*              run time.                                            */
/*     CRE026 - Consumer Banking                                     */
/*     BUG9619 - Close of business components run long if journal    */
/*                 cache is enabled                                  */
/*     CSC033 - Program rewritten to remove diskette processing and  */
/*                to introduce save of global libraries.            y*/
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&BIND &TIND)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&NUM) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&SMSG) TYPE(*CHAR) LEN(132)
             DCL        VAR(&JRNE) TYPE(*CHAR) LEN(200)
             DCL        VAR(&VAL1) TYPE(*CHAR) LEN(5)
             DCL        VAR(&BIND) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TIND) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FSAV) TYPE(*CHAR) LEN(8) VALUE('  DMLIB ')
             DCL        VAR(&DTALIB) TYPE(*CHAR) LEN(10) VALUE('  DTALIB ')
             DCL        VAR(&DEVI) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SAVD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&VOL1) TYPE(*CHAR) LEN(5) VALUE('DB   ')
             DCL        VAR(&JNSTAT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CB_AUTO) TYPE(*CHAR) LEN(111)
             DCL        VAR(&CB_RTN_CDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&XDAT) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SFMT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&ACPTH) TYPE(*CHAR) LEN(6)
             DCL        VAR(&GSAV) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7) VALUE(' ')
             DCL        VAR(&CSW025) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&LIBTOSAVE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MNGSYS) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&EQLIB) TYPE(*CHAR) LEN(7) VALUE('KFILXXX')                   /*CRE026*/
             DCL        VAR(&CRE026) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CRE026*/
             DCL        VAR(&KAPUNMNM) TYPE(*CHAR) LEN(3)                                 /*CRE026*/
             DCL        VAR(&GLOBAL) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&GLOBID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&GMLIB) TYPE(*CHAR) LEN(10) VALUE('  GMLIB   ')
             DCL        VAR(&GTALIB) TYPE(*CHAR) LEN(10) VALUE('  GTALIB  ')
             DCL        VAR(&PRFK) TYPE(*CHAR) LEN(3) VALUE(' ')                          /*CBF002*/
/**/
/*/COPY SDCPYSRC,SDSVALDCL                                                                        */
             DCL        VAR(&DTACPRV) TYPE(*CHAR) LEN(10)                                 /*CSC039*/
             DCL        VAR(&OPTION) TYPE(*CHAR) LEN(4)                                   /*CSC039*/
             CHGVAR     VAR(&OPTION) VALUE('*NO ')                                        /*CSC039*/
/**/
/*/COPY WNCPYSRC,SCC1712005                                                                       */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO ABNOR)
/**/
/*   Initial Processing                                                                           */
/**/
             CALL (AOSARDR0) PARM(&PRTCD '*VERIFY' 'CSW025')
             IF (&PRTCD *EQ ' ') (CHGVAR (&CSW025) VALUE('Y'))
                                                                                          /*CRE026*/
             RTVDTAARA  DTAARA(KAPUNMNM) RTNVAR(&KAPUNMNM)                                /*CRE026*/
             CHGVAR     VAR(&EQLIB) VALUE('KFIL' *CAT +
                        (&KAPUNMNM))                                                      /*CRE026*/
                                                                                          /*CRE026*/
/** Check for switchable feature CRE026 - Consumer Banking */                             /*CRE026*/
                                                                                          /*CRE026*/
             CHGVAR     VAR(&PRTCD) VALUE('       ')                                      /*CRE026*/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                                        /*CRE026*/
             CHGVAR     VAR(&SARD) VALUE('CRE026')                                        /*CRE026*/
                                                                                          /*CRE026*/
             CALL       PGM(AOSARDR0) PARM(&PRTCD &OPN &SARD)                             /*CRE026*/
                                                                                          /*CRE026*/
             IF         COND(&PRTCD *EQ '       ') THEN(DO)                               /*CRE026*/
             CHGVAR     VAR(&CRE026) VALUE('Y')                                           /*CRE026*/
             ENDDO                                                                        /*CRE026*/
/**/
/*/COPY WNCPYSRC,SCC1712011                                                                       */
/**/
/* Check if access paths to be saved                                                              */
/**/
             CHGVAR     VAR(&RTN) VALUE('       ')
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')
             CHGVAR     VAR(&SARD) VALUE('CSC003')
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)
/**/
             IF         COND(&RTN *EQ '       ') THEN(DO)
/**/
/* Set flag                                                                                       */
/**/
             CHGVAR     VAR(&ACPTH) VALUE('CSC003')
/**/
             ENDDO
/**/
/*   Check that the required data areas exist.                                                    */
/**/
/* JNSTAT                                                                                         */
/**/
             CHKOBJ     OBJ(JNSTAT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
               CHGVAR     VAR(&SMSG) VALUE('Job terminated +
                          - JNSTAT not found ')
               SNDMSG  MSG(&SMSG) TOMSGQ(MOPERQ)
               CHGJOB     SWS(XXXXXX11)
               GOTO       CMDLBL(ENDPGM)
             ENDDO
/**/
/* SDSTAT                                                                                         */
/**/
             CHKOBJ     OBJ(SDSTAT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
               CHGVAR     VAR(&SMSG) VALUE('Job terminated +
                          - SDSTAT not found ')
               SNDMSG  MSG(&SMSG) TOMSGQ(MOPERQ)
               CHGJOB     SWS(XXXXXX11)
               GOTO       CMDLBL(ENDPGM)
             ENDDO
/**/
/*/COPY WNCPYSRC,SCC1712006                                                                       */
/**/
             RTVDTAARA  DTAARA(JNSTAT) RTNVAR(&JNSTAT)
/**/
/*  Obtain zone library ID from SDSTAT                                                            */
/**/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(%SUBSTRING(&FSAV 1 2)) +
                          VALUE(%SUBSTRING(&SDSTAT 6 2))
             CHGVAR     VAR(%SUBSTRING(&DTALIB 1 2)) +
                          VALUE(%SUBSTRING(&SDSTAT 6 2))
/**/
/*  Determine whether global libraries should be saved.                                           */
/**/
             CHGVAR     VAR(&GLOBAL) VALUE(%SST(&JNSTAT 172 1))
/**/
/*  If save of global libraries is required,                                                      */
/**/
             IF         COND(&GLOBAL *EQ 'Y') THEN(DO)
/**/
/*  determine global system ID.                                                                  */
/**/
             CALL       PGM(AOSVALR0) PARM(&PRTCD 'BrgMidasGlobalPrefix' +
                          &SVAL1 &SVALK2 &SVAL2 &SVALK3 &SVAL3 +
                          &SVALK4 &SVAL4 &SVALK5 &SVAL5 &SVALK6 +
                          &SVAL6 &SVALK7 &SVAL7 &SVALK8 &SVAL8 +
                          &SVALK9 &SVAL9 &SVALK10 &SVAL10)
/**/
/* If there is an error finding system values, then end abnormally.                               */
/**/
                IF         COND(&PRTCD *NE '       ') THEN(GOTO +
                             CMDLBL(ABNOR))
/**/
/*  Calculate names of global libraries.                                                          */
/**/
             CHGVAR     VAR(&GLOBID) VALUE(&SVAL1)
             CHGVAR     VAR(&GMLIB) VALUE(&GLOBID *CAT 'GMLIB   ')
             CHGVAR     VAR(&GTALIB) VALUE(&GLOBID *CAT 'GTALIB  ')
/**/
             ENDDO
/**/
/*/COPY WNCPYSRC,SCC1712MP2                                                                       */
/**/
/*  Obtain media and device name for Beginning of Business save from data area JNSTAT.            */
/*  Obtain day for volume ID from data area LDA                                                   */
/**/
             IF         COND(&BIND *EQ 'B') THEN(DO)
/**/
               CHGVAR     VAR(&DEVI) +
                          VALUE(%SUBSTRING(&JNSTAT 39 10))
               CHGVAR     VAR(&SAVD) +
                          VALUE(%SUBSTRING(&JNSTAT 35 4))
               RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
               CHGVAR     VAR(%SUBSTRING(&VOL1 3 3)) +
                          VALUE(%SUBSTRING(&LDA 213 3))
/**/
/* Obtain the auto COB information via CB0602X                                                    */
/**/
             CHGVAR     VAR(%SST(&CB_AUTO 1 10)) VALUE('*TODAY    ')
             CALL       PGM(CB0602X) PARM(&CB_RTN_CDE &CB_AUTO)
/**/
/* Determine BOB savefile name                                                                    */
/**/
             CHGVAR     VAR(&VOL1) VALUE(%SST(&CB_AUTO 61 5))
/**/
/* check if CSC001 is switched on.                                                                */
/**/
             CHGVAR     VAR(&RTN) VALUE('       ')
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')
             CHGVAR     VAR(&SARD) VALUE('CSC001')
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)
             IF         COND(&RTN *EQ '       ') THEN(DO)
/**/
/* Retrieve previous run date from data area JNSTAT.                                              */
/* Call CB0602W, which is a new program to format the day.                                        */
/**/
             CALL SCJNSTAT PARM(&XDAT)
             CALL CB0602W PARM(&CB_RTN_CDE &CB_AUTO &XDAT)
             CHGVAR     VAR(&VOL1) VALUE(%SST(&CB_AUTO 61 5))
             ENDDO
/**/
            ENDDO
/**/
/*  Obtain media, device name and volume ID for Input Cycle save from data area JNSTAT            */
/**/
             IF         COND(&BIND *EQ 'I') THEN(DO)
/**/
               CHGVAR     VAR(&DEVI) +
                          VALUE(%SUBSTRING(&JNSTAT 53 10))
               CHGVAR     VAR(&SAVD) +
                          VALUE(%SUBSTRING(&JNSTAT 49 4))
               CHGVAR     VAR(&VOL1) +
                          VALUE(%SUBSTRING(&JNSTAT 63 5))
/**/
             ENDDO
/**/
/*  Tape processing -                                                                             */
/**/
             IF         COND(&SAVD *EQ 'TAPE') THEN(DO)
/**/
             CHGVAR     VAR(&GSAV) VALUE(%SST(&FSAV 1 7) *CAT '   ')
/**/
/* Save the zone DMLIB.                                                                           */
/**/
             CALL       PGM(SCC1767) PARM(&GSAV &SAVD +
                       '                    ' &DEVI &VOL1)
             RTVJOBA    SWS(&SWS)
/**/
             IF         COND(%SST(&SWS 7 1) *EQ '1') THEN(DO)
/**/
               CHGVAR     VAR(&SMSG) VALUE('Job terminated +
                          - library ' *CAT &FSAV *CAT ' NOT saved')
               SNDMSG  MSG(&SMSG) TOMSGQ(MOPERQ)
               CHGJOB     SWS(XXXXXX11)
               GOTO       CMDLBL(ENDPGM)
/**/
             ENDDO
                                                                                          /*CSC039*/
/*  Get System Value for Data Compression parameter in save commands                      /*CSC039*/
             CALL       PGM(AOSVALR0) PARM(&RSVALRTNC +
                             'SavDataCompression' &SVAL1 +
                             ' ' &SVAL2 +
                             ' ' &SVAL3 +
                             ' ' &SVAL4 +
                             ' ' &SVAL5 +
                             ' ' &SVAL6 +
                             ' ' &SVAL7 +
                             ' ' &SVAL8 +
                             ' ' &SVAL9 +
                             ' ' &SVAL10)                                                 /*CSC039*/
                                                                                          /*CSC039*/
/* If there is an error finding any system value then end abnormally */                   /*CSC039*/
                                                                                          /*CSC039*/
             IF         COND(&RSVALRTNC *NE '       ') THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*CSC039*/
             CHGVAR     VAR(&DTACPRV) VALUE(&SVAL1)                                       /*CSC039*/
                                                                                          /*CSC039*/
             SAVLIB     LIB(&FSAV) DEV(&DEVI) VOL(&VOL1) +
                          USEOPTBLK(*NO) ACCPTH(&OPTION) +
                          OUTPUT(*PRINT) DTACPR(&DTACPRV)                                 /*CSC039*/
/**/
/* Save the zone DTALIB.                                                                          */
/**/
             CHGVAR     VAR(&DTALIB) VALUE(%SST(&DTALIB 1 8) *CAT '  ')
             CALL       PGM(SCC1767) PARM(&DTALIB &SAVD +
                       '                    ' &DEVI &VOL1)
             RTVJOBA    SWS(&SWS)
             IF         COND(%SST(&SWS 7 1) *EQ '1') THEN(DO)
               CHGVAR     VAR(&SMSG) VALUE('Job terminated +
                          - library ' *CAT &DTALIB *CAT ' NOT saved')
               SNDMSG  MSG(&SMSG) TOMSGQ(MOPERQ)
               CHGJOB     SWS(XXXXXX11)
               GOTO       CMDLBL(ENDPGM)
             ENDDO                                                                     /*AR1033813*/
                                                                                          /*CBF002*/
/** Save the zone schemas/libraries */                                                    /*CBF002*/
                                                                                          /*CBF002*/
/** Changes in parameter values for SAVLIB and SAVSAVFDTA */                              /*CBF002*/
/** commands requires an update in SCSVPRMPD file also */                                 /*CBF002*/
                                                                                          /*CBF002*/
             IF         COND(&SAVD *EQ 'TAPE') THEN(DO)                                   /*CBF002*/
               CHGVAR   VAR(&PRFK) VALUE('011')                                           /*CBF002*/
             ENDDO                                                                        /*CBF002*/
                                                                                          /*CBF002*/
             IF         COND(&SAVD *EQ 'DISK') THEN(DO)                                   /*CBF002*/
               CHGVAR   VAR(&PRFK) VALUE('013')                                           /*CBF002*/
             ENDDO                                                                        /*CBF002*/
                                                                                          /*CBF002*/
             IF         COND(&SAVD *EQ 'SAVF') THEN(DO)                                   /*CBF002*/
               CHGVAR   VAR(&PRFK) VALUE('016')                                           /*CBF002*/
             ENDDO                                                                        /*CBF002*/
                                                                                          /*CBF002*/
             CHGVAR     VAR(&PRTCD) VALUE('       ')                                      /*CBF002*/
             CALL       PGM(SCC000303) PARM(&PRTCD &PRFK)                                 /*CBF002*/
                                                                                          /*CBF002*/
/** If error during save, end program */                                                  /*CBF002*/
                                                                                          /*CBF002*/
             IF         COND(&PRTCD *NE ' ') THEN(DO)                                     /*CBF002*/
               CHGJOB     SWS(XXXXXX11)                                                   /*CBF002*/
               GOTO       CMDLBL(ENDPGM)                                                  /*CBF002*/
             ENDDO                                                                        /*CBF002*/
                                                                                          /*CBF002*/
/**********  ENDDO  */                                                                 /*AR1033813*/
/**/
/*  If save of global libraries is required,                                                      */
/**/
             IF         COND(&GLOBAL *EQ 'Y') THEN(DO)
/**/
/* Save the global GMLIB.                                                                         */
/**/
             CALL       PGM(SCC1767) PARM(&GMLIB &SAVD +
                       '                    ' &DEVI &VOL1)
             RTVJOBA    SWS(&SWS)
/**/
             IF         COND(%SST(&SWS 7 1) *EQ '1') THEN(DO)
/**/
               CHGVAR     VAR(&SMSG) VALUE('Job terminated +
                          - library ' *CAT &GMLIB *CAT ' NOT saved')
               SNDMSG  MSG(&SMSG) TOMSGQ(MOPERQ)
               CHGJOB     SWS(XXXXXX11)
               GOTO       CMDLBL(ENDPGM)
/**/
             ENDDO
/**/
/* Save the global GTALIB.                                                                        */
/**/
             CALL       PGM(SCC1767) PARM(&GTALIB &SAVD +
                       '                    ' &DEVI &VOL1)
             RTVJOBA    SWS(&SWS)
/**/
             IF         COND(%SST(&SWS 7 1) *EQ '1') THEN(DO)
/**/
               CHGVAR     VAR(&SMSG) VALUE('Job terminated +
                          - library ' *CAT &GTALIB *CAT ' NOT saved')
               SNDMSG  MSG(&SMSG) TOMSGQ(MOPERQ)
               CHGJOB     SWS(XXXXXX11)
               GOTO       CMDLBL(ENDPGM)
/**/
             ENDDO
                                                                                          /*CBF002*/
/** Save the global schemas/libraries */                                                  /*CBF002*/
                                                                                          /*CBF002*/
/** Changes in parameter values for SAVLIB and SAVSAVFDTA */                              /*CBF002*/
/** commands requires an update in SCSVPRMPD file also */                                 /*CBF002*/
                                                                                          /*CBF002*/
             IF         COND(&SAVD *EQ 'TAPE') THEN(DO)                                   /*CBF002*/
             CHGVAR     VAR(&PRFK) VALUE('012')                                           /*CBF002*/
             ENDDO                                                                        /*CBF002*/
                                                                                          /*CBF002*/
             IF         COND(&SAVD *EQ 'DISK') THEN(DO)                                   /*CBF002*/
             CHGVAR     VAR(&PRFK) VALUE('014')                                           /*CBF002*/
             ENDDO                                                                        /*CBF002*/
                                                                                          /*CBF002*/
             IF         COND(&SAVD *EQ 'SAVF') THEN(DO)                                   /*CBF002*/
             CHGVAR     VAR(&PRFK) VALUE('017')                                           /*CBF002*/
             ENDDO                                                                        /*CBF002*/
                                                                                          /*CBF002*/
             CHGVAR     VAR(&PRTCD) VALUE('       ')                                      /*CBF002*/
             CALL       PGM(SCC000303) PARM(&PRTCD &PRFK)                                 /*CBF002*/
                                                                                          /*CBF002*/
/** If error during save, end program */                                                  /*CBF002*/
                                                                                          /*CBF002*/
             IF         COND(&PRTCD *NE ' ') THEN(DO)                                     /*CBF002*/
               CHGJOB     SWS(XXXXXX11)                                                   /*CBF002*/
               GOTO       CMDLBL(ENDPGM)                                                  /*CBF002*/
             ENDDO                                                                        /*CBF002*/
/**/
             ENDDO
/**/
/* Save Meridian library                                                                          */
/**/
             IF COND((&CSW025 *EQ 'Y') *AND (&MNGSYS *EQ 'Y')) +
                        THEN(DO)
/**/
                RTVDTAARA  DTAARA(MESTAT (9 10)) RTNVAR(&LIBTOSAVE)
                CALL       PGM(SCC1767) PARM(&LIBTOSAVE &SAVD +
                             '                    ' &DEVI &VOL1)
                RTVJOBA    SWS(&SWS)
/**/
                IF         COND(%SST(&SWS 7 1) *EQ '1') THEN(DO)
/**/
                   CHGVAR     VAR(&SMSG) VALUE('Job terminated - library ' +
                                *CAT &LIBTOSAVE *CAT ' NOT saved')
                   SNDMSG     MSG(&SMSG) TOMSGQ(MOPERQ)
                   CHGJOB     SWS(XXXXXX11)
                   GOTO       CMDLBL(ENDPGM)
/**/
                ENDDO
/**/
             ENDDO
                                                                                          /*CRE026*/
/** If CRE026 is *on save the Equation database library */                                /*CRE026*/
             IF         COND(&CRE026 *EQ 'Y')  THEN(DO)                                   /*CRE026*/
                                                                                          /*CRE026*/
             CHGVAR     VAR(&LIBTOSAVE) VALUE(&EQLIB *CAT '   ')                          /*CRE026*/
                                                                                          /*CRE026*/
             CALL       PGM(SCC1767) PARM(&LIBTOSAVE &SAVD +
                          '                    ' &DEVI &VOL1)                             /*CRE026*/
                                                                                          /*CRE026*/
/** Additional Processing if switch '7' is *on */                                         /*CRE026*/
             RTVJOBA    SWS(&SWS)                                                         /*CRE026*/
             IF         COND(%SST(&SWS 7 1) *EQ '1') THEN(DO)                             /*CRE026*/
             CHGVAR     VAR(&SMSG) VALUE('Job terminated - library ' +
                            *CAT &LIBTOSAVE *CAT ' NOT saved')                            /*CRE026*/
             SNDMSG     MSG(&SMSG) TOMSGQ(MOPERQ)                                         /*CRE026*/
             CHGJOB     SWS(XXXXXX11)                                                     /*CRE026*/
             GOTO       CMDLBL(ENDPGM)                                                    /*CRE026*/
             ENDDO                                                                        /*CRE026*/
                                                                                          /*CRE026*/
             ENDDO                                                                        /*CRE026*/
                                                                                          /*CRE026*/
/**/
             ENDDO
/**/
/*/COPY WNCPYSRC,SCC1712007                                                                       */
/**/
/*/COPY WNCPYSRC,SCC1712008                                                                       */
/**/
/*  Update volume ID in data area JNSTAT.                                                         */
/**/
 ALC1:       ALCOBJ     OBJ((JNSTAT *DTAARA *EXCLRD)) WAIT(1)
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(ALC1))
             RTVDTAARA  DTAARA(JNSTAT) RTNVAR(&JNSTAT)
/**/
/*  If Input Cycle  termination, use volume ID of save just completed.                            */
/**/
             IF         COND(&TIND *EQ 'T') THEN(CHGVAR +
                          VAR(%SUBSTRING(&JNSTAT 75 5)) VALUE(&VOL1))
/**/
             CHGVAR     VAR(&VAL1) VALUE(&VOL1)
/**/
/*  If run during input cycle, add 1 to volume ID of save just                                    */
/*  completed before updating JNSTAT.                                                             */
/**/
             IF         COND(&BIND *EQ 'I') THEN(DO)
               CHGVAR     VAR(&NUM) VALUE(%SUBSTRING(&VOL1 3 3))
               CHGVAR     VAR(&NUM) VALUE(&NUM + 1)
               CHGVAR     VAR(%SUBSTRING(&VOL1 3 3)) VALUE(&NUM)
               CHGVAR     VAR(%SUBSTRING(&JNSTAT 63 5)) VALUE(&VOL1)
             ENDDO
/**/
             CHGDTAARA  DTAARA(JNSTAT) VALUE(&JNSTAT)
/**/
             DLCOBJ     OBJ((JNSTAT *DTAARA *EXCLRD))
/**/
/*  Send 'SV' entry to journal                                                                    */
/**/
             CHGVAR     VAR(%SUBSTRING(&JRNE 1 5)) VALUE(&VAL1)
             CHGVAR     VAR(%SUBSTRING(&JRNE 6 8)) VALUE(&FSAV)
             CHGVAR     VAR(%SUBSTRING(&JRNE 26 4)) VALUE(&SAVD)
/**/
/*/COPY WNCPYSRC,SCC1712012                                                                       */
/**/
/**********  SNDJRNE    JRN(ICJRN) TYPE('SV') ENTDTA(&JRNE) */                           /*BUG9616*/
             SNDJRNE    JRN(ICJRN) TYPE('SV') ENTDTA(&JRNE) +
                          FORCE(*YES)                                                    /*BUG9619*/
/**/
/*/COPY WNCPYSRC,SCC1712013                                                                       */
/**/
/*  If Beginning of Business, and dual systems indicator is 'Y',                                  */
/*  save the journal library.                                                                     */
/**/
             IF         COND(&BIND *EQ 'B') THEN(DO)
             IF         COND(%SST(&JNSTAT 80 1) *EQ 'Y') THEN(DO)
             CHGVAR     VAR(%SST(&FSAV 3 5)) VALUE('JLIB ')
/**/
/*/COPY WNCPYSRC,SCC1712MP1                                                                       */
/**/
/*  Tape processing -                                                                             */
/**/
             IF         COND(&SAVD *EQ 'TAPE') THEN(DO)
/**/
             CHGVAR     VAR(&GSAV) VALUE(%SST(&FSAV 1 6) *CAT '    +
                          ')
/**/
/*/COPY WNCPYSRC,SCC1712009                                                                       */
/**/
             CALL       PGM(SCC1767) PARM(&GSAV &SAVD +
                          '                    ' &DEVI JNSAV)
/**/
/*/COPY WNCPYSRC,SCC1712010                                                                       */
/**/
             RTVJOBA    SWS(&SWS)
/**/
             IF         COND(%SST(&SWS 7 1) *EQ '1') THEN(DO)
/**/
               CHGVAR     VAR(&SMSG) VALUE('Job terminated +
                          - library ' *CAT &FSAV *CAT ' NOT saved')
               SNDMSG  MSG(&SMSG) TOMSGQ(MOPERQ)
               CHGJOB     SWS(XXXXXX11)
               GOTO       CMDLBL(ENDPGM)
/**/
             ENDDO
/**/
             ENDDO
/**/
/*  Save journal library and send message to user.                                                */
/**/
/*/COPY WNCPYSRC,SCC1712003                                                                       */
/**/
             ENDDO
/**/
             ENDDO
/**/
/*/COPY WNCPYSRC,SCC1712014                                                                       */
/**/
                         GOTO ENDPGM
/**/
/*  Error processing                                                                              */
/**/
ABNOR:
/**/
/*/COPY WNCPYSRC,SCC1712015                                                                       */
/**/
             SNDPGMMSG  MSG('Save Master Library ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             GOTO       CMDLBL(ENDPGM)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
/*/COPY WNCPYSRC,SCC1712016                                                                      */
/**/
ENDPGM:
/**/
             RETURN
             ENDPGM
/**/
/*/COPY WNCPYSRC,SCC1712017                                                                       */
