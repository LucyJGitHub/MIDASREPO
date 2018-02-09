     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Exchange Rate Spread Report')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer module                                *
      *                                                               *
      *  FT000574   - Exchange Rate Spread Report                     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG433             Date 02Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009  *CREATE    Date 25May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG433 - Recompiled due to change in FTXTRHPD                *
      *  CFT009 - Funds Transfer Fees and Charge Development          *
      *                                                               *
      *****************************************************************
      *  Exchange Rate Spread Parent Details : Main Index
     FFTXTRHL0  IF   E           K Disk
 
      *  Exchange Rate Spread Parent Details : Alternative Index
     FFTXTRHL1  IF   E           K Disk    Rename(FTXTRHD0:FTXTRHD1) Prefix(X_)
 
      *  Exchange Rate Spread Child Details
     FFTXTRDL0  IF   E           K Disk
 
      *  Exchange Rate Spread Printer File
     FFT000574P1O    E             Printer Infds(DS574) OFLIND(*In01)
     FFT000574AUO    E             Printer Infds(AU574) OFLIND(*In02)
 
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
     DDS574            DS
     D  SFName                83     92
     D  SFnum                123    124B 0
 
     DAU574            DS
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
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
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
 
     D  #Pgm           S             10
 
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
 
      * Read all parent records.  Output on header record.  Read all child
      *  details.  Output on detail record.
      *  Page break after each header record
     C                   Read      FTXTRHL0                               99
     C                   Dow       *In99 = *Off
     C                   Eval      RptDtl = 'Y'
     C                   Exsr      Clr_Hdr
     C                   Exsr      Mov_Hdr
     C                   Add       1             PageNo
     C                   Write     Hdr574
     C                   Write     Dtl574A
     C                   Write     Dtl574B
 
      *
      ** Read and report detail records
      *
     C                   Eval      *In98 = *Off
     C     SPRCOD        Setll     FTXTRDL0                               97
 
     C                   If        Not *In97
     C                   Write     NoDetl
     C                   Else
 
     C     SPRCOD        ReadE     FTXTRDL0                               98
     C                   Dow       *In98 = *Off
     C                   Exsr      Clr_Dtl
     C                   Exsr      Mov_dtl
 
      * Overflow ?
     C                   If        *In01
     C                   Add       1             PageNo
     C                   Write     Hdr574
     C                   Write     Dtl574A
     C                   Write     Dtl574B
     C                   Eval      *In01 = *Off
     C                   Endif
 
     C                   Write     Man574
     C                   Write     STP574
     C     SPRCOD        ReadE     FTXTRDL0                               98
     C                   Enddo
 
     C                   Endif
 
 
     C                   Read      FTXTRHL0                               99
     C                   Enddo
 
 
     C                   If        RptDtl = 'Y'
     C                   Write     Trl574
     C                   Else
     C                   Add       1             PageNo
     C                   Write     Hdr574
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
 
     C                   Eval      WSPRCOD  = *Blanks
     C                   Eval      WXRSDSC  = *Blanks
     C                   Eval      WPNTDCD  = *Blanks
     C                   Eval      WPXRSDSC = *Blanks
 
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
 
     C                   Eval      WSPRCOD  = SPRCOD
     C                   Eval      WXRSDSC  = XRSDSC
     C                   Eval      WPNTDCD  = PNTDCD
 
      * If parent code defined, get description
     C                   If        PNTDCD <> *Blanks
     C     PNTDCD        Chain     FTXTRHL1                           97
     C                   Eval      WPXRSDSC = X_XRSDSC
     C                   Endif
 
 
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Clr_Dtl  - Clear Detail Printer Format                        *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Clr_Dtl       Begsr
 
     C                   Eval      WXRSCCY  = *Blanks
 
     C                   Eval      WMANBPC  = *Blanks
     C                   Eval      WMANBSP  = *Blanks
     C                   Eval      WMANBSN  = *Blanks
     C                   Eval      WMANSPC  = *Blanks
     C                   Eval      WMANSSP  = *Blanks
     C                   Eval      WMANSSN  = *Blanks
 
     C                   Eval      WSTPBPC  = *Blanks
     C                   Eval      WSTPBSP  = *Blanks
     C                   Eval      WSTPBSN  = *Blanks
     C                   Eval      WSTPSPC  = *Blanks
     C                   Eval      WSTPSSP  = *Blanks
     C                   Eval      WSTPSSN  = *Blanks
 
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Mov_Dtl  - Move Data to Printer Detail Format                 *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Mov_Dtl       Begsr
 
     C                   Eval      WXRSCCY  = XRSCCY
     C                   Eval      WMANBSN  = MANBSN
     C                   Eval      WMANSSN  = MANSSN
     C                   Eval      WSTPBSN  = STPBSN
     C                   Eval      WSTPSSN  = STPSSN
 
      *
      ** The following need to be converted via ZEDIT
      *
     C                   Eval      ZFIELD = *Blanks
     C                   MOVE      MANBPC        ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM      8             ZADEC             1 0
     C                   MOVE      ZFIELD        WMANBPC
      *
 
     C                   Eval      ZFIELD = *Blanks
     C                   MOVE      MANBSP        ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM      8             ZADEC             1 0
     C                   MOVE      ZFIELD        WMANBSP
      *
 
     C                   Eval      ZFIELD = *Blanks
     C                   MOVE      MANSPC        ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM      8             ZADEC             1 0
     C                   MOVE      ZFIELD        WMANSPC
      *
 
     C                   Eval      ZFIELD = *Blanks
     C                   MOVE      MANSSP        ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM      8             ZADEC             1 0
     C                   MOVE      ZFIELD        WMANSSP
      *
 
     C                   Eval      ZFIELD = *Blanks
     C                   MOVE      STPBPC        ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM      8             ZADEC             1 0
     C                   MOVE      ZFIELD        WSTPBPC
      *
 
     C                   Eval      ZFIELD = *Blanks
     C                   MOVE      STPBSP        ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM      8             ZADEC             1 0
     C                   MOVE      ZFIELD        WSTPBSP
      *
 
     C                   Eval      ZFIELD = *Blanks
     C                   MOVE      STPSPC        ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM      8             ZADEC             1 0
     C                   MOVE      ZFIELD        WSTPSPC
      *
 
     C                   Eval      ZFIELD = *Blanks
     C                   MOVE      STPSSP        ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM      8             ZADEC             1 0
     C                   MOVE      ZFIELD        WSTPSSP
 
 
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
     C                   Eval      #Pgm = 'FTC000574'
 
     C     *Entry        Plist
     C                   Parm                    PARM1             1
     C                   Parm                    @RSEQ             5
     C                   Parm                    @RLEV             1
     C                   Parm                    @RENT             3
 
      *
      *  Setup ZSFILE : Print P1
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
     C                   Eval      DBPgm = #Pgm
     C                   Eval      DBKey = 'FT000574P1'
     C                   Eval      DBFILE = 'ZSFILE'
     C                   Eval      DBase = 1
     C                   Out       LDA
     C                   Write     DBERROR
     C                   Exsr      *PSSR
     C                   Return
     C                   Endif
 
      *  Setup ZSFILE : Print AUDIT
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
     C                   Eval      DBPgm = #Pgm
     C                   Eval      DBKey = 'FT000574AU'
     C                   Eval      DBFILE = 'ZSFILE'
     C                   Eval      DBase = 2
     C                   Out       LDA
     C                   Write     DBERROR
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
     C                   Eval      dbase = 3
     C                   Eval      dbkey = '*FIRST'
     C                   Out       LDA
     C                   Write     DBERROR
     C                   Exsr      *PSSR
     C                   Endif
 
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
