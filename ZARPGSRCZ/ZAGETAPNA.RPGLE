     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Get Account Posting Next Available Num.')
      *****************************************************************
      *                                                               *
      *  Midas - Common Applications Module                           *
      *                                                               *
      *  ZAGETAPNA - Get Account Posting Next Available Number        *
      *                                                               *
      *  Function:  This module gets the next available number.       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CRE008  *CREATE    Data 19Feb02               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FGLAPNAPD  UF A E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
     C     I_XRFI        CHAIN     GLAPNAPD                           60
     C     *IN60         IFEQ      *ON
     C                   MOVE      I_XRFI        GLNARI
     C                   Z-ADD     1             O_XRFN
     C                   Z-ADD     O_XRFN        GLNARN
     C                   WRITE     GLAPNAPF
     C                   ELSE
     C     GLNARN        ADD       1             O_XRFN
     C                   Z-ADD     O_XRFN        GLNARN
     C                   UPDATE    GLAPNAPF
     C                   ENDIF
 
      * Return
     C                   RETURN
 
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      * Return code
      * Error Message
     C                   PARM                    X_RTCD
     C                   PARM                    X_ERMS
 
      * INPUTS
      * Ext.File Ref.ID
     C                   PARM                    I_XRFI            3
      * OUTPUTS
      * Ext.File Ref.No.
     C                   PARM                    O_XRFN           10 0
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
