     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Global updates - FX')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOGLOBFX - Global Updates - FX                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CGP017             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG3286            Date 17Jun04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGP017 - Global Layer - GOC0100 Task Split (Recompile)       *
      *  BUG3286 - Replication of extension files should not be       *
      *            conditioned on CLE025                              *
      *  CLE025 - Credit Lines                                        *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
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
 
     D CLE025          S              1                                                       CLE025
     D PSARD           S              6                                                       CLE025
     D PRTCD           S              7                                                       CLE025
     D POPTN           S              7                                                       CLE025
 
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
     C     PFLNAME       CASEQ     'FXCLSPSD'    GLOB_FXCLSPSD
     C     PFLNAME       CASEQ     'FXCLSPSH'    GLOB_FXCLSPSH
     C     PFLNAME       CASEQ     'FXDEALPP'    GLOB_FXDEALPP
     C     PFLNAME       CASEQ     'DLDLDBQD'    GLOB_DLDLDBQD                               BUG3286
     C                   ENDCS
     C*****CLE025        IFEQ      'Y'                                                CLE025 BUG3286
     C*****PFLNAME       ANDEQ     'DLDLDBQD'                                         CLE025 BUG3286
     C**********         EXSR      GLOB_DLDLDBQD                                      CLE025 BUG3286
     C**********         ENDIF                                                        CLE025 BUG3286
     C                   ENDIF
 
     C                   MOVEL     'A'           I#BFAF
     C                   ENDDO
 
     C                   RETURN
 
      /SPACE 5
      *****************************************************************
      * Global Updates - CLS Pay-in Schedule Detail
      *****************************************************************
     C     GLOB_FXCLSPSD BEGSR
      /COPY GPCPYSRCG,GPFXCLSPSD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - CLS Pay-in Schedule Header
      *****************************************************************
     C     GLOB_FXCLSPSH BEGSR
      /COPY GPCPYSRCG,GPFXCLSPSH
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - FX Deal
      *****************************************************************
     C     GLOB_FXDEALPP BEGSR
      /COPY GPCPYSRCG,GPFXDEALPP
     C                   ENDSR
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
      /SPACE 5                                                                                CLE025
      *****************************************************************                       CLE025
      * Global Updates - FX Deal Extension                                                    CLE025
      *****************************************************************                       CLE025
     C     GLOB_DLDLDBQD BEGSR                                                                CLE025
      /COPY GPCPYSRCG,GPDLDLDBQD                                                              CLE025
     C                   ENDSR                                                                CLE025
      *****************************************************************                       CLE025
     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
                                                                                              CLE025
      ** Determine if CLE025 is switched on                                                   CLE025
                                                                                              CLE025
     C                   CALL      'AOSARDR0'                                                 CLE025
     C                   PARM      *BLANKS       PRTCD                                        CLE025
     C                   PARM      '*VERIFY'     POPTN                                        CLE025
     C                   PARM      'CLE025'      PSARD                                        CLE025
                                                                                              CLE025
     C                   IF        PRTCD = *BLANKS                                            CLE025
     C                   MOVE      'Y'           CLE025                                       CLE025
     C                   ELSE                                                                 CLE025
     C                   MOVE      'N'           CLE025                                       CLE025
     C                   ENDIF                                                                CLE025
 
     C                   MOVEL     *BLANK        I#RTCD            7
     C                   MOVEL     *BLANK        I#ERMS           50
 
      * Get Zone
 
      /COPY GOCPYSRC,GOGETZONE
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
