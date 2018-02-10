     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM NAs Sold Amend Checking')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMNASSAMD - Negotiable Assets Sold Amend Checking            *
      *                                                               *
      *  Function:  This module compares the fields of an             *
      *             amended deal against those currently on file.     *
      *             It checks whether all fields amended are          *
      *             amendable, and if not returns error messages to   *
      *             the calling process.                              *
      *             If can optionally reset fields wrongly amended.   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 BUG9711            Date 26Jan06               *
      *                 CDL039             Date 22Aug05               *
      *                 CDL038             Date 10May05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP004             Date 07Sep98               *
      *                 CAP002  *CREATE    Date 22Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9711- Changes to MMVNASPPD/MMVNASSPD (re-compile)         *
      *  CDL039 - Amendable Deal Sub Types & Classes                  *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP004 - API's Phase 3.                                      *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FMMCDAFLL  IF   E             DISK    INFSR(*PSSR)
 
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
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **--------------------------------------------------------------------------------------------
      ** Flags to indicate whether transaction fields are valid
      ** These have been declared for all MM0027D2 fields, though some may
      ** not actually be needed if the field is not used/not validated
      ** The OKFlagsDS data structure is defined in the following /COPY
     D/COPY MMCPYSRC,MMNASSOK
      **--------------------------------------------------------------------------------------------
 
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
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * New Deal in Screen Format
     D NwDlScnFmt    E DS                  EXTNAME(MMNASSPD)
 
      * (Current) Deal in Screen Format
     D DealScnFmt    E DS                  EXTNAME(MMNASSPD)
     D                                     PREFIX(@)
 
      * (Current) Deal in File Format
     D DealFilFmt    E DS                  EXTNAME(MMDENSPP)
 
     D RUNDAT          DS                  DTAARA(RUNDAT)
      ** Run date data area
     D  @MBIN                 13     13
 
     D                 DS
      **  Data structure for date in, to change format.
     D  DateIn                 1      8  0
     D  @@YY                   1      4  0
     D  @@MM                   5      6  0
     D  @@DD                   7      8  0
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CDL039
      ** EXTERNAL DS FOR SAR DETAILS                                                          CDL039
                                                                                              CDL039
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
      ** Copy of the MMVNASSD0 data structure, to allow validation of
      ** both MMVNASSPD and MMDENSPP fields by the same routine.
     D VNASSFmt      E DS                  EXTNAME(MMVNASSPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Deal Amendment Value Date in Midas Dayno. format
     D DeamValDat      S              5P 0
 
      ** New Maturity Date in Midas Dayno. format
     D NewMatDate      S              5P 0
 
      ** New Next Interest Date in Midas Dayno. format
     D NewNxInDte      S              5P 0
 
      ** Message ID for the single database error message
     D Msg1            S                   LIKE(#MsgID)
 
      ** Message data for the single database error message
     D MsgData         S                   LIKE(#MsgData)
 
      ** Overall Transaction status, to be passed back to calling program
     D AmendOK         S              1A
 
      ** Deal Transaction Date in Midas Dayno. format
     D TransDate       S              5P 0
 
      ** Last Interest Date in Midas Dayno. format
     D LstIntDate      S              5P 0
 
      ** Whether reset of errors is required
     D ResetErrs       S              1A
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
 
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
 
      **  Convert the dates on the current live deal
      **  from YYYYMMDD format to Midas day number format
     C                   EXSR      ConvDates
 
      **  Compare fields with amended values.
     C                   EXSR      CompFlds
 
      *  If any errors were found:
      *    Set Amendments OK Indicator to 'N'
 
     C     Idx           IFGT      0
     C                   EVAL      AmendOK = 'N'
     C                   ELSE
     C                   EVAL      AmendOK = 'Y'
     C                   ENDIF
 
      *  If any errors were found and reset of fields in error required,
      *  do this
     C     Idx           IFGT      0
     C     ResetErrs     ANDEQ     'Y'
     C                   EXSR      ResetFlds
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CompFlds  - Compare certain fields on the current deal        *
      *             with those amended.                               *
      *                                                               *
      *****************************************************************
     C     CompFlds      BEGSR
 
     C*-----------------------------------------*
     C* Deal Type                               *
     C*-----------------------------------------*
     C** This field is NOT AMENDABLE.
     C*
     C     DDMTYP        IFNE      @DDMTYP
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMTYP'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0398'
     C                   EVAL      ddMTYPok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Deal SubType                            *
     C*-----------------------------------------*
     C** This field is amendable only if so defined on MMCDAFPP.
     C** and if CDL039 is ON                                                                  CDL039
     C*
     C     HMDSTS        IFNE      'C'
     C     DDSTYP        ANDNE     @DDSTYP
     C     CDL039        ANDEQ     'N'                                                        CDL039
     C     HMDSTS        OREQ      'C'
     C     DDSTYP        ANDNE     @DDSTYP
     C     HHDLSA        ANDEQ     'N'
     C     CDL039        ANDEQ     'N'                                                        CDL039
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSTYP'
     C     HMDSTS        IFEQ      'C'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0400'
     C                   ELSE
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0401'
     C                   END
     C                   EVAL      ddSTYPok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Federal Funds Indicator                 *
     C*-----------------------------------------*
     C** This field may only be amended if deal NOT Authorised.
     C*
     C     HMDSTS        IFNE      'C'
     C     DDFEDF        ANDNE     @DDFEDF
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFEDF'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0396'
     C                   EVAL      ddFEDFok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Deal Date                               *
     C*-----------------------------------------*
     C** This field may not be amended
     C*
     C     DDDLDT        IFNE      @DDDLDT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDLDT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0382'
     C                   EVAL      ddDLDTok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Broker Code                             *
     C*-----------------------------------------*
     C**  This field is not amendable for R and A status deals,
     C**  and is only amendable for status C if this is indicated on
     C**  MMCDAFLL.
     C*
     C     DDBKCD        IFNE      @DDBKCD
     C*
     C     HMDSTS        IFNE      'C'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBKCD'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0391'
     C                   EVAL      ddBKCDok        = 'N'
     C                   ELSE
     C     HHBKRA        IFEQ      'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBKCD'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0390'
     C                   EVAL      ddBKCDok        = 'N'
     C                   ENDIF
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Brokerage                               *
     C*-----------------------------------------*
     C**  This field is not amendable for R and A status deals,
     C**  and is only amendable for status C if this is indicated on
     C**  MMCDAFLL.
     C*
      ** Use the %TRIM built-in function to remove any leading or trailing
      ** spaces
     C                   IF        %trim(DDBRKG) <> %trim(@DDBRKG)
     C*
     C     HMDSTS        IFNE      'C'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBRKG'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0395'
     C                   EVAL      ddBRKGok        = 'N'
     C                   ELSE
     C     HHBKGA        IFEQ      'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBRKG'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0394'
     C                   EVAL      ddBRKGok        = 'N'
     C                   ENDIF
     C                   ENDIF
     C*
     C                   ENDIF
 
      **----------------------------------------*
      ** Sale of deal number                    *
      **----------------------------------------*
 
     C**  The Sale of Deal No. may not be amended.
     C                   IF        DDDADN <> @DDDADN                            B1
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDADN'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0402'
     C                   EVAL      ddDADNok        = 'N'
     C                   ENDIF
 
      **----------------------------------------*
      ** NAB Issuer                             *
      **----------------------------------------*
 
      ** Issued by customer cannot be amended
     C                   IF        DDISUR <> @DDISUR                            B1
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDISUR'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0497'
     C                   EVAL      ddISURok       = 'N'
     C                   ENDIF
 
      **----------------------------------------*
      ** Sold to Customer                       *
      **----------------------------------------*
 
      **  This field is not amendable for R and A status deals,
      **  and is only amendable for status C if this is indicated on
      **  MMCDAFLL.
     C     DDCSNM        IFNE      @DDCSNM
 
     C     HMDSTS        IFNE      'C'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCSNM'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0385'
     C                   EVAL      ddCSNMok       = 'N'
     C                   ELSE
     C     HHCNMA        IFEQ      'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCSNM'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0384'
     C                   EVAL      ddCSNMok       = 'N'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C*
     C*-----------------------------------------*
     C* Value Date                              *
     C*-----------------------------------------*
     C** This field is NOT AMENDABLE.
     C*
     C     DDVDAT        IFNE      @DDVDAT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDVDAT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0386'
     C                   EVAL      ddVDATok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Currency                                *
     C*-----------------------------------------*
     C** This field is NOT AMENDABLE.
     C*
     C     DDCCY         IFNE      @DDCCY
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCCY '
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0370'
     C                   EVAL      ddCCYok         = 'N'
     C                   ENDIF
 
      **----------------------------------------*
      ** Face value                             *
      **----------------------------------------*
 
      ** This field is not amendable.
      ** Use the %TRIM built-in function to remove any leading or trailing
      ** spaces
     C                   IF        %trim(DDFVAL) <> %trim(@DDFVAL)
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFVAL'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0496'
     C                   EVAL      ddFVALok       = 'N'
     C                   ENDIF
 
      **----------------------------------------*
      ** Sale price                             *
      **----------------------------------------*
 
      ** This field is not amendable.
      ** Use the %TRIM built-in function to remove any leading or trailing
      ** spaces
     C                   IF        %trim(DDAMNP) <> %trim(@DDAMNP)
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDAMNP'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0500'
     C                   EVAL      ddAMNPok       = 'N'
     C                   ENDIF
 
      **----------------------------------------*
      ** Yield rate                             *
      **----------------------------------------*
 
      ** This field is not amendable.
     C     DDINTR        IFNE      @DDINTR
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSPRT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0495'
     C                   EVAL      ddINTRok       = 'N'
     C                   ENDIF
 
      **----------------------------------------*
      ** Profit Centre                          *
      **----------------------------------------*
 
     C** Only validate this field if Profit Centre ICD flag on.
     C*
     C     BKPRCU        IFEQ      'Y'
     C*
     C** This field is not amendable unless 'Profit Centre Amendable'
     C** ICD flag is on.
     C*
     C     DDPRFC        IFNE      @DDPRFC
     C     BKPRCA        ANDNE     'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPRFC'
     C                   EVAL      MsgIDArr(Idx)   = 'FXM4002'
     C                   EVAL      ddPRFCok       = 'N'
     C                   ENDIF
     C*
     C                   ENDIF
 
      **----------------------------------------*
      ** Parcel Size                            *
      **----------------------------------------*
 
      ** This field is not amendable
      ** Use the %TRIM built-in function to remove any leading or trailing
      ** spaces
     C                   IF        %trim(DDPSZE) <> %trim(@DDPSZE)
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPSZE'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM2001'
     C                   EVAL      ddPSZEok       = 'N'
     C                   ENDIF
                                                                                CAP004
      **----------------------------------------*                               CAP004
      ** Book Code                              *                               CAP004
      **----------------------------------------*                               CAP004
                                                                                CAP004
      ** This field may only be amended if deal NOT Authorised.                 CAP004
                                                                                CAP004
     C     DDBOKC        IFNE      @DDBOKC                                      CAP004
     C     HMDSTS        ANDNE     'C'                                          CAP004
     C                   ADD       1             Idx                            CAP004
     C                   EVAL      FldNameArr(Idx) = 'DDBOKC'                   CAP004
     C                   EVAL      MsgIDArr(Idx)   = 'MMM2570'                  CAP004
     C                   EVAL      ddBOKCok        = 'N'                        CAP004
     C                   ENDIF                                                  CAP004
                                                                                              CDL038
      *-----------------------------------------*                                             CDL038
      * Class                                   *                                             CDL038
      *-----------------------------------------*                                             CDL038
      ** This field is amendable only if the deal is complete                                 CDL038
      ** and if CDL039 is ON                                                                  CDL039
                                                                                              CDL038
     C     HMDSTS        IFNE      'C'                                                        CDL038
     C     DDCLAS        ANDNE     @DDCLAS                                                    CDL038
     C     CDL039        ANDEQ     'N'                                                        CDL039
     C                   ADD       1             Idx                                          CDL038
     C                   EVAL      FldNameArr(Idx) = 'DDCLAS'                                 CDL038
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0258'                                CDL038
     C                   EVAL      ddCLASok        = 'N'                                      CDL038
     C                   ENDIF                                                                CDL038
 
     C*
     C*-----------------------------------------------------------------*
     C* The following fields are currently UNCONDITIONALLY AMENDABLE    *
     C* so no checking is done here.                                    *
     C*-----------------------------------------------------------------*
     C*
     C***DDBOKC*-*Book*Code**********************************************       CAP004
     C** DDLNKN - Linked Reference Number
     C** DDORBR - Originating Branch
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETFLDS - Reset fields in Error                             *
      *                                                               *
      *****************************************************************
 
     C     RESETFLDS     BEGSR
      *
      * Reset fields in error to 'current' values
      *
      * Deal Type
     C     ddMTYPOK      IFEQ      'N'
     C                   MOVEL     @DDMTYP       DDMTYP
     C                   END
      *
      * Deal SubType
     C     ddSTYPOK      IFEQ      'N'
     C                   MOVEL     @DDSTYP       DDSTYP
     C                   END
      *
      * Federal Funds Indicator
     C     ddFEDFOK      IFEQ      'N'
     C                   MOVEL     @DDFEDF       DDFEDF
     C                   END
      *
      * Deal Date
     C     ddDLDTOK      IFEQ      'N'
     C                   MOVEL     @DDDLDT       DDDLDT
     C                   END
      *
      * Broker Code
     C     ddBKCDOK      IFEQ      'N'
     C                   MOVEL     @DDBKCD       DDBKCD
     C                   END
      *
      * Brokerage
     C     ddBRKGOK      IFEQ      'N'
     C                   MOVEL     @DDBRKG       DDBRKG
     C                   END
      *
      * Sale of Deal Number
     C     ddDADNOK      IFEQ      'N'
     C                   MOVEL     @DDDADN       DDDADN
     C                   END
      *
      * Issuer
     C     ddISUROK      IFEQ      'N'
     C                   MOVEL     @DDISUR       DDISUR
     C                   END
      *
      * Sold to customer
     C     ddCSNMOK      IFEQ      'N'
     C                   MOVEL     @DDCSNM       DDCSNM
     C                   END
      *
      * Value Date
     C     ddVDATOK      IFEQ      'N'
     C                   MOVEL     @DDVDAT       DDVDAT
     C                   END
      *
      * Currency
     C     ddCCYOK       IFEQ      'N'
     C                   MOVEL     @DDCCY        DDCCY
     C                   END
      *
      * Face value
     C     ddFVALOK      IFEQ      'N'
     C                   MOVEL     @DDFVAL       DDFVAL
     C                   END
      *
      * Sale price
     C     ddAMNPOK      IFEQ      'N'
     C                   MOVEL     @DDAMNP       DDAMNP
     C                   END
      *
      * Yield rate
     C     ddINTROK      IFEQ      'N'
     C                   MOVEL     @DDINTR       DDINTR
     C                   END
      *
      * Book code
     C     ddBOKCOK      IFEQ      'N'
     C                   MOVEL     @DDBOKC       DDBOKC
     C                   END
      *
      * Linked reference number
     C     ddLNKNOK      IFEQ      'N'
     C                   MOVEL     @DDLNKN       DDLNKN
     C                   END
      *
      * Profit Centre
     C     ddPRFCOK      IFEQ      'N'
     C                   MOVEL     @DDPRFC       DDPRFC
     C                   END
      *
      * Originating branch
     C     ddORBROK      IFEQ      'N'
     C                   MOVEL     @DDORBR       DDORBR
     C                   END
      *
      * Parcel size
     C     ddPSZEOK      IFEQ      'N'
     C                   MOVEL     @DDPSZE       DDPSZE
     C                   END
      *                                                                                       CDL038
      * Class                                                                                 CDL038
     C     ddCLASOK      IFEQ      'N'                                                        CDL038
     C                   MOVEL     @DDCLAS       DDCLAS                                       CDL038
     C                   END                                                                  CDL038
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CONVDATES  - Convert date fields from MMDELDPP from DDMMYYYY  *
      *              to Midas Dayno (5,0) format for comparison       *
      *                                                               *
      *****************************************************************
 
     C     CONVDATES     BEGSR
     C*
     C***********************************************
     C**  Format the transaction date               *
     C***********************************************
     C*
     C                   Z-ADD     HMDTYY        @@YY
     C                   Z-ADD     HMDTMM        @@MM
     C                   Z-ADD     HMDTDD        @@DD
     C*
     C     DateIn        IFEQ      0
     C                   Z-ADD     0             TransDate
     C                   ELSE
     C                   CALLB     'ZDATE10'
     C                   PARM                    DateIn
     C                   PARM                    ZZMDNO
     C                   MOVE      ZZMDNO        TransDate
     C                   END
     C*
     C***********************************************
     C**  Format the Last Interest date.            *
     C***********************************************
     C*
     C                   Z-ADD     HMLIYY        @@YY
     C                   Z-ADD     HMLIMM        @@MM
     C                   Z-ADD     HMLIDD        @@DD
     C*
     C     DateIn        IFEQ      0
     C                   Z-ADD     0             LstIntDate
     C                   ELSE
     C                   CALLB     'ZDATE10'
     C                   PARM                    DateIn
     C                   PARM                    ZZMDNO
     C                   MOVE      ZZMDNO        LstIntDate
     C                   END
     C*
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************   AU
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *inzsr        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      * New Deal in Screen Format
     C                   PARM                    NwDlScnFmt
      * Current Deal in Screen Format
     C                   PARM                    DealScnFmt
      * Current Deal in file format
     C                   PARM                    DealFilFmt
      *
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Amendments OK
     C                   PARM                    AmendOk
      * Reset of Fields in Error Required (Y/N)
     C                   PARM                    ResetErrs
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C     *LIKE         DEFINE    ILDDND        ZZMDNO
      *
      **  Get RUNDAT to access Multibranching flag.
      *
     C                   IN        RUNDAT
 
      ** Access Bank details via access program
      ** (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Access MIDAS Modules details via access program
      ** (database error handling done in access program)
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
      ** Access General Ledger details via access program
      ** (database error handling done in access program)
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
      **  Read the first and only record on MMCDAFLL.
     C     1             CHAIN     MMCDAFLL                           60
 
      **  If no valid record found then it is a data base error.
     C     *IN60         IFEQ      '1'
     C     HHDLTF        OREQ      '*'
 
     C                   MOVEL     'MMCDAFLL'    DBFILE                         * DBERROR 018 *
     C                   MOVEL     *BLANKS       DBKEY                          ***************
     C                   EVAL      FieldName = 'None'
     C                   EVAL      Msg1 = 'MMA0002'
     C                   EVAL      MsgData = (PSProcPgm + PSProcMod
     C                              + PSProcName + DBFILE + DBKEY)
     C                   EXSR      DBErrExit
     C                   EXSR      *pssr
 
     C                   ENDIF
 
     C**  Close the files that are only used once.
     C                   CLOSE     MMCDAFLL
 
      *                                                                                       CDL039
      ** ACCESS SAR DETAILS FILE TO DETERMINE IF CDL039 IS INSTALLED                          CDL039
      *                                                                                       CDL039
     C                   CALL      'AOSARDR0'                                                 CDL039
     C                   PARM      *BLANKS       @RTCD                                        CDL039
     C                   PARM      '*VERIFY'     @OPTN                                        CDL039
     C                   PARM      'CDL039'      @SARD             6                          CDL039
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL039
      *                                                                                       CDL039
     C     @RTCD         IFEQ      *BLANK                                                     CDL039
     C                   MOVEL     'Y'           CDL039            1                          CDL039
     C                   ELSE                                                                 CDL039
     C                   MOVEL     'N'           CDL039                                       CDL039
     C                   END                                                                  CDL039
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,DBERREXIT
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
