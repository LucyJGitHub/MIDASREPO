     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE SECS - Validate field SNCD - LU Window#6')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading ILE Module                        *
      *                                                               *
      *  SEVSESNCD - Securities Details Extension Validation - Field  *
      *              SNCD - LU Window No 6                            *
      *                                                               *
      *  Function:  Validates the "Security National Code" Field      *
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
      *                 ULX610  *CREATE    Date 28Jan02               *
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
     D #6LXSNCD        S              3A
     D #6LXSECD        S             15A
     D ULX008          S              1A
     D WWSNCD          S              3A
 
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
 
      ** If ULX008 is off, default the input field to blank
      *
     C     ULX008        IFEQ      'N'
     C                   MOVEL     *BLANKS       #6LXSNCD
     C                   ENDIF
 
      ** Validate the input field
      *
 B1  C                   IF        ULX008 = 'Y'
 
 B2  C                   IF        #6LXSNCD = *BLANKS
 
 B3  C                   IF        #6LXSECD <> *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'LX61013'     #MsgID
     C                   MOVE      *BLANKS       #MsgData
     C                   GOTO      #ERROR
 E3  C                   ENDIF
 
 X2  C                   ELSE
 
 B3  C                   IF        #6LXSNCD <> 'WKN' AND #6LXSNCD <> 'AUT' AND
     C                             #6LXSNCD <> 'BEL' AND #6LXSNCD <> 'SIC' AND
     C                             #6LXSNCD <> 'RGA' AND #6LXSNCD <> 'GRE' AND
     C                             #6LXSNCD <> 'COM' AND #6LXSNCD <> 'SED' AND
     C                             #6LXSNCD <> 'REU' AND #6LXSNCD <> 'BLO' AND
     C                             #6LXSNCD <> 'TEL'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'LX61014'     #MsgID
     C                   MOVE      *BLANKS       #MsgData
     C                   GOTO      #ERROR
 E3  C                   ENDIF
 
 E2  C                   ENDIF
 
 E1  C                   ENDIF
 
      ** Input is valid
      *
     C                   MOVEL     #6LXSNCD      WWSNCD
 
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
     C                   PARM                    #6LXSNCD
     C                   PARM                    #6LXSECD
     C                   PARM                    ULX008
     C                   PARM                    WWSNCD
 
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
 
      *===============================================================*
**  CPY@
(C) Copyright Finastra International Limited 2002
