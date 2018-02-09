     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD FX Netting Multiple Settlements Display')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD0910D - FX Netting Multiple Settlements Display            *
      *                                                               *
      *  Function:  This program allows the user to enquire from a    *
      *             list of ext settle maint.                         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CDL025  *CREATE    Date 07Nov04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL025 - FX Netting Payment Generation                       *
      *                                                               *
      *****************************************************************
      ** Screen Formats
     FSD0910D#  CF   E             WORKSTN USROPN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
 
     FSDFNMSL2  IF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------------------------------
 
      **------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------------------------------
 
      **------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------------
 
      **---------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------------
 
      **---------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      /EJECT
      ** +--------------------------------------+
      ** ¦ ARRAYS AND DATA STRUCTURES           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** DATA AREA GIVING INSTALLATION CONTROL DETAILS
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
 
      /EJECT
 
      /EJECT
      * Data structures:
      *
      * Job date/time
     D JBDTTM          DS
     D  ##JDT                  1      7S 0
     D  ##JCC                  1      1S 0
     D  ##JYY                  2      3S 0
     D  ##JMM                  4      5S 0
     D  ##JDD                  6      7S 0
     D  ##JTM                  8     13S 0
     D  ##JHH                  8      9S 0
     D  ##JNN                 10     11S 0
     D  ##JSS                 12     13S 0
 
      * ABO DEFINE LARGE STRING FOR CL CMD
     D YARTCM          DS           512
     D  Dummy1                        1
 
      ** Display file information data structure
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
 
      * File information data structure
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
 
      * Outward parameters
      * RCD : Midas SD FX Multiple settlements File
     D PARC            DS          1342
     D  PACYCD                 1      3A
     D  PACUST                 4      9A
     D  PATRTY                50     51A
     D  PASEQN              1339   1342A
      * Outward parameters
     D PBRC            DS          1344
     D  PBCYCD                 1      3A
     D  PBCUST                 4      9A
     D  PBTRTY                50     51A
     D  PBSEQN              1339   1342A
 
      **  External data structures for Switchable Features Details
     D SCSARD        E DS                  ExtName(SCSARDPD)
 
      **  Second data structure for Access Programs, long DS
     D DSSDY         E DS                  ExtName(DSSDY)
 
     D*RUNDAT          DS
     D* ##JDT                  1      7S 0
     D* MRDT                   1      7
     D* RDNB                   8     10P 0
     D* SUC                   11     11
     D* DFF                   12     12
     D* MBIN                  13     13
      /EJECT
      * Parameter declarations
     D P1PARM          DS
     D  P1DFMD                 1      1A
 
      * Message data for 'value for field not valid'
      * *SFLSEL
     D ZAMSDA          DS           132
     D  ZA0001                 1      1
 
     D ##RR            S              5S 0
     D ##RRMX          S              5S 0
     D ##RROK          S              5S 0
     D ##RRRD          S              5S 0
     D ##SFPG          S              3S 0 Inz(14)
     D ##SLIN          S              3S 0
     D ##SPG           S              3S 0
 
     D CAIn81          S               N   Inz(*Off)
     D CEU003          S               N   Inz(*Off)
     D HELP25          S               N   Inz(*Off)
 
     D W0CFL           S             10A   Inz(*Blanks)
     D W0CRW           S              5S 0 Inz(*Zeros)
     D W0CCL           S              5S 0 Inz(*Zeros)
     D W0DCF           S              1A   Inz(*Blanks)
     D W0ENV           S              3A   Inz('400')
     D W0GRP           S              1A   Inz(*Blanks)
     D W0HLP           S              1A   Inz(*Blanks)
     D W0NSRQ          S              1A   Inz(*Blanks)
     D W0RR0           S              5S 0 Inz(*Zeros)
     D W0RSL           S              1A   Inz(*Blanks)
     D W0SLM           S              5S 0 Inz(99999)
     D W0SPG           S              5S 0 Inz(1)
 
     D WCSRLC          S              3A   Inz(*Blanks)
 
     D WUMRDT          S              7A   Inz(*Blanks)
     D WUDUFF          S              1A   Inz(*Blanks)
     D WUMDEL          S              1A   Inz(*Blanks)
     D WUMSGF          S             10A   Inz(*Blanks)
     D WUMSID          S              7A   Inz(*Blanks)
     D WUTQKF          S              1A   Inz(*Blanks)
     D WUMTXT          S             80A   Inz(*Blanks)
 
     D WZRSTY          S                   Like(#2RSTY)
     D WZRONO          S                   Like(#2RONO)
     D WZROBN          S                   Like(#2ROBN)
     D WZROCS          S                   Like(#2ROCS)
     D WZRIBN          S                   Like(#2RIBN)
     D WZRIBL          S                   Like(#2RIBL)
     D WZPSTY          S                   Like(#2PSTY)
     D WZPONO          S                   Like(#2PONO)
     D WZPOBN          S                   Like(#2POBN)
     D WZPOCS          S                   Like(#2POCS)
     D WZPIBN          S                   Like(#2PIBN)
     D WZPIBA          S                   Like(#2PIBA)
     D WZRCNO          S                   Like(#2RCNO)
     D WZRCAL          S                   Like(#2RCAL)
     D WZRCNB          S                   Like(#2RCNB)
     D WZACBN          S                   Like(#2ACBN)
     D WZACBL          S                   Like(#2ACBL)
     D WZBYNB          S                   Like(#2BYNB)
     D WZBACL          S                   Like(#2BACL)
     D WZDPY1          S                   Like(#2DPY1)
     D WZDPY2          S                   Like(#2DPY2)
     D WZDPY3          S                   Like(#2DPY3)
     D WZDPY4          S                   Like(#2DPY4)
     D WZDECG          S                   Like(#2DECG)
     D WZBBI1          S                   Like(#2BBI1)
     D WZBBI2          S                   Like(#2BBI2)
     D WZBBI3          S                   Like(#2BBI3)
     D WZBBI4          S                   Like(#2BBI4)
     D WZBBI5          S                   Like(#2BBI5)
     D WZBBI6          S                   Like(#2BBI6)
     D WZLCD           S                   Like(#2LCD)
     D WZTYLC          S                   Like(#2TYLC)
     D WZCUST          S                   Like(#2CUST)
     D WZCYCD          S                   Like(#2CYCD)
     D WZSEQN          S                   Like(#2SEQN)
     D WZTRTY          S                   Like(#2TRTY)
 
     D YSETCS          S              1A   Inz('Y')
 
     D ZAMSGF          S             10A   Inz(*Blanks)
     D ZAMSID          S             10A   Inz(*Blanks)
     D ZHCSCL          S              5S 0 Inz(*Zeros)
     D ZHCSRW          S              5S 0 Inz(*Zeros)
     D ZINPOS          S              5S 0 Inz(*Zeros)
     D ZZCSCL          S              5S 0 Inz(*Zeros)
     D ZZCSRW          S              5S 0 Inz(*Zeros)
     D ZZFMB           S             10A   Inz(*Blanks)
 
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *Entry        PList
     C                   Parm                    P0RTN             7
     C     P1DFMD        Parm                    WP0001            1
      *****************************************************************
      * Initialize
     C                   Exsr      ZZINIT
      *
     C                   Do        *HIVAL
      * Initialise & load subfile page
     C                   Exsr      BAIZSF
     C                   Movel     'N'           W0RSF             1
      * Display screen until reload requested
     C                   DoW       W0RSF = 'N'
      * Display screen
     C                   Exsr      CAEXFM
      * Process response
      * Cancel & exit program
     C   03              CAS                     ZXEXPG
      * HOME: Request subfile reload
     C   05              CAS                     FBRQRL
      * Display next SFL page
     C   27              CAS                     BBLDSF
      * Process screen input
     C                   CAS                     DAPR##
     C                   EndCs
      *
     C                   EndDo
     C                   EndDo
      *****************************************************************
      /EJECT
     CSR   BAIZSF        BegSr
      *================================================================
      * Initialise and load subfile page
      *================================================================
      * Clear subfile
     C                   Eval      *In80 = *On
     C                   Write     #SFLCTL
     C                   Eval      *In80 = *Off
      * Reset no of records in subfile
     C                   Eval      ##RRMX = *zeros
     C                   Eval      *In81 = *Off
      * Position DBF file
     C     KPOS          KList
     C                   KFld                    LCUST
     C                   KFld                    LCYCD
     C                   KFld                    LSEQN
      * Setup key
     C                   Eval      LCUST = #2CUST
     C                   Eval      LCYCD = #2CYCD
     C                   Move      #2SEQN        LSEQN
     C                   Eval      LTRTY = #2TRTY
 
     C     KPOS          Setll     SDFNMSL2
     C                   Read      SDFNMSL2                             8782    *82=EOF
      * Save previous selector values
     C                   Eval      WZRSTY = #2RSTY
     C                   Eval      WZRONO = #2RONO
     C                   Eval      WZROBN = #2ROBN
     C                   Eval      WZROCS = #2ROCS
     C                   Eval      WZRIBN = #2RIBN
     C                   Eval      WZRIBL = #2RIBL
     C                   Eval      WZPSTY = #2PSTY
     C                   Eval      WZPONO = #2PONO
     C                   Eval      WZPOBN = #2POBN
     C                   Eval      WZPOCS = #2POCS
     C                   Eval      WZPIBN = #2PIBN
     C                   Eval      WZPIBA = #2PIBA
     C                   Eval      WZRCNO = #2RCNO
     C                   Eval      WZRCAL = #2RCAL
     C                   Eval      WZRCNB = #2RCNB
     C                   Eval      WZACBN = #2ACBN
     C                   Eval      WZACBL = #2ACBL
     C                   Eval      WZBYNB = #2BYNB
     C                   Eval      WZBACL = #2BACL
     C                   Eval      WZDPY1 = #2DPY1
     C                   Eval      WZDPY2 = #2DPY2
     C                   Eval      WZDPY3 = #2DPY3
     C                   Eval      WZDPY4 = #2DPY4
     C                   Eval      WZDECG = #2DECG
     C                   Eval      WZBBI1 = #2BBI1
     C                   Eval      WZBBI2 = #2BBI2
     C                   Eval      WZBBI3 = #2BBI3
     C                   Eval      WZBBI4 = #2BBI4
     C                   Eval      WZBBI5 = #2BBI5
     C                   Eval      WZBBI6 = #2BBI6
     C                   Eval      WZLCD  = #2LCD
     C                   Eval      WZTYLC = #2TYLC
     C                   Eval      WZCUST = #2CUST
     C                   Eval      WZCYCD = #2CYCD
     C                   Eval      WZSEQN = #2SEQN
     C                   Eval      WZTRTY = #2TRTY
      * Load subfile page
     C                   Eval      ##RROK = *Zeros
     C                   Exsr      BBLDSF
      *================================================================
     CSR   BAEXIT        EndSr
      /EJECT
     CSR   BBLDSF        BegSr
      *================================================================
      * Load subfile page
      *================================================================
      * Re-establish fields in read-ahead record
     C                   If        *In27 = *On and *In82 = *Off
     C                   ReadP     SDFNMSL2                               90
     C                   Read      SDFNMSL2                               90
     C                   EndIf
      *
      * Setof record error indicators
     C                   Eval      *In34 = *Off
      * Start at previous highest record in SFL
     C                   Eval      ##RR = ##RRMX
      * Reset count of DBF records read
     C                   Eval      ##RRRD = 0
      * Set required pages based on *Set Cursor or *Subfile Pages
     C     W0RR0         IFGT      0
     C     W0RR0         DIV       ##SFPG        ##SPG
     C                   MVR                     ##SLIN
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
      * Load next SFL page until SFL page full, or
      * Scan limit reached
     C                   DoW       *In82 = *Off and
     C                             ##RROK < ##SFLN and ##RRRD < W0SLM
      * Check selection fields - if fail, read next record
     C                   If        #2RSTY <> *Blanks
     C     LRSTY         CabNE     #2RSTY        BB020
     C                   End
 
     C                   If        #2RONO <> *Blanks
      * Scan for search string
     C                   Call      'QCLSCAN'
     C                   Parm                    LRONO
     C                   Parm      12            WQA3N
     C                   Parm      1             WQB3N
     C                   Parm                    #2RONO
     C                   Parm      12            WQC3N
     C                   Parm      '1'           WQD1
     C                   Parm      '1'           WQE1
     C                   Parm      '?'           WQF1
     C                   Parm                    WQG3N
 
     C     WQG3N         CabLT     1             BB020
     C                   End
 
     C                   If        #2ROBN <> *Blanks
     C     LROBN         CabNE     #2ROBN        BB020
     C                   End
 
     C                   If        #2ROCS <> *Blanks
     C     LROCS         CabNE     #2ROCS        BB020
     C                   End
 
     C                   If        #2RIBN <> *Blanks
      * Scan for search string
     C                   Call      'QCLSCAN'
     C                   Parm                    LRIBN
     C                   Parm      8             WQA3N
     C                   Parm      1             WQB3N
     C                   Parm                    #2RIBN
     C                   Parm      8             WQC3N
     C                   Parm      '1'           WQD1
     C                   Parm      '1'           WQE1
     C                   Parm      '?'           WQF1
     C                   Parm                    WQG3N
 
     C     WQG3N         CabLT     1             BB020
     C                   End
 
     C                   If        #2RIBL <> *Blanks
      * Scan for search string
     C                   Call      'QCLSCAN'
     C                   Parm                    LRIBL
     C                   Parm      35            WQA3N
     C                   Parm      1             WQB3N
     C                   Parm                    #2RIBL
     C                   Parm      35            WQC3N
     C                   Parm      '1'           WQD1
     C                   Parm      '1'           WQE1
     C                   Parm      '?'           WQF1
     C                   Parm                    WQG3N
 
     C     WQG3N         CabLT     1             BB020
     C                   End
 
     C                   If        #2PSTY <> *Blanks
     C     LPSTY         CabNE     #2PSTY        BB020
     C                   End
 
     C                   If        #2PONO <> *Blanks
     C     LPONO         CabNE     #2PONO        BB020
     C                   End
 
     C                   If        #2POBN <> *Blanks
     C     LPOBN         CabNE     #2POBN        BB020
     C                   End
 
     C                   If        #2POCS <> *Blanks
     C     LPOCS         CabNE     #2POCS        BB020
     C                   End
 
     C                   If        #2PIBN <> *Blanks
     C     LPIBN         CabNE     #2PIBN        BB020
     C                   End
 
     C                   If        #2PIBA <> *Blanks
     C     LPIBA         CabNE     #2PIBA        BB020
     C                   End
 
     C                   If        #2RCNO <> *Blanks
     C     LRCNO         CabNE     #2RCNO        BB020
     C                   End
 
     C                   If        #2RCAL <> *Blanks
     C     LRCAL         CabNE     #2RCAL        BB020
     C                   End
 
     C                   If        #2RCNB <> *Blanks
     C     LRCNB         CabNE     #2RCNB        BB020
     C                   End
 
     C                   If        #2ACBN <> *Blanks
     C     LACBN         CabNE     #2ACBN        BB020
     C                   End
 
     C                   If        #2ACBL <> *Blanks
     C     LACBL         CabNE     #2ACBL        BB020                          A/c With Bank L
     C                   End
 
     C                   If        #2BYNB <> *Blanks
     C     LBYNB         CabNE     #2BYNB        BB020                          Beneficiary Num
     C                   End
 
     C                   If        #2BACL <> *Blanks
     C     LBACL         CabNE     #2BACL        BB020                          Beneficiary A/c
     C                   End
 
     C                   If        #2DPY1 <> *Blanks
      * Scan for search string
     C                   Call      'QCLSCAN'
     C                   Parm                    LDPY1                          Details of Paym
      * Length
     C                   Parm      35            WQA3N             3 0
      * Start
     C                   Parm      1             WQB3N             3 0
      * Mask
     C                   Parm                    #2DPY1
      * Length
     C                   Parm      35            WQC3N             3 0
      * Translate
     C                   Parm      '1'           WQD1              1
      * Trim
     C                   Parm      '1'           WQE1              1
      * Wild
     C                   Parm      '?'           WQF1              1
      * Result
     C                   Parm                    WQG3N             3 0
 
     C     WQG3N         CabLT     1             BB020
     C                   End
 
     C                   If        #2DPY2 <> *Blanks
     C     LDPY2         CabNE     #2DPY2        BB020                          Details of Paym
     C                   End
 
     C                   If        #2DPY3 <> *Blanks
     C     LDPY3         CabNE     #2DPY3        BB020                          Details of Paym
     C                   End
 
     C                   If        #2DPY4 <> *Blanks
     C     LDPY4         CabNE     #2DPY4        BB020                          Details of Paym
     C                   End
 
     C                   If        #2DECG <> *Blanks
     C     LDECG         CabNE     #2DECG        BB020                          Details of char
     C                   End
 
     C                   If        #2BBI1 <> *Blanks
      * Scan for search string
     C                   Call      'QCLSCAN'
     C                   Parm                    LBBI1                          Bank to Bank In
      * Length
     C                   Parm      35            WQA3N             3 0
      * Start
     C                   Parm      1             WQB3N             3 0
      * Mask
     C                   Parm                    #2BBI1
      * Length
     C                   Parm      35            WQC3N             3 0
      * Translate
     C                   Parm      '1'           WQD1              1
      * Trim
     C                   Parm      '1'           WQE1              1
      * Wild
     C                   Parm      '?'           WQF1              1
      * Result
     C                   Parm                    WQG3N             3 0
 
     C     WQG3N         CabLT     1             BB020
     C                   End
 
     C                   If        #2BBI2 <> *Blanks
     C     LBBI2         CabNE     #2BBI2        BB020                          Bank to Bank In
     C                   End
 
     C                   If        #2BBI3 <> *Blanks
     C     LBBI3         CabNE     #2BBI3        BB020                          Bank to Bank In
     C                   End
 
     C                   If        #2BBI4 <> *Blanks
     C     LBBI4         CabNE     #2BBI4        BB020                          Bank to Bank In
     C                   End
 
     C                   If        #2BBI5 <> *Blanks
     C     LBBI5         CabNE     #2BBI5        BB020                          Bank to Bank In
     C                   End
 
     C                   If        #2BBI6 <> *Blanks
     C     LBBI6         CabNE     #2BBI6        BB020                          Bank to Bank In
     C                   End
 
     C                   If        #2LCD <> *Zeros
     C     LLCD          CabNE     #2LCD         BB020                          Last Change Dat
     C                   End
 
     C                   If        #2TYLC <> *Blanks
     C     LTYLC         CabNE     #2TYLC        BB020                          Type of Last Ch
     C                   End
 
     C                   If        #2CUST = *Blanks
     C                             and #2CYCD <> *Blanks
     C     LCYCD         CabNE     #2CYCD        BB020                          Currency Code
     C                   END
 
     C                   If        (#2CUST = *Blanks or #2CYCD = *Blanks)
     C                             and #2TRTY <> *Blanks
     C     LTRTY         CabNE     #2TRTY        BB020                          Transaction Typ
     C                   End
      * Load SFL fields
     C                   Exsr      MBFL#1
     C                   Eval      W0RSL = 'Y'
      * Output to subfile
     C                   Eval      ##RR = ##RR + 1
     C                   Eval      ##RROK = ##RROK + 1
     C                   If        ##RROK > 0
     C                   Eval      *In81 = *On
     C                   Endif
 
      * If SFLRCD invalid, note that errors present
     C                   If        *In98 = *On and *In99 = *Off
     C                   Eval      *In99 = *On
     C                   EndIf
     C                   Write     #SFLRCD
 
     C     BB020         Tag
      * Increment scan check count
     C                   Eval      ##RRRD = ##RRRD + 1
     C                   Read      SDFNMSL2                               82    *82=EOF
     C                   End                                                    OD 1 - ##SFPG
      *................................................................
     C     BB900         Tag
      *................................................................
      * If no DBF records found, display error message
     C                   If        ##RR = *Zeros and *In82 = *On
      * Send message '*No data to display'
     C                   Movel     'Y2U0008'     ZAMSID
     C                   Movel     'Y2USRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C                   End                                                    FI ##RR = *ZERO
      *
      *................................................................
      * Save highest SFL record load can continue at end point
     C                   If        ##RR > ##RRMX
      * Calculate top line
     C     ##RROK        Div       ##SFPG        ##SPG
     C                   MvR                     ##SLIN
     C                   If        ##SLIN > 0
     C                   Eval      ##SFRC = ##RR - ##SLIN
     C                   Else
     C                   Eval      ##SFRC = ##RR - ##SFPG
     C                   End
     C                   Eval      ##SFRC = ##SFRC + 1
     C                   Eval      ##RRMX = ##RR
     C                   End
      * If scan limit reached, display error message
     C                   If        ##RRRD >= W0SLM
      * Send message '*Scan limit reached'
     C                   Movel     'Y2U0017'     ZAMSID
     C                   Movel     'Y2USRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C                   Else
     C                   Eval      ##RROK = 0
     C                   End
      *================================================================
     CSR   BBEXIT        EndSr
      /EJECT
 
     CSR   CAEXFM        BegSr
      *================================================================
      * Display screen
      *================================================================
     C                   DoU       W0HLP = 'N'
     C                   Eval      W0HLP = 'N'
     C                   Eval      HELP25 = *In25
     C                   Move      *ALL'0'       ##OFF            30
     C                   MoveA     ##OFF         *In(1)
     C                   Eval      *In25 = HELP25
      * Update screen time
     C                   Time                    ##TME
      * PUTOVR unless conditioned fields change
     C                   Eval      *In86 = *On
     C                   If        *In81 <> CAIn81
     C                   Eval      *In86 = *Off
     C                   End
     C                   Eval      CAIn81 = *In81
      * Set cursor by *SET CURSOR data
     C                   If        YSETCS = 'Y'
     C                   Exsr      Y0SET
     C                   End
     C                   Write     #MSGCTL
     C                   Write     #CMDTXT1
     C                   Exfmt     #SFLCTL
      * Maintain subfile position where possible
     C                   If        @#SFRC > 0
     C                   Eval      ##SFRC = @#SFRC
     C                   End
      * Test cursor
     C                   Exsr      Y8TST
      * Clear set cursor DDS indicator
     C                   If        WCSRLC = 'OFF'
     C                   Eval      *In94 = *Off
     C                   End
     C                   Eval      WCSRLC = *Blanks
      * If help requested, display help text
     C                   If        *In25 = *On
     C                   Exsr      ZHHPKY
     C                   End
     C                   End
      * Update job time
     C                   Time                    ##JTM
      * Clear messages from program message queue
     C                   Call      'Y2CLMSC'
     C                   Parm      ##PGM         ZAPGMQ           10
     C                   Parm      '*SAME'       ZAPGRL            5
      * Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1      99    *
     C                   Eval      *In83 = *Off
     C                   Eval      *In92 = *Off
     C                   If        YSETCS = 'Y'
     C                   Exsr      Y9CLR
     C                   End
      *================================================================
     CSR   CAEXIT        EndSr
      /EJECT
     CSR   DAPR##        BegSr
      *================================================================
      * Process screen input
      *================================================================
      *
      * Confirm/update is not deferred
     C                   Eval      W0DCF = 'N'
      * Validate Transaction Type
     C                   Eval      W0RTN = *Blanks
     C                   Eval      W0NSRQ = #2TRTY
      * Name search required?
     C                   If        W0NSRQ = '?'
     C                   Call      'Y2VLLSR'                            90      *
     C                   Parm                    W0RTN             7
     C                   Parm      1110281       Y2LSNO            7 0
     C     #2TRTY        Parm      #2TRTY        W0EXVL           20            Transaction Typ
      * Defer confirm
     C                   Eval      W0DCF = 'Y'
     C                   End
      *
      * If error, exit
     C     *IN99         CabEq     '1'           DAEXIT
      *................................................................
      * Change of position specified
     C     WZCUST        CasNE     #2CUST        FBRQRL
     C     WZCYCD        CasNE     #2CYCD        FBRQRL
     C     WZSEQN        CasNE     #2SEQN        FBRQRL
     C     WZTRTY        CasNE     #2TRTY        FBRQRL
     C                   End
      * USER: Process subfile control (Pre-confirm)
      * If a '?' is placed into the positioner call the select record
      * for the client details.
     C                   Eval      WUTQKF = #2CUST
      * CASE: WRK.Test ? in Key Field is Question Mark
     C                   If        WUTQKF = '?'
     C                   Eval      #2CUST = *Blanks
      * Select Client Details - Client Details  *
     C                   Call      'SD0010S'                            90      Select Client D
     C                   Parm      *BLANK        W0RTN             7
     C     #2CUST        Parm      #2CUST        WQ0001            6            Customer Number
      *
     C                   If        *In90 = *On
      * Call to program ended in error
     C                   MoveL     'Y2U0032'     W0RTN
     C                   MoveL     *BLANKS       W0CLPG           10
     C                   MoveL     'SD0010S'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MoveL     'Y2U0032'     ZAMSID
     C                   MoveL     'Y2USRMSG'    ZAMSGF
     C                   MoveL     W0CLPG        ZAMSDA                         Message data
     C                   Exsr      ZASNMS
     C                   End
      *
      * Error detected?
     C                   If        W0RTN <> *Blanks
     C                   Eval      *In99 = *On
     C                   Eval      *In31 = *On
     C                   End
     C                   End                                                    *FI
      * Reload subfile requested
     C     W0RSF         CabEQ     'Y'           DAEXIT
     C                   If        *In81 = *On
      * Process subfile records
     C                   Exsr      DBPRSF
     C                   End
      * If error, quit processing
     C     *In99         CabEQ     '1'           DAEXIT
      * Defer confirm/update requested
     C     W0DCF         CabEQ     'Y'           DAEXIT
      * USER: Process command keys
      * CASE: PAR.Display file mode is Maintenance mode
     C                   If        P1DFMD = 'M'                                 *IF
      * CASE: CTL.*CMD key is *Go to 'Add' mode
     C                   If        *In09 = *On                                  *IF
      * Edit Extended Settlements - Extended Settlements  *
     C                   Clear                   PARC
     C                   Eval      PACYCD = *Blanks
     C                   Eval      PACUST = *Blanks
     C                   Eval      PASEQN = *Zeros
     C                   Eval      PATRTY = 'NT'
      *
     C                   Call      'SD0911R'                            90      Edit Extended S
     C                   Parm      *BLANK        W0RTN             7
     C                   Parm                    PARC                           RCD: Extended S
     C                   Parm      'I'           WQ0002            1            Action Code
      *
     C                   If        *In90 = *On
      * Call to program ended in error
     C                   Movel     'Y2U0032'     W0RTN
     C                   Movel     *BLANKS       W0CLPG           10
     C                   Movel     'SD0911R'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   Movel     'Y2U0032'     ZAMSID
     C                   Movel     'Y2USRMSG'    ZAMSGF
     C                   Movel     W0CLPG        ZAMSDA                         Message data
     C                   Exsr      ZASNMS
     C                   EndIf
      *
      * Error detected?
     C                   If        W0RTN <> *Blanks
     C                   Eval      *In99 = *On
     C                   EndIf
     C                   Eval      W0RSF = 'Y'
     C                   EndIf                                                  *FI
 
     C                   Else
      * CASE: *OTHERWISE
      * CASE: CTL.*CMD key is *Go to 'Add' mode
     C                   If        *In09 = *On
      * Send message 'Function key not allowed'
     C                   Movel     'USR0533'     ZAMSID
     C                   Exsr      ZASNMS
     C                   Eval      *In99 = *On
     C                   Goto      DAEXIT                                       *QUIT
     C                   End                                                    *FI
     C                   End                                                    *FI
      *================================================================
     CSR   DAEXIT        EndSr
      /EJECT
     CSR   DBPRSF        BegSr
      *================================================================
      * Process modified subfile record
      *================================================================
     C                   ReadC     #SFLRCD                                92    *
     C                   DoW       Not %Eof
      * Process subfile record
     C                   Exsr      DCPRSR
     C                   UpDate    #SFLRCD
     C                   ReadC     #SFLRCD                                92    *
     C                   EndDo
      *================================================================
     CSR   DBEXIT        EndSr
      /EJECT
     CSR   DCPRSR        BegSr
      *================================================================
      * Process subfile record
      *================================================================
      * Setof error indicators and SFLNXTCHG
     C                   Eval      *In34 = *Off
     C                   Eval      *In98 = *Off
      * USER: Process subfile record (Pre-confirm)
      * User Requests E - Enquire.
      * CASE: RCD.*SFLSEL is *Enquire
     C                   If        #1SEL = 'E'
      * Display Extended Settle - Extended Settlements  *
     C                   Clear                   PBRC
     C                   Eval      PBCYCD =  #1CYCD
     C                   Eval      PBCUST =  #1CUST
     C                   Move      #1SEQN        PBSEQN
     C                   Eval      PBTRTY =  #1TRTY
      *
     C                   Call      'SD0911E'                            90      Display Extende
     C                   Parm      *Blank        W0RTN             7
     C                   Parm                    PBRC                           RCD: Extended S
      *
     C                   If        *In90 = *On
      * Call to program ended in error
     C                   Movel     'Y2U0032'     W0RTN
     C                   Movel     *BLANKS       W0CLPG           10
     C                   Movel     'SD0911E'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   Movel     'Y2U0032'     ZAMSID
     C                   Movel     'Y2USRMSG'    ZAMSGF
     C                   Movel     W0CLPG        ZAMSDA                         Message data
     C                   Exsr      ZASNMS
     C                   EndIf
      *
      * Error detected?
     C                   If        W0RTN <> *Blanks
     C                   Eval      *In98 = *On
     C                   EndIf
     C                   Eval      W0RSF = 'Y'
     C                   EndIf                                                  *FI
      * User Requests File Maintenance.
      * CASE: PAR.Display file mode is Maintenance mode
     C                   If        P1DFMD = 'M'
      *
      * CASE: RCD.*SFLSEL is *Amend
     C                   If        #1SEL = 'A' and *In98 = *Off
      * Edit Extended Settlements - Extended Settlements  *
     C                   Clear                   PARC
     C                   Eval      PACYCD = #1CYCD
     C                   Eval      PACUST = #1CUST
     C                   Move      #1SEQN        PASEQN
     C                   Eval      PATRTY = #1TRTY
 
     C                   Call      'SD0911R'                            90      Edit Extended S
     C                   Parm      *BLANK        W0RTN             7
     C                   Parm                    PARC                           RCD: Extended S
     C                   Parm      'A'           WQ0003            1            Action Code
      *
     C                   If        *In90 = *On
      * Call to program ended in error
     C                   Movel     'Y2U0032'     W0RTN
     C                   Movel     *BLANKS       W0CLPG           10
     C                   Movel     'SD0911R'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   Movel     'Y2U0032'     ZAMSID
     C                   Movel     'Y2USRMSG'    ZAMSGF
     C                   Movel     W0CLPG        ZAMSDA                         Message data
     C                   Exsr      ZASNMS
     C                   EndIF
      *
      * Error detected?
     C                   If        W0RTN <> *Blanks
     C                   Eval      *In98 = *On
     C                   EndIf
     C                   Eval      W0RSF = 'Y'
     C                   EndIf                                                  *FI
      * CASE: RCD.*SFLSEL is *Delete
     C                   If        #1SEL = 'D' and *In98 = *Off
      * Edit Extended Settlements - Extended Settlements  *
     C                   Clear                   PARC
     C                   Eval      PACYCD = #1CYCD
     C                   Eval      PACUST = #1CUST
     C                   Move      #1SEQN        PASEQN
     C                   Eval      PATRTY = #1TRTY
      *
     C                   Call      'SD0911R'                            90      Edit Extended S
     C                   Parm      *BLANK        W0RTN             7
     C                   Parm                    PARC                           RCD: Extended S
     C                   Parm      'D'           WQ0004            1            Action Code
      *
     C                   If        *In90 = *On
      * Call to program ended in error
     C                   Movel     'Y2U0032'     W0RTN
     C                   Movel     *BLANKS       W0CLPG           10
     C                   Movel     'SD0911R'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   Movel     'Y2U0032'     ZAMSID
     C                   Movel     'Y2USRMSG'    ZAMSGF
     C                   Movel     W0CLPG        ZAMSDA                         Message data
     C                   Exsr      ZASNMS
     C                   EndIF
      *
      * Error detected?
     C                   If        W0RTN <> *Blanks
     C                   Eval      *In98 = *On
     C                   EndIf
     C                   Eval      W0RSF = 'Y'
     C                   EndIf                                                  *FI
      *
     C                   Else
      * CASE: *OTHERWISE
      * CASE: RCD.*SFLSEL is *Amend or *Delete
     C                   If        #1SEL = 'A' or #1SEL = 'D'
      * Setup message data for message
     C                   Movel     #1SEL         ZA0001                         *SFLSEL
      * Send message 'value for field not valid'
     C                   Movel     'USR0553'     ZAMSID
     C                   Exsr      ZASNMS
     C                   Eval      *In98 = *On
     C                   Eval      *In34 = *On
     C                   EndIf                                                  *FI
     C                   EndIf                                                  *FI
      * Exit Program Processing - Fast Exit.
      * CASE: PGM.*Return code is *User QUIT requested
     C                   If        W0RTN = 'Y2U9999'
     C                   Eval      P0RTN = W0RTN
     C                   Exsr      ZYEXPG
     C                   EndIf                                                  *FI
 
      * SFLRCD invalid
     C                   If        *In98 = *On
     C  N99              Z-Add     ##RR          ##SFRC               99        *
      * SFLNXTCHG
     C                   Eval      *In84 = *On
     C                   Else
      * SFLRCD valid
      * SFLNXTCHG
     C                   Eval      *In84 = *Off
     C                   Eval      #1SEL = *Blanks
     C                   EndIf                                                  FI *IN98
      *================================================================
     CSR   DCEXIT        EndSr
      /EJECT
     CSR   FBRQRL        BegSr
      *================================================================
      * Request subfile reload
      *================================================================
     C                   Eval      W0RSF = 'Y'
      *================================================================
     CSR   FBEXIT        EndSr
      /EJECT
     CSR   MBFL#1        BegSr
      *================================================================
      * Move SDFNMSL2 fields to subfile
      *================================================================
     C                   Eval      #1SEL = *Blanks
     C                   Eval      #1CVMR = LCVMR
     C                   Eval      #1RSTY = LRSTY
     C                   Eval      #1RONO = LRONO
     C                   Eval      #1ROBN = LROBN
     C                   Eval      #1ROCS = LROCS
     C                   Eval      #1RIBN = LRIBN
     C                   Eval      #1RIBL = LRIBL
     C                   Eval      #1PSTY = LPSTY
     C                   Eval      #1PONO = LPONO
     C                   Eval      #1POBN = LPOBN
     C                   Eval      #1POCS = LPOCS
     C                   Eval      #1PIBN = LPIBN
     C                   Eval      #1PIBA = LPIBA
     C                   Eval      #1RCNO = LRCNO
     C                   Eval      #1RCAL = LRCAL
     C                   Eval      #1RCNB = LRCNB
     C                   Eval      #1ACBN = LACBN
     C                   Eval      #1ACBL = LACBL
     C                   Eval      #1BYNB = LBYNB
     C                   Eval      #1POCS = LPOCS
     C                   Eval      #1BACL = LBACL
     C                   Eval      #1DPY1 = LDPY1
     C                   Eval      #1DPY2 = LDPY2
     C                   Eval      #1DPY3 = LDPY3
     C                   Eval      #1DPY4 = LDPY4
     C                   Eval      #1DECG = LDECG
     C                   Eval      #1BBI1 = LBBI1
     C                   Eval      #1BBI2 = LBBI2
     C                   Eval      #1POCS = LPOCS
     C                   Eval      #1BBI3 = LBBI3
     C                   Eval      #1BBI4 = LBBI4
     C                   Eval      #1BBI5 = LBBI5
     C                   Eval      #1BBI6 = LBBI6
     C                   Eval      #1LCD  = LLCD
     C                   Eval      #1TYLC = LTYLC
     C                   Eval      #1ORBR = LORBR
     C                   Eval      #1OPBR = LOPBR
     C                   Eval      #1POCS = LPOCS
     C                   Eval      #1DSR1 = LDSR1
     C                   Eval      #1DSR2 = LDSR2
     C                   Eval      #1DSR3 = LDSR3
     C                   Eval      #1DSR4 = LDSR4
     C                   Eval      #1DSR5 = LDSR5
     C                   Eval      #1DSR6 = LDSR6
     C                   Eval      #1SSR1 = LSSR1
     C                   Eval      #1SSR2 = LSSR2
     C                   Eval      #1POCS = LPOCS
     C                   Eval      #1SSR3 = LSSR3
     C                   Eval      #1SSR4 = LSSR4
     C                   Eval      #1SSR5 = LSSR5
     C                   Eval      #1SSR6 = LSSR6
     C                   Eval      #1CND1 = LCND1
     C                   Eval      #1CND2 = LCND2
     C                   Eval      #1CND3 = LCND3
     C                   Eval      #1CND4 = LCND4
     C                   Eval      #1POCS = LPOCS
     C                   Eval      #1CND5 = LCND5
     C                   Eval      #1CND6 = LCND6
     C                   Eval      #1ISDA = LISDA
     C                   Eval      #1AGTY = LAGTY
     C                   Eval      #1AGDT = LAGDT
     C                   Eval      #1AGVV = LAGVV
     C                   Eval      #1CUST = LCUST
     C                   Eval      #1CYCD = LCYCD
     C                   Eval      #1POCS = LPOCS
     C                   Eval      #1CSSN = LCSSN
     C                   Eval      #1CRNM = LCRNM
     C                   Eval      #1CRTN = LCRTN
     C                   Eval      #1TRTY = LTRTY
     C                   Move      LSEQN         #1SEQN
      *
     C                   If        CEU003 = *On
     C                   Eval      #1STCY = LSTCY
     C                   Eval      #1IERI = LIERI
     C                   EndIf
     C                   Eval      #1SEL = *Blanks
      *================================================================
     CSR   MBEXIT        EndSR
      /EJECT
     CSR   MEIZ#2        BegSr
      *================================================================
      * Initialise subfile control
      *================================================================
     C                   Eval      #2RSTY = *Blanks
     C                   Eval      #2RONO = *Blanks
     C                   Eval      #2ROBN = *Blanks
     C                   Eval      #2ROCS = *Blanks
     C                   Eval      #2RIBN = *Blanks
     C                   Eval      #2RIBL = *Blanks
     C                   Eval      #2PSTY = *Blank
     C                   Eval      #2PONO = *Blank
     C                   Eval      #2POBN = *Blanks
     C                   Eval      #2POCS = *Blanks
     C                   Eval      #2PIBN = *Blanks
     C                   Eval      #2PIBA = *Blanks
     C                   Eval      #2RCNO = *Blanks
     C                   Eval      #2RCAL = *Blanks
     C                   Eval      #2RCNB = *Blank
     C                   Eval      #2ACBN = *Blank
     C                   Eval      #2ACBL = *Blanks
     C                   Eval      #2BYNB = *Blanks
     C                   Eval      #2BACL = *Blanks
     C                   Eval      #2DPY1 = *Blanks
     C                   Eval      #2DPY2 = *Blanks
     C                   Eval      #2DPY3 = *Blanks
     C                   Eval      #2DPY4 = *Blank
     C                   Eval      #2DECG = *Blank
     C                   Eval      #2BBI1 = *Blanks
     C                   Eval      #2BBI2 = *Blanks
     C                   Eval      #2BBI3 = *Blanks
     C                   Eval      #2BBI4 = *Blanks
     C                   Eval      #2BBI5 = *Blanks
     C                   Eval      #2BBI6 = *Blanks
     C                   Eval      #2LCD  = *Zeros
     C                   Eval      #2TYLC = *Blank
     C                   Eval      #2CUST = *Blanks
     C                   Eval      #2CYCD = *Blanks
     C                   Eval      #2TRTY = *Blank
     C                   Eval      #2SEQN = *Blank
      *================================================================
     CSR   MEEXIT        EndSr
      /EJECT
     CSR   Y0SET         BegSr
      *================================================================
      * Set cursor by *SET CURSOR data
      *================================================================
      *================================================================
     CSR   Y0EXIT        EndSr
      /EJECT
     CSR   Y8TST         BEGSR
      *================================================================
      * Test cursor
      *================================================================
     C                   Eval      ZINPOS = @#RWCL
     C     ZINPOS        Div       256           W0CRW
     C                   MvR                     W0CCL
      *================================================================
     CSR   Y8EXIT        EndSr
      /EJECT
     CSR   Y9CLR         BegSr
      *================================================================
      * Clear *SET CURSOR data
      *================================================================
      *================================================================
     CSR   Y9EXIT        EndSr
      /EJECT
     CSR   ZASNMS        BegSr
      *================================================================
      * Send message to program's message queue
      *================================================================
      * If no message file specified, use default
     C                   If        ZAMSGF = *Blanks
     C                   Eval      ZAMSGF = ZADFMF
     C                   EndIF
 
     C                   Call      'ZA0340'
     C                   Parm                    ZAMSGF
     C                   Parm                    ZAMSID
 
     C                   Reset                   ZAMSGF
 
      *================================================================
     CSR   ZAEXIT        EndSr
      /EJECT
     CSR   ZHHPKY        BegSr
      *================================================================
      * Display HELP text
      *================================================================
      * Signal help request
     C                   Eval      W0HLP = 'Y'
      *
      * Extract cursor row and column
     C     @#RWCL        Div       256           ZHCSRW
     C                   MvR                     ZHCSCL                         Column
      *
      * Save cursor position for redisplay
     C                   Eval      ZZCSRW = ZHCSRW
     C                   Eval      ZZCSCL = ZHCSCL
 
     C                   Call      'YDDSHPR'
     C                   Parm      ##PGM         W0HPMB           10            Help text sourc
     C                   Parm      *BLANK        YYHPFL           10            Help text file
     C                   Parm      *BLANK        YYHPLB           10            Help text libra
     C                   Parm                    W0RTN             7
     C                   Parm      '*START'      YYHLVN           10            Help label
     C                   Parm      '*NORMAL'     YYUSOP           10            Options
     C                   Parm      ZHCSRW        YYRW              5 0          Row
     C                   Parm      ZHCSCL        YYCL              5 0          Column
     C                   Parm      *ZERO         YYLGCT            5 0          # of grps
     C                   Parm      *BLANK        YYLGVN           10            Label grps
      *
      * Clear set cursor DDS indicator
     C                   If        *In94 = *Off
     C                   Eval      WCSRLC = 'OFF'
     C                   Eval      *In94 = *On
     C                   EndIF
      *================================================================
     CSR   ZHEXIT        EndSr
      /EJECT
     CSR   ZXEXPG        BegSr
      *================================================================
      * Cancel & exit program
      *================================================================
     C                   Exsr      ZYEXPG
      *================================================================
     CSR   ZXEXIT        EndSr
      /EJECT
     CSR   ZYEXPG        BegSr
      *================================================================
      * Exit program: Direct
      *================================================================
      * Terminate program
     C                   Eval      *InLr = *On
      * Exit program
     C                   Return
      *
      *================================================================
     CSR   ZYEXIT        EndSr
      /EJECT
     CSR   ZZINIT        BegSR
      *================================================================
      * Initialisation
      *================================================================
 
      * Obtain default message file
     C     *DtaAra       Define    Y2MGFLA       ZADFMF           10
     C                   In        ZADFMF
 
     C                   Eval      P0RTN = *Blanks
     C                   Eval      W0RTN = *Blanks
     C                   Eval      W0RSL = *Blanks
     C                   Eval      W0RSF = *Blanks
     C                   Eval      W0ENV = '400'
      * Setup job date/time
     C                   Eval      ##JDT = UDate
      * Set century digit (If YY prior to 1940 treat as 20YY)
     C                   If        ##JYY < 40
     C                   Eval      ##JCC = 1
     C                   Else
     C                   Eval      ##JCC = 0
     C                   EndIf
 
     C                   Time                    ##JTM
      * Update screen time
     C                   Time                    ##TME             6 0
      * Move main file information to JOB context
     C                   Eval      ZZFFL = @1FFL
     C                   Eval      ZZFLB = @1FLB
     C                   Eval      ZZFMB = @1FMB
     C                   Eval      @1FFL = ZZFFL
     C                   Eval      @1FLB = ZZFLB
     C                   Eval      @1FMB = ZZFMB
     C                   Call      'Y2QLVNR'
     C                   Parm                    ZZFFL            10
     C                   Parm                    ZZFLB            10
     C                   Parm                    ZZFQL            21            LIBRARY/FILE
      * Open files
     C                   Open      SD0910D#
     C                   Open      SDFNMSL2
 
     C                   Eval      ##SFPG = 14
     C                   Eval      ##SFRC = 1
      * Maximum record number
     C                   Eval      ##RRMX = *Zeros
      * Processed Subfile record
     C                   Eval      W0RR0 = *Zeros
      *................................................................
     C                   Eval      W0GRP = *Blanks
      * Get Rundate - Rundate  *
     C                   In        RUNDAT
     C                   Eval      ##MRDT = AGMRDT
     C                   Eval      ##PGM = PSProcName
     C                   Eval      ##JOB = PSJobName
     C                   Eval      ##USR = PSUser
      * Variable Hdr for Ext Sett - Extended Settlements  *
     C*****************************************************************
     C*
     C*    Variable Title For Extended Settlements Display File
     C*
     C*****************************************************************
     C                   Eval      WUMSGF = 'SDUSRMSG'
     C                   Eval      WUMTXT = *Blanks
     C*
     C                   If        P1DFMD = 'M'
     C* Setup footer text:
     C* Extended Settlements Maintenance
     C                   Eval      WUMSID = 'USR4630'
     C                   Call      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        Parm      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        Parm      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        Parm      WUMTXT        WQ0288           80            Message Text
 
     C                   Eval      ##URPT = WUMTXT
 
     C                   If        *In90 = *On
     C* Call to program ended in error
     C                   Eval      W0RTN = 'Y2U0032'
     C                   Eval      W0CLPG = 'SDRTVTXT  '
     C* Send message '*Error occured on CALL...'
     C                   Eval      ZAMSID = 'Y2U0032'
     C                   Eval      ZAMSGF = 'Y2USRMSG'
     C                   Eval      ZAMSDA = W0CLPG
     C                   Exsr      ZASNMS
     C                   EndIf
 
     C                   Else
     C* Setup footer text:
     C* Extended Settlements Enquiry
     C                   Eval      WUMSID = 'USR4631'
     C                   Call      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        Parm      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        Parm      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        Parm      WUMTXT        WQ0288           80            Message Text
 
     C                   Eval      ##URPT = WUMTXT
 
     C                   If        *In90 = *On
     C* Call to program ended in error
     C                   Eval      W0RTN = 'Y2U0032'
     C                   Eval      W0CLPG = 'SDRTVTXT  '
     C* Send message '*Error occured on CALL...'
     C                   Eval      ZAMSID = 'Y2U0032'
     C                   Eval      ZAMSGF = 'Y2USRMSG'
     C                   Eval      ZAMSda = W0CLPG
     C                   Exsr      ZASNMS
     C                   EndIf
 
     C                   EndIf
      * Set-up Dsp. file footer - Standard Functions  *
     C* MOVE THE CORRECT TEXT INTO THE DISPLAY FILE'S FOOTER DEPENDING ON THE
     C* MODE
     C                   Eval      WUMSGF = 'SDUSRMSG'
     C                   Eval      WUMTXT = *Blanks
 
     C                   If        P1DFMD = 'E'
     C* Setup footer text:
     C* E=Enquire   F3=Main Menu   F5=Refresh
     C                   Eval      WUMSID = 'USR3341'
     C                   Call      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        Parm      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        Parm      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        Parm      WUMTXT        KE0288           80            Message Text
 
     C                   Eval      ##CTX1 = WUMTXT
 
     C                   If        *In90 = *On
     C* Call to program ended in error
     C                   Eval      W0RTN = 'Y2U0032'
     C                   Eval      W0CLPG = 'SDRTVTXT  '
     C* Send message '*Error occured on CALL...'
     C                   Eval      ZAMSID = 'Y2U0032'
     C                   Eval      ZAMSGF = 'Y2USRMSG'
     C                   Eval      ZAMSDA = W0CLPG
     C                   Exsr      ZASNMS
     C                   EndIf
     C                   EndIf
 
     C                   If        P1DFMD = 'M'
     C                   If        WUMDEL <> 'N'
     C* Setup footer text:
     C* A=Amend  D=Delete  E=Enquire  F3=Main Menu  F5=Refresh
     C* F9=Go to 'Add'
     C                   Eval      WUMSID = 'USR3334'                           Message Identifier
     C                   Call      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        Parm      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        Parm      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        Parm      WUMTXT        KE0288           80            Message Text
 
     C                   Eval      ##CTX1 = WUMTXT                              Message Identifier
      *
     C                   If        *In90 = *On
      * Call to program ended in error
     C                   Eval      W0RTN = 'Y2U0032'
     C                   Eval      W0CLPG = 'SDRTVTXT  '
      * Send message '*Error occured on CALL...'
     C                   Eval      ZAMSID = 'Y2U0032'
     C                   Eval      ZAMSGF = 'Y2USRMSG'
     C                   Eval      ZAMSDA = W0CLPG
     C                   Exsr      ZASNMS
     C                   EndIf
     C                   EndIf
 
     C                   If        WUMDEL = 'N'
     C* Setup footer text:
     C* A=Amend  E=Enquire  F3=Main Menu  F5=Refresh  F9=Go to 'Add' Mode
     C                   Eval      WUMSID = 'USR3335'                           Message Identifier
     C                   Call      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        Parm      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        Parm      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        Parm      WUMTXT        KE0288           80            Message Text
 
     C                   Eval      ##CTX1 = WUMTXT                              Message Identifier
 
     C                   If        *In90 = *On
     C* Call to program ended in error
     C                   Eval      W0RTN = 'Y2U0032'
     C                   Eval      W0CLPG = 'SDRTVTXT  '
     C* Send message '*Error occured on CALL...'
     C                   Eval      ZAMSID = 'Y2U0032'
     C                   Eval      ZAMSGF = 'Y2USRMSG'
     C                   Eval      ZAMSDA = W0CLPG
     C                   Exsr      ZASNMS
     C                   EndIf
 
     C                   EndIf
     C                   EndIf
      *
      ** Access Switchable Feature Details
      *
     C                   Call      'AOSARDR0'
     C                   Parm      *BLANKS       PRTCD             7
     C                   Parm      '*VERIFY '    POPTN             7
     C                   Parm      'CEU003'      PSARD             6
     C     SCSARD        Parm      SCSARD        DSSDY
      *
     C                   If        PRTCD = *Blanks
     C                   Eval      CEU003 = *On
     C                   Eval      *In35 = *On
     C                   Else
     C                   Eval      CEU003 = *Off
     C                   Eval      *In35 = *Off
     C                   EndIf
      *
      * Initialise subfile control
     C                   Exsr      MEIZ#2
      *================================================================
     CSR   ZZEXIT        EndSr
      /EJECT
     CSR   *PSSR         BegSr
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
      *
      * Start of PSSR user point.
      *
      *
      * Standard Midas PSSR processing.
      *
      *
      * End of PSSR user point.
      *
      *
      *================================================================
     CSR                 EndSr
      *================================================================
** CPY@     : Copyright notice for inclusion in all programs
(c) Finastra International Limited 2004
