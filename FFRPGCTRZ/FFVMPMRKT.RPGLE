     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Validate market centre')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFVMARKET - Midas FF Validate Market Centre                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CAP183  *Create    Date 05Jan06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  CAP183 - Conversion of Market Prices Input into modular      *
      *           structure to use APIs.                              *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Market centres
     FMARKT     IF   E           K DISK
     F                                     PREFIX(M_)
 
      ** Market control details
     FMKCTL     IF   E           K DISK
 
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and #MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
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
 
      ** +--- Named indicators -------------------------------------------+
      ** ¦                                                                ¦
      ** ¦ NOTE: this whole section can be deleted if no named indicators ¦
      ** ¦       are being used.  The names given are examples.           ¦
      ** ¦                                                                ¦
      ** ¦ Map variable names to indicators to allow use of names instead ¦
      ** ¦ of numbers; base the following data structure on a pointer to  ¦
      ** ¦ the indicator array.                                           ¦
     D Indicators      DS                  BASED(pIndicator)
      ** ¦                                                                ¦
     D  NoLiveRec             71     71
      ** ¦                                                                ¦
      ** ¦ Set the indicator array pointer                                ¦
     D pIndicator      S               *   INZ(%Addr(*In))
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Market control details
     D MarketCont    E DS                  EXTNAME(MKCTLD)
 
      ** Market centre details
     D MarketCent    E DS                  EXTNAME(MARKT) PREFIX(M_)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** -- Parameters not declared elsewhere ------------------------------------------------------
      ** Market centre
     D DDMRKT          S              2A
 
      ** Action code
     D DDACTN          S              1A
      ** -- End of parameters ----------------------------------------------------------------------
 
      ** -- Parameters for APCALCOBJ procedure -----------------------------------------------------
      ** Object name
     D Object          S             10A
 
      ** Library name (use library list)
     D Libl            S             10A   INZ('*LIBL')
 
      ** Object type (data area)
     D DtaAra          S              7A   INZ('*DTAARA')
 
      ** Lock state (shared, allow reads)
     D ShareRead       S              7A   INZ('*SHRRD')
 
      ** Member name (only applicable for files)
     D NoMember        S             10A
 
      ** Wait time
     D WaitTime        S              6A   INZ('5')
 
      ** Whether or not to deallocate the object
     D DeAlc           S              1A   INZ('Y')
 
      ** Return code
     D RCodeAlc        S              7A
      ** -- End of APCALCOBJ parameters ------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C     Start         TAG
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Reset error fields
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line resets the fields related to error
      ** handling: ReturnCode, ErrorFound, FldNamXArr, MsgIDXArr,
      ** MsgDtaXArr, XIdx.  It therefore requires FVAL_ARRAY and STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_RESET
      **--------------------------------------------------------------------------------------------
 
      *
      ** Market Centre
      *
     C     DDMRKT        CHAIN     MARKT                              71
 
      *
      ** A live Market record must exist
      *
     C                   IF        NoLiveRec = True OR M_RECI <> 'D'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'DDMRKT'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA2103'
     C                   ELSE
 
      *
      ** If no errors so far
      ** Attempt to allocate Market data area
      *
     C                   RESET                   RCodeAlc
     C                   EVAL      Object = DDMRKT
 
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Libl
     C                   PARM                    DtaAra
     C                   PARM                    ShareRead
     C                   PARM                    NoMember
     C                   PARM                    WaitTime
     C                   PARM                    DeAlc
     C                   PARM                    RCodeAlc
 
      *
      ** Market not available for input
      *
     C                   IF        RCodeAlc = 'NO_ALC' OR RCodeAlc = 'ERROR'
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'DDMRKT'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA2118'
     C                   ELSE
 
      *
      ** A live Market Control record must exist
      *
     C     DDMRKT        CHAIN     MKCTL                              71
 
     C                   IF        NoLiveRec = True OR M_RECI <> 'D'
 
      *
      ** Deallocate Market data area
      *
     C                   RESET                   RCodeAlc
 
     C                   CALLB     'APCDLCOBJ'
     C                   PARM                    Object
     C                   PARM                    Libl
     C                   PARM                    DtaAra
     C                   PARM                    ShareRead
     C                   PARM                    NoMember
     C                   PARM                    RCodeAlc
 
      *
      ** Database error; return using standard error message handling
      *
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'DDMRKT'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA2119'
     C                   EVAL      DBFILE = 'MKCTL'
     C                   EVAL      DBKEY = DDMRKT
     C                   EVAL      MsgDtaXArr(XIdx) = (PSProcPgm + PSProcMod
     C                             + PSProcName + DBFILE + DBKEY)
 
     C                   ELSE
 
      *
      ** Market Centre must be open for input for all action
      ** codes except Enquire where it may also be closed.
      *
     C     MKCI          IFNE      'I'
 
     C     MKCI          IFNE      'C'
     C     DDACTN        ORNE      'E'
 
      *
      ** Deallocate Market data area
      *
     C                   RESET                   RCodeAlc
 
     C                   CALLB     'APCDLCOBJ'
     C                   PARM                    Object
     C                   PARM                    Libl
     C                   PARM                    DtaAra
     C                   PARM                    ShareRead
     C                   PARM                    NoMember
     C                   PARM                    RCodeAlc
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'DDMRKT'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA2118'
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      **--------------------------------------------------------------------------------------------
      ** The return code is set in the following /COPY:
     C/COPY ZACPYSRC,SETRETCDE
      **--------------------------------------------------------------------------------------------
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
      ** Outputs from this procedure
      ** ---------------------------
      ** Return code (10A)
     C                   PARM                    ReturnCode
      ** Field name array (<ErrArrMax> x 10A)
     C                   PARM                    FldNamXArr
      ** Error message ID array (<ErrArrMax> x 7A)
     C                   PARM                    MsgIDXArr
      ** Error message data array (<ErrArrMax> x 45A)
     C                   PARM                    MsgDtaXArr
      ** Market control details (data structure)
     C                   PARM                    MarketCont
      ** Market centre details (data structure)
     C                   PARM                    MarketCent
 
      ** Inputs to this procedure
      ** ------------------------
      ** Market centre (2A, from transaction)
     C                   PARM                    DDMRKT
      ** Action code (1A, from transaction)
     C                   PARM                    DDACTN
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
