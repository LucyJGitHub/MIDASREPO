/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RR Restart recovery menu')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas     STANDING DATA MODULE                              */
/*                                                                   */
/*       RRMENUN - RESTART RECOVERY MENU                             */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CBF002             Date 04Jul11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CPK017             Date 28Oct03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      066989             DATE 08Apr94              */
/*                      063306             DATE 15FEB94              */
/*                      S01343             DATE 15AUG91              */
/*                      E22987             DATE 26JUL90              */
/*                      E17129             DATE 21FEB89              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CBF002 - BF Infrastructure: Backup and Recovery             */
/*              - This program will be replaced by the               */
/*                Configuration Maintenance (artf815172)             */
/*       CPK017 - Midas Plus packaging.                              */
/*                Comment out the remove of msg from MSTATUS.        */
/*       066989 - Remove a 'MIDAS' from MSTATUS if signoff           */
/*                requested.                                         */
/*       063306 - Reset JOB switches.                                */
/*       S01343 - SC/RR/SD Module rename project.                    */
/*              - RRMENUN renamed from L2MNUN                        */
/*              - SCC0030 renamed from L1MNUA                        */
/*              - RRRECOVER renamed from MRECOVR                     */
/*              - SCUSRMNU renamed from MUSRMNU                      */
/*       E22987 - Remove old HELP processing                         */
/*       E17129 - Recreate program (missing from MRSLIB1)            */
/*                                                                   */
/*********************************************************************/
             PGM
/************DCL********VAR(&HBPGM) TYPE(*CHAR) LEN(8) VALUE('RR1702')/*E22987*/
/************DCL********VAR(&HERCD) TYPE(*CHAR) LEN(80)               /*E22987*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCLF       RRMENUNDF RCDFMT(RRMENUN)
/*                                                                            */
             RTVJOBA    JOB(&DEVNM)
 RDSPLY:     SNDRCVF    RCDFMT(RRMENUN)
             CHGVAR     VAR(&IN60) VALUE('0')                                             /*CBF002*/
             CHGVAR     VAR(&ERRMSG) VALUE(' ')                                           /*CBF002*/
/***ALLOW*HELP                                                     */ /*E22987*/
/************IF         COND(&IN01 *EQ '1') THEN(DO)               */ /*E22987*/
/************   CALL       PGM(MHELP) PARM(&HBPGM &HERCD)          */ /*E22987*/
/************   GOTO       RDSPLY                                  */ /*E22987*/
/************ENDDO                                                 */ /*E22987*/
/**/
             CHGJOB     SWS(XXXXXX00)                                /*063306*/
/**********  IF         COND(&MOPTN *EQ 01) THEN(CALL PGM(SDC1740))  */                   /*CBF002*/
             IF         COND(&MOPTN *EQ 01) THEN(DO)                                      /*CBF002*/
             CHGVAR     VAR(&IN60) VALUE('1')                                             /*CBF002*/
             CHGVAR     VAR(&ERRMSG) VALUE('This menu has been +
                          replaced by Configuration Maintenance.')
             GOTO       CMDLBL(RDSPLY)                                                    /*CBF002*/
             ENDDO                                                                        /*CBF002*/
             IF         COND(&MOPTN *EQ 04) THEN(CALL PGM(RRRECOVER) +
                          PARM(SDC1725 ' '))
             IF         COND(&MOPTN *EQ 05) THEN(CALL PGM(RRRECOVER) +
                          PARM(SDC1720 ' '))
             IF         COND(&MOPTN *EQ 06) THEN(CALL PGM(SDC1790))
             IF         COND(&MOPTN *EQ 07) THEN(CALL PGM(RRRECOVER) +
                          PARM(SDC1750 ' '))
             IF         COND(&MOPTN *EQ 08) THEN(CALL PGM(RRRECOVER) +
                          PARM(SDC1753 ' '))
             IF         COND(&MOPTN *EQ 09) THEN(CALL PGM(RRRECOVER) +
                          PARM(SDC1755 ' '))
/**/
             IF         COND(&MOPTN *EQ 22) THEN(CALL SCUSRMNU)
             IF         (&MOPTN *EQ 23)  THEN(TFRCTL SCC0030)
/************IF         (&MOPTN *EQ 24)  THEN(SIGNOFF *LIST)      */ /*066989*/
             IF         (&MOPTN *EQ 24)  THEN(DO)                    /*066989*/
/************     CHGMSGQ    MSGQ(MSTATUS) RESET(*YES)                      */ /*066989*/ /*CPK017*/
/************     RCVMSG     MSGQ(MSTATUS) RMV(*YES)                        */ /*066989*/ /*CPK017*/
/************     MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                 */ /*066989*/ /*CPK017*/
                  SIGNOFF    *LIST                                   /*066989*/
             ENDDO                                                   /*066989*/
             CHGJOB     SWS(00000000)
             GOTO       RDSPLY
/*                                                                            */
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM     /* END CL PGM RRMENUN    */
