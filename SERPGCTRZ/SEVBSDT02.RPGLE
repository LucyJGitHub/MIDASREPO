     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Buy-sell backs validate trade value date')    *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Validation Module                         *
      *                                                               *
      *  SEVBSDT02 - Validate Trade Value Date in Buy-Sell Back       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 13Dec01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CSE005             Date 20Jun00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE006  *CREATE    Date 01Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE074 - Const. Yld Amort. Upgrade to MidasPlus (Recompile)  *
      *  CSE071 - Multiple Holidays Re Securities                     *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CSE005 - Added  3 more Parameters  when calling  ZNCD  module*
      *           which were introduced in it  by this  amendment .   *
      *  CSE006 - Repurchase Agreements (REPOs) enhancement           *
      *                                                               *
      *****************************************************************
     FSECEO     IF   E           K DISK
     F                                     RENAME(SEDEVDF:SEDEVDO)
 
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
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Security Details
     D SECTY         E DS                  EXTNAME(SECTYD)
     D CDArr                 183    230
     D CRArr                 231    242
 
      ** External data structure for currency details.
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      **Second DS for access programs, long data structure.
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIx             S              3P 0
 
      ** Next Coupon Date
     D*NCD*******      S              5P 0                                                    CSE031
 
      ** Event Control Date (packed format)
     D ECD             S              5P 0
 
      ** Trade sold value date
     D TSTDVD          S              5S 0
 
      ** Trade purchased value date
     D TPTDVD          S              5S 0
 
      ** Back value date (run date minus back value period)
     D BckValDte       S              5S 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
 
     ISNDEVDF
     I              RECI                        SNDE_RECI
     ISEDEVDO
     I              RECI                        SEDE_RECI
     I              NMCY                        SEDE_NMCY
 
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   MOVE      *BLANK        WFldNmXAr
     C                   MOVE      *BLANK        WMsgIDXAr
     C                   MOVE      *BLANK        WMsgDtXAr
     C                   Z-ADD     0             WIx
 
      ** Clear output trade fields
 
     C                   Z-ADD     *ZERO         TPTDVD
     C                   Z-ADD     *ZERO         TSTDVD
      *
      ** Validate Trade Purchased Value Date
      *
     C                   EXSR      TPVAL
      *
      ** Validate Trade Sold Value Date
      *
     C                   EXSR      TSVAL
      *
      ** Cross validate both Value Dates
      *
     C                   EXSR      CROSSVAL
      *
      *
      ** If no errors, determine coupon rate and current factor
      *
     C                   IF        DDSTDVDok = 'Y' and DDPTDVDok = 'Y'
     C                   EXSR      DETCRCF
     C                   ENDIF
      *
      ** If an error was found, set the return code appropriately
      *
     C                   IF        DDSTDVDok = 'N' or DDPTDVDok = 'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * Return
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Trade Purchased Value Date
      *****************************************************************
     C     TPVAL         BEGSR
      *
      **  It must be a valid date
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDPTDVD       ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   PARM      6             ZADIG             2 0
 
     C     ZALIGNok      IFEQ      'Y'
     C                   MOVE      ZFIELD        ZDATEI
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATEI            6
     C                   PARM      *ZEROS        ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag         1
     C                   ENDIF
 
      * If either ZALIGN and ZDATE1 errors
 
     C     ZALIGNok      IFEQ      'N'
     C     ErrorFlag     OREQ      'Y'
     C                   MOVE      'N'           DDPTdvdOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPTDVD'     FldNamXAr(Idx)
     C                   MOVEL     'MMA0485'     MsgIdXAr(Idx)
     C                   GOTO      ETPVAL
     C                   ENDIF
      *
      * Update trade value date
      *
     C                   Z-ADD     ZDAYNO        TPTDVD
      *
      **   It must not be after maturity date or
      **   or before issue date of the security
      *
     C     MATY          IFNE      *ZEROS
     C     TPTDVD        ANDGT     MATY
     C     TPTDVD        ORLT      ISSD
     C                   MOVE      'N'           DDPTdvdOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPTDVD'     FldNamXAr(Idx)
     C                   MOVEL     'MMA0486'     MsgIdXAr(Idx)
     C                   END
      *
      **  It must fall within the back value period
      *
     C     TPTDVD        IFLT      BckValDte
     C                   MOVE      'N'           DDPTdvdOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPTDVD'     FldNamXAr(Idx)
     C                   MOVEL     'MMA0487'     MsgIdXAr(Idx)
     C                   ENDIF
      *
      **  If security is partly paid, it must not
      **  be before the most recent call date
      *
     C     PPDI          IFEQ      'Y'
     C     TPTDVD        ANDLT     SLCA
     C                   MOVE      'N'           DDPTdvdOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPTDVD'     FldNamXAr(Idx)
     C                   MOVEL     'MMA0487'     MsgIdXAr(Idx)
     C                   ENDIF
 
 
     C     ETPVAL        ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Trade Sold Value Date
      *****************************************************************
     C     TSVAL         BEGSR
      *
      **  It must be a valid date
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDSTDVD       ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   PARM      6             ZADIG             2 0
 
     C     ZALIGNok      IFEQ      'Y'
     C                   MOVE      ZFIELD        ZDATEI
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATEI            6
     C                   PARM      *ZEROS        ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag         1
     C                   END
 
      * If either ZALIGN and ZDATE1 errors
 
     C     ZALIGNok      IFEQ      'N'
     C     ErrorFlag     OREQ      'Y'
     C                   MOVE      'N'           DDSTDVDOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSTDVD'     FldNamXAr(Idx)
     C                   MOVEL     'MMA0485'     MsgIdXAr(Idx)
     C                   GOTO      ETSVAL
     C                   END
      *
      * Update trade value date
      *
     C                   Z-ADD     ZDAYNO        TSTDVD
      *
      **   It must not be after maturity date or
      **   or before issue date of the security
      *
     C     MATY          IFNE      *ZEROS
     C     TSTDVD        ANDGT     MATY
     C     TSTDVD        ORLT      ISSD
     C                   MOVE      'N'           DDSTDVDOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSTDVD'     FldNamXAr(Idx)
     C                   MOVEL     'MMA0486'     MsgIdXAr(Idx)
     C                   END
      *
      **  It must fall within the back value period
      *
     C     TSTDVD        IFLT      BckValDte
     C                   MOVE      'N'           DDSTDVDOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSTDVD'     FldNamXAr(Idx)
     C                   MOVEL     'MMA0487'     MsgIdXAr(Idx)
     C                   END
      *
      **  If security is partly paid, it must not
      **  be before the most recent call date
      *
     C     PPDI          IFEQ      'Y'
     C     TSTDVD        ANDLT     SLCA
     C                   MOVE      'N'           DDSTDVDOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSTDVD'     FldNamXAr(Idx)
     C                   MOVEL     'MMA0487'     MsgIdXAr(Idx)
     C                   END
 
 
     C     ETSVAL        ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** CROSSVAL - Cross validation on both Value Dates
      *****************************************************************
     C     CROSSVAL      BEGSR
 
      ** The two Value Dates cannot be the same
     C                   IF        TPTDVD = TSTDVD
      *
     C                   MOVE      'N'           DDPTDVDOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPTDVD'     FldNamXAr(Idx)
     C                   MOVEL     'MMA0722'     MsgIdXAr(Idx)
      *
     C                   MOVE      'N'           DDSTDVDOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSTDVD'     FldNamXAr(Idx)
     C                   MOVEL     'MMA0722'     MsgIdXAr(Idx)
      *
     C                   ELSE
      *
      ** If a coupon is due between the two Value Dates, and the ICD flag
      ** 'Repo coupon payment validation' is on, entry is NOT allowed.
      *
     C                   EXSR      SRZNCD                                                      10022
      *
     C                   IF        NCD > ECD and NCD < LaterDate
     C                             and BVRCPN = 'Y'
      *
     C                   MOVE      'N'           DDPTDVDOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPTDVD'     FldNamXAr(Idx)
     C                   MOVEL     'MMA0724'     MsgIdXAr(Idx)
      *
     C                   MOVE      'N'           DDSTDVDOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSTDVD'     FldNamXAr(Idx)
     C                   MOVEL     'MMA0724'     MsgIdXAr(Idx)
      *
     C                   ENDIF
      *
     C                   ENDIF
 
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** SRZNCD - Calculate Next Coupon Date
      *****************************************************************
     C     SRZNCD        BEGSR
 
     C                   IF        TPTDVD > TSTDVD
     C                   Z-ADD     TSTDVD        ECD
     C                   Z-ADD     TPTDVD        LaterDate         5 0
     C                   ELSE
     C                   Z-ADD     TPTDVD        ECD
     C                   Z-ADD     TSTDVD        LaterDate
     C                   ENDIF
 
     C                   CALLB     'ZNCD'
 
     C                   PARM                    ITLD
     C                   PARM                    FCPN
     C                   PARM                    MATY
     C                   PARM                    CDArr
     C                   PARM                    CRArr
     C                   PARM                    ECD
     C                   PARM                    BJDFIN
      *                                                                                       CSE005
      ** Nominal Currency                                                                     CSE005
      ** Security Investment Type                                                             CSE005
      ** Effect on Holidays on Coupon Dates                                                   CSE005
     C                   PARM                    NMCY              3                          CSE005
     C                   PARM                    SITP              3                          CSE005
     C                   PARM                    BCNV              1                          CSE005
      ** Last Coupon Date                                                                     CSE031
     C                   PARM                    LCPN                                         CSE031
     C                   PARM                    HCY1                                         CSE071
     C                   PARM                    HCY2                                         CSE071
     C                   PARM                    HCY3                                         CSE071
     C                   PARM                    HCY4                                         CSE071
     C                   PARM                    HCY5                                         CSE071
     C                   PARM                    HCY6                                         CSE071
     C                   PARM                    HCY7                                         CSE071
     C                   PARM                    HCY8                                         CSE071
     C                   PARM                    HCY9                                         CSE071
                                                                                              CSE005
     C                   PARM                    NCD
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** DETERMINE COUPON RATE AND CURRENT FACTOR
      *****************************************************************
     C     DETCRCF       BEGSR
      *
      * Coupon rate - Trade Purchased
      *
     C                   MOVE      SESN          SDSN
     C                   MOVE      'IR'          SDET
     C                   Z-ADD     TPTDVD        SDED
      *
     C     KLEVD         SETLL     SEDEVDO
     C                   READ      SEDEVDO                                44
      *
     C     *IN44         IFEQ      '0'
     C     SDSN          ANDEQ     SESN
     C     SDET          ANDEQ     'IR'
     C                   Z-ADD     SDNC          TPTDCR
     C                   ELSE
     C                   Z-ADD     CPNR          TPTDCR
     C                   ENDIF
      *
      * Current Factor - Trade Purchased
      *
     C     PROT          IFEQ      '8'
     C                   MOVE      SESN          SDSN
     C                   MOVE      'MP'          SDET
     C                   Z-ADD     TPTDVD        SDED
      *
     C     KLEVD         SETLL     SEDEVDO
     C                   READ      SEDEVDO                                44
      *
     C     *IN44         IFEQ      '0'
     C     SDSN          ANDEQ     SESN
     C     SDET          ANDEQ     'MP'
     C                   Z-ADD     SDCP          TPTCFC
     C                   ELSE
     C                   Z-ADD     CFCT          TPTCFC
     C                   ENDIF
      *
     C                   ENDIF
      *
      *
      * Coupon rate - Trade Sold
      *
     C                   MOVE      SESN          SDSN
     C                   MOVE      'IR'          SDET
     C                   Z-ADD     TSTDVD        SDED
      *
     C     KLEVD         SETLL     SEDEVDO
     C                   READ      SEDEVDO                                44
      *
     C     *IN44         IFEQ      '0'
     C     SDSN          ANDEQ     SESN
     C     SDET          ANDEQ     'IR'
     C                   Z-ADD     SDNC          TSTDCR
     C                   ELSE
     C                   Z-ADD     CPNR          TSTDCR
     C                   ENDIF
      *
      * Current Factor - Trade Sold
      *
     C     PROT          IFEQ      '8'
     C                   MOVE      SESN          SDSN
     C                   MOVE      'MP'          SDET
     C                   Z-ADD     TSTDVD        SDED
      *
     C     KLEVD         SETLL     SEDEVDO
     C                   READ      SEDEVDO                                44
      *
     C     *IN44         IFEQ      '0'
     C     SDSN          ANDEQ     SESN
     C     SDET          ANDEQ     'MP'
     C                   Z-ADD     SDCP          TSTCFC
     C                   ELSE
     C                   Z-ADD     CFCT          TSTCFC
     C                   ENDIF
      *
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Trade Screen fields
     C                   PARM                    DDPTDVD           7
     C                   PARM                    DDSTDVD           7
      *
      ** Security Details
      *
     C                   PARM                    SECTY
     C                   PARM                    PROT              1
      *
      ** ICD
     C                   PARM                    BJRDNB            5 0
     C                   PARM                    BJDFIN            1
     C                   PARM                    BVBVP             3 0
     C                   PARM                    BVRCPN            1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Trade Value Date - OK
     C                   PARM                    DDPTDVDok         1
     C                   PARM                    DDSTDVDok         1
      *
      ** Trade Value Dates
     C                   PARM                    TPTDVD
     C                   PARM                    TSTDVD
      *
      ** Trade Coupon Rates
      ** Trade Current Factors
     C                   PARM                    TPTDCR           11 7
     C                   PARM                    TPTCFC           10 9
 
     C                   PARM                    TSTDCR           11 7
     C                   PARM                    TSTCFC           10 9
 
 
      *  Calculate the back value date
      *
     C     BJRDNB        SUB       BVBVP         BckValDte
      *
      * Define key list for SECEO (SEDEVDO) Security Diary Events.
      *
     C     KLEVD         KLIST
     C                   KFLD                    SDSN
     C                   KFLD                    SDET
     C                   KFLD                    SDED
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
