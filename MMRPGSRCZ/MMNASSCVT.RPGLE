     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM NAs Sold Cnv: File to Screen Fmt')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMNASSCVT - Negotiable Assets Sold conversion: file to       *
      *              screen format                                    *
      *                                                               *
      *  Function:  This module converts the fields of a negotiable   *
      *             asset sold from their format on file to           *
      *             a screen format.                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CGL029             Date 01Sep03               *
      *                 CDL011             Date 07Jul02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 12Feb98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CDL011 - Expansion of Customer Number on Dealing Transactions*
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
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
 
      * Deal Status
     D @STSA           S             24    DIM(5) CTDATA PERRCD(1)
 
      * Deal in File Format
     D DealFilFmt    E DS                  EXTNAME(MMDENSPP)
 
      * Deal in Screen Format
     D DealScnFmt    E DS                  EXTNAME(MMNASSPD)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** EXTERNAL DS FOR DEALING DETAILS
                                                                                CDL011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CDL011
      ** EXTERNAL DS FOR SAR DETAILS                                            CDL011
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D                 DS
     D  @@YEAR                 1      4  0
     D  @@MNTH                 5      6  0
     D  @@DAY                  7      8  0
     D  @@DTIN                 1      8  0
 
     D                 DS
     D  @@SXP1                 1      1  0
     D  @@SXP2                 2      2  0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
     C**************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      * INITIALISATION
     C                   EXSR      INIT
      *
      ** SET OUTPUT SCREEN FIELDS
      *
     C                   EXSR      SETFLD
      *
      * Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SETFLD - SET OUTPUT SCREEN FIELDS
      *****************************************************************
     C     SETFLD        BEGSR
     C*
     C**  Deal number.
     C                   MOVE      HMDN38        DDDLNO
     C*
     C**  Deal type.
     C                   MOVE      HMMTYP        DDMTYP
     C*
     C**  Deal sub-type.
     C                   MOVE      HMSTYP        DDSTYP
     C*
     C**  Federal funds indicator
     C                   MOVE      HMFEDF        DDFEDF
     C*
     C** Deal date.
     C                   Z-ADD     HMDDYY        @@YEAR
     C                   Z-ADD     HMDDMM        @@MNTH
     C                   Z-ADD     HMDDDD        @@DAY
     C     @@DTIN        IFNE      *ZEROS
     C                   EXSR      CVTDAT
     C                   MOVE      @@DTOU        DDDLDT
     C                   END
     C*
     C**  Broker Code.
     C                   MOVE      HMBKCD        DDBKCD
     C*
     C**  Brokerage amount.
     C**  Format brokerage, using broker ccy decimal places
     C*
     C     HMBRKG        IFEQ      *ZERO
     C                   MOVE      '0'           DDBRKG
     C                   END
     C*
     C**  IF BROKERAGE A NUMBER, REFORMAT
     C*
     C     HMBRKG        IFNE      *ALL'9'
     C     HMBRKG        ANDNE     *ZERO
     C*
     C** Access currency for number of decimal places of broker currency.
     C** If brokerage currency is blank, assume deal currency.
     C*
     C     HMBKCY        IFNE      *BLANKS
     C                   MOVE      HMBKCY        @AJCD             3
     C                   ELSE
     C                   MOVE      HMCCY         @AJCD
     C                   END
     C*
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @AJCD
     C     SDCURR        PARM      SDCURR        DSSDY
     C*
     C** Format brokerage
     C                   Z-ADD     HMBRKG        @@AMTW
     C                   Z-ADD     A6NBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDBRKG
     C                   END
     C*
     C**  Sale of Deal Number.
     C                   MOVE      HMDADN        DDDADN
     C*
     C     CDL011        IFEQ      'Y'                                          CDL011
      *                                                                         CDL011
     C**  Issued by customer                                                    CDL011
     C                   MOVEL     HMISUR        DDISUR                         CDL011
     C*                                                                         CDL011
     C**  Sold to customer                                                      CDL011
     C                   MOVEL     HMCSNM        DDCSNM                         CDL011
      *                                                                         CDL011
     C                   ELSE                                                   CDL011
      *                                                                         CDL011
     C**  Issued by customer
     C                   MOVEL     HMISCN        DDISUR
     C*
     C**  Sold to customer
     C                   MOVEL     HMCNUM        DDCSNM
      *                                                                         CDL011
     C                   ENDIF                                                  CDL011
     C*
     C**  Value date.
     C                   Z-ADD     HMVDYY        @@YEAR
     C                   Z-ADD     HMVDMM        @@MNTH
     C                   Z-ADD     HMVDDD        @@DAY
     C     @@DTIN        IFNE      *ZEROS
     C                   EXSR      CVTDAT
     C                   MOVE      @@DTOU        DDVDAT
     C                   END
     C*
     C**  Currency Code.
     C                   MOVE      HMCCY         DDCCY
 
     C*
     C**  Face Value.
     C**  Format Face VAlue, using deal ccy decimal places
     C*
     C     HMFVAL        IFLT      0
     C                   Z-SUB     HMFVAL        @@AMTW
     C                   ELSE
     C                   Z-ADD     HMFVAL        @@AMTW
     C                   END
     C                   Z-ADD     HMCYDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDFVAL
     C*
     C**  Sale Price.
     C**  Format Sale Price, using deal ccy decimal places
     C*
     C     HMAMNP        IFLT      0
     C                   Z-SUB     HMAMNP        @@AMTW
     C                   ELSE
     C                   Z-ADD     HMAMNP        @@AMTW
     C                   END
     C                   Z-ADD     HMCYDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDAMNP
     C*
     C**  Yield Rate.
     C**  - Execute ZA0920 to format the rate, using 8 decimal places
     C**    and adjusting the file figure to have only implied decimal
     C**    places.
     C*
     C** For interest bearing NAs use interest rate else use discount rate
     C     HMINTR        MULT      10000000      @@AMTW                         *1
     C*
     C                   Z-ADD     7             @@QECN
     C                   EXSR      FmtAmt
     C                   MOVE      @@AMTD        DDINTR
     C     @@AMTW        IFEQ      *ZERO                                        B1
     C                   MOVE      *BLANKS       DDINTR                         *1
     C                   ENDIF                                                  E1
     C*
     C**  Book Code.
     C                   MOVE      HMBOKC        DDBOKC
     C*
     C**  Linked reference number.
     C     HMLNKN        IFNE      *ZEROS
     C                   MOVE      HMLNKN        DDLNKN
     C                   END
     C*
     C**  Profit Centre
     C                   MOVE      HMPRFC        DDPRFC
     C*
     C**  Originating Branch
     C                   MOVE      HMORBR        DDORBR
 
      ** Format Parcel Size
      ** If zero, put out blanks; otherwise treat as numeric with no
      ** decimal places.
     C                   IF        HMPSZE = *zero
     C                   EVAL      DDPSZE = *blanks
     C                   ELSE
     C                   Z-ADD     HMPSZE        @@AMTW
     C                   Z-ADD     0             @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDPSZE
     C                   ENDIF
      *                                                                                       CDL038
      * Class                                                                                 CDL038
     C                   MOVE      HMCLAS        DDCLAS                                       CDL038
 
     C**  Set up text for deal status.
     C*
     C     HMDSTS        IFEQ      'C'
     C                   MOVE      @STSA(1)      DDSTS
     C                   END
     C*
     C     HMDSTS        IFEQ      'A'
     C                   MOVE      @STSA(2)      DDSTS
     C                   END
     C*
     C     HMDSTS        IFEQ      'R'
     C                   MOVE      @STSA(3)      DDSTS
     C                   END
     C*
     C     HMDSTS        IFEQ      'M'
     C                   MOVE      @STSA(4)      DDSTS
     C                   END
     C*
     C     HMDDLT        IFEQ      'D'
     C                   MOVE      @STSA(5)      DDSTS
     C                   END
     C*
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CVTDAT - CONVERT DATE FROM YYYYMMDD TO DDMMYY (OR MMDDYY)     *
      *****************************************************************
     C     CVTDAT        BEGSR
      *
     C                   CALLB     'ZA0770'
     C                   PARM      *BLANK        @@RETC           10
     C                   PARM                    @@DTIN
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         @@DTOU            6 0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTAMT - FORMAT AMOUNT FOR DISPLAY                            *
      *****************************************************************
     C     FMTAMT        BEGSR
      *
     C                   CALLB     'ZA0920'
     C                   PARM      *BLANK        @@RETC           10
     C                   PARM                    @@AMTW           13 0
     C                   PARM                    @@QECN            1 0
     C                   PARM                    BNDCSP
     C                   PARM      *BLANK        @@AMTD           14
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *
      ** BLANK OUTPUTS (EXCEPT FOR ACTION CODE WITHIN DEAL FORMAT)
      *
     C                   MOVEL     DDACTN        ##ACTN            1
     C                   MOVEL     *BLANK        DealScnFmt
     C                   MOVEL     ##ACTN        DDACTN
     C                   MOVEL     *BLANK        DDSTS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  PROGRAM PARAMETERS
      *
     C     *ENTRY        PLIST
      *
      * INPUTS
      * Return Code
     C                   PARM                    RetCodeIn
      * Deal in file format
     C                   PARM                    DealFilFmt
      *
      * Output parameters
      * Deal in screen format
     C                   PARM                    DealScnFmt
      * Deal Status
     C                   PARM                    DDSTS            24
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
      ** Access the bank details for the date format (and anything else
      ** that's needed)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Access the dealing ICD to get the decimal separator character
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
 
      *                                                                         CDL011
      ** ACCESS SAR DETAILS FOR Expansion of Customer Number                    CDL011
      *                                                                         CDL011
     C                   CALLB     'AOSARDR0'                                   CDL011
     C                   PARM      *BLANKS       @RTCD                          CDL011
     C                   PARM      '*VERIFY'     @OPTN                          CDL011
     C                   PARM      'CDL011'      @SARD                          CDL011
     C     SCSARD        PARM      SCSARD        DSFDY                          CDL011
      *                                                                         CDL011
      * DATABASE ERROR                                                          CDL011
      *                                                                         CDL011
     C     @RTCD         IFNE      *BLANKS                                      CDL011
     C     @RTCD         ANDNE     '*NRF   '                                    CDL011
     C                   MOVEL     'CDL011'      DBKEY                          CDL011
     C                   MOVEL     'SCSARDPD'    DBFILE                         CDL011
     C                   MOVEL     '001'         DBASE                          CDL011
     C                   EXSR      *PSSR                                        CDL011
     C                   ENDIF                                                  CDL011
     C*                                                                         CDL011
     C     @RTCD         IFEQ      *BLANK                                       CDL011
     C                   MOVEL     'Y'           CDL011            1            CDL011
     C                   ELSE                                                   CDL011
     C                   MOVEL     'N'           CDL011                         CDL011
     C                   ENDIF                                                  CDL011
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** TEXT FOR DEAL STATUS
COMPLETE
AUTHORIZED
REQUIRES REAUTHORIZATION
MATURED
DELETED
