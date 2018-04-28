     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Global updates - SF')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOGLOBSF - Global Updates - SF                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. MD023043A          Date 27Nov13               *
      *  Prev Amend No. AR1094271          Date 11Mar13               *
      *                 AR1095441          Date 11Mar13               *
      *                 CGP017             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 239452             Date 28Apr06               *
      *                 CRE024             Date 22Dec05               *
      *                 BG7655             Date 27JUn05               *
      *                 BG6438             Date 05Apr05               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD023043A - Encounters an error upon switch-ON of CSW213     *
      *              (Recompile)                                      *
      *  AR1094271 - Zonal data of SFRAURPA and SFRAAUPA were not     *
      *              replicated to their global files                 *
      *  AR1095441 - COBOP Compilation Issues                         *
      *  CGP017 - Global Layer - GOC0100 Task Split (Recompile)       *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  239452 - Recompiled over correct copy source version.        *
      *  CRE024 - Restricted Account                                  *
      *  BG7655 - Rework BG6438 (Secondary triggers on global files)  *
      *  BG6438 - Remove secondary triggers on consolidated files     *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     F******T_SECDATL1UF A E           K DISK    INFSR(*PSSR) COMMIT(D_COM)            BG6438 BG7655
     F******                               USROPN                                      BG6438 BG7655
      ******                                                                           BG6438 BG7655
     D*****Z_MACBRDD     E DS                  EXTNAME(MACBRDD)                        BG6438 BG7655
                                                                                       BG6438 BG7655
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
     D PARM1           DS
      * Physical file name
     D  PFLNAME                1     10
      * Member name
     D  MBRNAME               21     30
      * Trigger event
     D  TRGEVENT              31     31
      * Offset to the before image of the record
     D  BOFF                  49     52B 0
      * Length of the before image of the record
     D  BLEN                  53     56B 0
      * Offset to the after image of the record
     D  AOFF                  65     68B 0
      * Length of the after image of the record
     D  ALEN                  69     72B 0
     D  EntryData            117  10117A
 
 
     D PARM2           DS
     D  LENG                   1      4B 0
 
 
      * ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    PARM1
     C                   PARM                    PARM2
 
      * Recover before and after image
 
     C     BOFF          ADD       1             OffSet            5 0
     C     BLen          SUBST     PARM1:OffSet  I#BIMG         4000
 
     C     AOFF          ADD       1             OffSet
     C     ALen          SUBST     PARM1:OffSet  I#AIMG         4000
 
 
      * Global Updates - BEFORE/AFTER image
      * TRGEVENT: '1'=INSERT, '2'=DELETE, '3'=UPDATE
     C     TRGEVENT      IFEQ      '1'
     C                   MOVEL     *BLANK        I#BIMG
     C                   ENDIF
     C     TRGEVENT      IFEQ      '2'
     C                   MOVEL     *BLANK        I#AIMG
     C                   ENDIF
 
     C                   MOVEL     O#ZONE        I#ZONE                         * ERROR MESSAGE
     C                   MOVEL     'Y'           I#TRAP
 
      * Determine updates
 
     C                   EXSR      DET_UPDATES
 
     C                   MOVEL     'B'           I#BFAF
     C                   DO        2
 
     C     P_Before      IFEQ      'Y'
     C     I#BFAF        ANDEQ     'B'
     C     P_After       OREQ      'Y'
     C     I#BFAF        ANDEQ     'A'
     C     PFLNAME       CASEQ     'MACBRDD '    GLOB_MACBRDD
     C     PFLNAME       CASEQ     'MUSERDD '    GLOB_MUSERDD
     C     PFLNAME       CASEQ     'SFMENUPD'    GLOB_SFMENUPD
     C     PFLNAME       CASEQ     'SFRAURPA'    GLOB_SFRAURPA                             AR1094271
     C     PFLNAME       CASEQ     'SFRAAUPA'    GLOB_SFRAAUPA                             AR1094271
     C                   ENDCS
     C                   ENDIF
 
     C                   MOVEL     'A'           I#BFAF
     C                   ENDDO
 
     C                   RETURN
 
      /SPACE 5
      *****************************************************************
      * Global Updates - Valid action Codes for User/Branch/Item
      *****************************************************************
     C     GLOB_MACBRDD  BEGSR
      ***/COPY*GPCPYSRCG,GPMACBRDD*************************************                    AR1095441
      /COPY GPCPYSRCG,T_SECDATA                                                               BG7655
      ******                                                                           BG6438 BG7655
     C*****I#BFAF        IFEQ      'B'                                                 BG6438 BG7655
     C******             MOVEL     I#BIMG        Z_MACBRDD                             BG6438 BG7655
     C******             ELSE                                                          BG6438 BG7655
     C******             MOVEL     I#AIMG        Z_MACBRDD                             BG6438 BG7655
     C******             ENDIF                                                         BG6438 BG7655
      ******                                                                           BG6438 BG7655
      **Use*USRP from MACBRDD to get position on T_SECDATA                             BG6438 BG7655
     C******             MOVE      USRP          KUSER            10                   BG6438 BG7655
     C*****KUSER         SETLL     T_SECDATL1                         99               BG6438 BG7655
      ******                                                                           BG6438 BG7655
     C*****KUSER         READE     T_SECDATL1                             98           BG6438 BG7655
      ******                                                                           BG6438 BG7655
     C******IN98         DOWEQ     '0'                                                 BG6438 BG7655
     C******             DELETE    T_SECDATL1                                          BG6438 BG7655
     C*****KUSER         READE     T_SECDATL1                             98           BG6438 BG7655
     C******             ENDDO                                                         BG6438 BG7655
      ******                                                                           BG6438 BG7655
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Midas Users
      *****************************************************************
     C     GLOB_MUSERDD  BEGSR
      /COPY GPCPYSRCG,GPMUSERDD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Menu Master Data
      *****************************************************************
     C     GLOB_SFMENUPD BEGSR
      /COPY GPCPYSRCG,GPSFMENUPD
     C                   ENDSR
      *****************************************************************                    AR1094271
      /SPACE 5                                                                             AR1094271
      *****************************************************************                    AR1094271
      * Global Updates - Mixed SFRAAUPA & SFRACRPA File for M+                             AR1094271
      *****************************************************************                    AR1094271
     C     GLOB_SFRAURPA BEGSR                                                             AR1094271
      /COPY GPCPYSRCG,GPSFRAURPA                                                           AR1094271
     C                   ENDSR                                                             AR1094271
      *****************************************************************                    AR1094271
      /SPACE 5                                                                             AR1094271
      *****************************************************************                    AR1094271
      * Global Updates - Restricted Accounts Authorised Users                              AR1094271
      *****************************************************************                    AR1094271
     C     GLOB_SFRAAUPA BEGSR                                                             AR1094271
      /COPY GPCPYSRCG,GPSFRAAUPA                                                           AR1094271
     C                   ENDSR                                                             AR1094271
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Determine Updates
      *****************************************************************
     C     DET_UPDATES   BEGSR
 
     C                   CALL      'GPDETGUPD'
     C                   PARM                    I#ZONE           10
     C                   PARM      PFLNAME       I#FILE           10
     C                   PARM                    I#BIMG
     C                   PARM                    I#AIMG
     C                   PARM      'N'           P_Before          1
     C                   PARM      'N'           P_After           1
 
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
 
     C                   MOVEL     *BLANK        I#RTCD            7
     C                   MOVEL     *BLANK        I#ERMS           50
 
      * Get Zone
 
      /COPY GOCPYSRC,GOGETZONE
      ******                                                                           BG6438 BG7655
      **Open for commit?                                                               BG6438 BG7655
     C******             CALL      'GPCOPN4COM'                                        BG6438 BG7655
     C******             PARM                    D_COM             1                   BG6438 BG7655
     C******             OPEN      T_SECDATL1                                          BG6438 BG7655
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
