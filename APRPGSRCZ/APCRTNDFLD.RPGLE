     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas AP Generate list of non-display fields')
      *****************************************************************
      *                                                               *
      *  Midas - Application Programming Interfaces module            *
      *                                                               *
      *  APCRTNDFLD - Create list of non-display fields               *
      *                                                               *
      *  Function: This module is used to generate a list of non-     *
      *            display fields for us in browsers.                 *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046657           Date 12Feb18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAP084  *CREATE    Date 26Jul03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046657 - Possibility to change non-amendable fields to be  *
      *             amendable and able to complete transaction        *
      *             (Recompile).                                      *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP084 - Synchronous calling of APIs                         *
      *                                                               *
      *****************************************************************
      /EJECT
 
      ** File containing conditions under which fields are non-displayed
     FAPNDCONL0 IF   E           K DISK
 
      ** Output file containing list of non-displayed fields
     FAPDFFLDPD UF A E             DISK
     F                                     INFDS(InfDS)
 
      ** File containing switched on features
     FSCSARDPD  IT   F    6        DISK    INFSR(*PSSR)
 
      ** File containing switched on modules
     FSDMMIDL3  IT   F   10        DISK    INFSR(*PSSR)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
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
     D                                     FROMFILE(SCSARDPD)
 
      ** Array of switched on modules
     D ModArr          S             10A   DIM(ArrayMax2) PERRCD(1)
     D                                     FROMFILE(SDMMIDL3)
 
      * DS to save/retrieve records from APNDCONL0 to/from array
     D LogicDS       E DS                  EXTNAME(APNDCONPD)
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
      * Key list for APNDCONDL0
     C     CondKey       KLIST
     C                   KFLD                    NCAPDT
     C                   KFLD                    NCDFLD
     C                   KFLD                    NCSEQN
 
      **--------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------
 
      * Get first record
     C                   Read      APNDCONL0                              80
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
     C                   Write     APDFFLDD0                            99
 
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
     C     CondKey       SetGT     APNDCONL0
     C                   Eval      NonDisplay = ' '
     C                   EndIf
 
     C                   Read      APNDCONL0                              80
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
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   EVAL      ReturnCode = '*Error'
     C                   RETURN
     C                   ENDSR
      ****************************************************************
**  CPY@
(c) Finastra International Limited 2003
