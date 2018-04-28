/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas TI Rename TI backup files')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Trade Innovation Module                             */
/*                                                                   */
/*       TIC1710B - Midas TI Update TI Backup save file name         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. 235616  *CREATE    Date 12Feb07              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       235616 - Amended to cater wait period and new rename is     */
/*                transferred to TIC1710.                            */
/*              - Created to amend the TI backup's save file name    */
/*                considering the Midas system date.                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&TIBKLIB)
 
             DCLF       FILE(T2PF)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
/**/
/*   INITIAL PROCESSING                                             */
/**/
 
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DEPSRV) TYPE(*CHAR) LEN(2)
             DCL        VAR(&UNITMN) TYPE(*CHAR) LEN(3)
 
 
             DCL        VAR(&TIFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NEWNAM) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&RUNDAT) TYPE(*CHAR) LEN(13)
             DCL        VAR(&DAY) TYPE(*CHAR) LEN(4)
             DCL        VAR(&TIBKLIB) TYPE(*CHAR) LEN(10)
/**********  DCL        VAR(&CB_RTN_CDE) TYPE(*CHAR) LEN(7)          */                   /*235616*/
/**********  DCL        VAR(&CB_AUTO) TYPE(*CHAR) LEN(111)           */                   /*235616*/
/**********  DCL        VAR(&VOLID) TYPE(*CHAR) LEN(5)               */                   /*235616*/
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CTR) TYPE(*DEC) LEN(2 0)                                     /*235616*/
             DCL        VAR(&RPY) TYPE(*CHAR) LEN(1)                                      /*235616*/
             DCL        VAR(&KEYVAR) TYPE(*CHAR) LEN(4)                                   /*235616*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&MODE)
 
             CHGJOB     SWS(XXXXXX00)
             SNDPGMMSG  MSG('TI Update TI Backup save file name') +
                        TOMSGQ(MOPERQ)
 
/* SYSTEM ID AND RUN DATE*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             RTVDTAARA  DTAARA(RUNDAT) RTNVAR(&RUNDAT)
             IF         COND(%SST(&RUNDAT 1 1) = ' ') THEN(CHGVAR +
                          VAR(%SST(&RUNDAT 1 1)) VALUE('0'))
 
 
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
 
 
             RTVSYSVAL SYSVAL(QDAYOFWEEK) RTNVAR(&DAY)
             CHGVAR     VAR(&TIFILE) VALUE('TI' *CAT &DEPSRV *CAT +
                          &UNITMN *CAT %SST(&DAY 2 3))
 
/**********  CHGVAR     VAR(%SST(&CB_AUTO 1 10)) VALUE('          ') */                   /*235616*/
/**********  CALL       PGM(CB0602X) PARM(&CB_RTN_CDE &CB_AUTO)      */                   /*235616*/
/**********  CHGVAR     VAR(&VOLID) VALUE(%SST(&CB_AUTO 107 5))      */                   /*235616*/
/**********  CHGVAR     VAR(&NEWNAM) VALUE('TI' *CAT &DEPSRV *CAT +  */                   /*235616*/
/**********               &UNITMN *CAT %SST(&VOLID 3 3))             */                   /*235616*/
/**/                                                                                      /*235616*/
/*  Use XXX instead of the day value                                 */                   /*235616*/
/**/                                                                                      /*235616*/
             CHGVAR     VAR(&NEWNAM) VALUE('TI' *CAT &DEPSRV *CAT +
                          &UNITMN *CAT 'XXX')                                             /*235616*/
 
 RTYFIND1:   CHGVAR     VAR(&CTR) VALUE(0)                                                /*235616*/
 RTYFIND:    DLYJOB     DLY(5)                                                            /*235616*/
             CHKOBJ     OBJ(&TIBKLIB/&TIFILE) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9810) EXEC(DO)                                           /*235616*/
             SNDPGMMSG  MSG('Library ' *CAT *TIBKLIB *CAT ' not +
                          found.') TOPGMQ(*EXT) TOMSGQ(MOPERQ)                            /*235616*/
             GOTO       CMDLBL(ABNOR)                                                     /*235616*/
             ENDDO                                                                        /*235616*/
             MONMSG     MSGID(CPF9801) EXEC(DO)                                           /*235616*/
             CHGVAR     VAR(&CTR) VALUE(&CTR + 1)                                         /*235616*/
             IF         COND(&CTR = 5) THEN(DO)                                           /*235616*/
             SNDPGMMSG  MSG('The TI backup save file ' *CAT &TIFILE +
                          *CAT ' is not yet created in library ' +
                          *CAT &TIBKLIB *CAT '.  Would you like to +
                          retry? Y/N') TOMSGQ(QSYSOPR)                                    /*235616*/
             SNDPGMMSG  MSG('The TI backup save file ' *CAT &TIFILE +
                          *CAT ' is not yet created in library ' +
                          *CAT &TIBKLIB *CAT '.  Would you like to +
                          retry? Y/N') TOMSGQ(MOPERQ) MSGTYPE(*INQ) +
                          KEYVAR(&KEYVAR)                                                 /*235616*/
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&KEYVAR) WAIT(*MAX) +
                              RMV(*NO) KEYVAR(&KEYVAR) MSG(&RPY)                          /*235616*/
             IF         COND((&RPY *EQ 'Y') *OR (&RPY *EQ 'y'))  THEN(+
                        GOTO RTYFIND1)                                                    /*235616*/
             ELSE       CMD(IF COND((&RPY *EQ 'N') *OR (&RPY *EQ +
                          'n')) THEN(DO))                                                 /*235616*/
             SNDPGMMSG  MSG('The TI backup save file name was not +
                          recorded.  Please update the file +
                          TIBKUPPD manually prior to continuing job +
                          MIDAS_SAVE.')                                                   /*235616*/
             GOTO       CMDLBL(ENDPGM)                                                    /*235616*/
             ENDDO                                                                        /*235616*/
             ENDDO                                                                        /*235616*/
             GOTO     RTYFIND                                                             /*235616*/
             ENDDO                                                                        /*235616*/
/**********  MONMSG     MSGID(CPF9801 CPF9810) EXEC(DO)                                   /*235616*/
/**********  SNDPGMMSG  MSG('File ' *BCAT &TIBKLIB *TCAT '/' *TCAT +                      /*235616*/
/**********               &TIFILE *BCAT ' not found') TOPGMQ(*EXT) +                      /*235616*/
/**********               TOMSGQ(MOPERQ)                                                  /*235616*/
/**********  GOTO       CMDLBL(ABNOR)                                                     /*235616*/
/**********  ENDDO                                                                        /*235616*/
RTYRNM:      CHKOBJ     OBJ(&TIBKLIB/&NEWNAM) OBJTYPE(*FILE)                              /*235616*/
             MONMSG     MSGID(CPF9801) EXEC(DO)                                           /*235616*/
             IF         COND(&TIFILE *NE &NEWNAM) THEN(RNMOBJ +
                          OBJ(&TIBKLIB/&TIFILE) OBJTYPE(*FILE) +
                          NEWOBJ(&NEWNAM))
             GOTO ENDPGM
             ENDDO                                                                        /*235616*/
 PRMPT:      SNDPGMMSG  MSG('Save file ' *CAT &NEWNAM *CAT ' already +
                          exist in library ' *CAT &TIBKLIB *TCAT +
                          '.  Would you like to retry? Y/N') +
                          TOMSGQ(QSYSOPR)                                                 /*235616*/
             SNDPGMMSG  MSG('Save file ' *CAT &NEWNAM *CAT ' already +
                          exist in library ' *CAT &TIBKLIB *TCAT +
                          '.  Would you like to retry? Y/N') +
                          MSGTYPE(*INQ) KEYVAR(&KEYVAR) TOMSGQ(MOPERQ)                    /*235616*/
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&KEYVAR) WAIT(*MAX) +
                              RMV(*NO) KEYVAR(&KEYVAR) MSG(&RPY)                          /*235616*/
             IF         COND((&RPY *EQ 'y') *OR (&RPY *EQ 'Y')) +
                          THEN(GOTO CMDLBL(RTYRNM))                                       /*235616*/
             IF         COND((&RPY *NE 'n') *OR (&RPY *NE 'N')) +
                          THEN(GOTO CMDLBL(PRMPT))                                        /*235616*/
 
/*  ERROR PROCESSING        */
 
ABNOR:
             SNDPGMMSG  MSG('TI Update TI backup save file name ENDED +
                          ABNORMALLY') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd. 2005')
             ENDPGM
