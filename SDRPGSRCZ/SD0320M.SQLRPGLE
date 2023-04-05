     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD056555
/*STD *  RPGSQLBND                                                    *                     MD056555
/*EXI *  TEXT('Midas SD Edit fee codes')                              *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD0320M - Fee Codes Maintenance                              *
      *                                                               *
      *  Function:  This program allows the user to maintain fee codes*
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD061007           Date 31Dec21               *
      *  Prev Amend No. MD056555           Date 31Aug20               *
      *                 MD057859           Date 07Apr21               *
      *                 CSD103             Date 10Aug20               *
      *                 MD054016           Date 03Sep19               *
      *                 CER050             Date 16Jun19               *
      *                 CLE071             Date 18Jul18               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE164             Date 18Aug14               *
      *                 MD021974A          Date 12Sep13               *
      *                 MD021974           Date 23Aug13               *
      *                 AR1093473          Date 04Mar13               *
      *                 AR1080662          Date 23Jan13               *
      *                 AR826996           Date 09Nov12               *
      *                 AR1022007          Date 23Aug12               *
      *                 AR467422           Date 01Aug12               *
      *                 262672             Date 01Aug12               *
      *                 CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CLE042             Date 06Sep05               *
      *                 CSD027             Date 09Dec05               *
      *                 CAS011             Date 16May05               *
      *                 231568             Date 10Jan05               *
      *                 CAS009             Date 04May04               *
      *                 CAAA03             Date 28Mar04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CSD003             Date 06Apr98               *
      *                 S01459             Date 06Apr98               *
      *                 S01117             Date 08AUG90               *
      *                                                               *
      *-------------------------------------------------------------- *
      *                                                               *
      *  MD061007 - Deliverable Data Split for SDFCTLPA and GPFCTLPA  *
      *  MD056555 - Deliverable Data Split for SAR group              *
      *  MD057859 - Allow alphanumeric base rate code in the input    *
      *             of default base rate.                             *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD054016 - Handling of the "Minimum APR Amount" in the Fee   *
      *             Maintenance                                       *
      *  CER050 - Annualised Percentage Rate                          *
      *  CLE071 - Value Dating of Rate Changes to Fees (Recompile)    *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *  MD021974A - Wrong additional fields on the Fee Code          *
      *              maintenance screen                               *
      *  MD021974  - Wrong additional fields on the Fee Code          *
      *              maintenance screen                               *
      *  AR1093473 - Unable to attached Past Due Details for FEE Codes*
      *  AR1080662 - Base Rate Field is missing in the Fee Codes      *
      *              Maintenance Additional Details Screen            *
      *  AR826996 - Validate Base Rate Code + Currency in SDBSRTPD    *
      *             (Child: AR826997)                                 *
      *  AR1022007 - [PDP] CC001 - Incorporate SM007 in PDP           *
      *  AR467422 - AUCRIN mandatory if other PDCL fields entered.    *
      *             Also it must be 'A', 'S' or 'P', not 'A' or 'D'.  *
      *  262672 - Modified to default suspense details when           *
      *           Suspense Fee Allowed = 'Y'.                         *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
      *  231568 - Additional Validation For ADJY in Fee Codes         *
      *           Maintenance                                         *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *  CAAA03 - Webfacing Changes (recompile).                      *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *  CSD003 - Synon Closedown Project (SD):                       *
      *           - Program removed from SD model.                    *
      *  S01459 - Addition of Midas Headerbox.                        *
      *  S01117 - Release 10 changes.                                 *
      *                                                               *
      *****************************************************************
     FSD0320M#  CF   E             WORKSTN USROPN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas SD Fee codes maintenance subfile
      *
     FSDFEEL1   IF   E           K DISK    USROPN
     F                                     INFDS(INFDS1)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Fee codes retrieval
      *
     FSDFEEL0   UF A E           K DISK    USROPN
     F                                     COMMIT
     F                                     INFDS(ID0001)
     F                                     INFSR(*PSSR)
      * UPD : Midas SD Fee codes update
      *
     F*SDFCTLL0* UF   E           K DISK    USROPN                                          MD061007
     F**********                           COMMIT                                           MD061007
     F**********                           INFDS(ID0002)                                    MD061007
     F**********                           INFSR(*PSSR)                                     MD061007
      * UPD : Midas SD Standing data controls update
      *
      *                                                                                       CAS009
     F/COPY WNCPYSRC,SDH00133
     FDLFEEDL0  IF   E           K DISK
      ** Dealing Fees detail file                                                             CAS009
      *                                                                                       CAS009
     F***LEFEEDLAIF  E           K        DISK                                         CAS009 CAS011
     FLEFEEDLB  IF   E           K DISK
      ** Lending Fees detail file                                                             CAS009
      *                                                                                       CAS009
     F*SCSARPL1* IF   E           K DISK                                                    MD056555
      ** Midas SC Switchable Feature Initialisation PGM index                                 231568
      *                                                                                       231568
     F***LEFEEDLEIF  E           K        DISK                                         231568 CAS011
     F***LEFEEDLFIF  E           K        DISK                                         CAS011 CLE134
     FLEFEEDLF  UF   E           K DISK
     F                                     COMMIT
     F                                     INFSR(*PSSR)
     F                                     RENAME(LEFEEDF:LEFEED)
      ** Lending Live Fees detail file                                                        231568
      *                                                                                       231568
     FDLFEEDLG  IF   E           K DISK
     F                                     RENAME(DLFEEDD0:DLFEED)
      ** Dealing Live Fees detail file                                                        231568
      *                                                                                       231568
     FLEFEEDLW  IF   E           K DISK                                                           AR
     F                                     RENAME(LEFEEDF:LEFEEDW)                                AR
     FSDBSRTL2  IF   E           K DISK                                                           AR
     FSDPRGPI0  IF   E           K DISK
     F/COPY WNCPYSRC,SD0320MF01
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
      *                                                                                    AR1022007
      ** Arrays for calls to validation modules                                            AR1022007
      *                                                                                    AR1022007
     D AFLDNM          S             10    DIM(72)
     D AMSGID          S              7    DIM(72)
     D AMGDTA          S             45    DIM(72)
      /EJECT
      * Data structures:
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      * Program data structure
     D JBDTTM          DS
      * Job date/time
     D  ##JDT                  1      7  0
     D  ##JCC                  1      1  0
     D  ##JYY                  2      3  0
     D  ##JMM                  4      5  0
     D  ##JDD                  6      7  0
     D  ##JTM                  8     13  0
     D  ##JHH                  8      9  0
     D  ##JNN                 10     11  0
     D  ##JSS                 12     13  0
      * ABO DEFINE LARGE STRING FOR CL CMD
     D YARTCM          DS           512
     D  DUMMY1                 1      1
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file information data structure
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External data structures for Switchable Features Details                             CAS001
      *                                                                                       CAS001
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)                                     AR1
      **  External DS for base rate details                                                AR1022007
      *                                                                                    AR1022007
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D SDLOAN        E DS                  EXTNAME(SDLOANPD)
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, Short data structure                                   CAS001
      *                                                                                       CAS001
     D LDA           E DS                  EXTNAME(LDA)
      ** Local data area for database error details                                           CAS001
      *                                                                                       CAS001
     D @1DBRC        E DS                  EXTNAME(SDFEEL0)
      * UPD : Midas SD Fee codes update
      * Current/previous master file format fields for change control
      *
     D*QSDFC1***     E DS                  EXTNAME(SDFCTLL0)                                MD061007
     D QSDFC1          DS                                                                   MD061007
     D  AHFLNM                 1     10                                                     MD061007
     D  AHNORC                11     13P 0                                                  MD061007
     D  AHNOIN                14     16P 0                                                  MD061007
     D  AHNOAM                17     19P 0                                                  MD061007
     D  AHNODL                20     22P 0                                                  MD061007
      * UPD : Midas SD Standing data controls update
     D YARDCS          DS            22
     D WUDELR          DS
     D  WUDR01                 1    250
     D  WUDR02               251    500
     D  WUDR03               501    750
     D  WUDR04               751   1000
     D  WUDR05              1001   1250
     D  WUDR06              1251   1500
     D  WUDR07              1501   1750
     D  WUDR08              1751   2000
     D  WUDR09              2001   2250
     D  WUDR00              2251   2500
     D  WUDR11              2501   2750
     D  WUDR12              2751   3000
      * Outward parameters
     D PARC            DS          3064
      * RCD : Midas SD Deleted records file retrieval
      * I :  File name
     D  PAFNME                 1     10
      * I :  Long Key
     D  PALKEY                11     60
      * I :  Deleted Data Record Pt1
     D  PADR01                61    310
      * I :  Deleted Data Record Pt2
     D  PADR02               311    560
      * I :  Deleted Data Record Pt3
     D  PADR03               561    810
      * I :  Deleted Data Record Pt4
     D  PADR04               811   1060
      * I :  Deleted Data Record Pt5
     D  PADR05              1061   1310
      * I :  Deleted Data Record Pt6
     D  PADR06              1311   1560
      * I :  Deleted Data Record Pt7
     D  PADR07              1561   1810
      * I :  Deleted Data Record Pt8
     D  PADR08              1811   2060
      * I :  Deleted Data Record Pt9
     D  PADR09              2061   2310
      * I :  Deleted Data Record Pt10
     D  PADR00              2311   2560
      * I :  Deleted Data Record Pt11
     D  PADR11              2561   2810
      * I :  Deleted Data Record Pt12
     D  PADR12              2811   3060
      * I :  Last Change Date
     D  PALCD               3061   3063P 0
      * I :  Type of Last Change
     D  PATYLC              3064   3064
      *
     D YBRDCS          DS            22
     D YCRDCS          DS            26
     D YDRDCS          DS            22
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
      *                                                                                       CLE134
     D DIGITS          C                   CONST('0123456789')
      *                                                                                       CLE134
     D C#LTST          DS
     D  #2CLTY                 1      2
     D  #2CLT1                 1      1
     D  #2CLST                 3      4
     D  #2CLCL                 5      8
      *                                                                                       CLE134
     D UPLST           DS                                                                        AR1
     D  #UPCSP                 1     11                                                          AR1
     D  #UPCSG                12     12                                                          AR1
     D  #UPRMT                13     19                                                          AR1
     D  #UPRFD                20     23                                                          AR1
      *                                                                                    AR1022007
     D A@CPY           DS
     D* Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright array
     D WUDSTT          DS
     D  WUPOS1                 1      1
     D  WUPOS2                 2      2
     D ID0001          DS           528
      * File information data structure
      *
     D ID0002          DS           528
      * File information data structure
      *
     D/COPY WNCPYSRC,SDH00134
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Fee Code must be GT 0'
      * Fee Code
     D  ZA0001                 1      2
      * Message data for 'Question Mark Invalid'
      * Key Field
     D  ZA0002                 1     10
      * Message data for 'Key Field Invalid Value'
      * If value in key field
     D  ZA0003                 1      1
      * Key Field
     D  ZA0004                 2     11
      * Message data for 'No blanks in fee code'
      * Fee Code
     D  ZA0005                 1      2
      * Message data for 'No blanks in fee code'
      * Fee Code
     D  ZA0006                 1      2
      * Message data for 'Fee Code must be numeric'
      * Fee Code
     D  ZA0007                 1      2
      * Message data for 'Fee Narrative is required'
      * Fee Narrative
     D  ZA0008                 1     20
      * Currency                                                                            AR826996
     D  ZA0009                 1      3                                                           AR
      * Base Rate Code                                                                      AR826996
     D  ZA0010                 4      5                                                           AR
     D ALPHAN          C                   CONST('0123456789ABCDEFGHI-
     D                                     JKLMNOPQRSTUVWXYZ*')
     D SCSARP        E DS                  EXTNAME(SCSRPJW0)                                MD056555
     I/COPY WNCPYSRC,SD0320MI01
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
      *****************************************************************
      * Initialize
     C                   EXSR      ZZINIT
      *
     C                   DO        *HIVAL
      * Initialise and load subfile page
     C                   EXSR      BAIZSF
     C                   MOVEL     'N'           W0RSF             1
      * Display screen until reload requested
     C     W0RSF         DOWEQ     'N'
      * Display screen
     C                   EXSR      CAEXFM
      * Process response
      * Cancel & exit program
     C   03              CAS                     ZXEXPG
      * HOME: Request subfile reload
     C   05              CAS                     FBRQRL
      * Display next SFL page
     C   27              CAS                     BBLDSF
      * Process screen input
     C                   CAS                     DAPR##
     C                   END
      *
     C                   END
     C                   END
      *****************************************************************
      /EJECT
     CSR   BAIZSF        BEGSR
      *================================================================
      * Initialise & load subfile page
      *================================================================
      * Clear subfile
     C                   SETON                                        80
     C                   WRITE     #SFLCTL
     C                   SETOFF                                       80
      * Reset no of records in subfile
     C                   Z-ADD     *ZERO         ##RRMX            5 081         SETOF 81
      * USER: Initialize subfile header
     C                   MOVEL     'N'           WUDELA                         Deletion Allowe
      * CASE: WRK.Set Up Complete is No
     C     WUSUC         IFEQ      'N'                                          *IF
      * CASE: PGM.*Program mode is *CHANGE
     C     W0PMD         IFEQ      'CHG'                                        *IF
     C                   MOVEL     'Y'           WUDELA                         Deletion Allowe
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Start of Fix S01117
      * Set up Edit File Footer - Standard Functions  *
     C*****************************************************************
     C*
     C*  Sets up the function key footer text for edit files in which
     C*  records may not be deleted after the system set up flag has
     C*  been set on
     C*
     C*****************************************************************
     C*
     C*  DETAIL LINE COMMAND KEY TEXT
     C*
     C                   MOVEL     'SDUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C*  If program mode is ADD:
     C*
     C     W0PMD         IFEQ      'ADD'
     C* Setup footer text:
     C* F3=Main Menu   F5=Refresh   F9=Go to 'Change' Mode
     C                   MOVEL     'USR3349'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   ELSE
     C*
     C*  If set up is not complete:
     C*
     C     WUSUC         IFEQ      'N'
     C* Setup footer text:
     C* D=Delete   F3=Main Menu   F5=Refresh   F9=Go to 'Add' Mode
      *                                                                                       CLE134
     C     CLE134        IFEQ      'Y'
     C     CER050        OREQ      'Y'
     C                   MOVEL     'USR5429'     WUMSID
      *                                                                                       CLE134
     C                   ELSE
     C                   MOVEL     'USR3348'     WUMSID                         Message Identifier
     C                   ENDIF
      *                                                                                       CLE134
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   ELSE
     C* Setup footer text:
     C* F3=Main Menu   F5=Refresh   F9=Go to 'Add' Mode
      *                                                                                       CLE134
     C     CLE134        IFEQ      'Y'
     C     CER050        OREQ      'Y'
     C                   MOVEL     'USR5430'     WUMSID
      *                                                                                       CLE134
     C                   ELSE
     C                   MOVEL     'USR3354'     WUMSID                         Message Identifier
     C                   ENDIF
      *                                                                                       CLE134
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C                   END
      * End of Fix S01117
      *................................................................
      * If CHANGE mode, then position file:
     C     W0PMD         IFNE      'ADD'
     C     *LIKE         DEFINE    #2FECD        WZFECD
     C                   MOVEL     #2FECD        WZFECD                         Fee Code
     C     KPOS          KLIST
     C                   KFLD                    AUFECD                         Fee Code
      * Setup key
     C                   MOVEL     #2FECD        AUFECD                         Fee Code
      * 82=EOF
     C     KPOS          SETLL     @AURECR                            82        *
      * 82=EOF
     C  N82              READ      @AURECR                              9182    *
     C/COPY WNCPYSRC,SD0320MC01
     C                   ELSE
     C                   SETOFF                                       82        *
     C                   END
      * Load subfile page
     C                   EXSR      BBLDSF
      *................................................................
      * If no records found, display error message
     C   82##RR          IFEQ      *ZERO                                        IF
      * Send message '*No data to display'
     C                   MOVEL     'Y2U0008'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
      *
      *================================================================
     CSR   BAEXIT        ENDSR
      /EJECT
     CSR   BBLDSF        BEGSR
      *================================================================
      * Load subfile page (write empty page if add mode)
      *================================================================
     C                   SETOFF                                       84        No SFLNXTCHG
      * Re-establish fields in read-ahead record
     C   27W0PMD         IFNE      'ADD'
     C  N82              READP     @AURECR                                90    *
     C  N82              READ      @AURECR                                90    *
     C/COPY WNCPYSRC,SD0320MC02
     C                   END
      *
      * Setof record error indicators
     C                   MOVE      *ALL'0'       WKIND0            3
     C                   MOVE      *ALL'1'       WKIND1            3
      * Start at previous highest record in SFL
     C                   Z-ADD     ##RRMX        ##RR              5 0
     C                   Z-ADD     *ZERO         ##RROK            5 0
      * Set required pages based on *Set Cursor or *Subfile Pages
     C     W0RR0         IFGT      0
     C     W0RR0         DIV       ##SFPG        ##SPG             3 0
     C                   MVR                     ##SLIN            3 0
     C     ##SLIN        IFGT      0
     C                   ADD       1             ##SPG
     C                   END
     C     W0SPG         IFGT      ##SPG
     C                   Z-ADD     W0SPG         ##SPG
     C                   END
     C                   ELSE
     C                   Z-ADD     W0SPG         ##SPG
     C                   END
      * Compute lines required based on pages
     C     ##SPG         MULT      ##SFPG        ##SFLN            9 0
     C     ##SFLN        IFGT      999
     C                   Z-ADD     999           ##SFLN
     C                   END
      *................................................................
      * Load next subfile page
     C  N82##RROK        DOWLT     ##SFLN                                       DO
     C                   ADD       1             ##RR
     C                   MOVEA     WKIND0        *IN(32)
     C                   MOVE      *OFF          *IN35
     C/COPY WNCPYSRC,SD0320MC03
     C                   SETOFF                                       87        *
      * Clear subfile fields
     C                   EXSR      MAIZ#1
      * If CHANGE mode, load subfile fields
     C     W0PMD         IFNE      'ADD'
     C                   EXSR      MBFL#1
      * Validate subfile record and calculate derived fields
     C                   EXSR      DFV2RC
     C                   END
      * Output to subfile
     C                   ADD       1             ##RROK               81        *
      * If SFLRCD invalid, note that errors present
     C   98
     CANN99              SETON                                        99        *
      * Set screen conditioning indicators
     C                   EXSR      GADSA1
     C                   WRITE     #SFLRCD
     C     W0PMD         IFNE      'ADD'
      * 82=EOF
     C                   READ      @AURECR                                82    *
     C/COPY WNCPYSRC,SD0320MC04
     C                   END
     C  N82              END
      *................................................................
      * Save highest SFL record load can continue at end point
     C     ##RR          IFGT      ##RRMX
      * Calculate top line
     C     ##RROK        DIV       ##SFPG        ##SPG
     C                   MVR                     ##SLIN
     C     ##SLIN        IFGT      0
     C     ##RR          SUB       ##SLIN        ##SFRC
     C                   ELSE
     C     ##RR          SUB       ##SFPG        ##SFRC
     C                   END
     C                   ADD       1             ##SFRC
     C                   Z-ADD     ##RR          ##RRMX
     C                   END
      *================================================================
     CSR   BBEXIT        ENDSR
      /EJECT
     CSR   CAEXFM        BEGSR
      *================================================================
      * Display screen and process HELP requests
      *================================================================
      * Set screen conditioning indicators
     C                   EXSR      GBDSA2
      * Update screen time
     C                   TIME                    ##TME
     C     W0HLP         DOUEQ     'N'
     C                   MOVEL     'N'           W0HLP             1
     C                   MOVE      *IN25         HELP25            1
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
     C                   MOVE      HELP25        *IN25
      * PUTOVR unless conditioned fields change
     C                   SETON                                        86
     C     *IN89         IFNE      CAIN89
     C     *IN81         ORNE      CAIN81
     C                   SETOFF                                       86
     C                   END
     C                   MOVE      *IN89         CAIN89            1
     C                   MOVE      *IN81         CAIN81            1
      * Set cursor by *SET CURSOR data
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y0SET
     C                   END
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #SFLCTL
      * Maintain subfile position where possible
     C     @#SFRC        IFGT      *ZERO
     C                   Z-ADD     @#SFRC        ##SFRC
     C                   END
      * Test cursor
     C                   EXSR      Y8TST
      * Clear set cursor DDS indicator
     C     WCSRLC        IFEQ      'OFF'
     C                   SETOFF                                       94        *
     C                   END
     C                   MOVE      *BLANK        WCSRLC
      * If help requested, display help text
     C   25              EXSR      ZHHPKY
     C                   END
      * Update job time
     C                   TIME                    ##JTM
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1      99    *
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y9CLR
     C                   END
      *================================================================
     CSR   CAEXIT        ENDSR
      /EJECT
     CSR   DAPR##        BEGSR
      *================================================================
      * Process screen input
      *================================================================
      *
     C     W0PMD         IFNE      'ADD'
      * Change of position specified
     C     WZFECD        CASNE     #2FECD        FBRQRL                         Fee Code
     C                   END
     C                   END
      * Quit if reload requested
     C     W0RSF         CABEQ     'Y'           DAEXIT
      *
     C   81              DO
      * No data entered as yet
     C                   MOVEL     'N'           WKIPIN            1
      * Confirm/update is not deferred
     C                   MOVEL     'N'           W0DCF             1
      * Process subfile records
     C                   EXSR      DBPRSF
      * If error, exit
     C     *IN99         CABEQ     '1'           DAEXIT
      * Defer confirm/update requested
     C     W0DCF         CABEQ     'Y'           DAEXIT
      * If data entered
     C     WKIPIN        IFEQ      'Y'
      * Update DBF from subfile
     C                   EXSR      EAPRSF
      * If error during update, exit:
     C     *IN99         CABEQ     '1'           DAEXIT
     C                   END                                                    WKIPIN
     C                   END
      * Switch between *ADD/*CHANGE modes
     C   09              EXSR      FACHMD
      *================================================================
     CSR   DAEXIT        ENDSR
      /EJECT
     CSR   DBPRSF        BEGSR
      *================================================================
      * Process modified subfile record
      *================================================================
     C                   READC     #SFLRCD                                92    *
     C     *IN92         DOWEQ     '0'
     C                   EXSR      DCPRSR
     C                   SETOFF                                       87        *
      * Set screen conditioning indicators
     C                   EXSR      GADSA1
     C                   UPDATE    #SFLRCD
     C                   READC     #SFLRCD                                92    *
     C                   END
      *================================================================
     CSR   DBEXIT        ENDSR
      /EJECT
     CSR   DCPRSR        BEGSR
      *================================================================
      * Process subfile record
      *================================================================
      * Set off error indicators
     C                   MOVEA     WKIND0        *IN(32)
     C                   MOVE      *OFF          *IN35
     C/COPY WNCPYSRC,SD0320MC05
      * No errors
     C                   SETOFF                                       98
      * No SFLNXTCHG
     C                   SETOFF                                       84
     C     W0PMD         IFEQ      'ADD'
      * Check for null record
     C                   EXSR      DDNLRC
     C     W0NLR         IFEQ      'Y'
     C                   GOTO      DCEXIT
     C                   END
      * If not null record, continue
     C                   END
      * Data entered
     C                   MOVEL     'Y'           WKIPIN
      * SFLNXTCHG
     C                   SETON                                        84
      * If delete request, bypass validation
     C     #1SEL         IFEQ      'D'
     C     WUDELA        ANDEQ     'Y'
     C                   GOTO      DCEXIT
     C                   END
      * Validate subfile record
     C                   EXSR      DEV1RC
      * If SFLRCD invalid, note the fact
     C   98
     CANN99              Z-ADD     ##RR          ##SFRC               99        *
      *================================================================
     CSR   DCEXIT        ENDSR
      /EJECT
     CSR   DDNLRC        BEGSR
      *================================================================
      * Check for null record
      *================================================================
     C                   MOVEL     'N'           W0NLR             1
     C     #1FECD        CABNE     *BLANK        DDEXIT                         Fee Code
     C     #1FENV        CABNE     *BLANK        DDEXIT                         Fee Narrative
     C     #1ADJY        CABNE     *BLANK        DDEXIT
     C/COPY WNCPYSRC,SDH00135
     C                   MOVEL     'Y'           W0NLR
      *================================================================
     CSR   DDEXIT        ENDSR
      /EJECT
     CSR   DEV1RC        BEGSR
      *================================================================
      * Validate subfile record
      *================================================================
      * USER: Validate subfile record fields
      * Start of Fix S01117
      * Fee Code validation
      * CASE: PGM.*Program mode is *ADD
     C     W0PMD         IFEQ      'ADD'                                        *IF
      * CASE: RCD.Fee Code is entered
     C     #1FECD        IFNE      *BLANK                                       *IF
      * CASE: RCD.Fee Code is zero
     C     #1FECD        IFGE      '0'                                          *IF
     C     #1FECD        ANDLE     '00'
      * Setup message data for message
     C                   MOVEL     #1FECD        ZA0001                         Fee Code
      * Send message 'Fee Code must be GT 0'
     C                   MOVEL     'USR1401'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9833      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     #1FECD        WUTQKF                         Test ? in Key F
     C                   MOVEL     #1FECD        WUIVKF                         If value in key
      * CASE: WRK.Test ? in Key Field is Question Mark
     C     WUTQKF        IFEQ      '?'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1FECD        ZA0002                         Fee Code
      * Send message 'Question Mark Invalid'
     C                   MOVEL     'USR0380'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9833      *
      *
     C                   ELSE
      * CASE: WRK.If value in key field is Asterisk
     C     WUIVKF        IFEQ      '*'                                          *IF
      * Setup message data for message
     C                   MOVEL     WUIVKF        ZA0003                         If value in key
     C                   MOVEL     #1FECD        ZA0004                         Fee Code
      * Send message 'Key Field Invalid Value'
     C                   MOVEL     'USR0849'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9833      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * Chek for blanks in the key field
     C                   EXSR      UASUBR                                       Chek for blanks
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #1FECD        WUZASF                         ZALIGN Screen F
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0001            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0002           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0003            1 0          ZALIGN No Of De
     C                   PARM      2             WQ0004            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0005           16            ZALIGN File Fie
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZALIGN'      W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        98        *
     C                   END
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1FECD        ZA0007                         Fee Code
      * Send message 'Fee Code must be numeric'
     C                   MOVEL     'USR1402'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9833      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      *                                                                                       CLE134
     C     CLE134        IFEQ      'Y'
     C     #1SEL         ANDEQ     'E'
     C     CER050        OREQ      'Y'
     C     #1SEL         ANDEQ     'E'
     C                   MOVE      *ON           *IN19
     C                   ELSE
     C                   MOVE      *OFF          *IN19
     C                   ENDIF
     C     #1SEL         IFEQ      'D'
     C     WUDELA        ANDEQ     'N'
     C                   MOVEL     'USR5433'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN32
     C                   MOVE      *ON           *IN98
     C                   ENDIF
      *                                                                                       CLE134
     C     CLE134        IFEQ      'N'
     C     CER050        ANDEQ     'N'
     C     #1SEL         IFEQ      'A'
     C     #1SEL         OREQ      'E'
     C                   MOVEL     'USR5434'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN32
     C                   MOVE      *ON           *IN98
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE134
     C     CLE134        IFEQ      'Y'
     C     CER050        OREQ      'Y'
     C     #1SEL         IFEQ      'A'
     C     #1SEL         OREQ      'E'
     C     CLE036        IFEQ      'Y'
     C                   MOVE      *OFF          *IN72
     C                   MOVE      *OFF          *IN73
     C                   ENDIF
     C     CER050        IFEQ      'Y'
     C                   MOVE      *OFF          *IN65
     C                   MOVE      *OFF          *IN66
     C                   ENDIF
     C                   EXSR      DTLSCN
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE134
      * Fee Narrative is required
      * CASE: RCD.Fee Narrative is blank
     C     #1FENV        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1FENV        ZA0008                         Fee Narrative
      * Send message 'Fee Narrative is required'
     C                   MOVEL     'USR1403'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9834      *
      *
     C                   END                                                    *FI
      * End of Fix S01117
     C/COPY WNCPYSRC,SD0320MC06
      *                                                                                       CAS001
      ** If CAS001 is installed, validate Adjustment to Yield entry.                          CAS001
      *                                                                                       CAS001
     C     CAS001        IFEQ      'Y'
     C     #1ADJY        IFEQ      *BLANK
     C     #1ADJY        OREQ      'Y'
     C     #1ADJY        OREQ      'N'
      *                                                                                       CAS001
     C                   ELSE
      *                                                                                       CAS001
      ** Send message if value is other than Y, N and *Blank.                                 CAS001
      *                                                                                       CAS001
     C                   MOVEL     'USR9155'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN35
     C                   MOVE      *ON           *IN98
      *                                                                                       CAS001
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CAS001
      ** Perform additional validation when CAS009 is on. Retrieve the current                CAS009
      ** Adjustment to Yeild value.                                                           CAS009
      *                                                                                       CAS009
     C     CAS009        IFEQ      'Y'
      *                                                                                       CAS009
     C     #1FECD        CHAIN     SDFEEL1                            94
      *                                                                                       CAS009
      ** Only Validate when the initialisation program has ran                                231568
     C     #1ADJY        IFNE      AUADJY
     C     WCAS9I        ANDEQ     'Y'
      *                                                                                       CAS009
     C                   MOVE      #1FECD        WFECD             2 0
      *                                                                                       CAS009
      ** If there is a change in the Adjustment to Yield field, check necessary files         CAS009
      ** if the fee has already been used.  Raise and error if fee has been used.             CAS009
      *                                                                                       CAS009
     C********** WFECD     CHAINDLFEEDL0             93                                CAS009 231568
     C     WFECD         CHAIN     DLFEEDLG                           93
      *                                                                                       CAS009
     C     *IN93         IFEQ      '1'
      *                                                                                       CAS009
     C********** WFECD     CHAINLEFEEDLA             93                                CAS009 231568
     C********** WFECD     CHAINLEFEEDLE             93                                231568 CAS011
     C********** WFECD     CHAINLEFEEDLF             93                                CAS011 CLE134
     C     WFECD         CHAIN(N)  LEFEEDLF                           93
      *                                                                                       CAS009
     C                   ENDIF
      *                                                                                       CAS009
     C     *IN93         IFEQ      '0'
     C                   MOVEL     'USR9425'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN35
     C                   MOVE      *ON           *IN98
     C                   ENDIF
      *                                                                                       CAS009
     C                   ENDIF
      *                                                                                       CAS009
     C                   ENDIF
      * Validate subfile record relations
     C                   EXSR      DFV2RC
      * Fee Code required
     C     #1FECD        IFEQ      *BLANK                                       IF
     C                   SETON                                        9833      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *================================================================
     CSR   DEEXIT        ENDSR
      /EJECT
     CSR   DFV2RC        BEGSR
      *================================================================
      * Validate subfile record relations
      *================================================================
      *================================================================
     CSR   DFEXIT        ENDSR
      /EJECT
     CSR   EAPRSF        BEGSR
      *================================================================
      * Update DBF from subfile
      *================================================================
      * Initialise subfile reload flag
     C     W0PMD         IFEQ      'ADD'
     C                   MOVEL     'Y'           W0RSF
     C                   ELSE
     C                   MOVEL     'N'           W0RSF
     C                   END
      * Process all modified subfile records
     C                   READC     #SFLRCD                                92    *
     C     *IN92         DOWEQ     '0'
      * Process modified subfile record
     C                   EXSR      EBPRSR
     C     W0RTN         IFNE      *BLANK
      * Error: ROLLBACK any DBF changes
     C                   ROLBK
     C                   ELSE
      * Otherwise COMMIT any DBF changes
     C                   COMMIT
     C                   END
      *                                                                                       CAS009
      ** Do not blank out value of #1SEL on the screen when there is a error.                 CAS009
      *                                                                                       CAS009
     C     *IN32         IFNE      '1'
     C                   MOVEL     *BLANK        #1SEL
     C                   ENDIF
      * Set screen conditioning indicators
     C                   EXSR      GADSA1
     C                   UPDATE    #SFLRCD
     C                   READC     #SFLRCD                                92    *
     C                   END
      * If any errors, cancel reload
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'N'           W0RSF             1
     C                   END
      *================================================================
     CSR   EAEXIT        ENDSR
      /EJECT
     CSR   EBPRSR        BEGSR
      *================================================================
      * Process modified subfile record
      *================================================================
      * Set off error indicators
     C                   MOVEA     WKIND0        *IN(32)
     C/COPY WNCPYSRC,SD0320MC07
     C                   SETOFF                                       98
      *
     C     W0PMD         IFEQ      'ADD'
      * Process add request
     C     #1SEL         IFNE      'D'
     C                   EXSR      DDNLRC
     C     W0NLR         IFNE      'Y'
     C                   EXSR      ECADRQ
     C                   END
     C                   END
     C                   ELSE
     C     #1SEL         IFEQ      'D'
      *                                                                                       CAS009
      ** Validate delete option for the fee code.                                             CAS009
      *                                                                                       CAS009
     C     CAS009        IFEQ      'Y'
      *                                                                                       CAS009
     C                   MOVE      #1FECD        WFECD
      *                                                                                       CAS009
     C     WFECD         CHAIN     DLFEEDL0                           93
      *                                                                                       CAS009
     C     *IN93         IFEQ      '1'
      *                                                                                       CAS009
     C********** WFECD     CHAINLEFEEDLA             93                                CAS009 CAS011
     C     WFECD         CHAIN     LEFEEDLB                           93
      *                                                                                       CAS009
     C                   ENDIF
      *                                                                                       CAS009
     C     *IN93         IFEQ      '0'
     C                   MOVEL     'USR9427'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN32
     C                   MOVE      *ON           *IN98
     C                   GOTO      EBEXIT
     C                   ENDIF
     C                   ENDIF
      * Process delete request
     C                   EXSR      EDDLRQ
     C                   ELSE
      * Process change request
     C     #1SEL         IFNE      'E'
     C                   EXSR      EECHRQ
     C                   ENDIF
     C                   END
     C                   END
      * If error occurred on update, note the fact
     C     *IN98         IFEQ      '1'
     C     *IN99         IFEQ      '0'
     C                   Z-ADD     ##RR          ##SFRC               99        *
     C                   END
     C                   END
      *================================================================
     CSR   EBEXIT        ENDSR
      /EJECT
     CSR   ECADRQ        BEGSR
      *================================================================
      * Process add request
      *================================================================
      * USER: Create DBF record
      * Create Fee Codes - Fee Codes  *
     C                   EXSR      SACRRC
     C     W0RTN         IFNE      *BLANK
      * Write error detected
      * Screen errors
     C                   MOVEA     WKIND1        *IN(32)
      * Format error
     C/COPY WNCPYSRC,SD0320MC08
     C                   SETON                                        98        *
      * Enable entry
     C                   SETOFF                                       87        *
      * SFLNXTCHG
     C                   SETON                                        84        *
     C                   ELSE
      * DBF write successful
      * disable entry
     C                   SETON                                        87        *
      * No SFLNXTCHG
     C                   SETOFF                                       84        *
     C                   END
      *================================================================
     CSR   ECEXIT        ENDSR
      /EJECT
     CSR   EDDLRQ        BEGSR
      *================================================================
      * Process delete request
      *================================================================
      * USER: Delete DBF record
      * Delete Fee Codes - Fee Codes  *
     C                   EXSR      SCDLRC
     C     W0RTN         IFNE      *BLANK
      * Delete unsuccessful
      * Screen errors
     C                   MOVEA     WKIND1        *IN(32)
     C/COPY WNCPYSRC,SD0320MC09
      * Format error
     C                   SETON                                        98        *
      * Enable entry
     C                   SETOFF                                       87        *
      * SFLNXTCHG
     C                   SETON                                        84        *
      * If record altered, reset subfile record
     C     W0RTN         CASEQ     'Y2U0007'     MBFL#1                         IF
     C                   END
     C                   ELSE
      * DBF delete successful
      * Blank out record and protect from entry
     C                   EXSR      MAIZ#1
      * disable entry
     C                   SETON                                        87        *
      * No SFLNXTCHG
     C                   SETOFF                                       84        *
      * Reload subfile
     C                   MOVEL     'Y'           W0RSF             1
     C                   END
      *================================================================
     CSR   EDEXIT        ENDSR
      /EJECT
     CSR   EECHRQ        BEGSR
      *================================================================
      * Process update request
      *================================================================
      * USER: Change DBF record
      * Change Fee Codes - Fee Codes  *
     C                   EXSR      SECHRC
     C     W0RTN         IFNE      *BLANK
      * Data update error
      * Screen errors
     C                   MOVEA     WKIND1        *IN(32)
      * Format error
     C/COPY WNCPYSRC,SD0320MC10
     C                   SETON                                        98        *
      * Enable entry
     C                   SETOFF                                       87        *
      * SFLNXTCHG
     C                   SETON                                        84        *
      * Reset subfile record if changed record
     C     W0RTN         CASEQ     'Y2U0007'     MBFL#1                         IF
     C                   END
     C                   ELSE
      * DBF update successful
      * Enable entry
     C                   SETOFF                                       87        *
      * No SFLNXTCHG
     C                   SETOFF                                       84        *
     C                   END
      *================================================================
     CSR   EEEXIT        ENDSR
      /EJECT                                                                                  CLE134
     C     DTLSCN        BEGSR
      *================================================================                       CLE134
      * DTLSCN: Detail Screen introduced by CLE134                                            CLE134
      *================================================================                       CLE134
      *                                                                                    AR1022007
      ** Initialise SM007/CRE073 Detail Screen                                             AR1022007
      *                                                                                    AR1022007
     C                   CLEAR                   UPLST
     C                   Z-ADD     0             N#CSP
      *                                                                                       CLE134
      ** Get Fee Code record                                                                  CLE134
      *                                                                                       CLE134
     C     #1FECD        CHAIN     SDFEEL1                            77
      *                                                                                       CLE134
     C     *IN77         IFEQ      *OFF
     C     CLE134        IFEQ      'Y'
     C                   MOVE      AUCLTY        #2CLTY
     C                   MOVE      AUCLST        #2CLST
     C                   MOVE      AUCLCL        #2CLCL
      *                                                                                       CLE134
     C     AUCBSR        IFEQ      *ZEROS
     C                   MOVE      *BLANKS       #2CBSR
     C                   ELSE
     C                   MOVE      AUCBSR        #2CBSR
     C                   ENDIF
      *                                                                                       CLE134
     C     AUCBRT        IFEQ      *ZEROS
     C     *IN71         OREQ      '0'
     C                   MOVE      *BLANKS       #2CBRT
     C                   ELSE
     C                   Z-ADD     0             W#NUMB
     C                   MOVE      AUCBRT        W#NUMB
     C                   CALL      'ZSEDIT'
     C                   PARM                    W#NUMB           15 0
     C                   PARM      7             W#DECS            1 0
     C                   PARM      *BLANK        W#EDTC            1
     C                   PARM                    W#CHAR           21
     C                   MOVEL     W#CHAR        W#CH20           20
     C                   MOVE      W#CH20        #2CBRT
     C                   Z-ADD     0             W#NUMB
     C                   ENDIF
      *                                                                                    AR1080662
     C     AUCRSP        IFEQ      0
     C                   MOVE      *BLANKS       #2CRSP
      *                                                                                       CLE134
     C                   ELSE
     C                   MOVE      AUCRSP        W#NUMB
      *                                                                                       CLE134
     C                   CALL      'ZSEDIT'
     C                   PARM                    W#NUMB           15 0
     C                   PARM      7             W#DECS            1 0
     C                   PARM      *BLANK        W#EDTC            1
     C                   PARM                    W#CHAR           21
      *                                                                                       CLE134
     C                   MOVEL     W#CHAR        W#CH20           20
     C                   MOVE      W#CH20        #2CRSP
     C                   ENDIF
      *                                                                                       CLE134
     C                   MOVE      AUCRIN        #2CRIN
     C                   MOVE      AUBSRI        #2BSRI
      *                                                                                       CLE134
     C     AUICBS        IFEQ      *ZERO
     C                   MOVE      *BLANKS       #2ICBS
      *                                                                                       CLE134
     C                   ELSE
     C                   MOVE      AUICBS        #2ICBS
     C                   ENDIF
      *                                                                                       CLE134
     C                   MOVE      AUOVRA        #2OVRA
     C                   MOVE      AUFAMU        #2FAMU
     C                   MOVE      AUFSFA        #2FSFA
      *                                                                                       CLE134
     C     AUSFAM        IFEQ      0
     C                   MOVE      *BLANKS       #2SFAM
      *                                                                                       CLE134
     C                   ELSE
     C                   MOVE      AUSFAM        W#NUMB
      *                                                                                       CLE134
     C                   CALL      'ZSEDIT'
     C                   PARM                    W#NUMB           15 0
     C                   PARM      0             W#DECS            1 0
     C                   PARM      *BLANK        W#EDTC            1
     C                   PARM                    W#CHAR           21
      *                                                                                       CLE134
     C                   MOVEL     W#CHAR        W#CH20           20
     C                   MOVE      W#CH20        #2SFAM
     C                   ENDIF
      *                                                                                       CLE134
     C     AUSFPM        IFEQ      0
     C                   MOVE      *BLANKS       #2SFPM
      *                                                                                       CLE134
     C                   ELSE
     C                   MOVE      AUSFPM        W#NUMB
      *                                                                                       CLE134
     C                   CALL      'ZSEDIT'
     C                   PARM                    W#NUMB           15 0
     C                   PARM      0             W#DECS            1 0
     C                   PARM      *BLANK        W#EDTC            1
     C                   PARM                    W#CHAR           21
      *                                                                                       CLE134
     C                   MOVEL     W#CHAR        W#CH20           20
     C                   MOVE      W#CH20        #2SFPM
     C                   ENDIF
      *                                                                                       CLE134
     C                   MOVE      AUFPYA        #2FPYA
     C                   MOVE      AUPSIN        #2PSIN
      *                                                                                       CLE134
     C     AUPSLM        IFEQ      0
     C                   MOVE      *BLANKS       #2PSLM
      *                                                                                       CLE134
     C                   ELSE
     C                   MOVE      AUPSLM        W#NUMB
      *                                                                                       CLE134
     C                   CALL      'ZSEDIT'
     C                   PARM                    W#NUMB           15 0
     C                   PARM      0             W#DECS            1 0
     C                   PARM      *BLANK        W#EDTC            1
     C                   PARM                    W#CHAR           21
      *                                                                                       CLE134
     C                   MOVEL     W#CHAR        W#CH20           20
     C                   MOVE      W#CH20        #2PSLM
     C                   ENDIF
      *                                                                                       CLE134
     C                   MOVE      AUFEMC        #2FEMC
     C                   MOVE      AUGDPR        #2GDPR
     C**********           MOVE AUPCKO    #2PCKO                                       CLE134 CLE164
     C                   MOVE      AUPGID        #2PGID
     C     AUPGID        CHAIN     SDPRGPI0                           86
     C     *IN86         IFEQ      '0'
     C                   MOVE      PGDESC        #2PDES
     C                   ELSE
     C                   MOVE      *BLANKS       #2PDES
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CER050
     C     CER050        IFEQ      'Y'
     C     AUMINF        IFEQ      0
     C                   MOVE      *BLANKS       #1MINF
     C                   ELSE
     C                   MOVE      AUMINF        W#NUMB
     C                   CALL      'ZSEDIT'
     C                   PARM                    W#NUMB           15 0
     C                   PARM      A6NBDP        W#DECS            1 0
     C                   PARM      *BLANK        W#EDTC            1
     C                   PARM                    W#CHAR           21
     C                   MOVEL     W#CHAR        W#CH20           20
     C                   MOVE      W#CH20        #1MINF
     C                   ENDIF
     C     AUIAPR        IFEQ      *BLANKS
     C                   MOVE      'N'           #1IAPR
     C                   ELSE
     C                   MOVE      AUIAPR        #1IAPR
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CER050
     C                   ENDIF
      *                                                                                       CLE134
      ** Set indicators according to action: protect fields                                   CLE134
      *                                                                                       CLE134
     C     #1SEL         IFEQ      'E'
     C                   MOVE      *ON           *IN77
     C                   MOVE      *ON           *IN72
     C                   MOVE      *OFF          *IN73
     C                   ENDIF
      *                                                                                       CLE134
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ
     C                   PARM      '*SAME'       ZAPGRL
      *                                                                                       CLE134
      ** Set SM007/CRE073 fields on screen                                                 AR1022007
      *                                                                                    AR1022007
     C     CRE073        IFEQ      'Y'
     C     AUPCSP        IFEQ      0
     C                   MOVE      *BLANKS       #UPCSP
     C                   ELSE
     C                   MOVE      AUPCSP        W#NUMB
     C                   CALL      'ZSEDIT'
     C                   PARM                    W#NUMB           15 0
     C                   PARM      7             W#DECS            1 0
     C                   PARM      *BLANK        W#EDTC            1
     C                   PARM                    W#CHAR           21
     C                   MOVEL     W#CHAR        W#CH20           20
     C                   MOVE      W#CH20        #UPCSP
     C                   ENDIF
      *                                                                                    AR1022007
     C                   MOVE      AUPCSG        #UPCSG
     C                   MOVE      AUPFMT        #UPRMT
     C                   MOVE      AUPRFD        #UPRFD
     C                   ENDIF
      *                                                                                    AR1022007
     C     *INKL         DOUEQ     *ON
     C     *IN97         OREQ      *OFF
     C     W0DEF         ANDEQ     'N'
     C                   WRITE     #MSGCTL
     C                   EXFMT     #RCDDTL
      *                                                                                       CLE134
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ
     C                   PARM      '*SAME'       ZAPGRL
      *                                                                                       CLE134
     C                   MOVE      *INKL         #1F12
     C                   MOVEL     'N'           W0DEF
      *                                                                                       CLE134
     C     #1SEL         IFEQ      'A'
     C     *INKL         ANDEQ     *OFF
     C                   EXSR      VALDTL
     C                   ENDIF
      *                                                                                       CLE134
     C                   ENDDO
      *================================================================                       CLE134
     C                   ENDSR
      /EJECT                                                                                  CLE134
     C     VALDTL        BEGSR
      *================================================================                       CLE134
      * VALDTL: Validate Detail Screen introduced by CLE134                                   CLE134
      *================================================================                       CLE134
      *                                                                                       CLE134
      ** Past Due Call Loan Type/Subtype (& Loan Class if feature present)                    CLE134
      *                                                                                       CLE134
     C     CLE134        IFEQ      'Y'
      *                                                                                       CER050
     C                   SELECT
     C     C#LTST        WHENEQ    *BLANKS
      *                                                                                       CLE134
     C     #2CLT1        WHENNE    'Z'
     C                   MOVE      *ON           *IN36
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'USR5431'     ZAMSID
     C                   EXSR      ZASNMS
      *                                                                                       CLE134
     C     CLE042        WHENEQ    'Y'
     C     #2CLCL        ANDEQ     *BLANKS
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'USR5439'     ZAMSID
     C                   EXSR      ZASNMS
      *                                                                                       CLE134
     C                   OTHER
     C                   CALL      'AOLOANR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      #2CLTY        P@LNTY            2
     C                   PARM      #2CLST        P@LNST            2
     C                   PARM      #2CLCL        P@LNCL            4
     C     SDLOAN        PARM      SDLOAN        DSFDY
      *                                                                                       CLE134
     C                   SELECT
     C     PRTCD         WHENEQ    '*NRF'
     C                   MOVE      *ON           *IN36
     C                   MOVE      *ON           *IN37
      *                                                                                       CLE134
     C     CLE042        IFEQ      'Y'
     C                   MOVE      *ON           *IN50
     C                   ENDIF
      *                                                                                       CLE134
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'USR5413'     ZAMSID
     C                   EXSR      ZASNMS
      *                                                                                       CLE134
     C     PRTCD         WHENNE    *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SD0320M '    DBPGM
     C                   MOVEL     'SDLOANPD'    DBFILE
     C                   MOVEL     C#LTST        DBKEY
     C                   Z-ADD     5             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDSL
      *                                                                                       CLE134
     C                   ENDSL
      *                                                                                       CLE134
      ** Past Due Default Base Rate                                                           CLE134
      *                                                                                       CLE134
      ** If no Past Due Loan Type entered;                                                    CLE134
      ** - Input not allowed.                                                                 CLE134
      *                                                                                       CLE134
     C                   Z-ADD     0             N#CBRT           11 7
     C                   MOVE      *OFF          *IN73
     C     C#LTST        IFEQ      *BLANKS
     C     #2CBSR        IFNE      *BLANKS
     C     #2CBRT        ORNE      *BLANKS
     C**********           MOVE *ON       *IN38                                     CLE134 AR1080662
     C     #2CBSR        COMP      *BLANKS                            38
     C     #2CBRT        COMP      *BLANKS                            73
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'USR5489'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CLE134
      ** Else Past Due Loan Type entered;                                                     CLE134
      ** - Input mandatory.                                                                   CLE134
      *                                                                                       CLE134
     C                   ELSE
     C     #2CBSR        IFEQ      *BLANKS
     C     #2CRSP        ANDEQ     *BLANKS
     C     #2CBRT        ANDEQ     *BLANKS
     C     #UPCSP        ANDEQ     *BLANKS
      *                                                                                    AR1022007
      ** Rate/Spread only if SM007/CRE073 is off                                           AR1022007
      *                                                                                    AR1022007
     C     CRE073        IFEQ      'N'
     C                   MOVE      *ON           *IN38
     C                   MOVE      *ON           *IN39
     C                   MOVE      *ON           *IN73
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'USR5488'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                    AR1022007
      *                                                                                       CLE134
      ** - Must be a valid value.                                                             CLE134
      *                                                                                       CLE134
     C                   ELSE
     C     #2CBSR        IFNE      *BLANKS
     C     #2CBSR        ANDNE     *ZEROS
     C     #2CBRT        ANDNE     *BLANKS
     C                   MOVE      *ON           *IN38
     C                   MOVE      *ON           *IN73
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'USR5498'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CLE134
     C     #2CBSR        IFNE      *BLANKS
     C********** DIGITS    CHECK#2CBSR    WPOS    30                                 CLE134 MD057859
      *                                                                              CLE134 MD057859
     C********** WPOS      IFGT 0                                                    CLE134 MD057859
     C**********           MOVE *ON       *IN38                                      CLE134 MD057859
     C**********           MOVE *ON       *IN97                                      CLE134 MD057859
     C**********           MOVEL'USR5419' ZAMSID                                     CLE134 MD057859
     C**********           EXSR ZASNMS                                               CLE134 MD057859
     C**********           ELSE                                                    AR826996 MD057859
     C                   EXSR      SRVBRC
     C     *IN64         IFEQ      *ON
     C                   MOVE      *ON           *IN38
     C                   MOVE      *ON           *IN97
     C**********           MOVEL'USR5446' ZAMSID                                   AR826996 MD057859
     C                   MOVEL     'USR0079'     ZAMSID
     C                   MOVEL     FEFCCY        ZA0009
     C                   MOVEL     #2CBSR        ZA0010
     C                   EXSR      ZASNMS
     C                   ENDIF
     C**********           ENDIF                                                     CLE134 MD057859
     C                   ENDIF
     C     #2CBRT        IFNE      *BLANKS
     C     *IN71         ANDEQ     '1'
     C                   CALL      'ZALIGN'
     C     W0RTN         PARM      *BLANKS       WQ0001
     C                   PARM      #2CBRT        WQ0002
     C                   PARM      7             WQ0003
     C                   PARM      4             WQ0004
     C                   PARM      *BLANKS       WQ0005
      *                                                                                    AR1080662
     C     W0RTN         IFEQ      *BLANKS
     C                   MOVE      WQ0005        N#CBRT
      *                                                                                    AR1080662
     C                   CALL      'ZEDIT'
     C                   PARM      WQ0005        WQ0002
     C                   PARM      7             WQ0003
      *                                                                                    AR1080662
     C                   MOVE      WQ0002        #2CBRT
      *                                                                                    AR1080662
     C                   ELSE
     C                   MOVE      *ON           *IN73
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'USR5423'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE134
      ** Past Due Default Rate/Spread                                                         CLE134
      *                                                                                       CLE134
     C                   Z-ADD     0             N#CRSP
      *                                                                                    AR1022007
      ** Calculate Rate/Spread and Spread ind only if SM007/CRE073 is off.                 AR1022007
      *                                                                                    AR1022007
     C     CRE073        IFEQ      'N'
      *                                                                                       CLE134
      ** If no Past Due Loan Type entered;                                                    CLE134
      ** - Input not allowed.                                                                 CLE134
      *                                                                                       CLE134
     C     C#LTST        IFEQ      *BLANKS
     C     #2CRSP        IFNE      *BLANKS
     C                   MOVE      *ON           *IN39
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'USR5494'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CLE134
      ** Else Past Due Loan Type entered;                                                     CLE134
      ** - Input mandatory.                                                                   CLE134
      *                                                                                       CLE134
     C                   ELSE
     C     #2CRSP        IFEQ      *BLANKS
     C     #2CBSR        ANDEQ     *BLANKS
     C     #2CBRT        ANDEQ     *BLANKS
     C     #2CRSP        OREQ      *BLANKS
     C     #2CBSR        ANDEQ     *ZEROS
     C     #2CBRT        ANDEQ     *BLANKS
     C                   MOVE      *ON           *IN39
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'USR5424'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CLE134
     C     #2CRSP        IFNE      *BLANKS
     C                   CALL      'ZALIGN'
     C     W0RTN         PARM      *BLANKS       WQ0001
     C                   PARM      #2CRSP        WQ0002
     C                   PARM      7             WQ0003
     C                   PARM      4             WQ0004
     C                   PARM      *BLANKS       WQ0005
      *                                                                                       CLE134
     C     W0RTN         IFEQ      *BLANKS
     C                   MOVE      WQ0005        N#CRSP
      *                                                                                       CLE134
     C                   CALL      'ZEDIT'
     C                   PARM                    WQ0005
     C                   PARM                    WQ0003
      *                                                                                       CLE134
     C                   MOVE      WQ0005        #2CRSP
      *                                                                                       CLE134
     C                   ELSE
     C                   MOVE      *ON           *IN39
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'USR5423'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE134
      ** Past Due Default Spread Indicator                                                    CLE134
      *                                                                                       CLE134
      ** If no Past Due Loan Type entered;                                                    CLE134
      ** - Input not allowed.                                                                 CLE134
      *                                                                                       CLE134
     C     C#LTST        IFEQ      *BLANKS
     C     #2CRIN        IFNE      *BLANKS
     C                   MOVE      *ON           *IN40
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'USR5491'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CLE134
      **Else*Past*Due*Loan*Type*entered;*******************************              CLE134 AR467422
      **-*If*Base*Rate*and*Spread/Rate*not*entered;********************              CLE134 AR467422
      ****-*Input*not*allowed.*****************************************              CLE134 AR467422
      **********                                                                     CLE134 AR467422
     C**********           ELSE                                                      CLE134 AR467422
     C********** #2CRIN    IFNE *BLANK                                               CLE134 AR467422
     C********** #2CBSR    ANDEQ*BLANKS                                              CLE134 AR467422
     C********** #2CRIN    ORNE *BLANK                                               CLE134 AR467422
     C********** #2CRSP    ANDEQ*BLANKS                                              CLE134 AR467422
     C**********           MOVE *ON       *IN40                                      CLE134 AR467422
     C**********           MOVE *ON       *IN97                                      CLE134 AR467422
     C**********           MOVEL'USR5420' ZAMSID                                     CLE134 AR467422
     C**********           EXSR ZASNMS                                               CLE134 AR467422
      *                                                                                       CLE134
      ** Else Past Due Loan Type entered;                                                   AR467422
      **-*If*both*Base*Rate*and*Spread/Rate*entered;*******************              CLE134 AR467422
      ** - Input mandatory.                                                                   CLE134
      *                                                                                       CLE134
     C                   ELSE
     C     #2CRIN        IFEQ      *BLANK
     C********** #2PBSR    ANDNE*BLANKS                                              CLE134 AR467422
     C********** #2PRSP    ANDNE*BLANKS                                              CLE134 AR467422
     C                   MOVE      *ON           *IN40
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'USR5490'     ZAMSID
     C                   EXSR      ZASNMS
      *                                                                                       CLE134
      ** - Must be a valid value.                                                             CLE134
      *                                                                                       CLE134
     C                   ELSE
     C********** #2CRIN    IFNE *BLANK                                               CLE134 AR467422
     C     #2CRIN        IFNE      'S'
     C     #2CRIN        ANDNE     'A'
     C********** #2CRIN    ANDNE'D'                                                  CLE134 AR467422
     C     #2CRIN        ANDNE     'P'
     C                   MOVE      *ON           *IN40
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'USR5425'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C**********           ENDIF                                                     CLE134 AR467422
     C                   ENDIF
      *                                                                                    AR1022007
     C                   ENDIF
      *                                                                                    AR1022007
      ** Validate additional SM007 fields/CRE073 if feature is on                          AR1022007
      *                                                                                    AR1022007
     C     CRE073        IFEQ      'Y'
     C                   EXSR      SMVAL
     C                   ENDIF
      *                                                                                       CLE134
      ** Past Due Default Base Rate Change Indicator                                          CLE134
      *                                                                                       CLE134
      ** If no Past Due Loan Type entered;                                                    CLE134
      ** - Input not allowed.                                                                 CLE134
      *                                                                                       CLE134
     C     C#LTST        IFEQ      *BLANKS
     C     #2BSRI        IFNE      *BLANKS
     C                   MOVE      *ON           *IN41
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'USR5485'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CLE134
      ** Else Past Due Loan Type entered;                                                     CLE134
      ** - Input mandatory.                                                                   CLE134
      *                                                                                       CLE134
     C                   ELSE
     C     #2BSRI        IFEQ      *BLANK
     C                   MOVE      'D'           #2BSRI
     C                   ENDIF
      *                                                                                       CLE134
     C     #2BSRI        IFNE      'D'
     C     #2BSRI        ANDNE     'R'
     C     #2BSRI        ANDNE     'N'
     C                   MOVE      *ON           *IN41
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'USR5435'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE134
      ** Interest Calculation Basis                                                           CLE134
      *                                                                                       CLE134
      ** If no Past Due Loan Type entered;                                                    CLE134
      ** - Input not allowed.                                                                 CLE134
      *                                                                                       CLE134
     C     C#LTST        IFEQ      *BLANKS
     C     #2ICBS        IFNE      *BLANKS
     C                   MOVE      *ON           *IN42
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'USR5497'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CLE134
      ** Else Past Due Loan Type entered;                                                     CLE134
      ** - Input mandatory.                                                                   CLE134
      *                                                                                       CLE134
     C                   ELSE
     C     #2ICBS        IFEQ      *BLANKS
     C                   MOVE      *ON           *IN42
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'USR5426'     ZAMSID
     C                   EXSR      ZASNMS
      *                                                                                       CLE134
      ** - Must be a valid value.                                                             CLE134
      *                                                                                       CLE134
     C                   ELSE
     C     #2ICBS        IFLT      '1'
     C     #2ICBS        ORGT      '6'
     C                   MOVE      *ON           *IN42
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'USR5426'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE134
      ** Overdraft Repayment Allowed                                                          CLE134
      *                                                                                       CLE134
     C     #2OVRA        IFEQ      *BLANK
     C                   MOVE      'N'           #2OVRA
     C                   ENDIF
      *                                                                                       CLE134
     C     #2OVRA        IFNE      'Y'
     C     #2OVRA        ANDNE     'N'
     C                   MOVE      *ON           *IN43
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'USR5416'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CLE134
      ** Facility Amount Utlisation                                                           CLE134
      *                                                                                       CLE134
     C     #2FAMU        IFEQ      *BLANK
     C                   MOVE      'N'           #2FAMU
     C                   ENDIF
      *                                                                                       CLE134
     C     #2FAMU        IFNE      'Y'
     C     #2FAMU        ANDNE     'N'
     C                   MOVE      *ON           *IN44
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'USR5416'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                CLE134 262672
      ** Early Maturity Condition                                                      CLE134 262672
      *                                                                                CLE134 262672
     C********** #2FEMC    IFEQ *BLANK                                                 CLE134 262672
     C**********           MOVE 'S'       #2FEMC                                       CLE134 262672
     C**********           ENDIF                                                       CLE134 262672
      *                                                                                CLE134 262672
     C********** #2FEMC    IFNE 'A'                                                    CLE134 262672
     C********** #2FEMC    ANDNE'T'                                                    CLE134 262672
     C********** #2FEMC    ANDNE'S'                                                    CLE134 262672
     C**********           MOVE *ON       *IN46                                        CLE134 262672
     C**********           MOVE *ON       *IN97                                        CLE134 262672
     C**********           MOVEL'USR5465' ZAMSID                                       CLE134 262672
     C**********           EXSR ZASNMS                                                 CLE134 262672
     C**********           ENDIF                                                       CLE134 262672
      *                                                                                       CLE134
      ** Suspend Fee Allowed                                                                  CLE134
      *                                                                                       CLE134
     C     #2FSFA        IFEQ      *BLANK
     C                   MOVE      'N'           #2FSFA
     C                   ENDIF
      *                                                                                       CLE134
     C     #2FSFA        IFNE      'Y'
     C     #2FSFA        ANDNE     'N'
     C                   MOVE      *ON           *IN45
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'USR5416'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CLE134
      ** Changing the value from Y to N is not allowed if fees with                           CLE134
      ** this fee code are present with a non-zero suspended amount.                          CLE134
      *                                                                                       CLE134
     C     W0PMD         IFEQ      'CHG'
     C     AUFSFA        ANDEQ     'Y'
     C     #2FSFA        ANDEQ     'N'
      *                                                                                       CLE134
     C                   MOVE      AUFECD        W#FECD            2 0
     C     W#FECD        SETLL     LEFEEDLF
     C     W#FECD        READE(N)  LEFEEDLF                               92
     C     *IN92         DOWEQ     *OFF
      *                                                                                       CLE134
     C     FESFA         IFGT      0
     C                   LEAVE
     C                   ENDIF
      *                                                                                       CLE134
     C     W#FECD        READE(N)  LEFEEDLF                               92
     C                   ENDDO
      *                                                                                       CLE134
     C     *IN92         IFEQ      *OFF
     C                   MOVE      *ON           *IN45
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'USR5436'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE134
      ** Suspended Fee Amount Maximum                                                         CLE134
      *                                                                                       CLE134
     C                   Z-ADD     0             N#SFAM
      *                                                                                       CLE134
     C                   SELECT
     C     #2FEMC        WHENEQ    'A'
     C     #2SFAM        ANDEQ     *BLANKS
     C                   MOVE      *ON           *IN51
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'USR5437'     ZAMSID
     C                   EXSR      ZASNMS
      *                                                                                       CLE134
     C     #2SFAM        WHENEQ    *BLANKS
      *                                                                                       CLE134
     C                   OTHER
     C                   CALL      'ZALIGN'
     C     W0RTN         PARM      *BLANKS       WQ0001
     C                   PARM      #2SFAM        WQ0002
     C                   PARM      0             WQ0003
     C                   PARM      13            WQ0004
     C                   PARM      *BLANKS       WQ0005
      *                                                                                       CLE134
     C     W0RTN         IFEQ      *BLANKS
     C                   MOVE      WQ0005        N#SFAM
      *                                                                                       CLE134
     C                   CALL      'ZEDIT'
     C                   PARM                    WQ0005
     C                   PARM                    WQ0003
     C                   MOVE      WQ0005        #2SFAM
      *                                                                                       CLE134
     C                   ELSE
     C                   MOVE      *ON           *IN51
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'USR5423'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CLE134
     C                   ENDSL
      *                                                                                       CLE134
      ** Suspended Fee Payments Maximum                                                       CLE134
      *                                                                                       CLE134
     C                   Z-ADD     0             N#SFPM
     C                   SELECT
     C     #2FEMC        WHENEQ    'S'
     C     #2SFPM        ANDEQ     *BLANKS
     C     #2FEMC        OREQ      'T'
     C     #2SFPM        ANDEQ     *BLANKS
     C                   MOVE      *ON           *IN52
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'USR5438'     ZAMSID
     C                   EXSR      ZASNMS
      *                                                                                       CLE134
     C     #2SFPM        WHENEQ    *BLANKS
      *                                                                                       CLE134
     C                   OTHER
     C                   CALL      'ZALIGN'
     C     W0RTN         PARM      *BLANKS       WQ0001
     C                   PARM      #2SFPM        WQ0002
     C                   PARM      0             WQ0003
     C                   PARM      3             WQ0004
     C                   PARM      *BLANKS       WQ0005
      *                                                                                       CLE134
     C     W0RTN         IFEQ      *BLANKS
     C                   MOVE      WQ0005        N#SFPM
      *                                                                                       CLE134
     C                   CALL      'ZEDIT'
     C                   PARM                    WQ0005
     C                   PARM                    WQ0003
     C                   MOVE      WQ0005        #2SFPM
      *                                                                                       CLE134
     C                   ELSE
     C                   MOVE      *ON           *IN52
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'USR5423'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CLE134
     C                   ENDSL
      *                                                                                       CLE134
      ** Partial Payment Allowed                                                              CLE134
      *                                                                                       CLE134
     C     #2FPYA        IFEQ      *BLANK
     C                   MOVE      'N'           #2FPYA
     C                   ENDIF
      *                                                                                       CLE134
     C     #2FPYA        IFNE      'Y'
     C     #2FPYA        ANDNE     'N'
     C     #2FPYA        ANDNE     'P'
     C                   MOVE      *ON           *IN47
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'USR5432'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CLE134
      ** Partial Indicator                                                                    CLE134
      *                                                                                       CLE134
     C     #2FPYA        IFEQ      'P'
     C     #2PSIN        ANDNE     'A'
     C     #2PSIN        ANDNE     'P'
     C                   MOVE      *ON           *IN53
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'USR5460'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CLE134
     C     #2FPYA        IFNE      'P'
     C     #2PSIN        ANDNE     *BLANK
     C                   MOVE      *ON           *IN53
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'USR5461'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CLE134
      ** Partial Limit                                                                        CLE134
      *                                                                                       CLE134
     C                   Z-ADD     0             N#PSLM
     C                   SELECT
      *                                                                                       CLE134
     C     #2PSIN        WHENEQ    *BLANK
     C     #2PSLM        ANDNE     *BLANK
     C                   MOVE      *ON           *IN54
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'USR5462'     ZAMSID
     C                   EXSR      ZASNMS
      *                                                                                       CLE134
     C     #2PSLM        WHENEQ    *BLANK
      *                                                                                       CLE134
     C                   OTHER
     C                   CALL      'ZALIGN'
     C     W0RTN         PARM      *BLANKS       WQ0001
     C                   PARM      #2PSLM        WQ0002
     C                   PARM      0             WQ0003
     C                   PARM      13            WQ0004
     C                   PARM      *BLANKS       WQ0005
      *                                                                                       CLE134
     C     W0RTN         IFEQ      *BLANKS
     C                   MOVE      WQ0005        N#PSLM
     C                   CALL      'ZEDIT'
     C                   PARM                    WQ0005
     C                   PARM                    WQ0003
     C                   MOVE      WQ0005        #2PSLM
      *                                                                                       CLE134
     C                   ELSE
     C                   MOVE      *ON           *IN54
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'USR5423'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDSL
      *                                                                                       CLE134
      ** Further checks if valid amount/%age entered:                                         CLE134
      *                                                                                       CLE134
     C     *IN54         IFEQ      *OFF
      *                                                                                       CLE134
     C     #2PSIN        IFEQ      'A'
     C     N#PSLM        ANDLE     0
     C                   MOVE      *ON           *IN54
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'USR5463'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CLE134
     C     #2PSIN        IFEQ      'P'
     C     N#PSLM        ANDLE     0
     C     #2PSIN        OREQ      'P'
     C     N#PSLM        ANDGT     100
     C                   MOVE      *ON           *IN54
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'USR5464'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CLE134
     C                   ENDIF
      *                                                                                       262672
      ** Early Maturity Condition                                                             262672
      *                                                                                       262672
     C     #2FSFA        IFNE      'Y'
     C                   MOVE      *BLANKS       #2FEMC
      *                                                                                       262672
     C                   ELSE
     C     #2FEMC        IFEQ      *BLANK
     C                   MOVE      'S'           #2FEMC
     C                   ENDIF
      *                                                                                       262672
     C     #2FEMC        IFNE      'A'
     C     #2FEMC        ANDNE     'T'
     C     #2FEMC        ANDNE     'S'
     C                   MOVE      *ON           *IN46
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'USR5465'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE134
      ** Grace Period                                                                         CLE134
      *                                                                                       CLE134
     C     #2GDPR        IFEQ      *BLANK
     C                   MOVE      BPGRPR        #2GDPR
     C                   ENDIF
      *                                                                                       CLE134
     C     DIGITS        CHECK     #2GDPR        WPOS              3 0
      *                                                                                       CLE134
     C     WPOS          IFGT      0
     C                   MOVE      *ON           *IN48
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'USR5440'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CLE134
      ** Pre-checking Order                                                                   CLE134
      *                                                                                       CLE134
     C                   MOVEL     *BLANKS       PGERR             1
      *                                                                                       CLE164
     C                   MOVEL     #2CLT1        NPDCL             1
      *                                                                                       CLE164
     C     #2PGID        IFEQ      *BLANKS
     C     NPDCL         ANDEQ     'Z'
     C                   MOVE      *ON           *IN49
     C                   MOVE      *ON           *IN97
     C                   MOVE      'Y'           PGERR
     C                   MOVEL     'USR9899'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C********** #2PCKO    IFNE *BLANKS                                                CLE134 CLE164
     C     #2PGID        IFNE      *BLANKS
     C********** DIGITS    CHECK#2PCKO    WPOS                                         CLE134 CLE164
     C     #2PGID        IFEQ      '?'
     C                   EXSR      SLPGID
     C                   ENDIF
     C     ALPHAN        CHECK     #2PGID        NUM               1 0    68
      *                                                                                       CLE134
     C********** WPOS      IFGT 0                                                      CLE134 CLE164
     C     *IN68         IFEQ      '1'
     C                   MOVE      *ON           *IN49
     C                   MOVE      *ON           *IN97
     C**********           MOVEL'USR5427' ZAMSID                                       CLE134 CLE164
     C                   MOVEL     'USR5417'     ZAMSID
     C                   MOVEL     'Y'           PGERR
     C                   EXSR      ZASNMS
     C                   ENDIF
     C     PGERR         IFEQ      *BLANKS
     C     #2PGID        CHAIN     SDPRGPI0                           68
     C     *IN68         IFEQ      '1'
     C                   MOVEL     'USR9717'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9749
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE134
     C                   ENDIF
      *                                                                                       CER050
     C     CER050        IFEQ      'Y'
      *                                                                                       CER050
     C     #1IAPR        IFEQ      *BLANKS
     C                   MOVE      'N'           #1IAPR
     C                   ELSE
     C     #1IAPR        IFNE      'Y'
     C     #1IAPR        ANDNE     'N'
     C                   MOVE      *ON           *IN65
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'SDX0460'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CER050
     C     #1MINF        IFNE      *BLANKS
     C     #1IAPR        ANDNE     'N'
     C                   CALL      'ZALIGN'
     C     W0RTN         PARM      *BLANKS       WQ0001
     C                   PARM      #1MINF        WQ0002
     C                   PARM      A6NBDP        WQ0003
     C                   PARM      @@NDEC        WQ0004
     C                   PARM      *BLANKS       WQ0005
     C     W0RTN         IFEQ      *BLANKS
     C                   MOVE      WQ0005        N#MINF
     C                   CALL      'ZEDIT'
     C                   PARM      WQ0005        WQ0002
     C                   PARM      A6NBDP        WQ0003
     C                   MOVE      WQ0002        #1MINF
     C                   ELSE
     C                   MOVE      *ON           *IN66
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'SDX0461'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ELSE
     C     #1MINF        IFNE      *BLANKS
     C                   MOVE      *ON           *IN66
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'ER00116'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C**********           MOVE *BLANKS   #1MINF                                     CER050 MD054016
     C**********           Z-ADD0         N#MINF                                     CER050 MD054016
     C                   ENDIF
      *                                                                                       CER050
     C                   ENDIF
      *                                                                                       CER050
     C                   ENDSR
      /EJECT                                                                               AR1022007
     CSR   SMVAL         BEGSR
      *================================================================                    AR1022007
      * SMVAL: Vadlidate Additional Details introduced by AR1022007                        AR1022007
      *================================================================                    AR1022007
      ** Validate Interest Past Due SM007/CRE073 fields                                    AR1022007
      *                                                                                    AR1022007
     C     CRE073        IFEQ      'Y'
      *                                                                                    AR1022007
      ** If no Past Due Loan Type entered;                                                 AR1022007
      ** - Input not allowed: Contr. spread                                                AR1022007
      *                                                                                    AR1022007
     C     C#LTST        IFEQ      *BLANKS
      *                                                                                    AR1022007
     C     #UPCSP        IFNE      *BLANKS
     C                   MOVE      *ON           *IN60
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'USR5410'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                    AR1022007
      ** - Input not allowed: Contr. spread ind.                                           AR1022007
      *                                                                                    AR1022007
     C     #UPCSG        IFNE      *BLANKS
     C                   MOVE      *ON           *IN61
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'USR5410'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                    AR1022007
      ** - Input not allowed: Rounding method                                              AR1022007
      *                                                                                    AR1022007
     C     #UPRMT        IFNE      *BLANKS
     C                   MOVE      *ON           *IN62
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'USR5410'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                    AR1022007
      ** - Input not allowed: Rounding fraction/decimal                                    AR1022007
      *                                                                                    AR1022007
     C     #UPRFD        IFNE      *BLANKS
     C                   MOVE      *ON           *IN63
     C                   MOVE      *ON           *IN97
     C                   MOVEL     'USR5410'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                    AR1022007
      ** ELSE Past Due Loan Type entered;                                                  AR1022007
      ** - Input mandatory.                                                                AR1022007
      *                                                                                    AR1022007
     C                   ELSE
      *                                                                                    AR1022007
      ** Validate contr. spread/spread ind input                                           AR1022007
      *                                                                                    AR1022007
     C                   CALL      'ZAVCSPSG'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      *BLANKS       WBSRT            12
     C                   PARM                    #2CBSR
     C                   PARM                    #2CBRT
     C**********           PARM *BLANKS   VALFRT 12                              AR1022007 AR1093473
     C                   PARM      #UPCSP        PRMCSP           12
     C                   PARM                    #UPCSG
     C                   PARM      0             TMCNSP           11 7
     C                   PARM      'LOAN'        PMOD              6
     C                   PARM      0             PCUR              2 0
     C                   PARM      *BLANKS       AFLDNM
     C                   PARM      *BLANKS       AMSGID
     C                   PARM      *BLANKS       AMGDTA
     C                   PARM      0             AR1               3 0
     C                   PARM                    WCSPOK            1
     C                   PARM                    WCSGOK            1
      *                                                                                    AR1022007
      ** Set indicators of invalid spread rate/ind input                                   AR1022007
      *                                                                                    AR1022007
     C     WCSPOK        IFEQ      'N'
     C                   MOVE      *ON           *IN60
     C                   MOVE      *ON           *IN97
     C                   ELSE
      *                                                                                    AR1022007
      ** Prepare spread input as decimal                                                   AR1022007
      *                                                                                    AR1022007
     C     #UPCSP        IFNE      *BLANKS
     C                   CALL      'ZALIGN'
     C     W0RTN         PARM      *BLANKS       WQ0001            7
     C                   PARM      #UPCSP        WQ0002           16
     C                   PARM      7             WQ0003            1 0
     C                   PARM      4             WQ0004            2 0
     C                   PARM      *BLANKS       WQ0005           16
     C     W0RTN         IFEQ      *BLANKS
     C                   MOVE      WQ0005        N#CSP            11 7
     C                   CALL      'ZEDIT'
     C                   PARM                    WQ0005           16
     C                   PARM      7             WQ0003            1 0
     C                   MOVE      WQ0005        #UPCSP
     C                   ENDIF
     C                   ENDIF
      *                                                                                    AR1022007
     C                   ENDIF
      *                                                                                    AR1022007
     C     WCSGOK        IFEQ      'N'
     C                   MOVE      *ON           *IN61
     C                   MOVE      *ON           *IN97
     C                   ENDIF
      *                                                                                    AR1022007
      ** Rounding method must be of valid value                                            AR1022007
      *                                                                                    AR1022007
     C                   CALL      'ZAVRNDMT'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    #UPRMT
     C                   PARM      #UPCSP        PRMCSP           12
     C                   PARM                    #UPRFD
     C                   PARM      *BLANKS       PMOD              6
     C                   PARM      0             PCUR              2 0
     C                   PARM                    AFLDNM
     C                   PARM                    AMSGID
     C                   PARM                    AMGDTA
     C                   PARM                    AR1
     C                   PARM                    WDRMOK            1
      *                                                                                    AR1022007
      ** Set indicators of invalid rounding method input                                   AR1022007
      *                                                                                    AR1022007
     C     WDRMOK        IFEQ      'N'
     C                   MOVE      *ON           *IN62
     C                   MOVE      *ON           *IN97
     C                   ENDIF
      *                                                                                    AR1022007
      ** Rounding fraction/decimal must be of valid value                                  AR1022007
      *                                                                                    AR1022007
     C                   CALL      'ZAVRNDFD'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    #UPRFD
     C                   PARM      #UPCSP        PRMCSP           12
     C                   PARM                    #UPRMT
     C                   PARM      *BLANKS       PMOD              6
     C                   PARM      0             PCUR              2 0
     C                   PARM                    AFLDNM
     C                   PARM                    AMSGID
     C                   PARM                    AMGDTA
     C                   PARM                    AR1               3 0
     C                   PARM                    WDRDOK            1
      *                                                                                    AR1022007
      ** Set indicators of invalid rounding fraction input                                 AR1022007
      *                                                                                    AR1022007
     C     WDRDOK        IFEQ      'N'
     C                   MOVE      *ON           *IN63
     C                   MOVE      *ON           *IN97
     C                   ENDIF
      *                                                                                    AR1022007
      ** Set error messages for invalid CRE073 fields                                      AR1022007
      *                                                                                    AR1022007
     C                   Z-ADD     1             AR1
     C     AMSGID(AR1)   DOWNE     *BLANKS
     C                   MOVEL     AMSGID(AR1)   ZAMSID
     C                   ADD       1             AR1
      *                                                                                    AR1022007
      ** Set more appropriate error msg for particular SM007/CRE073 error                  AR1022007
      ** - Invalid spread indicator msg                                                    AR1022007
      *                                                                                    AR1022007
     C     ZAMSID        IFEQ      'USR9026'
     C                   MOVEL     'USR5425'     ZAMSID
     C                   ENDIF
      *                                                                                    AR1022007
     C                   EXSR      ZASNMS
     C                   ENDDO
      *                                                                                    AR1022007
     C                   ENDIF
      *                                                                                    AR1022007
     C                   ENDIF
      *                                                                                    AR1022007
     C                   ENDSR
      /EJECT
     CSR   FACHMD        BEGSR
      *================================================================
      * Switch between *ADD/*CHANGE modes
      *================================================================
     C     W0PMD         IFNE      'ADD'
     C                   MOVEL     'ADD'         W0PMD
     C                   ELSE
     C                   MOVEL     'CHG'         W0PMD
     C                   END
     C                   EXSR      FBRQRL
      *================================================================
     CSR   FAEXIT        ENDSR
      /EJECT
     CSR   FBRQRL        BEGSR
      *================================================================
      * Request subfile reload
      *================================================================
     C                   MOVEL     'Y'           W0RSF
      *================================================================
     CSR   FBEXIT        ENDSR
      /EJECT
     CSR   GADSA1        BEGSR
      *================================================================
      * Set display attributes for Subfile record
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
      * Protect keys if change mode or updated record
     C                   SETON                                        88        *
     C   89
     CANN87              SETOFF                                       88        *
     C                   MOVEL     *IN87         *IN79
     C     WUDELA        IFEQ      'N'                                          *IF
     C                   MOVEL     '1'           *IN79
     C                   END                                                    *FI
      *                                                                                       CLE134
     C     CLE134        IFEQ      'Y'
     C     W0PMD         ANDNE     'ADD'
     C     CER050        OREQ      'Y'
     C     W0PMD         ANDNE     'ADD'
     C                   MOVE      *OFF          *IN79
     C                   ENDIF
      *================================================================
     CSR   GAEXIT        ENDSR
      /EJECT
     CSR   GBDSA2        BEGSR
      *================================================================
      * Set display attributes for Subfile control
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
      *================================================================
     CSR   GBEXIT        ENDSR
      /EJECT
     CSR   MAIZ#1        BEGSR
      *================================================================
      * Initialise subfile record
      *================================================================
      * Previous values
     C                   MOVEL     *BLANK        #1DBRC
     C                   Z-ADD     *ZERO         #1LCD                          Last Change Dat
     C                   MOVEL     *BLANK        #1TYLC                         Type of Last Ch
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
     C                   MOVEL     *BLANK        #1FECD                         Fee Code
     C                   MOVEL     *BLANK        #1FENV                         Fee Narrative
     C                   MOVEL     *BLANK        #1ADJY
     C/COPY WNCPYSRC,SD0320MC11
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @AURECR fields to subfile
      *================================================================
     C                   Z-ADD     AULCD         #1LCD                          Last Change Dat
     C                   MOVEL     AUTYLC        #1TYLC                         Type of Last Ch
     C                   MOVEL     AUFECD        #1FECD                         Fee Code
     C                   MOVEL     AUFENV        #1FENV                         Fee Narrative
     C                   MOVEL     AUADJY        #1ADJY
     C/COPY WNCPYSRC,SD0320MC12
      * Hold current record image for change detection
     C                   MOVEL     @1DBRC        #1DBRC
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MEIZ#2        BEGSR
      *================================================================
      * Initialise subfile control
      *================================================================
     C                   MOVEL     *BLANK        #2FECD                         Fee Code
      *================================================================
     CSR   MEEXIT        ENDSR
      /EJECT
     CSR   SACRRC        BEGSR
      *================================================================
      * Create Fee Codes - Fee Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
     C                   CLEAR                   @AURECQ
      * Move all fields to @AURECQ
     C                   MOVEL     #1FECD        AUFECD                         Fee Code
     C                   Z-ADD     WURDNB        AULCD                          Last Change Dat
     C                   MOVEL     'I'           AUTYLC                         Type of Last Ch
     C                   MOVEL     #1FENV        AUFENV                         Fee Narrative
     C                   MOVEL     #1ADJY        AUADJY
     C                   MOVE      'N'           AUIAPR
     C                   Z-ADD     0             AUMINF
      *
     C     KLCRSA        KLIST
     C                   KFLD                    AUFECD                         Fee Code
      * Check for duplicate primary key
     C     KLCRSA        SETLL     @AURECQ                                90    *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'USR0048'     W0RTN             7
      * Send message 'Fee Codes              EX'
     C                   MOVEL     'USR0048'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      SAEXIT
     C/COPY WNCPYSRC,SD0320MC13
     C                   END
      *
     C                   WRITE     @AURECQ                              91      *
      *
     C     *IN91         IFEQ      '1'
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
     C/COPY WNCPYSRC,SDH00136
      * USER: Processing after Data update
     C                   Z-ADD     1             WUNORC                         No. of Records
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
     C                   Z-ADD     1             WUNOIN                         No. of Inserts
      * Start of SAR S01117
      * Change code to filename FEE - SDFEEPD
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SBCHRC
      * End of SAR S01117
      * Update TABLEUQ - Fee Codes  *
     C                   CALL      'TABLEUQ'                            90      Update TABLEUQ
     C     W0RTN         PARM      *BLANK        WQ0006            7            *Return code
     C                   PARM      AUFECD        WQ0007            2            Fee Code
     C                   PARM      AUFENV        WQ0008           20            Fee Narrative
     C                   PARM      AUTYLC        WQ0009            1            Type of Last Ch
     C                   PARM      WURDNB        WQ0010            5 0          Run day number
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'TABLEUQ'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        98        *
     C                   END
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
      * Send message 'Unable to update'
     C                   MOVEL     'USR0015'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98        *
      *
     C                   END                                                    *FI
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBCHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YARDC             1
      *
      * Move key fields to @AHREAU
     C                   MOVE      *BLANK        AHFLNM                         Filename
     C                   MOVEL     'SDFEEPD'     AHFLNM                         Filename
      *
     C     KLCHSB        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C*****KLCHSB        CHAIN     @AHREAU                            9091      *           MD061007
     C                   CALL      'SD000119'                                               MD061007
     C                   PARM      '*RTV'        ZMODE             4                        MD061007
     C                   PARM                    AHFLNM                                     MD061007
     C                   PARM      0             AHNORC                                     MD061007
     C                   PARM      0             AHNOIN                                     MD061007
     C                   PARM      0             AHNOAM                                     MD061007
     C                   PARM      0             AHNODL                                     MD061007
     C                   PARM      *BLANKS       ZRETRN           10                        MD061007
      *                                                                                     MD061007
     C                   SETOFF                                       9091                  MD061007
     C     ZRETRN        IFEQ      '*NRF'                                                   MD061007
     C                   SETON                                        90                    MD061007
     C                   ENDIF                                                              MD061007
     C     ZRETRN        IFEQ      '*ERROR'                                                 MD061007
     C                   SETON                                        91                    MD061007
     C                   ENDIF                                                              MD061007
      *                                                                                     MD061007
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SBEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SBEXIT
     C                   END
      *
      * Store record data for null update check
     C                   MOVE      QSDFC1        YARDCS
      * USER: Processing after Data read
     C                   ADD       AHNORC        WUNORC                         No. of Records
     C                   ADD       AHNOIN        WUNOIN                         No. of Inserts
     C                   ADD       AHNOAM        WUNOAM                         No. of Amends
     C                   ADD       AHNODL        WUNODL                         No. of Deletes
      * Move non-key fields to @AHREAU
     C                   Z-ADD     WUNORC        AHNORC                         No. of Records
     C                   Z-ADD     WUNOIN        AHNOIN                         No. of Inserts
     C                   Z-ADD     WUNOAM        AHNOAM                         No. of Amends
     C                   Z-ADD     WUNODL        AHNODL                         No. of Deletes
      *
      * Set PGM.*Record Data Changed flag
     C     QSDFC1        IFNE      YARDCS
     C                   MOVE      'Y'           YARDC
     C                   END
      * If changed update record otherwise release record
     C     YARDC         IFEQ      'Y'
     C**********         UPDATE    @AHREAU                              91      *           MD061007
     C                   CALL      'SD000119'                                               MD061007
     C                   PARM      '*UPD'        ZMODE                                      MD061007
     C                   PARM                    AHFLNM                                     MD061007
     C                   PARM                    AHNORC                                     MD061007
     C                   PARM                    AHNOIN                                     MD061007
     C                   PARM                    AHNOAM                                     MD061007
     C                   PARM                    AHNODL                                     MD061007
     C                   PARM      *BLANKS       ZRETRN                                     MD061007
                                                                                            MD061007
     C                   SETOFF                                       91                    MD061007
     C     ZRETRN        IFNE      *BLANKS                                                  MD061007
     C                   SETON                                        91                    MD061007
     C                   ENDIF                                                              MD061007
                                                                                            MD061007
     C                   ELSE
      * Release record lock
     C**********         UNLOCK    SDFCTLL0                             91      *           MD061007
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SBEXIT        ENDSR
      /EJECT
     CSR   SCDLRC        BEGSR
      *================================================================
      * Delete Fee Codes - Fee Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @AURECQ
     C                   MOVEL     #1FECD        AUFECD                         Fee Code
      *
     C     KLDLSC        KLIST
     C                   KFLD                    AUFECD                         Fee Code
     C     KLDLSC        CHAIN     @AURECQ                            9091      *
     C     *IN90         IFEQ      '1'
      * Record already deleted
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SCEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
      * Send message '*Database operation error'
     C                   MOVEL     'Y2U0004'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SCEXIT
     C                   END
      *
      * Check for changed record
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Release record lock
     C     KLDLSC        SETLL     @AURECQ                            9091      *
     C                   GOTO      SCEXIT
     C                   END                                                    FI #1DBRC
      *................................................................
     C/COPY WNCPYSRC,SD0320MC14
     C                   DELETE    @AURECQ                              91      *
     C     *IN91         IFEQ      '1'
      * Delete error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
     C/COPY WNCPYSRC,SDH00137
      * DBF delete successful
      * USER: Processing after Data update
      * WUDELR Data Structure - SD Deleted Records File  *
     C                   MOVEL     @1DBRC        WUDELR
      * Write Deleted Record - SD Deleted Records File  *
     C                   CLEAR                   PARC
     C                   MOVEL     'SDFEEPD'     PAFNME                         File name
     C                   MOVEL     #1FECD        PALKEY                         Long Key
     C                   MOVEL     WUDR01        PADR01                         Deleted Data Re
     C                   MOVEL     WUDR02        PADR02                         Deleted Data Re
     C                   MOVEL     WUDR03        PADR03                         Deleted Data Re
     C                   MOVEL     WUDR04        PADR04                         Deleted Data Re
     C                   MOVEL     WUDR05        PADR05                         Deleted Data Re
     C                   MOVEL     WUDR06        PADR06                         Deleted Data Re
     C                   MOVEL     WUDR07        PADR07                         Deleted Data Re
     C                   MOVEL     WUDR08        PADR08                         Deleted Data Re
     C                   MOVEL     WUDR09        PADR09                         Deleted Data Re
     C                   MOVEL     WUDR00        PADR00                         Deleted Data Re
     C                   MOVEL     WUDR11        PADR11                         Deleted Data Re
     C                   MOVEL     WUDR12        PADR12                         Deleted Data Re
     C                   Z-ADD     WURDNB        PALCD                          Last Change Dat
     C                   MOVEL     'D'           PATYLC                         Type of Last Ch
      *
     C                   CALL      'SD0520X'                            90      Write Deleted R
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM                    PARC                           RCD: SD Deleted
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0520X'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        9833      *
     C                   END
     C                   Z-ADD     -1            WUNORC                         No. of Records
     C                   Z-ADD     1             WUNODL                         No. of Deletes
     C                   Z-ADD     *ZERO         WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
      * Start of SAR S01117
      * Change code to filename FEE - SDFEEPD
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SDCHRC
      * End of SAR S01117
     C                   MOVEL     'D'           WUTYLC                         Type of Last Ch
      * Update TABLEUQ - Fee Codes  *
     C                   CALL      'TABLEUQ'                            90      Update TABLEUQ
     C     W0RTN         PARM      *BLANK        WQ0011            7            *Return code
     C                   PARM      AUFECD        WQ0012            2            Fee Code
     C                   PARM      AUFENV        WQ0013           20            Fee Narrative
     C                   PARM      WUTYLC        WQ0014            1            Type of Last Ch
     C                   PARM      WURDNB        WQ0015            5 0          Run day number
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'TABLEUQ'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        98        *
     C                   END
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
      * Send message 'Unable to update'
     C                   MOVEL     'USR0015'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98        *
      *
     C                   END                                                    *FI
     C                   END
      *================================================================
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   SDCHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YBRDC             1
      *
      * Move key fields to @AHREAU
     C                   MOVE      *BLANK        AHFLNM                         Filename
     C                   MOVEL     'SDFEEPD'     AHFLNM                         Filename
      *
     C     KLCHSD        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C*****KLCHSD        CHAIN     @AHREAU                            9091      *           MD061007
     C                   CALL      'SD000119'                                               MD061007
     C                   PARM      '*RTV'        ZMODE             4                        MD061007
     C                   PARM                    AHFLNM                                     MD061007
     C                   PARM      0             AHNORC                                     MD061007
     C                   PARM      0             AHNOIN                                     MD061007
     C                   PARM      0             AHNOAM                                     MD061007
     C                   PARM      0             AHNODL                                     MD061007
     C                   PARM      *BLANKS       ZRETRN           10                        MD061007
      *                                                                                     MD061007
     C                   SETOFF                                       9091                  MD061007
     C     ZRETRN        IFEQ      '*NRF'                                                   MD061007
     C                   SETON                                        90                    MD061007
     C                   ENDIF                                                              MD061007
     C     ZRETRN        IFEQ      '*ERROR'                                                 MD061007
     C                   SETON                                        91                    MD061007
     C                   ENDIF                                                              MD061007
      *                                                                                     MD061007
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SDEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SDEXIT
     C                   END
      *
      * Store record data for null update check
     C                   MOVE      QSDFC1        YBRDCS
      * USER: Processing after Data read
     C                   ADD       AHNORC        WUNORC                         No. of Records
     C                   ADD       AHNOIN        WUNOIN                         No. of Inserts
     C                   ADD       AHNOAM        WUNOAM                         No. of Amends
     C                   ADD       AHNODL        WUNODL                         No. of Deletes
      * Move non-key fields to @AHREAU
     C                   Z-ADD     WUNORC        AHNORC                         No. of Records
     C                   Z-ADD     WUNOIN        AHNOIN                         No. of Inserts
     C                   Z-ADD     WUNOAM        AHNOAM                         No. of Amends
     C                   Z-ADD     WUNODL        AHNODL                         No. of Deletes
      *
      * Set PGM.*Record Data Changed flag
     C     QSDFC1        IFNE      YBRDCS
     C                   MOVE      'Y'           YBRDC
     C                   END
      * If changed update record otherwise release record
     C     YBRDC         IFEQ      'Y'
     C**********         UPDATE    @AHREAU                              91      *           MD061007
     C                   CALL      'SD000119'                                               MD061007
     C                   PARM      '*UPD'        ZMODE                                      MD061007
     C                   PARM                    AHFLNM                                     MD061007
     C                   PARM                    AHNORC                                     MD061007
     C                   PARM                    AHNOIN                                     MD061007
     C                   PARM                    AHNOAM                                     MD061007
     C                   PARM                    AHNODL                                     MD061007
     C                   PARM      *BLANKS       ZRETRN                                     MD061007
                                                                                            MD061007
     C                   SETOFF                                       91                    MD061007
     C     ZRETRN        IFNE      *BLANKS                                                  MD061007
     C                   SETON                                        91                    MD061007
     C                   ENDIF                                                              MD061007
                                                                                            MD061007
     C                   ELSE
      * Release record lock
     C**********         UNLOCK    SDFCTLL0                             91      *           MD061007
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SDEXIT        ENDSR
      /EJECT
     CSR   SECHRC        BEGSR
      *================================================================
      * Change Fee Codes - Fee Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YCRDC             1
      *
      * Move key fields to @AURECQ
     C                   MOVEL     #1FECD        AUFECD                         Fee Code
      *
     C     KLCHSE        KLIST
     C                   KFLD                    AUFECD                         Fee Code
     C     KLCHSE        CHAIN     @AURECQ                            9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SEEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SEEXIT
     C                   END
      *
      * Check for changed record
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Release record lock
     C                   UNLOCK    SDFEEL0                              91      *
     C                   GOTO      SEEXIT
     C                   END                                                    FI #1DBRC
      * Store record data for null update check
     C                   MOVE      @1DBRC        YCRDCS
      * Move non-key fields to @AURECQ
     C                   Z-ADD     WURDNB        AULCD                          Last Change Dat
     C                   MOVEL     'A'           AUTYLC                         Type of Last Ch
     C                   MOVEL     #1FENV        AUFENV                         Fee Narrative
     C                   MOVEL     #1ADJY        AUADJY
      *                                                                                       CLE134
     C     CLE134        IFEQ      'Y'
     C     #1F12         ANDEQ     *OFF
     C                   MOVE      #2CLTY        AUCLTY
     C                   MOVE      #2CLST        AUCLST
     C                   MOVE      #2CLCL        AUCLCL
     C                   MOVE      #2CBSR        AUCBSR
     C     CLE036        IFEQ      'Y'
     C                   MOVE      N#CBRT        AUCBRT
     C                   ENDIF
     C                   Z-ADD     N#CRSP        AUCRSP
     C                   MOVE      #2CRIN        AUCRIN
     C                   MOVE      #2BSRI        AUBSRI
     C     #2ICBS        IFNE      *BLANKS
     C                   MOVE      #2ICBS        AUICBS
     C                   ELSE
     C                   MOVE      *ZEROS        AUICBS
     C                   END
     C                   MOVE      #2OVRA        AUOVRA
     C                   MOVE      #2FAMU        AUFAMU
      *                                                                                       CLE134
      ** Save old value 'Suspend Fee Allowed'                                                 CLE134
      *                                                                                       CLE134
     C                   MOVE      AUFSFA        O#FSFA            1
     C                   MOVE      #2FSFA        AUFSFA
     C                   Z-ADD     N#SFAM        AUSFAM
     C                   Z-ADD     N#SFPM        AUSFPM
     C                   MOVE      #2FPYA        AUFPYA
     C                   MOVE      #2PSIN        AUPSIN
     C                   Z-ADD     N#PSLM        AUPSLM
     C                   MOVE      #2FEMC        AUFEMC
     C                   MOVE      #2GDPR        AUGDPR
     C**********           MOVE #2PCKO    AUPCKO                                       CLE134 CLE164
     C                   MOVE      #2PGID        AUPGID
     C     AUPGID        CHAIN     SDPRGPI0                           86
     C     *IN86         IFEQ      '0'
     C                   MOVE      PGDESC        #2PDES
     C                   ELSE
     C                   MOVE      *BLANKS       #2PDES
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE134
      ** Initialize and set if SM007/CRE073 is active.                                     AR1022007
      *                                                                                    AR1022007
     C     CRE073        IFEQ      'Y'
     C     #1F12         ANDEQ     *OFF
     C                   Z-ADD     0             AUPCSP
     C                   MOVE      *BLANKS       AUPCSG
     C                   MOVE      *BLANKS       AUPFMT
     C                   MOVE      *BLANKS       AUPRFD
      *                                                                                    AR1022007
     C     UPLST         IFNE      *BLANK
     C                   Z-ADD     N#CSP         AUPCSP
     C                   MOVE      #UPCSG        AUPCSG
     C                   MOVE      #UPRMT        AUPFMT
     C                   MOVE      #UPRFD        AUPRFD
     C                   ENDIF
      *                                                                                    AR1022007
     C                   ENDIF
      *                                                                                    AR1022007
     C     CER050        IFEQ      'Y'
     C     #1F12         ANDEQ     *OFF
     C                   MOVE      #1IAPR        AUIAPR
     C                   MOVE      N#MINF        AUMINF
     C                   ENDIF
     C/COPY WNCPYSRC,SD0320MC15
      *
      * Set PGM.*Record Data Changed flag
     C     @1DBRC        IFNE      YCRDCS
     C                   MOVE      'Y'           YCRDC
     C                   END
      * If changed update record otherwise release record
     C     YCRDC         IFEQ      'Y'
     C                   UPDATE    @AURECQ                              91      *
      *                                                                                       CLE134
      ** Update live fees                                                                     CLE134
      *                                                                                       CLE134
     C     CLE134        IFEQ      'Y'
     C     #1F12         ANDEQ     *OFF
     C                   EXSR      UPDFEE
     C                   ENDIF
      *                                                                                       CLE134
     C                   ELSE
      * Release record lock
     C                   UNLOCK    SDFEEL0                              91      *
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
     C/COPY WNCPYSRC,SDH00138
      *
      * Update saved record image
     C                   MOVEL     @1DBRC        #1DBRC
      * DBF change successful
      * USER: Processing after Data update
     C                   Z-ADD     *ZERO         WUNORC                         No. of Records
     C                   Z-ADD     *ZERO         WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
     C                   Z-ADD     1             WUNOAM                         No. of Amends
      * Start of SAR S01117
      * Change code to filename FEE - SDFEEPD
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SFCHRC
      * End of SAR S01117
      * Update TABLEUQ - Fee Codes  *
     C                   CALL      'TABLEUQ'                            90      Update TABLEUQ
     C     W0RTN         PARM      *BLANK        WQ0016            7            *Return code
     C                   PARM      AUFECD        WQ0017            2            Fee Code
     C                   PARM      AUFENV        WQ0018           20            Fee Narrative
     C                   PARM      AUTYLC        WQ0019            1            Type of Last Ch
     C                   PARM      WURDNB        WQ0020            5 0          Run day number
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'TABLEUQ'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        98        *
     C                   END
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
      * Send message 'Unable to update'
     C                   MOVEL     'USR0015'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98        *
      *
     C                   END                                                    *FI
     C                   END
      *================================================================
     CSR   SEEXIT        ENDSR
      /EJECT
     CSR   SFCHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YDRDC             1
      *
      * Move key fields to @AHREAU
     C                   MOVE      *BLANK        AHFLNM                         Filename
     C                   MOVEL     'SDFEEPD'     AHFLNM                         Filename
      *
     C     KLCHSF        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C*****KLCHSF        CHAIN     @AHREAU                            9091      *           MD061007
     C                   CALL      'SD000119'                                               MD061007
     C                   PARM      '*RTV'        ZMODE             4                        MD061007
     C                   PARM                    AHFLNM                                     MD061007
     C                   PARM      0             AHNORC                                     MD061007
     C                   PARM      0             AHNOIN                                     MD061007
     C                   PARM      0             AHNOAM                                     MD061007
     C                   PARM      0             AHNODL                                     MD061007
     C                   PARM      *BLANKS       ZRETRN           10                        MD061007
      *                                                                                     MD061007
     C                   SETOFF                                       9091                  MD061007
     C     ZRETRN        IFEQ      '*NRF'                                                   MD061007
     C                   SETON                                        90                    MD061007
     C                   ENDIF                                                              MD061007
     C     ZRETRN        IFEQ      '*ERROR'                                                 MD061007
     C                   SETON                                        91                    MD061007
     C                   ENDIF                                                              MD061007
      *                                                                                     MD061007
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SFEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SFEXIT
     C                   END
      *
      * Store record data for null update check
     C                   MOVE      QSDFC1        YDRDCS
      * USER: Processing after Data read
     C                   ADD       AHNORC        WUNORC                         No. of Records
     C                   ADD       AHNOIN        WUNOIN                         No. of Inserts
     C                   ADD       AHNOAM        WUNOAM                         No. of Amends
     C                   ADD       AHNODL        WUNODL                         No. of Deletes
      * Move non-key fields to @AHREAU
     C                   Z-ADD     WUNORC        AHNORC                         No. of Records
     C                   Z-ADD     WUNOIN        AHNOIN                         No. of Inserts
     C                   Z-ADD     WUNOAM        AHNOAM                         No. of Amends
     C                   Z-ADD     WUNODL        AHNODL                         No. of Deletes
      *
      * Set PGM.*Record Data Changed flag
     C     QSDFC1        IFNE      YDRDCS
     C                   MOVE      'Y'           YDRDC
     C                   END
      * If changed update record otherwise release record
     C     YDRDC         IFEQ      'Y'
     C**********         UPDATE    @AHREAU                              91      *           MD061007
     C                   CALL      'SD000119'                                               MD061007
     C                   PARM      '*UPD'        ZMODE                                      MD061007
     C                   PARM                    AHFLNM                                     MD061007
     C                   PARM                    AHNORC                                     MD061007
     C                   PARM                    AHNOIN                                     MD061007
     C                   PARM                    AHNOAM                                     MD061007
     C                   PARM                    AHNODL                                     MD061007
     C                   PARM      *BLANKS       ZRETRN                                     MD061007
                                                                                            MD061007
     C                   SETOFF                                       91                    MD061007
     C     ZRETRN        IFNE      *BLANKS                                                  MD061007
     C                   SETON                                        91                    MD061007
     C                   ENDIF                                                              MD061007
                                                                                            MD061007
     C                   ELSE
      * Release record lock
     C**********         UNLOCK    SDFCTLL0                             91      *           MD061007
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SFEXIT        ENDSR
      /EJECT                                                                                  CLE134
     C     UPDFEE        BEGSR
      *================================================================                       CLE134
      * UPDFEE: Update Fee                                                                    CLE134
      *================================================================                       CLE134
      *                                                                                       CLE134
      ** If the value of Suspend Fee Allowed has changed,                                     CLE134
      ** then update the live fees accordingly.                                               CLE134
      *                                                                                       CLE134
     C     AUFSFA        IFNE      O#FSFA
     C                   MOVE      AUFECD        W#FECD            2 0
     C     W#FECD        SETLL     LEFEEDLF
     C     W#FECD        READE     LEFEEDLF                               92
      *                                                                                       CLE134
     C     *IN92         DOWEQ     *OFF
     C     FEFSFA        IFNE      AUFSFA
     C                   MOVE      AUFSFA        FEFSFA
     C                   UPDATE    LEFEED
     C                   ENDIF
      *                                                                                       CLE134
     C     W#FECD        READE     LEFEEDLF                               92
     C                   ENDDO
      *                                                                                       CLE134
     C                   ENDIF
      *                                                                                       CLE134
     C                   ENDSR
      *****************************************************************                     AR826996
      *                                                                                     AR826996
      *  SRVBRC - Validate Base Rate + Currency                                             AR826996
      *                                                                                     AR826996
      *****************************************************************                     AR826996
     C     SRVBRC        BEGSR
      *                                                                                     AR826996
     C     KCYBR         KLIST
     C                   KFLD                    #2CBSR
     C                   KFLD                    FEFCCY
      *                                                                                     AR826996
     C                   MOVE      *OFF          *IN62
     C                   MOVE      *OFF          *IN63
     C                   MOVE      *OFF          *IN64
     C                   MOVE      *BLANKS       @CCY              3
     C                   MOVE      #1FECD        WFECD
      *                                                                                     AR826996
     C     WFECD         SETLL     LEFEEDLW
     C     WFECD         READE     LEFEEDLW                               62
     C     *IN62         DOWEQ     *OFF
     C                   MOVE      *ON           *IN63
     C     FEFCCY        IFNE      @CCY
      *                                                                                     AR826996
      ** Search Base Rate Code + Currency in SDBSRTPD                                       AR826996
      *                                                                                     AR826996
     C     KCYBR         CHAIN     SDBSRTL2                           64
      *                                                                                     AR826996
     C     *IN64         IFEQ      *ON
     C                   LEAVE
     C                   ENDIF
      *                                                                                     AR826996
     C                   MOVEL     FEFCCY        @CCY
      *                                                                                     AR826996
     C                   ENDIF
     C     WFECD         READE     LEFEEDLW                               62
     C                   ENDDO
      *                                                                                     AR826996
      ** If Fee Code is not found in LEFEED, just make sure that                            AR826996
      ** Base Rate is exists in SDBSRTPD                                                    AR826996
      *                                                                                     AR826996
     C     *IN63         IFEQ      *OFF
     C     #2CBSR        CHAIN     SDBSRTL2                           64
      *                                                                                     AR826996
      ** If Base Rate still not found, prompt error message without CCY                     AR826996
      *                                                                                     AR826996
     C     *IN64         IFEQ      *ON
     C                   MOVE      *BLANK        FEFCCY
     C                   ENDIF
     C                   ENDIF
      *                                                                                     AR826996
     C                   ENDSR
      *****************************************************************                     AR826996
      /EJECT
     CSR   UASUBR        BEGSR
      *================================================================
      * Chek for blanks in the key field
      *================================================================
     C                   MOVEL     #1FECD        WUDSTT                         data structure
      * CASE: WRK.Position One is Blank
     C     WUPOS1        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1FECD        ZA0005                         Fee Code
      * Send message 'No blanks in fee code'
     C                   MOVEL     'USR1414'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9833      *
      *
     C                   ELSE
      * CASE: WRK.Position Two is Blank
     C     WUPOS2        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1FECD        ZA0006                         Fee Code
      * Send message 'No blanks in fee code'
     C                   MOVEL     'USR1414'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9833      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      *================================================================
     CSR   UAEXIT        ENDSR
      /EJECT
     CSR   Y0SET         BEGSR
      *================================================================
      * Set cursor by *SET CURSOR data
      *================================================================
      *================================================================
     CSR   Y0EXIT        ENDSR
      /EJECT
     CSR   Y8TST         BEGSR
      *================================================================
      * Test cursor
      *================================================================
     C                   Z-ADD     @#RWCL        ZINPOS            5 0
     C     ZINPOS        DIV       256           W0CRW
     C                   MVR                     W0CCL
      *================================================================
     CSR   Y8EXIT        ENDSR
      /EJECT
     CSR   Y9CLR         BEGSR
      *================================================================
      * Clear *SET CURSOR data
      *================================================================
      *================================================================
     CSR   Y9EXIT        ENDSR
      /EJECT
     CSR   ZASNMS        BEGSR
      *================================================================
      * Send message to program's message queue
      *================================================================
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   END
      * If no message file specified, use default
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   END
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C                   PARM                    ZAMSTP            7            Message type
      * Clear all fields for default mechanism next time
     C                   MOVEL     *BLANK        ZAPGMQ
     C                   MOVEL     *BLANK        ZAPGRL
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP
      *================================================================
     CSR   ZAEXIT        ENDSR
      /EJECT
     CSR   ZHHPKY        BEGSR
      *================================================================
      * Display HELP text
      *================================================================
      * Signal help request
     C                   MOVEL     'Y'           W0HLP             1
      *
      * Extract cursor row and column
     C     @#RWCL        DIV       256           ZHCSRW            5 0          Row
     C                   MVR                     ZHCSCL            5 0          Column
      *
      * Save cursor position for redisplay
     C                   Z-ADD     ZHCSRW        ZZCSRW            3 0          Row
     C                   Z-ADD     ZHCSCL        ZZCSCL            3 0          Column
      *
      *
     C                   CALL      'YDDSHPR'
     C                   PARM      ##PGM         W0HPMB           10            Help text sourc
     C                   PARM      *BLANK        YYHPFL           10            Help text file
     C                   PARM      *BLANK        YYHPLB           10            Help text libra
     C                   PARM                    W0RTN             7
     C                   PARM      '*START'      YYHLVN           10            Help label
     C                   PARM      '*NORMAL'     YYUSOP           10            Options
     C                   PARM      ZHCSRW        YYRW              5 0          Row
     C                   PARM      ZHCSCL        YYCL              5 0          Column
     C                   PARM      *ZERO         YYLGCT            5 0          # of grps
     C                   PARM      *BLANK        YYLGVN           10            Label grps
      *
      * Clear set cursor DDS indicator
     C  N94              MOVEL     'OFF'         WCSRLC
     C  N94              SETON                                        94        *
      *================================================================
     CSR   ZHEXIT        ENDSR
      /EJECT
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Exit program: Normal
      *================================================================
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct
      *================================================================
      * ROLLBACK any uncommitted DBF changes
     C                   ROLBK                                          90
      *
      * Terminate program
     C                   SETON                                        LR
      *
      * Exit program
     C                   RETURN
      *
      *================================================================
     CSR   ZYEXIT        ENDSR
      /EJECT
     CSR   ZZINIT        BEGSR
      *================================================================
      * Initialisation
      *================================================================
     C     W0ICL         IFEQ      *BLANK
     C                   MOVEL     'Y'           W0ICL             1            *Initial call
     C                   ELSE
     C                   MOVEL     'N'           W0ICL
     C                   END
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
     C                   MOVEL     *BLANK        W0RSL             1
     C                   MOVEL     *BLANK        W0RSF             1
     C                   MOVEL     *ZEROS        W0RTW             9 0
     C                   MOVEL     '400'         W0ENV             3
      * Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
      * Set century digit (If YY prior to 1940 treat as 20YY)
     C     ##JYY         IFLT      40
     C                   Z-ADD     1             ##JCC
     C                   ELSE
     C                   Z-ADD     0             ##JCC
     C                   END
     C                   TIME                    ##JTM
      * Update screen time
     C                   TIME                    ##TME             6 0
      * Define work field Deletion Allowed
     C                   MOVEL     *BLANK        WUDELA            1
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUSUC             1
      * Obtain default message file
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF           10
     C                   IN        ZADFMF
      * Define work field Test ? in Key Field
     C                   MOVEL     *BLANK        WUTQKF            1
      * Define work field If value in key field
     C                   MOVEL     *BLANK        WUIVKF            1
      * Define work field data structure local Inst
     C                   MOVEL     *BLANK        WUDSTT            2
      * Define work field Position One
     C                   MOVEL     *BLANK        WUPOS1            1
      * Define work field Position Two
     C                   MOVEL     *BLANK        WUPOS2            1
      * Define work field ZALIGN Screen Fun Field
     C                   MOVEL     *BLANK        WUZASF           16
      * Define work field ZALIGN File Field
     C                   MOVEL     *BLANK        WUZAFF           16
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
      * Define work field No. of Records
     C                   Z-ADD     *ZERO         WUNORC            5 0
      * Define work field No. of Amends
     C                   Z-ADD     *ZERO         WUNOAM            5 0
      * Define work field No. of Deletes
     C                   Z-ADD     *ZERO         WUNODL            5 0
      * Define work field No. of Inserts
     C                   Z-ADD     *ZERO         WUNOIN            5 0
      * Define work field Deleted Data Record Pt1
     C                   MOVEL     *BLANK        WUDR01          250
      * Define work field Deleted Data Record Pt2
     C                   MOVEL     *BLANK        WUDR02          250
      * Define work field Deleted Data Record Pt3
     C                   MOVEL     *BLANK        WUDR03          250
      * Define work field Deleted Data Record Pt4
     C                   MOVEL     *BLANK        WUDR04          250
      * Define work field Deleted Data Record Pt5
     C                   MOVEL     *BLANK        WUDR05          250
      * Define work field Deleted Data Record Pt6
     C                   MOVEL     *BLANK        WUDR06          250
      * Define work field Deleted Data Record Pt7
     C                   MOVEL     *BLANK        WUDR07          250
      * Define work field Deleted Data Record Pt8
     C                   MOVEL     *BLANK        WUDR08          250
      * Define work field Deleted Data Record Pt9
     C                   MOVEL     *BLANK        WUDR09          250
      * Define work field Deleted Data Record Pt10
     C                   MOVEL     *BLANK        WUDR00          250
      * Define work field Deleted Data Record Pt11
     C                   MOVEL     *BLANK        WUDR11          250
      * Define work field Deleted Data Record Pt12
     C                   MOVEL     *BLANK        WUDR12          250
      * Define work field Type of Last Change
     C                   MOVEL     *BLANK        WUTYLC            1
      * Define work field Midas Run Date
     C                   MOVEL     *BLANK        WUMRDT            7
      * Define work field Date format flag
     C                   MOVEL     *BLANK        WUDFF             1
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUMBIN            1
      * Flag no *SET CURSOR in the program
     C                   MOVE      'N'           YSETCS            1
     C                   MOVE      *BLANK        WCSRLC            3
     C/COPY WNCPYSRC,SD0320MC17
      * Open files
      * Begin commit control
     C                   CALL      'Y2BGCMC'
     C                   PARM                    W0RTN             7
     C     W0RTN         IFNE      *BLANK
     C     W0RTN         ANDNE     'CPF8351'
     C                   EXSR      ZYEXPG
     C                   END
      * Define *Synon program work fields
     C                   MOVEL     *BLANKS       W0CFL            10            *Cursor field
     C                   Z-ADD     *ZEROS        W0CRW             5 0          *Cursor row
     C                   Z-ADD     *ZEROS        W0CCL             5 0          *Cursor column
      * Move main file information to JOB context
     C                   MOVE      @1FFL         ZZFFL            10            Main file name
     C                   MOVE      @1FLB         ZZFLB            10            Main file lib
     C                   MOVE      @1FMB         ZZFMB            10            Main file mbr
     C                   MOVE      ZZFFL         @1FFL            10
     C                   MOVE      ZZFLB         @1FLB            10
     C                   MOVE      ZZFMB         @1FMB            10
     C                   CALL      'Y2QLVNR'
     C                   PARM                    ZZFFL            10
     C                   PARM                    ZZFLB            10
     C                   PARM                    ZZFQL            21            LIBRARY/FILE
     C                   OPEN      SD0320M#
     C                   OPEN      SDFEEL1
     C                   OPEN      SDFEEL0
     C**********         OPEN      SDFCTLL0                                                 MD061007
     C                   MOVEL     'N'           W0PMT             1
      *
     C                   Z-ADD     15            ##SFPG            3 0          SFLPAG
     C                   Z-ADD     1             ##SFRC
      * Maximum record number
     C                   Z-ADD     *ZERO         ##RRMX
      * Scan limit
     C                   Z-ADD     500           W0SLM             5 0
      * Subfile pages
     C                   Z-ADD     1             W0SPG             3 0
      * Processed Subfile record
     C                   Z-ADD     0             W0RR0             4 0
      *................................................................
      * Set to *CHANGE mode
     C                   MOVEL     'CHG'         W0PMD             3
     C                   MOVEL     *BLANK        W0GRP             1
      * USER: Initialize program
      * SD0320M Precompiler - Fee Codes  *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT            7            RUN DATE
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB                         RUNDAY NO.
     C                   MOVE      SUC           WUSUC                          SET UP COMPLT
     C                   MOVE      DFF           WUDFF                          DTE FMT FLAG
     C                   MOVE      MBIN          WUMBIN                         MULTI BR. IND
      * Copyright Statement 1988 - Standard Functions  * copyright
      * Start of Fix S01117
      * define data strucrure - Fee Codes  *
      * End of Fix S01117
      *                                                                                       CLE134
      ** Get Customer Lending ICD                                                             CLE134
      *                                                                                       CLE134
     C                   CALL      'AOCLNDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST'      POPTN             7
     C     SDCLND        PARM      SDCLND        DSSDY
      *                                                                                       CLE134
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SD0320M '    DBPGM
     C                   MOVEL     'SDCLNDPD'    DBFILE
     C                   Z-ADD     6             DBASE
     C                   MOVEL     POPTN         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CAS001
      ** Determine if CAS001 is installed                                                     CAS001
      *                                                                                       CAS001
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY '    POPTN             7
     C                   PARM      'CAS001'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CAS001
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     'SD0320M '    DBPGM
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     'CAS001'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CAS001
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CAS001            1
     C                   MOVE      *ON           *IN55
     C                   ELSE
     C                   MOVE      'N'           CAS001
     C                   MOVE      *OFF          *IN55
     C                   ENDIF
     C/COPY WNCPYSRC,SDH00139
      *                                                                                       CAS001
      ** Determine if CAS009 is installed                                                     CAS009
      *                                                                                       CAS009
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY '    POPTN
     C                   PARM      'CAS009'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CAS009
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SD0320M '    DBPGM
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     2             DBASE
     C                   MOVEL     'CAS009'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CAS009
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CAS009            1
      *                                                                                       231568
     C     KSARP         KLIST
     C                   KFLD                    KSARN             6
     C                   KFLD                    KPNAM            10
      *                                                                                       231568
     C                   MOVE      'CAS009'      KSARN
     C     'LEC'         CAT       '000016'      KPNAM
      *                                                                                       231568
     C*****KSARP         CHAIN     SCSARPL1                           78                    MD056555
     C/EXEC SQL                                                                             MD056555
     C+ SELECT *                                                                            MD056555
     C+ into :SCSARP                                                                        MD056555
     C+ from SCSRPJW0                                                                       MD056555
     C+ where AKSARN = :KSARN and AKPNAM = :KPNAM                                           MD056555
     C/END-EXEC                                                                             MD056555
      *                                                                                       231568
     C******IN78         IFEQ      *ON                                                      MD056555
     C                   IF        SQLCODE = 100                                            MD056555
     C     *LOCK         IN        LDA
     C                   MOVEL     'SD0320M '    DBPGM
     C                   MOVEL     'SCSARPPD'    DBFILE
     C                   Z-ADD     3             DBASE
     C                   MOVEL     'CAS009'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
      *                                                                                       231568
      ** Check if Initialisation Program for CAS009 Fee Codes has run                         231568
      *                                                                                       231568
     C     AKPRVC        IFEQ      'Y'
      *                                                                                       231568
      ** Set CAS009 Initialised Flag to Yes                                                   231568
      *                                                                                       231568
     C                   MOVE      'Y'           WCAS9I            1
     C                   ENDIF
     C                   ENDIF
      *                                                                                       231568
     C                   ELSE
     C                   MOVE      'N'           CAS009
     C                   ENDIF
      *                                                                                       CAS009
      ** Determine if CLE134 is installed                                                     CLE134
      *                                                                                       CLE134
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY '    POPTN
     C                   PARM      'CLE134'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CLE134
     C                   SELECT
     C     PRTCD         WHENEQ    *BLANKS
     C                   MOVE      'Y'           CLE134            1
     C**********           MOVE *ON       *IN57                                     CLE134 MD021974A
     C                   MOVE      *ON           *IN58
      *                                                                                       CLE134
     C     PRTCD         WHENEQ    '*NRF'
     C                   MOVE      'N'           CLE134
     C**********           MOVE *OFF      *IN57                                     CLE134 MD021974A
     C                   MOVE      *OFF          *IN58
      *                                                                                       CLE134
     C                   OTHER
     C     *LOCK         IN        LDA
     C                   MOVEL     'SD0320M '    DBPGM
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     4             DBASE
     C                   MOVEL     'CLE134'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDSL
      *                                                                                       CLE134
      ** Determine if CLE042 is installed                                                     CLE134
      *                                                                                       CLE134
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY '    POPTN
     C                   PARM      'CLE042'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CLE134
     C                   SELECT
     C     PRTCD         WHENEQ    *BLANKS
     C                   MOVE      'Y'           CLE042            1
     C                   MOVE      *ON           *IN56
      *                                                                                       CLE134
     C     PRTCD         WHENEQ    '*NRF'
     C                   MOVE      'N'           CLE042
     C                   MOVE      *OFF          *IN56
      *                                                                                       CLE134
     C                   OTHER
     C     *LOCK         IN        LDA
     C                   MOVEL     'SD0320M '    DBPGM
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     7             DBASE
     C                   MOVEL     'CLE042'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDSL
      *                                                                                       CLE134
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CRE073'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                    AR1022007
     C     PRTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CRE073            1
     C                   MOVE      *ON           *IN76
     C                   ELSE
     C                   MOVE      'N'           CRE073
     C                   MOVE      *OFF          *IN76
     C                   ENDIF
      *                                                                                    AR1022007
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CLE036'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                    AR1080662
     C                   SELECT
     C     PRTCD         WHENEQ    *BLANKS
     C                   MOVE      'Y'           CLE036            1
     C     PRTCD         WHENEQ    '*NRF'
     C                   MOVE      'N'           CLE036
     C                   OTHER
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CLE036'      DBKEY
     C                   Z-ADD     6             DBASE
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   EXSR      *PSSR
     C                   ENDSL
      *                                                                                    AR1080662
     C     CLE036        IFEQ      'Y'
     C     CLE134        ANDEQ     'Y'
     C                   MOVE      *ON           *IN71
     C                   ELSE
     C                   MOVE      *OFF          *IN71
     C                   MOVE      *ON           *IN72
     C                   ENDIF
      *                                                                                       CER050
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CER050'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CER050
     C     PRTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CER050            1
     C                   MOVE      *ON           *IN75
     C                   ELSE
     C                   MOVE      'N'           CER050
     C                   MOVE      *OFF          *IN75
     C                   ENDIF
      *                                                                                       CER050
     C     CER050        IFEQ      'Y'
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *                                                                                       CER050
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA                                          ***************
     C                   Z-ADD     8             DBASE                          ** DB ERR 08 **
     C                   MOVE      'SDBANKPD'    DBFILE                         ***************
     C                   MOVEL     @OPTN         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CER050
      * Access  program to get the number of decimal places using                             CER050
      * the currency code                                                                     CER050
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      BJCYCD        ##KEY1           10
     C     SDCURR        PARM      SDCURR        DSSDY
      *                                                                                       CER050
      * Database error if the currency code is not found                                      CER050
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA                                          ***************
     C                   Z-ADD     9             DBASE                          ** DB ERR 09 **
     C                   MOVE      'SDCURRPD'    DBFILE                         ***************
     C                   MOVEL     BJCYCD        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CER050
     C     13            SUB       A6NBDP        @@NDEC            2 0
      *                                                                                       CER050
     C                   ENDIF
      *                                                                                       CER050
      * Initialise subfile control
     C                   EXSR      MEIZ#2
     C/COPY WNCPYSRC,SD0320MC16
      *================================================================
     CSR   ZZEXIT        ENDSR
     C/COPY WNCPYSRC,SDH00141
      /EJECT
     CSR   *PSSR         BEGSR
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
      * Core function specific processing.
      *
     C/COPY WNCPYSRC,SD0320MPSC
      *
      * Start of PSSR user point.
      *
     C/COPY WNCPYSRC,SD0320MPS1
      *
      * Standard Midas PSSR processing.
      *
     C*COPY*SDCPYSRC,SDPSSRINT                                                              MD056555
     C/COPY SDCPYSRC,SDPSSRINTI                                                             MD056555
      *
      * End of PSSR user point.
      *
     C/COPY WNCPYSRC,SD0320MPS2
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
      *****************************************************************                       CLE164
      *                                                               *                       CLE164
      *  SLPGID - Select Priority Group ID                                                    CLE164
      *                                                               *                       CLE164
      *================================================================                       CLE164
     C     SLPGID        BEGSR
      *                                                                                       CLE164
     C                   MOVEL     #2PGID        PGIDSL            1
     C     PGIDSL        IFEQ      '?'
     C                   CALL      'SD00321S'                           90
     C                   PARM                    W0RTN             7
     C     #2PGID        PARM      #2PGID        WVAR01            3
     C     *IN90         IFEQ      '1'
      *                                                                                       CLE164
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      * Defer confirm                                                                         CLE164
     C                   MOVEL     'Y'           W0DEF             1
     C                   END
     C                   ENDSR
**CTDATA CPY@
(c) Finastra International Limited 2001
