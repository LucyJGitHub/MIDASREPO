     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Dealing Fees amend checking')
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLDLFEAMD - Dealing Fees Amend Checking                      *
      *                                                               *
      *  Function:  This module compares the fields of an             *
      *             amended Fee against those currently on file.      *
      *             It checks whether all fields amended are          *
      *             amendable, and if not returns error messages to   *
      *             the calling process.                              *
      *             If can optionally reset fields wrongly amended.   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 13JAN06               *
      *  Prev Amend No. CAS009  *CREATE    Date 04May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Recompiled due to PF changes.                       *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
 
     D W_START         S              1A
     D W_AMORT         S              1A
     D W_ACCRU         S              1A
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** New Fee in Screen Format
     D NwFeScnFmt    E DS                  EXTNAME(DLDLFEPD)
 
      ** (Current) Fee in Screen Format
     D CrFeScnFmt    E DS                  EXTNAME(DLDLFEPD)
     D                                     PREFIX(W_)
      ** Valid Fee layout
     D ValidDlfe     E DS                  EXTNAME(DLVDLFEPD)
     D                                     PREFIX(V_)
 
      ** Flags to indicate whether transaction fields are valid
     D OkDLFE        E DS                  EXTNAME(DLEDLFEPD)
 
      ** EXTERNAL DS FOR BANK DETAILS
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
     D PRTCD           S              7
     D POPTN           S              7
     D AmendOk         S              1
     D ResetErrs       S              1
 
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
 
      **  Compare fields with amended values.
 
     C                   EXSR      COMPFLDS
      *
      *  If any errors were found:
      *    Set Amendments OK Indicator to 'N'
      *
     C     Idx           IFGT      0
     C                   EVAL      AmendOK = 'N'
     C                   ELSE
     C                   EVAL      AmendOK = 'Y'
     C                   ENDIF
 
      ** If any errors were found:
      ** - and reset of fields in error required, do this
 
     C     Idx           IFGT      0
     C     ResetErrs     ANDEQ     'Y'
     C                   EXSR      RESETFLDS
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * COMPFLDS  - Compare certain fields on the current Fee         *
      *             with those amended.                               *
      *****************************************************************
     C     COMPFLDS      BEGSR
     C                   EVAL      W_START = 'Y'
     C                   EVAL      W_AMORT = ' '
 
      ** Compare Deal number
     C     DDDLNO        IFNE      W_DDDLNO
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDLNO'
     C                   EVAL      OKDLNO = 'N'
     C                   ENDIF
 
      ** Compare Fee Sequence
     C     DDFSEQ        IFNE      W_DDFSEQ
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFSEQ'
     C                   EVAL      OKFSEQ = 'N'
     C                   ENDIF
 
      ** Compare Customer Number
     C     DDCUST        IFNE      W_DDCUST
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCUST'
     C                   EVAL      OKCUST = 'N'
     C                   ENDIF
 
      ** Check that start date has not yet been reached
     C     V_DLPSTD      IFLT      BJRDNB
     C     V_DLORED      ANDEQ     BJRDNB
     C     V_DLPSTD      ORGE      BJRDNB
     C                   EVAL      W_START = 'N'
     C                   ENDIF
 
      ** Check that Payment On Indicator is 'S'
     C                   IF        V_DLPYON = 'S'
     C                   EVAL      W_AMORT = 'Y'
     C                   ENDIF
 
      ** Check that Payment On Indicator is 'N' or 'E'
     C                   IF        V_DLPYON = 'N' OR V_DLPYON = 'E'
     C                   EVAL      W_ACCRU = 'Y'
     C                   ENDIF
 
     C                   IF        (W_START = 'Y' AND W_AMORT = 'Y')
     C                             OR (W_START = 'Y' AND W_ACCRU = 'Y')
 
      ** Compare Fee Code
     C     DDFCOD        IFNE      W_DDFCOD
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFCOD'
     C                   EVAL      OKFCOD = 'N'
     C                   ENDIF
 
      ** Compare Fee Currency
     C     DDFCCY        IFNE      W_DDFCCY
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFCCY'
     C                   EVAL      OKFCCY = 'N'
     C                   ENDIF
 
     C                   IF        W_AMORT = 'Y'
      ** Compare Fee Amount
     C     DDFAMT        IFNE      W_DDFAMT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFAMT'
     C                   EVAL      OKFAMT = 'N'
     C                   ENDIF
 
      ** Compare Fee Sign
     C     DDFSGN        IFNE      W_DDFSGN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFSGN'
     C                   EVAL      OKFSGN = 'N'
     C                   ENDIF
     C                   ENDIF
 
      ** Compare Start Date
     C     DDSDAT        IFNE      W_DDSDAT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSDAT'
     C                   EVAL      OKSDAT = 'N'
     C                   ENDIF
 
      ** Compare Fee Payment On
     C     DDFIND        IFNE      W_DDFIND
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFIND'
     C                   EVAL      OKFIND = 'N'
     C                   ENDIF
 
     C                   ENDIF
 
      ** Compare End Date
     C     DDEDAT        IFNE      W_DDEDAT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDEDAT'
     C                   EVAL      OKEDAT = 'N'
     C                   ENDIF
 
      ** If Error set-up error message & write details to Invalid file
     C     Idx           IFNE      0
     C                   EVAL      MsgIDArr(Idx)   = 'DLF0006'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RESETFLDS - Reset fields in Error                             *
      *****************************************************************
     C     RESETFLDS     BEGSR
 
      ** Reset fields in error to 'current' values
 
      ** Deal Number
     C     OKDLNO        IFEQ      'N'
     C                   EVAL      DDDLNO = W_DDDLNO
     C                   ENDIF
 
      ** Fee Sequence
     C     OKFSEQ        IFEQ      'N'
     C                   EVAL      DDFSEQ = W_DDFSEQ
     C                   ENDIF
 
      ** Customer Number
     C     OKCUST        IFEQ      'N'
     C                   EVAL      DDCUST = W_DDCUST
     C                   ENDIF
 
      ** Fee Code
     C     OKFCOD        IFEQ      'N'
     C                   EVAL      DDFCOD = W_DDFCOD
     C                   ENDIF
 
      ** Fee currency
     C     OKFCCY        IFEQ      'N'
     C                   EVAL      DDFCCY = W_DDFCCY
     C                   ENDIF
 
      ** Fee amount
     C     OKFAMT        IFEQ      'N'
     C                   EVAL      DDFAMT = W_DDFAMT
     C                   ENDIF
 
      ** Fee sign
     C     OKFSGN        IFEQ      'N'
     C                   EVAL      DDFSGN = W_DDFSGN
     C                   ENDIF
 
      ** Fee Start Date
     C     OKSDAT        IFEQ      'N'
     C                   EVAL      DDSDAT = W_DDSDAT
     C                   ENDIF
 
      ** Fee period end
     C     OKEDAT        IFEQ      'N'
     C                   EVAL      DDEDAT = W_DDEDAT
     C                   ENDIF
 
      ** Payment on
     C     OKFIND        IFEQ      'N'
     C                   EVAL      DDFIND = W_DDFIND
     C                   ENDIF
 
      ** Next payment date
     C     OKNPYD        IFEQ      'N'
     C                   EVAL      DDNPYD = W_DDNPYD
     C                   ENDIF
 
      ** Frequency
     C     OKFREQ        IFEQ      'N'
     C                   EVAL      DDFREQ = W_DDFREQ
     C                   ENDIF
 
      ** Day in month
     C     OKPDAY        IFEQ      'N'
     C                   EVAL      DDPDAY = W_DDPDAY
     C                   ENDIF
 
     C                   ENDSR
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
 
     C     *ENTRY        PLIST
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** New Fee in Screen Format
     C                   PARM                    NwFeScnFmt
 
      ** Current Fee in Screen Format
     C                   PARM                    CrFeScnFmt
 
      ** Fee in file format
     C                   PARM                    ValidDlfe
 
      ** OUTPUTS
 
      ** Field OK flags (DS) from/to caller
     C                   PARM                    OkDlfe
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      ** Amendments OK
     C                   PARM                    AmendOk
 
      ** Reset of Fields in Error Required (Y/N)
     C                   PARM                    ResetErrs
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'DLDLFEAMD'
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C     PRTCD         IFNE      *BLANK
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 900
     C                   EXSR      *PSSR
     C                   ENDIF
 
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
(c) Misys International Banking Systems Ltd. 2004
