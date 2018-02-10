     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PM Portfolio Chrgs Convert File to Scrn Fmt')
      *****************************************************************
      *                                                               *
      *  Midas - Portfolio Management Module                          *
      *                                                               *
      *  PMPFDM1CT  - Portfolio Charges Details Conversion:           *
      *               File to Screen Format                           *
      *                                                               *
      *  Function: This module converts the fields of the Portfolio   *
      *            Charges details from their format as on file to    *
      *            a screen format.                                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002             Date 13Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP033  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CPB002 - New Private Banking Customer Processing.            *
      *           Just recompile over changes in PMVPFDMPD.           *
      *  CAP033 - Conversion of PM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Portfolio Charge Codes file
     FPMCGCDPD  IF   E           K DISK    INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
     D MaxChrgArr      C                   CONST(10)
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Original Portfolio Charges header details - screen format
     D CrChrgScrnH     DS
     D  DDBCGY                 1      3
     D  DDCSCY                 4      6
     D***DDCUSA                 7     18                                                      CGL029
     D***DDBRCA                19     21                                                      CGL029
     D  DDCUSA                 7     24                                                       CGL029
     D  DDBRCA                25     27                                                       CGL029
      *
      ** DS for Portfolio Charges screen fields - detail
     D ChrgScrnD       DS
     D  DDCGCO                 1      2
     D  DDCGSP                 3     16
     D  DDCGSI                17     17
     D  DDCGEI                18     18
     D  DDCGFQ                19     19
     D  DDCGDY                20     21
     D  DDCGND                22     27
     D  DDCGST                28     28
     D  DDCSFQ                29     29
     D  DDCSDY                30     31
     D  DDCSND                32     37
     D  DDPRFC                38     41
      *
     D  DDVALD                42     42
     D  DDCGCH                43     44
     D  DDCGSH                45     57  0
     D  DDCGEH                58     58
     D  DDCGLH                59     63  0
     D  DDCGDH                64     65
     D  DDCGNH                66     70  0
     D  DDCGFH                71     71
     D  DDCSFH                72     72
     D  DDCSDH                73     74
     D  DDCSNH                75     79  0
     D  DDCGTH                80     80
     D  DDPRFH                81     84
      *
      ** Original Portfolio Charges details array - screen format
     D CrChrgScrnArr   S                   DIM(MaxChrgArr)
     D                                     LIKE(ChrgScrnD)
      *
      ** Original Portfolio Charges details array - file format
     D CrChrgFileArr   S                   DIM(MaxChrgArr)
     D                                     LIKE(PMCHRG)
      *
      ** Externally described DS for Portfolio Charges details
     D PMCHRG        E DS                  EXTNAME(PMCHRGPD)
      *
      ** Portfolio Definition Details - for file update
     D NwDfFilFmt    E DS                  EXTNAME(PMVPFDMPD)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
     C                   EXSR      SRInit
      *
     C                   EXSR      SRCvtHdr
      *
     C                   EXSR      SRCvtChrg
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Initialisation                                      *
      *                                                               *
      *****************************************************************
      *
     C     SRInit        BEGSR
      *
      ** Clear output.
      *
     C                   CLEAR                   CrChrgScrnH
     C                   CLEAR                   CrChrgScrnArr
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCvtHdr - Convert Portfolio Charges Header Details from     *
      *             file format to screen format                      *
      *                                                               *
      *****************************************************************
      *
     C     SRCvtHdr      BEGSR
      *
     C                   EVAL      DDBCGY = P1PNBCGY
     C                   EVAL      DDCSCY = P1PNCSCY
     C                   EVAL      DDCUSA = P1PNCUSA
     C                   EVAL      DDBRCA = P1PNCUSB
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCvtChrg - Convert Portfolio Charges Details from file      *
      *              format to screen format                          *
      *                                                               *
      *****************************************************************
      *
     C     SRCvtChrg     BEGSR
      *
     C                   Z-ADD     1             WVCNT             2 0
      *
      ** Read Original Portfolio Charges details array in file format.
      *
     C     WVCNT         DOUGT     MaxChrgArr
      *
      ** Initialise data structure for update of Original Portfolio Charges
      ** details array in screen format.
      *
     C                   CLEAR                   ChrgScrnD
     C                   Z-ADD     0             DDCGSH
     C                   Z-ADD     0             DDCGLH
     C                   Z-ADD     0             DDCGNH
     C                   Z-ADD     0             DDCSNH
     C                   MOVEL     'N'           DDVALD
      *
     C                   CLEAR                   PMCHRG
      *
      ** Move Original Portfolio Charges details from array to data
      ** structure.
      *
     C                   EVAL      PMCHRG = CrChrgFileArr(WVCNT)
      *
      ** If Charges record exist for customer, portfolio reference
      ** and sequence combination, convert details to screen
      ** format.
      *
     C     POCGCO        IFNE      *BLANKS
     C                   EXSR      SRFillScrn
     C                   ENDIF
      *
      ** Update Original Portfolio Charges details array in screen
      ** format with or without details.
      *
     C                   Eval      CrChrgScrnArr(WVCNT) = ChrgScrnD
      *
     C                   ADD       1             WVCNT
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFillScrn - Update Charges screen fields                    *
      *                                                               *
      *****************************************************************
      *
     C     SRFillScrn    BEGSR
      *
      ** Set on flag to indicate that this Charge record was
      ** retrieved from file.
      *
     C                   MOVEL     'Y'           DDVALD
      *
      ** Charge Code
      *
     C                   MOVEL     POCGCO        DDCGCO
     C                   MOVEL     POCGCO        DDCGCH
      *
      ** Charge Spread
      *
     C     POCGSP        IFNE      0
     C                   EXSR      SRDecP
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      POCGSP        ZFIELD
     C                   EXSR      SRZEdit
     C                   MOVE      ZFIELD        DDCGSP
     C                   Z-ADD     POCGSP        DDCGSH
     C                   ENDIF
      *
      ** Charge Spread Indicator
      *
     C                   MOVEL     POCGSI        DDCGSI
      *
      ** Charge Effective Indicator
      *
     C                   MOVEL     POCGEI        DDCGEI
     C                   MOVEL     POCGEI        DDCGEH
      *
      ** Last Accrual Date
      *
     C                   MOVEL     POCGLD        DDCGLH
      *
      ** Accrual Date Frequency
      *
     C                   MOVEL     POCGFQ        DDCGFQ
     C                   MOVEL     POCGFQ        DDCGFH
      *
      ** Accrual Day in Month
      *
     C     POCGDY        IFNE      0
     C                   MOVEL     POCGDY        DDCGDY
     C                   MOVEL     POCGDY        DDCGDH
     C                   ENDIF
      *
      ** Next Accrual Date
      *
     C     POCGND        IFNE      0
     C                   Z-ADD     POCGND        ZDAYNO
     C                   EXSR      SRZDate2
     C                   MOVEL     ZDATE         DDCGND
     C                   Z-ADD     POCGND        DDCGNH
     C                   ENDIF
      *
      ** Charge Stopped Indicator
      *
     C                   MOVEL     POCGST        DDCGST
     C                   MOVEL     POCGST        DDCGTH
      *
      ** Settlement Date Frequency
      *
     C                   MOVEL     POCSFQ        DDCSFQ
     C                   MOVEL     POCSFQ        DDCSFH
      *
      ** Settlement Day in Month
      *
     C     POCSDY        IFNE      0
     C                   MOVEL     POCSDY        DDCSDY
     C                   MOVEL     POCSDY        DDCSDH
     C                   ENDIF
      *
      ** Next Settlement Date
      *
     C     POCSND        IFNE      0
     C                   Z-ADD     POCSND        ZDAYNO
     C                   EXSR      SRZDate2
     C                   MOVEL     ZDATE         DDCSND
     C                   Z-ADD     POCSND        DDCSNH
     C                   ENDIF
      *
      ** Profit Centre
      *
     C     BKPRCU        IFEQ      'Y'
     C                   MOVEL     POPFRC        DDPRFC
     C                   MOVEL     POPFRC        DDPRFH
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDecP - Calculate number of decimals                        *
      *                                                               *
      *****************************************************************
      *
     C     SRDecP        BEGSR
      *
      ** Retrieve Charge Basis from Charge Codes file.
      *
     C     PChrgCode     CHAIN     PMCGCDPD                           01
      *
     C     *IN01         IFEQ      *ON
     C     P5RECI        ORNE      'D'
     C                   MOVEL     DDBCGY        WKEY              5
     C                   MOVE      DDCGCO        WKEY
     C                   MOVEL     WKEY          DBKEY
     C                   MOVEL     'PMCGCDPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Calculate number of decimals for flat rate.
      *
     C     P5CGBS        IFEQ      'F'
     C                   Z-ADD     P1PNBCGD      ZADEC
     C                   ENDIF
      *
      ** Calculate number of decimals for percentage rate.
      *
     C     P5CGBS        IFEQ      'P'
     C                   Z-ADD     7             ZADEC
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZEdit - Edit field to insert decimal point and blank       *
      *            out leading zeroes                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRZEdit       BEGSR
      *
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZDate2 - Convert date to screen format                     *
      *                                                               *
      *****************************************************************
      *
     C     SRZDate2      BEGSR
      *
     C                   Z-ADD     0             ZDATE
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      BJDFIN        PDFMT             1
     C                   PARM                    ZDATE             6 0
     C                   PARM      *BLANKS       ZADATE            7
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
     C                   PARM                    RetCodeIn
      *
      ** Original Portfolio Charges details array - file format
     C                   PARM                    CrChrgFileArr
      *
      ** Portfolio Definition Details - for file update
     C                   PARM                    NwDfFilFmt
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date Format
     C                   PARM                    BJDFIN            1
      *
      ** SDGELR - Profit Centres Used
     C                   PARM                    BKPRCU            1
      *
      ** OUTPUT
      ** ======
      *
      ** Original Portfolio Charges header details - screen format
     C                   PARM                    CrChrgScrnH
      *
      ** Original Portfolio Charges details array - screen format
     C                   PARM                    CrChrgScrnArr
      *
      ** Key List
      *
     C     PChrgCode     KLIST
     C                   KFLD                    DDBCGY
     C                   KFLD                    DDCGCO
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
