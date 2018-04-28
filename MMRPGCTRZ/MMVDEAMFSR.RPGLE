     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate funding spread/rate     (DeAms)')    *
      *****************************************************************
      *                                                               *
      *  Midas - Common Validation Routine                            *
      *                                                               *
      *  MMVDEAMFSR - Validate Funding Spread/Rate                    *
      *               (for Deal Amendment processing)                 *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             Funding Spread/Rate  and confirms if valid.       *
      *             If it is valid the 10A return code will be        *
      *             blank; if it is not it will contain 'Error'       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CDL094             Date 11Jun14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 01Jun01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 15May01               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 03Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL022 - Deal Amendment Changes (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMDEAMPP *
      *  CDE002 - Revenue Analysis - new entry parm and validation    *
      *  CSD006 - Use long DS with SDBSRTPD.                          *
      *  CAP002 - Conversion of inputs into modular structure to      *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +----------------------------+
      ** ¦ Manually Included F-Specs  ¦
      ** ¦ =========================  ¦
      ** +----------------------------+
      **
     FMMLVDMLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     INFDS(INFDS)
      **
      ** +-----------------------------------+
      ** ¦ End of Manually Included F-Specs  ¦
      ** ¦ ================================  ¦
      ** +-----------------------------------+
      **
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
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
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
 
     D INFDS           DS
     D**  Data structure for file status of MM deals file.
     D*
     D                 DS
     D**  Data Structure to split value date used in key to deams file
     D  @KVALD                 1      8  0
     D  KeyVdatYY              1      4  0
     D  KeyVdatYr              3      4  0
     D  KeyVdatMM              5      6  0
     D  KeyVdatDD              7      8  0
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** External data structure for access programs (long)
 
      ** External data structure for Customer Details file
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
 
      ** External data structure for PCA Details file
     D SDPCAC        E DS                  EXTNAME(SDPCACPD)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message code 1 received as a parameter
     D Msgid1          S                   LIKE(#MSGID)
 
      ** Error message code 2 received as a parameter
      ** (for errors relating to Interest Rate/Spread)
     D Msgid2          S                   LIKE(#MSGID)
 
      ** Deal Amendment Type received as a paramater
     D DDMTYP          S              2A
 
      ** Warning message code 1 received as a parameter
     D WMsgid1         S                   LIKE(#MSGID)
 
      ** Funding Spread/Rate received as a paramater
     D DDFSRP          S             12A
 
      ** Interest Rate received as a paramater
     D DDINTR          S             12A
 
      ** Deal Number received as a paramater
     D DDDLNO          S              6A
 
      ** Deam Sequence Number received as a paramater
     D DDDS38          S              3A
 
      ** Currency Code received as a paramater
     D DDCCY           S              3A
 
      ** Value Date in Midas Day No. format received as a parameter
     D @VDYNO          S              5  0
 
      ** Decimal separator (from SDDEALPD) received as a parameter
     D BNDCSP          S              1A
 
      ** Funding Profit Centre from original deal (MMDELDPP)
      ** received as a parameter
     D H@FPRC          S              4A
 
      ** Base Rate Code from original deal (MMDELDPP)
      ** received as a parameter
     D H@BSRC          S              2A
 
      ** Spread from original deal (MMDELDPP)
      ** received as a parameter
     D H@SPRD          S             11  7
 
      ** Funding Spread/Rate from original deal (MMDELDPP)
      ** received as a parameter
     D H@FSRP          S             11  7
 
      ** Interest Rate from original deal (MMDELDPP)
      ** received as a parameter
     D H@INTR          S             11  7
 
      ** Funding Spread Sign from original deal (MMDELDPP)
      ** received as a parameter
     D H@FSGN          S              1A
 
      ** Interest Rate Field in error flag passed as a parameter
     D DDIntrOK        S              1A
 
      ** Interest Rate Change flag from deal passed as a parameter
     D IGIRCF          S              1A
 
      ** Funding Rate Change flag from deal passed as a parameter
     D IGFRCF          S              1A
 
      ** Funding Spread/Rate from deal passed as a parameter
     D IGFSRP          S             11  7
 
      ** Interest Rate/Spread from deal received as a parameter
     D IGINTR          S             11  7
                                                                                              CDE002
      ** Analytical Accounting (SDMMODPD)                                                     CDE002
      ** received as a parameter                                                              CDE002
     D BGN0ST          S              1A                                                      CDE002
 
 
      ** Key Fields used in chain to MMLVDMLL
     D KeyDealNo       S              6S 0
     D KeySeqNum       S              3S 0
 
 
      ** Fields used in call to Module ZA0840
 
      ** Alpha field for numeric validation
     D @@ALPH          S             16A
      ** Millions/Thousands id (Y=function on)
     D @@MTID          S              1A
      ** Amount calculation field
     D @@AMT           S             15  0
      ** Error code
     D @@ERCD          S              1  0
      ** Number of decimal places
     D @@IDP           S              3  0
      ** Number of integers
     D @@IINT          S              3  0
 
     D HNDA38          S              6S 0
     D HNDS38          S              3S 0
 
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
 
      ** Reset the error flag to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
     C                   RESET                   Msgid2
     C                   RESET                   WMsgid1
     C                   RESET                   WarnFound
      *
     C*  *------------------------------*
     C*  * Validate Funding Spread/Rate *
     C*  *------------------------------*
     C*
      *
      **  Funding spread/rate should not be entered if amendment type
      **  is not 'SC'
      *
     C     DDMTYP        IFNE      'SC'
     C     DDFSRP        ANDNE     *BLANKS
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0469'     Msgid1
     C                   ENDIF
      *
      **  Still an error if 'SC' but both interest rate/spread are
      **  blank
      *
     C     DDMTYP        IFEQ      'SC'
     C     DDINTR        ANDEQ     *BLANKS
     C     DDFSRP        ANDEQ     *BLANKS
     C                   MOVE      'N'           DDIntrOK
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0468'     Msgid2
     C                   ENDIF
      *
      **  Not valid if deal is not directly funded
      **  only if analytical accounting is on                                                 CDE002
      *
     C     DDMTYP        IFEQ      'SC'
     C     DDFSRP        ANDNE     *BLANKS
     C     H@FPRC        ANDEQ     *BLANKS
     C     BGN0ST        ANDEQ     'Y'                                                        CDE002
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0470'     Msgid1
     C                   ENDIF
      *
      **  Check if it is a valid figure with 7 decimal places max.
      *
     C     ErrorFound    IFNE      'Y'
     C     DDIntrOK      ANDNE     'N'
     C                   Z-ADD     7             @@IDP
     C                   Z-ADD     4             @@IINT
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDFSRP        @@ALPH
     C                   MOVE      'N'           @@MTID
     C                   CALLB     'ZA0840'
     C                   PARM                    ReturnCode
     C                   PARM                    @@ALPH
     C                   PARM                    @@IDP
     C                   PARM                    @@IINT
     C                   PARM                    @@MTID
     C                   PARM                    @@Ercd
     C                   PARM                    @@Amt
     C                   PARM                    BNDCSP
      *
     C     @@Ercd        IFNE      0
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0422'     Msgid1
     C                   ENDIF
      *
      **  Determine Interest Rate Change Flag
      *
     C     DDINTR        IFNE      *BLANKS
     C                   MOVE      'Y'           IGIRCF
     C                   ELSE
     C                   MOVE      'N'           IGIRCF
     C                   ENDIF
      *
      **  Determine Funding Rate Change Flag
      *
     C     DDFSRP        IFNE      *BLANKS
     C                   MOVE      'Y'           IGFRCF
     C                   ELSE
     C                   MOVE      'N'           IGFRCF
     C                   ENDIF
     C                   ENDIF
      *
      **  If the spread/rate is valid, determine the effective rate and
      **  output it.
      *
     C     ErrorFound    IFEQ      'N'
     C     DDIntrOK      ANDNE     'N'
     C     DDFSRP        IFNE      *BLANKS
     C     @@AMT         DIV       10000000      IGFSRP
     C                   MOVE      @@ALPH        DDFSRP
     C                   ELSE
     C                   Z-ADD     0             IGFSRP
     C                   ENDIF
      *
      **  Calculate new effective rates and check if effective funding
      **  rate is within tolerance level
      **  only if analytical accounting is on                                                 CDE002
      *
     C     BGN0ST        IFEQ      'Y'                                                        CDE002
     C                   EXSR      SRERAT
      *
      **  Retrieve Funding Tolerance from PCA ICD
      *
     C                   CALLB     'AOPCACR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDPCAC        PARM      SDPCAC        DSFDY
      *
      **  Check for data base error
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     'SDPCACPD'    DBFILE                         ************
     C                   MOVEL     '019'         DBASE                          * DBERR 019*
     C                   MOVEL     @OPTN         DBOPTN            7            ************
     C                   MOVEL     '*FIRST '     DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      **  Calculate minimum & maximum allowable amount based on
      **  Funding Tolerance
      *
     C     EffctvFRat    IFGT      EffctvIRat
     C     FTTFRT        DIV       100           TolWkFld1         3 2
     C     TolWkFld1     ADD       1             TolWkFld4         3 2
     C     EffctvIrat    MULT      TolWkFld4     MaxTolrnce       11 7
     C                   ENDIF
      *
     C     EffctvFRat    IFLT      EffctvIRat
     C     FTTFRT        DIV       100           TolWkFld2         3 2
     C     1             SUB       TolWkFld2     TolWkFld3         3 2
     C     EffctvIrat    MULT      TolWkFld3     MinTolrnce       11 7
     C                   ENDIF
      *
      **  Check if Effective Funding Rate is within tolerance level
      *
     C     *IN24         IFEQ      *ON
     C     EffctvFRat    ANDNE     EffctvIRat
     C     EffctvFRat    IFGT      MaxTolrnce
     C     EffctvFRat    ANDGT     EffctvIRat
     C     EffctvFRat    ORLT      MinTolrnce
     C     EffctvFRat    ANDLT     EffctvIRat
     C                   MOVE      'Y'           WarnFound
     C                   MOVEL     'MMM2550'     WMsgid1
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                                CDE002
     C                   ENDIF
 
      ** Return code is set in the /COPY
     C/COPY ZACPYSRC,SETRETCDE
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRERAT - Subroutine to calculate new effective rates         *
      *                                                               *
      *  Called by: Main Processing                                   *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     SRERAT        BEGSR
      *
     C                   MOVE      '1'           *IN24
     C                   MOVE      '0'           *IN25
     C                   Z-ADD     *ZEROS        @KVALD
      *
      **  Calculate New Effective Interest Rate
      *
      **  New Interest Rate/Spread as entered for current deal amend
      *
     C     DDINTR        IFNE      *BLANKS
     C                   Z-ADD     IGINTR        WkIRatSprd
      *
      **  Or, if no Interest Rate/Spread entered, from another 'SC'
      **  with value date <= current deal amendment value date
      *
     C                   ELSE
     C                   MOVE      DDDLNO        KeyDealNo
     C     DDDS38        IFEQ      *BLANKS
     C                   MOVE      '999'         KeySeqNum
     C                   ELSE
     C                   MOVE      DDDS38        KeySeqNum
     C                   ENDIF
      *
      **  Look for last 'SC' for the entered deal
      *
     C     DeamKey       SETGT     MMLVDMLL
     C     *IN25         DOUEQ     *ON
     C     HNMTYP        OREQ      'SC'
     C     HNIRCF        ANDEQ     'Y'
     C     HNDA38        ORNE      KeyDealNo
     C                   READP     MMLVDMLL                               25
     C                   ENDDO
      *
     C     HNMTYP        IFEQ      'SC'
     C     HNIRCF        ANDEQ     'Y'
     C     HNDA38        ANDEQ     KeyDealNo
     C                   Z-ADD     H@INTR        WkIRatSprd
      *
      **  Or, if no Int Rate/Spread entered & no other 'SC' for deal,
      **  use original deal rate/spread
      *
     C                   ELSE
      *
      **  If deal has base rate, use spread rate, else use current deal
      **  interest rate
      *
     C     H@BSRC        IFNE      *BLANKS
     C                   Z-ADD     H@SPRD        WkIRatSprd
     C                   ELSE
     C                   Z-ADD     H@INTR        WkIRatSprd
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      **  Obtain Base Rate Code
      *
     C                   MOVE      H@BSRC        WkBasRatCd
      *
      **  If deal is linked to a Base Rate...
      *
     C     WkBasRatCd    IFNE      *BLANKS
      *
      **  Retrieve Base Rate Code details
      *
     C                   CALLB     'AOBSRTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDCCY         @BRCY             3
     C                   PARM      WkBasRatCd    @BRCD             2
     C*****SDBSRT        PARM      SDBSRT        DSFDY                          CSD006
     C     SDBSRT        PARM      SDBSRT        DSSDY                          CSD006
      *
      **  Determine actual base rate
      *
     C     @VDYNO        IFLT      BAVDNR
     C                   Z-ADD     BACBSR        WkBaseRate
     C                   ELSE
     C                   Z-ADD     BANBRT        WkBaseRate
     C                   ENDIF
      *
     C     WkBaseRate    ADD       WkIRatSprd    EffctvIrat
      *
      **  If deal is not linked to a Base Rate, eff. int. rate = WkIRatSprd
      *
     C                   ELSE
     C                   Z-ADD     WkIRatSprd    EffctvIrat
     C                   ENDIF
      *
      **  Do not perform tolerance check if new eff. int. rate = 0
      *
     C     EffctvIrat    IFEQ      0
     C                   MOVE      '0'           *IN24
     C                   GOTO      SRERA9
     C                   ENDIF
      *
      **  Calculate New Funding Rate/Spread
      *
     C                   MOVE      '0'           *IN25
      *
      **  New Funding Rate/Spread as entered for current deal amend
      *
     C     DDFSRP        IFNE      *BLANKS
     C                   Z-ADD     IGFSRP        WkFRatSprd
      *
      **  Or, if no Funding Rate/Spread entered, from another 'SC'
      **  with value date <= current deal amendment value date
      *
     C                   ELSE
     C                   MOVE      DDDLNO        KeyDealNo
     C     DDDS38        IFEQ      *BLANKS
     C                   MOVE      '999'         KeySeqNum
     C                   ELSE
     C                   MOVE      DDDS38        KeySeqNum
     C                   ENDIF
      *
      **  Look for last 'SC' for the entered deal
      *
     C     DeamKey       SETGT     MMLVDMLL
     C     *IN25         DOUEQ     *ON
     C     HNMTYP        OREQ      'SC'
     C     HNFRCF        ANDEQ     'Y'
     C     HNDA38        ORNE      KeyDealNo
     C                   READP     MMLVDMLL                               25
     C                   ENDDO
      *
     C     HNMTYP        IFEQ      'SC'
     C     HNFRCF        ANDEQ     'Y'
     C     HNDA38        ANDEQ     KeyDealNo
     C                   Z-ADD     HNFSRP        WkFRatSprd
      *
      **  Or, if Interest Rate/Spread entered & no other 'SC' for deal,
      **  use original deal rate/spread
      *
     C                   ELSE
     C                   MOVE      '1'           *IN25
     C                   Z-ADD     H@FSRP        WkFRatSprd
     C                   ENDIF
     C                   ENDIF
      *
      **  Do not perform tolerance check if new eff. int. rate = 0
      *
     C     WkFRatSprd    IFEQ      0
     C                   MOVE      '0'           *IN24
     C                   GOTO      SRERA9
     C                   ENDIF
      *
      **  Calculate New Effective (Actual) Funding Rate
      *
     C     H@FSGN        IFEQ      *BLANKS
     C                   Z-ADD     WkFRatSprd    EffctvFRat
     C                   ELSE
     C     H@FSGN        IFEQ      '+'
     C     EffctvIrat    ADD       WkFRatSprd    EffctvFRat
     C                   ELSE
     C     EffctvIrat    SUB       WkFRatSprd    EffctvFRat
     C                   ENDIF
     C                   ENDIF
      *
     C     SRERA9        ENDSR
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
 
     C     *entry        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    Msgid1
     C                   PARM                    Msgid2
     C                   PARM                    WMsgid1
     C                   PARM                    DDMTYP
     C                   PARM                    DDFSRP
     C                   PARM                    DDINTR
     C                   PARM                    DDDLNO
     C                   PARM                    DDDS38
     C                   PARM                    DDCCY
     C                   PARM                    @VDYNO
     C                   PARM                    BNDCSP
     C                   PARM                    H@FPRC
     C                   PARM                    H@BSRC
     C                   PARM                    H@SPRD
     C                   PARM                    H@FSRP
     C                   PARM                    H@INTR
     C                   PARM                    H@FSGN
     C                   PARM                    DDIntrOK
     C                   PARM                    IGIRCF
     C                   PARM                    IGFRCF
     C                   PARM                    IGFSRP
     C                   PARM                    IGINTR
     C                   PARM                    BGN0ST                                       CDE002
 
     C** Define work fields
     C     *LIKE         DEFINE    @@Amt         ThisDMAmt
     C     *LIKE         DEFINE    IGINTR        WkIRatSprd
     C     *LIKE         DEFINE    IGFSRP        WkFRatSprd
     C     *LIKE         DEFINE    H@BSRC        WkBasRatCd
     C     *LIKE         DEFINE    BACBSR        WkBaseRate
     C     *LIKE         DEFINE    BACBSR        EffctvIRat
     C     *LIKE         DEFINE    BACBSR        EffctvFRat
 
     C** Key Lists.
     C     DeamKey       KLIST
     C                   KFLD                    KeyDealNo
     C                   KFLD                    KeyVdatYY
     C                   KFLD                    KeyVdatMM
     C                   KFLD                    KeyVdatDD
     C                   KFLD                    KeySeqNum
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
