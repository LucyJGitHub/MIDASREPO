     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE SECS - Validate field SECT - LU Window#6')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading ILE Module                        *
      *                                                               *
      *  SEVSESECT - Securities Details Extension Validation - Field  *
      *              SECT - LU Window No 6                            *
      *                                                               *
      *  Function:  Validates the "Security Type" Field               *
      *             If it is valid the 10A return code will be blank, *
      *             else it will contain 'Error'                      *
      *                                                               *
      *  (C) Copyright Finastra International Limited 2002            *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CER001             Date 25Apr05               *
      *                 ULX610  *CREATE    Date 25Jan02               *
      *                                                               *
      *   ------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  ULX610 - SE Securities Details API for Lux Country           *
      *           ULX008 - Commissariat aux Bourses                   *
      *           ULX004 - IML                                        *
      *           ULU001 - IML Reporting                              *
      *                                                               *
      *===============================================================*
 
      *===============================================================*
      ** Automatically included D-specs
      ** ==============================
      *
 
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                    error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes definitions for the above
      ** fields as #ProcPgm, #ProcMod and #ProcName.  They are based
      ** on the corresponding fields in the PSDS /COPY member, so that
      ** member must be included where this one is used.
      *
     D/COPY ZACPYSRC,PROCPARMS
 
      ** The following /COPY line includes the definitions for error &
      ** warning message arrays.
      *
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** Manually included D-specs
      ** =========================
      *
 
      ** Named constants
      ** ---------------
      *
 
      ** Arrays and Data Structures
      ** --------------------------
      *
 
      ** Second DS for access programs, long data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Declared variables
      ** ------------------
      *
 
      ** Define *entry parameters
      *
     D #6LXSECT        S              2S 0
     D WWSECT          S              2S 0
 
      ** Define parameters for called modules
      *
 
      *===============================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G      *
      *===============================================================*
 
      ** Initial processing is performed automatically: the *INZSR is
      ** executed at program activation.
      *
 
      ** Reset the error flag to prevent problems on subsequent calls
      *
     C                   RESET                   ErrorFound
 
      ** Validate the input field
      *
     C                   IF        #6LXSECT <> 00 AND #6LXSECT <> 11 AND
     C                             #6LXSECT <> 12 AND #6LXSECT <> 13 AND
     C                             #6LXSECT <> 21 AND #6LXSECT <> 22 AND
     C                             #6LXSECT <> 31 AND #6LXSECT <> 32 AND
     C                             #6LXSECT <> 41 AND #6LXSECT <> 42
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'LX61011'     #MsgID
     C                   MOVE      *BLANKS       #MsgData
     C                   GOTO      #ERROR
     C                   ENDIF
 
      ** Input is valid
      *
     C                   Z-ADD     #6LXSECT      WWSECT
 
      ** If an error was found, set the return code appropriately
      *
     C     #ERROR        TAG
      *    ----------    ------
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   RETURN
 
      *===============================================================*
      *                    S  U  B  R  O  U  T  I  N  E  S            *
      *===============================================================*
 
      *===============================================================*
      * *INZSR    : Program initialisation                            *
      *---------------------------------------------------------------*
     C     *INZSR        BEGSR
      *    ----------    ------
      ** Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    #MsgID
     C                   PARM                    #MsgData
     C                   PARM                    #6LXSECT
     C                   PARM                    WWSECT
 
      ** Set the program, module and procedure names for database
      ** error processing.  Note: this /COPY requires that the PSDS
      ** /COPY is also included.
      *
     C                   EVAL      DBPgm  = PSProcPgm
     C                   EVAL      DBMod  = PSProcMod
     C                   EVAL      DBProc = PSProcName
      *    ----------    ------
     C                   ENDSR
 
      *===============================================================*
      *  Program, module and procedure names for database error       *
      *---------------------------------------------------------------*
     C/COPY ZACPYSRC,PSSR_ILE
 
      *========================================================================*
**  CPY@
(C) Copyright Finastra International Limited 2002
