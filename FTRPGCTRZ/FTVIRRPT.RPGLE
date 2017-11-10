     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate IP regulatory reporting')            *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVIRRPT - Validate IP Regulatory Reporting                  *
      *                                                               *
      *  Function:  This module validates Regulatory Reporting.       *
      *             This is a component of FTIPAYCTL, FTIPAYRPR,      *
      *             FTIPAYSIN, and service program for level 2        *
      *             validation modules.                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CFT162             Date 08Sep17               *
      *  Prev Amend No. AR920077           Date 13Mar15               *
      *                 MD000091           Date 06May13               *
      *                 CFT120             Date 28Sep12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BUG3644            Date 12Jul04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014  *CREATE    Date 25May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT162 - MT900 and MT910 Message Generation (Recompile)      *
      *  AR920077 - Correct :77B: validation. (Child: AR922613)       *
      *           - Applied for AR981901                              *
      *  MD000091 - Event Codes Substitution                          *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG3644 - Serious Error in Collateralised Lending (Recompile)*
      *  CFT009 - Funds Transfer Fees and Charges (recompile)         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

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
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of dbase error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** The following /COPY line includes the definitions for error
      ** and warning message arrays.
     D/COPY ZACPYSRC,ERR_XARRYS

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT                                                          *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      /COPY FTCPYSRC,SFTVALCSLE

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Incoming Payments Lvl 2 Scrn 2 file 2 details
     D NwIP4AScnFmt  E DS                  EXTNAME(FTIPY4APD)

      ** Incoming Payments Valid extension file
     D NwIP2FilFmt   E DS                  EXTNAME(FTVIPY2PD)

      ** Incoming Payments Lvl 2 Scrn 2 error indicators
     D OKIPY3DS      E DS                  EXTNAME(FTEIPY3PD)

      ** First data structure for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** DS for Country Codes
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)

     D WCORDER         C                   '/ORDERRES/'
     D WCBENEF         C                   '/BENEFRES/'

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error messages
     D Idx             S              3P 0

      ** General index variable
     D J               S              3P 0

      **
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
      **                                                                                    MD000091
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************

      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

     C                   EVAL      Idx = 0

     C                   EXSR      SRRRPT

      ** If an error was found, set the return code appropriately
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      ReturnCode = 'ERROR'
     C                   ENDIF

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRRRPT - Validation of Regulatory Reporting                  *
      *****************************************************************
     C     SRRRPT        BEGSR

      *
      ** Entry is optional

     C                   IF        (DDRRP1 = *BLANKS) AND
     C                             (DDRRP2 = *BLANKS) AND
     C                             (DDRRP3 = *BLANKS)
     C                   EVAL      I2INRRP1 = *BLANKS
     C                   EVAL      I2INRRP2 = *BLANKS
     C                   EVAL      I2INRRP3 = *BLANKS
     C                   GOTO      EXRRPT
     C                   ENDIF

      ** There should be no blank line preceding a nonblank line among
      **   the Regulatory Reporting lines

     C                   IF        (DDRRP1 = *BLANK AND DDRRP2 <> *BLANK) OR
     C                             (DDRRP2 = *BLANK AND DDRRP3 <> *BLANK)
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr = 'FTM5017'
     C                   EVAL      FldNamXAr(Idx) = 'DDRRP1'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKRRP1 = 'N'
     C                   EVAL      OKRRP2 = 'N'
     C                   EVAL      OKRRP3 = 'N'
     C                   GOTO      EXRRPT
     C                   ENDIF

      *
      ** If positions 1-10 of first line is not '/ORDERRES/' nor
      **    '/BENEFRES/', accept free-format text

     C                   MOVEL     DDRRP1        WCHR10           10

     C                   IF        (WCHR10 <> WCORDER) AND
     C                             (WCHR10 <> WCBENEF)

     C                   IF        (DDRRP1 <> *BLANKS)
     C                   MOVE      *BLANKS       FLD              35
     C                   EVAL      FLD = DDRRP1
     C                   EXSR      SWSET
     C                   IF        (*IN99 = *ON)
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr = 'FTM5018'
     C                   EVAL      FldNamXAr(Idx) = 'DDRRP1'
     C     10            SUBST     DDRRP1        MsgDtaXar(Idx)
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKRRP1 = 'N'
     C                   ENDIF
     C                   ENDIF

     C                   IF        (DDRRP2 <> *BLANKS)
     C                   EVAL      FLD = DDRRP2
     C                   EXSR      SWSET
     C                   IF        (*IN99 = *ON)
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr = 'FTM5018'
     C                   EVAL      FldNamXAr(Idx) = 'DDRRP2'
     C     10            SUBST     DDRRP2        MsgDtaXar(Idx)
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKRRP2 = 'N'
     C                   ENDIF
     C                   ENDIF

     C                   IF        (DDRRP3 <> *BLANKS)
     C                   EVAL      FLD = DDRRP3
     C                   EXSR      SWSET
     C                   IF        (*IN99 = *ON)
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr = 'FTM5018'
     C                   EVAL      FldNamXAr(Idx) = 'DDRRP3'
     C     10            SUBST     DDRRP3        MsgDtaXar(Idx)
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKRRP3 = 'N'
     C                   ENDIF
     C                   ENDIF

     C                   IF        ErrorFound = 'N'
     C                   EVAL      I2INRRP1 = DDRRP1
     C                   EVAL      I2INRRP2 = DDRRP2
     C                   EVAL      I2INRRP3 = DDRRP3
     C                   ENDIF
     C                   GOTO      EXRRPT
     C                   ENDIF

      *
      ** If /BENEFRES/ or /ORDERRES/, positions 11-12 should refer to
      **    a live ISO Country Code

     C     2             SUBST     DDRRP1:11     WCHR1112          2
     C     2             SUBST     DDRRP1:13     WCHR1314          2
     C     23            SUBST     DDRRP1:13     WCHR1335         23
     C     21            SUBST     DDRRP1:15     WCHR1535         21
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      WCHR1112      PCNCD             2
     C     SDCTRY        PARM      SDCTRY        DSFDY
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr = 'FTM5019'
     C                   EVAL      FldNamXAr(Idx) = 'DDRRP1'
     C**********         EVAL      MsgDtaXAr(Idx) = WCHR1112                                MD000091
     C                   EVAL      BLen = %Len(%Trim(WCHR1112))                             MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(WCHR1112)                 MD000091
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKRRP1 = 'N'
     C                   GOTO      EXRRPT
     C                   ENDIF

      ** Validate first line
      ** Codeword + ISO Country Code + '//' + Additional info
      *

     C                   IF        (WCHR1335 <> *BLANKS)

     C                   SELECT

      ** Positions 13-14 should be '//'
     C                   WHEN      (WCHR1314 <> '//')
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr = 'FTM5020'
     C                   EVAL      FldNamXAr(Idx) = 'DDRRP1'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKRRP1 = 'N'
     C                   GOTO      EXRRPT

      ** Additional info is mandatory after '//'
     C                   WHEN      (WCHR1314 = '//')  AND
     C                             (WCHR1535 = *BLANKS)
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr = 'FTM5021'
     C                   EVAL      FldNamXAr(Idx) = 'DDRRP1'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKRRP1 = 'N'
     C                   GOTO      EXRRPT

      ** Validate if additional info consists of SWIFT characters
     C                   OTHER
     C                   EVAL      FLD = *BLANKS
     C                   EVAL      FLD = WCHR1535
     C                   EXSR      SWSET
     C                   IF        (*IN99 = *ON)
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr = 'FTM5022'
     C                   EVAL      FldNamXAr(Idx) = 'DDRRP1'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKRRP1 = 'N'
     C                   GOTO      EXRRPT
     C                   ENDIF
     C                   ENDSL

     C                   ENDIF

      ** Validate second line
      ** '//' + Additional info

     C     2             SUBST     DDRRP2:1      WCHR0102          2
     C     33            SUBST     DDRRP2:3      WCHR0335         33

     C                   IF        (DDRRP2 <> *BLANKS)
     C                   MOVEL     DDRRP1        @@RRP1           10                        AR920077
     C                   MOVEL     DDRRP2        @@RRP2           10                        AR920077

     C                   SELECT

      ** Positions 1-2 should be '//'
     C                   WHEN      (WCHR0102 <> '//')
     C                             And (WCORDER <> @@RRP1 Or WCBENEF <> @@RRP2)             AR920077
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr = 'FTM5020'
     C                   EVAL      FldNamXAr(Idx) = 'DDRRP2'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKRRP2 = 'N'
     C                   GOTO      EXRRPT

      ** Additional info is mandatory after '//'
     C                   WHEN      (WCHR0102 = '//')  AND
     C                             (WCHR0335 = *BLANKS)
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr = 'FTM5021'
     C                   EVAL      FldNamXAr(Idx) = 'DDRRP2'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKRRP2 = 'N'
     C                   GOTO      EXRRPT

      ** Validate if additional info consists of SWIFT characters
     C                   OTHER
     C                   EVAL      FLD = *BLANKS
     C                   EVAL      FLD = WCHR0335
     C                   EXSR      SWSET
     C                   IF        (*IN99 = *ON)
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr = 'FTM5022'
     C                   EVAL      FldNamXAr(Idx) = 'DDRRP2'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKRRP2 = 'N'
     C                   GOTO      EXRRPT
     C                   ENDIF
     C                   ENDSL

     C                   ENDIF

      ** Validate third line
      ** '//' + Additional info

     C     2             SUBST     DDRRP3:1      WCHR0102
     C     33            SUBST     DDRRP3:3      WCHR0335

     C                   IF        (DDRRP3 <> *BLANKS)

     C                   SELECT

      ** Positions 13-14 should be '//'
     C                   WHEN      (WCHR0102 <> '//')
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr = 'FTM5020'
     C                   EVAL      FldNamXAr(Idx) = 'DDRRP3'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKRRP3 = 'N'
     C                   GOTO      EXRRPT

      ** Additional info is mandatory after '//'
     C                   WHEN      (WCHR0102 = '//')  AND
     C                             (WCHR0335 = *BLANKS)
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr = 'FTM5021'
     C                   EVAL      FldNamXAr(Idx) = 'DDRRP3'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKRRP3 = 'N'
     C                   GOTO      EXRRPT

      ** Validate if additional info consists of SWIFT characters
     C                   OTHER
     C                   EVAL      FLD = *BLANKS
     C                   EVAL      FLD = WCHR0335
     C                   EXSR      SWSET
     C                   IF        (*IN99 = *ON)
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr = 'FTM5022'
     C                   EVAL      FldNamXAr(Idx) = 'DDRRP3'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKRRP3 = 'N'
     C                   GOTO      EXRRPT
     C                   ENDIF
     C                   ENDSL

     C                   ENDIF

     C                   IF        ErrorFound = 'N'
     C                   EVAL      I2INRRP1 = DDRRP1
     C                   EVAL      I2INRRP2 = DDRRP2
     C                   EVAL      I2INRRP3 = DDRRP3
     C                   ENDIF

     C     EXRRPT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      *
      ** O: Return Code
     C                   PARM                    ReturnCode
      *
      ***********
      ** INPUT **
      ***********
      *
      ** I: Incoming Payments Lvl 2 Scrn 2 File details
     C                   PARM                    NwIP4AScnFmt
      *
      ************
      ** OUTPUT **
      ************
      *
      ** Incoming Payments Valid extension file
     C                   PARM                    NwIP2FilFmt
      ** Incoming Payments Lvl 2 Scrn 2 error indicators
     C                   PARM                    OKIPY3DS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** ==============================================================
      ** Program, module and procedure names for database error proc'g.
      ** ==============================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      /EJECT
     C/COPY FTCPYSRC,SFTADDRSC1
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
