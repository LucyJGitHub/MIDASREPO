/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas TI Beginning of business save')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Trade Innovation Module                             */
/*                                                                   */
/*       TIC1710 - Midas TI Beginning of business save               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. 235616  *CREATE    Date 12Feb07              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       235616 - The program does not save the latest               */
/*                version of TI database and not the TI database     */
/*                at the time the MIDAS_SAVE job is submitted.       */
/*              - TI Backups after Close of Business                 */
/*                Patterned after TIC1711                            */
/*                                                                   */
/*********************************************************************/
/**********  PGM        PARM(&TIBKLIB)                               */                   /*235616*/
             PGM        PARM(&TIBKLIB &OPTN)                                              /*235616*/
 
             DCLF       FILE(T2PF)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
/**/
/*   INITIAL PROCESSING                                             */
/**/
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SFMT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&ACPTH) TYPE(*CHAR) LEN(6)
 
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DEPSRV) TYPE(*CHAR) LEN(2)
             DCL        VAR(&UNITMN) TYPE(*CHAR) LEN(3)
 
             DCL        VAR(&KAPBAS) TYPE(*CHAR) LEN(8) VALUE('KAPBAS  ')
             DCL        VAR(&TIXXXX) TYPE(*CHAR) LEN(7) VALUE('TI     ')
 
             DCL        VAR(&KBSAVF) TYPE(*CHAR) LEN(10) VALUE('KAP       ')
             DCL        VAR(&TISAVF) TYPE(*CHAR) LEN(10) VALUE('          ')
             DCL        VAR(&FILE3) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OLDF3) TYPE(*CHAR) LEN(10)                                   /*235616*/
 
             DCL        VAR(&SAVFTEXT) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RUNDAT) TYPE(*CHAR) LEN(13)
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7) VALUE(' ')
             DCL        VAR(&CSW025) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&SAVE_DEV) TYPE(*CHAR) LEN(4)
             DCL        VAR(&DAY) TYPE(*CHAR) LEN(3)
             DCL        VAR(&SAVE_TYPE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&TIBKLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TAPOPT) TYPE(*CHAR) LEN(5)
             DCL        VAR(&CB_RTN_CDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CB_AUTO) TYPE(*CHAR) LEN(111)
             DCL        VAR(&VOLID) TYPE(*CHAR) LEN(5)
             DCL        VAR(&MONIND) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RMSG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SAVE_FILE) TYPE(*CHAR) LEN(20)
             DCL        VAR(&DEVICE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&KEYVAR) TYPE(*CHAR) LEN(4)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&MODE)
 
             CHGJOB     SWS(XXXXXX00)
/**********  SNDPGMMSG  MSG('TI Beginning of business Database Save') +                   /*235616*/
/**********             TOMSGQ(MOPERQ)                               */                   /*235616*/
             SNDPGMMSG  MSG('TI Beginning of business Database Save' +
                          *CAT &OPTN) TOMSGQ(MOPERQ)                                      /*235616*/
 
             CALL (AOSARDR0) PARM(&PRTCD '*VERIFY' 'CSW025')
             IF (&PRTCD *EQ ' ') (CHGVAR (&CSW025) VALUE('Y'))
 
/* Check if access paths to be saved                               */
 
             CHGVAR     VAR(&RTN) VALUE('       ')
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')
             CHGVAR     VAR(&SARD) VALUE('CSC003')
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)
/* Set flag */
             IF         COND(&RTN *EQ '       ') THEN(DO)
             CHGVAR     VAR(&ACPTH) VALUE('CSC003')
             ENDDO
 
/* SYSTEM ID AND RUN DATE*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
/**/
/* RUNDATX is a copy of RUNDAT dtaara on the time of executing SCC2455 */
/**/
             RTVDTAARA  DTAARA(QTEMP/RUNDATX) RTNVAR(&RUNDAT)
             IF         COND(%SST(&RUNDAT 1 1) = ' ') THEN(CHGVAR +
                          VAR(%SST(&RUNDAT 1 1)) VALUE('0'))
/**/
/* Retrieve dtaara saved in QTEMP via SCC2455  */
/**/
             RTVDTAARA  DTAARA(QTEMP/&SYSID) RTNVAR(&DAY)
 
/*  PROCESSING FOR SAVING ONTO DISK                         */
/*  AT START OF INPUT CYCLE TERMINATION                     */
 
READ:
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(DO)
                GOTO       CMDLBL(ENDREAD)
             ENDDO
 
/* Only carry out check if unit mnemonic belongs to this system. */
             IF         COND(%SST(&T2UMN 1 2) *NE &SYSID) THEN(DO)
                GOTO       CMDLBL(READ)
             ENDDO
 
             CHGVAR     VAR(&DEPSRV) VALUE(&T2DSM)
             CHGVAR     VAR(&UNITMN) VALUE(&T2UMN)
 
             GOTO       CMDLBL(READ)
ENDREAD:
 
             IF         COND(&DEPSRV = '  ') THEN(GOTO CMDLBL(ABNOR))
             IF         COND(&UNITMN = '  ') THEN(GOTO CMDLBL(ABNOR))
 
               CHGVAR     VAR(%SUBSTRING(&KAPBAS 7 2)) +
                          VALUE(&DEPSRV)
 
               CHGVAR     VAR(%SUBSTRING(&TIXXXX 3 2)) +
                          VALUE(&DEPSRV)
               CHGVAR     VAR(%SUBSTRING(&TIXXXX 5 3)) +
                          VALUE(&UNITMN)
 
               CHGVAR     VAR(%SUBSTRING(&KBSAVF 4 2)) +
                          VALUE(&SYSID)
/**********    CHGVAR     VAR(%SUBSTRING(&KBSAVF 6 5)) +             */                   /*235616*/
/**********               VALUE(%SST(&RUNDAT 1 5))                   */                   /*235616*/
               CHGVAR     VAR(%SUBSTRING(&KBSAVF 6 3)) +
                          VALUE(&DAY)                                                     /*235616*/
 
               CHGVAR     VAR(%SUBSTRING(&TISAVF 1 2)) +
                          VALUE(&DEPSRV)
               CHGVAR     VAR(%SUBSTRING(&TISAVF 3 3)) +
                          VALUE(&UNITMN)
/**********    CHGVAR     VAR(%SUBSTRING(&TISAVF 6 5)) +             */                   /*235616*/
/**********               VALUE(%SST(&RUNDAT 1 5))                   */                   /*235616*/
               CHGVAR     VAR(%SUBSTRING(&TISAVF 6 3)) +
                          VALUE(&DAY)                                                     /*235616*/
 
             IF         COND((&OPTN *NE '*TAPSAV') | (&OPTN *NE +
                          '*CRTSAV')) THEN(DO)                                            /*235616*/
             SNDPGMMSG  MSG('Call Parameter Incorrect, please use +
                          *CRTSAV or *TAPSAV') TOMSGQ(MOPERQ)                             /*235616*/
             ENDDO                                                                        /*235616*/
             IF         COND(&OPTN *EQ '*CRTSAV') THEN(DO)                                /*235616*/
/* DELETE SAVE FILES */
 
             DLTF       FILE(&TIBKLIB/&KBSAVF)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(&TIBKLIB/&TISAVF)
             MONMSG     MSGID(CPF0000)
 
             CRTSAVF    FILE(&TIBKLIB/&KBSAVF)
             MONMSG     MSGID(CPF0000)
             CRTSAVF    FILE(&TIBKLIB/&TISAVF)
             MONMSG     MSGID(CPF0000)
 
/* If CSC003 then save with access paths                           */
 
             IF         COND(&ACPTH *EQ 'CSC003') THEN(DO)
             SAVLIB     LIB(&KAPBAS) DEV(*SAVF) SAVF(&TIBKLIB/&KBSAVF) +
                          USEOPTBLK(*NO) CLEAR(*ALL) ACCPTH(*YES) +
                          OUTPUT(*PRINT)
             SAVLIB     LIB(&TIXXXX) DEV(*SAVF) SAVF(&TIBKLIB/&TISAVF) +
                          USEOPTBLK(*NO) CLEAR(*ALL) ACCPTH(*YES) +
                          OUTPUT(*PRINT)
             ENDDO
             ELSE       CMD(DO)
             SAVLIB     LIB(&KAPBAS) DEV(*SAVF) SAVF(&TIBKLIB/&KBSAVF) +
                          USEOPTBLK(*NO) CLEAR(*ALL) OUTPUT(*PRINT)
             SAVLIB     LIB(&TIXXXX) DEV(*SAVF) SAVF(&TIBKLIB/&TISAVF) +
                          USEOPTBLK(*NO) CLEAR(*ALL) OUTPUT(*PRINT)
 
             ENDDO
 
 
             CHGVAR     VAR(&SAVFTEXT) VALUE(%SST(&RUNDAT 1 7) *CAT +
                          ' - Midas I/C initialisation KAPBASE save')
             CHGSAVF    FILE(&TIBKLIB/&KBSAVF) TEXT(&SAVFTEXT)
 
             CHGVAR     VAR(&SAVFTEXT) VALUE(%SST(&RUNDAT 1 7) *CAT +
                          ' - Midas I/C initialisation TI DB save')
             CHGSAVF    FILE(&TIBKLIB/&TISAVF) TEXT(&SAVFTEXT)
 
             CHGVAR     VAR(&FILE3) VALUE('TI' *CAT &DEPSRV *CAT +
                          &UNITMN *CAT &DAY)
             CHGVAR     VAR(&OLDF3) VALUE('TI' *CAT &DEPSRV *CAT +
                          &UNITMN *CAT 'XXX')                                             /*235616*/
/**/                                                                                      /*235616*/
/* Perform file checks and rename.                                     */                 /*235616*/
/**/                                                                                      /*235616*/
RETRNM:      CHKOBJ     OBJ(&TIBKLIB/&OLDF3) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
 PRMPT1:     SNDPGMMSG  MSG('The TI backup save file ' *CAT &OLDF3 +
                          *CAT ' is not found in library ' *CAT +
                          &TIBKLIB *CAT '.  Would you like to +
                          retry? Y/N') TOMSGQ(QSYSOPR)                                    /*235616*/
             SNDPGMMSG  MSG('The TI backup save file ' *CAT &OLDF3 +
                          *CAT ' is not found in library ' *CAT +
                          &TIBKLIB *CAT '.  Would you like to +
                          retry? Y/N') TOMSGQ(MOPERQ) MSGTYPE(*INQ) +
                          KEYVAR(&KEYVAR)                                                 /*235616*/
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&KEYVAR) WAIT(*MAX) +
                              RMV(*NO) KEYVAR(&KEYVAR) MSG(&RMSG)                         /*235616*/
             IF         COND((&RMSG *EQ 'Y') *OR (&RMSG *EQ 'y')) +
                          THEN(GOTO CMDLBL(RETRNM))                                       /*235616*/
             ELSE (IF         COND((&RMSG *EQ 'N') *OR (&MSG *EQ 'n')) +
                          THEN(DO))                                                       /*235616*/
             SNDPGMMSG  MSG('The TI backup save file ' *CAT &OLDF3 +
                          *CAT ' is not found in library ' *CAT +
                          &TIBKLIB *CAT '.  Would you like to +
                          retry? Y/N') TOMSGQ(QSYSOPR)                                    /*235616*/
             CHGVAR     VAR(&FILE3) VALUE(*BLANKS)                                        /*235616*/
             ENDDO                                                                        /*235616*/
             ELSE       CMD(GOTO CMDLBL(PRMPT1))                                          /*235616*/
             ENDDO                                                                        /*235616*/
             IF         COND(&FILE3 *NE *BLANKS) THEN(RNMOBJ +
                          OBJ(&TIBKLIB/&OLDF3) OBJTYPE(*FILE) +
                          NEWOBJ(&FILE3))                                                 /*235616*/
 
             ENDDO                                                                        /*235616*/
             IF         COND(&OPTN *EQ '*TAPSAV') THEN(DO)                                /*235616*/
/**/
/* Start Saving the savefiles to tape if required                      */
/**/
             RTVDTAARA  DTAARA(JNSTAT (35 4)) RTNVAR(&SAVE_DEV)
             IF         COND(&SAVE_DEV *NE 'TAPE') THEN(DO)
             SNDPGMMSG  MSG('Beginning of Business saves are not set +
                          to be saved to tape.  Save files ' *CAT +
                          &KBSAVF *CAT ' and ' *CAT &TISAVF *CAT ' are now +
                          created in library ' *CAT &TIBKLIB) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
             ELSE       CMD(DO)
             CHGVAR     VAR(&SAVE_TYPE) VALUE('SAVF')
             RTVDTAARA  DTAARA(JNSTAT (39 10)) RTNVAR(&DEVICE)
/**/
/* Determine volume ID of BOB day save    */
/**/
             CHGVAR     VAR(&VOLID) VALUE('DB' *TCAT &DAY)
 
/* Check if volume ID should be changed to a different value.  */
 
CHECKTAP:    RTVDTAARA  DTAARA(TAPOPT) RTNVAR(&TAPOPT)
             IF         COND((&TAPOPT *EQ 'SYSID') *AND (%SST(&VOLID +
                          1 2) *EQ 'DB')) THEN(CHGVAR VAR(&VOLID) +
                          VALUE(&SYSID *TCAT %SST(&VOLID 3 3)))
             CHKTAP     DEV(&DEVICE) VOL(&VOLID)
             MONMSG     MSGID(CPF6718) EXEC(DO)
                CHGVAR     VAR(&MONIND) VALUE('1')
                CHGVAR     VAR(&MSG) VALUE('Unable to allocate device ' +
                             *BCAT &DEVICE *BCAT '. Retry if device +
                             becomes available and mount volume ' +
                             *BCAT &VOLID *BCAT ' OR enter "C" to +
                             cancel and end program.')
             ENDDO
 
             MONMSG     MSGID(CPF6720) EXEC(DO)
                CHGVAR     VAR(&MONIND) VALUE('1')
                CHGVAR     VAR(&MSG) VALUE('Tape with volume ID ' *BCAT +
                             &VOLID *BCAT ' not found on device ' *BCAT +
                             &DEVICE *BCAT '. Mount the correct tape +
                             and retry OR enter "C" to cancel and end +
                             program.')
             ENDDO
 
             MONMSG     MSGID(CPF6760) EXEC(DO)
                CHGVAR     VAR(&MONIND) VALUE('1')
                CHGVAR     VAR(&MSG) VALUE('Device ' *BCAT &DEVICE +
                             *BCAT ' not ready. Mount volume with ID ' +
                             *BCAT &VOLID *BCAT ' on device, press +
                             START and retry OR enter "C" to cancel +
                             and end program.')
             ENDDO
 
             MONMSG     MSGID(CPF6772) EXEC(DO)
                CHGVAR     VAR(&MONIND) VALUE('1')
                CHGVAR     VAR(&MSG) VALUE('Cannot process mounted vol +
                             on device ' *BCAT &DEVICE *BCAT '.Clean +
                             tape path & heads,& retry OR enter"C"to +
                             cancel program. If problem recurs,mount +
                             another volume & retry.')
             ENDDO
 
             MONMSG     MSGID(CPF9814) EXEC(DO)
                CHGVAR     VAR(&MONIND) VALUE('1')
                CHGVAR     VAR(&MSG) VALUE('Device ' *BCAT &DEVICE +
                             *BCAT ' not found. Mount volume with ID ' +
                             *BCAT &VOLID *BCAT ' on device and retry +
                             OR enter "C" to cancel and end program.')
             ENDDO
             IF         COND(&MONIND *EQ '1') THEN(DO)
 
              IF         COND(&MODE *EQ '1') THEN(DO)
                 SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) MSGTYPE(*INQ)
                ENDDO
              ELSE       CMD(DO)
                 SNDPGMMSG  MSG(&MSG) TOMSGQ(QSYSOPR) MSGTYPE(*INFO)
                 SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ) MSGTYPE(*INQ) +
                              KEYVAR(&KEYVAR)
              ENDDO
 
              RCVMSG     MSGTYPE(*RPY) MSGKEY(&KEYVAR) WAIT(*MAX) +
                               RMV(*NO) KEYVAR(&KEYVAR) MSG(&RMSG)
/*  If reply is 'C',  End program   */
              IF         COND((&RMSG *EQ 'C') *OR (&RMSG *EQ 'c')) +
                                THEN(DO)
                   SNDPGMMSG  MSG('Pgm SCC2455 - Save of database save +
                             files cancelled by user')
                   GOTO       CMDLBL(ABNOR)
              ENDDO
              ELSE       CMD(DO)
                   CHGVAR     VAR(&MONIND) VALUE('0')
                   GOTO       CMDLBL(CHECKTAP)
              ENDDO
             ENDDO
 
             CHGVAR     VAR(%SST(&SAVE_FILE 11 10 )) VALUE(&TIBKLIB)
             CHGVAR     VAR(%SST(&SAVE_FILE 1 10 )) VALUE(&KBSAVF)
TICHK:       CHKOBJ     OBJ(%SST(&SAVE_FILE 11 10)/%SST(&SAVE_FILE 1 +
                          10)) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801 CPF9810) EXEC(DO)
             SNDPGMMSG  MSG('File ' *BCAT %SST(&SAVE_FILE 11 10) *TCAT +
                          '/' *TCAT %SST(&SAVE_FILE 1 10) *BCAT ' +
                          not found') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 TICALL:     CALL       PGM(SCC1767) PARM(&TIBKLIB &SAVE_TYPE +
                         &SAVE_FILE &DEVICE &VOLID)
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)                                  /*235616*/
             DLTF       FILE(&TIBKLIB/&SAVE_FILE)                                         /*235616*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(SNDPGMMSG +
                          MSG('Problem encounterred in deleting +
                          file ' *CAT &TIBKLIB *TCAT '/' *TCAT +
                          &SAVE_FILE))                                                    /*235616*/
             ENDDO                                                                        /*235616*/
             IF         COND(%SST(&SAVE_FILE 1 10) *EQ &FILE3) +
                          THEN(GOTO CMDLBL(TIEND))
             IF         COND(%SST(&SAVE_FILE 1 10) *EQ &KBSAVF) +
                          THEN(DO)
             CHGVAR     VAR(%SST(&SAVE_FILE 1 10 )) VALUE(&TISAVF)
             GOTO       CMDLBL(TICHK)
                          ENDDO
             IF         COND(%SST(&SAVE_FILE 1 10) *EQ &TISAVF) +
                          THEN(DO)
             CHGVAR     VAR(%SST(&SAVE_FILE 1 10 )) VALUE(&FILE3 )
             CHKOBJ     OBJ(%SST(&SAVE_FILE 11 10)/%SST(&SAVE_FILE 1 +
                          10)) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801 CPF9810) EXEC(DO)
             SNDPGMMSG  MSG('File ' *BCAT %SST(&SAVE_FILE 11 10) +
                          *TCAT '/' *TCAT %SST(&SAVE_FILE 1 10) +
                          *BCAT ' not found. TI specific COB backup +
                          failed or have not yet started') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(TIEND)
             ENDDO
             GOTO       CMDLBL(TICALL)
TIEND:                    ENDDO
             ENDDO
             ENDDO                                                                        /*235616*/
             GOTO ENDPGM
 
/*  ERROR PROCESSING        */
 
ABNOR:
             SNDPGMMSG  MSG('TI Beginning of Business Database Save ENDED +
                          ABNORMALLY') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd. 2005')
             ENDPGM
