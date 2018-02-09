/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SC Input cycle database save')                  */
/*********************************************************************/
/*                                                                   */
/*        Midas - Standing Data Module                               */
/*                                                                   */
/*       SCC1711 - INPUT CYCLE DATABASE SAVE                         */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD038500           Date 17Aug16              */
/*                      MD035839           Date 14Sep15              */
/*                      AR1096483          Date 18Mar13              */
/*                      CSC048             Date 06Aug12              */
/*                      CCB023A *REWRITE   Date 06Aug12              */
/*                      CCB020             Date 06Aug12              */
/*                      CBF002             Date 04Jul11              */
/*                      AR796089           Date 28Jun11              */
/*                      AR787620           Date 10Jun11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      CSC040             Date 19Aug08              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      BUG14179           Date 30Jun07              */
/*                      BUG14057           Date 31May07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*                      CSC033             Date 22May07              */
/*                      BUG12169           Date 10Oct06              */
/*                      CRE026             Date 24May06              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      239298             Date 01Jun06              */
/*                      239918             Date 09Jun06              */
/*                      BUG9619            Date 01Feb06              */
/*                      BG3834R            Date 11Feb05              */
/*                      CSC023             Date 02Feb04              */
/*                      CSC020             Date 31Mar04              */
/*                      214155             Date 23Jan03              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      207764             Date 23Jul02              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      206496             Date 12JUN02              */
/*                      CSW025             Date 26Mar02              */
/*                      202830             Date 11Feb02              */
/*                      178962             Date 24Jan02              */
/*                      CPK014             Date 14Nov01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CSC012             Date 22Oct01              */
/*                    192731             Date 11Jul01                */
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                    193382             Date 09May01                */
/*                    183682             Date 08Jan01                */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                    118516             DATE 03JUN97                */
/*                    110242             DATE 07NOV96                */
/*                    S01408             DATE 08AUG96                */
/*                    S01408             DATE 12APR96                */
/*                    CSC002             DATE 14MAR96                */
/*                    CSC003             DATE 23JAN96                */
/*                    S01408             DATE 11JAN96                */
/*                    S01408             DATE 10MAY95                */
/*                    S01420             DATE 27APR95                */
/*                    S01495             DATE 01OCT94                */
/*                    S01463             DATE 11FEB94                */
/*                    S01431             DATE 27SEP93                */
/*                    S01375             DATE 10JAN92                */
/*                    S01319             DATE 10OCT91                */
/*                    S01343             DATE 15AUG91                */
/*                    RT0159             DATE 25JUN91                */
/*                    E23432             DATE 22SEP89                */
/*                    LN0309             DATE 01JUN90                */
/*                    E20391             DATE 26NOV89                */
/*                    E17536             DATE 14AUG89                */
/*                    E18933             DATE 25JUL89                */
/*                    S01192             DATE 30/01/89               */
/*                    S01117             DATE 18/08/89               */
/*                    S01179             DATE 12/09/88               */
/*                    E11174             DATE 27/06/87               */
/*                    S01133             DATE 31/03/87               */
/*                    S01118             DATE 12/03/87               */
/*                    E81140             DATE 19/08/86               */
/*                    E80978             DATE 15/08/86               */
/*                    S01098             DATE 08/09/86               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD038500 - Error when saving global library due to file     */
/*                  locking. Patterned after fix AR546370 as a pre-  */
/*                  ventative fix to avoid SAVLIB locking problems.  */
/*       MD035839 - Include the prefix for new DI library to resolve */
/*                  issue in SCC1711 during COB                      */
/*       AR1096483 - Included DILIB name for global libraries.       */
/*       CSC048 - Journal Caching                                    */
/*       CCB023A - COB Restructure - Input Cycle Termination         */
/*                 Restructuring                                     */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       CBF002  - BF Infrastructure: Backup and Recovery            */
/*       AR796089 - DTALIB saved twice                               */
/*       AR787620 - Hooks Incorporation                              */
/*                  WNCPYSRC,SCH00007                                */
/*                  WNCPYSRC,SCH00008                                */
/*                  WNCPYSRC,SCH00009                                */
/*                  WNCPYSRC,SCH00010                                */
/*                  WNCPYSRC,SCH00011                                */
/*                  WNCPYSRC,SCH00012                                */
/*                  WNCPYSRC,SCH00013                                */
/*                  WNCPYSRC,SCH00014                                */
/*                  WNCPYSRC,SCH00015                                */
/*                  WNCPYSRC,SCH00016                                */
/*                  WNCPYSRC,SCH00017                                */
/*                  WNCPYSRC,SCH00018                                */
/*                  WNCPYSRC,SCH00019                                */
/*                  WNCPYSRC,SCH00020                                */
/*                  WNCPYSRC,SCH00021                                */
/*                  WNCPYSRC,SCH00022                                */
/*                  WNCPYSRC,SCH00023                                */
/*                  WNCPYSRC,SCH00024                                */
/*                  WNCPYSRC,SCH00025                                */
/*                  WNCPYSRC,SCH00026                                */
/*                  WNCPYSRC,SCH00027                                */
/*                  WNCPYSRC,SCH00028                                */
/*                  WNCPYSRC,SCH00029                                */
/*       CSC040  - Include parameter DTACPR in save commands to      */
/*                 reduce run time.                                  */
/*       BUG14179 - Include save/restore of KINPXzz equation library */
/*                  when Consumer Banking is switched on.            */
/*       BUG14057 - Move CRE026 enhancement validation line          */
/*       CSC033 - Include global libraries in backups.               */
/*       BUG12169 - Include equation libraries KLIB and KOPT.        */
/*                  Changed naming convention of equation DBIC       */
/*                  savefiles.                                       */
/*       CRE026 - Consumer Banking                                   */
/*       239298 - DO SAVE WHILE ACTIVE FOR MMM as it                 */
/*                causes lock for other zomes.                       */
/*     239918 - Apply fix 227074.                                    */
/*     227074 - Only one of the two SAVLIB must be executed          */
/*              depending on switchable feature CSC003.  Patterned   */
/*              after fix 222277.                                    */
/*       BUG9619 - Close of business components run long if journal  */
/*                 cache is enabled                                  */
/*     BG3834R- SCDMLCK is redundant                                 */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*     CSC020 - Journaling changes for MidasPlus.                    */
/*     214155 - End QZDASOINIT jobs locking the DMLIB.               */
/*     207764 - Change all SAV* and RST* commands to print a         */
/*              report of objects saved or restored.                 */
/*     206496 - Don't save MMM related journals.                     */
/*     CSW025 - Midas Message Manager                                */
/*                - Save/restore message manager library             */
/*     202830 - 'Save Database' option in the System Save/recovery   */
/*              menu didn't save the DTALIB                          */
/*     178962 - Database error on SCC1711 when RCFMONITOR failed     */
/*              to run due to allocation problem. Terminate job      */
/*              RCFMONITOR (send 'T' to dataqueue) if job is active. */
/*     CPK014 - Submit jobs with user *JOBD                          */
/*     CSC012 - Addition of a daily DTALIB save.                     */
/*     192731 - Change SAVLIB cmd to have USEOPTBLK *NO              */
/*                instead of *YES                                    */
/*     193382 - Stamp the DBIC save savefile with the Midas rundate. */
/*     183682  -  If Cashier data queue does not exist, create it.   */
/*     118516  -  Send warning of COB file lock to Cashier branch    */
/*                monitors.                                          */
/*     110242  -  Change defaults for SBMJOB cmd to take *JOBD       */
/*     S01408  -  Addition of core hook SCC1711004                   */
/*     S01408  -  Addition of core hook SCC1711INT                   */
/*                Addition of core hook SCC1711ERR                   */
/*                Addition of core hook SCC1711END                   */
/*                Addition of core hook SCC1711002                   */
/*                Addition of core hook SCC1711003                   */
/*     CSC002  -  Do not Submit TRMSAV if CSC002 installed.          */
/*     CSC003  -  Add switchable feature to save access paths        */
/*     S01408  -  Addition of core hook SC1711001                    */
/*     S01408  -  Addition of core hook SC1711MP1                    */
/*             -  Addition of core hook SC1711MPE                    */
/*     S01420 - COB enhancements (Batch processing)                  */
/*     S01495 - COB enhancements.                                    */
/*     S01463  -  Rename FCC0401 job to RCFMONITOR.                  */
/*     S01431  -  Amendments for Merva SWIFT                         */
/*     S01375  -  Changed for Auto Close of Business                 */
/*     S01319  -  Remove redundant processing   .                    */
/*     S01343  -  SC/RR/SD MODULE RENAME PROJECT.                    */
/*                - SCC1711 RENAMED FROM SDC1711.                    */
/*                - AUTOBKP RENAMED TO RRAUTOBKP.                    */
/*                - CHKAUTO RENAMED TO RRCHKAUTO.                    */
/*                - SDC1712 RENAMED TO SCC1712.                      */
/*                - SDC1716 RENAMED TO SCC1716.                      */
/*     RT0159  -  Messages should be sent via new Midas Info Screen. */
/*     E23432  -  DLYJOB ADDED TO PREVENT JOB LOOPING PREVENTING     */
/*                RRAUTOBKP BECOMING ACTIVE                          */
/*     LN0309  -  CORRECT SUBMIT OF FCC0401 JOB                      */
/*     E20391  -  RTGDTA(*JOBD) ADDED TO ALL SBMJOB CMDS.            * *E20391*/
/*     E17536  -  CM0330 SHOULD ONLY BE CALLED IF CMPROCAA = 'A'     */
/*     E18933  -  CHANGE CMPROCAAA TO 'C' IF IC TERMINATION.         */
/*     S01192  -  SWIFT 2780 PROTOCOL INCORPORATION                  */
/*     S01117  -  MULTIBRANCHING                                     */
/*     S01179  -  AS400 CONVERSION                                   */
/*     E11174  -  ERROR FIX E10752 HAD TO BE REAPPLIED BECAUSE IT    */
/*                WAS MISSING FROM THE SIGN OFF LIBRARY AFTER        */
/*                MSDL PHASE 3 WAS MERGED INTO THE CORE LIBRARIES.   */
/*     S01133  -  DEALING ROOM SYSTEM                                */
/*     S01118  -  MIDAS/S.W.I.F.T. DIRECT LINK                       */
/*     E81140  -  PROGRAM LOOPS IF RRAUTOBKP JOB HAS BEEN CANCELLED  */
/*                BUT JNSTAT POS 69 IS STILL SET TO 'Y'              */
/*     E80978  -  MONMSG CPF1362 AFTER CANCELLING AUTO BACKUP        */
/*                JOB IN CASE JOB NO LONGER EXISTS IN THE SYSTEM     */
/*     S01098  -  USE SAVE FILE FOR DISK SAVE.                       */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MODLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&ZONEID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DILIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SAVF) TYPE(*CHAR) LEN(7)
             DCL        VAR(&JRNE) TYPE(*CHAR) LEN(200)
             DCL        VAR(&JNSTAT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SFMT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&ACPTH) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SAVFTEXT) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RUNDAT) TYPE(*CHAR) LEN(13)
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7) VALUE(' ')
             DCL        VAR(&GLOBAL) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&GLOBID) TYPE(*CHAR) LEN(2)
/*/COPY SDCPYSRC,SDSVALDCL                                           */
             DCL        VAR(&DTACPRV) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRFK) TYPE(*CHAR) LEN(3) VALUE(' ')
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO ABNOR)
 
             SNDPGMMSG  MSG('Input Cycle Database Save - ' *CAT &MODE) +
                        TOMSGQ(MOPERQ)
 
/* Check if access paths are to be saved                               */
 
             CHGVAR     VAR(&RTN) VALUE('       ')
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')
             CHGVAR     VAR(&SARD) VALUE('CSC003')
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)
             IF         COND(&RTN *EQ '       ') THEN(DO)
               CHGVAR     VAR(&ACPTH) VALUE('*YES')
             ENDDO
             ELSE       DO
               CHGVAR     VAR(&ACPTH) VALUE('*NO')
             ENDDO
 
/*  Get System Value for Data Compression parameter in save commands */
 
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
                        ' ' &SVAL10)
 
             IF         COND(&RSVALRTNC *NE '       ') THEN(GOTO +
                             CMDLBL(ABNOR))
             CHGVAR     VAR(&DTACPRV) VALUE(&SVAL1)
 
/*  Determine whether global libraries should be saved.              */
 
             RTVDTAARA  DTAARA(JNSTAT) RTNVAR(&JNSTAT)
             CHGVAR     VAR(&GLOBAL) VALUE(%SST(&JNSTAT 172 1))
 
             IF         COND(&MODE *EQ 'BF') THEN(DO)
 
/** Save zonal schemas/libraries */
 
               IF         COND(&ACPTH *EQ '*YES') THEN(DO)
                 CHGVAR     VAR(&PRFK) VALUE('005')
               ENDDO
               ELSE       CMD(DO)
                 CHGVAR     VAR(&PRFK) VALUE('006')
               ENDDO
 
               CALL       PGM(SCC000303) PARM(&PRTCD &PRFK)
 
               IF         COND(&PRTCD *NE ' ') THEN(DO)
                 CHGJOB   SWS(XXXXXX11)
                 GOTO     CMDLBL(ENDPGM)
               ENDDO
 
               IF         COND(&GLOBAL *EQ 'Y') THEN(DO)
 
/** Save global schemas/libraries */
 
                 IF         COND(&ACPTH *EQ '*YES') THEN(DO)
                   CHGVAR       VAR(&PRFK) VALUE('007')
                 ENDDO
                 ELSE       DO
                   CHGVAR       VAR(&PRFK) VALUE('008')
                 ENDDO
 
                 CALL       PGM(SCC000303) PARM(&PRTCD &PRFK)
 
                 IF         COND(&PRTCD *NE ' ') THEN(DO)
                   CHGJOB   SWS(XXXXXX11)
                   GOTO     CMDLBL(ENDPGM)
                 ENDDO
 
               ENDDO
 
               GOTO       ENDPGM
 
             ENDDO
 
/*           IF         COND((&MODE *EQ 'DM') *OR (&MODE *EQ 'DTA')) + */           /*MD035839*/
/*                        THEN(DO)                                     */           /*MD035839*/
             IF         COND((&MODE *EQ 'DM') *OR (&MODE *EQ 'DTA') *OR +
                          (&MODE *EQ 'DD')) THEN(DO)                                /*MD035839*/
 
/* Retrieve data area SDSTAT for zone prefix */
 
               RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
               CHGVAR     VAR(&ZONEID) VALUE(%SUBSTRING(&SDSTAT 6 2))
               CHGVAR     VAR(&MODLIB) VALUE(&ZONEID *CAT &MODE +
                            *TCAT 'LIB')
               CHGVAR     VAR(&DILIB) VALUE(&ZONEID *CAT 'DILIB ')
 
             ENDDO
 
/*           IF         COND((&MODE *EQ 'GM') *OR (&MODE *EQ 'GTA')) +  */          /*MD035839*/
/*                          THEN(DO)                                    */          /*MD035839*/
             IF         COND((&MODE *EQ 'GM') *OR (&MODE *EQ 'GTA') *OR +
                          (&MODE *EQ 'GD')) THEN(DO)                                /*MD035839*/
 
               IF         COND(&GLOBAL *EQ 'Y') THEN(DO)
 
/*  Determine global system ID.                                      */
 
               CALL       PGM(AOSVALR0) PARM(&PRTCD 'BrgMidasGlobalPrefix' +
                            &SVAL1 &SVALK2 &SVAL2 &SVALK3 &SVAL3 +
                            &SVALK4 &SVAL4 &SVALK5 &SVAL5 &SVALK6 +
                            &SVAL6 &SVALK7 &SVAL7 &SVALK8 &SVAL8 +
                            &SVALK9 &SVAL9 &SVALK10 &SVAL10)
 
/* If there is an error finding system values, then end abnormally.  */
 
               IF         COND(&PRTCD *NE '       ') THEN(GOTO +
                            CMDLBL(ABNOR))
 
               CHGVAR     VAR(&GLOBID) VALUE(&SVAL1)
               CHGVAR     VAR(&MODLIB) VALUE(&GLOBID *CAT &MODE +
                            *TCAT 'LIB')
               RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)                               /*AR1096483*/
               CHGVAR     VAR(&ZONEID) VALUE(%SUBSTRING(&SDSTAT 6 2))                  /*AR1096483*/
               CHGVAR     VAR(&DILIB) VALUE(&ZONEID *CAT 'DILIB ')                     /*AR1096483*/
 
               ENDDO
               ELSE       DO
 
                 GOTO       ENDPGM
 
               ENDDO
 
             ENDDO
 
/* Determine savefile name */
 
             CHGVAR   VAR(&SAVF) VALUE('DBIC' *CAT &MODE)
 
/*           IF         COND((&MODE *EQ 'GM') *OR +                */               /*MD035839*/
/*                        (&MODE *EQ 'GTA')) THEN(DO)              */               /*MD035839*/
             IF         COND((&MODE *EQ 'GM') *OR +
                          (&MODE *EQ 'GTA') *OR (&MODE *EQ 'GD')) THEN(DO)          /*MD035839*/
/**********    SAVLIB     LIB(&MODLIB) DEV(*SAVF) SAVF(&DILIB/&SAVF) +
                            USEOPTBLK(*NO) CLEAR(*ALL) PRECHK(*YES) +
                            SAVACT(*LIB) ACCPTH(&ACPTH) +
                            DTACPR(&DTACPRV) OUTPUT(*PRINT)        */                   /*MD038500*/
               SAVLIB     LIB(&MODLIB) DEV(*SAVF) SAVF(&DILIB/&SAVF) +
                          USEOPTBLK(*NO) CLEAR(*ALL) PRECHK(*YES) +
                          SAVACT(*LIB) SAVACTWAIT(120 *NOCMTBDY) +
                          ACCPTH(*YES) DTACPR(&DTACPRV) +
                          OUTPUT(*PRINT)                                                /*MD038500*/
 
             ENDDO
             ELSE       DO
/**********    SAVLIB     LIB(&MODLIB) DEV(*SAVF) SAVF(&DILIB/&SAVF) +
                            USEOPTBLK(*NO) CLEAR(*ALL) PRECHK(*YES) +
                            ACCPTH(&ACPTH) DTACPR(&DTACPRV) +
                            OUTPUT(*PRINT)                         */                   /*MD038500*/
               SAVLIB     LIB(&MODLIB) DEV(*SAVF) SAVF(&DILIB/&SAVF) +
                          USEOPTBLK(*NO) CLEAR(*ALL) PRECHK(*YES) +
                          SAVACT(*LIB) SAVACTWAIT(120 *NOCMTBDY) +
                          ACCPTH(&ACPTH) DTACPR(&DTACPRV) +
                          OUTPUT(*PRINT)                                                /*MD038500*/
             ENDDO
 
             RTVDTAARA  DTAARA(RUNDAT) RTNVAR(&RUNDAT)
 
             CHGVAR     VAR(&SAVFTEXT) VALUE(%SST(&RUNDAT 1 7) +
                         *CAT  ' - Midas I/C termination ' +
                         *CAT &MODE *TCAT 'LIB save')
             CHGSAVF    FILE(&DILIB/&SAVF) TEXT(&SAVFTEXT)
 
             CHGVAR     VAR(%SUBSTRING(&JRNE 1 5)) VALUE('DISK ')
             CHGVAR     VAR(%SUBSTRING(&JRNE 6 8)) VALUE(&MODLIB)
             CHGVAR     VAR(%SUBSTRING(&JRNE 16 8)) VALUE(&DILIB)
             CHGVAR     VAR(%SUBSTRING(&JRNE 26 4)) VALUE('DISK')
/*********   SNDJRNE    JRN(ICJRN) TYPE('SV') ENTDTA(&JRNE)      */                       /*CSC048*/
             SNDJRNE    JRN(ICJRN) TYPE('SV') ENTDTA(&JRNE) +
                          FORCE(*YES)                                                     /*CSC048*/
 
             GOTO       ENDPGM
 
ABNOR:
 
             SNDPGMMSG  MSG('Input Cycle Database Save - ' *CAT &MODE +
                          *TCAT ' ENDED ABNORMALLY') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 ENDPGM:
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
