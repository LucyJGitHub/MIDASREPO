     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Validate Business Entity Identifier')
      *****************************************************************
      *                                                               *
      *  Midas - Access Object Module                                 *
      *                                                               *
      *  AOBEISR0 - Validate Business Entity Identifier               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01.01 ----------------------------------------*
      *  Last Amend No. CSW202  *CREATE    Date 20May02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW202 - SWIFT 2002 Standards Update                         *
      *                                                               *
      *****************************************************************
 
      ** Business Entity Identifier file
     FMEBEISL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** Business Entity Identifier file
     D MEBEIS        E DS                  EXTNAME(MEBEISPD)
 
      ** External Data structure to hold the outgoing record format
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PRetCode        S              7A
     D POption         S              7A
     D PBusType        S              4A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Access Option *SAME input
 
     C                   IF        PRetCode = '*SAME  '
     C                   IF        *IN01 = *OFF
     C                   EVAL      *IN91 = *ON
     C                   ENDIF
     C                   GOTO      TSkip
     C                   ENDIF
 
      ** Initialise Error Indicators
 
     C                   MOVEA     '0000000000'  *IN(90)
 
      ** First Call - Open File
 
     C                   IF        *IN01 = *OFF
     C                   EVAL      *IN01 = *ON
     C                   OPEN      MEBEISL1                             91
     C                   IF        *IN91 = *ON
     C                   GOTO      TSkip
     C                   ENDIF
     C                   ENDIF
 
      ** Last call - close file and terminate program
 
     C                   IF        POption = '*FREE  '
     C                   CLOSE     MEBEISL1                             92
     C                   IF        *IN92 = *ON
     C                   GOTO      TSkip
     C                   ENDIF
     C                   GOTO      TSkip
     C                   ENDIF
 
      ** Caller request for first record
 
     C                   IF        POption = '*FIRST '
     C     *LOVAL        SETLL     MEBEISL1                           9390
     C                   IF        *IN90 = *ON OR *IN93 = *ON
     C                   GOTO      TSkip
     C                   ENDIF
     C                   EVAL      POption = '*NEXT  '
     C                   ENDIF
 
      ** Caller request for next record
 
     C                   IF        POption = '*NEXT  '
     C                   READ      MEBEISL1                             9094
     C                   IF        *IN90 = *ON OR *IN94 = *ON
     C                   GOTO      TSkip
     C                   ENDIF
     C                   ENDIF
 
      ** Caller request for last record
 
     C                   IF        POption = '*LAST  '
     C     *HIVAL        SETGT     MEBEISL1                             90
     C                   IF        *IN90 = *ON
     C                   GOTO      TSkip
     C                   ENDIF
     C                   EVAL      POption = '*PREV  '
     C                   ENDIF
 
      ** Caller request for previous record
 
     C                   IF        POption = '*PREV  '
     C                   READP     MEBEISL1                             9094
     C                   IF        *IN90 = *ON OR *IN94 = *ON
     C                   GOTO      TSkip
     C                   ENDIF
     C                   ENDIF
 
      ** Caller requests record indicated by key
 
     C                   IF        POption = '*KEY   ' OR POption = '*VERIFY'
     C                   IF        PBusType = *BLANKS
     C                   EVAL      *IN97 = *ON
     C                   GOTO      TSkip
     C                   ENDIF
     C     PBusType      CHAIN     MEBEISL1                           9590
     C                   IF        *IN90 = *ON OR *IN95 = *ON
     C                   GOTO      TSkip
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        POption <> '*KEY   ' AND
     C                             POption <> '*NEXT  ' AND
     C                             POption <> '*PREV  ' AND
     C                             POption <> '*VERIFY' AND
     C                             POption <> '*FREE  '
     C                   EVAL      *IN96 = *ON
     C                   ENDIF
 
     C     TSKip         TAG
 
     C                   EVAL      PRetCode = *BLANKS
 
     C                   SELECT
     C                   WHEN      *IN90 = *ON
     C                   EVAL      PRetCode = '*ERROR '
 
     C                   WHEN      *IN91 = *ON
     C                   EVAL      PRetCode = '*OPEN  '
 
     C                   WHEN      *IN92 = *ON
     C                   EVAL      PRetCode = '*CLOSE '
 
     C                   WHEN      *IN93 = *ON
     C                   EVAL      PRetCode = '*EMPTY '
 
     C                   WHEN      *IN94 = *ON
     C                   EVAL      PRetCode = '*EOF   '
 
     C                   WHEN      *IN95 = *ON
     C                   EVAL      PRetCode = '*NRF   '
 
     C                   WHEN      *IN96 = *ON
     C                   EVAL      PRetCode = '*OPTION'
 
     C                   WHEN      *IN97 = *ON
     C                   EVAL      PRetCode = '*NOSEL '
 
     C                   WHEN      *IN98 = *ON
     C                   EVAL      PRetCode = '*CALL  '
     C                   ENDSL
 
     C                   IF        POption <> '*FREE  ' AND
     C                             POption <> '*VERIFY' AND
     C                             POption <> '*OPTION'
     C                   EVAL      DSFDY = MEBEIS
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
 
      ** Inputs
 
     C                   Parm                    PRetCode
     C                   Parm                    POption
     C                   Parm                    PBusType
     C                   Parm                    DSFDY
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
