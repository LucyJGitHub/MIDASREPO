     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Receivers and Intermediaries Report')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer module                                *
      *                                                               *
      *  FT000577   - Receivers and Intermediaries Report Listing     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009   *CREATE   Date 25May00               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CFT009 - Funds Transfer Fees and Charge Development          *
      *                                                               *
      *****************************************************************
      *  Receivers and intermediaries charges : Main Index
     FFTRICHL0  IF   E           K Disk
 
      *  Receivers and intermediaries charges Printer File
     FFT000577P1O    E             Printer Infds(DS577) OFLIND(*In01)
     FFT000577AUO    E             Printer Infds(AU577) OFLIND(*In02)
 
      * Customer S.W.I.F.T. codes
     FSDCUSTL7  IF   E           K DISK
 
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
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
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
     DDS577            DS
     D  SFName                83     92
     D  SFnum                123    124B 0
 
     DAU577            DS
     D  SFNameAU              83     92
     D  SFnumAU              123    124B 0
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for access programs, short DS
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      * Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External data structure for customer number
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** External data structure for BIC
     D MEBIC         E DS                  EXTNAME(MEBICDPD)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D No_Desc         C                   Const('No Description Found')
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D  Zseq           S                   Like(@RSEQ)
     D  ZEntP1         S              3
     D  ZSName         S             10
     D  ZSNum          S              6  0
     D  ZSErr          S              1
 
     D  RptDtl         S              1
 
     D  @Type          S                   Like(@Rtcd)
 
     D #Pgm            S             10
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *                     INDICATOR  USAGE                          *
      *                                                               *
      * 01 : Printer Overflow                                         *
      * 97 : General Chain Indicator                                  *
      * 98 : Read detail records (EOF)                                *
      * 99 : Read Header Details (EOF)                                *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      * Read all records.
     C                   Read      FTRICHL0                               99
     C                   Dow       *In99 = *Off
     C                   Eval      RptDtl = 'Y'
     C                   Exsr      Clr_Hdr
     C                   Exsr      Mov_Hdr
 
      * Overflow ?
     C                   If        *In01
     C                   Add       1             PageNo
     C                   Write     Hdr577
     C                   Eval      *In01 = *Off
     C                   Endif
 
     C                   Write     Dtl577
 
     C                   Read      FTRICHL0                               99
     C                   Enddo
 
 
     C                   If        RptDtl = 'Y'
     C                   Write     Trl577
     C                   Else
     C                   Add       1             PageNo
     C                   Write     Hdr577
     C                   Write     NoDetl
     C                   Endif
 
     C                   Eval      *InLR = *On
 
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Clr_Hdr  - Clear Header Printer Format                        *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Clr_Hdr       Begsr
 
     C                   Eval      WPTYID   = *Blanks
     C                   Eval      WDESCR   = *Blanks
     C                   Eval      WCURCCY  = *Blanks
     C                   Eval      WTRANTY  = *Blanks
     C                   Eval      WCHGCD   = *Blanks
 
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Mov_Hdr  - Move Data to Header Printer Format                 *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Mov_Hdr       Begsr
 
     C                   Eval      WPTYID   = PTYID
     C                   Eval      WCURCCY  = CURCCY
     C                   Eval      WTRANTY  = TRANTY
     C                   Eval      WCHGCD   = CHGCD
 
      *
      **  Get BIC, Customer Number or Customer Shortname Description
      **   Move into Description Field (WDESCR)
      *
 
     C                   Eval      Char18 = PTYID
 
     C                   CallB     'AOBICDV0'
     C                   Parm      *Blanks       RetCodeIn
     C                   Parm                    Char18           18
     C                   Parm                    @Type
     C                   Parm                    DSSDY
 
     C                   Select
 
     C                   When      @Type = '*BIC'
     C                   Eval      MEBIC  = DSSDY
     C                   Eval      WDESCR    =   BDINS1
 
     C                   When      @Type = '*NUMBER' or @Type = '*SHNAME'
     C                   Eval      SDCUST = DSSDY
     C                   Eval      WDESCR    =   BBCNA1
 
     C                   Other
 
     C                   MoveL     WPTYID        SWFTKY           12
     C     SWFTKY        Chain     SdCustL7                           97
     C                   If        *In97
     C                   Eval      WDESCR   =  No_Desc
     C                   Else
     C                   Eval      WDESCR    =   BBCNA1
     C                   Endif
 
     C                   Endsl
 
 
     C                   Endsr
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
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
      * Program Name
     C                   Eval      #Pgm = 'FTC000577'
 
     C     *Entry        Plist
     C                   Parm                    PARM1             1
     C                   Parm                    @RSEQ             5
     C                   Parm                    @RLEV             1
     C                   Parm                    @RENT             3
 
      *
      *  Setup ZSFILE : List
      *
     C                   Eval      Zseq = @Rseq
 
     C                   Eval      ZSNum  = SFNum
     C                   Eval      ZSName = SFName
 
     C                   Call      'ZSFILE'
     C                   Parm                    ZSeq
     C                   Parm      *BLANKS       ZEntP1
     C                   Parm                    ZSName
     C                   Parm                    ZSNum
     C                   Parm      *BLANKS       ZSerr
 
     C                   If        ZSerr = 'Y'
     C                   Eval      *INU7 = *On
     C                   Eval      *INU8 = *On
     C                   Eval      *INLR = *On
     C     *Lock         In        LDA
     C                   Eval      DBPgm = 'FT000577'
     C                   Eval      DBKey = 'FT000577P1'
     C                   Eval      DBFILE = 'ZSFILE'
     C                   Eval      DBase = 1
     C                   Out       LDA
     C                   WRITE     DBERROR
     C                   Exsr      *PSSR
     C                   Return
     C                   Endif
 
      *
      *  Setup ZSFILE : Audit
      *
     C                   Eval      Zseq = @Rseq
 
     C                   Eval      ZSNum  = SFNumAU
     C                   Eval      ZSName = SFNameAU
 
     C                   Call      'ZSFILE'
     C                   Parm                    ZSeq
     C                   Parm      *BLANKS       ZEntP1
     C                   Parm                    ZSName
     C                   Parm                    ZSNum
     C                   Parm      *BLANKS       ZSerr
 
     C                   If        ZSerr = 'Y'
     C                   Eval      *INU7 = *On
     C                   Eval      *INU8 = *On
     C                   Eval      *INLR = *On
     C     *Lock         In        LDA
     C                   Eval      DBPgm = 'FT000577'
     C                   Eval      DBKey = 'FT000577AU'
     C                   Eval      DBFILE = 'ZSFILE'
     C                   Eval      DBase = 2
     C                   Out       LDA
     C                   WRITE     DBERROR
     C                   Exsr      *PSSR
     C                   Return
     C                   Endif
      *
      ** Get Report Header
      *
     C                   CallB     'AOBANKR0'
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*FIRST   '   @optn
     C     Sdbank        Parm      Sdbank        Dsfdy
 
     C                   If        @rtcd <> *Blanks
     C     *Lock         In        LDA
     C                   Eval      dbfile = 'SDBANKPD'
     C                   Eval      dbase = 2
     C                   Eval      dbkey = '*FIRST'
     C                   Out       LDA
     C                   WRITE     DBERROR
     C                   Exsr      *PSSR
     C                   Endif
 
      * Write Page Header
     C                   Eval      *In01 = *On
 
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
