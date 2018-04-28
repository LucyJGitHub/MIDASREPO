/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SM Data base libraries restore')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - Implementation module                               */
/*                                                                   */
/*       SMC1062 - Restore data base libraries                       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/*       Last Amend No. CSC043             Date 18Jun10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CUP016 *CREATE     Date 01Apr03              */
/*                      xxxxxx             Date ddmmmyy              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CSC043 - MidasPlus IASP Enablement                          */
/*       CUP016 - Add implementation software to core.               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&FMDBLIB &TODBLIB &RSTLIB &DEV +
                          &UPSTATPOS &ENDOPT)
 
             DCL        VAR(&FMDBLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TODBLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RSTLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DEV) TYPE(*CHAR) LEN(10)
             DCL        VAR(&UPSTATPOS) TYPE(*CHAR) LEN(3)
             DCL        VAR(&ENDOPT) TYPE(*CHAR) LEN(7)
 
             DCL        VAR(&UPSTATPOSN) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(132)
             DCL        VAR(&REPLY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DEVTYPE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OPTFILE) TYPE(*CHAR) LEN(11)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')
             DCL        VAR(&IASP_YN) TYPE(*CHAR) LEN(1)                                  /*CSC043*/
             DCL        VAR(&IASP) TYPE(*CHAR) LEN(10)                                    /*CSC043*/
/*/COPY GPCPYSRCG,GPSVALDCL  */                                                           /*CSC043*/
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/*                                                                                        /*CSC043*/
/** Get the global IASP system values */                                                  /*CSC043*/
/*                                                                                        /*CSC043*/
             CALL       PGM(GPAOSVALR0) PARM(&RSVALRTNC +
                          'IASPinstallation' &SVAL1 'IASPgroup' +
                          &SVAL2 &SVALK3 &SVAL3 &SVALK4 &SVAL4 +
                          &SVALK5 &SVAL5 &SVALK6 &SVAL6 &SVALK7 +
                          &SVAL7 &SVALK8 &SVAL8 &SVALK9 &SVAL9 +
                          &SVALK10 &SVAL10)                                               /*CSC043*/
/*                                                                                        /*CSC043*/
/** Check whether system is in IASP environment. */                                       /*CSC043*/
/*                                                                                        /*CSC043*/
              CHGVAR     VAR(&IASP_YN) VALUE(%SST(&SVAL1 1 1))                            /*CSC043*/
/*                                                                                        /*CSC043*/
/** If IASP environment */                                                                /*CSC043*/
/*                                                                                        /*CSC043*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC043*/
/*                                                                                        /*CSC043*/
/** Get name of IASP. */                                                                  /*CSC043*/
/*                                                                                        /*CSC043*/
              CHGVAR     VAR(&IASP) VALUE(%SST(&SVAL2 1 10))                              /*CSC043*/
                                                                                          /*CSC043*/
             ENDDO                                                                        /*CSC043*/
                                                                                          /*CSC043*/
 
/* Check what type of device is being used. */
             RTVOBJD    OBJ(&DEV) OBJTYPE(*DEVD) OBJATR(&DEVTYPE)
 
             CHGVAR     VAR(&UPSTATPOSN) VALUE(&UPSTATPOS)
             CHGDTAARA  DTAARA(UPSTAT (&UPSTATPOSN 1)) VALUE('A')
 
/* Restore libraries. */
RSTOBJ:
/* If restore is from a tape drive. */
             IF         COND(&DEVTYPE *EQ 'TAP') THEN(DO)
/*                                                                                        /*CSC043*/
/** If restoring to an IASP environment */                                                /*CSC043*/
/*                                                                                        /*CSC043*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC043*/
                RSTLIB     SAVLIB(&FMDBLIB) DEV(&DEV) VOL(*MOUNTED) +
                             ENDOPT(&ENDOPT) RSTLIB(&RSTLIB) +
                             OUTPUT(*PRINT) RSTASPDEV(&IASP)                              /*CSC043*/
/*                                                                                        /*CSC043*/
/** If the library is not found on the tape send a message to get */                      /*CSC043*/
/**  the user to choose whether to cancel this component or to load */                    /*CSC043*/
/**  the correct tape and retry. */                                                       /*CSC043*/
/*                                                                                        /*CSC043*/
                MONMSG     MSGID(CPF3780) EXEC(DO)                                        /*CSC043*/
                   SNDUSRMSG  MSGID(CPF3780) MSGF(QCPFMSG) +
                                MSGDTA(&FMDBLIB) VALUES(C R) DFT(R) +
                                MSGTYPE(*INQ) TOMSGQ(*) MSGRPY(&REPLY)                    /*CSC043*/
                   IF         COND(&REPLY *EQ 'R') THEN(GOTO CMDLBL(RSTOBJ))              /*CSC043*/
                   IF         COND(&REPLY *EQ 'C') THEN(GOTO CMDLBL(ABNOR))               /*CSC043*/
                ENDDO                                                                     /*CSC043*/
                MONMSG     MSGID(CPF3836 CPF3848 CPF3773)                                 /*CSC043*/
             ENDDO                                                                        /*CSC043*/
             ELSE       CMD(DO)                                                           /*CSC043*/
                RSTLIB     SAVLIB(&FMDBLIB) DEV(&DEV) VOL(*MOUNTED) +
                             ENDOPT(&ENDOPT) RSTLIB(&RSTLIB) +
                             OUTPUT(*PRINT)
/* If the library is not found on the tape send a message to get   */
/*  the user to choose whether to cancel this component or to load */
/*  the correct tape and retry.                                    */
                MONMSG     MSGID(CPF3780) EXEC(DO)
                   SNDUSRMSG  MSGID(CPF3780) MSGF(QCPFMSG) +
                                MSGDTA(&FMDBLIB) VALUES(C R) DFT(R) +
                                MSGTYPE(*INQ) TOMSGQ(*) MSGRPY(&REPLY)
                   IF         COND(&REPLY *EQ 'R') THEN(GOTO CMDLBL(RSTOBJ))
                   IF         COND(&REPLY *EQ 'C') THEN(GOTO CMDLBL(ABNOR))
                ENDDO
                MONMSG     MSGID(CPF3836 CPF3848 CPF3773)
             ENDDO                                                                        /*CSC043*/
             ENDDO
 
/* If restore is from an optical disk tape drive. */
             IF         COND(&DEVTYPE *EQ 'OPT') THEN(DO)
                CHGVAR     VAR(&OPTFILE) VALUE('/' *TCAT &FMDBLIB)
/*                                                                                        /*CSC043*/
/** If restoring to an IASP environment */                                                /*CSC043*/
/*                                                                                        /*CSC043*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC043*/
                RSTOBJ     OBJ(*ALL) SAVLIB(QTEMP) DEV(&DEV) +
                             RSTLIB(QTEMP) OUTPUT(*PRINT) +
                             OPTFILE(&OPTFILE) RSTASPDEV(&IASP)                           /*CSC043*/
/*                                                                                        /*CSC043*/
/** If the save file is not found on the disk send a message to get */                    /*CSC043*/
/**  the user to choose whether to cancel this component or to load */                    /*CSC043*/
/**  the correct disk and retry. */                                                       /*CSC043*/
/*                                                                                        /*CSC043*/
                MONMSG     MSGID(CPF3780) EXEC(DO)                                        /*CSC043*/
                   SNDUSRMSG  MSGID(CPF3780) MSGF(QCPFMSG) MSGDTA(&FMDBLIB) +
                                VALUES(C R) DFT(R) MSGTYPE(*INQ) +
                                TOMSGQ(*) MSGRPY(&REPLY)                                  /*CSC043*/
                   IF         COND(&REPLY *EQ 'R') THEN(GOTO CMDLBL(RSTOBJ))              /*CSC043*/
                   IF         COND(&REPLY *EQ 'C') THEN(GOTO CMDLBL(ABNOR))               /*CSC043*/
                ENDDO                                                                     /*CSC043*/
                MONMSG     MSGID(CPF3836 CPF3848 CPF3773)                                 /*CSC043*/
             ENDDO                                                                        /*CSC043*/
             ELSE       CMD(DO)                                                           /*CSC043*/
                RSTOBJ     OBJ(*ALL) SAVLIB(QTEMP) DEV(&DEV) +
                             RSTLIB(QTEMP) OUTPUT(*PRINT) +
                             OPTFILE(&OPTFILE)
/* If the save file is not found on the disk send a message to get */
/*  the user to choose whether to cancel this component or to load */
/*  the correct disk and retry.                                    */
                MONMSG     MSGID(CPF3780) EXEC(DO)
                   SNDUSRMSG  MSGID(CPF3780) MSGF(QCPFMSG) MSGDTA(&FMDBLIB) +
                                VALUES(C R) DFT(R) MSGTYPE(*INQ) +
                                TOMSGQ(*) MSGRPY(&REPLY)
                   IF         COND(&REPLY *EQ 'R') THEN(GOTO CMDLBL(RSTOBJ))
                   IF         COND(&REPLY *EQ 'C') THEN(GOTO CMDLBL(ABNOR))
                ENDDO
                MONMSG     MSGID(CPF3836 CPF3848 CPF3773)
             ENDDO                                                                        /*CSC043*/
 
/*                                                                                        /*CSC043*/
/** If restoring to an IASP environment */                                                /*CSC043*/
/*                                                                                        /*CSC043*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC043*/
                RSTOBJ     OBJ(*ALL) SAVLIB(&FMDBLIB) DEV(*SAVF) +
                             SAVF(QTEMP/&FMDBLIB) RSTLIB(&RSTLIB) +
                             OUTPUT(*PRINT) RSTASPDEV(&IASP)                              /*CSC043*/
                MONMSG     MSGID(CPF3836 CPF3848 CPF3773)                                 /*CSC043*/
             ENDDO                                                                        /*CSC043*/
             ELSE       CMD(DO)                                                           /*CSC043*/
                RSTOBJ     OBJ(*ALL) SAVLIB(&FMDBLIB) DEV(*SAVF) +
                             SAVF(QTEMP/&FMDBLIB) RSTLIB(&RSTLIB) +
                             OUTPUT(*PRINT)
                MONMSG     MSGID(CPF3836 CPF3848 CPF3773)
             ENDDO                                                                        /*CSC043*/
             ENDDO
 
             CHGDTAARA  DTAARA(UPSTAT (&UPSTATPOS 1)) VALUE('C')
             GOTO       CMDLBL(ENDPGM)
 
/* Abnormal end. */
ABNOR:
             CHGDTAARA  DTAARA(UPSTAT (&UPSTATPOSN 1)) VALUE('F')
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&MEM) VALUE('SMC1062 - Job has Ended +
                          Abnormally')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(SETUP)
             MONMSG     MSGID(CPF0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000)
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
