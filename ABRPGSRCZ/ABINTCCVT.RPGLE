     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Int contract cnv file to screen format')      *
      *****************************************************************
      *                                                               *
      *  Midas - Internal Contracts (Dealing) Module                  *
      *                                                               *
      *  ABINTCCVT - Internal Contract Conversion: File to Screen Fmt *
      *                                                               *
      *  Function: This module converts the fields of an Int. Contract*
      *            from their format as on file to a screen format.   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. AR941922           Date 28Mar12               *
      *  Prev Amend No. 261962             Date 23Sep09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL038             Date 10May05               *
      *                 CGL029             Date 01Sep03               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 198665             Date 12Apr02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 156689             Date 08Mar99               *
      *                 CAP004             Date 08Sep98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR941922 - Status of Authorised INTC deals not shown during  *
      *             Enquiry via Internal Contracts menu               *
      *  261962 - Amended so that system can get the associated front *
      *           office ID from Java for INTC.                       *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  198665 - Remove checking if value date is less than run date.*
      *  156689 - ZASIGN TO RECOGNIZE '.' OR ',' AS DECIMAL SEPARATOR *
      *  CAP004 - API's Phase 3.                                      *
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
     D*@STSA****       S             24    DIM(2) CTDATA PERRCD(1)                          AR941922
     D @STSA           S             24    DIM(3) CTDATA PERRCD(1)                          AR941922
     D DDFOID          S             20A                                                      261962
     D DDAFID          S             20A                                                      261962
 
 
      * Deal in File Format
     D DealFilFmt    E DS                  EXTNAME(ABDEALPP)
 
      * Deal in Screen Format
     D DealScnFmt    E DS                  EXTNAME(ABINTCPD)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                    156689
      ** EXTERNAL DS FOR DEALING DETAILS                                        156689
                                                                                156689
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D                 DS
     D  @@YEAR                 1      4  0
     D  @@MNTH                 5      6  0
     D  @@DAY                  7      8  0
     D  @@DTIN                 1      8  0
 
 
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
      *
      * INITIALIZATION
      *
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
      *
      * Deal Date
     C                   Z-ADD     JPDDYY        @@YEAR
     C                   Z-ADD     JPDDMM        @@MNTH
     C                   Z-ADD     JPDDDD        @@DAY
     C                   EXSR      CVTDAT
     C                   MOVE      @@DTOU        DDDLDT
      *
      * Deal Type
     C                   MOVE      JPMDTY        DDDLTP
      *
      * Deal SubType
     C                   MOVE      JPSTYP        DDDSTP
      *
      * Branch
     C                   MOVE      JPMBCA        DDBRCD
      *
      * FX Book Code
     C                   MOVE      JPFXBC        DDFXBC
      *
      * MM Book Code
     C                   MOVE      JPMMBC        DDMMBC
      *
      * Linked Ref No
     C     JPLNKN        IFNE      *ZERO
     C                   MOVE      JPLNKN        DDLNKR
     C                   ELSE
     C                   MOVE      *BLANK        DDLNKR
     C                   END
      *
      ** 1st leg deal number
     C                   MOVE      JPFD38        DDL1DN
      *
      ** 1st leg value date
     C                   Z-ADD     JPNDYY        @@YEAR
     C                   Z-ADD     JPNDMM        @@MNTH
     C                   Z-ADD     JPNDDD        @@DAY
     C                   EXSR      CVTDAT
     C                   MOVE      @@DTOU        DDL1DT
      *
      ** 1st leg exchange rate
     C                   Z-ADD     *ZERO         @@AMTW
     C                   MOVE      JPNDXR        @@AMTW
     C                   Z-ADD     8             W@DECP
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTP        DDL1RT
      *
      ** 1st leg buy currency
      ** 1st leg buy amount
      ** 1st leg sell currency
      ** 1st leg sell amount
      *
     C     JPNDA1        IFLT      *ZERO
 
     C                   MOVE      JPDFCY        DDL1CS
 
     C                   Z-SUB     JPNDA1        @@AMTW
     C                   Z-ADD     JPCDPF        W@DECP
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTP        DDL1SA
 
     C                   MOVE      JPDSCY        DDL1CB
 
     C                   Z-ADD     JPNDA2        @@AMTW
     C                   Z-ADD     JPCDPS        W@DECP
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTP        DDL1BA
 
     C                   ELSE
 
     C                   MOVE      JPDSCY        DDL1CS
 
     C                   Z-SUB     JPNDA2        @@AMTW
     C                   Z-ADD     JPCDPS        W@DECP
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTP        DDL1SA
 
     C                   MOVE      JPDFCY        DDL1CB
 
     C                   Z-ADD     JPNDA1        @@AMTW
     C                   Z-ADD     JPCDPF        W@DECP
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTP        DDL1BA
 
     C                   END
      *
      ** 1st leg base equivalent
     C                   Z-ADD     JPNBCA        @@AMTW
     C                   Z-ADD     BseCcyDP      W@DECP
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTP        DDL1BE
      *
      ** 2nd leg deal number
     C                   MOVE      JPSD38        DDL2DN
      *
      ** 2nd leg value date
     C                   Z-ADD     JPFDYY        @@YEAR
     C                   Z-ADD     JPFDMM        @@MNTH
     C                   Z-ADD     JPFDDD        @@DAY
     C                   EXSR      CVTDAT
     C                   MOVE      @@DTOU        DDL2DT
      *
      ** 2nd leg exch rate
     C                   Z-ADD     *ZERO         @@AMTW
     C                   MOVE      JPFDXR        @@AMTW
     C                   Z-ADD     8             W@DECP
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTP        DDL2RT
      *
      ** 2nd leg buy currency
      ** 2nd leg buy amount
      ** 2nd leg sell currency
      ** 2nd leg sell amount
      *
     C     JPFDA1        IFLT      *ZERO
 
     C                   MOVE      JPDFCY        DDL2CS
 
     C                   Z-SUB     JPFDA1        @@AMTW
     C                   Z-ADD     JPCDPF        W@DECP
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTP        DDL2SA
 
     C                   MOVE      JPDSCY        DDL2CB
 
     C                   Z-ADD     JPFDA2        @@AMTW
     C                   Z-ADD     JPCDPS        W@DECP
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTP        DDL2BA
 
     C                   ELSE
 
     C                   MOVE      JPDSCY        DDL2CS
 
     C                   Z-SUB     JPFDA2        @@AMTW
     C                   Z-ADD     JPCDPS        W@DECP
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTP        DDL2SA
 
     C                   MOVE      JPDFCY        DDL2CB
 
     C                   Z-ADD     JPFDA1        @@AMTW
     C                   Z-ADD     JPCDPF        W@DECP
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTP        DDL2BA
 
     C                   END
      *
      ** 2nd leg base equivalent
     C                   Z-ADD     JPFBCA        @@AMTW
     C                   Z-ADD     BseCcyDP      W@DECP
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTP        DDL2BE
      *
      ** Forward points (signed)
     C                   Z-ADD     *ZERO         @@AMTW
     C                   MOVE      JPFWPP        @@AMTW
     C                   Z-ADD     2             W@DECP
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDFPTS
      *
      * FX Profit Centre
     C                   MOVE      JPPRFC        DDPRFC
      *
      * Originating Branch
     C                   MOVE      JPORBR        DDORBR
      *
      ** Loan round-down indicator
     C                   MOVE      JPLRDF        DDLRDF
      *
      ** Loan interest calculation method
     C                   MOVE      JPICM1        DDLOCM
      *
      ** Loan interest rate (signed)
     C                   Z-ADD     *ZERO         @@AMTW
     C                   MOVE      JPIRT1        @@AMTW
     C                   Z-ADD     7             W@DECP
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDLOIR
      *
      * Loan Interest Amount
     C                   Z-ADD     JPINA1        @@AMTW
     C                   Z-ADD     JPCDPF        W@DECP
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDLOIA
      *
      ** Deposit interest round-down indicator
     C                   MOVE      JPDRDF        DDDRDF
      *
      ** Deposit interest calculation method
     C                   MOVE      JPICM2        DDDPCM
      *
      ** Deposit interest rate (signed)
     C                   Z-ADD     *ZERO         @@AMTW
     C                   MOVE      JPIRT2        @@AMTW
     C                   Z-ADD     7             W@DECP
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDDPIR
      *
      * Deposit Interest Amount
     C                   Z-ADD     JPINA2        @@AMTW
     C                   Z-ADD     JPCDPS        W@DECP
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDDPIA
      *
      * MM Profit Centre
     C     BGN0ST        IFEQ      'Y'
     C                   MOVE      JPMMPC        DDMMPC
     C                   ENDIF
      *                                                                                       CDL038
      * Deal Class                                                                            CDL038
     C                   MOVE      JPCLAS        DDCLAS                                       CDL038
      *
      * Deal Deleted
      *
     C     JPDDLT        IFEQ      'D'
     C                   MOVE      @STSA(2)      DDSTS
                                                                                            AR941922
      ** Authorised Deal                                                                    AR941922
                                                                                            AR941922
     C                   ELSE                                                               AR941922
     C                   MOVE      @STSA(3)      DDSTS                                      AR941922
     C**********         ELSE                                                                 198665
      *****************************************************************                       198665
      **Deal*Matured***************************************************                       198665
      *****************************************************************                       198665
     C*****JPFDAT        IFLT      BJRDNB                                                     198665
     C**********         MOVE      @STSA(1)      DDSTS                                        198665
     C**********         END                                                                  198665
     C                   END
      *
      ** Front Office Transaction ID                                                          261962
     C                   EVAL      DDFOID = JPFRNT                                            261962
      *                                                                                       261962
      ** Associated Front Office Transaction ID                                               261962
     C                   EVAL      DDAFID = JPAFRT                                            261962
      *                                                                                       261962
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
     C                   CALLB     'ZA0921'
     C                   PARM      *BLANK        @@RETC           10
     C                   PARM                    @@AMTW           15 0
     C                   PARM                    W@DECP            1 0
     C                   PARM      BNDCSP        @@DCSP            1            156689
     C                   PARM      *BLANK        @@AMTP           16
     C                   PARM      *BLANK        @@AMTD           17
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
     C                   MOVEL     *BLANK        DDL2RT
     C                   MOVEL     *BLANK        DDL2CB
     C                   MOVEL     *BLANK        DDL2BA
     C                   MOVEL     *BLANK        DDL2CS
     C                   MOVEL     *BLANK        DDL2SA
     C                   MOVEL     *BLANK        DDLOIA
     C                   MOVEL     *BLANK        DDDPIA
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
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Deal in file format
     C                   PARM                    DealFilFmt
      *
      * Output parameters
      *
      * Deal in screen format
     C                   PARM                    DealScnFmt
      *
      * 2nd Leg Exchange Rate
      * 2nd Leg Buy Currency
      * 2nd Leg Buy Amount
      * 2nd Leg Sell Currency
      * 2nd Leg Sell Amount
      * Loan Interest Amount
      * Deposit Interest Amount
     C                   PARM                    DDL2RT           13
     C                   PARM                    DDL2CB            3
     C                   PARM                    DDL2BA           16
     C                   PARM                    DDL2CS            3
     C                   PARM                    DDL2SA           16
     C                   PARM                    DDLOIA           17
     C                   PARM                    DDDPIA           17
      *
      * Deal Status
     C                   PARM                    DDSTS            24
      * Front Office Transaction ID                                                           261962
      * Associated Front Office Transaction ID                                                261962
     C                   PARM                    DDFOID                                       261962
     C                   PARM                    DDAFID                                       261962
      *                                                                                       261962
      *
      ** Initialize program name
      *
     C                   MOVEL     'ABINTCCVT'   DBPGM
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '900'         DBASE                          * DBERR 900 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      ** Get the currency decimal places of accounting base ccy
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BJCYCD        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     @AJCD         DBKEY                          ************
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 902*
     C                   EXSR      *PSSR
     C                   END
      *
     C                   Z-ADD     A6NBDP        BseCcyDP          1 0
      *
      ** ACCESS MIDAS MODULE DETAILS
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   MOVEL     '902'         DBASE                          * DBERR 900 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *                                                                         156689
      ** ACCESS DEALING DETAILS                                                 156689
      *                                                                         156689
     C**********         CALL      'AODEALR0'                                   156689        CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD                          156689
     C                   PARM      '*FIRST '     @OPTN                          156689
     C*****SDDEAL        PARM      SDDEAL        DSFDY                          156689        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *                                                                         156689
      * DATABASE ERROR                                                          156689
      *                                                                         156689
     C     @RTCD         IFNE      *BLANK                                       156689
     C                   MOVEL     @OPTN         DBKEY                          156689
     C                   MOVEL     'SDDEALPD'    DBFILE                         156689
     C                   MOVEL     '903'         DBASE                          156689
     C                   EXSR      *PSSR                                        156689
     C                   END                                                    156689
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      ** ADDED AUTHORISED IN DEAL STATUS                                                    AR941922
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** TEXT FOR DEAL STATUS
MATURED
DELETED
AUTHORISED
