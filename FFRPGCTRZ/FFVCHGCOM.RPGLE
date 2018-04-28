     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF validate customer')
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFVCHGCOM - Charges and Commissions.                         *
      *                                                               *
      *  Function:  This module validates the charges and commissions *
      *             fields for both broker and customer.              *
      *                                                               *
      * *NOTE* Although customer settlement fields are used below,    *
      *        this module can also be used to validate broker        *
      *        details. If the module is to be used for customer      *
      *        processing, XBRKI should have the value 'N'. Any       *
      *        other value signifies broker validation.               *
      *                                                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. BG9185             Date 08Nov05               *
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CFF007             Date 26Mar01               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 147775             Date 16Nov98               *
      *                 CAP004  *CREATE    Date 24Jun98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BG9185 - Correction to CGL029                                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CFF007 - Futures and Options Enhancement for Private Banking *
      *  147775 - General FF API fixes - (Pre-release unnanotated)    *
      *  CAP004 - Conversion of Midas inputs to APIs.                 *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas FF Charges/Commissions Details
     FCHGCM     IF   E           K DISK
                                                                                              CFF007
      ** Midas FF Customer/broker instrument defaults                                         CFF007
     FDEFLT     IF   E           K DISK                                                       CFF007
 
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
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
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
                                                                                              CFF007
     D RNG             S              5S 0 DIM(9) INZ(*Zeros)                                 CFF007
                                                                                              CFF007
     D AMT             S             13S 0 DIM(9) INZ(*Zeros)                                 CFF007
 
     D FFVSETL       E DS                  EXTNAME(FFVSETLPD)
      ** The valid settlement (and charges and commissions) details
 
     D FFEBSETPD     E DS                  EXTNAME(FFEBSETPD)
      * Broker settlement OK flags
 
     D FFECSETPD     E DS                  EXTNAME(FFECSETPD)
      * Customer settlement OK flags
 
     D FFCSETPD      E DS                  EXTNAME(FFCSETPD)
      * Customer settlement format definition
 
      * Customer/Broker commission code (standard and same day)
     D  SBCM                   1      4
 
      * Customer/Broker commission amount
     D  SCCMA1                 5      5
     D  SCCMA2                 6     18
 
      ** External data structure for currency details.
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      **Second DS for access programs, long data structure.
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Flag which indicates whether the validation processing is
      ** for the customer or broker (1A)
     D XBRKI           S              1A
 
      ** Charge Code flag
     D OKXCHC          S              1A
 
      ** Charge Amount flag
     D OKXCHA          S              1A
 
      ** Standard Charge Code
     D OKXCMC          S              1A
 
      ** Same Day Charge Code
     D OKXCMS          S              1A
 
      ** Same Day Charge Code
     D OKXCMA          S              1A
 
      ** Return flag from ZAlign
     D ZAlignOK        S              1A
 
      ** Alpha field to be validated or edited by ZAlign
     D ZFIELD          S             16A
 
      ** Number of decimal places for validation or editing
     D Decimals        S              1P 0
 
      ** Number of integers for validation
     D Integers        S              2P 0
 
      ** Commission code - key for reading LF/CHGCM
     D KCGCM           S              2S 0
 
      ** Instrument currency - key for reading LF/CHGCM
     D KCCY            S              3A
                                                                                              CFF007
      ** Broker/Customer Chg/Comms. Pattern                                                   CFF007
     D PCPTI           S              1A                                                      CFF007
                                                                                              CFF007
      ** Work field Broker/Customer Chg/Comms. Pattern                                        CFF007
     D WWCPT           S              1A                                                      CFF007
                                                                                              CFF007
      ** Work field Broker/Customer Chg/Comms. Pattern                                        CFF007
     D WCPT            S              1A                                                      CFF007
                                                                                              CFF007
      ** Number of Contracts                                                                  CFF007
     D PNUCO           S              5P 0                                                    CFF007
 
      ** Work field for commission amount
     D WXCMA           S                   LIKE(CCMA)
 
      ** Work field for charges amount
     D WXCHA           S                   LIKE(CCHA)
 
      ** Work field for initial margin.
     D WXMAR           S             13  0
 
      ** Numeric version of ZFIELD.
     D ZFldAmt         S             13  0
                                                                                              CFF007
      ** Number of decimal position                                                           CFF007
     D ZADEC           S              1P 0                                                    CFF007
                                                                                              CFF007
      ** Private Banking Customer Indicator                                                   CFF007
     D PPBFLG          S              1A                                                      CFF007
 
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
      ** MsgDtaXArr, XIdx; and to warning message handling: WarnFound,
      ** FldNamWArr, MsgIDWArr, MsgDtaWArr, WIdx.
      ** It therefore requires FVAL_ARRAY and STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_RESET
      **--------------------------------------------------------------------------------------------
     ** Resets
     ** ~~~~~~
     C                   EVAL      OKXCHC    = 'Y'
     C                   EVAL      OKXCHA    = 'Y'
     C                   EVAL      OKXCMC    = 'Y'
     C                   EVAL      OKXCMS    = 'Y'
     C                   EVAL      OKXCMA    = 'Y'
      *                                                                                       CFF007
      ** Determine Commission Pattern                                                         CFF007
      *                                                                                       CFF007
     C     CFF007        IFEQ      'Y'                                                        CFF007
     C                   EXSR      SRCMPAT                                                    CFF007
     C                   ENDIF                                                                CFF007
 
      ** Determine instrument currency decimal places
 
     C                   EXSR      DetInCcyDP
 
     C                   Z-ADD     0             ZFldAmt
     C                   Z-ADD     0             WXCMA
     C                   Z-ADD     0             WXCHA
     C                   Z-ADD     0             WXMAR
 
      **   1. Commission Code: Standard
      **      ~~~~~~~~~~~~~~~~~~~~~~~~~
     C     SCCMC         IFNE      '  '
     C                   TESTN                   SCCMC                75
 
      **   If Not Numeric
     C     *IN75         IFEQ      '0'
     C                   MOVE      'N'           OKXCMC
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
 
      **   Broker or Customer error processing
 
     C     XBRKI         IFEQ      'N'
     C                   EVAL      FldNamXArr(XIdx) = 'SCCMC'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0438'
     C                   EVAL      OKCCMC = 'N'
     C                   ELSE
 
     C                   EVAL      FldNamXArr(XIdx) = 'SBCMC'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0431'
     C                   EVAL      OKBCMC = 'N'
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      SCCMC         KCGCM
 
     C     KCHGCM        CHAIN     CHGCM                              71
     C  N71RECI          COMP      'D'                                7171
 
      **   - invalid
 
     C     *IN71         IFEQ      '1'
     C                   MOVE      'N'           OKXCMC
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
 
      **   Broker or Customer error processing
 
     C     XBRKI         IFEQ      'N'
     C                   EVAL      FldNamXArr(XIdx) = 'SCCMC'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0438'
     C                   EVAL      OKCCMC = 'N'
     C                   ELSE
 
     C                   EVAL      FldNamXArr(XIdx) = 'SBCMC'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0431'
     C                   EVAL      OKBCMC = 'N'
     C                   ENDIF
     C                   END
 
     C                   END
 
     C                   END
 
      **   2. Commission Code: Same day
      **      ~~~~~~~~~~~~~~~~~~~~~~~~~
     C     SCCMS         IFNE      '  '
 
     C                   TESTN                   SCCMS                75
      **   If Not Numeric
     C     *IN75         IFEQ      '0'
     C                   MOVE      'N'           OKXCMS
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
 
      **   Broker or Customer error processing
 
     C     XBRKI         IFEQ      'N'
     C                   EVAL      FldNamXArr(XIdx) = 'SCCMS'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0439'
     C                   EVAL      OKCCMS = 'N'
     C                   ELSE
 
     C                   EVAL      FldNamXArr(XIdx) = 'SBCMS'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0432'
     C                   EVAL      OKBCMS = 'N'
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      SCCMS         KCGCM
 
     C     KCHGCM        CHAIN     CHGCM                              71
     C  N71RECI          COMP      'D'                                7171
 
      **   - invalid
 
     C     *IN71         IFEQ      '1'
     C                   MOVE      'N'           OKXCMS
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
 
      **   Broker or Customer error processing
 
     C     XBRKI         IFEQ      'N'
     C                   EVAL      FldNamXArr(XIdx) = 'SCCMS'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0439'
     C                   EVAL      OKCCMS = 'N'
     C                   ELSE
 
     C                   EVAL      FldNamXArr(XIdx) = 'SBCMS'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0432'
     C                   EVAL      OKBCMS = 'N'
     C                   ENDIF
     C                   END
 
     C                   END
 
     C                   END
 
      **   3. Commission Code - cross-check
      **      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     C     OKXCMC        IFEQ      'Y'
     C     OKXCMS        ANDEQ     'Y'
 
      **   - if one entered, the other must also be entered
     C                   IF        SCCMC <> *blanks AND SCCMS = *blanks
     C                   MOVE      'N'           OKXCMC
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
 
      **   Broker or Customer error processing
 
     C     XBRKI         IFEQ      'N'
     C                   EVAL      FldNamXArr(XIdx) = 'SCCMC'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0438'
     C                   EVAL      OKCCMC = 'N'
     C                   ELSE
 
     C                   EVAL      FldNamXArr(XIdx) = 'SBCMC'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0431'
     C                   EVAL      OKBCMC = 'N'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SCCMS <> *blanks AND SCCMC = *blanks
     C                   MOVE      'N'           OKXCMS
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
 
      **   Broker or Customer error processing
 
     C     XBRKI         IFEQ      'N'
     C                   EVAL      FldNamXArr(XIdx) = 'SCCMC'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0439'
     C                   EVAL      OKCCMS = 'N'
     C                   ELSE
 
     C                   EVAL      FldNamXArr(XIdx) = 'SBCMC'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0432'
     C                   EVAL      OKBCMS = 'N'
     C                   ENDIF
 
     C                   END
 
     C                   END
 
      **   4. Commission Amount
      **      ~~~~~~~~~~~~~~~~~
     C     SCCMA         IFNE      *BLANKS
 
     C     SCCMA1        IFEQ      'A'
 
     C     SCCMA2        IFNE      *BLANKS
     C                   MOVE      'N'           OKXCMA
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
 
      **   Broker or Customer error processing
 
     C     XBRKI         IFEQ      'N'
     C                   EVAL      FldNamXArr(XIdx) = 'SCCMA'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0440'
     C                   EVAL      OKCCMA = 'N'
 
     C                   ELSE
     C                   EVAL      FldNamXArr(XIdx) = 'SBCMA'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0433'
     C                   EVAL      OKBCMA = 'N'
 
     C                   ENDIF
 
     C                   END
 
     C                   ELSE
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      SCCMA         ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZAlignOK
     C                   PARM                    ZFIELD
     C                   PARM                    Decimals
     C                   PARM                    Integers
      **   - invalid
     C     ZAlignOK      IFEQ      'N'
     C                   MOVE      'N'           OKXCMA
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
 
      **   Broker or Customer error processing
 
     C     XBRKI         IFEQ      'N'
     C                   EVAL      FldNamXArr(XIdx) = 'SCCMA'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0440'
     C                   EVAL      OKCCMA = 'N'
     C                   ELSE
 
     C                   EVAL      FldNamXArr(XIdx) = 'SBCMA'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0433'
     C                   EVAL      OKBCMA = 'N'
     C                   ENDIF
      **   - valid
     C                   ELSE
     C                   MOVE      ZFIELD        ZFldAmt
     C                   EVAL      WXCMA = ZFldAmt
 
     C     ZFldAmt       IFEQ      0
     C                   MOVE      *BLANK        SCCMA
     C                   ELSE
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    Decimals
     C                   MOVE      ZFIELD        SCCMA
     C                   END
 
     C                   END
 
     C                   END
 
     C                   END
 
      **   5. Commission Codes + Amount
      **      ~~~~~~~~~~~~~~~~~~~~~~~~~
     C     OKXCMC        IFEQ      'Y'
     C     OKXCMS        ANDEQ     'Y'
     C     OKXCMA        ANDEQ     'Y'
 
     C     SCCMA1        IFEQ      'A'
 
      **   - codes must be entered
 
     C     SBCM          IFEQ      *BLANK
     C                   MOVE      'N'           OKXCMC
     C                   MOVE      'N'           OKXCMS
     C                   MOVE      'N'           OKXCMA
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
 
      **   Broker or Customer error processing
 
     C     XBRKI         IFEQ      'N'
     C                   EVAL      FldNamXArr(XIdx) = 'SCCMC'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0441'
     C                   EVAL      OKCCMC = 'N'
     C                   ELSE
 
     C                   EVAL      FldNamXArr(XIdx) = 'SBCMC'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0434'
     C                   EVAL      OKBCMC = 'N'
     C                   ENDIF
     C                   END
 
     C                   ELSE
 
      **   - codes and amount cannot both be entered
 
     C     SBCM          IFNE      *BLANK
     C     SCCMA         ANDNE     *BLANK
     C     PPBFLG        ANDNE     'Y'                                                        CFF007
     C     SBCM          ORNE      *BLANK                                                     CFF007
     C     SCCMA         ANDNE     *BLANK                                                     CFF007
     C     CFF007        ANDNE     'Y'                                                        CFF007
     C                   MOVE      'N'           OKXCMC
     C                   MOVE      'N'           OKXCMS
     C                   MOVE      'N'           OKXCMA
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
 
      **   Broker or Customer error processing
 
     C     XBRKI         IFEQ      'N'
     C                   EVAL      FldNamXArr(XIdx) = 'SCCMC'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0441'
     C                   EVAL      OKCCMC = 'N'
     C                   ELSE
 
     C                   EVAL      FldNamXArr(XIdx) = 'SBCMC'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0434'
     C                   EVAL      OKBCMC = 'N'
     C                   ENDIF
                                                                                              CFF007
     C                   ELSE                                                                 CFF007
                                                                                              CFF007
     C     CFF007        IFEQ      'Y'                                                        CFF007
     C     PPBFLG        ANDEQ     'Y'                                                        CFF007
                                                                                              CFF007
     C     SBCM          IFEQ      *BLANK                                                     CFF007
     C     SCCMA         ANDNE     *BLANK                                                     CFF007
     C                   MOVE      'N'           OKXCMC                                       CFF007
     C                   MOVE      'N'           OKXCMS                                       CFF007
     C                   MOVE      'N'           OKXCMA                                       CFF007
     C                   EVAL      ErrorFound = 'Y'                                           CFF007
     C                   EVAL      XIdx = XIdx + 1                                            CFF007
      *                                                                                       CFF007
      ** Broker or Customer error processing                                                  CFF007
      *                                                                                       CFF007
     C     XBRKI         IFEQ      'N'                                                        CFF007
     C                   EVAL      FldNamXArr(XIdx) = 'SCCMC'                                 CFF007
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA1168'                                CFF007
     C                   EVAL      OKCCMC = 'N'                                               CFF007
                                                                                              CFF007
     C                   ELSE                                                                 CFF007
     C                   EVAL      FldNamXArr(XIdx) = 'SBCMC'                                 CFF007
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA1169'                                CFF007
     C                   EVAL      OKBCMC = 'N'                                               CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
     C                   ELSE                                                                 CFF007
                                                                                              CFF007
     C     SBCM          IFNE      *BLANK                                                     CFF007
     C     SCCMC         ANDEQ     SCCMS                                                      CFF007
                                                                                              CFF007
     C     WCPT          IFEQ      'S'                                                        CFF007
     C     WCPT          OREQ      'H'                                                        CFF007
     C     WCPT          OREQ      'A'                                                        CFF007
     C                   Z-ADD     PNUCO         WCONO             5 0                        CFF007
     C                   MOVE      SCCMC         CGCM                                         CFF007
     C                   Z-ADD     *zeros        WRATA            13 0                        CFF007
                                                                                              CFF007
     C     WCONO         IFNE      *zeros                                                     CFF007
     C     CGCM          ANDNE     *zeros                                                     CFF007
     C                   EXSR      SRTTFC                                                     CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
     C     WRATA         IFNE      *zeros                                                     CFF007
     C                   MOVE      WRATA         ZFIELD                                       CFF007
     C                   Z-ADD     DECIMALS      ZADEC                                        CFF007
                                                                                              CFF007
     C                   CALLB     'ZEDIT'                              99                    CFF007
     C                   PARM                    ZFIELD                                       CFF007
     C                   PARM                    ZADEC                                        CFF007
                                                                                              CFF007
     C     *IN99         IFEQ      '1'                                                        CFF007
     C                   EXSR      *PSSR                                                      CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
     C                   MOVE      ZFIELD        ZXCMA            14                          CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
     C     SCCMA         IFEQ      *blanks                                                    CFF007
     C                   Z-ADD     WRATA         WXCMA                                        CFF007
     C                   MOVE      ZXCMA         SCCMA                                        CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
     C     XBRKI         IFEQ      'Y'                                                        CFF007
     C                   MOVE      'Y'           CMCB                                         CFF007
     C                   ELSE                                                                 CFF007
     C                   MOVE      'Y'           CMCC                                         CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
     C                   ENDIF                                                                CFF007
     C                   ENDIF                                                                CFF007
     C                   ENDIF                                                                CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
     C                   END
 
     C                   END
 
     C                   END
 
      **   6. Charge Code
      **      ~~~~~~~~~~~
     C     SCCHC         IFNE      '  '
 
     C                   TESTN                   SCCHC                75
 
      **   If Not Numeric
 
     C     *IN75         IFEQ      '0'
     C                   MOVE      'N'           OKXCHC
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
 
      **   Broker or Customer error processing
 
     C     XBRKI         IFEQ      'N'
     C                   EVAL      FldNamXArr(XIdx) = 'SCCHC'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0442'
     C                   EVAL      OKCCHC = 'N'
     C                   ELSE
 
     C                   EVAL      FldNamXArr(XIdx) = 'SBCHC'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0435'
     C                   EVAL      OKBCHC = 'N'
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      SCCHC         KCGCM
 
     C     KCHGCM        CHAIN     CHGCM                              71
     C  N71RECI          COMP      'D'                                7171
 
      **   - invalid
 
     C     *IN71         IFEQ      '1'
     C                   MOVE      'N'           OKXCHC
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
 
      **   Broker or Customer error processing
 
     C     XBRKI         IFEQ      'N'
     C                   EVAL      FldNamXArr(XIdx) = 'SCCHC'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0442'
     C                   EVAL      OKCCHC = 'N'
     C                   ELSE
 
     C                   EVAL      FldNamXArr(XIdx) = 'SBCHC'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0435'
     C                   EVAL      OKBCHC = 'N'
     C                   ENDIF
     C                   END
 
     C                   END
 
     C                   END
 
      **   7. Charge Amount
      **      ~~~~~~~~~~~~~
     C     SCCHA         IFNE      *BLANKS
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      SCCHA         ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZAlignOK
     C                   PARM                    ZFIELD
     C                   PARM                    Decimals
     C                   PARM                    Integers
 
      **   - invalid
 
     C     ZAlignOK      IFEQ      'N'
     C                   MOVE      'N'           OKXCHA
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
 
      **   Broker or Customer error processing
 
     C     XBRKI         IFEQ      'N'
     C                   EVAL      FldNamXArr(XIdx) = 'SCCHA'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0443'
     C                   EVAL      OKCCHA = 'N'
     C                   ELSE
 
     C                   EVAL      FldNamXArr(XIdx) = 'SBCHA'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0436'
     C                   EVAL      OKBCHA = 'N'
     C                   ENDIF
      **   - valid
     C                   ELSE
     C                   MOVE      ZFIELD        ZFldAmt
     C                   EVAL      WXCHA = ZFldAmt
 
     C     ZFldAmt       IFEQ      0
     C                   MOVE      *BLANK        SCCHA
     C                   ELSE
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    Decimals
     C                   MOVE      ZFIELD        SCCHA
     C                   END
 
     C                   END
 
     C                   END
 
      **   8. Charge Code + Amount
      **      ~~~~~~~~~~~~~~~~~~~~
     C     OKXCHC        IFEQ      'Y'
     C     OKXCHA        ANDEQ     'Y'
 
      **   - code and amount cannot both be entered
 
     C     SCCHC         IFNE      *BLANK
     C     SCCHA         ANDNE     *BLANK
     C     PPBFLG        ANDNE     'Y'                                                        CFF007
     C     SCCHC         ORNE      *BLANK                                                     CFF007
     C     SCCHA         ANDNE     *BLANK                                                     CFF007
     C     CFF007        ANDNE     'Y'                                                        CFF007
     C                   MOVE      'N'           OKXCHC
     C                   MOVE      'N'           OKXCHA
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
 
      **   Broker or Customer error processing
 
     C     XBRKI         IFEQ      'N'
     C                   EVAL      FldNamXArr(XIdx) = 'SCCHC'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0444'
     C                   EVAL      OKCCHC = 'N'
     C                   ELSE
 
     C                   EVAL      FldNamXArr(XIdx) = 'SBCHC'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0437'
     C                   EVAL      OKBCHC = 'N'
     C                   ENDIF
      *                                                                                       CFF007
     C                   ELSE                                                                 CFF007
      *                                                                                       CFF007
     C     CFF007        IFEQ      'Y'                                                        CFF007
     C     PPBFLG        ANDEQ     'Y'                                                        CFF007
      *                                                                                       CFF007
     C     SCCHC         IFEQ      *BLANK                                                     CFF007
     C     SCCHA         ANDNE     *BLANK                                                     CFF007
     C                   MOVE      'N'           OKXCMC                                       CFF007
     C                   MOVE      'N'           OKXCMS                                       CFF007
     C                   MOVE      'N'           OKXCMA                                       CFF007
     C                   EVAL      ErrorFound = 'Y'                                           CFF007
     C                   EVAL      XIdx = XIdx + 1                                            CFF007
                                                                                              CFF007
      **   Broker or Customer error processing                                                CFF007
                                                                                              CFF007
     C     XBRKI         IFEQ      'N'                                                        CFF007
     C                   EVAL      FldNamXArr(XIdx) = 'SCCHC'                                 CFF007
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA1170'                                CFF007
     C                   EVAL      OKCCHC = 'N'                                               CFF007
     C                   ELSE                                                                 CFF007
                                                                                              CFF007
     C                   EVAL      FldNamXArr(XIdx) = 'SBCHC'                                 CFF007
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA1171'                                CFF007
     C                   EVAL      OKBCHC = 'N'                                               CFF007
     C                   ENDIF                                                                CFF007
     C                   ELSE                                                                 CFF007
                                                                                              CFF007
     C     SCCHC         IFNE      *BLANK                                                     CFF007
                                                                                              CFF007
     C                   Z-ADD     PNUCO         WCONO             5 0                        CFF007
     C                   MOVE      SCCHC         CGCM                                         CFF007
     C                   Z-ADD     *zeros        WRATA            13 0                        CFF007
                                                                                              CFF007
     C     WCONO         IFNE      *zeros                                                     CFF007
     C     CGCM          ANDNE     *zeros                                                     CFF007
     C                   EXSR      SRTTFC                                                     CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
     C     WRATA         IFNE      *zeros                                                     CFF007
     C                   MOVE      WRATA         ZFIELD                                       CFF007
     C                   Z-ADD     DECIMALS      ZADEC                                        CFF007
                                                                                              CFF007
     C                   CALLB     'ZEDIT'                              99                    CFF007
     C                   PARM                    ZFIELD                                       CFF007
     C                   PARM                    ZADEC                                        CFF007
                                                                                              CFF007
     C     *IN99         IFEQ      '1'                                                        CFF007
     C                   EXSR      *PSSR                                                      CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
     C                   MOVE      ZFIELD        ZXCHA            14                          CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
     C     SCCHA         IFEQ      *blanks                                                    CFF007
     C                   Z-ADD     WRATA         WXCHA                                        CFF007
     C                   MOVE      ZXCHA         SCCHA                                        CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
     C     XBRKI         IFEQ      'Y'                                                        CFF007
     C                   MOVE      'Y'           CHCB                                         CFF007
     C                   ELSE                                                                 CFF007
     C                   MOVE      'Y'           CHCC                                         CFF007
     C                   ENDIF                                                                CFF007
     C                   ENDIF                                                                CFF007
     C                   ENDIF                                                                CFF007
     C                   ENDIF                                                                CFF007
     C                   END
 
     C                   END
      **   9. Validate Broker/Customer Initial Margin
      **      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     C                   Z-ADD     0             WXMAR
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVE      SCMAR         ZFIELD
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZAlignOK
     C                   PARM                    ZFIELD
     C                   PARM                    Decimals
     C                   PARM                    Integers
 
      **   - invalid
 
     C     ZAlignOk      IFEQ      'N'
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
 
     C     XBRKI         IFEQ      'N'
     C                   EVAL      FldNamXArr(XIdx) = 'SCMAR'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0533'
     C                   EVAL      OKCMAR = 'N'
     C                   ELSE
 
     C                   EVAL      FldNamXArr(XIdx) = 'SBMAR'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0534'
     C                   EVAL      OKBMAR = 'N'
     C                   ENDIF
 
      **   - valid
 
     C                   ELSE
     C                   MOVE      ZFIELD        WXMAR
 
      **    - if Margin is input as zero, store it as -1
      **    - if Margin is input as blank, store it as zero
 
     C     SCMAR         IFNE      *BLANK
 
     C     WXMAR         IFEQ      *ZERO
     C                   Z-SUB     1             WXMAR
     C                   END
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    Decimals
 
     C                   MOVE      ZFIELD        SCMAR
 
     C                   END
 
     C                   END
 
      ** If there have been no errors, set up the valid settlements
      ** (charges and commisions) file details for customer or broker, as
      ** appropriate.
     C                   IF        XIdx = 0
     C                   IF        XBRKI = 'N'
 
     C                   EXSR      SetupVCust
 
     C                   ELSE
 
     C                   EXSR      SetupVBrok
 
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
      * DetInCcyDP - Determine instrument currency decimal places     *
      *                                                               *
      *****************************************************************
 
     C     DetInCcyDP    BEGSR
 
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR'      @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      KCCY          @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   Z-ADD     A6NBDP        Decimals
     C     13            SUB       A6NBDP        Integers
 
     C                   ENDSR
      *****************************************************************                       CFF007
      /EJECT                                                                                  CFF007
      *****************************************************************                       CFF007
      *                                                               *                       CFF007
      * SRCMPAT - Determine Broker Commission Pattern                 *                       CFF007
      *                                                               *                       CFF007
      *****************************************************************                       CFF007
                                                                                              CFF007
     C     SRCMPAT       BEGSR                                                                CFF007
                                                                                              CFF007
     C     KDEFLT        KLIST                                                                CFF007
     C*******            KFLD                    KCBCD             6 0                CFF007  CSD027
     C                   KFLD                    KCBCD             6                          CSD027
     C                   KFLD                    KMRKT             2                          CFF007
     C                   KFLD                    KISTC             3                          CFF007
      *                                                                                       CFF007
      **  If a Commssion Amount Entered, or = 'A'                                             CFF007
      *                                                                                       CFF007
     C     SCCMA         IFNE      *Blanks                                                    CFF007
     C     SCCMA1        OREQ      'A'                                                        CFF007
     C                   EVAL      WCPT = 'A'                                                 CFF007
     C                   ELSE                                                                 CFF007
      *                                                                                       CFF007
      **  Commission Amount blank                                                             CFF007
      **  - If Commission Codes not enterd                                                    CFF007
      *                                                                                       CFF007
     C     SCCMC         IFEQ      *Blanks                                                    CFF007
     C     SCCMS         ANDEQ     *Blanks                                                    CFF007
     C                   EVAL      WCPT = *Blanks                                             CFF007
     C                   ELSE                                                                 CFF007
      *                                                                                       CFF007
      **   - Commssion Codes entered                                                          CFF007
      *                                                                                       CFF007
     C     SACTN         IFEQ      'A'                                                        CFF007
     C                   EVAL      WCPT = *Blanks                                             CFF007
     C                   MOVEL     SBOCO         KCBCD                                        CFF007
                                                                                              CFF007
     C     Kdeflt        CHAIN     DEFLT                              71                      CFF007
                                                                                              CFF007
     C     *IN71         IFEQ      FALSE                                                      CFF007
     C     RECI          ANDEQ     'D'                                                        CFF007
     C     CPAT          ANDNE     *BLANKS                                                    CFF007
     C                   EVAL      WWCPT = CPAT                                               CFF007
     C                   ELSE                                                                 CFF007
     C                   EVAL      WWCPT = PCPTI                                              CFF007
     C                   ENDIF                                                                CFF007
     C                   ENDIF                                                                CFF007
      *                                                                                       CFF007
      **  - Use default value if exists, otherwise 'A'                                        CFF007
      *                                                                                       CFF007
     C     WWCPT         IFNE      *BLANKS                                                    CFF007
     C                   MOVE      WWCPT         WCPT                                         CFF007
     C                   ELSE                                                                 CFF007
     C                   MOVE      'A'           WCPT                                         CFF007
     C                   ENDIF                                                                CFF007
     C                   ENDIF                                                                CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
     C                   ENDSR                                                                CFF007
      *****************************************************************                       CFF007
      /EJECT                                                                                  CFF007
      *****************************************************************                       CFF007
      *                                                               *                       CFF007
      * SRTTFC - To Calculate Tier, Threshold or Flat Rate            *                       CFF007
      *                                                               *                       CFF007
      *****************************************************************                       CFF007
                                                                                              CFF007
     C     SRTTFC        BEGSR                                                                CFF007
                                                                                              CFF007
     C                   Z-ADD     CGCM          KCGCM                                        CFF007
                                                                                              CFF007
     C     KCHGCM        CHAIN     CHGCM                              71                      CFF007
      *                                                                                       CFF007
      ** Locate the Highest valued charged range lower limit on CHGCM                         CFF007
      ** Whose value is less than or equal to the contract number                             CFF007
      *                                                                                       CFF007
     C                   Z-ADD     LR01          RNG(1)                                       CFF007
     C                   Z-ADD     LR02          RNG(2)                                       CFF007
     C                   Z-ADD     LR03          RNG(3)                                       CFF007
     C                   Z-ADD     LR04          RNG(4)                                       CFF007
     C                   Z-ADD     LR05          RNG(5)                                       CFF007
     C                   Z-ADD     LR06          RNG(6)                                       CFF007
     C                   Z-ADD     LR07          RNG(7)                                       CFF007
     C                   Z-ADD     LR08          RNG(8)                                       CFF007
     C                   Z-ADD     LR09          RNG(9)                                       CFF007
                                                                                              CFF007
     C                   Z-ADD     CA01          AMT(1)                                       CFF007
     C                   Z-ADD     CA02          AMT(2)                                       CFF007
     C                   Z-ADD     CA03          AMT(3)                                       CFF007
     C                   Z-ADD     CA04          AMT(4)                                       CFF007
     C                   Z-ADD     CA05          AMT(5)                                       CFF007
     C                   Z-ADD     CA06          AMT(6)                                       CFF007
     C                   Z-ADD     CA07          AMT(7)                                       CFF007
     C                   Z-ADD     CA08          AMT(8)                                       CFF007
     C                   Z-ADD     CA09          AMT(9)                                       CFF007
                                                                                              CFF007
     C                   Z-ADD     9             Y                 1 0                        CFF007
     C                   MOVE      'N'           WFOUND            1                          CFF007
                                                                                              CFF007
     C     WFOUND        DOWEQ     'N'                                                        CFF007
     C     Y             ANDGT     1                                                          CFF007
                                                                                              CFF007
     C     RNG(Y)        IFNE      0                                                          CFF007
     C     RNG(Y)        ANDLE     WCONO                                                      CFF007
     C                   MOVE      'Y'           WFOUND            1                          CFF007
     C                   ELSE                                                                 CFF007
     C                   SUB       1             Y                                            CFF007
     C                   ENDIF                                                                CFF007
     C                   ENDDO                                                                CFF007
      *                                                                                       CFF007
      **  If charges are Tiered                                                               CFF007
      *                                                                                       CFF007
     C     TTFI          IFEQ      'T'                                                        CFF007
     C     WCONO         SUB       RNG(Y)        WWCONO            5 0                        CFF007
     C                   ADD       1             WWCONO                                       CFF007
     C     WWCONO        MULT      AMT(Y)        WRATA                                        CFF007
                                                                                              CFF007
     C     Y             DOWGE     2                                                          CFF007
     C     Y             SUB       1             Z                 1 0                        CFF007
     C     RNG(Y)        SUB       RNG(Z)        WWRATA           13 0                        CFF007
     C                   ADD       WWRATA        WRATA                                        CFF007
     C                   SUB       1             Y                                            CFF007
     C                   ENDDO                                                                CFF007
     C                   ENDIF                                                                CFF007
      *                                                                                       CFF007
      **  If charges are Threshold                                                            CFF007
      *                                                                                       CFF007
     C     TTFI          IFEQ      'X'                                                        CFF007
     C     WCONO         MULT      AMT(Y)        WRATA                                        CFF007
     C                   ENDIF                                                                CFF007
      *                                                                                       CFF007
      **  If charges are Flat                                                                 CFF007
      *                                                                                       CFF007
     C     TTFI          IFEQ      'F'                                                        CFF007
     C                   Z-ADD     AMT(Y)        WRATA                                        CFF007
     C                   ENDIF                                                                CFF007
      *                                                                                       CFF007
      **  If Rate amount < MIN Charge commission                                              CFF007
      *                                                                                       CFF007
     C     WRATA         IFLT      MINC                                                       CFF007
     C     MINC          ANDNE     0                                                          CFF007
     C                   Z-ADD     MINC          WRATA                                        CFF007
     C                   ENDIF                                                                CFF007
      *                                                                                       CFF007
      **  If Rate amount > MAX Charge commission                                              CFF007
      *                                                                                       CFF007
     C     WRATA         IFGT      MAXC                                                       CFF007
     C     MAXC          ANDNE     0                                                          CFF007
     C                   Z-ADD     MAXC          WRATA                                        CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
     C                   ENDSR                                                                CFF007
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SetupVCust - Set up valid fields for customer charges and     *
      *              commissions                                      *
      *                                                               *
      *****************************************************************
 
     C     SetupVCust    BEGSR
 
      ** Opening contracts standard
     C                   Z-ADD     0             OCSC
 
      ** Opening contracts same day
     C                   Z-ADD     0             OCDC
 
      ** Closing contracts standard
     C                   Z-ADD     0             CCSC
 
      ** Closing contracts same day
     C                   Z-ADD     0             CCDC
 
      ** Standard contracts posted
     C                   Z-ADD     0             CPSC
 
      ** Same day contracts posted
     C                   Z-ADD     0             CPDC
 
      ** Charges posted
     C                   Z-ADD     0             CCHP
 
      ** Commissions posted
     C                   Z-ADD     0             CCMP
 
      ** Customer commission code
     C                   MOVE      SCCMC         CCMC
 
      ** Customer commission code - same day
     C                   MOVE      SCCMS         CCMS
 
      ** Customer commission amount
     C                   Z-ADD     WXCMA         CCMA
 
      ** Customer charges code
     C                   MOVE      SCCHC         CCHC
 
      ** Customer charges amount
     C                   Z-ADD     WXCHA         CCHA
 
      ** Customer margin
     C                   Z-ADD     WXMAR         CMAR
 
     C                   ENDSR
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SetupVBrok - Set up valid fields for broker charges and       *
      *              commissions                                      *
      *                                                               *
      *****************************************************************
 
     C     SetupVBrok    BEGSR
 
      ** Opening contracts standard
     C                   Z-ADD     0             OCSB
 
      ** Opening contracts same day
     C                   Z-ADD     0             OCDB
 
      ** Closing contracts standard
     C                   Z-ADD     0             CCSB
 
      ** Closing contracts same day
     C                   Z-ADD     0             CCDB
 
      ** Standard contracts posted
     C                   Z-ADD     0             CPSB
 
      ** Same day contracts posted
     C                   Z-ADD     0             CPDB
 
      ** Charges posted
     C                   Z-ADD     0             BCHP
 
      ** Commissions posted
     C                   Z-ADD     0             BCMP
 
      ** Broker commission code
     C                   MOVE      SCCMC         BCMC
 
      ** Broker commission code - same day
     C                   MOVE      SCCMS         BCMS
 
      ** Broker commission amount
     C                   Z-ADD     WXCMA         BCMA
 
      ** Broker charges code
     C                   MOVE      SCCHC         BCHC
 
      ** Broker charges amount
     C                   Z-ADD     WXCHA         BCHA
 
      ** Broker margin
     C                   Z-ADD     WXMAR         BMAR
 
     C                   ENDSR
 
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
      ** Field name array (<ErrArrMax> x 10A, returned to caller)
     C                   PARM                    FldNamXArr
      ** Error message ID array (<ErrArrMax> x 7A, returned to caller)
     C                   PARM                    MsgIDXArr
      ** Error message data array (<ErrArrMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaXArr
      * Broker settlement OK flags.
     C                   PARM                    FFEBSETPD
      * Customer settlement OK flags
     C                   PARM                    FFECSETPD
      ** The valid settlements file format (data structure, from FFVSETLPD)
     C                   PARM                    FFVSETL
 
      ** Parameters received from caller
      ** -------------------------------
      ** Customer settlement format definition, used generically
      ** (for both broker and customer), in this module.
     C                   PARM                    FFCSETPD
      ** Flag which indicates whether the module is being called to validate
      ** the customer or broker (Y = Broker, N = Customer)
     C                   PARM                    XBRKI
      ** Instrument currency (3A, from INTYPD)
     C                   PARM                    KCCY
      ** Broker/Custom Chrg/com. Patterns (1A, from INTYPD)                                   CFF007
     C                   PARM                    PCPTI                                        CFF007
      ** Market (2A, from screen)                                                             CFF007
     C                   PARM                    KMRKT                                        CFF007
      ** Instrument (3A, from screen)                                                         CFF007
     C                   PARM                    KISTC                                        CFF007
      ** Number of Contracts (5.0P, from TRANSD)                                              CFF007
     C                   PARM                    PNUCO                                        CFF007
      ** Action Code used  (1A, from screen)                                                  CFF007
     C                   PARM                    SACTN             1                          CFF007
      ** Broker                                                                               CFF007
     C                   PARM                    SBOCO             6                          CFF007
      ** Futures and Options Enhancement for Private Banking                                  CFF007
     C                   PARM                    CFF007            1                          CFF007
      ** Private Banking Customer Inidcator                                                   CFF007
     C                   PARM                    PPBFLG                                       CFF007
 
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     **  Key List
     **  ~~~ ~~~~
 
      **   LF/CHGCM - keylist for chaining to logical file CHGCM
     C     KCHGCM        KLIST
     C                   KFLD                    KCCY
     C                   KFLD                    KCGCM
 
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
