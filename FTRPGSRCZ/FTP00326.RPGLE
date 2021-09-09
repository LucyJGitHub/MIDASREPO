     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTP00326   - Maintain Extended Payment Charge Defaults       *
      *                                                               *
      *  Function : This module allow the user to maintain default    *
      *             payments.                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  Last Amend No. MD31937            Date 13Jan15               *
      *  Last Amend No. AR856737           Date 13Sep11               *
      *  Last Amend No. URGIND             Date 21Jul2005             *
      *  Prev Amend No. STP009             Date 22Nov2004             *
      *                 STP001             Date 25Jan2005             *
      *                 ESL038             Date 04Oct2004             *
      *                 ERN054  *Create    Date 19Jun2003             *
      * Midas Release 4 --------------- Base -------------------------*
      *---------------------------------------------------------------*
      *                                                               *
      *  MD31937  - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 Upgrade STP enhancement to Midas Plus level.        *
      *  URGIND - Urgent Flag processing.                             *
      *  STP009 - Inc Settlement codes EC ZC TP                       *
      *  STP001 - Allow N in Destination Country                      *
      *  ESL038 - ING STP Development                                 *
      *  ERN054 - Agency message changes                              *
      *  CFT009 - Funds Transfer Fees and Charge Development          *
      *                                                               *
      *****************************************************************
      * Maintenance display file
     FFTP00326DFCF   E             WORKSTN SFILE(FT326S1:SFLRRN)

      * Customer default maintenance database file
     FFTPYCGV0  UF A E           K DISK    Commit Infds(PyDs) InFsr(PySr)
     FFTPYCGV1  IF A E           K DISK    RENAME(FTPYCGD0:FTREAD)

      * Transaction type file
     FFTTRNTL0  IF   E           K DISK

      * Deal sub-type file
     FFDDTSTL1  IF   E           K DISK

      * Customer grouping file
     FSDCGRPL0  IF   E           K DISK

      * Payment codes file
     FFTPCHGL0  IF   E           K DISK

      * Payment date offset file
     FFTPDOCL0  IF   E           K DISK

      * FX Spread Code
     FFTXTRHL0  IF   E           K DISK

     FACSTATV0  IF   E           K DISK
      * Account Location and Types file

     FFTLOOKV0  IF   E           K DISK
      *
      *  FT Look Up searches
      *
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
      *
      *               1 BRANCH
      *               2 CUSTOM
      *               3 CURRCY
      *               4 TRNTYP
      *               5 TRSBTY
      *               6 CSGRCD
      *               7 NETWRK
      *               8 PAYTYP
      *               9 MSGTYP
      *              10 STMTMD
      *              11 DRACTP
      *              12 CRACTP
      *              13 ADDDED
      *              14 FXTRAN
      *              15 TDCTRY
      *              16 URGFLG                                                                URGIND
      *
     D**Search#        S             20A   DIM(10)                                            EMRFIX
     D  Search#        S             20A   DIM(50)                                            EMRFIX
     D  SearchNbr      S              5  0
     D  KeySV          S              1A   DIM(20)
     D  Idx            S              5  0
     D  KeysComb       S              1

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
     D  Reload         S              1
     D  ValidOK        S              1

     DMSGDS            DS
     D  Msgid                  1      7
     D  Msgf                   8     17    Inz('FTUSRMSG')
     D  Msglib                18     27    Inz('*LIBL')
     D  MsgDta                28    283    Inz(' ')
     D  MsgRel               284    288    Inz('*SAME')


      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D FTLOOK        E DS                  EXTNAME(FTLOOKP0)
      * FTLOOKP0 - Look Up searches
     D  ##Search              16     35
      *
     D PyDS            DS
     D  PyStatus         *Status

      ** External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

      ** External data structure for customer number
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** External data structure for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** External data structure for Network details
     D SDNWRK        E DS                  EXTNAME(SDNWRKPD)

      ** External data structure for message type details
     D SDMTPY        E DS                  EXTNAME(SDMTPYPD)

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
     D Record_Locked   C                   Const(01218)
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D* @Optn                              Like(@RTCD)
     D  #Kyst                              Like(@RTCD)

     D  Inv_Code       S              1
     D  SelRcd         S              1

     D PyLocked        S              1
     D ReturnPt        S              6

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

     C                   Dow       *Inkc = *Off

     C                   If        PyLocked = 'Y'
     C                   Eval      PyLocked = 'N'
     C                   Eval      Reload   = 'Y'
     C                   Eval      Sflsel = ' '
     C                   Endif

     C                   If        Reload = 'Y'
     C                   Exsr      Clr@Sf
     C                   Exsr      Load@Sf
     C                   Endif

      * Display subfile data
     C                   Write     MsgCtl
     C  N30              Write     Blk326
     C                   Write     FT326T1
     C                   Exfmt     FT326C1

      *?Clear old messages
     C                   CALL      'ZA0250'


     C                   Select

      *?When positioner changed, reload subfile
     C                   When      *In60
     C                   Exsr      Clr@Sf
     C                   Exsr      Load@Sf

      *?F9 pressed : Add Record
     C                   When      *InkI  = *On
     C                   Eval      #Act   = 'I'
     C                   Eval      *In44  = *Off
     C                   Eval      *In49  = *Off
     C                   Eval      *In50  = *Off
     C                   Eval      *In51  = *Off
     C                   Eval      *In57  = *Off

      *?Clear Screen Data
     C                   Exsr      Clr_Dta

     C                   Exsr      DtlRcd

     C                   Other

      *?Sfldsp = 30.  ie records exist, then can process
     C                   If        *In30 = *On
     C                   Exsr      Prc@Sf
     C                   Endif

     C                   Endsl

      *?End *INKC
     C                   Enddo

     C                   Commit

     C                   Eval      *Inlr = *On

     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Clr@Sf - Clear Subfile                                        *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Clr@Sf        Begsr
      *?Clear Subfile
     C                   Seton                                          3031
     C                   Write     FT326C1
     C                   Setoff                                         3031
      *
      *?Reset SFLRRN
     C                   Eval      Sflrrn = *Zero
     C                   Endsr
      *****************************************************************
      *                                                               *
      * Load@sf - Load subfile data                                   *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Load@sf       Begsr

     C     *Loval        Setll     FTPYCGV1

      *?Read Records into Subfile
     C                   Read      FTPYCGV1                               32
     C                   Dow       *In32 = *Off

      *?Select Records
     C                   Eval      SelRcd = 'Y'

     C                   If        Sbranch <> *Blanks
     C                   If        Branch <> Sbranch
     C                   Eval      SelRcd = 'N'
     C                   Endif
     C                   Endif

     C                   If        Scustom <> *Blanks
     C                   If        Custom <> Scustom
     C                   Eval      SelRcd = 'N'
     C                   Endif
     C                   Endif

     C                   If        Scsgrcd <> *Blanks
     C                   If        Csgrcd <> Scsgrcd
     C                   Eval      SelRcd = 'N'
     C                   Endif
     C                   Endif
                                                                                              URGIND
     C                   If        SUrgFlg <> *Blanks                                         URGIND
     C                   If        UrgFlg <> SUrgFlg                                          URGIND
     C                   Eval      SelRcd = 'N'                                               URGIND
     C                   Endif                                                                URGIND
     C                   Endif                                                                URGIND

     C                   If        Scurrcy <> *Blanks
     C                   If        Currcy <> Scurrcy
     C                   Eval      SelRcd = 'N'
     C                   Endif
     C                   Endif

     C                   If        Strntyp <> *Blanks
     C                   If        Trntyp <> Strntyp
     C                   Eval      SelRcd = 'N'
     C                   Endif
     C                   Endif

     C                   If        Strsbty <> *Blanks
     C                   If        Trsbty <> Strsbty
     C                   Eval      SelRcd = 'N'
     C                   Endif
     C                   Endif

     C                   If        Snetwrk <> *Blanks
     C                   If        Netwrk <> SNetwrk
     C                   Eval      SelRcd = 'N'
     C                   Endif
     C                   Endif

     C                   If        Spaytyp <> *Blanks
     C                   If        Paytyp <> Spaytyp
     C                   Eval      SelRcd = 'N'
     C                   Endif
     C                   Endif

     C                   If        Smsgtyp <> *Blanks
     C                   If        Smsgtyp<> Smsgtyp
     C                   Eval      SelRcd = 'N'
     C                   Endif
     C                   Endif

     C                   If        Sstmtmd <> *Blanks
     C                   If        Stmtmd <> Sstmtmd
     C                   Eval      SelRcd = 'N'
     C                   Endif
     C                   Endif

     C                   If        Sdractp <> *Blanks
     C                   If        Dractp <> Sdractp
     C                   Eval      SelRcd = 'N'
     C                   Endif
     C                   Endif

     C                   If        Scractp <> *Blanks
     C                   If        Cractp <> Scractp
     C                   Eval      SelRcd = 'N'
     C                   Endif
     C                   Endif

     C                   If        Saddded <> *Blanks
     C                   If        Addded <> Saddded
     C                   Eval      SelRcd = 'N'
     C                   Endif
     C                   Endif

     C                   If        Sfxtran <> *Blanks
     C                   If        Fxtran <> Sfxtran
     C                   Eval      SelRcd = 'N'
     C                   Endif
     C                   Endif

     C                   If        Stdctry <> *Blanks
     C                   If        TdCtry <> Stdctry
     C                   Eval      SelRcd = 'N'
     C                   Endif
     C                   Endif

     C                   If        SelRcd = 'Y'
     C                   Eval      Sflrrn = Sflrrn + 1
     C                   Write     FT326S1
     C                   Endif

     C                   Read      FTPYCGV1                               32
     C                   Enddo
      *
      *?Compare SFLRRN with 0 to see if there is anything to display
     C                   If        Sflrrn > 0
     C                   Eval      *in30 = *On
     C                   Else
     C                   Eval      Msgid = 'GEN0001'
     C                   Exsr      SndMsg
     C                   Endif

     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Prc@Sff - Process Subfile                                     *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Prc@Sf        Begsr

      *?Set switch not to reload subfile
     C                   Eval      ReLoad = 'N'

      *
      *?Read subfile for any subfile select records
     C                   Eval      *In33 = *Off
     C                   Readc     FT326S1                                33
     C                   Dow       *In33 = *Off

     C     SflRrn        Chain     FT326S1                            44
     C                   Eval      *In43 = *Off
     C                   Update    FT326S1

     C                   Setoff                                         1012
     C                   Select

      *?Change current record
     C                   When      SflSel = 'A'
     C                   Eval      #Act = 'A'
     C                   Eval      *In49 = *On
     C                   Eval      *In50 = *Off
     C     KeyL0         Chain     FTPYCGV0                           97
     C                   IF        Not *IN97
     C                   Exsr      MovFil2

     C                   Exsr      DtlRcd
     C                   ENDIF

      *?Delete current record
     C                   When      SflSel = 'D'

     C                   Eval      #Act = 'D'
     C                   EVAL      *In48 = *On
     C                   Eval      *In49 = *On
     C                   Eval      *In50 = *On
     C     KeyL0         Chain     FTPYCGV1                           97
     C                   Exsr      MovFil2
     C                   Exsr      DtlRcd
     C                   EVAL      *In48 = *Off

      *
      *?Enquire on current record
     C                   When      SflSel = 'E'
     C                   Eval      #Act = 'E'

     C                   Eval      *In49 = *On
     C                   Eval      *In50 = *On
     C                   EVAL      *In48 = *On
     C     KeyL0         Chain     FTPYCGV1                           97
     C                   Exsr      MovFil2
     C                   Exsr      DtlRcd
     C                   EVAL      *In48 = *Off

      *?If subfile select != A/D or E then Error Message
     C                   Other
     C     SflSel        Ifne      *BLANK
     C                   Eval      *in34 = *On
     C                   Eval      MsgDta = SflSel
     C                   Eval      Msgid = 'FTM1001'
     C                   Exsr      SndMsg
     C                   Eval      *in43 = *On
     C     SflRrn        Chain     FT326S1                            44
     C                   Update    FT326S1
     C                   Endif
      *
     C                   Endsl
      *
     C                   Readc     FT326S1                                33
     C                   Enddo
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * DtlRcd - Process individual record                            *
      *                                                               *
      * Called by: Prc@Sf                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     DtlRcd        Begsr

     C                   Eval      *In10 = *Off
     C                   Eval      *In12 = *Off

     C                   Eval      *In44 = *Off

      *?Loop until some valid action taken
     C                   Dow       Not *IN03 and Not *In10 and Not *In12

     C                   IF        SflSel = 'D'
     C                   Eval      *In44 = *On
     C                   ELSE
     C                   Eval      *In44 = *Off
     C                   Endif

     C                   Write     MsgCtl
     C                   Exfmt     FT326X1

      *?Setof display indicators
     C                   Eval      *In51 = *Off
     C                   Eval      *In52 = *Off
     C                   Eval      *In53 = *Off
     C                   Eval      *In54 = *Off
     C                   Eval      *In55 = *Off
     C                   Eval      *In56 = *Off
     C                   Eval      *In57 = *Off
     C                   Eval      *In58 = *Off
     C                   Eval      *In59 = *Off
     C                   Eval      *In60 = *Off
     C                   Eval      *In61 = *Off
     C                   Eval      *In62 = *Off
     C                   Eval      *In63 = *Off
     C                   Eval      *In64 = *Off
     C                   Eval      *In65 = *Off
     C                   Eval      *In66 = *Off
     C                   Eval      *In67 = *Off
     C                   Eval      *In68 = *Off
     C                   Eval      *In69 = *Off
     C                   Eval      *In70 = *Off
     C                   Eval      *In71 = *Off
     C                   Eval      *In72 = *Off
     C                   Eval      *In73 = *Off
     C                   Eval      *In74 = *Off
     C                   Eval      *In75 = *Off
     C                   Eval      *In76 = *Off

      *?Clear old messages
     C                   CALL      'ZA0250'

     C                   Exsr      Quest_Proc
     C                   If        CodeQuery = 'Y'
     C                   Eval      ValidOK = 'N'
     C                   Else
     C                   Eval      ValidOK = 'Y'
     C                   EndIf

     C                   If        *In09 = *On Or SflSel = 'A'
     C                   If        *In12 = *Off
     C                             and CodeQuery <> 'Y'
     C                   Exsr      Validate
     C                   Else
     C                   Eval      ValidOK = 'N'
     C                   EndIf
     C                   Endif

      *?All*validated OK.**Seton F10 Confirm.********************

     C                   IF        ValidOK = 'Y'

     C                   Select

     C                   When      SflSel = *Blank
     C                   Exsr      MovFil
     C                   Write     FTPYCGD0
     C                   Commit
     C     *Loval        Setll     FTPYCGV0
     C                   Eval      Reload = 'Y'
     C                   EVAL      *In12 = *On

     C                   When      SflSel = 'A'
     C     KeyL0         Chain     FTPYCGV0                           97
     C                   Exsr      MovFil
     C                   Update    FTPYCGD0
     C     *Loval        Setll     FTPYCGV0
     C                   Unlock    FTPYCGV0
     C                   Commit
     C                   Commit
     C     *loval        Setll     FTPYCGV0
     C                   EVAL      *In12 = *On

     C     SflRrn        Chain     FT326S1                            97
     C                   Eval      SflSel = *Blanks
     C                   Exsr      MovFil
     C                   Update    FT326S1


     C                   When      SflSel = 'D' and *IN10 = *On
     C     KeyL0W        Delete    FTPYCGV0                           97
     C                   Eval      Reload = 'Y'
     C                   Eval      SflSel = *Blanks

     C                   Endsl

     C                   Endif

     C                   If        *In12
     C     SflRrn        Chain     FT326S1                            97
     C                   If        SflSel = 'E' or SflSel = 'A'
     C                   Eval      SflSel = *Blank
     C                   Else
     C                   Eval      *In34 = *On
     C                   Eval      SflSel = *Blank
     C                   Endif
     C                   Update    FT326S1
     C                   Endif

     C                   If        *In10
     C                   Leave
     C                   Endif

     C                   Enddo

     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Perform question mark processing                              *
      *                                                               *
      * Called by: Prc@Sf                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Quest_Proc    Begsr

      *? Set up code query variable.

     C                   Move      *Blanks       CodeQuery         1

      *? Transaction type.

     C                   If        WTrntyp <> *Blanks
     C     '?'           Scan      WTrntyp                                96

     C                   If        *In96
     C                   Eval      CodeQuery = 'Y'
     C                   CallB     'FT000970'
     C                   Parm                    WTrnTyp
     C     '?'           Scan      WTrnTyp                                96

     C                   If        *IN96
     C                   Eval      WTrnTyp = *Blanks
     C                   EndIf

     C                   EndIf

     C                   EndIf

      *?Validate Codes.

     C                   If        WSwstch  <> *Blanks
     C                   Eval      PYCHCD   =  WSwstch
     C                   Exsr      Code_Qry
     C                   Eval      WSwstch  =  PYCHCD
     C                   Endif

     C                   If        WSwprch  <> *Blanks
     C                   Eval      PYCHCD   =  WSwprch
     C                   Exsr      Code_Qry
     C                   Eval      WSwprch  =  PYCHCD
     C                   Endif

     C                   If        WMischg  <> *Blanks
     C                   Eval      PYCHCD   =  WMischg
     C                   Exsr      Code_Qry
     C                   Eval      WMischg  =  PYCHCD
     C                   Endif

     C                   If        WCorChg  <> *Blanks
     C                   Eval      PYCHCD   =  WCorChg
     C                   Exsr      Code_Qry
     C                   Eval      WCorChg  =  PYCHCD
     C                   Endif

     C                   If        WChchrg  <> *Blanks
     C                   Eval      PYCHCD   =  WChchrg
     C                   Exsr      Code_Qry
     C                   Eval      WChchrg  =  PYCHCD
     C                   Endif

     C                   If        WMisch1  <> *Blanks
     C                   Eval      PYCHCD   =  WMisch1
     C                   Exsr      Code_Qry
     C                   Eval      WMisch1  =  PYCHCD
     C                   Endif

     C                   If        WFxchcc  <> *Blanks
     C                   Eval      PYCHCD   =  WFxchcc
     C                   Exsr      Code_Qry
     C                   Eval      WFxchcc  =  PYCHCD
     C                   Endif

     C                   If        WTxchcd  <> *Blanks
     C                   Eval      PYCHCD   =  WTxchcd
     C                   Exsr      Code_Qry
     C                   Eval      WTxchcd  =  PYCHCD
     C                   Endif

     C                   If        WMisch2  <> *Blanks
     C                   Eval      PYCHCD   =  WMisch2
     C                   Exsr      Code_Qry
     C                   Eval      WMisch2  =  PYCHCD
     C                   Endif

     C                   If        WCabchc  <> *Blanks
     C                   Eval      PYCHCD   =  WCabchc
     C                   Exsr      Code_Qry
     C                   Eval      WCabchc  =  PYCHCD
     C                   Endif

     C                   If        WAdvchg  <> *Blanks
     C                   Eval      PYCHCD   =  WAdvchg
     C                   Exsr      Code_Qry
     C                   Eval      WAdvchg  =  PYCHCD
     C                   Endif

     C                   If        WMisch3  <> *Blanks
     C                   Eval      PYCHCD   =  WMisch3
     C                   Exsr      Code_Qry
     C                   Eval      WMisch3  =  PYCHCD
     C                   Endif

     C                   If        WTrcmch  <> *Blanks
     C                   Eval      PYCHCD   =  WTrcmch
     C                   Exsr      Code_Qry
     C                   Eval      WTrcmch  =  PYCHCD
     C                   Endif

     C                   If        WTelchg  <> *Blanks
     C                   Eval      PYCHCD   =  WTelchg
     C                   Exsr      Code_Qry
     C                   Eval      WTelchg  =  PYCHCD
     C                   Endif

     C                   If        WMisch4  <> *Blanks
     C                   Eval      PYCHCD   =  WMisch4
     C                   Exsr      Code_Qry
     C                   Eval      WMisch4  =  PYCHCD
     C                   Endif

     C                   If        WColchg  <> *Blanks
     C                   Eval      PYCHCD   =  WColchg
     C                   Exsr      Code_Qry
     C                   Eval      WColchg  =  PYCHCD
     C                   Endif

     C                   If        WMisch5  <> *Blanks
     C                   Eval      PYCHCD   =  WMisch5
     C                   Exsr      Code_Qry
     C                   Eval      WMisch5  =  PYCHCD
     C                   Endif

     C                   If        WDedchg  <> *Blanks
     C                   Eval      PYCHCD   =  WDedchg
     C                   Exsr      Code_Qry
     C                   Eval      WDedchg  =  PYCHCD
     C                   Endif

      *?Other codes (FX Spread Set)
     C                   If        WFxspst  <> *Blanks
     C                   Eval      SPRCOD   =  WFxspst
     C                   Exsr      Qry_Spread
     C                   Eval      WFxspst  =  SPRCOD
     C                   Endif

      *?Other codes (Payment Date Offset)
     C                   If        WPdofcd  <> *Blanks
     C                   Eval      PYDTOC   =  WPdofcd
     C                   Exsr      Qry_Offset
     C                   Eval      WPdofcd  =  PYDTOC
     C                   Endif

     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Validate Data Items                                           *
      *                                                               *
      * Called by: Prc@Sf                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Validate      Begsr

      *?Validate Branch
     C                   Select
      *?Branch code cannot be blanks
     C                   When      WBranch = *Blanks
      ******
     c******             Eval      Msgid = 'FTF3139'
     C******             Eval      *in51 = *On
     C******             Eval      ValidOK = 'N'
     C******             Exsr      SndMsg
      ******

     C                   Other

      *?Branch code must valid
     C                   CallB     'AOBRCHR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm                    WBranch
     C                   Parm                    DSFDY

     C                   If        @Rtcd <> *Blanks
     C                   Eval      Msgid   = 'FTF3140'
     C                   Eval      MsgDta  = WBranch
     C                   Eval      *in51   = *On
     C                   Eval      ValidOK = 'N'
     C                   Exsr      SndMsg
     C                   Endif

     C                   Endsl

      *?Validate Customer.  If entered, it must contain either a valid customer
      *? number or customer shortname.
     C                   Select
     C                   When      WCustom <> *Blanks

     C                   CallB     'AOCUSTR0'
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*KEY   '     @Optn
     C                   Parm                    WCustom
     C                   Parm      *Blanks       #KYST
     C     SDCUST        Parm      *Blanks       DSSDY

      * Database error ?
     C                   If        @Rtcd <> *Blanks
     C                   Eval      Msgid   = 'FTF3141'
     C                   Eval      MsgDta  = WCustom
     C                   Eval      *in52   = *On
     C                   Eval      ValidOK = 'N'
     C                   Exsr      SndMsg

     C                   Else
     C                   Eval      WCustom = BBCUST
     C                   Endif

     C                   Endsl

      *?Validate transaction type.
      *? This is an optional field.  If entered, the transaction type must exist
      *?  on the transaction type table.
     C                   Select
     C                   When      WTrntyp <> *Blanks

     C     '?'           Scan      WTrntyp                                96
     C                   If        *In96
     C                   CallB     'FT000970'
     C                   Parm                    WTrnTyp
     C                   Else
     C     WTrntyp       Chain     FTTRNTL0                           97
     C                   If        *In97
     C                   Eval      Msgid   = 'FTM3142'
     C                   Eval      MsgDta  = WTrntyp
     C                   Eval      *in53   = *On
     C                   Eval      ValidOK = 'N'
     C                   Exsr      SndMsg
     C                   Endif
     C                   Endif

     C                   Endsl

      *?Validate transaction sub-type.
      *? This is an optional field. If entered, this field must be a valid deal
      *?  sub-type and may only be entered if the transaction type has been entered,
      *?  otherwise it is prohibited.
      *?  If the transaction sub-type has been entered, ensure that the combination of
      *?  transaction type and transaction sub-type is a valid entry on FDDTSTL1.

     C                   Select
     C                   When      WTrsbty <> *Blanks

     C                   CallB     'AODLSTR0'
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*KEY   '     @Optn
     C                   Parm                    WTrsbty
     C                   Parm      *Blanks       Dsfdy

     C                   If        @Rtcd <> *Blanks
     C                   Eval      Msgid   = 'FTF3143'
     C                   Eval      MsgDta  = WTrsbty
     C                   Eval      *in54   = *On
     C                   Eval      ValidOK = 'N'
     C                   Exsr      SndMsg
     C                   Endif

     C                   If        WTrntyp = *Blanks
     C                   Eval      Msgid   = 'FTF3144'
     C                   Eval      *in54   = *On
     C                   Eval      ValidOK = 'N'
     C                   Exsr      SndMsg
     C                   Endif

     C     KeyDeal       Chain     FDDTSTL1                           97
     C                   If        *In97
     C                   Eval      Msgid   = 'FTF3145'
     C                   Eval      MsgDta  = WTrntyp
     C                   Eval      *in54   = *On
     C                   Eval      ValidOK = 'N'
     C                   Exsr      SndMsg
     C                   Endif

     C                   Endsl

      *?Validate Customer grouping code.
      *? This is an optional field.  If entered it must be a valid customer grouping code.
      *? Group set code must be '1'.

     C                   Select
     C                   When      WCsgrcd <> *Blanks
      *
     C                   Eval      D6SNBR = '1'
     C     KeyGroup      Chain     SDCGRPL0                           97
     C                   If        *In97
     C                   Eval      D6SNBR = '*'
     C     KeyGroup      Chain     SDCGRPL0                           97
     C                   If        *In97
     C                   Eval      Msgid   = 'FTF3146'
     C                   Eval      MsgDta  = WCsgrcd
     C                   Eval      *in55   = *On
     C                   Eval      ValidOK = 'N'
     C                   Exsr      SndMsg
     C                   Endif
     C                   Endif

     C                   Endsl

      *?Validate Urgent Indicator.                                                            URGIND
     C                   Select                                                               URGIND
     C                   When          (WUrgFlg <> 'N') And (WUrgFlg <> 'U')                  URGIND
     C                             And (WUrgFlg <> *Blanks)                                   URGIND
     C                   Eval      Msgid   = 'FTF3287'                                        URGIND
     C                   Eval      MsgDta  = WUrgFlg                                          URGIND
     C                   Eval      *in78   = *On                                              URGIND
     C                   Eval      ValidOK = 'N'                                              URGIND
     C                   Exsr      SndMsg                                                     URGIND
     C                   Endsl                                                                URGIND
      *?Validate Description. Mandatory
     C                   Select
     C                   When      WPdescr = *Blanks
     C                   Eval      Msgid   = 'FTF3147'
     C                   Eval      MsgDta  = WTrntyp
     C                   Eval      *in57   = *On
     C                   Eval      ValidOK = 'N'
     C                   Exsr      SndMsg
     C                   Endsl

      *?Validate Currency.  This is an optional field.  If entered it must be
      *? a valid currency code.
     C                   Select
     C                   When      WCurrcy <> *Blanks
      *
     C                   CALL      'AOCURRR0'
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*KEY   '     @Optn
     C                   Parm                    WCurrcy
     C     SDCURR        Parm      SDCURR        DSSDY

     C                   If        @Rtcd <> *Blanks
     C                   Eval      Msgid   = 'FTF3148'
     C                   Eval      MsgDta  = WCurrcy
     C                   Eval      *in56   = *On
     C                   Eval      ValidOK = 'N'
     C                   Exsr      SndMsg
     C                   Endif

     C                   Endsl

      *?Validate Network.  This is an optional field.  If entered it must be
      *? a valid Network code.
     C                   Select
     C                   When      WNetwrk <> *Blanks
      *
     C                   CALL      'AONWRKR0'
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*KEY   '     @Optn
     C                   Parm      Wnetwrk       PNetwrk           6
     C     SDNWRK        Parm      *blanks       DSSDY

     C     '?'           Scan      WNetwrk
     C                   Select
     C                   When      %Found
     C                   If        EDNWRK <> *blanks
     C                   Eval      WNetwrk = EDNWRK
     C                   Endif
     C                   Eval      ValidOK = 'N'
     C                   When      @Rtcd <> *Blanks
     C                   Eval      SvMsgf = Msgf
     C                   Eval      Msgf    = 'XXUSRMSG'
     C                   Eval      Msgid   = 'PLN0037'
     C                   Eval      MsgDta  = WNetwrk
     C                   Eval      *in81   = *On
     C                   Eval      ValidOK = 'N'
     C                   Exsr      SndMsg
     C                   Eval      Msgf = SvMsgf
     C                   Endsl

     C                   Endsl

      *?Validate Msg Types.  This is an optional field.  If entered it must be
      *? a valid Msg Type.
     C                   Select
     C                   When      WMsgtyp <> *Blanks
      *
     C                   CALL      'AOMTPYR0'
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*KEY   '     @Optn
     C                   Parm      WMsgtyp       PMsgtyp           3
     C     SDMTPY        Parm      *blanks       DSSDY

     C     '?'           Scan      WMsgtyp
     C                   Select
     C                   When      %Found
     C                   If        EEMTPY <> *blanks
     C                   Eval      WMsgtyp = EEMTPY
     C                   Endif
     C                   Eval      ValidOK = 'N'
     C                   When      @Rtcd <> *Blanks
     C                   Eval      SvMsgf = Msgf
     C                   Eval      Msgf    = 'XXUSRMSG'
     C                   Eval      Msgid   = 'PLN0038'
     C                   Eval      MsgDta  = WMsgtyp
     C                   Eval      *in82   = *On
     C                   Eval      ValidOK = 'N'
     C                   Exsr      SndMsg
     C                   Eval      Msgf = SvMsgf
     C                   Endsl

     C                   Endsl

      *?Validate FX Transaction indicator
     C                   Select
     C                   When      WFxtran = *Blanks
     C                   When      WFxtran <> 'Y' and WFxtran <> 'N'
     C                   Movel     *blanks       SvMsgf           10
     C                   Eval      SvMsgf = Msgf
     C                   Eval      Msgf    = 'XXUSRMSG'
     C                   Eval      Msgid   = 'PLN0034'
     C                   Eval      MsgDta  = WFxtran
     C                   Eval      *in88   = *On
     C                   Eval      ValidOK = 'N'
     C                   Exsr      SndMsg
     C                   Eval      Msgf = SvMsgf
     C                   Endsl
                                                                                              URGIND
      *?Validate Urgent Flag                                                                  URGIND
     C                   Select                                                               URGIND
     C                   When      WUrgFlg = *Blanks                                          URGIND
     C                   When      WUrgFlg <> 'U' and WUrgFlg <> 'N'                          URGIND
     C                   Movel     *blanks       SvMsgf           10                          URGIND
     C                   Eval      SvMsgf = Msgf                                              URGIND
     C                   Eval      Msgf    = 'XXUSRMSG'                                       URGIND
     C                   Eval      Msgid   = 'FTF3287'                                        URGIND
     C                   Eval      MsgDta  = WUrgFlg                                          URGIND
     C                   Eval      *in89   = *On                                              URGIND
     C                   Eval      ValidOK = 'N'                                              URGIND
     C                   Exsr      SndMsg                                                     URGIND
     C                   Eval      Msgf = SvMsgf                                              URGIND
     C                   Endsl                                                                URGIND

      *?Validate FX Transaction indicator
     C                   Select
     C                   When      WTdCtry = *Blanks
      *******            When      WTdCtry <> 'F ' and WTdCtry <> 'PL'          STP001
     C                   When      WTdCtry <> 'F ' and WTdCtry <> 'PL'          STP001
     C                             and WTdCtry <> 'N '
     C                   Movel     *blanks       SvMsgf           10
     C                   Eval      SvMsgf = Msgf
     C                   Eval      Msgf    = 'XXUSRMSG'
     C                   Eval      Msgid   = 'PLN0019'
     C                   Eval      MsgDta  = WTdCtry
     C                   Eval      *in88   = *On
     C                   Eval      ValidOK = 'N'
     C                   Exsr      SndMsg
     C                   Eval      Msgf = SvMsgf
     C                   Endsl

      *?Validate Credit Account indicator
     C                   Select
     C                   When      WCractp = *Blanks
     C                   When      WCractp <> *blanks
     C     WCractp       Chain     @STATV0
     C                   If        Not %Found
     C                   Eval      SvMsgf = Msgf
     C                   Eval      Msgf    = 'XXUSRMSG'
     C                   Eval      Msgid   = 'PLN0033'
     C                   Eval      MsgDta  = WCractp
     C                   Eval      *in87   = *On
     C                   Eval      ValidOK = 'N'
     C                   Exsr      SndMsg
     C                   Eval      Msgf = SvMsgf
     C                   Endif
     C                   Endsl

      *?Validate Debit Account indicator
     C                   Select
     C                   When      WDractp = *Blanks
     C                   When      WDractp <> *blanks
     C     WDractp       Chain     @STATV0
     C                   If        Not %Found
     C                   Eval      SvMsgf = Msgf
     C                   Eval      Msgf    = 'XXUSRMSG'
     C                   Eval      Msgid   = 'PLN0033'
     C                   Eval      MsgDta  = WDractp
     C                   Eval      *in86   = *On
     C                   Eval      ValidOK = 'N'
     C                   Exsr      SndMsg
     C                   Eval      Msgf = SvMsgf
     C                   Endif
     C                   Endsl

      *?Validate Add/Deduct indicator
     C                   Select
     C                   When      WAddded = *Blanks
     C                   When      WAddded <> 'A' and WAddded <> 'D'
     C                   Eval      SvMsgf = Msgf
     C                   Eval      Msgf    = 'XXUSRMSG'
     C                   Eval      Msgid   = 'PLN0035'
     C                   Eval      MsgDta  = WAddded
     C                   Eval      *in85   = *On
     C                   Eval      ValidOK = 'N'
     C                   Exsr      SndMsg
     C                   Eval      Msgf = SvMsgf
     C                   Endsl

      *?Validate Settlement method indicator
     C                   Select
     C                   When      WStmtmd = *Blanks
     C                   When      WStmtmd <> '00' and
     C                             WStmtmd <> '01' and
     C                             WStmtmd <> '02' and
     C                             WStmtmd <> '08' and
     C                             WStmtmd <> '10' and
     C                             WStmtmd <> '12' and
     C                             WStmtmd <> '13' and
     C                             WStmtmd <> '14' and
     C                             WStmtmd <> 'EX' and
     C                             WStmtmd <> 'BA' and
     C                             WStmtmd <> 'EC' and                                        STP009
     C                             WStmtmd <> 'ZC' and                                        STP009
     C                             WStmtmd <> 'TP' and                                        STP009
     C                             WStmtmd <> 'PL' and
     C                             WStmtmd <> 'EB' and
     C                             WStmtmd <> 'ER' and                                        STP009
     C                             WStmtmd <> 'EL' and                                        STP009
     C                             WStmtmd <> 'ES' and                                        STP009
     C                             WStmtmd <> 'EK' and                                        STP009
     C                             WStmtmd <> 'PS' and                                        STP009
     C                             WStmtmd <> 'PB' and                                        STP009
     C                             WStmtmd <> 'MC'
     C                   Eval      SvMsgf = Msgf
     C                   Eval      Msgf    = 'XXUSRMSG'
     C                   Eval      Msgid   = 'PLN0036'
     C                   Eval      MsgDta  = WStmtmd
     C                   Eval      *in84   = *On
     C                   Eval      ValidOK = 'N'
     C                   Exsr      SndMsg
     C                   Eval      Msgf = SvMsgf
     C                   Endsl

      *?Ensure that the data entered is unique.  Required only on insert
     C                   If        *In09
     C     KeyL0W        Setll     FTPYCGV1                               96
     C                   If        *In96
     C                   Eval      Msgid    = 'FTF3150'
     C                   Eval      *in51    = *On
     C                   Eval      *in52    = *On
     C                   Eval      *in53    = *On
     C                   Eval      *in54    = *On
     C                   Eval      *in55    = *On
     C                   Eval      *in56    = *On
     C                   Eval      *in57    = *On
     C                   Eval      *in81    = *On
     C                   Eval      *in82    = *On
     C                   Eval      *in83    = *On
     C                   Eval      *in84    = *On
     C                   Eval      *in85    = *On
     C                   Eval      *in86    = *On
     C                   Eval      *in87    = *On
     C                   Eval      *in88    = *On
     C                   Eval      *in89    = *On                                             URGIND
     C                   Eval      ValidOK  = 'N'
     C                   Exsr      SndMsg
     C                   Endif
     C                   Endif

      *?Validate Codes.  Must exist on the payment code file.

     C                   If        WSwstch  <> *Blanks
     C                   Eval      PYCHCD   =  WSwstch
     C                   Exsr      Get_PayCode
     C                   Eval      WSwstch  =  PYCHCD
     C                   If        Inv_Code = 'Y'
     C                   Eval      Msgid    = 'FTF3149'
     C                   Eval      MsgDta   = WSwstch
     C                   Eval      *in59    = *On
     C                   Eval      ValidOK  = 'N'
     C                   Exsr      SndMsg
     C                   Endif
     C                   Endif

     C                   If        WSwprch  <> *Blanks
     C                   Eval      PYCHCD   =  WSwprch
     C                   Exsr      Get_PayCode
     C                   Eval      WSwprch  =  PYCHCD
     C                   If        Inv_Code = 'Y'
     C                   Eval      Msgid    = 'FTF3149'
     C                   Eval      MsgDta   = WSwprch
     C                   Eval      *in60    = *On
     C                   Eval      ValidOK  = 'N'
     C                   Exsr      SndMsg
     C                   Endif
     C                   Endif

     C                   If        WMischg  <> *Blanks
     C                   Eval      PYCHCD   =  WMischg
     C                   Exsr      Get_PayCode
     C                   Eval      WMischg  =  PYCHCD
     C                   If        Inv_Code = 'Y'
     C                   Eval      Msgid    = 'FTF3149'
     C                   Eval      MsgDta   = WMischg
     C                   Eval      *in61    = *On
     C                   Eval      ValidOK  = 'N'
     C                   Exsr      SndMsg
     C                   Endif
     C                   Endif

     C                   If        WCorChg  <> *Blanks
     C                   Eval      PYCHCD   =  WCorChg
     C                   Exsr      Get_PayCode
     C                   Eval      WCorChg  =  PYCHCD
     C                   If        Inv_Code = 'Y'
     C                   Eval      Msgid    = 'FTF3149'
     C                   Eval      MsgDta   = WCorChg
     C                   Eval      *in62    = *On
     C                   Eval      ValidOK  = 'N'
     C                   Exsr      SndMsg
     C                   Endif
     C                   Endif

     C                   If        WChchrg  <> *Blanks
     C                   Eval      PYCHCD   =  WChchrg
     C                   Exsr      Get_PayCode
     C                   Eval      WChchrg  =  PYCHCD
     C                   If        Inv_Code = 'Y'
     C                   Eval      Msgid    = 'FTF3149'
     C                   Eval      MsgDta   = WChchrg
     C                   Eval      *in63    = *On
     C                   Eval      ValidOK  = 'N'
     C                   Exsr      SndMsg
     C                   Endif
     C                   Endif

     C                   If        WMisch1  <> *Blanks
     C                   Eval      PYCHCD   =  WMisch1
     C                   Exsr      Get_PayCode
     C                   Eval      WMisch1  =  PYCHCD
     C                   If        Inv_Code = 'Y'
     C                   Eval      Msgid    = 'FTF3149'
     C                   Eval      MsgDta   = WMisch1
     C                   Eval      *in64    = *On
     C                   Eval      ValidOK  = 'N'
     C                   Exsr      SndMsg
     C                   Endif
     C                   Endif

     C                   If        WFxchcc  <> *Blanks
     C                   Eval      PYCHCD   =  WFxchcc
     C                   Exsr      Get_PayCode
     C                   Eval      WFxchcc  =  PYCHCD
     C                   If        Inv_Code = 'Y'
     C                   Eval      Msgid    = 'FTF3149'
     C                   Eval      MsgDta   = WFxchcc
     C                   Eval      *in65    = *On
     C                   Eval      ValidOK  = 'N'
     C                   Exsr      SndMsg
     C                   Endif
     C                   Endif

     C                   If        WTxchcd  <> *Blanks
     C                   Eval      PYCHCD   =  WTxchcd
     C                   Exsr      Get_PayCode
     C                   Eval      WTxchcd  =  PYCHCD
     C                   If        Inv_Code = 'Y'
     C                   Eval      Msgid    = 'FTF3149'
     C                   Eval      MsgDta   = WTxchcd
     C                   Eval      *in66    = *On
     C                   Eval      ValidOK  = 'N'
     C                   Exsr      SndMsg
     C                   Endif
     C                   Endif

     C                   If        WMisch2  <> *Blanks
     C                   Eval      PYCHCD   =  WMisch2
     C                   Exsr      Get_PayCode
     C                   Eval      WMisch2  =  PYCHCD
     C                   If        Inv_Code = 'Y'
     C                   Eval      Msgid    = 'FTF3149'
     C                   Eval      MsgDta   = WMisch2
     C                   Eval      *in67    = *On
     C                   Eval      ValidOK  = 'N'
     C                   Exsr      SndMsg
     C                   Endif
     C                   Endif

     C                   If        WCabchc  <> *Blanks
     C                   Eval      PYCHCD   =  WCabchc
     C                   Exsr      Get_PayCode
     C                   Eval      WCabchc  =  PYCHCD
     C                   If        Inv_Code = 'Y'
     C                   Eval      Msgid    = 'FTF3149'
     C                   Eval      MsgDta   = WCabchc
     C                   Eval      *in68    = *On
     C                   Eval      ValidOK  = 'N'
     C                   Exsr      SndMsg
     C                   Endif
     C                   Endif

     C                   If        WAdvchg  <> *Blanks
     C                   Eval      PYCHCD   =  WAdvchg
     C                   Exsr      Get_PayCode
     C                   Eval      WAdvchg  =  PYCHCD
     C                   If        Inv_Code = 'Y'
     C                   Eval      Msgid    = 'FTF3149'
     C                   Eval      MsgDta   = WAdvchg
     C                   Eval      *in69    = *On
     C                   Eval      ValidOK  = 'N'
     C                   Exsr      SndMsg
     C                   Endif
     C                   Endif

     C                   If        WMisch3  <> *Blanks
     C                   Eval      PYCHCD   =  WMisch3
     C                   Exsr      Get_PayCode
     C                   Eval      WMisch3  =  PYCHCD
     C                   If        Inv_Code = 'Y'
     C                   Eval      Msgid    = 'FTF3149'
     C                   Eval      MsgDta   = WMisch3
     C                   Eval      *in70    = *On
     C                   Eval      ValidOK  = 'N'
     C                   Exsr      SndMsg
     C                   Endif
     C                   Endif

     C                   If        WTrcmch  <> *Blanks
     C                   Eval      PYCHCD   =  WTrcmch
     C                   Exsr      Get_PayCode
     C                   Eval      WTrcmch  =  PYCHCD
     C                   If        Inv_Code = 'Y'
     C                   Eval      Msgid    = 'FTF3149'
     C                   Eval      MsgDta   = WTrcmch
     C                   Eval      *in71    = *On
     C                   Eval      ValidOK  = 'N'
     C                   Exsr      SndMsg
     C                   Endif
     C                   Endif

     C                   If        WTelchg  <> *Blanks
     C                   Eval      PYCHCD   =  WTelchg
     C                   Exsr      Get_PayCode
     C                   Eval      WTelchg  =  PYCHCD
     C                   If        Inv_Code = 'Y'
     C                   Eval      Msgid    = 'FTF3149'
     C                   Eval      MsgDta   = WTelchg
     C                   Eval      *in72    = *On
     C                   Eval      ValidOK  = 'N'
     C                   Exsr      SndMsg
     C                   Endif
     C                   Endif

     C                   If        WMisch4  <> *Blanks
     C                   Eval      PYCHCD   =  WMisch4
     C                   Exsr      Get_PayCode
     C                   Eval      WMisch4  =  PYCHCD
     C                   If        Inv_Code = 'Y'
     C                   Eval      Msgid    = 'FTF3149'
     C                   Eval      MsgDta   = WMisch4
     C                   Eval      *in73    = *On
     C                   Eval      ValidOK  = 'N'
     C                   Exsr      SndMsg
     C                   Endif
     C                   Endif

     C                   If        WColchg  <> *Blanks
     C                   Eval      PYCHCD   =  WColchg
     C                   Exsr      Get_PayCode
     C                   Eval      WColchg  =  PYCHCD
     C                   If        Inv_Code = 'Y'
     C                   Eval      Msgid    = 'FTF3149'
     C                   Eval      MsgDta   = WColchg
     C                   Eval      *in74    = *On
     C                   Eval      ValidOK  = 'N'
     C                   Exsr      SndMsg
     C                   Endif
     C                   Endif

     C                   If        WMisch5  <> *Blanks
     C                   Eval      PYCHCD   =  WMisch5
     C                   Exsr      Get_PayCode
     C                   Eval      WMisch5  =  PYCHCD
     C                   If        Inv_Code = 'Y'
     C                   Eval      Msgid    = 'FTF3149'
     C                   Eval      MsgDta   = WMisch5
     C                   Eval      *in76    = *On
     C                   Eval      ValidOK  = 'N'
     C                   Exsr      SndMsg
     C                   Endif
     C                   Endif

     C                   If        WDedchg  <> *Blanks
     C                   Eval      PYCHCD   =  WDedchg
     C                   Exsr      Get_PayCode
     C                   Eval      WDedchg  =  PYCHCD
     C                   If        Inv_Code = 'Y'
     C                   Eval      Msgid    = 'FTF3149'
     C                   Eval      MsgDta   = WDedchg
     C                   Eval      *in77    = *On
     C                   Eval      ValidOK  = 'N'
     C                   Exsr      SndMsg
     C                   Endif
     C                   Endif

      *?Other codes (FX Spread Set)
     C                   If        WFxspst  <> *Blanks
     C                   Eval      SPRCOD   =  WFxspst
     C                   Exsr      Get_Spread
     C                   Eval      WFxspst  =  SPRCOD
     C                   If        Inv_Code = 'Y'
     C                   Eval      Msgid    = 'FTF3152'
     C                   Eval      MsgDta   = WFxspst
     C                   Eval      *in75    = *On
     C                   Eval      ValidOK  = 'N'
     C                   Exsr      SndMsg
     C                   Endif
     C                   Endif

      *?Other codes (Payment Date Offset)
     C                   If        WPdofcd  <> *Blanks
     C                   Eval      PYDTOC   =  WPdofcd
     C                   Exsr      Get_Offset
     C                   Eval      WPdofcd  =  PYDTOC
     C                   If        Inv_Code = 'Y'
     C                   Eval      Msgid    = 'FTF3153'
     C                   Eval      MsgDta   = WPdofcd
     C                   Eval      *in58    = *On
     C                   Eval      ValidOK  = 'N'
     C                   Exsr      SndMsg
     C                   Endif
     C                   Endif

      *?Customer group codes and customer details are mutually exclusive
     C                   If        WCsgrcd <> *Blanks and
     C                             WCustom <> *Blanks
     C                   Eval      Msgid    = 'FTF3216'
     C                   Eval      *in52   = *On
     C                   Eval      *in55   = *On
     C                   Eval      ValidOK  = 'N'
     C                   Exsr      SndMsg
     C                   Endif

      *?Ensure that the data entered will form a valid combination
      *
     C                   Do        SearchNbr     Idx
     C                   Clear                   KeySV
     C                   Eval      KeysComb = 'Y'
     C                   Movea     Search#(Idx)  KeySV(1)
      * If branch then must be entered
     C                   If        KeySV(1) = 'Y' and Wbranch = *blanks
     C                   Eval      KeysComb = 'N'
     C                   Endif
      * If not branch then must not be entered
     C                   If        KeySV(1) = 'N' and Wbranch <> *blanks
     C                   Eval      KeysComb = 'N'
     C                   Endif
      * If Customer then must be entered
     C                   If        KeySV(2) = 'Y' and Wcustom = *blanks
     C                   Eval      KeysComb = 'N'
     C                   Endif
      * If not customer then must not be entered
     C                   If        KeySV(2) = 'N' and Wcustom <> *blanks
     C                   Eval      KeysComb = 'N'
     C                   Endif
      * If currency then must be entered
     C                   If        KeySV(3) = 'Y' and Wcurrcy = *blanks
     C                   Eval      KeysComb = 'N'
     C                   Endif
      * If not currency then must not be entered
     C                   If        KeySV(3) = 'N' and Wcurrcy <> *blanks
     C                   Eval      KeysComb = 'N'
     C                   Endif
      * If transaction type then must be entered
     C                   If        KeySV(4) = 'Y' and Wtrntyp = *blanks
     C                   Eval      KeysComb = 'N'
     C                   Endif
      * If not transaction type then must not be entered
     C                   If        KeySV(4) = 'N' and Wtrntyp <> *blanks
     C                   Eval      KeysComb = 'N'
     C                   Endif
      * If transaction sub-type then must be entered
     C                   If        KeySV(5) = 'Y' and Wtrsbty = *blanks
     C                   Eval      KeysComb = 'N'
     C                   Endif
      * If not transaction sub-type then must not be entered
     C                   If        KeySV(5) = 'N' and Wtrsbty <> *blanks
     C                   Eval      KeysComb = 'N'
     C                   Endif
      * If customer group then must be entered
     C                   If        KeySV(6) = 'Y' and Wcsgrcd = *blanks
     C                   Eval      KeysComb = 'N'
     C                   Endif
      * If not customer group when must not be entered
     C                   If        KeySV(6) = 'N' and Wcsgrcd <> *blanks
     C                   Eval      KeysComb = 'N'
     C                   Endif
      * If network then must be entered
     C                   If        KeySV(7) = 'Y' and Wnetwrk = *blanks
     C                   Eval      KeysComb = 'N'
     C                   Endif
      * If not network then must not be entered
     C                   If        KeySV(7) = 'N' and Wnetwrk <> *blanks
     C                   Eval      KeysComb = 'N'
     C                   Endif
      * If pay type then must be entered
     C                   If        KeySV(8) = 'Y' and Wpaytyp = *blanks
     C                   Eval      KeysComb = 'N'
     C                   Endif
      * If not pay type then must not be entered
     C                   If        KeySV(8) = 'N' and Wpaytyp <> *blanks
     C                   Eval      KeysComb = 'N'
     C                   Endif
      * If message type then must be entered
     C                   If        KeySV(9) = 'Y' and Wmsgtyp = *blanks
     C                   Eval      KeysComb = 'N'
     C                   Endif
      * If not message type then must not be entered
     C                   If        KeySV(9) = 'N' and Wmsgtyp <> *blanks
     C                   Eval      KeysComb = 'N'
     C                   Endif
      * If settlement method then must be entered
     C                   If        KeySV(10) = 'Y' and Wstmtmd = *blanks
     C                   Eval      KeysComb = 'N'
     C                   Endif
      * If not settlement method then must not be entered
     C                   If        KeySV(10) = 'N' and Wstmtmd <> *blanks
     C                   Eval      KeysComb = 'N'
     C                   Endif
      * If debit account type then must be entered
     C                   If        KeySV(11) = 'Y' and Wdractp = *blanks
     C                   Eval      KeysComb = 'N'
     C                   Endif
      * If not debit account type then must not be entered
     C                   If        KeySV(11) = 'N' and Wdractp <> *blanks
     C                   Eval      KeysComb = 'N'
     C                   Endif
      * If credit account type then must be entered
     C                   If        KeySV(12) = 'Y' and Wcractp = *blanks
     C                   Eval      KeysComb = 'N'
     C                   Endif
      * If not credit account type then must not be entered
     C                   If        KeySV(12) = 'N' and Wcractp <> *blanks
     C                   Eval      KeysComb = 'N'
     C                   Endif
      * If add/deduct then must be entered
     C                   If        KeySV(13) = 'Y' and Waddded = *blanks
     C                   Eval      KeysComb = 'N'
     C                   Endif
      * If not Add/deduct then must not be entered
     C                   If        KeySV(13) = 'N' and Waddded <> *blanks
     C                   Eval      KeysComb = 'N'
     C                   Endif
      * If Fx Trade then must be entered
     C                   If        KeySV(14) = 'Y' and Wfxtran = *blanks
     C                   Eval      KeysComb = 'N'
     C                   Endif
      * If not FX Trade then must not be entered
     C                   If        KeySV(14) = 'N' and Wfxtran <> *blanks
     C                   Eval      KeysComb = 'N'
     C                   Endif
      * If Transation destination is entered
     C                   If        KeySV(15) = 'Y' and Wtdctry = *blanks
     C                   Eval      KeysComb = 'N'
     C                   Endif
      * If not Transaction and destination
     C                   If        KeySV(15) = 'N' and Wtdctry <> *blanks
     C                   Eval      KeysComb = 'N'
     C                   Endif
      * If Urgent Flag then must be entered                                                   URGIND
     C                   If        KeySV(16) = 'Y' and WUrgFlg = *blanks                      URGIND
     C                   Eval      KeysComb = 'N'                                             URGIND
     C                   Endif                                                                URGIND
      * If not Urgent Flag then must not be entered                                           URGIND
     C                   If        KeySV(16) = 'N' and WUrgFlg <> *blanks                     URGIND
     C                   Eval      KeysComb = 'N'                                             URGIND
     C                   Endif                                                                URGIND
      *
      * If valid combination exit
     C                   If        KeysComb = 'Y'
     C                   Leave
     C                   Endif
     C                   Enddo
      * Test for invalid combination
     C                   If        KeysComb <> 'Y'
     C                   Eval      *in51    = *On
     C                   Eval      *in52    = *On
     C                   Eval      *in53    = *On
     C                   Eval      *in54    = *On
     C                   Eval      *in55    = *On
     C                   Eval      *in56    = *On
     C                   Eval      *in57    = *On
     C                   Eval      *in81    = *On
     C                   Eval      *in82    = *On
     C                   Eval      *in83    = *On
     C                   Eval      *in84    = *On
     C                   Eval      *in85    = *On
     C                   Eval      *in86    = *On
     C                   Eval      *in87    = *On
     C                   Eval      *in88    = *On
     C                   Eval      *in89    = *On                                             URGIND
     C                   Eval      Msgid    = 'FTF3218'
     C                   Eval      ValidOK  = 'N'
     C                   Exsr      SndMsg
     C                   Endif



     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Clear Screen Date                                             *
      *                                                               *
      * Called by: Prc@Sf                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Clr_Dta       Begsr

     C                   Eval      WBranch = *Blanks
     C                   Eval      WCustom = *Blanks
     C                   Eval      WTrnTyp = *Blanks
     C                   Eval      WTrsBty = *Blanks
     C                   Eval      WCsgRcd = *Blanks
     C                   Eval      WCurRcy = *Blanks
     C                   Eval      WNetwrk = *Blanks
     C                   Eval      WMsgtyp = *Blanks
     C                   Eval      WPaytyp = *Blanks
     C                   Eval      WStmtmd = *Blanks
     C                   Eval      WDractp = *Blanks
     C                   Eval      WCractp = *Blanks
     C                   Eval      WAddded = *Blanks
     C                   Eval      WFxtran = *Blanks
     C                   Eval      WTdCtry = *Blanks
     C                   Eval      WPdescr = *Blanks
     C                   Eval      WPdoFcd = *Blanks
     C                   Eval      WSwsTch = *Blanks
     C                   Eval      WSwpRch = *Blanks
     C                   Eval      WMisChg = *Blanks
     C                   Eval      WCorChg = *Blanks
     C                   Eval      WChcHrg = *Blanks
     C                   Eval      WMisCh1 = *Blanks
     C                   Eval      WFxcHcc = *Blanks
     C                   Eval      WTxcHcd = *Blanks
     C                   Eval      WMisCh2 = *Blanks
     C                   Eval      WCabChc = *Blanks
     C                   Eval      WAdvChg = *Blanks
     C                   Eval      WMisCh3 = *Blanks
     C                   Eval      WTrcMch = *Blanks
     C                   Eval      WTelChg = *Blanks
     C                   Eval      WMisCh4 = *Blanks
     C                   Eval      WColChg = *Blanks
     C                   Eval      WFxsPst = *Blanks
     C                   Eval      WMisCh5 = *Blanks
     C                   Eval      WDedChg = *Blanks
     C                   Eval      WUrgFlg = *Blanks                                          URGIND

     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Move file to screen                                           *
      *                                                               *
      * Called by: Prc@Sf                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     MovFil2       Begsr

     C                   Eval      WBranch   =   Branch
     C                   Eval      WCustom   =   Custom
     C                   Eval      WTrnTyp   =   TrnTyp
     C                   Eval      WTrsBty   =   TrsBty
     C                   Eval      WCsgRcd   =   CsgRcd
     C                   Eval      WCurRcy   =   CurRcy
     C                   Eval      WNetwrk   =   Netwrk
     C                   Eval      WMsgtyp   =   Msgtyp
     C                   Eval      WPaytyp   =   Paytyp
     C                   Eval      WStmtmd   =   Stmtmd
     C                   Eval      WDractp   =   Dractp
     C                   Eval      WCractp   =   Cractp
     C                   Eval      WAddded   =   Addded
     C                   Eval      WFxtran   =   Fxtran
     C                   Movel     TdCtry        TdCtry            2
     C                   Eval      WTdCtry   =   TdCtry
     C                   Eval      WPdescr   =   Pdescr
     C                   Eval      WPdoFcd   =   PdoFcd
     C                   Eval      WSwsTch   =   SwsTch
     C                   Eval      WSwpRch   =   SwpRch
     C                   Eval      WMisChg   =   MisChg
     C                   Eval      WCorChg   =   CorChg
     C                   Eval      WChcHrg   =   ChcHrg
     C                   Eval      WMisCh1   =   MisCh1
     C                   Eval      WFxcHcc   =   FxcHcc
     C                   Eval      WTxcHcd   =   TxcHcd
     C                   Eval      WMisCh2   =   MisCh2
     C                   Eval      WCabChc   =   CabChc
     C                   Eval      WAdvChg   =   AdvChg
     C                   Eval      WMisCh3   =   MisCh3
     C                   Eval      WTrcMch   =   TrcMch
     C                   Eval      WTelChg   =   TelChg
     C                   Eval      WMisCh4   =   MisCh4
     C                   Eval      WColChg   =   ColChg
     C                   Eval      WFxsPst   =   FxsPst
     C                   Eval      WMisCh5   =   MisCh5
     C                   Eval      WDedChg   =   DedChg
     C                   Eval      WUrgFlg   =   UrgFlg                                       URGIND

     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Mov File Move data to File structure                          *
      *                                                               *
      * Called by: Prc@Sf                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     MovFil        Begsr

     C                   Eval       Branch   =  WBranch
     C                   Eval       Custom   =  WCustom
     C                   Eval       TrnTyp   =  WTrnTyp
     C                   Eval       TrsBty   =  WTrsBty
     C                   Eval       CsgRcd   =  WCsgRcd
     C                   Eval       CurRcy   =  WCurRcy
     C                   Eval       Netwrk   =  WNetwrk
     C                   Eval       Msgtyp   =  WMsgtyp
     C                   Eval       Paytyp   =  WPaytyp
     C                   Eval       Stmtmd   =  WStmtmd
     C                   Eval       Dractp   =  WDractp
     C                   Eval       Cractp   =  WCractp
     C                   Eval       Addded   =  WAddded
     C                   Eval       Fxtran   =  WFxtran
     C                   Eval       TdCtry   =  WTdCtry
     C                   Eval       Pdescr   =  WPdescr
     C                   Eval       PdoFcd   =  WPdoFcd
     C                   Eval       SwsTch   =  WSwsTch
     C                   Eval       SwpRch   =  WSwpRch
     C                   Eval       MisChg   =  WMisChg
     C                   Eval       CorChg   =  WCorChg
     C                   Eval       ChcHrg   =  WChcHrg
     C                   Eval       MisCh1   =  WMisCh1
     C                   Eval       FxcHcc   =  WFxcHcc
     C                   Eval       TxcHcd   =  WTxcHcd
     C                   Eval       MisCh2   =  WMisCh2
     C                   Eval       CabChc   =  WCabChc
     C                   Eval       AdvChg   =  WAdvChg
     C                   Eval       MisCh3   =  WMisCh3
     C                   Eval       TrcMch   =  WTrcMch
     C                   Eval       TelChg   =  WTelChg
     C                   Eval       MisCh4   =  WMisCh4
     C                   Eval       ColChg   =  WColChg
     C                   Eval       FxsPst   =  WFxsPst
     C                   Eval       MisCh5   =  WMisCh5
     C                   Eval       DedChg   =  WDedChg
     C                   Eval       UrgFlg   =  WUrgFlg                                       URGIND

     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Get_PayCode.  Validates Payment Charge Code                   *
      *                                                               *
      * Called by: Validate                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Get_PayCode   Begsr

     C                   Eval      Inv_Code = *Blank


     C     PYCHCD        Setll     FTPCHGL0                               97
     C                   If        Not *In97
     C                   Eval      Inv_Code = 'Y'
     C                   Endif

     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Code_Qry - Does code question mark processing                 *
      *                                                               *
      * Called by: Quest_Proc                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Code_Qry      Begsr

     C     '?'           Scan      PYCHCD                                 96

     C                   If        *In96
     C                   Eval      CodeQuery = 'Y'
     C                   CallB     'FT000940'
     C                   Parm                    PYCHCD
     C     '?'           Scan      PYCHCD                                 96
     C                   If        *IN96
     C                   Eval      PYCHCD = *Blanks
     C                   EndIf

     C                   Endif

     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Qry_Spread.   '?' processing for FX Spread Set Code           *
      *                                                               *
      * Called by: Quest_Proc                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Qry_Spread    Begsr

     C     '?'           Scan      SPRCOD                                 96

     C                   If        *In96
     C                   Eval      CodeQuery = 'Y'
     C                   CallB     'FT000950'
     C                   Parm                    SPRCOD
     C     '?'           Scan      SPRCOD                                 96

     C                   If        *In96
     C                   Eval      SPRCOD = *Blanks
     C                   EndIf

     C                   Endif

     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Qry_Offset.   '?' processing for Payment Date Offset Code     *
      *                                                               *
      * Called by: Quest_Proc                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Qry_Offset    Begsr

     C     '?'           Scan      PYDTOC                                 96

     C                   If        *In96
     C                   Eval      CodeQuery = 'Y'
     C                   CallB     'FT000960'
     C                   Parm                    PYDTOC
     C     '?'           Scan      PYDTOC                                 96

     C                   If        *In96
     C                   Eval      PYDTOC = *Blanks
     C                   Endif

     C                   Endif

     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Get_Offset.   Validates Payment Date Offset Code              *
      *                                                               *
      * Called by: Validate                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Get_Offset    Begsr

     C                   Eval      Inv_Code = *Blank

     C     PYDTOC        Setll     FTPDOCL0                               97
     C                   If        Not *In97
     C                   Eval      Inv_Code = 'Y'
     C                   Endif

     C                   Endsr
      *****************************************************************
      *                                                               *
      * Get_Spread.   Validates FX Spread Set Code                    *
      *                                                               *
      * Called by: Validate                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Get_Spread    Begsr

     C                   Eval      Inv_Code = *Blank

     C     SPRCOD        Setll     FTXTRHL0                               97
     C                   If        Not *In97
     C                   Eval      Inv_Code = 'Y'
     C                   Endif

     C                   Endsr
      *****************************************************************
      *                                                               *
      * PySr - Record Locking                                         *
      *                                                               *
      * Called by: *Error                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     PySr          Begsr
     C                   Eval      PyLocked = 'N'
     C                   If        PyStatus = Record_Locked
     C                   Eval      PyLocked = 'Y'
     C     SFLRRN        CHAIN     FT326S1                            96
     C                   EVAL      *In43 = *Off
     C                   EVAL      SFLSEL = ' '
     C                   UPDATE    FT326S1
     C                   Eval      Msgid = 'FTF3151'
     C                   CALL      'ZA0250'
     C                   Exsr      SndMsg
     C                   Eval      ReturnPt = '*GETIN'
     C                   Endif
     C                   Endsr     ReturnPt
      /EJECT
      *****************************************************************
      *                                                               *
      * SndMsg - Send Program Message                                 *
      *                                                               *
      * Called by: Prc@Sf                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SndMsg        Begsr
      *
      * Only write message if requested
     C                   If        Msgid <> *Blanks
     C                   CallB     'AOCREPT'
     C                   Parm                    Msgid
     C                   Parm                    Msgf
     C                   Parm                    MsgLib
     C                   Parm                    MsgDta
     C                   Parm                    MsgRel
     C                   Parm                    #Pgm
     C                   PARM      *Blanks       FTMSGQ           10
     C                   PARM      *Blanks       FTMSGT            7
     C                   Endif
      *
      *?Reset message Id
     C                   Reset                   Msgds
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

     C                   Eval      #WrkSt = PsJobName
     C                   Eval      #Pgm = PsProcPgm
      *
      ** Access Bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database error
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 001*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   Eval      ReLoad = 'Y'

     C     KeyL0         Klist
     C                   Kfld                    BRANCH
     C                   Kfld                    CUSTOM
     C                   Kfld                    CURRCY
     C                   Kfld                    TRNTYP
     C                   Kfld                    TRSBTY
     C                   Kfld                    CSGRCD
     C                   Kfld                    NETWRK
     C                   Kfld                    PAYTYP
     C                   Kfld                    MSGTYP
     C                   Kfld                    STMTMD
     C                   Kfld                    DRACTP
     C                   Kfld                    CRACTP
     C                   Kfld                    ADDDED
     C                   Kfld                    FXTRAN
     C                   Kfld                    TdCtry
     C                   Kfld                    UrgFlg                                       URGIND

     C     KeyL0W        Klist
     C                   Kfld                    WBRANCH
     C                   Kfld                    WCUSTOM
     C                   Kfld                    WCURRCY
     C                   Kfld                    WTRNTYP
     C                   Kfld                    WTRSBTY
     C                   Kfld                    WCSGRCD
     C                   Kfld                    WNETWRK
     C                   Kfld                    WPAYTYP
     C                   Kfld                    WMSGTYP
     C                   Kfld                    WSTMTMD
     C                   Kfld                    WDRACTP
     C                   Kfld                    WCRACTP
     C                   Kfld                    WADDDED
     C                   Kfld                    WFXTRAN
     C                   Kfld                    WTdCtry
     C                   Kfld                    WUrgFlg                                      URGIND

      * Key list for deal type / sub-type combination
     C     KeyDeal       Klist
     C                   Kfld                    WTrntyp
     C                   Kfld                    WTrsbty


      * Group Set Code key list
     C     KeyGroup      Klist
     C                   Kfld                    D6SNBR
     C                   Kfld                    WCsgrcd

     C                   Eval      D6SNBR = '1'

      *
      * Set Searches
      *               1 BRANCH
      *               2 CUSTOM
      *               3 CURRCY
      *               4 TRNTYP
      *               5 TRSBTY
      *               6 CSGRCD
      *               7 NETWRK
      *               8 PAYTYP
      *               9 MSGTYP
      *              10 STMTMD
      *              11 DRACTP
      *              12 CRACTP
      *              13 ADDDED
      *              14 FXTRAN
      *              15 TdCtry
      *              16 UrgFlg                                                                URGIND
     C                   Clear                   Search20         20
      *                                        12345678901234567890
      *
      * Define Look Up key
     C     Klook1        Klist
     C                   Kfld                    LPKEY
     C                   Kfld                    LPSEQN
     C     Klook2        Klist
     C                   Kfld                    LPKEY
      *
     C                   Eval      LPKEY = 'Charge Def'
     C                   Clear                   LPSEQN
      *
      * Look to see if specific customer search required
     C     Klook1        Setll     @Lookv0
     C     Klook2        Reade     @Lookv0                                90
     C                   If        *in90 = *off
     C                   Eval      SearchNbr = 0
     C                   Dou       *in90 = *on
     C                   Eval      SearchNbr = SearchNbr + 1
     C                   Eval      Idx = SearchNbr
     C                   Movea     ##Search      Search#(Idx)
     C     Klook2        Reade     @Lookv0                                90
     C                   Enddo
     C                   Else
      *
     C                   Eval      SearchNbr = 5
      *
     C                   Eval      Search20 = 'YNNYNYYYYYNNNNNNNNNN'
     C                   Movea     Search20      Search#(1)
     C                   Eval      Search20 = 'YNNYNNYYYYNNNNNNNNNN'
     C                   Movea     Search20      Search#(2)
     C                   Eval      Search20 = 'YNNYYNNNNNNNNNNNNNNN'
     C                   Movea     Search20      Search#(3)
     C                   Eval      Search20 = 'YNNNNYNNNNNNNNNNNNNN'
     C                   Movea     Search20      Search#(4)
     C                   Eval      Search20 = 'YNNNNNNNNNNNNNNNNNNN'
     C                   Movea     Search20      Search#(5)
     C                   Endif
      *

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
