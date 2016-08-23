     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Generate list of non-display fields')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPCRTNDFLD - Create list of non-display fields               *
      *                                                               *
      *  Function: This module is used to generate a list of non-     *
      *            display fields for use in browsers.                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CGP001  *CREATE    Date 15Aug03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
      /EJECT
 
      ** File containing conditions under which fields are non-displayed
     FGPNDCONL0 IF   E           K DISK
 
      ** Output file containing list of non-displayed fields
     FGPDFFLDPD UF A E             DISK
     F                                     INFDS(InfDS)
 
      ** File containing switched on features
     FGPSARDPD  IT   F    6        DISK    INFSR(*PSSR)
 
      ** File containing switched on modules
     FGPMMIDL3  IT   F   10        DISK    INFSR(*PSSR)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout:
     D/COPY GPCPYSRCG,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY GPCPYSRCG,PSDS
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      ** The maximum size of the arrays
     D ArrayMax        C                   CONST(10)
     D ArrayMax2       C                   CONST(9999)
 
      ** Array of logical conditions
     D LogicArr        S                   Like(LogicDS)
     D                                     DIM(ArrayMax)
 
      ** Array of switched-on features
     D FeatArr         S              6A   DIM(ArrayMax2) PERRCD(1)
     D                                     FROMFILE(GPSARDPD)
 
      ** Array of switched on modules
     D ModArr          S             10A   DIM(ArrayMax2) PERRCD(1)
     D                                     FROMFILE(GPMMIDL3)
 
      * DS to save/retrieve records from GPNDCONL0 to/from array
     D LogicDS       E DS                  EXTNAME(GPNDCONPD)
     D SFName                 35     40
 
      * File information data structure
     D InfDS           DS
 
     D Ix              S              3  0
     D Iy              S              3  0
     D NDCount         S              3  0
     D NonDisplay      S              1
 
      **********************************************************************
      /SPACE 5
      **********************************************************************
      * Start of main processing
      **********************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode
      *
      * Key list for GPNDCONDL0
     C     CondKey       KLIST
     C                   KFLD                    NCAPDT
     C                   KFLD                    NCDFLD
     C                   KFLD                    NCSEQN
 
      **--------------------------------------------------------------
      ** Set the values of program, module and procedures names for database
      ** error processing.
     C                   EVAL      DBPgm  = PSProcPgm
     C                   EVAL      DBMod  = PSProcMod
     C                   EVAL      DBProc = PSProcName
      **--------------------------------------------------------------
 
      * Get first record
     C                   Read      GPNDCONL0                              80
     C                   Z-ADD     1             Iy
 
      * Read all available records
     C                   DoW       *IN80 = *Off
 
      * Save current condition to array
     C                   Eval      LogicArr(Iy) = LogicDS
 
      * If this is the end of the current set of conditions, check whether
      * they have been satisfied
     C                   If        NCLOGC <> '*AND'
     C                   EXSR      ChkLogic
     C                   Reset                   LogicArr
     C                   Z-ADD     0             Iy
     C                   EndIf
 
      * If the field is not to be displayed, write to outfile
     C                   If        NonDisplay = 'Y'
     C                   Eval      NDAPDT = NCAPDT
     C                   Eval      NDDFLD = NCDFLD
     C                   Eval      NDTYPE = NCTYPE
     C                   Monitor
     C                   Write     GPDFFLDD0                            99
 
      * Any error other than 'Duplicate record' = database error
      * (We want to drop any duplicates)
     C                   On-Error  1021
     C                   On-Error  *File
     C                   Exsr      *PSSR
     C                   EndMon
 
      * In case the first half of an '*OR' statement has proved correct,
      * we don't want to process any other statements for this field.
      * Position to the end of the current set of records.
     C                   Eval      NCSEQN = '999'
     C     CondKey       SetGT     GPNDCONL0
     C                   Eval      NonDisplay = ' '
     C                   EndIf
 
     C                   Read      GPNDCONL0                              80
     C                   Add       1             Iy
     C                   EndDo
 
     C                   SETON                                        LR
     C                   RETURN
      ****************************************************************
      /SPACE 5
      ****************************************************************
      * Check logic conditions
      ****************************************************************
     C     ChkLogic      BEGSR
 
     C                   Z-ADD     1             Ix
     C                   Z-ADD     0             NDCount
     C                   DO        ArrayMax
 
     C                   If        LogicArr(Ix) = *Blank
     C                   Leave
     C                   EndIf
 
     C                   EVAL      LogicDS = LogicArr(Ix)
 
      * Check for existence of feature or module as appropriate
      * Feature.....
     C                   If        NCMODF = 'S'
     C     SFName        LOOKUP    FeatArr                                20
 
      * Module......
     C                   Else
     C     NCMDFN        LOOKUP    ModArr                                 20
     C                   EndIf
 
      * Add 1 to the number of logical true counts depending on whether
      * the feature/module should be present or absent.
     C                   If        *IN20 = '1' and
     C                             NCMINS = 'Y'
     C                   Add       1             NDCount
     C                   EndIf
     C                   If        *IN20 = '0' and
     C                             NCMINS = 'N'
     C                   Add       1             NDCount
     C                   EndIf
 
     C                   Add       1             Ix
     C                   EndDo
 
      * If the number of nondisplay counts is the same as the number of
      * logical statements, then they have all been proved true.  Set
      * flag to write to outfile.
     C                   If        NDCount = Iy
     C                   Eval      NonDisplay = 'Y'
     C                   EndIf
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * *PSSR - Program exception error routine                       *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   EVAL       *INU7 = *ON
     C                   EVAL       *INU8 = *ON
     C                   EVAL       *INLR = *ON
      *
     C                   IF        RunBefore <> 'Y'
      *
     C                   EVAL      RunBefore = 'Y'
     C                   DUMP
      *
     C                   ENDIF
      *
     C                   EVAL      ReturnCode = '*Error'
     C                   RETURN
     C                   ENDSR
      ****************************************************************
