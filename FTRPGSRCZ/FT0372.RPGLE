     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      **********************************************************************
/*STD *  RPGBASEMOD                                                        *
/*EXI *  TEXT('Midas FT Retrieve transaction num from other msg')     *
      **********************************************************************
      *                                                                    *
      *  Midas - Message management Module                                 *
      *                                                                    *
      *  FT0372 - Retrieve a transaction number from other part of the     *
      *  same message                                                      *
      *  Function:  This program is used to identify the transaction       *
      *  number associated to a SWIFT SENDER / REFERENCE NUMBER.           *
      *  It is used in auto generation payment (FT0300) for messages       *
      *  with several parts like MT101 MT102.                              *
      *                                                                    *
      *  (c) Finastra International Limited 2001                      *
      *                                                                    *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 221761             Date 01Apr04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 30May00                    *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00                    *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 177674             Date 12May00                    *
      *                 CFT006  *CREATE    Date 26Apr00                    *
      *                                                                    *
      *--------------------------------------------------------------------*
      *                                                                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CFT032 - Account line in field 50k in MT103 (recompile)      *
      *  221761 - Recompiled due to change made in PF/FT101HPD.       *
      *  CFT009 - Addition of fields for FT fees and charges               *
      *           Recompile                                                *
      *  185107 - Mapping of details from swift message - Recompile        *
      *  177674 - Conform update processing of auto generation payment     *
      *                                                                    *
      **********************************************************************
      *                                                                    *
      * ID F  C  H  L    FUNCTION OF INDICATORS                            *
      *                                                                    *
      * 90 - General error indicator                                       *
      **********************************************************************
      * SUBROUTINE INDEX                                                   *
      *                                                                    *
      * *INZSR (for first call)                                            *
      * Init - Initialise                                                  *
      * RtvMT101 - Retrieve transaction number from sequence A of MT101    *
      * RtvMT102 - Retrieve transaction number from sequence A of MT102    *
      **********************************************************************
      * CCT header
     FFT102HL7  IF A E           K DISK    PREFIX(CH_)
      * RFT header
     FFT101HL4  IF A E           K DISK    PREFIX(RH_)
 
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
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
     D/COPY ZACPYSRC,ERR_XARRYS
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      * Data Structures used by Access Programs
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** WORKING VARIABLES
      ** -----------------
     D PayType         S                   LIKE(RH_PYTP)
     D PaySubTy        S                   LIKE(RH_PYST)
     D Branch          S                   LIKE(RH_BRCA)
     D OrigBrch        S                   LIKE(RH_ORBR)
     D BookCode        S                   LIKE(RH_BOKC)
     D ProfitCent      S                   LIKE(RH_PRFC)
      *
 
      ** DATA STRUCTURES
      ** ---------------
      *
 
      ** INDEXS
      ** ------
     D E               S              3P 0
     D IdxErr          S                   Like(E)
     D q               S              2  0
 
      ** ARRAYS
      ** ------
 
      ** Array of subroutines stack
     D SrStack         S             15    Dim(30)
 
      ** FLAGS
      ** -----
 
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
 
      **  Set up subroutine stack name
     C                   ADD       1             q
     C                   MOVEA     'Beg'         SrStack(q)
 
      ** Initialise
     C                   EXSR      Init
 
     C                   SELECT
 
      ** Retrieve transaction number for MT101
     C                   WHEN      MsgType = '101'
     C                   EXSR      RtvMT101
 
      ** Retrieve transaction number for MT102
     C                   WHEN      MsgType = '102'
     C                   EXSR      RtvMT102
     C                   ENDSL
 
     C                   Z-add     E             IdxErr
 
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       SrStack(q)
     C                   SUB       1             q
 
      ** Return
     C                   RETURN
 
      **********************************************************************
      /EJECT
      **********************************************************************
      *                                                                    *
      * *INZSR - Program Initialisation routine                            *
      *                                                                    *
      * Called by: Main processing                                         *
      *                                                                    *
      * Calls: None                                                        *
      *                                                                    *
      **********************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      ** INPUT
      ** Key list
     C                   PARM                    Key1            100
     C                   PARM                    Key2            100
     C                   PARM                    Key3            100
     C                   PARM                    Key4            100
     C                   PARM                    Key5            100
      ** Message type
     C                   PARM                    MsgType           3
      ** Payment type
     C                   PARM                    PayType
      ** Payment sub type
     C                   PARM                    PaySubTy
      ** Branch
     C                   PARM                    Branch
      ** Orig Branch
     C                   PARM                    OrigBrch
      ** Book Code
     C                   PARM                    BookCode
      ** Profit centre
     C                   PARM                    ProfitCent
      ** OUTPUT
      ** Transaction number
     C                   PARM                    TransNo          30
      ** Match header criteria
     C                   PARM                    MatchCrit         1
      ** Return code
      ** - *ERROR : serious error encountered
      ** - *NOT_FND : transaction not found
     C                   PARM                    RtnCode          10
      ** Number of errors
     C                   PARM                    IdxErr
      ** Errors arrays
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      *  Program, module and procedure names for database error processing.
      *  The following /COPY sets these values, and also defines LDA as
      *  an external data area
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      **********************************************************************
      *                                                                    *
      * Init - Initialise                                                  *
      *                                                                    *
      **********************************************************************
 
     C     Init          BEGSR
 
      **  Set up subroutine stack name
     C                   ADD       1             q
     C                   MOVEA     'Init    '    SrStack(q)
 
     C                   EVAL      FldNameArr = *BLANK
     C                   EVAL      MsgIdArr = *BLANK
     C                   EVAL      MsgDtaArr = *BLANK
     C                   EVAL      E = 0
     C                   EVAL      TransNo = *BLANK
     C                   EVAL      RtnCode = '*ERROR'
     C                   EVAL      MatchCrit  = 'N'
 
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       SrStack(q)
     C                   SUB       1             q
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      *                                                                    *
      * RtvMT101 - Retrieve transaction number from sequence A of MT101    *
      *                                                                    *
      **********************************************************************
 
     C     RtvMT101      BEGSR
 
      **  Set up subroutine stack name
     C                   ADD       1             q
     C                   MOVEA     'RtvMT101'    SrStack(q)
 
     C     KRftHdr1      KLIST
     C                   KFLD                    RH_STID
     C                   KFLD                    RH_SNDREF
 
     C                   EVAL      RH_STID = Key1
     C                   EVAL      RH_SNDREF = Key2
     C                   EVAL      RtnCode = '*NOT_FND'
     C     KRftHdr1      CHAIN     FT101HL4                           90
     C                   IF        *IN90 = '0'
     C                   EVAL      RtnCode = *BLANK
     C                   EVAL      TransNo = RH_RFTID
     C                   IF        RH_PYTP = PayType  AND
     C                             RH_PYST = PaySubTy  AND
     C                             RH_BRCA = Branch AND
     C                             RH_ORBR = OrigBrch AND
     C                             RH_BOKC = BookCode AND
     C                             RH_PRFC = ProfitCent
     C                   EVAL      MatchCrit = 'Y'
     C                   ELSE
     C                   ADD       1             E
     C                   EVAL      FldNameArr(E) = 'FT0372'
     C                   EVAL      MsgIdArr(E) = 'RFU0004'
     C                   IF        RH_PYTP <> PayType
     C                   ADD       1             E
     C                   EVAL      FldNameArr(E) = 'FT0372'
     C                   EVAL      MsgIdArr(E) = 'RFU0007'
     C                   ENDIF
     C                   IF        RH_PYST <> PaySubTy
     C                   ADD       1             E
     C                   EVAL      FldNameArr(E) = 'FT0372'
     C                   EVAL      MsgIdArr(E) = 'RFU0008'
     C                   ENDIF
     C                   IF        RH_BRCA <> Branch
     C                   ADD       1             E
     C                   EVAL      FldNameArr(E) = 'FT0372'
     C                   EVAL      MsgIdArr(E) = 'RFU0009'
     C                   ENDIF
     C                   IF        RH_ORBR <> OrigBrch
     C                   ADD       1             E
     C                   EVAL      FldNameArr(E) = 'FT0372'
     C                   EVAL      MsgIdArr(E) = 'RFU0010'
     C                   ENDIF
     C                   IF        RH_BOKC <> BookCode
     C                   ADD       1             E
     C                   EVAL      FldNameArr(E) = 'FT0372'
     C                   EVAL      MsgIdArr(E) = 'RFU0011'
     C                   ENDIF
     C                   IF        RH_PRFC <> ProfitCent
     C                   ADD       1             E
     C                   EVAL      FldNameArr(E) = 'FT0372'
     C                   EVAL      MsgIdArr(E) = 'RFU0012'
     C                   ENDIF
      **  Unwind subroutine stack name
     C                   ENDIF
     C                   ENDIF
 
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       SrStack(q)
     C                   SUB       1             q
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      *                                                                    *
      * RtvMT102 - Retrieve transaction number from sequence A of MT102    *
      *                                                                    *
      **********************************************************************
 
     C     RtvMT102      BEGSR
 
      **  Set up subroutine stack name
     C                   ADD       1             q
     C                   MOVEA     'RtvMT102'    SrStack(q)
 
     C     KCctHdr4      KLIST
     C                   KFLD                    CH_STID
     C                   KFLD                    CH_FILREF
 
     C                   EVAL      CH_STID = Key1
     C                   EVAL      CH_FILREF = Key2
     C                   EVAL      RtnCode = '*NOT_FND'
     C     KCctHdr4      CHAIN     FT102HL7                           90
     C                   IF        *IN90 = '0'
     C                   EVAL      RtnCode = *BLANK
     C                   EVAL      TransNo = CH_CCTID
     C                   IF        CH_CCTTYP = PayType  AND
     C                             CH_CCTTST = PaySubTy  AND
     C                             CH_BRCA = Branch AND
     C                             CH_ORBR = OrigBrch AND
     C                             CH_BOKC = BookCode AND
     C                             CH_PRFC = ProfitCent
     C                   EVAL      MatchCrit  = 'Y'
     C                   ELSE
     C                   ADD       1             E
     C                   EVAL      FldNameArr(E) = 'FT0372'
     C                   EVAL      MsgIdArr(E) = 'RFU0004'
     C                   IF        CH_CCTTYP <> PayType
     C                   ADD       1             E
     C                   EVAL      FldNameArr(E) = 'FT0372'
     C                   EVAL      MsgIdArr(E) = 'RFU0007'
     C                   ENDIF
     C                   IF        CH_CCTTST <> PaySubTy
     C                   ADD       1             E
     C                   EVAL      FldNameArr(E) = 'FT0372'
     C                   EVAL      MsgIdArr(E) = 'RFU0008'
     C                   ENDIF
     C                   IF        CH_BRCA <> Branch
     C                   ADD       1             E
     C                   EVAL      FldNameArr(E) = 'FT0372'
     C                   EVAL      MsgIdArr(E) = 'RFU0009'
     C                   ENDIF
     C                   IF        CH_ORBR <> OrigBrch
     C                   ADD       1             E
     C                   EVAL      FldNameArr(E) = 'FT0372'
     C                   EVAL      MsgIdArr(E) = 'RFU0010'
     C                   ENDIF
     C                   IF        CH_BOKC <> BookCode
     C                   ADD       1             E
     C                   EVAL      FldNameArr(E) = 'FT0372'
     C                   EVAL      MsgIdArr(E) = 'RFU0011'
     C                   ENDIF
     C                   IF        CH_PRFC <> ProfitCent
     C                   ADD       1             E
     C                   EVAL      FldNameArr(E) = 'FT0372'
     C                   EVAL      MsgIdArr(E) = 'RFU0012'
     C                   ENDIF
      **  Unwind subroutine stack name
     C                   ENDIF
     C                   ENDIF
 
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       SrStack(q)
     C                   SUB       1             q
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
 
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
