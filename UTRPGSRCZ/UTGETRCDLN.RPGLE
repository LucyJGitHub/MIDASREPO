     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas UT Get record length')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities module                                     *
      *                                                               *
      *  UTGETRCDLN - Get record length                               *
      *                                                               *
      *  Function: This module returns the record length of a file    *
      *            passed to it.  In the case of a physical file or   *
      *            logical file with only one record format, this     *
      *            will be the actual record length.  In the case of  *
      *            a multiformat logical file it will be the length   *
      *            of the longest record format.                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Last Amend No. CAP004             Date 23Oct98               *
      *  Prev Amend No. CAP002  *CREATE    Date 25Apr98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP004 - Clear the error structure used by the API before    *
      *           calling it, as it appears not to.                   *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
 
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
      ** The following /COPY lines include the structures necessary for the
      ** QDBRTVFD API.  The first is specific to that API; the second is
      ** the generic API error structure.
     D/COPY QSYSINC/QRPGLESRC,QDBRTVFD
     D/COPY QSYSINC/QRPGLESRC,QUSEC
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
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** Parameters
      ** ----------
      ** Record length
     D RecordLen       S              5P 0
 
      ** File name
     D FileName        S             10A
 
      ** File library
     D FileLib         S             10A
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** Parameters for the QDBRTVFD API
      ** -------------------------------
      ** Length of receiver variable
     D RcvrLen         S              9B 0 INZ(400)
 
      ** Returned qualified file name
     D QualFRtn        S             20A
 
      ** Format to return
     D FormatRtn       S              8A   INZ('FILD0100')
 
      ** Qualified file name passed to API
     D QualFSent       S             20A
 
      ** Record format name
     D RcdFmtName      S             10A   INZ('*FIRST')
 
      ** Whether or not overrides should be processed
     D Override        S              1A   INZ('1')
 
      ** System on which file resides
     D System          S             10A   INZ('*LCL')
 
      ** Format type (not actually used for the format we are requesting,
      ** but a required parameter)
     D FormatType      S             10A   INZ('*INT')
      **--------------------------------------------------------------------------------------------
 
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
 
      ** The QDBFRTVFD API will return the maximum record length in the
      ** field QDBFMXRL of data structure QDBQ25; these are defined in
      ** the include member QDBFRTVFD in QSYSINC/QRPGLESRC
 
      ** Clear the returned error structure before passing it, as the                         CAP004
      ** API appears not to clear out old error message IDs.                                  CAP004
     C                   CLEAR                   QUSEC                                        CAP004
                                                                                              CAP004
      ** Set up the 'Bytes provided' field for the API error structure
     C                   EVAL      QUSBPRV = 16
 
      ** Set up the qualified file name sent to the API
     C                   EVAL      QualFSent = FileName + FileLib
 
     C                   CALL      'QDBRTVFD'
      **                                      Receiver variable
     C                   PARM                    QDBQ25
      **                                      Length of receiver variable
     C                   PARM                    RcvrLen
      **                                      Qualified file name (returned)
     C                   PARM                    QualFRtn
      **                                      Format name for returned data
     C                   PARM                    FormatRtn
      **                                      Qualified file name (sent)
     C                   PARM                    QualFSent
      **                                      Record format
     C                   PARM                    RcdFmtName
      **                                      Override processing required?
     C                   PARM                    Override
      **                                      System on which file resides
     C                   PARM                    System
      **                                      Format type
     C                   PARM                    FormatType
      **                                      Error structure
     C                   PARM                    QUSEC
 
      ** If the API returned an error, indicate this to the caller
     C                   EVAL      ReturnCode = QUSEI
 
      ** Return the record length
     C                   EVAL      RecordLen = QDBFMXRL
 
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
      ** Parameters returned to caller
      ** -----------------------------
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Record length (5,0P)
     C                   PARM                    RecordLen
 
      ** Parameters received from caller
      ** -------------------------------
      ** File name (10A)
     C                   PARM                    FileName
      ** File library (10A)
     C                   PARM                    FileLib
 
 
 
 
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
(c) Misys International Banking Systems Ltd. 2001
