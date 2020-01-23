/*********************************************************************/
/*S*D****CLPBASEBND***************************************************/                 /*MD029775*/
/*STD    CLPBASE                                                     */                 /*MD030956*/
/*EXI    TEXT('Midas TI Input cycle database save')                  */
/*********************************************************************/
/*                                                                   */
/*        Midas - Standing Data Module                               */
/*                                                                   */
/*       TIC1711 - TI INPUT CYCLE DATABASE SAVE                      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD054919           Date 10Jan20              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/*                      MD030956           Date 09Oct14              */
/*                      MD029775           Date 19Aug14              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG7833            Date 14Jul04              */
/*                      BUG4848 *CREATE    Date 11Nov04              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD054919 - TI Save does not compress when saving.           */
/*       MD046248 - Finastra Rebranding                              */
/*       MD030956 - Additional changes to BFM-TI enhancement.        */
/*                  Reinstated for future use in case of downgrade.  */
/*       MD029775 - TI/Midas EOD sync will no longer be used by TI   */
/*                  Plus                                             */
/*       BUG7833 - Amend the program to have unique save file name   */
/*                 for each zone in MidasPlus.                       */
/*   BUG4848 - TI BACKUPS                                            */
/*                                                                   */
/*********************************************************************/
             PGM

             DCLF       FILE(T2PF)

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/*   INITIAL PROCESSING                                             */
/**/
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
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

             DCL        VAR(&SAVFTEXT) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RUNDAT) TYPE(*CHAR) LEN(13)
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7) VALUE(' ')
             DCL        VAR(&CSW025) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&DTACPRV) TYPE(*CHAR) LEN(10)                               /*MD054919*/
             DCL        VAR(&SVAL1) TYPE(*CHAR) LEN(200)                                /*MD054919*/
             DCL        VAR(&SVAL2) TYPE(*CHAR) LEN(200)                                /*MD054919*/
             DCL        VAR(&SVAL3) TYPE(*CHAR) LEN(200)                                /*MD054919*/
             DCL        VAR(&SVAL4) TYPE(*CHAR) LEN(200)                                /*MD054919*/
             DCL        VAR(&SVAL5) TYPE(*CHAR) LEN(200)                                /*MD054919*/
             DCL        VAR(&SVAL6) TYPE(*CHAR) LEN(200)                                /*MD054919*/
             DCL        VAR(&SVAL7) TYPE(*CHAR) LEN(200)                                /*MD054919*/
             DCL        VAR(&SVAL8) TYPE(*CHAR) LEN(200)                                /*MD054919*/
             DCL        VAR(&SVAL9) TYPE(*CHAR) LEN(200)                                /*MD054919*/
             DCL        VAR(&SVAL10) TYPE(*CHAR) LEN(200)                               /*MD054919*/
             DCL        VAR(&RSVALRTNC) TYPE(*CHAR) LEN(7)                              /*MD054919*/

/*/COPY WNCPYSRC,TIH00018                                            */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO ABNOR)
/**/
             SNDPGMMSG  MSG('TI Input Cycle Database Save') +
                        TOMSGQ(MOPERQ)

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
             RTVDTAARA  DTAARA(RUNDAT) RTNVAR(&RUNDAT)
             IF         COND(%SST(&RUNDAT 1 1) = ' ') THEN(CHGVAR +
                          VAR(%SST(&RUNDAT 1 1)) VALUE('0'))

/*  Get System Value for Data Compression parameter in save commands */                 /*MD054919*/

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
                        ' ' &SVAL10)                                                    /*MD054919*/

             IF         COND(&RSVALRTNC *NE '       ') THEN(GOTO +
                             CMDLBL(ABNOR))                                             /*MD054919*/
             CHGVAR     VAR(&DTACPRV) VALUE(&SVAL1)                                     /*MD054919*/

/*/COPY WNCPYSRC,TIH00019                                            */
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

/**********    CHGVAR     VAR(%SUBSTRING(&KBSAVF 4 2)) +             */                  /*BUG7833*/
/**********               VALUE(&DEPSRV)                             */                  /*BUG7833*/
               CHGVAR     VAR(%SUBSTRING(&KBSAVF 4 2)) +
                          VALUE(&SYSID)                                                  /*BUG7833*/
               CHGVAR     VAR(%SUBSTRING(&KBSAVF 6 5)) +
                          VALUE(%SST(&RUNDAT 1 5))

               CHGVAR     VAR(%SUBSTRING(&TISAVF 1 2)) +
                          VALUE(&DEPSRV)
               CHGVAR     VAR(%SUBSTRING(&TISAVF 3 3)) +
                          VALUE(&UNITMN)
               CHGVAR     VAR(%SUBSTRING(&TISAVF 6 5)) +
                          VALUE(%SST(&RUNDAT 1 5))

/* DELETE SAVE FILES */

/*/COPY WNCPYSRC,TIH00020                                            */
             DLTF       FILE(TIBACKUPS/&KBSAVF)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(TIBACKUPS/&TISAVF)
             MONMSG     MSGID(CPF0000)

             CRTSAVF    FILE(TIBACKUPS/&KBSAVF)
             MONMSG     MSGID(CPF0000)
             CRTSAVF    FILE(TIBACKUPS/&TISAVF)
             MONMSG     MSGID(CPF0000)

/* If CSC003 then save with access paths                           */

             IF         COND(&ACPTH *EQ 'CSC003') THEN(DO)
/**********     SAVLIB     LIB(&KAPBAS) DEV(*SAVF) SAVF(TIBACKUPS/&KBSAVF) +            /*MD054919*/
/**********                  USEOPTBLK(*NO) CLEAR(*ALL) ACCPTH(*YES) +                  /*MD054919*/
/**********                  OUTPUT(*PRINT)                                             /*MD054919*/
/**********     SAVLIB     LIB(&TIXXXX) DEV(*SAVF) SAVF(TIBACKUPS/&TISAVF) +            /*MD054919*/
/**********                  USEOPTBLK(*NO) CLEAR(*ALL) ACCPTH(*YES) +                  /*MD054919*/
/**********                  OUTPUT(*PRINT)                                             /*MD054919*/
                SAVLIB     LIB(&KAPBAS) DEV(*SAVF) +
                             SAVF(TIBACKUPS/&KBSAVF) USEOPTBLK(*NO) +
                             CLEAR(*ALL) ACCPTH(*YES) +
                             DTACPR(&DTACPRV) OUTPUT(*PRINT)                            /*MD054919*/
                SAVLIB     LIB(&TIXXXX) DEV(*SAVF) +
                             SAVF(TIBACKUPS/&TISAVF) USEOPTBLK(*NO) +
                             CLEAR(*ALL) ACCPTH(*YES) +
                             DTACPR(&DTACPRV) OUTPUT(*PRINT)                            /*MD054919*/
             ENDDO
             ELSE       CMD(DO)
/**********     SAVLIB     LIB(&KAPBAS) DEV(*SAVF) SAVF(TIBACKUPS/&KBSAVF) +            /*MD054919*/
/**********                  USEOPTBLK(*NO) CLEAR(*ALL) OUTPUT(*PRINT)                  /*MD054919*/
/**********     SAVLIB     LIB(&TIXXXX) DEV(*SAVF) SAVF(TIBACKUPS/&TISAVF) +            /*MD054919*/
/**********                  USEOPTBLK(*NO) CLEAR(*ALL) OUTPUT(*PRINT)                  /*MD054919*/
                SAVLIB     LIB(&KAPBAS) DEV(*SAVF) +
                             SAVF(TIBACKUPS/&KBSAVF) USEOPTBLK(*NO) +
                             CLEAR(*ALL) +
                             DTACPR(&DTACPRV) OUTPUT(*PRINT)                            /*MD054919*/
                SAVLIB     LIB(&TIXXXX) DEV(*SAVF) +
                             SAVF(TIBACKUPS/&TISAVF) USEOPTBLK(*NO) +
                             CLEAR(*ALL) +
                             DTACPR(&DTACPRV) OUTPUT(*PRINT)                            /*MD054919*/

             ENDDO


             CHGVAR     VAR(&SAVFTEXT) VALUE(%SST(&RUNDAT 1 7) *CAT +
                          ' - Midas I/C termination KAPBASE save')
             CHGSAVF    FILE(TIBACKUPS/&KBSAVF) TEXT(&SAVFTEXT)

             CHGVAR     VAR(&SAVFTEXT) VALUE(%SST(&RUNDAT 1 7) *CAT +
                          ' - Midas I/C termination TI DB save')
             CHGSAVF    FILE(TIBACKUPS/&TISAVF) TEXT(&SAVFTEXT)

/*/COPY WNCPYSRC,TIH00021                                            */
             GOTO ENDPGM

/*  ERROR PROCESSING        */

ABNOR:
             SNDPGMMSG  MSG('TI Input Cycle Database Save ENDED +
                          ABNORMALLY') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
