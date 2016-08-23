     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC Data Replication Configurator Read')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SCRPCNRED - Data Replication Configurator Read               *
      *                                                               *
      *  Function:  This module will read forwards and backwards      *
      *             through the Data Replication Details File         *
      *                                                               *
      *  Component of: SCRPCNSIN - Data Replication Configurator      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Last Amend No. CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         End of File for SCFDTLL1                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRInit  - Initialise Fields                                  *
      *  SRRdBck - Reads Backward thru Data Replication File Details  *
      *  SRRdFwd - Reads Forward  thru Data Replication File Details  *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Data Replication File Definition Retrieval Index
     FSCFDTLL1  IF   E           K DISK    INFSR(*PSSR) USROPN
 
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
      **    False      logical = *off (for indicator processing)
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
 
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
 
     D/COPY ZACPYSRC,ERR_ARRAYS
 
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
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters
     D PRdFwd          S              1
     D PRdBck          S              1
     D PErrMsg         S              7
     D PRdPhyF         S             10
     D PPhyFile        S             10
 
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Initialize Output
 
     C                   EXSR      SRInit
 
      ** Read Forward
 
     C                   IF        PRdFwd = 'Y'
     C                   EXSR      SRRdFwd
     C                   ELSE
 
      ** Read Backwards
 
     C                   IF        PRdBck = 'Y'
     C                   EXSR      SRRdBck
     C                   ENDIF
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInit - Initialise Fields                                    *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Call : None                                                   *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
 
     C                   EVAL      PErrMsg = *Blanks
     C                   EVAL      PRdPhyF = *Blanks
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRdFwd - Read Forwards thru Data Replication File Details    *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
     C     SRRdFwd       BEGSR
 
     C                   OPEN      SCFDTLL1
 
      ** Position to current record on file
 
     C     PPhyFile      SETGT     SCFDTLL1
 
      **  Read the file.
 
     C                   READ      SCFDTLL1                               01
 
      ** If end of file was encountered, report this fact
 
     C                   IF        *IN01 = *On
     C                   IF        PPhyFile = *Blanks
     C                   EVAL      PErrMsg = 'DRC0002'
     C                   ELSE
     C                   EVAL      PErrMsg = 'DRC0003'
     C                   ENDIF
 
      ** Else, return the deal number read
 
     C                   ELSE
     C                   EVAL      PRdPhyF = FDPHYF
     C                   ENDIF
 
     C                   CLOSE     SCFDTLL1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRdBck - Read Backwards Thru Data Replicaiton File Details   *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
     C     SRRdBck       BEGSR
 
     C                   OPEN      SCFDTLL1
 
      ** Position to current record on file
 
     C     PPhyFile      SETLL     SCFDTLL1
 
      ** Read the file
 
     C                   READP     SCFDTLL1                               01
 
      ** If start of file was encountered, report this fact
 
     C                   IF        *IN01 = *On
     C                   EVAL      PErrMsg = 'DRC0004'
 
      ** Else, return the deal number read
 
     C                   ELSE
     C                   EVAL      PRdPhyF = FDPHYF
     C                   ENDIF
 
     C                   CLOSE     SCFDTLL1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Physical File Name Pointer
 
     C                   PARM                    PPhyFile
 
      ** Read Forward Indicator
      ** Read Backward Indicator
 
     C                   PARM                    PRdFwd
     C                   PARM                    PRdBck
 
      ** Output Paramters
      ** Error Message
      ** Physical File Name Read
 
     C                   PARM                    PErrMsg
     C                   PARM                    PRdPhyF
 
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
     C/COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
