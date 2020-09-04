     H DEBUG
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SF Val action code for user/pgm/brch')
      *****************************************************************
      *                                                               *
      *  Midas - Security Profile Facility                            *
      *                                                               *
      *  ZVACTBU - Standard program to validate action/branch codes   *
      *            versus user/programs                               *
      *                                                               *
      *  Function: This program checks, for a user, if the combination*
      *            of Action Code and Branch Code is authorised to a  *
      *            menu group/item.                                   *
      *            A parameter is passed back to the calling program  *
      *            to indicate validity :                             *
      *            0 - all valid                                      *
      *            1 - no actions are authorised for this user/branch/*
      *                menu item.                                     *
      *            2 - user is not authorised to this action code for *
      *                this menu item/branch.                         *
      *                                                               *
      *  Where Used: Input Cycle, multibranch environment             *
      *                                                               *
      *  Called By: Any program requiring this validation             *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Any changes made to this program may also need to be         *
      *  incorporated in ZBACTBU.                                     *
      *                                                               *
      *  Last Amend No. MD035137           Date 23Jul15               *
      *  Prev Amend No. CCB020             Date 06Aug12               *
      *                 AR867641           Date 20Nov11               *
      *                 CBF005 *REWRITE    Date 19Oct11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG25892           Date 04Sep09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11849           Date 08Aug06               *
      *                 CSD031             Date 10Apr06               *
      *                 236017             Date 08Nov05               *
      *                 BUG4283            Date 23Sep04               *
      *                 BUG2287            Date 28Apr04               *
      *                 CAP084             Date 10Jul03               *
      *                 CSF002             Date 11Aug03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 197434             Date 25Mar02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 E26748             Date 01Aug91               *
      *                 RT0148             Date 06Jun91               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD035137 - Applied missing fix for BUG25892                  *
      *  CCB020 - COB Restructure - Secondary COB Infrastructure      *
      *         - Remove checking and processing for CSC011 (24x7)    *
      *  AR867641 - BFMidas Drop2 build compilation issues            *
      *  CBF005 - BF Infrastructure: Single Security User Maintenance *
      *           Profile (REWRITE)                                   *
      *  BUG25892 - Dump in STP during validation of branch, act code *
      *  BUG11849 - User not authorized to Standard Settlement menu   *
      *  CSD031 - Enhanced Centralised Static Data                    *
      *  236017 - Intermittent branch/action code problem             *
      *  BUG4283 - Reaccess MACBR if menu index has changed           *
      *  BUG2287 - Show consolidated global view  (Recompile)         *
      *  CAP084 - API Wrapper project                                 *
      *  CSF002 - Global layer.                                       *
      *           - Replace previous ZMITEM layout with the new       *
      *             unique code.                                      *
      *  197434 - Array index error on SF0021. Increase maximum       *
      *           number of branches from 100 to 900.                 *
      *  CSC011 - 24x7 Midas Availability                             *
      *  E26748 - Source member incorrectly placed in ZARPGSRC so     *
      *           moved to SFRPGSRC.                                  *
      *  RT0148 - Increase number of action codes to 10               *
      *                                                               *
      *****************************************************************
      *
      *       FUNCTION OF INDICATORS
      *
      *       96       BRANCH ENCOUNTERED PREVIOUSLY, DONOT CHAIN AGAIN
      *       97       BRANCH/MENU ITEMS/USER NOT ON MACBR
      *
      *****************************************************************
      *       INPUTS TO THIS PROGRAMME
      *
      *       BRANCH CODE 3A  (FROM THE CALLING PROGRAM)
      *       ACTION CODE 1A  (FROM THE CALLING PROGRAM)
      *       DTAARA/ZMITEM   MENU ITEM REQUESTED
      *       USRID from PSDS
      *
      *****************************************************************
      *       OUTPUT FROM THIS PROGRAMME
      *
      * ERROR CODE : 0 = NO ERROR
      *              1 = NO RECORD FOUND FOR USER/MENU ITEM/BRANCH
      *              2 = ACTION CODE NOT VALID FOR USER/MENU ITEM/BRANCH
      *
      *****************************************************************
      *
     FSFMENUL0  IF   E           K DISK
     FGPMENUL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(SFMENUD0:GPMENUD0)
 
     D** EXTERNAL DATA AREA OF MENU ITEM REQUESTED
      *
     D ZMITEM          DS
     D  UNQCDE                 1     10
      *
      ** External data area for user name
     D ZMUSER          DS            17
     D  ZMUSR                  1     10
 
     D PSDS           SDS
     D  USRID                254    263
 
     D/COPY WNCPYSRC,ZVACTBUI01
 
     D R_Count         S              4  0
     D SQL_Err         S              1A
 
     D*SDSTAT***     E DS           256    EXTNAME(SDSTAT)                                    CCB020
      ***Standing*Data*Data*Structure**********************************                       CCB020
      *****************************************************************                       CCB020
     D*SC24X7***     E DS           256    EXTNAME(SC24X7)                                    CCB020
      ***24*x*7*Status*Data*Structure**********************************                       CCB020
      *
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** Data Structure for SAR Details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
     I*
     ISFMENUD0
     I              MIAAC10                     MIAA10
      *
     IGPMENUD0
     I              MIAAC10                     MIAA10
 
      *
     C     CSD031        IFEQ      'Y'
     C     *INU1         ANDEQ     *ON
     C                   OPEN      GPMENUL0
     C                   ENDIF
      *
     C     *DTAARA       DEFINE                  ZMITEM
     C                   IN        ZMITEM
     C                   UNLOCK    ZMITEM
      *
      ** If ZMUSER exists, use the name from that, otherwise use the PSDS
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER                               99
     C     *IN99         IFEQ      '0'
     C                   UNLOCK    ZMUSER
     C                   ENDIF
      *
     C     ZMUSR         IFNE      *BLANKS
     C                   MOVEL     ZMUSR         USRID
     C                   ENDIF
 
     C                   EXSR      ChkAuth
 
     C/COPY WNCPYSRC,ZVACTBUC01
     C/COPY WNCPYSRC,ZVACTBUC02
      *
     C     *DTAARA       DEFINE                  LDA
      *
     C*****ERR**         IFEQ      0                                                          CCB020
     C*****ERR**         OREQ      2                                                          CCB020
      *****************************************************************                       CCB020
      ***Determine*if*CSC011*is*installed******************************                       CCB020
      *****************************************************************                       CCB020
     C**********         CALL      'AOSARDR0'                                                 CCB020
     C**********         PARM      *BLANKS       @RTCD             7                          CCB020
     C**********         PARM      '*VERIFY '    @OPTN             7                          CCB020
     C**********         PARM      'CSC011'      @SARD             6                          CCB020
     C*****SCSARD        PARM      SCSARD        DSFDY                                        CCB020
      *****************************************************************                       CCB020
     C*****@RTCD         IFNE      *BLANKS                                                    CCB020
     C*****@RTCD         ANDNE     '*NRF   '                                                  CCB020
     C******LOCK         IN        LDA                                                        CCB020
     C**********         MOVEL     'SCSARDPD'    DBFILE                                       CCB020
     C**********         Z-ADD     01            DBASE                                        CCB020
     C**********         MOVEL     'CSC011'      DBKEY                                        CCB020
     C**********         MOVEL     'ZVACTBU'     DBPGM                                        CCB020
     C**********         OUT       LDA                                                        CCB020
     C**********         EXSR      *PSSR                                                      CCB020
     C**********         ENDIF                                                                CCB020
      *****************************************************************                       CCB020
     C*****@RTCD         IFEQ      *BLANKS                                                    CCB020
      *****************************************************************                       CCB020
      ***Access*SDSTAT*to*get*the*current*system*prefix****************                       CCB020
      *****************************************************************                       CCB020
     C******DTAARA       DEFINE                  SDSTAT                                       CCB020
     C**********         IN        SDSTAT                                                     CCB020
      *****************************************************************                       CCB020
      ***Access*SC24X7*to*get*the*support*system*prefix*and************                       CCB020
      ***maintenance*code**********************************************                       CCB020
      *****************************************************************                       CCB020
     C******DTAARA       DEFINE                  SC24X7                                       CCB020
     C**********         IN        SC24X7                                                     CCB020
      *****************************************************************                       CCB020
     C*****LIBR*         IFEQ      S1SUPP                                                     CCB020
      *****************************************************************                       CCB020
     C*****CSD031        IFEQ      'Y'                                                        CCB020
     C******INU1         ANDEQ     *ON                                                        CCB020
     C*****UNQCDE        CHAIN     GPMENUL0                           20                      CCB020
     C**********         ELSE                                                                 CCB020
     C*****UNQCDE        CHAIN     SFMENUL0                           20                      CCB020
     C**********         ENDIF                                                                CCB020
      *****************************************************************                       CCB020
     C******IN20         IFEQ      *ON                                                        CCB020
     C**********         Z-ADD     1             ERR                                          CCB020
     C**********         ELSE                                                                 CCB020
      *****************************************************************                       CCB020
     C*****MIACOB        IFEQ      'N'                                                        CCB020
     C*****MIACOB        OREQ      *BLANK                                                     CCB020
     C**********         Z-ADD     1             ERR                                          CCB020
     C**********         ELSE                                                                 CCB020
      *****************************************************************                       CCB020
     C*****ZACTN         IFNE      'E'                                                        CCB020
     C*****S1MANT        ANDEQ     'E'                                                        CCB020
     C*****ZACTN         ORNE      'E'                                                        CCB020
     C*****MIACOB        ANDEQ     'E'                                                        CCB020
     C**********         Z-ADD     2             ERR                                          CCB020
     C**********         ENDIF                                                                CCB020
      *****************************************************************                       CCB020
     C**********         ENDIF                                                                CCB020
      *****************************************************************                       CCB020
     C**********         ENDIF                                                                CCB020
      *****************************************************************                       CCB020
     C**********         ENDIF                                                                CCB020
      *****************************************************************                       CCB020
     C**********         ENDIF                                                                CCB020
      *****************************************************************                       CCB020
     C**********         ENDIF                                                                CCB020
      *
     C     CSD031        IFEQ      'Y'
     C     *INU1         ANDEQ     *ON
     C                   CLOSE     GPMENUL0
     C                   ENDIF
      *
     C**********         SETON                                        LR                    MD035137
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ChkAuth - Check user authority                               *
      *                                                               *
      *****************************************************************
     C     ChkAuth       BEGSR
      *
     C                   EVAL      ERR = 1
 
     C/EXEC SQL WHENEVER SQLERROR GOTO CheckEnd
     C/END-EXEC
 
     C/EXEC SQL WHENEVER NOT FOUND GOTO CheckEnd
     C/END-EXEC
 
     C/EXEC SQL
     C+  SELECT Count(*) into :R_Count from MIVW_PerMM
     C**********WHERE PMINDX = :UNQCDE AND PMACTC = :ZACTN                                  AR867641
     C**********   AND ENENTV = :ZBR   AND ENUSER = :USRID                                  AR867641
     C**********   AND ENENTT = 'Branch'                                                    AR867641
     C+         WHERE INDX = :UNQCDE AND ACA = :ZACTN                                       AR867641
     C+            AND BRCB = :ZBR   AND USRP = :USRID                                      AR867641
     C/END-EXEC
 
      ** IF NO RECORD FOR THE ACTION, CHECK IF USER IS AUTHORISE TO OTHER ACTION
     C                   IF        R_Count < 1
 
     C/EXEC SQL
     C+  SELECT Count(*) into :R_Count from MIVW_PerMM
     C**********WHERE PMINDX = :UNQCDE                                                      AR867641
     C**********   AND ENENTV = :ZBR   AND ENUSER = :USRID                                  AR867641
     C**********   AND ENENTT = 'Branch'                                                    AR867641
     C+         WHERE INDX = :UNQCDE                                                        AR867641
     C+            AND BRCB = :ZBR   AND USRP = :USRID                                      AR867641
     C/END-EXEC
 
     C                   IF        R_COUNT > 0
     C                   EVAL      ERR = 2
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      ERR = 0
     C                   ENDIF
 
     C     CheckEnd      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program Exception Error Routine                      *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation subroutine.                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    ZACTN             1
     C                   PARM                    ZBR               3
     C                   PARM                    ERR               1 0
      *
      ** Check if CSD031 is on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CSD031'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   MOVE      'N'           CSD031            1
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSD031
     C                   ELSE
      *
     C     PRTCD         IFNE      '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CSD031'      DBKEY
     C                   Z-ADD     101           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
