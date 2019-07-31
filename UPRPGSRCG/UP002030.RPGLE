     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*XBI *  OVRDBF FILE(FROMLIB) TOFILE(QAFDMBRL)                        *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Determine MidasPlus name for a mbr or src')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP002030 - Determine MidasPlus Name for a Member or Source   *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CUP025  *CREATE    Date 26Jan04               *
      *                 XXXXXX             Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CUP025 - MidasPlus Upgrade Utilities.                        *
      *                                                               *
      *****************************************************************
 
      * +--------------------------------------+
      * ¦ F-specs                              ¦
      * ¦ =======                              ¦
      * +--------------------------------------+
 
      * Driving file (DSPFD *MBRLIST)
     FFROMLIB   IF   E             DISK
 
      * Target member/source rename data - MBR records only
     FUPMPRNL0  IF   E           K DISK
 
      * Target member/source rename data - SRC records only
     FUPMPRNL1  IF   E           K DISK
 
      * Target member/source rename data - PFX records only
     FUPMPRNL2  IF   E           K DISK
 
     D FromLibr        S             10
     D FromLibPfx      S              2
     D ToLibr          S             10
     D OldMbr          S             10
     D OldSrc          S             10
     D NewMbr          S             10
     D NewSrc          S             10
     D NewSrcInd       S              1
     D MbrName         S             10
     D SrcName         S             10
     D ClCheck2        S              2
     D ClCheck3        S              3
     D ModPrefix       S             10
     D Database        S              3
     D Recursive       S              1
     D NewMbrLvl       S              1
     D Suffix          S              1
     D DBaseSfx        S              1
     D ExtraFrom       S             10
     D ExtraTo         S             10
 
      * +--- Start of Main processing -----------------------------------+
      * ¦                                                                ¦
      * +----------------------------------------------------------------+
 
     C     *ENTRY        PLIST
     C                   PARM                    FromLibr
     C                   PARM                    ToLibr
 
     C     READ1         TAG
 
      * Read driving file
     C                   READ      FROMLIB                              9090
 
     C                   EVAL      FromLibPfx = %SUBST(MLFILE:1:2)
 
      * Ignore skeleton sources and C headers
     C     FromLibPfx    IFEQ      'SK'                                         IF1
     C     FromLibPfx    OREQ      'H '
      *
      * Call the program to copy the member to the same name and source file
     C                   CALL      'UPC002031'
     C                   PARM                    MLNAME
     C                   PARM                    MLNAME
     C                   PARM                    MLFILE
     C                   PARM                    MLFILE
     C                   PARM                    FromLibr
     C                   PARM                    ToLibr
      *
     C                   GOTO      READ1
     C                   END                                                    ENDIF1
 
      * Main processing loop
     C     *IN90         DOWEQ     *OFF                                         DOW1
 
      * Initialise parameters
     C                   EVAL      NewMbr = MLNAME
     C                   EVAL      NewSrc = MLFILE
     C                   EVAL      MbrName = MLNAME
     C                   EVAL      SrcName = MLFILE
 
      * Check for predefined member renames
     C     MbrName       CHAIN     UPMPRNL0                           9999
 
      * If a predefined member rename is present then re-initialise parameter
     C     *IN99         IFEQ      *OFF                                         IF1
     C                   EVAL      NewMbr = RNNEWN
     C                   EVAL      NewMbrLvl = RNLAYR
     C                   END                                                    ENDIF1
 
      * Check for predefined source file renames in the Extra Defn Details
     C                   EVAL      ExtraFrom = %SUBST(RNDEFN:1:10)
     C                   EVAL      ExtraTo = %SUBST(RNDEFN:11:20)
 
      * If a predefined src rename is present then re-initialise parameter
     C     ExtraFrom     IFEQ      MLFILE                                       IF1
     C                   EVAL      NewSrc = ExtraTo
     C                   EVAL      NewSrcInd = 'Y'
     C                   END                                                    ENDIF1
 
      * Check for predefined source file renames
     C     SrcName       CHAIN     UPMPRNL1                           9898
 
      * If a predefined src rename is present then re-initialise parameter
     C     *IN98         IFEQ      *OFF
     C                   EVAL      NewSrc = RNNEWN
     C                   EVAL      NewSrcInd = 'Y'
     C                   END
 
      * If the source is a CL source then extend the name from CL to CLP
     C                   EVAL      ClCheck2 = %SUBST(NewSrc:3:2)
     C                   EVAL      ClCheck3 = %SUBST(NewSrc:3:3)
     C     ClCheck2      IFEQ      'CL'
     C     ClCheck3      ANDNE     'CLP'
     C     ClCheck3      ANDNE     'CLE'
     C                   EVAL      NewSrc = %SUBST(NewSrc:1:2) + 'CLP' +
     C                             %SUBST(NewSrc:5:6)
     C                   END
 
      * Check for predefined module ID renames
     C                   EVAL      ModPrefix = %SUBST(NewSrc:1:2)
     C     ModPrefix     CHAIN     UPMPRNL2                           9797
 
      * If a predefined mod rename is present and it is a database
      * object then replace the position 9 'D' with 'G' if necessary
     C                   EVAL      Database = %SUBST(NewSrc:3:3)
     C                   EVAL      DBaseSfx = %SUBST(NewSrc:9:1)
     C     Database      IFEQ      'DDS'
     C     Database      OREQ      'DTA'
     C     Database      OREQ      'DTQ'
     C     Database      OREQ      'SQL'
     C     Database      OREQ      'TBL'
 
      * If a layer has been defined
     C     RNLAYR        IFNE      ' '
     C                   EVAL      %SUBST(NewSrc:9:1) = RNLAYR
     C                   END
 
      * If no layer has been defined and not a PRTF and not a *CM
      * and not a *QT
     C     RNLAYR        IFEQ      ' '
     C     DBaseSfx      ANDNE     'P'
     C     DBaseSfx      ANDNE     'C'
     C     DBaseSfx      ANDNE     'Q'
     C     NewSrcInd     ANDEQ     ' '
     C                   EVAL      %SUBST(NewSrc:9:1) = 'D'
     C                   END
 
      * If no layer has been defined and a PRTF
     C     RNLAYR        IFEQ      ' '
     C     DBaseSfx      ANDEQ     'P'
     C     NewSrcInd     ANDEQ     ' '
     C                   EVAL      %SUBST(NewSrc:9:1) = 'P'
     C                   END
 
      * If no layer has been defined and a *CM
     C     RNLAYR        IFEQ      ' '
     C     DBaseSfx      ANDEQ     'C'
     C     NewSrcInd     ANDEQ     ' '
     C                   EVAL      %SUBST(NewSrc:9:1) = 'C'
     C                   END
 
      * If no layer has been defined and a *QT
     C     RNLAYR        IFEQ      ' '
     C     DBaseSfx      ANDEQ     'Q'
     C     NewSrcInd     ANDEQ     ' '
     C                   EVAL      %SUBST(NewSrc:9:1) = 'Q'
     C                   END
     C                   END
 
      * If a predefined mod rename is present and it is not a database
      * object then re-initialise parameter
     C     Database      IFNE      'DDS'
     C     Database      ANDNE     'DTA'
     C     Database      ANDNE     'DTQ'
     C     Database      ANDNE     'SQL'
     C     Database      ANDNE     'TBL'
 
      * If a specific level (zone or global) has been defined
      * then initialise the 'Suffix' variable
     C     NewMbrLvl     IFNE      ' '
     C                   EVAL      Suffix = NewMbrLvl
     C                   END
 
      * If no specific level has been defined
     C     Suffix        IFEQ      ' '
     C     RNLAYR        ANDEQ     ' '
     C                   EVAL      Suffix = 'Z'
     C                   END
 
      * If it is a *CPYSRC source file or QWINDSRC
     C     Database      IFEQ      'CPY'
     C     MLFILE        OREQ      'QWINDSRC'
     C                   EVAL      NewSrc = MLFILE
     C                   GOTO      COPY
     C                   END
 
      * If a specific module prefix has been defined
     C     *IN97         IFEQ      *OFF
     C                   EVAL      NewSrc = %SUBST(ModPrefix:1:2) +
     C                             %SUBST(NewSrc:3:6) + RNLAYR
     C                   END
 
      * If a specific module prexix has not been defined
     C     *IN97         IFEQ      *ON
     C     NewSrcInd     ANDEQ     ' '
     C                   EVAL      NewSrc = %SUBST(NewSrc:1:8) + Suffix
     C                   END
 
     C                   END
 
     C     COPY          TAG
      *
      * Call the program to copy the member to the new name and source file
     C                   CALL      'UPC002031'
     C                   PARM                    MLNAME
     C                   PARM                    NewMbr
     C                   PARM                    MLFILE
     C                   PARM                    NewSrc
     C                   PARM                    FromLibr
     C                   PARM                    ToLibr
      *
      * Reset variables for the next member
     C                   EVAL      NewMbrLvl = ' '
     C                   EVAL      NewSrcInd = ' '
     C                   EVAL      ExtraFrom = ' '
     C                   EVAL      ExtraTo = ' '
     C                   EVAL      NewMbrLvl = ' '
     C                   EVAL      RNLAYR = ' '
     C                   EVAL      NewMbr = ' '
     C                   EVAL      NewSrc = ' '
     C                   EVAL      Suffix = ' '
     C                   EVAL      DBaseSfx = ' '
     C                   EVAL      ModPrefix = ' '
 
     C     READ2         TAG
      * Read driving file
     C                   READ      FROMLIB                              9090
 
      * Ignore skeleton sources and C headers
     C                   EVAL      FromLibPfx = %SUBST(MLFILE:1:2)
 
     C     FromLibPfx    IFEQ      'SK'                                         IF1
     C     FromLibPfx    OREQ      'H '
      *
      * Call the program to copy the member to the same name and source file
     C                   CALL      'UPC002031'
     C                   PARM                    MLNAME
     C                   PARM                    MLNAME
     C                   PARM                    MLFILE
     C                   PARM                    MLFILE
     C                   PARM                    FromLibr
     C                   PARM                    ToLibr
      *
     C                   GOTO      READ2
     C                   END
 
     C                   END
 
      * End of program
     C     ENDPGM        TAG
     C                   SETON                                        LR
 
     C                   RETURN
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = 'N'                              IF1
     C                   EVAL      Recursive = 'Y'
     C                   SETON                                        U7U8
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF                                                  ENDIF1
      *
     C                   ENDSR
      *****************************************************************
