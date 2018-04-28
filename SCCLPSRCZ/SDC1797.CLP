/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SC Input cycle term database')                  */
/*********************************************************************/
/*                                                                   */
/*        Midas - System Control Module                              */
/*                                                                   */
/*       SDC1797 - SAVE MASTER LIBRARY AT INPUT CYCLE TERMINATION    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. MD030818           Date 24Nov14              */
/*       Prev Amend No. MD030956           Date 09Oct14              */
/*                      MD029775           Date 19Aug14              */
/*                      CBF002             Date 04Jul11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      247714             Date 17May07              */
/*                      CSC033             Date 22May07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*                      244885             Date 06Feb07              */
/*                      235616             Date 12Feb07              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG9619            Date 01Feb06              */
/*                      CER001             Date 25Apr05              */
/*                      BUG6521            Date 03May05              */
/*                      BUG4848            Date 11Nov04              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      207764             Date 23Jul02              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                    CSW025             Date 26Mar02                */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                    CSC012             Date 22Oct01                */
/*                    192731             Date 11Jul01                */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                    CCB009             Date 01Jun00                */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408               DATE  11APR96          */
/*                      CSC002               DATE  14MAR96          */
/*                      S01408               DATE  10MAY95          */
/*                      E29436               DATE  11OCT91          */
/*                      S01179               DATE  13/09/88         */
/*                      E10878               DATE  19/05/87         */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD030818 - TRMSAV ended abnormally due to missing DBIC     */
/*                  save file. Renamed DBIC to DBICDM.              */
/*       MD030956 - Additional changes to BFM-TI enhancement.       */
/*                  Reinstated for future use in case of downgrade. */
/*       MD029775 - TI/Midas EOD sync will no longer be used by TI  */
/*                  Plus                                            */
/*       CBF002 - BF Infrastructure: Backup and Recovery            */
/*       247714 - This is a Salesforce Reference.                   */
/*                Tape can't unload due to T2PF not found during    */
/*       CSC033 - Include global libraries in database saves.       */
/*       244885 - Add new system value "UnloadTapePostDBIC" to      */
/*                specify whether the tape should be unloaded       */
/*                after DBIC save. This allows the correct tape     */
/*                to be mounted when using an automatic cartridge   */
/*                stacker tape drive                                */
/*       235616 - Add TIxxYYYday (e.g. TIDPHK1SAT) save file       */
/*                backedup by TI server KCMSAV to the tape backup.  */
/*              - Delete TI save files when finished saving to tape */
/*       BUG9619 - Close of business components run long if journal  */
/*                 cache is enabled                                  */
/*       CER001 - LUX Upgrade to MidasPlus                          */
/*                Applied F402UP Lux Fix                            */
/*       BUG6521 - Change Volume ID to be unique for each zone.      */
/*       BUG4848- TI BACKUPS                                        */
/*       207764 - Change all SAV* and RST* commands to print a      */
/*                report of objects saved or restored.              */
/*       CSW025 - Midas Message Manager                             */
/*                - Save/restore message manager library            */
/*     CSC012 - Addition of a daily DTALIB save.                    */
/*       192731 - Change SAVLIB/SAVSAVFDTA cmds to have             */
/*                USEOPTBLK *NO instead of *YES                     */
/*       CCB009 - Journal files throughout close of business        */
/*       S01408 - Addition of core hook SDC1797INT                  */
/*                Addition of core hook SDC1797ERR                  */
/*                Addition of core hook SDC1797END                  */
/*                Addition of core hook SDC1797003                  */
/*                Addition of core hook SDC1797002                  */
/*                Addition of core hook SDC1797001                  */
/*       CSC002 - Call SCC2458 to save receivers as well            */
/*       S01408 - Addition of core hook SDC1797MP1                  */
/*       E29436 - MOVE TO SCCLSRC FROM RR.                          */
/*       S01179 - AS400 CONVERSION                                  */
/*       E10878 - WHEN PROGRAM CANCELLATION IS BEING OFFERED BY A   *  *E10878*/
/*                PROGRAM MESSAGE, ONLY THE REPLY OF AN UPPER CASE  *  *E10878*/
/*                'C' WILL CANCEL THE PROGRAM.                      *  *E10878*/
/*                                                                  */
/********************************************************************/
             PGM
/************DCLF       FILE(T2PF)                                                /*BUG4848 CSC033*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/*   INITIAL PROCESSING                                             */
/**/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,SDC1797INT                                   */      /*S01408*/
/**/                                                                  /*S01408*/
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)                                   /*BUG4848*/
/************DCL        VAR(&DEPSRV) TYPE(*CHAR) LEN(2)                           /*BUG4848 CSC033*/
/************DCL        VAR(&UNITMN) TYPE(*CHAR) LEN(3)                           /*BUG4848 CSC033*/
/************DCL        VAR(&KBSAVF) TYPE(*CHAR) LEN(10) VALUE('KAP       ')      /*BUG4848 CSC033*/
/************DCL        VAR(&TISAVF) TYPE(*CHAR) LEN(10) VALUE('          ')      /*BUG4848 CSC033*/
/************DCL        VAR(&TISAV2) TYPE(*CHAR) LEN(10) VALUE('TI        ')       /*235616 CSC033*/
/************DCL        VAR(&DAY) TYPE(*CHAR) LEN(4)                               /*235616 CSC033*/
/************DCL        VAR(&RUNDAT) TYPE(*CHAR) LEN(13)                          /*BUG4848 CSC033*/
             DCL        VAR(&SMSG) TYPE(*CHAR) LEN(132)
             DCL        VAR(&JRNE) TYPE(*CHAR) LEN(200)
             DCL        VAR(&RMSG) TYPE(*CHAR) LEN(132)
             DCL        VAR(&MONIND) TYPE(*LGL) LEN(1)
             DCL        VAR(&VAL1) TYPE(*CHAR) LEN(5)
             DCL        VAR(&FSAV) TYPE(*CHAR) LEN(8) VALUE('  DILIB ')
             DCL        VAR(&DEVI) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SAVD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&VOL1) TYPE(*CHAR) LEN(5) VALUE('DB   ')
             DCL        VAR(&KEYVAR) TYPE(*CHAR) LEN(4)
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                                    /*247714*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')                          /*247714*/
/**/
/**********  DCLDTAARA  DTAARA(JNSTAT)                              *  *S01179*/
             DCL        VAR(&JNSTAT) TYPE(*CHAR) LEN(200)             /*S01179*/
/**********  DCLDTAARA  DTAARA(SDSTAT)                              *  *S01179*/
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)             /*S01179*/
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7) VALUE(' ')                         /*CSW025*/
             DCL        VAR(&CSW025) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CSW025*/
             DCL        VAR(&SAVEFILE) TYPE(*CHAR) LEN(10)                                /*CSW025*/
             DCL        VAR(&MNGSYS) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CSW025*/
/************DCL        VAR(&TAPOPT) TYPE(*CHAR) LEN(5)                           /*BUG6521 CSC033*/
             DCL        VAR(&UNLTAP) TYPE(*CHAR) LEN(1)                                   /*244885*/
/************DCL        VAR(&TIBKLIB) TYPE(*CHAR) LEN(10) +
                          VALUE('TIBACKUPS')                                       /*235616 CSC033*/
             DCL        VAR(&GMLIB) TYPE(*CHAR) LEN(10)                                   /*CSC033*/
             DCL        VAR(&GTALIB) TYPE(*CHAR) LEN(10)                                  /*CSC033*/
             DCL        VAR(&SAVE_FILE3) TYPE(*CHAR) LEN(20)                              /*CSC033*/
             DCL        VAR(&SAVE_FILE4) TYPE(*CHAR) LEN(20)                              /*CSC033*/
             DCL        VAR(&GLOBAL) TYPE(*CHAR) LEN(1)                                   /*CSC033*/
             DCL        VAR(&GLOBID) TYPE(*CHAR) LEN(2)                                   /*CSC033*/
             DCL        VAR(&USESID) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CSC033*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                                    /*CSC033*/
             DCL        VAR(&TI) TYPE(*CHAR) LEN(1)                                       /*CSC033*/
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(7)                                      /*CSC033*/
             DCL        VAR(&PRFK) TYPE(*CHAR) LEN(3) VALUE(' ')                          /*CBF002*/
/*/COPY WNCPYSRC,SDC1797006                                          */
/*/COPY SDCPYSRC,SDSVALDCL                                           */                   /*244885*/
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO ABNOR)
/************RTVDTAARA  DTAARA(TAPOPT) RTNVAR(&TAPOPT)                            /*BUG6521 CSC033*/
             RTVDTAARA  DTAARA(JNSTAT (173 1)) RTNVAR(&USESID)                            /*CSC033*/
                                                                                          /*CSW025*/
             CALL (AOSARDR0) PARM(&PRTCD '*VERIFY' 'CSW025')                              /*CSW025*/
             IF (&PRTCD *EQ ' ') (CHGVAR (&CSW025) VALUE('Y'))                            /*CSW025*/
                                                                                          /*CSW025*/
             RTVDTAARA  DTAARA(MESTAT (50 1)) RTNVAR(&MNGSYS)                             /*CER001*/
 
             CALL       PGM(AOMMODR0) PARM(&RTCD '*FIRST' &FMT)                           /*247714*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,SDC1797001                                        */ /*S01408*/
/**/                                                                  /*S01408*/
/**/
             SNDPGMMSG  MSG('Saving Master Library') TOMSGQ(MRUNQ)
/*                                                                                        /*CSC033*/
/* Access PF/SDMMODPD to determine which modules are live                                 /*CSC033*/
/*                                                                                        /*CSC033*/
             CALL       PGM(AOMMODR0) PARM(&RTN '*FIRST' &FMT)                            /*CSC033*/
/*                                                                                        /*CSC033*/
/* Determine whether Trade Innovation Interface is present.                               /*CSC033*/
/*                                                                                        /*CSC033*/
             IF         COND(%SST(&FMT 103 1) *EQ 'Y') THEN(DO)                           /*CSC033*/
             CHGVAR     VAR(&TI) VALUE('Y')                                               /*CSC033*/
             ENDDO                                                                        /*CSC033*/
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
/*/COPY WNCPYSRC,SCH00034                                            */
/**/
/*   CHECK THAT THE REQUIRED DATA AREAS EXIST                                 */
/**/
/* JNSTAT */
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
/* SDSTAT */
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
/**********  RCVDTAARA  DTAARA(JNSTAT)                              *  *S01179*/
             RTVDTAARA  DTAARA(JNSTAT) RTNVAR(&JNSTAT)                /*S01179*/
/**/
/*  OBTAIN LIBRARY ID FROM SDSTAT                                             */
/**/
/**********  RCVDTAARA  DTAARA(SDSTAT)                              *  *S01179*/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)                /*S01179*/
             CHGVAR     VAR(%SUBSTRING(&FSAV 1 2)) +
                          VALUE(%SUBSTRING(&SDSTAT 6 2))
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC1797MP1                                          */
                                                                      /*S01408*/
/**/
/*  OBTAIN MEDIA, DEVICE NAME & AND VOLUME ID FOR I-C SAVE FROM JNSTAT        */
/**/
               CHGVAR     VAR(&DEVI) +
                          VALUE(%SUBSTRING(&JNSTAT 53 10))
               CHGVAR     VAR(&SAVD) +
                          VALUE(%SUBSTRING(&JNSTAT 49 4))
               CHGVAR     VAR(&VOL1) +
                          VALUE(%SUBSTRING(&JNSTAT 63 5))
/*/COPY WNCPYSRC,SDC1797017                                          */
/**/                                                                                      /*CSC033*/
/** Check whether global library save is required.                                        /*CSC033*/
/**/                                                                                      /*CSC033*/
             CHGVAR     VAR(&GLOBAL) VALUE(%SST(&JNSTAT 172 1))                           /*CSC033*/
/**/                                                                                      /*CSC033*/
/* If save of global libraries is required,                                               /*CSC033*/
/**/                                                                                      /*CSC033*/
             IF         COND(&GLOBAL *EQ 'Y') THEN(DO)                                    /*CSC033*/
/*                                                                                        /*CSC033*/
/*  determine global system ID.                                                           /*CSC033*/
/*                                                                                        /*CSC033*/
             CALL       PGM(AOSVALR0) PARM(&RSVALRTNC +
                          'BrgMidasGlobalPrefix' &SVAL1 &SVALK2 +
                          &SVAL2 &SVALK3 &SVAL3 &SVALK4 &SVAL4 +
                          &SVALK5 &SVAL5 &SVALK6 &SVAL6 &SVALK7 +
                          &SVAL7 &SVALK8 &SVAL8 &SVALK9 &SVAL9 +
                          &SVALK10 &SVAL10)                                               /*CSC033*/
/*                                                                                        /*CSC033*/
/* If there is an error finding any system value then end abnormally */                   /*CSC033*/
/*                                                                                        /*CSC033*/
             IF         COND(&RSVALRTNC *NE '       ') THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*CSC033*/
/**/                                                                                      /*CSC033*/
/*  Calculate names of global libraries.                                                  /*CSC033*/
/**/                                                                                      /*CSC033*/
             CHGVAR     VAR(&GLOBID) VALUE(&SVAL1)                                        /*CSC033*/
             CHGVAR     VAR(&GMLIB) VALUE(&GLOBID *CAT 'GMLIB   ')                        /*CSC033*/
             CHGVAR     VAR(&GTALIB) VALUE(&GLOBID *CAT 'GTALIB  ')                       /*CSC033*/
/**/                                                                                      /*CSC033*/
/* Determine Input Cycle save file names for global libraries.                            /*CSC033*/
/**/                                                                                      /*CSC033*/
             CHGVAR     VAR(&SAVE_FILE3) VALUE('DBICGM    xxDILIB   ')                    /*CSC033*/
             CHGVAR     VAR(%SST(&SAVE_FILE3 11 2)) +
                          VALUE(%SST(&SDSTAT 6 2))                                        /*CSC033*/
             CHGVAR     VAR(&SAVE_FILE4) VALUE(&SAVE_FILE3)                               /*CSC033*/
             CHGVAR     VAR(%SST(&SAVE_FILE4 5 3)) VALUE('GTA')                           /*CSC033*/
/**/                                                                                      /*CSC033*/
             ENDDO                                                                        /*CSC033*/
/**/                                                                                      /*CSC033*/
/**/
/*  DISKETTE PROCESSING - CHECK DEVICE HAS BEEN LOADED CORRECTLY              */
/**/
             IF         COND(&SAVD *EQ 'DKTE') THEN(DO)
 CHECK1:     CHKDKT     DEV(DKT01) VOL(&VOL1)
 
             MONMSG     MSGID(CPF6162 CPF6165 CPF4128 CPF6708) EXEC(DO)
                             CHGVAR     VAR(&MONIND) VALUE('1')
                             SNDPGMMSG  MSG('Diskette with volume ID ' *CAT  +
                                             &VOL1 *CAT ' not found. Mount +
                                             the correct diskette and retry OR +
                                             enter "C" to cancel and end +
                                             program.') KEYVAR(&KEYVAR)  +
                                        MSGTYPE(*INQ) TOMSGQ(MOPERQ)
                        ENDDO
/**/
                        MONMSG     MSGID(CPF6164) EXEC(DO)
                             CHGVAR     VAR(&MONIND) VALUE('1')
                             SNDPGMMSG  MSG('Unable to read diskette due to +
                                             surface defect. Mount another +
                                             diskette and retry OR enter "C" +
                                             to cancel and end program.') +
                                        MSGTYPE(*INQ) TOMSGQ(MOPERQ) +
                                        KEYVAR(&KEYVAR)
                        ENDDO
/**/
/*  IF ERROR MSG SENT, WAIT FOR REPLY. IF 'C', END PROGRAM (& IF B.O.B.       */
/*  BLANK OUT JNSTAT) ELSE RETURN TO CHECK1                                   */
/**/
                        IF         COND(&MONIND *EQ '1') THEN(DO)
/**/
                             RCVMSG                  MSGKEY(&KEYVAR) +
                             WAIT(*MAX) KEYVAR(&KEYVAR) MSG(&RMSG)
/**/
/****************************IF         COND(&RMSG *EQ 'C') THEN(DO)*  *E10878*/
                    IF ((&RMSG *EQ 'C') *OR (&RMSG *EQ 'c')) THEN(DO) /*E10878*/
                               SNDPGMMSG  MSG('Save Master Library +
                                              - CANCELLED')
                               CHGJOB SWS(XXXXXX1X)
                               GOTO ENDPGM
                             ENDDO
/**/
                             ELSE DO
                               CHGVAR     VAR(&MONIND) VALUE('0')
                               GOTO CHECK1
                             ENDDO
/**/
                        ENDDO
/**/
             ENDDO
/**/
/*  TAPE PROCESSING - CHECK DEVICE HAS BEEN LOADED CORRECTLY                  */
/**/
             IF         COND(&SAVD *EQ 'TAPE') THEN(DO)
/*/COPY WNCPYSRC,SDC1797007                                          */
/********** CHECK2:                 CHKTAP     DEV(&DEVI) VOL(&VOL1)                     /*BUG6521*/
CHECK2:      RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)                              /*BUG6521*/
/************IF         COND((&TAPOPT *EQ 'SYSID') *AND (%SST(&VOL1 +
                          1 2) *EQ 'DB')) THEN(CHGVAR VAR(&VOL1) +
                          VALUE(&SYSID *TCAT %SST(&VOL1 3 3)))                    /*BUG6521 CSC033*/
             IF         COND((&USESID *EQ 'Y') *AND (%SST(&VOL1 +
                          1 2) *EQ 'DB')) THEN(CHGVAR VAR(&VOL1) +
                          VALUE(&SYSID *TCAT %SST(&VOL1 3 3)))                            /*CSC033*/
             CHKTAP     DEV(&DEVI) VOL(&VOL1)                                            /*BUG6521*/
/*/COPY WNCPYSRC,SDC1797014                                          */
/**/
                        MONMSG     MSGID(CPF6718) EXEC(DO)
                             CHGVAR     VAR(&MONIND) VALUE('1')
                             SNDPGMMSG  MSG('Unable to allocate device. Retry +
                                             if device becomes available and +
                                             mount volume ' *CAT &VOL1 *CAT +
                                             ' OR enter "C" to cancel and end +
                                             program.') +
                                        MSGTYPE(*INQ) TOMSGQ(MOPERQ) +
                                        KEYVAR(&KEYVAR)
                        ENDDO
/**/
/*/COPY WNCPYSRC,SDC1797015                                          */
                        MONMSG     MSGID(CPF6720) EXEC(DO)
                             CHGVAR     VAR(&MONIND) VALUE('1')
                             SNDPGMMSG  MSG('Tape with volume ID ' *CAT  +
                                             &VOL1 *CAT ' not found. Mount +
                                             the correct tape and retry OR +
                                             enter "C" to cancel and end +
                                             program.') +
                                        MSGTYPE(*INQ) TOMSGQ(MOPERQ) +
                                        KEYVAR(&KEYVAR)
                        ENDDO
/*/COPY WNCPYSRC,SDC1797016                                          */
/**/
                        MONMSG     MSGID(CPF6760) EXEC(DO)
                             CHGVAR     VAR(&MONIND) VALUE('1')
                             SNDPGMMSG  MSG('Device not ready. Mount volume +
                                             with ID ' *CAT &VOL1 *CAT ' on +
                                             device, press START and retry OR +
                                             enter "C" to cancel and end +
                                             program.') +
                                        MSGTYPE(*INQ) TOMSGQ(MOPERQ) +
                                        KEYVAR(&KEYVAR)
                        ENDDO
/**/
                        MONMSG     MSGID(CPF6772) EXEC(DO)
                             CHGVAR     VAR(&MONIND) VALUE('1')
                             SNDPGMMSG  MSG('Cannot process mounted vol.Clean +
                                             tape path & heads,& retry OR +
                                             enter"C"to cancel program.If +
                                             problem recurs,mount another vol +
                                             & retry.') +
                                        MSGTYPE(*INQ) TOMSGQ(MOPERQ) +
                                        KEYVAR(&KEYVAR)
                        ENDDO
/**/
                        MONMSG     MSGID(CPF9814) EXEC(DO)
                             CHGVAR     VAR(&MONIND) VALUE('1')
                             SNDPGMMSG  MSG('Device not found. Mount volume +
                                             with ID ' *CAT &VOL1 *CAT ' on +
                                             correct device and retry OR enter +
                                             "C" to cancel and end program.') +
                                        MSGTYPE(*INQ) TOMSGQ(MOPERQ) +
                                        KEYVAR(&KEYVAR)
                        ENDDO
/*/COPY WNCPYSRC,SDC1797008                                          */
/**/
/*  IF ERROR MSG SENT, WAIT FOR REPLY. IF 'C', END PROGRAM (& IF B.O.B.       */
/*  BLANK OUT JNSTAT) ELSE RETURN TO CHECK2                                   */
/**/
                        IF         COND(&MONIND *EQ '1') THEN(DO)
/**/
                             RCVMSG                  MSGKEY(&KEYVAR) +
                             WAIT(*MAX) KEYVAR(&KEYVAR) MSG(&RMSG)
/**/
/****************************IF         COND(&RMSG *EQ 'C') THEN(DO)*  *E10878*/
                    IF ((&RMSG *EQ 'C') *OR (&RMSG *EQ 'c')) THEN(DO) /*E10878*/
                               SNDPGMMSG  MSG('Save Master Library +
                                               - CANCELLED')
                               CHGJOB SWS(XXXXXX1X)
                               GOTO ENDPGM
                             ENDDO
/**/
                             ELSE DO
                               CHGVAR     VAR(&MONIND) VALUE('0')
/*/COPY WNCPYSRC,SDC1797009                                          */
                               GOTO CHECK2
                             ENDDO
/**/
                        ENDDO
/**/
             ENDDO
/**/
/*  SAVE MASTER LIBRARY AND SEND MESSAGE TO USER                              */
/**/
             CHGVAR     VAR(&SMSG) VALUE('Save of library ' +
                          *CAT &FSAV *CAT ' in progress')
             SNDMSG  MSG(&SMSG) TOMSGQ(MOPERQ)
/**/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,SDC1797002                                   */      /*S01408*/
/**/                                                                  /*S01408*/
/**********  SAVSAVFDTA SAVF(&FSAV/DBIC) DEV(&DEVI) VOL(*MOUNTED)     /*192731*/
/**********  SAVSAVFDTA SAVF(&FSAV/DBIC) DEV(&DEVI) VOL(*MOUNTED) + */         /*192731*/ /*207764*/
/**********  USEOPTBLK(*NO)                                         */         /*192731*/ /*207764*/
/**********  SAVSAVFDTA SAVF(&FSAV/DBIC) DEV(&DEVI) VOL(*MOUNTED) + */           /*207764 MD030818*/
/**********  USEOPTBLK(*NO) OUTPUT(*PRINT)                          */           /*207764 MD030818*/
             SAVSAVFDTA SAVF(&FSAV/DBICDM) DEV(&DEVI) VOL(*MOUNTED) +
             USEOPTBLK(*NO) OUTPUT(*PRINT)                                              /*MD030818*/
/*/COPY WNCPYSRC,SDC1797005                                          */
/**/
             MONMSG     MSGID(CPF0000) EXEC(DO)
/*/COPY WNCPYSRC,SDC1797004                                          */
/**/
/*  IF ERROR DURING SAVE, END PROGRAM                                         */
/**/
               CHGVAR     VAR(&SMSG) VALUE('Job terminated +
                          - library ' *CAT &FSAV *CAT ' NOT saved')
               SNDMSG  MSG(&SMSG) TOMSGQ(MOPERQ)
               CHGJOB     SWS(XXXXXX11)
               GOTO       CMDLBL(ENDPGM)
             ENDDO
                                                                                          /*CSC012*/
/*/COPY WNCPYSRC,SCH00035                                            */
/* Save the DTALIB */                                                                     /*CSC012*/
                                                                                          /*CSC012*/
/**********  SAVSAVFDTA SAVF(&FSAV/DBICDTA) DEV(&DEVI) VOL(*MOUNTED) + */      /*CSC012*/ /*207764*/
/**********               USEOPTBLK(*NO)                               */      /*CSC012*/ /*207764*/
             SAVSAVFDTA SAVF(&FSAV/DBICDTA) DEV(&DEVI) VOL(*MOUNTED) +
                          USEOPTBLK(*NO) OUTPUT(*PRINT)                                   /*207764*/
                                                                                          /*CSC012*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                                           /*CSC012*/
                                                                                          /*CSC012*/
/* If error during save, end program */                                                   /*CSC012*/
                                                                                          /*CSC012*/
               CHGVAR     VAR(&SMSG) VALUE('Job terminated +
                          - library ' *CAT &FSAV *CAT ' NOT saved')                       /*CSC012*/
               SNDMSG  MSG(&SMSG) TOMSGQ(MOPERQ)                                          /*CSC012*/
               CHGJOB     SWS(XXXXXX11)                                                   /*CSC012*/
               GOTO       CMDLBL(ENDPGM)                                                  /*CSC012*/
             ENDDO                                                                        /*CSC012*/
                                                                                          /*CBF002*/
/** Call SCC000303 to perform BF database backup */                                       /*CBF002*/
/** Save BF schemas found in Schemas/Libraries file */                                    /*CBF002*/
                                                                                          /*CBF002*/
/** Changes in parameter values for SAVLIB and SAVSAVFDTA */                              /*CBF002*/
/** commands requires an update in SCSVPRMPD file also */                                 /*CBF002*/
                                                                                          /*CBF002*/
             IF         COND(&SAVD *EQ 'TAPE') THEN(DO)                                   /*CBF002*/
               CHGVAR     VAR(&PRFK) VALUE('001')                                         /*CBF002*/
             ENDDO                                                                        /*CBF002*/
             ELSE       CMD(DO)                                                           /*CBF002*/
               CHGVAR     VAR(&PRFK) VALUE('003')                                         /*CBF002*/
             ENDDO                                                                        /*CBF002*/
                                                                                          /*CBF002*/
             CALL       PGM(SCC000303) PARM(&RTCD &PRFK)                                  /*CBF002*/
                                                                                          /*CBF002*/
/** If error during save, end program */                                                  /*CBF002*/
                                                                                          /*CBF002*/
             IF         COND(&RTCD *NE ' ') THEN(DO)                                      /*CBF002*/
               CHGJOB     SWS(XXXXXX11)                                                   /*CBF002*/
               GOTO       CMDLBL(ENDPGM)                                                  /*CBF002*/
             ENDDO                                                                        /*CBF002*/
/**/                                                                                      /*CSC033*/
/* If save of global libraries is required,                                               /*CSC033*/
/**/                                                                                      /*CSC033*/
             IF         COND(&GLOBAL *EQ 'Y') THEN(DO)                                    /*CSC033*/
/**/                                                                                      /*CSC033*/
/* Save the global GMLIB.                                                                 /*CSC033*/
/**/                                                                                      /*CSC033*/
             SAVSAVFDTA SAVF(&FSAV/DBICGM) DEV(&DEVI) VOL(*MOUNTED) +
                          USEOPTBLK(*NO) OUTPUT(*PRINT)                                   /*CSC033*/
                                                                                          /*CSC033*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                                           /*CSC033*/
                                                                                          /*CSC033*/
/* If error during save, end program */                                                   /*CSC033*/
                                                                                          /*CSC033*/
               CHGVAR     VAR(&SMSG) VALUE('Job terminated +
                          - library ' *CAT &GMLIB *CAT ' NOT saved')                      /*CSC033*/
               SNDMSG  MSG(&SMSG) TOMSGQ(MOPERQ)                                          /*CSC033*/
               CHGJOB     SWS(XXXXXX11)                                                   /*CSC033*/
               GOTO       CMDLBL(ENDPGM)                                                  /*CSC033*/
             ENDDO                                                                        /*CSC033*/
/**/                                                                                      /*CSC033*/
/* Save the global GTALIB.                                                                /*CSC033*/
/**/                                                                                      /*CSC033*/
             SAVSAVFDTA SAVF(&FSAV/DBICGTA) DEV(&DEVI) VOL(*MOUNTED) +
                          USEOPTBLK(*NO) OUTPUT(*PRINT)                                   /*CSC033*/
                                                                                          /*CSC033*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                                           /*CSC033*/
                                                                                          /*CSC033*/
/* If error during save, end program */                                                   /*CSC033*/
                                                                                          /*CSC033*/
               CHGVAR     VAR(&SMSG) VALUE('Job terminated +
                          - library ' *CAT &GTALIB *CAT ' NOT saved')                     /*CSC033*/
               SNDMSG  MSG(&SMSG) TOMSGQ(MOPERQ)                                          /*CSC033*/
               CHGJOB     SWS(XXXXXX11)                                                   /*CSC033*/
               GOTO       CMDLBL(ENDPGM)                                                  /*CSC033*/
             ENDDO                                                                        /*CSC033*/
                                                                                          /*CBF002*/
/** Call SCC000303 to perform BF database backup */                                       /*CBF002*/
/** Save global libraries in the Schemas/Libraries File */                                /*CBF002*/
                                                                                          /*CBF002*/
/** Changes in parameter values for SAVLIB and SAVSAVFDTA */                              /*CBF002*/
/** commands requires an update in SCSVPRMPD file also */                                 /*CBF002*/
                                                                                          /*CBF002*/
             IF         COND(&SAVD *EQ 'TAPE') THEN(DO)                                   /*CBF002*/
               CHGVAR     VAR(&PRFK) VALUE('002')                                         /*CBF002*/
             ENDDO                                                                        /*CBF002*/
             ELSE       CMD(DO)                                                           /*CBF002*/
               CHGVAR     VAR(&PRFK) VALUE('004')                                         /*CBF002*/
             ENDDO                                                                        /*CBF002*/
                                                                                          /*CBF002*/
             CALL       PGM(SCC000303) PARM(&RTCD &PRFK)                                  /*CBF002*/
                                                                                          /*CBF002*/
/** If error during save, end program */                                                  /*CBF002*/
                                                                                          /*CBF002*/
             IF         COND(&RTCD *NE ' ') THEN(DO)                                      /*CBF002*/
               CHGJOB     SWS(XXXXXX11)                                                   /*CBF002*/
               GOTO       CMDLBL(ENDPGM)                                                  /*CBF002*/
             ENDDO                                                                        /*CBF002*/
/**/                                                                                      /*CSC033*/
/**/                                                                                      /*CSC033*/
             ENDDO                                                                        /*CSC033*/
/**/                                                                                      /*CSC033*/
/**/
             IF COND((&CSW025 *EQ 'Y') *AND (&MNGSYS *EQ 'Y')) +
                        THEN(DO)                                                          /*CSW025*/
                RTVDTAARA  DTAARA(MESTAT (19 10)) RTNVAR(&SAVEFILE)                       /*CSW025*/
/**********     SAVSAVFDTA SAVF(&FSAV/&SAVEFILE) DEV(&DEVI) + */               /*CSW025*/ /*207764*/
/**********                  VOL(*MOUNTED) USEOPTBLK(*NO)     */               /*CSW025*/ /*207764*/
                SAVSAVFDTA SAVF(&FSAV/&SAVEFILE) DEV(&DEVI) +
                             VOL(*MOUNTED) USEOPTBLK(*NO) +
                             OUTPUT(*PRINT)                                               /*207764*/
                                                                                          /*CSW025*/
/* If error during save, end program */                                                   /*CSW025*/
                MONMSG     MSGID(CPF0000) EXEC(DO)                                        /*CSW025*/
                  CHGVAR     VAR(&SMSG) VALUE('Job terminated +
                             - library ' *CAT &FSAV *CAT ' +
                             NOT saved')                                                  /*CSW025*/
                  SNDMSG  MSG(&SMSG) TOMSGQ(MOPERQ)                                       /*CSW025*/
                  CHGJOB     SWS(XXXXXX11)                                                /*CSW025*/
                  GOTO       CMDLBL(ENDPGM)                                               /*CSW025*/
                ENDDO                                                                     /*CSW025*/
/*/COPY WNCPYSRC,SCH00036                                            */
             ENDDO                                                                        /*CSW025*/
                                                                                         /*BUG4848*/
             IF         COND(%SST(&FMT 103 1) *NE 'Y') THEN(GOTO +
                          CMDLBL(SKIP_TI))                                                /*247714*/
 
/**Call*TIC000002*to*perform*TI*database*backup,**********************/          /*CSC033 MD029775*/
/**if*Trade*Innovation*module*is*present.*****************************/          /*CSC033 MD029775*/
/**/                                                                                      /*CSC033*/
/**********  IF         COND(&TI *EQ 'Y') THEN(DO)                               /*CSC033 MD029775*/
/**********  CALL       PGM(TIC000002)                                           /*CSC033 MD029775*/
/**********  ENDDO                                                               /*CSC033 MD029775*/
                                                                                        /*MD030956*/
/* Call TIC000002 to perform TI database backup,                                        /*MD030956*/
/* if Trade Innovation module is present.                                               /*MD030956*/
/**/                                                                                    /*MD030956*/
             IF         COND(&TI *EQ 'Y') THEN(DO)                                      /*MD030956*/
             CALL       PGM(TIC000002)                                                  /*MD030956*/
             ENDDO                                                                      /*MD030956*/
                                                                                          /*CSC033*/
/************CHKOBJ OBJ(TIBACKUPS) OBJTYPE(*LIB)                                  /*BUG4848 CSC033*/
/************MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(ALC1))                /*BUG4848*/ /*244885*/
/************MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(UNL1))                     /*244885 CSC033*/
/************                                                                            /*BUG4848*/
/**SYSTEM*ID*AND*RUN*DATE*/                                                       /*BUG4848 CSC033*/
/************RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)                       /*BUG4848 CSC033*/
/************RTVDTAARA  DTAARA(RUNDAT) RTNVAR(&RUNDAT)                            /*BUG4848 CSC033*/
/************IF         COND(%SST(&RUNDAT 1 1) = ' ') THEN(CHGVAR +
/************             VAR(%SST(&RUNDAT 1 1)) VALUE('0'))                      /*BUG4848 CSC033*/
/************                                                                     /*BUG4848 CSC033*/
/**READ:*****                                                                     /*BUG4848 CSC033*/
/************RCVF                                                                 /*BUG4848 CSC033*/
/************MONMSG     MSGID(CPF0864) EXEC(DO)                                   /*BUG4848 CSC033*/
/************   GOTO       CMDLBL(ENDREAD)                                        /*BUG4848 CSC033*/
/************ENDDO                                                                /*BUG4848 CSC033*/
/************                                                                     /*BUG4848 CSC033*/
/**Only*carry*out*check*if*unit*mnemonic*belongs*to*this*system. */               /*BUG4848 CSC033*/
/************IF         COND(%SST(&T2UMN 1 2) *NE &SYSID) THEN(DO)                /*BUG4848 CSC033*/
/************   GOTO       CMDLBL(READ)                                           /*BUG4848 CSC033*/
/************ENDDO                                                                /*BUG4848 CSC033*/
/************                                                                     /*BUG4848 CSC033*/
/************CHGVAR     VAR(&DEPSRV) VALUE(&T2DSM)                                /*BUG4848 CSC033*/
/************CHGVAR     VAR(&UNITMN) VALUE(&T2UMN)                                /*BUG4848 CSC033*/
/************                                                                     /*BUG4848 CSC033*/
/************GOTO       CMDLBL(READ)                                              /*BUG4848 CSC033*/
/**ENDREAD:**                                                                     /*BUG4848 CSC033*/
/************  CHGVAR     VAR(%SUBSTRING(&KBSAVF 4 2)) +
/************             VALUE(&DEPSRV)                                          /*BUG4848 CSC033*/
/************  CHGVAR     VAR(%SUBSTRING(&KBSAVF 6 5)) +
/************             VALUE(%SST(&RUNDAT 1 5))                                /*BUG4848 CSC033*/
/************                                                                     /*BUG4848 CSC033*/
/************  CHGVAR     VAR(%SUBSTRING(&TISAVF 1 2)) +
/************             VALUE(&DEPSRV)                                          /*BUG4848 CSC033*/
/************  CHGVAR     VAR(%SUBSTRING(&TISAVF 3 3)) +
/************             VALUE(&UNITMN)                                          /*BUG4848 CSC033*/
/************  CHGVAR     VAR(%SUBSTRING(&TISAVF 6 5)) +
/************             VALUE(%SST(&RUNDAT 1 5))                                /*BUG4848 CSC033*/
/************                                                                     /*BUG4848 CSC033*/
/************SAVSAVFDTA SAVF(TIBACKUPS/&KBSAVF) DEV(&DEVI) +
/************             VOL(*MOUNTED) USEOPTBLK(*NO) +
/************             OUTPUT(*PRINT)                                          /*BUG4848 CSC033*/
/************                                                                     /*BUG4848 CSC033*/
/************MONMSG     MSGID(CPF0000) EXEC(DO)                                   /*BUG4848 CSC033*/
/************                                                                     /*BUG4848 CSC033*/
/**If*error*during*save,*end*program**/                                           /*BUG4848 CSC033*/
/************                                                                     /*BUG4848 CSC033*/
/************  CHGVAR     VAR(&SMSG) VALUE('Job terminated +
/************             - file ' *CAT &KBSAVF *CAT ' NOT saved')                /*BUG4848 CSC033*/
/************  SNDMSG  MSG(&SMSG) TOMSGQ(MOPERQ)                                  /*BUG4848 CSC033*/
/************  CHGJOB     SWS(XXXXXX11)                                           /*BUG4848 CSC033*/
/************  GOTO       CMDLBL(ENDPGM)                                          /*BUG4848 CSC033*/
/************ENDDO                                                                /*BUG4848 CSC033*/
/************                                                                     /*BUG4848 CSC033*/
/************SAVSAVFDTA SAVF(TIBACKUPS/&TISAVF) DEV(&DEVI) +
/************             VOL(*MOUNTED) USEOPTBLK(*NO) +
/************             OUTPUT(*PRINT)                                          /*BUG4848 CSC033*/
/************                                                                     /*BUG4848 CSC033*/
/************MONMSG     MSGID(CPF0000) EXEC(DO)                                   /*BUG4848 CSC033*/
/************                                                                     /*BUG4848 CSC033*/
/**If*error*during*save,*end*program**/                                           /*BUG4848 CSC033*/
/************                                                                     /*BUG4848 CSC033*/
/************  CHGVAR     VAR(&SMSG) VALUE('Job terminated +
/************             - file ' *CAT &TISAVF *CAT ' NOT saved')                /*BUG4848 CSC033*/
/************  SNDMSG  MSG(&SMSG) TOMSGQ(MOPERQ)                                  /*BUG4848 CSC033*/
/************  CHGJOB     SWS(XXXXXX11)                                           /*BUG4848 CSC033*/
/************  GOTO       CMDLBL(ENDPGM)                                          /*BUG4848 CSC033*/
/************ENDDO                                                                /*BUG4848 CSC033*/
/************                                                                      /*235616 CSC033*/
/**Save*TIxxYYYday*as*save*by*TI*KCMSAV*by*CSCS*server                             /*235616 CSC033*/
/************  CHGVAR     VAR(%SUBSTRING(&TISAV2 3 2)) +
/************             VALUE(&DEPSRV)                                           /*235616 CSC033*/
/************  CHGVAR     VAR(%SUBSTRING(&TISAV2 5 3)) +
/************             VALUE(&UNITMN)                                           /*235616 CSC033*/
/************  RTVSYSVAL SYSVAL(QDAYOFWEEK) RTNVAR(&DAY)                           /*235616 CSC033*/
/************  CHGVAR     VAR(%SUBSTRING(&TISAV2 8 3)) +
/************             VALUE(%SST(&DAY 2 3))                                    /*235616 CSC033*/
/************                                                                      /*235616 CSC033*/
/************SAVSAVFDTA SAVF(TIBACKUPS/&TISAV2) DEV(&DEVI) +
/************             VOL(*MOUNTED) USEOPTBLK(*NO) +
/************             OUTPUT(*PRINT)                                           /*235616 CSC033*/
/************MONMSG     MSGID(CPF0000) EXEC(DO)                                    /*235616 CSC033*/
/************                                                                      /*235616 CSC033*/
/**If*error*during*save,*end*program**/                                            /*235616 CSC033*/
/************                                                                      /*235616 CSC033*/
/************  CHGVAR     VAR(&SMSG) VALUE('Job terminated +
/************             - file ' *CAT &TISAVF *CAT ' NOT saved')                 /*235616 CSC033*/
/************  SNDMSG  MSG(&SMSG) TOMSGQ(MOPERQ)                                   /*235616 CSC033*/
/************  CHGJOB     SWS(XXXXXX11)                                            /*235616 CSC033*/
/************  GOTO       CMDLBL(ENDPGM)                                           /*235616 CSC033*/
/************ENDDO                                                                 /*235616 CSC033*/
/************                                                                      /*235616 CSC033*/
/************                                                                      /*235616 CSC033*/
/************CHGVAR     VAR(&RMSG) VALUE('Y')                                      /*235616 CSC033*/
/************SNDPGMMSG  MSG('Deleting TI Save files.') TOMSGQ(QSYSOPR)             /*235616 CSC033*/
/************SNDPGMMSG  MSG('Delete TI Save files? Y/N') +
/************             TOMSGQ(MOPERQ) MSGTYPE(*INQ) KEYVAR(&KEYVAR)             /*235616 CSC033*/
/************RCVMSG     MSGKEY(&KEYVAR) WAIT(300) KEYVAR(&KEYVAR) +
/************             MSG(&RMSG)                                               /*235616 CSC033*/
/************IF ((&RMSG *EQ 'Y') *OR (&RMSG *EQ 'y')) THEN(DO)                     /*235616 CSC033*/
/************DLTF       FILE(&TIBKLIB/&KBSAVF)                                     /*235616 CSC033*/
/************MONMSG     MSGID(CPF0000)                                             /*235616 CSC033*/
/************DLTF       FILE(&TIBKLIB/&TISAVF)                                     /*235616 CSC033*/
/************MONMSG     MSGID(CPF0000)                                             /*235616 CSC033*/
/************DLTF       FILE(&TIBKLIB/&TISAV2)                                     /*235616 CSC033*/
/************MONMSG     MSGID(CPF0000)                                             /*235616 CSC033*/
/************ENDDO                                                                 /*235616 CSC033*/
SKIP_TI:                                                                                  /*247714*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,SDC1797003                                   */      /*S01408*/
/**/                                                                  /*S01408*/
UNL1:                                                                                     /*244885*/
             IF         COND(&SAVD *EQ 'TAPE') THEN(DO)                                   /*244885*/
/*                                                                                        /*244885*/
/*                                                                                        /*244885*/
/*  Get the Unload Tape Post DBIC save system value */                                    /*244885*/
/*                                                                                        /*244885*/
/*                                                                                        /*244885*/
             CALL       PGM(AOSVALR0) PARM(&RSVALRTNC +
                          'UnloadTapePostDBIC' &SVAL1 &SVALK2 +
                          &SVAL2 &SVALK3 &SVAL3 &SVALK4 &SVAL4 +
                          &SVALK5 &SVAL5 &SVALK6 &SVAL6 &SVALK7 +
                          &SVAL7 &SVALK8 &SVAL8 &SVALK9 &SVAL9 +
                          &SVALK10 &SVAL10)                                               /*244885*/
/*                                                                                        /*244885*/
/* If there is an error finding any system value then end abnormally */                   /*244885*/
/*                                                                                        /*244885*/
             IF         COND(&RSVALRTNC *NE '       ') THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*244885*/
/*                                                                                        /*244885*/
             CHGVAR     VAR(&UNLTAP) VALUE(%SST(&SVAL1 1 1))                              /*244885*/
             IF         COND(&UNLTAP *EQ 'Y') THEN(CHKTAP +
                          DEV(&DEVI) ENDOPT(*UNLOAD))                                     /*244885*/
             ENDDO                                                                        /*244885*/
/*  UPDATE VOLUME ID IN JNSTAT                                                */
/**/
 ALC1:       ALCOBJ     OBJ((JNSTAT *DTAARA *EXCLRD)) WAIT(1)
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(ALC1))
/**********  RCVDTAARA  DTAARA(JNSTAT)                              *  *S01179*/
             RTVDTAARA  DTAARA(JNSTAT) RTNVAR(&JNSTAT)                /*S01179*/
/**/
/*   USE VOLUME ID OF SAVE JUST COMPLETED                                     */
/**/
             CHGVAR     VAR(%SUBSTRING(&JNSTAT 75 5)) VALUE(&VOL1)
             CHGVAR     VAR(&VAL1) VALUE(&VOL1)
/**/
/**********  SNDDTAARA  DTAARA(JNSTAT)                              *  *S01179*/
             CHGDTAARA  DTAARA(JNSTAT) VALUE(&JNSTAT)                 /*S01179*/
/**/
             DLCOBJ     OBJ((JNSTAT *DTAARA *EXCLRD))
/**/
/*  SEND 'SV' ENTRY TO JOURNAL                                                */
/**/
             CHGVAR     VAR(%SUBSTRING(&JRNE 1 5)) VALUE(&VAL1)
             CHGVAR     VAR(%SUBSTRING(&JRNE 6 8)) VALUE(&FSAV)
             CHGVAR     VAR(%SUBSTRING(&JRNE 26 4)) VALUE(&SAVD)
/**/
/*/COPY WNCPYSRC,SDC1797010                                          */
/**********  SNDJRNE    JRN(ICJRN) TYPE('SV') ENTDTA(&JRNE) */                           /*BUG9619*/
             SNDJRNE    JRN(ICJRN) TYPE('SV') ENTDTA(&JRNE) FORCE(*YES)                  /*BUG9619*/
/*/COPY WNCPYSRC,SDC1797011                                          */
/**/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/* */                                                                 /*CSC002*/
/* Call SCC2458 to save receivers if necessary                        /*CSC002*/
/* */                                                                 /*CSC002*/
             CALL       PGM(SCC2458) PARM(&DEVI &VOL1)                /*CSC002*/
             ENDDO                                                    /*CCB009*/
/* */                                                                 /*CSC002*/
/*/COPY WNCPYSRC,SDC1797012                                          */
                         GOTO ENDPGM
/**/
/*  ERROR PROCESSING                                                          */
/**/
ABNOR:
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,SDC1797ERR                                        */ /*S01408*/
/**/                                                                  /*S01408*/
             SNDPGMMSG  MSG('Save Master Library +
                        ENDED ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,SDC1797END                                        */ /*S01408*/
/**/                                                                  /*S01408*/
ENDPGM:     ENDPGM
/*/COPY WNCPYSRC,SDC1797013                                          */
