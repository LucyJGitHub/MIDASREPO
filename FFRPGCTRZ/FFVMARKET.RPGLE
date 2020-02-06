     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Validate market centre')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFVMARKET - Validate market centre for exchange-traded       *
      *              futures and options                              *
      *                                                               *
      *  Function:  This module checks that an entered market centre  *
      *             is a legitimate one defined to the system.        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD000091           Date 07May13               *
      *                 CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP004  *CREATE    Date 01Jun98               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  CAP004 - Conversion of Midas inputs to APIs                  *
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
 
     D MarketCont    E DS                  EXTNAME(MKCTLD)
      ** Market control details
 
     D MarketCent    E DS                  EXTNAME(MARKT) PREFIX(M_)
      ** Market centre details
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **--- Parameters not declared elsewhere ------------------------------------------------------
      ** Market centre
     D SMRKT           S              2A
 
      ** Action code
     D SACTN           S              1A
      **--- End of parameters ----------------------------------------------------------------------
 
      **--- Parameters for APCALCOBJ procedure -----------------------------------------------------
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
      **--- End of APCALCOBJ parameters ------------------------------------------------------------
 
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
                                                                                            MD000091
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
 
      **   Market Centre
      **   ¯¯¯¯¯¯¯¯¯¯¯¯¯
     C     SMRKT         CHAIN     MARKT                              71
 
      **   - a live Market record must exist
     C                   IF        NoLiveRec = True OR M_RECI <> 'D'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SMRKT'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0327'
     C                   ELSE
 
      **   If no errors so far
      **   - attempt to allocate Market data area
     C                   RESET                   RCodeAlc
     C                   EVAL      Object = SMRKT
 
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Libl
     C                   PARM                    DtaAra
     C                   PARM                    ShareRead
     C                   PARM                    NoMember
     C                   PARM                    WaitTime
     C                   PARM                    DeAlc
     C                   PARM                    RCodeAlc
 
 
      **   - Market not available for input
     C                   IF        RCodeAlc = 'NO_ALC' OR RCodeAlc = 'ERROR'
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SMRKT'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0328'
     C                   ELSE
 
      **   - a live Market Control record must exist
     C     SMRKT         CHAIN     MKCTL                              71
 
     C                   IF        NoLiveRec = True OR M_RECI <> 'D'
 
      **   - deallocate Market data area
     C                   RESET                   RCodeAlc
 
     C                   CALLB     'APCDLCOBJ'
     C                   PARM                    Object
     C                   PARM                    Libl
     C                   PARM                    DtaAra
     C                   PARM                    ShareRead
     C                   PARM                    NoMember
     C                   PARM                    RCodeAlc
 
      **   - database error; return using standard error message handling
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SMRKT'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0002'
     C                   EVAL      DBFILE = 'MKCTL'
     C                   EVAL      DBKEY = SMRKT
     C**********         EVAL      MsgDtaXArr(XIdx) = (PSProcPgm + PSProcMod                MD000091
     C**********                   + PSProcName + DBFILE + DBKEY)                           MD000091
     C                   EVAL      BLen = %Len(%Trim(PSProcPgm))                            MD000091
     C                   EVAL      MsgDtaXArr(XIdx) = LenStr +%TRIM(PSProcPgm)              MD000091
     C                   EVAL      BLen = %Len(%Trim(PSProcMod))                            MD000091
     C                   EVAL      MsgDtaXArr(XIdx) = %TRIM(MsgDtaXArr(XIdx))               MD000091
     C                                            + LenStr +%TRIM(PSProcMod)                MD000091
     C                   EVAL      BLen = %Len(%Trim(PSProcName))                           MD000091
     C                   EVAL      MsgDtaXArr(XIdx) = %TRIM(MsgDtaXArr(XIdx))               MD000091
     C                                            + LenStr +%TRIM(PSProcName)               MD000091
     C                   EVAL      BLen = %Len(%Trim(DBFILE))                               MD000091
     C                   EVAL      MsgDtaXArr(XIdx) = %TRIM(MsgDtaXArr(XIdx))               MD000091
     C                                            + LenStr +%TRIM(DBFILE)                   MD000091
     C                   EVAL      BLen = %Len(%Trim(DBKEY))                                MD000091
     C                   EVAL      MsgDtaXArr(XIdx) = %TRIM(MsgDtaXArr(XIdx))               MD000091
     C                                            + LenStr +%TRIM(DBKEY)                    MD000091
 
     C                   ELSE
 
      **   - Market Centre must be open for input for all action
      **   codes except Enquire where it may also be closed.
     C     MKCI          IFNE      'I'
 
     C     MKCI          IFNE      'C'
     C     SACTN         ORNE      'E'
 
      **   - deallocate Market data area
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
     C                   EVAL      FldNamXArr(XIdx) = 'SMRKT'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0328'
 
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
     C                   PARM                    SMRKT
      ** Action code (1A, from transaction)
     C                   PARM                    SACTN
 
 
 
 
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
(c) Finastra International Limited 2001
