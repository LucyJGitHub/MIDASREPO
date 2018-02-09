     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Initialization Program for CER020')           *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000090 - Midas LE Initialisation program for CER020        *
      *                                                               *
      *  Function:  This module will initialise 'Initial Start Date', *
      *             'Final Maturity Date' fields on CLOANCL and       *
      *             'Previous and Penultimate Expiry Dates'on FCLTYFM *
      *                                                               *
      *  Component of: LEC00090                                       *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE141             Date 08Feb16               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG22611           Date 09Feb09               *
      *                 CER020  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           (Recompile)                                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG22611 - German Features initialization pgm error          *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus                                          *
      *                                                               *
      *****************************************************************
      *
      ** Midas LE Loans File
     FCLOAN     UF   E           K DISK    INCLUDE(CLOANCLF)
     F                                     INFSR(*PSSR)
     F**********                           COMMIT                                           BUG22611
      *
      ** Midas LE Loans File
     FFCLTY     UF   E           K DISK    INCLUDE(FCLTYFMF)
     F                                     INFSR(*PSSR)
     F**********                           COMMIT                                           BUG22611
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      *
      ** Data Structure for bank details
     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             01     01
     D  ErrOnFile             02     02
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
      *
     D WUpdateFlag     S              1A
      *
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the         ¦
      ** ¦ *inzsr is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN - Main processing                                        *
      *****************************************************************
      *
      ** Initialize Initial Start Date, Final Maturity Date
      *
     C                   EXSR      SrInitCLFlds
      *
      ** Initialize Previous and Penultimate Expiry Date
      *
     C                   EXSR      SrInitFCFlds
      *
      ** Program Termination
      *
     C                   EVAL      *INLR = True
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInitCLFlds - Initialize Initial Start Date, Final Maturity *
      *                 Date                                          *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: NONE                                                  *
      *                                                               *
      *****************************************************************
     C     SrInitCLFlds  BEGSR
      *
      ** Read Loans File
      *
     C     *LOVAL        SETLL     CLOANCLF
     C                   READ      CLOANCLF                               01
      *
     C                   DOW       EndOfFile = False
     C                   EVAL      WUpdateFlag = 'N'
      *
      ** Populate Initial Start Date
      *
     C                   IF        ISDT = *ZEROS
      *
     C                   EVAL      ISDT = VDAT
     C                   EVAL      WUpdateFlag = 'Y'
      *
     C                   ENDIF
      *
      ** Populate Final Maturity Date
      *
     C                   IF        FMDT = *ZEROS
      *
     C                   EVAL      FMDT = MDAT
     C                   EVAL      WUpdateFlag = 'Y'
      *
     C                   ENDIF
      *
      ** Update Loan Record
      *
     C                   IF        WUpdateFlag = 'Y'
     C                   UPDATE    CLOANCLF
     C                   ENDIF
      *
     C                   READ      CLOANCLF                               01
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrlnitFCFlds -  Populate Original Deal Number                *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrInitFCFlds  BEGSR
      *
      ** Read Loans File
      *
     C     *LOVAL        SETLL     FCLTYFMF
     C                   READ      FCLTYFMF                               01
      *
     C                   DOW       EndOfFile = False
     C                   EVAL      WUpdateFlag = 'N'
      *
      ** Populate Previous Expiry Date
      *
     C                   IF        PEXD = *ZEROS
      *
     C                   EVAL      PEXD = DTEX
     C                   EVAL      WUpdateFlag = 'Y'
      *
     C                   ENDIF
      *
      ** Populate Penultimate Expiry Date
      *
     C                   IF        PNXD = *ZEROS
      *
     C                   EVAL      PNXD = DTEX
     C                   EVAL      WUpdateFlag = 'Y'
      *
     C                   ENDIF
      *
      ** Update Loan Record
      *
     C                   IF        WUpdateFlag = 'Y'
     C                   UPDATE    FCLTYFMF
     C                   ENDIF
      *
     C                   READ      FCLTYFMF                               01
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
