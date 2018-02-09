     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Caps/Collars/Floors Read')
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Module                                       *
      *                                                               *
      *  IRCACFRED - Caps/Collars/Floors Read                         *
      *                                                               *
      *  Function:  This module reads forwards and backwards          *
      *             through the Caps/Collars/Floors Details File.     *
      *                                                               *
      *  Component of: IRCACFSIN - Caps/Collars/Floors IRS Screen     *
      *                Input                                          *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL028             Date 07Feb05               *
      *                 217684             Date 12May03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP056             Date 13Mar02               *
      *                 CIR008             Date 13Mar02               *
      *                 CAP055  *CREATE    Date 13Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  217684 - Authorisation User Malfunction (Recompile)          *
      *  CAP056 - Automatic Authorisation of Interface deals          *
      *           (Recompile)                                         *
      *  CIR008 - FRA/IRS Deals Authorisation                         *
      *  CAP055 - APIs for FRA/IRS Caps/Collars/Floors                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         End of File (DLCACFL0)                          *
      *    02         Start of File (DLCACFL0)                        *
      *    03         Test Numeric Indicator                          *
      *    04         Test Zone Indicator                             *
      *                                                               *
      *    LR         Last Record Indicator (program termination)     *
      *    U7 and U8  DB Error Processing Indicator                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrChckAut - Check For User Authority If Not Multi-branching  *
      *  SrValDlNo - Validate Deal Number Pointer                     *
      *  SrReadFwd - Read Forwards Through Deals File                 *
      *  SrReadBck - Read Backwards Through Deals File                *
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      * *PSSR - Error processing                                      *
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
 
     FDLCACFL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas DL All Caps/Collars/Floors Deals
 
      ** Caps/Collars/Floors deals for Authorisation                                          CIR008
     FDLCACFL2  IF   E           K DISK    INFSR(*PSSR)                                       CIR008
     F                                     RENAME(DEALSDGF:DLCACFD2)                          CIR008
                                                                                              CIR008
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
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
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             01     01
     D  StartOfFile           02     02
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Input Parameters
     D PRetCodeIn      S             10A
     D PActCode        S              1A
     D PDealNo         S              6A
     D PReadFwd        S              1A
     D PReadBck        S              1A
 
      ** Standing Data
     D PSingBrCd       S              3A
 
      ** Output Parameters
     D PErrorMsg       S              7A
     D PDealRead       S              6A
     D PDealType       S              2A
 
      ** Parameters for ZVACTBU/ZVACTU
     D PZAction        S              1A
     D PBrCde          S              3A
     D PError          S              1P 0
 
     D WTestZ          S              1A
     D WDealNoNum      S              6P 0
 
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
                                                                                              CIR008
     D CIR008          S              1A                                                      CIR008
 
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
 
      ** Initialize outputs
 
     C                   EVAL      PErrorMsg = *BLANK
     C                   EVAL      PDealRead = *BLANK
     C                   EVAL      PDealType = *BLANK
 
      ** Check for user authority to browse if not multi-branching
 
     C                   IF        PSingBrCd <> *BLANK
     C                   EXSR      SrChckAut
     C                   ENDIF
 
      ** Validate Deal Number (for pointer)
 
     C                   EXSR      SrValDlNo
 
      ** Read forwards
 
     C                   IF        PReadFwd = 'Y'
     C                   EXSR      SrReadFwd
     C                   ELSE
 
      ** Read backwards
 
     C                   IF        PReadBck = 'Y'
     C                   EXSR      SrReadBck
     C                   ENDIF
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrChckAut - Check For User Authority If Not Multi-branching  *
      *****************************************************************
     C     SrChckAut     BEGSR
 
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           PZAction
     C                   PARM      *ZERO         PError
 
      ** Return Error Message
 
     C                   IF        PError = 1
     C                   EVAL      PErrorMsg = 'FXM0292'
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrValDlNo - Validate Deal Number Pointer                     *
      *****************************************************************
     C     SrValDlNo     BEGSR
 
      **  Validate that the deal number is numeric or blank.
 
     C                   TESTN                   PDealNo              03
     C                   MOVE      PDealNo       WTestZ
     C                   TESTZ                   WTestZ                   04
 
     C                   IF        PDealNo = *BLANKS OR
     C                             *IN03 = *ON AND
     C                             *IN04 = *ON
     C                   MOVE      PDealNo       WDealNoNum
 
      ** Return error message
 
     C                   ELSE
     C                   EVAL      PErrorMsg = 'MMM0162'
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrReadFwd - Read Forwards Through Deals File                 *
      *****************************************************************
     C     SrReadFwd     BEGSR
 
      ** Position to current record on file
      ** File to be accessed depends on the Action code                                       CIR008
 
     C                   IF        PActCode = 'X' AND CIR008 = 'Y'                            CIR008
     C     WDealNoNum    SETGT     DLCACFL2                                                   CIR008
     C                   ELSE                                                                 CIR008
     C     WDealNoNum    SETGT     DLCACFL0
     C                   ENDIF                                                                CIR008
 
      ** Read until end of file or a valid record is found
 
     C                   DOU       EndOfFile = TRUE OR
     C                             PError = *ZERO
 
      ** Read from file
 
     C                   IF        PActCode = 'X' AND CIR008 = 'Y'                            CIR008
     C                   READ      DLCACFL2                               01                  CIR008
     C                   ELSE                                                                 CIR008
     C                   READ      DLCACFL0                               01
     C                   ENDIF                                                                CIR008
 
      ** If multi-branching, check if authorized to look at deal (based
      ** on branch) but if invalid continue searching for valid branch
 
     C                   IF        EndOfFile = FALSE AND PSingBrCd = *BLANK
 
     C                   EVAL      PBrCde = BRCA
 
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           PZAction
     C                   PARM                    PBrCde
     C                   PARM      *ZERO         PError
     C                   ENDIF
 
     C                   ENDDO
 
      ** If end of file was encountered, report this fact
 
     C                   IF        EndOfFile = TRUE
     C                   IF        PDealNo = *BLANKS
     C                   EVAL      PErrorMsg = 'MMM1006'
     C                   ELSE
     C                   EVAL      PErrorMsg = 'MMM1002'
     C                   ENDIF
 
      ** Else, return the deal number read
 
     C                   ELSE
     C                   MOVE      DLNO          PDealRead
     C                   MOVE      DTYP          PDealType
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrReadBck - Read Backwards Through Deals File                *
      *****************************************************************
     C     SrReadBck     BEGSR
 
      ** Position to current record on file
      ** File to be accessed depends on the Action code                                       CIR008
 
     C                   IF        PActCode = 'X' AND CIR008 = 'Y'                            CIR008
     C     WDealNoNum    SETLL     DLCACFL2                                                   CIR008
     C                   ELSE                                                                 CIR008
     C     WDealNoNum    SETLL     DLCACFL0
     C                   ENDIF                                                                CIR008
 
      ** Read until start of file or a valid record is found or an error
 
     C                   DOU       StartOfFile = True OR
     C                             PError = *ZERO
 
      ** Read from deals file
 
     C                   IF        PActCode = 'X' AND CIR008 = 'Y'                            CIR008
     C                   READP     DLCACFL2                               02                  CIR008
     C                   ELSE                                                                 CIR008
     C                   READP     DLCACFL0                               02
     C                   ENDIF                                                                CIR008
 
      ** If multi-branching, check if authorized to look at deal (based
      ** on branch) but if invalid continue searching for valid branch
 
     C                   IF        StartOfFile = FALSE AND PSingBrCd = *BLANK
 
     C                   EVAL      PBrCde = BRCA
 
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           PZAction
     C                   PARM                    PBrCde
     C                   PARM      *ZERO         PError
     C                   ENDIF
 
     C                   ENDDO
 
      ** If start of file was encountered, report this fact
 
     C                   IF        StartOfFile = TRUE
     C                   EVAL      PErrorMsg = 'MMM1003'
 
      ** Else, return the deal number read
 
     C                   ELSE
     C                   MOVE      DLNO          PDealRead
     C                   MOVE      DTYP          PDealType
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Input Parameters :
 
      ** Return Code
 
     C                   PARM                    PRetCodeIn
 
      ** Action Code
 
     C                   PARM                    PActCode
 
      ** Deal Number pointer
 
     C                   PARM                    PDealNo
 
      ** Read Forwards
 
     C                   PARM                    PReadFwd
 
      ** Read Backwards
 
     C                   PARM                    PReadBck
 
      ** Single Branch Code from SDBANKPD
 
     C                   PARM                    PSingBrCd
                                                                                              CIR008
      ** Switchable feature CIR008                                                            CIR008
                                                                                              CIR008
     C                   PARM                    CIR008                                       CIR008
 
      ** Output Parameters :
 
      ** Error meassage
 
     C                   PARM                    PErrorMsg
 
      ** Deal read
 
     C                   PARM                    PDealRead
 
      ** Deal Type
 
     C                   PARM                    PDealType
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
