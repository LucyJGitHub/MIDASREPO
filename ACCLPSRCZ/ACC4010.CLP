/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AC Control of start ECS from ACT s/b at ACT')   */
/*********************************************************************/
/*                                                                   */
/*       Midas     - System Control Module                           */
/*                                                                   */
/*       ACC4010 - Control of starting ECS at office                 */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Note: This program must be recompiled in library            */
/*             AUTOLIB on the office machine.                        */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 101930             Date 08Jul96              */
/*                      S01491             Date 01Oct94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       101930 - Remote Location name set up incorrectly.           */
/*          Note: Program should exist in lib. AUTOLIB on office m/c.*/
/*       S01491 - Autocall.                                          */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(100)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
/************DCL        VAR(&RMTLOC) TYPE(*CHAR) LEN(10)************/ /*101930*/
/************DCL        VAR(&PGMDEV) TYPE(*CHAR) LEN(10)************/ /*101930*/
             DCL        VAR(&ICFF) TYPE(*CHAR) LEN(10)                /*101930*/
/**/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(ERROR))
/**/
/** Retrieve the job name                                          */
/**/
             RTVJOBA    JOB(&JOB)
/**/
/** Remove remote location name variable as *REQUESTER is used     */ /*101930*/
/** when setting up the ICF file                                   */ /*101930*/
/***Set*up*remote*location*n1me*************************************/ /*101930*/
/**/                                                                  /*101930*/
/************CHGVAR     VAR(&RMTLOC) VALUE('RMT' *TCAT %SST(&JOB 8 1))/*101930*/
/**/                                                                  /*101930*/
/***Set*up*program*device*******************************************/ /*101930*/
/**/                                                                  /*101930*/
/************CHGVAR     VAR(&PGMDEV) VALUE('PGMDEV' *TCAT %SST(&JOB + /*101930*/
/************             8 1))                                       /*101930*/
/**/                                                                  /*101930*/
/** Set up ICF file                                                */ /*101930*/
/**/                                                                  /*101930*/
             CHGVAR     VAR(&ICFF) VALUE('AC401' *TCAT %SST(&JOB 8 +
                          1) *TCAT 'CM')                              /*101930*/
/**/
/** Setup communications file for the correct location             */
/**/
/************RMVICFDEVE FILE(AC4010CM) PGMDEV(&PGMDEV)**************/ /*101930*/
             RMVICFDEVE FILE(&ICFF) PGMDEV(PGMDEV)                    /*101930*/
             MONMSG     MSGID(CPF0000)
/**/
/************ADDICFDEVE FILE(AC4010CM) PGMDEV(&PGMDEV) +              /*101930*/
/************             RMTLOCNAME(&RMTLOC) CMNTYPE(*APPC) +        /*101930*/
/************             LCLLOCNAME(*LOC) MODE(ECS) RMTNETID(*NONE)  /*101930*/
             ADDICFDEVE FILE(&ICFF) PGMDEV(PGMDEV) +
                          RMTLOCNAME(*REQUESTER) CMNTYPE(*APPC) +
                          LCLLOCNAME(*LOC) MODE(ECS) RMTNETID(*NONE)  /*101930*/
/**/
/** Override ICFF so that correct program device is used           */
/**/
/************OVRICFF    FILE(AC4010CM) ACQPGMDEV(&PGMDEV)             /*101930*/
             OVRICFF    FILE(AC401XCM) TOFILE(&ICFF) +
                          ACQPGMDEV(PGMDEV)                           /*101930*/
/**/
/** Call program                                                   */
/**/
             CALL       PGM(AC4010)
             GOTO       CMDLBL(ENDPGM)                                /*101930*/
/**/
 ERROR:      RCLRSC
/**/
             DLTOVR     FILE(*ALL)
/**/
             RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSGDTA) MSGID(&MSGID)
             SNDPGMMSG  MSGID(&MSGID) MSGF(QCPFMSG) MSGDTA(&MSGDTA) +
                          MSGTYPE(*ESCAPE)
/**/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
