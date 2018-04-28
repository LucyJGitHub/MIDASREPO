/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SC Save a Midas Library')                       */
/********************************************************************/
/*                                                                  */
/*        Midas     - System Control Module                         */
/*                                                                  */
/*       SCC1767 - SAVE A MIDAS LIBRARY                             */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. AR813190           Date 09Aug11              */
/*       Prev Amend No. AR787620           Date 10Jun11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      CCB016             Date 31Oct07              */
/*                      CSC039             Date 18Aug08              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      CSC033             Date 21May07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG6521            Date 03May05              */
/*                      185977             Date 22Jul03              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      207764             Date 23Jul02              */
/* Midas Release 4.01 -----------------------------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      192731               Date 11Jul01           */
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408               Date  08AUG96          */
/*                      S01408               DATE  15APR96          */
/*                      CSC003               DATE  23JAN96          */
/*                      S01375               DATE  03APR92          */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       AR813190 - Apply fix AR799678 (Child: AR813191)             */
/*       AR799678 - ICIFINISH failed component at the live system    */
/*                  IO. When saving files that may be in use by      */
/*                  other jobs, include option in savlib command:    */
/*                  SAVACTWAIT(120 *NOCMTBDY *LOCKWAIT).             */
/*                  (Child: AR799679)                                */
/*       AR787620 - Hooks Incorporation                              */
/*                  WNCPYSRC,SCH00001                                */
/*                  WNCPYSRC,SCH00002                                */
/*                  WNCPYSRC,SCH00003                                */
/*       CCB016 - COB Enhancements: save only objects changed       */
/*                during a COB in case of special flag is set in    */
/*                CCB016 data area and it is a DBBOB save.          */
/*       CSC039 - Include parameter DTACPR in save commands to      */
/*                reduce run time.                                  */
/*       CSC033 - Include global libraries in backups.              */
/*       BUG6521 - Change Volume ID to be unique for each zone.      */
/*       185977 - If take N to message, end job (specifically for   */
/*              - journal reciever saves).                          */
/*       207764 - Change all SAV* and RST* commands to print a      */
/*                report of objects saved or restored.              */
/*       192731 - Change SAVLIB/SAVSAVFDTA cmds to have             */
/*                USEOPTBLK *NO instead of *YES                     */
/*       S01408 - Addition of core hook SCC1767009                  */
/*       S01408 - Addition of core hook SCC1767INT                  */
/*                Addition of core hook SCC1767MPE                  */
/*                Addition of core hook SCC1767ERR                  */
/*                Addition of core hook SCC1767END                  */
/*                Addition of core hook SCC1767001                  */
/*                Addition of core hook SCC1767002                  */
/*                Addition of core hook SCC1767003                  */
/*                Addition of core hook SCC1767004                  */
/*                Addition of core hook SCC1767005                  */
/*                Addition of core hook SCC1767006                  */
/*                Addition of core hook SCC1767007                  */
/*                Addition of core hook SCC1767008                  */
/*       CSC003 - Add switchable feature to save access paths       */
/*       S01375 - EOD saves, extension to save save file data       */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&LIBRARY &SAVE_TYPE &SAVE_FILE &DEVICE +
                          &VOLID)
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,SCC1767INT                                        */ /*S01408*/
/**/
/*           Copyright statement definition                          */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/*   Declare variables                                              */
/**/
             DCL        VAR(&LIBRARY) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SAVE_TYPE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&SAVE_FILE) TYPE(*CHAR) LEN(20)
             DCL        VAR(&DEVICE) TYPE(*CHAR) LEN(10)
/*/COPY WNCPYSRC,SCC1767018                                          */
             DCL        VAR(&VOLID) TYPE(*CHAR) LEN(5)
/*/COPY WNCPYSRC,SCC1767019                                          */
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&KEYVAR) TYPE(*CHAR) LEN(4)
             DCL        VAR(&CNL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(7)                  /*CSC003*/
             DCL        VAR(&OPN) TYPE(*CHAR) LEN(7)                  /*CSC003*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*CSC003*/
             DCL        VAR(&SFMT) TYPE(*CHAR) LEN(200)               /*CSC003*/
             DCL        VAR(&ACPTH) TYPE(*CHAR) LEN(6)                /*CSC003*/
             DCL        VAR(&OPTION) TYPE(*CHAR) LEN(4)               /*CSC003*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(100)                                /*185977*/
/************DCL        VAR(&TAPOPT) TYPE(*CHAR) LEN(5)                           /*BUG6521 CSC033*/
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)                                   /*BUG6521*/
/*/COPY SDCPYSRC,SDSVALDCL                                           */                   /*CSC039*/
             DCL        VAR(&DTACPRV) TYPE(*CHAR) LEN(10)                                 /*CSC039*/
             DCL        VAR(&SAVACT) TYPE(*CHAR) LEN(8) VALUE('*NO')                      /*CSC033*/
             DCL        VAR(&USESID) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CSC033*/
             DCL        VAR(&SAVCHG) TYPE(*CHAR) LEN(1)                                   /*CCB016*/
             DCL        VAR(&CBAUTO) TYPE(*CHAR) LEN(111)                                 /*CCB016*/
             DCL        VAR(&CBRTCD) TYPE(*CHAR) LEN(7)                                   /*CCB016*/
             DCL        VAR(&BOBSVF) TYPE(*CHAR) LEN(7)                                   /*CCB016*/
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)                                   /*CCB016*/
             DCL        VAR(&SVALK1) TYPE(*CHAR) LEN(20)                                  /*CCB016*/
             DCL        VAR(&SVAL1) TYPE(*CHAR) LEN(200)                                  /*CCB016*/
             DCL        VAR(&SVALK2) TYPE(*CHAR) LEN(20)                                  /*CCB016*/
             DCL        VAR(&SVAL2) TYPE(*CHAR) LEN(200)                                  /*CCB016*/
             DCL        VAR(&SVALK3) TYPE(*CHAR) LEN(20)                                  /*CCB016*/
             DCL        VAR(&SVAL3) TYPE(*CHAR) LEN(200)                                  /*CCB016*/
             DCL        VAR(&SVALK4) TYPE(*CHAR) LEN(20)                                  /*CCB016*/
             DCL        VAR(&SVAL4) TYPE(*CHAR) LEN(200)                                  /*CCB016*/
             DCL        VAR(&SVALK5) TYPE(*CHAR) LEN(20)                                  /*CCB016*/
             DCL        VAR(&SVAL5) TYPE(*CHAR) LEN(200)                                  /*CCB016*/
             DCL        VAR(&SVALK6) TYPE(*CHAR) LEN(20)                                  /*CCB016*/
             DCL        VAR(&SVAL6) TYPE(*CHAR) LEN(200)                                  /*CCB016*/
             DCL        VAR(&SVALK7) TYPE(*CHAR) LEN(20)                                  /*CCB016*/
             DCL        VAR(&SVAL7) TYPE(*CHAR) LEN(200)                                  /*CCB016*/
             DCL        VAR(&SVALK8) TYPE(*CHAR) LEN(20)                                  /*CCB016*/
             DCL        VAR(&SVAL8) TYPE(*CHAR) LEN(200)                                  /*CCB016*/
             DCL        VAR(&SVALK9) TYPE(*CHAR) LEN(20)                                  /*CCB016*/
             DCL        VAR(&SVAL9) TYPE(*CHAR) LEN(200)                                  /*CCB016*/
             DCL        VAR(&SVALK0) TYPE(*CHAR) LEN(20)                                  /*CCB016*/
             DCL        VAR(&SVAL10) TYPE(*CHAR) LEN(200)                                 /*CCB016*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC1767001                                        */ /*S01408*/
                                                                      /*S01408*/
/**/
/*           Global Monitor Message  */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO ABNOR)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC1767002                                        */ /*S01408*/
                                                                      /*S01408*/
/**/
/*           Copyright statement definition - at runtime             */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
             SNDPGMMSG  MSG('Save a Midas Library') TOMSGQ(MRUNQ)
/**/
             CHGJOB     SWS(XXXXXX00)
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)                              /*BUG6521*/
/************RTVDTAARA  DTAARA(TAPOPT) RTNVAR(&TAPOPT)                            /*BUG6521 CSC033*/
             RTVDTAARA  DTAARA(JNSTAT (173 1)) RTNVAR(&USESID)                            /*CSC033*/
             RTVJOBA    TYPE(&MODE)
/*/COPY WNCPYSRC,SCH00032                                            */
/* */                                                                                     /*CSC033*/
/* If global library, use save-while-active.                                                CSC033*/
/* */                                                                                     /*CSC033*/
             IF         COND(%SST(&LIBRARY 3 1) *EQ 'G') THEN(DO)                         /*CSC033*/
             CHGVAR     VAR(&SAVACT) VALUE('*LIB')                                        /*CSC033*/
             ENDDO                                                                        /*CSC033*/
/* */                                                                 /*CSC003*/
/* Check if access paths to be saved                               */ /*CSC003*/
/* */                                                                 /*CSC003*/
                                                                      /*CSC003*/
             CHGVAR     VAR(&RTN) VALUE('       ')                    /*CSC003*/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                    /*CSC003*/
             CHGVAR     VAR(&SARD) VALUE('CSC003')                    /*CSC003*/
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)     /*CSC003*/
             IF         COND(&RTN *EQ '       ') THEN(DO)             /*CSC003*/
/* Set flag */                                                        /*CSC003*/
             CHGVAR     VAR(&ACPTH) VALUE('CSC003')                   /*CSC003*/
             ENDDO                                                    /*CSC003*/
/**/
/*   Check that save type is recognised as valid                   */
/**/
             IF         COND((&SAVE_TYPE *NE 'TAPE') *AND +
                             (&SAVE_TYPE *NE 'SAVF') *AND +
                             (&SAVE_TYPE *NE 'DISK')) THEN(DO)
             SNDPGMMSG  MSG('Save type ' *BCAT &SAVE_TYPE *BCAT ' not +
                          recognised as valid - only DISK, SAVF or +
                          TAPE allowed') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
/*   Check that passed parameters relating to objects are correct  */
/**/
             IF         COND(&SAVE_TYPE *EQ 'TAPE') THEN(DO)
             CHKOBJ     OBJ(&DEVICE) OBJTYPE(*DEVD)
             MONMSG     MSGID(CPF9801 CPF9814) EXEC(DO)
             SNDPGMMSG  MSG('Device ' *BCAT &DEVICE *BCAT ' not +
                          found') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
             ENDDO
/**/
             IF         COND((&SAVE_TYPE *EQ 'DISK') *OR +
                             (&SAVE_TYPE *EQ 'SAVF')) THEN(DO)
             CHKOBJ     OBJ(%SST(&SAVE_FILE 11 10)/%SST(&SAVE_FILE 1 +
                          10)) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801 CPF9810) EXEC(DO)
             SNDPGMMSG  MSG('File ' *BCAT %SST(&SAVE_FILE 1 10) *TCAT +
                          '.' *TCAT %SST(&SAVE_FILE 11 10) *BCAT ' +
                          not found') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
             ENDDO
/**/                                                                                      /*CCB016*/
/*   Retrieve SAVCHGOBJ flag in case it need                       */                     /*CCB016*/
             CHGVAR     VAR(&SAVCHG) VALUE('N')                                           /*CCB016*/
             IF         COND(&SAVE_TYPE *EQ 'DISK') THEN(DO)                              /*CCB016*/
             /* Retrieve name of DBBOB save file */                                       /*CCB016*/
             CHGVAR VAR(%SST(&CBAUTO 1 10)) VALUE('*TODAY    ')                           /*CCB016*/
             CALL PGM(CB0602X) PARM(&CBRTCD &CBAUTO)                                      /*CCB016*/
             CHGVAR VAR(&BOBSVF) VALUE(%SST(&CBAUTO 61 5))                                /*CCB016*/
             /* Check it is a DBBOB save */                                               /*CCB016*/
             IF         (%SST(&SAVE_FILE 1 5) = &BOBSVF) THEN(DO)                         /*CCB016*/
             /* Retrieve and check SAVCHGOBJ flag */                                      /*CCB016*/
                                                                                          /*CCB016*/
/* Get 'BOBSaveSAVCHGOBJ?' system value from file SDSVALPD  */                            /*CCB016*/
                                                                                          /*CCB016*/
                   CALL       PGM(AOSVALR0) PARM(&RTNCDE +
                                'BOBSaveSAVCHGOBJ?' &SVAL1 &SVALK2 +
                                &SVAL2 &SVALK3 &SVAL3 &SVALK4 &SVAL4 +
                                &SVALK5 &SVAL5 &SVALK6 &SVAL6 &SVALK7 +
                                &SVAL7 &SVALK8 &SVAL8 &SVALK9 &SVAL9 +
                                &SVALK0 &SVAL10)                               /*CCB016*/
 
/* If the 'APIProcessingMode' system value is missing then end abnormally */   /*CCB016*/
 
                   IF         COND(%SST(&SVAL1 1 4) *EQ '*NRF') THEN(GOTO +
                                CMDLBL(ABNOR))                                 /*CCB016*/
                   ELSE
                              CHGVAR     VAR(&SAVCHG) VALUE(%SST(&SVAL1 1 1))  /*CCB016*/
 
/*/COPY WNCPYSRC,SCH00001                                            */
             IF         COND((&SAVCHG *NE 'Y') *AND +
                             (&SAVCHG *NE 'N')) THEN(DO)              /*CCB016*/
             CHGVAR     VAR(&SAVCHG) VALUE('N')                       /*CCB016*/
             ENDDO                                                    /*CCB016*/
/*/COPY WNCPYSRC,SCH00002                                            */
             ENDDO                                                    /*CCB016*/
             ENDDO                                                    /*CCB016*/
/**/
             CHKOBJ     OBJ(QSYS/&LIBRARY) OBJTYPE(*LIB)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             SNDPGMMSG  MSG('Library ' *BCAT &LIBRARY *BCAT ' not +
                          found') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
/*   If disk save then skip to save tag                            */
/**/
             IF         COND(&SAVE_TYPE *EQ 'DISK') THEN(GOTO +
                          CMDLBL(SAVE_DISK))
/**/
/*  Check that device has been loaded properly and that correct    */
/*  volume is placed on drive                                      */
/**/
 CHECK:      RMVMSG     PGMQ(*SAME) CLEAR(*ALL)
             CHGVAR     VAR(&ERROR) VALUE('N')
/*/COPY WNCPYSRC,SCC1767010                                          */
/************IF         COND((&TAPOPT *EQ 'SYSID') *AND (%SST(&VOLID +
                          1 2) *EQ 'DB')) THEN(CHGVAR VAR(&VOLID) +
                          VALUE(&SYSID *TCAT %SST(&VOLID 3 3)))                   /*BUG6521 CSC033*/
             IF         COND((&USESID *EQ 'Y') *AND (%SST(&VOLID +
                          1 2) *EQ 'DB')) THEN(CHGVAR VAR(&VOLID) +
                          VALUE(&SYSID *TCAT %SST(&VOLID 3 3)))                           /*CSC033*/
             CHKTAP     DEV(&DEVICE) VOL(&VOLID)
/*/COPY WNCPYSRC,SCC1767017                                          */
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&ERROR) +
                          VALUE('Y'))
/*/COPY WNCPYSRC,SCC1767011                                          */
/**/
/* If no error generated by request then try to save objects         */
/**/
             IF         COND(&ERROR *EQ 'N') THEN(GOTO CMDLBL(SAVE))
/**/
/* Receive messages if error reported i.e. &ERROR is 'Y'             */
/**/
 RCVMSG1:    RCVMSG     PGMQ(*SAME) MSGTYPE(*ANY) RMV(*NO) +
                          MSGDTA(&MSGDTA) MSGID(&MSGID) MSGF(&MSGF) +
                          MSGFLIB(&MSGFLIB)
             IF         COND(&MSGID *EQ ' ') THEN(GOTO +
                          CMDLBL(ASK_USER))
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(RCVMSG1)
/**/
/* If error ask for repeat else analyse volume of tape or diskette   */
/**/
 ASK_USER:   IF         COND(&MODE *EQ '1') THEN(DO)
/*/COPY WNCPYSRC,SCC1767012                                          */
             SNDPGMMSG  MSG('Media error detected - operation is: +
                          save ' *CAT &LIBRARY *BCAT ' to volume ' +
                          *CAT &VOLID) TOPGMQ(*EXT) MSGTYPE(*INFO)
/*/COPY WNCPYSRC,SCC1767013                                          */
             SNDPGMMSG  MSG('Error detected - do you wish to retry (Y +
                          or N)') TOPGMQ(*EXT) MSGTYPE(*INQ) +
                          KEYVAR(&KEYVAR)
             ENDDO
             ELSE       CMD(DO)
/*/COPY WNCPYSRC,SCC1767014                                          */
             SNDPGMMSG  MSG('Media error detected - operation is: +
                          save ' *CAT &LIBRARY *BCAT ' to volume ' +
                          *CAT &VOLID) TOMSGQ(MOPERQ) MSGTYPE(*INFO)
/*/COPY WNCPYSRC,SCC1767015                                          */
             SNDPGMMSG  MSG('Error detected - do you wish to retry (Y +
                          or N)') TOMSGQ(MOPERQ) MSGTYPE(*INQ) +
                          KEYVAR(&KEYVAR)
             ENDDO
             RCVMSG     MSGKEY(&KEYVAR) WAIT(*MAX) KEYVAR(&KEYVAR) +
                          MSG(&CNL)
/**/
/* Volume name on device to be used */
/**/
             IF         COND((&CNL *EQ 'Y') *OR (&CNL *EQ 'y')) +
                          THEN(DO)
             GOTO       CMDLBL(CHECK)
             ENDDO
             ELSE       CMD(DO)
/**********  IF         COND((&CNL *NE 'N') *AND (&CNL *NE 'n')) +                        /*185977*/
/**********               THEN(GOTO CMDLBL(ASK_USER))                                     /*185977*/
             IF         COND((&CNL *NE 'N') *AND (&CNL *NE 'n')) +
                          THEN(DO)                                                        /*185977*/
             GOTO       CMDLBL(ASK_USER)                                                  /*185977*/
             ENDDO                                                                        /*185977*/
             ELSE       CMD(DO)                                                           /*185977*/
             IF         COND((&CNL *EQ 'N') *OR (&CNL *EQ 'n')) +
                          THEN(DO)                                                        /*185977*/
                               CHGVAR     VAR(&MESSAGE) VALUE('Save of library ' *CAT +
                               &LIBRARY *BCAT 'cancelled by the user')                    /*185977*/
                               SNDPGMMSG  MSG(&MESSAGE) TOPGMQ(*EXT) TOMSGQ(MOPERQ +
                               MRUNQ)                                                     /*185977*/
                               GOTO CMDLBL(END)                                           /*185977*/
             ENDDO                                                                        /*185977*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
             ENDDO                                                                        /*185977*/
/**/
/* Remove messages from program queue so that only SAVLIB messages */
/* are reported                                                    */
/**/
 SAVE:       RMVMSG     PGMQ(*SAME) CLEAR(*ALL)
/**/
/*   If savf save then skip to save file tag                       */
/**/
             IF         COND(&SAVE_TYPE *EQ 'SAVF') THEN(GOTO +
                          CMDLBL(SAVE_SAVF))
/**/
/*  Save library specified                                          */
/**/
             SNDPGMMSG  MSG('Save library - ' *BCAT &LIBRARY *BCAT ' +
                          in progress') TOMSGQ(MOPERQ)
/**/
/*/COPY WNCPYSRC,SCC1767016                                          */
/* */                                                                 /*CSC003*/
/* If CSC003 then save with access paths                           */ /*CSC003*/
/* */                                                                 /*CSC003*/
/************SAVLIB     LIB(&LIBRARY) DEV(&DEVICE) VOL(*MOUNTED)       *CSC003*/
             CHGVAR     VAR(&OPTION) VALUE('*NO ')                    /*CSC003*/
             IF         COND(&ACPTH *EQ 'CSC003') THEN(DO)            /*CSC003*/
             CHGVAR     VAR(&OPTION) VALUE('*YES')                    /*CSC003*/
             ENDDO                                                    /*CSC003*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC1767003                                        */ /*S01408*/
                                                                      /*S01408*/
/**********  SAVLIB     LIB(&LIBRARY) DEV(&DEVICE) VOL(*MOUNTED) +
/**********               ACCPTH(&OPTION)                             /*CSC003 192731*/
/**********  SAVLIB     LIB(&LIBRARY) DEV(&DEVICE) VOL(*MOUNTED) + */          /*192731*/ /*207764*/
/**********               ACCPTH(&OPTION) USEOPTBLK(*NO)           */          /*192731*/ /*207764*/
/*********   SAVLIB     LIB(&LIBRARY) DEV(&DEVICE) VOL(*MOUNTED) +
/*********                USEOPTBLK(*NO) ACCPTH(&OPTION) +
/*********                OUTPUT(*PRINT)                                       /*207764*/ /*CSC033*/
             SAVLIB     LIB(&LIBRARY) DEV(&DEVICE) VOL(*MOUNTED) +
                          USEOPTBLK(*NO) SAVACT(&SAVACT) +
                          ACCPTH(&OPTION) OUTPUT(*PRINT)                                  /*CSC033*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC1767004                                        */ /*S01408*/
                                                                      /*S01408*/
             MONMSG     MSGID(CPF0000) EXEC(DO)
/**/
/*  If error during save send message and terminate                */
/**/
             SNDPGMMSG  MSG('Save library - ' *BCAT &LIBRARY *BCAT ' +
                          failed, see messages on MOPERQ for +
                          details') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
 RCVMSG2:    RCVMSG     PGMQ(*SAME) MSGTYPE(*ANY) RMV(*NO) +
                          MSGDTA(&MSGDTA) MSGID(&MSGID) MSGF(&MSGF) +
                          MSGFLIB(&MSGFLIB)
             IF         COND(&MSGID *NE ' ') THEN(DO)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(RCVMSG2)
             ENDDO
             GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC1767007                                        */ /*S01408*/
                                                                      /*S01408*/
             GOTO       CMDLBL(END)
/**/
/* Remove messages from program queue so that only SAVLIB messages */
/* are reported                                                    */
/**/
 SAVE_SAVF:  RMVMSG     PGMQ(*SAME) CLEAR(*ALL)
/**/
/*  Save library specified                                          */
/**/
             SNDPGMMSG  MSG('Save save file - ' *BCAT %SST(&SAVE_FILE +
                          11 10) *TCAT '/' *TCAT %SST(&SAVE_FILE 1 +
                          10) *BCAT 'in progress') TOMSGQ(MOPERQ)
/**/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC1767005                                        */ /*S01408*/
                                                                      /*S01408*/
/**********  SAVSAVFDTA SAVF(%SST(&SAVE_FILE 11 10)/%SST(&SAVE_FILE 1 +
/**********               10)) DEV(&DEVICE) VOL(*MOUNTED)             /*192731*/
/**********  SAVSAVFDTA SAVF(%SST(&SAVE_FILE 11 10)/%SST(&SAVE_FILE 1 +
/**********               10)) DEV(&DEVICE) VOL(*MOUNTED) +
/**********               USEOPTBLK(*NO)                              /*192731 CSC033*/
             SAVSAVFDTA SAVF(%SST(&SAVE_FILE 11 10)/%SST(&SAVE_FILE +
                          1 10)) DEV(&DEVICE) VOL(*MOUNTED) +
                          USEOPTBLK(*NO) OUTPUT(*PRINT)               /*CSC033*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC1767006                                        */ /*S01408*/
                                                                      /*S01408*/
             MONMSG     MSGID(CPF0000) EXEC(DO)
/**/
/*  If error during save send message and terminate                */
/**/
             SNDPGMMSG  MSG('Save of save file - ' *BCAT +
                          %SST(&SAVE_FILE 11 10) *TCAT '/' *TCAT +
                          %SST(&SAVE_FILE 1 10) *BCAT 'failed, see +
                          messages on MOPERQ for details') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
 RCVMSG4:    RCVMSG     PGMQ(*SAME) MSGTYPE(*ANY) RMV(*NO) +
                          MSGDTA(&MSGDTA) MSGID(&MSGID) MSGF(&MSGF) +
                          MSGFLIB(&MSGFLIB)
             IF         COND(&MSGID *NE ' ') THEN(DO)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(RCVMSG4)
             ENDDO
             GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC1767008                                        */ /*S01408*/
                                                                      /*S01408*/
             GOTO       CMDLBL(END)
/**/
/* Remove messages from program queue so that only SAVLIB messages */
/* are reported                                                    */
/**/
 SAVE_DISK:  RMVMSG     PGMQ(*SAME) CLEAR(*ALL)
/**/
/*  Save library specified                                          */
/**/
             SNDPGMMSG  MSG('Save library - ' *BCAT &LIBRARY *BCAT ' +
                          in progress') TOMSGQ(MOPERQ)
/**/
/* */                                                                 /*CSC003*/
/* If CSC003 then save with access paths                           */ /*CSC003*/
/* */                                                                 /*CSC003*/
/************SAVLIB     LIB(&LIBRARY) DEV(*SAVF) SAVF(%SST(&SAVE_FILE +*CSC003*/
/************             11 10)/%SST(&SAVE_FILE 1 10)) CLEAR(*ALL)    *CSC003*/
             CHGVAR     VAR(&OPTION) VALUE('*NO ')                    /*CSC003*/
             IF         COND(&ACPTH *EQ 'CSC003') THEN(DO)            /*CSC003*/
             CHGVAR     VAR(&OPTION) VALUE('*YES')                    /*CSC003*/
             ENDDO                                                    /*CSC003*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC1767009                                        */ /*S01408*/
                                                                      /*S01408*/
/**********  SAVLIB     LIB(&LIBRARY) DEV(*SAVF) +
/**********               SAVF(%SST(&SAVE_FILE 11 +
/**********               10)/%SST(&SAVE_FILE 1 10)) CLEAR(*ALL) +
/**********               ACCPTH(&OPTION)                             /*CSC003 192731*/
/**********  SAVLIB     LIB(&LIBRARY) DEV(*SAVF) +                 */          /*192731*/ /*207764*/
/**********               SAVF(%SST(&SAVE_FILE 11 +                */          /*192731*/ /*207764*/
/**********               10)/%SST(&SAVE_FILE 1 10)) CLEAR(*ALL) + */          /*192731*/ /*207764*/
/**********               ACCPTH(&OPTION) USEOPTBLK(*NO)           */          /*192731*/ /*207764*/
/**********  SAVLIB     LIB(&LIBRARY) DEV(*SAVF) +
/**********               SAVF(%SST(&SAVE_FILE 11 +
/**********               10)/%SST(&SAVE_FILE 1 10)) USEOPTBLK(*NO) +
/**********               CLEAR(*ALL) ACCPTH(&OPTION) +
/**********               OUTPUT(*PRINT)                                       /*207764*/ /*CSC033*/
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
             IF         COND(&RSVALRTNC *NE '       ') THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*CSC039*/
             CHGVAR     VAR(&DTACPRV) VALUE(&SVAL1)                                       /*CSC039*/
                                                                                          /*CSC039*/
/*           SAVLIB     LIB(&LIBRARY) DEV(*SAVF) +                 */
/*                        SAVF(%SST(&SAVE_FILE 11 +                */
/*                        10)/%SST(&SAVE_FILE 1 10)) USEOPTBLK(*NO) +  */
/*                        CLEAR(*ALL) SAVACT(&SAVACT) +            */
/*                        ACCPTH(&OPTION) OUTPUT(*PRINT)           */              /*CSC033 CSC039*/
/*/COPY WNCPYSRC,SCH00003                                            */
             IF         COND(&SAVACT *EQ '*NO') THEN(DO)                                /*AR799678*/
             SAVLIB     LIB(&LIBRARY) DEV(*SAVF) +
                          SAVF(%SST(&SAVE_FILE 11 +
                          10)/%SST(&SAVE_FILE 1 10)) USEOPTBLK(*NO) +
                          CLEAR(*ALL) ACCPTH(&OPTION) +
                          OUTPUT(*PRINT) DTACPR(&DTACPRV)                                 /*CSC039*/
             MONMSG     MSGID(CPF0000) EXEC(DO)
/**/
/*  If error during save send message and terminate                */
/**/
             SNDPGMMSG  MSG('Save library - ' *BCAT &LIBRARY *BCAT ' +
                          failed, see messages on MOPERQ for +
                          details') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
 RCVMSG3:    RCVMSG     PGMQ(*SAME) MSGTYPE(*ANY) RMV(*NO) +
                          MSGDTA(&MSGDTA) MSGID(&MSGID) MSGF(&MSGF) +
                          MSGFLIB(&MSGFLIB)
             IF         COND(&MSGID *NE ' ') THEN(DO)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(RCVMSG3)
             ENDDO
             GOTO       CMDLBL(ABNOR)
             ENDDO
             ENDDO                                                                      /*AR799678*/
             ELSE       CMD(DO)                                                         /*AR799678*/
               SAVLIB     LIB(&LIBRARY) DEV(*SAVF) +
                             SAVF(%SST(&SAVE_FILE 11 +
                             10)/%SST(&SAVE_FILE 1 10)) USEOPTBLK(*NO) +
                             CLEAR(*ALL) SAVACT(&SAVACT) +
                             SAVACTWAIT(120 *NOCMTBDY *LOCKWAIT) +
                             ACCPTH(&OPTION) OUTPUT(*PRINT)                             /*AR799678*/
               MONMSG     MSGID(CPF0000) EXEC(DO)                                       /*AR799678*/
                                                                                        /*AR799678*/
/** If error during save send message and terminate */                                  /*AR799678*/
                                                                                        /*AR799678*/
               SNDPGMMSG  MSG('Save library - ' *BCAT &LIBRARY *BCAT ' +
                             failed, see messages on MOPERQ for +
                             details') TOPGMQ(*EXT) TOMSGQ(MOPERQ)                      /*AR799678*/
 RCVMSG5:      RCVMSG     PGMQ(*SAME) MSGTYPE(*ANY) RMV(*NO) +
                             MSGDTA(&MSGDTA) MSGID(&MSGID) MSGF(&MSGF) +
                             MSGFLIB(&MSGFLIB)                                          /*AR799678*/
               IF         COND(&MSGID *NE ' ') THEN(DO)                                 /*AR799678*/
                 SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                               MSGDTA(&MSGDTA) TOMSGQ(MOPERQ)                           /*AR799678*/
                 GOTO       CMDLBL(RCVMSG5)                                             /*AR799678*/
               ENDDO                                                                    /*AR799678*/
               GOTO       CMDLBL(ABNOR)                                                 /*AR799678*/
               ENDDO                                                                    /*AR799678*/
             ENDDO                                                                      /*AR799678*/
/**/
/*/COPY WNCPYSRC,SCC1767MPE                                          */
 
             GOTO       CMDLBL(END)
/**/
/*  Error processing                                                */
/**/
 ABNOR:      SNDPGMMSG  MSG('SCC1767 Save a Midas Library - ENDED +
                          ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ +
                          MRUNQ)
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,SCC1767ERR                                        */ /*S01408*/
/**/                                                                  /*S01408*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
END:
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,SCC1767END                                        */ /*S01408*/
/**/                                                                  /*S01408*/
            ENDPGM
