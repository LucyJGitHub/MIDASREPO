     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Header browse module for CCT')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTM1021BW -  Funds Transfer Browse Function Module for CCT   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207             Date 07Jun07               *
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 TDA035             Date 02Apr04               *
      *                 213056             Date 09Dec02               *
      *                 CSD015             Date 14Oct02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 188775             Date 08Mar01               *
      *                 188650             Date 07Feb01               *
      *                 188651             Date 06Feb01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 187210             Date 20Nov00               *
      *                 184177             Date 01Nov00               *
      *                 185196             Date 23Oct00               *
      *                 185107             Date 17Oct00               *
      *                 184060             Date 22Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT006  *CREATE    Date 20Oct99               *
      *                                    Date ddmmmyy               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Changes (Recompiled)                     *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  213056 - Initialise RetCodeIn to blanks if error already     *
      *           exists                                              *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  CSW201 - SWIFT 2001 Standards Update (Recompiled)            *
      *  188775 - Checking for insufficient funds                     *
      *  188650 - Allow more than 1 subfile selection                 *
      *  188651 - Resequence browse into last entries entered         *
      *  187210 - Correct validation for individual select            *
      *  184177 - Retain selector fields.                             *
      *  185196 - Put out warning message when authorising if routed  *
      *           from SWIFT message and not all parts processed.     *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184060 - No transaction type code in detail screen -Recompile*
      *  CFT006 - Funds Transfer/Swift Messages MT101/MT102           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
     FFTM1022BDFCF   E             WORKSTN
     F                                     SFILE(FTM1022BSF:RRN)
     FMSIXI2L2  IF   E           K DISK    INFSR(*PSSR)
     FFT102DL0  IF   E           K DISK    INFSR(*PSSR)
     FFT102HL3  IF   E           K DISK    INFSR(*PSSR)
     FFT102HL5  IF   E           K DISK    INFSR(*PSSR) RENAME(FT102HD0:CCT5)
     FFT102HL1  IF   E           K DISK    INFSR(*PSSR) RENAME(FT102HD0:CCTL1)
     FFT102HLA  IF   E           K DISK    INFSR(*PSSR) RENAME(FT102HD0:CCTLA)
     FFT102HL2  IF   E           K DISK    INFSR(*PSSR) RENAME(FT102HD0:CCTL2)
     F* IMM Incoming Msg Control File                                           185196
     FMEINFTL0  IF   E           K DISK    INFSR(*PSSR)                         185196
     F* CCT detail file                                                         185196
     FFT102DL2  IF   E           K DISK    INFSR(*PSSR) RENAME(FT102DD0:RFTL2D) 185196
                                                                                              CSD015
      ** Compliance Watch Hit List File                                                       CSD015
     FSDCWHTL1  IF   E           K DISK                                                       CSD015
 
      *****************************************************************
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *       03  Exit                                                *
      *       05  Refresh                                             *
      *       12  Cancel                                              *
      *       14  Toggle between outgoing/incoming 102                *
      *       15  Switch between authorised / unauthorised and dual   *
      *                                                               *
      *       25  Message subfile                                     *
      *       26  SFLDSP                                              *
      *       27  SFLDSPCTL                                           *
      *       28  SFLCLR                                              *
      *       29  SFLEND                                              *
      *       30  SFLNXTCHG                                           *
      *       31  Toggle between sender/destination                   *
      *                                                               *
      *       40  Read FT102HL5                                       *
      *       41  Readc subfile                                       *
      *       42  Chain FT102HL3                                      *
      *       43  Chain FT102DL0                                      *
      *       44  Chain MSIXI2L2                                      *
      *       45  Write to subfile                                    *
      *       46  Read MEINFTL4                                       *         185196
      *       47  Read FT102DL2                                       *         185196
      *                                                               *
      *       50  Error in selection fields                           *
      *       51  Error in position fields                            *
      *       52  Error in subfile action code                        *
      *       53  Error in header action code                         *
      *       54  Error in CCT ID                                     *
      *       55  Error in transaction reference                      *
      *       56  Error in swift reference                            *
      *                                                               *
      *****************************************************************
 
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      **********************************************************************
      /EJECT                                                               *
      **********************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Header record datastructure
     D HdrRcdIn      E DS                  EXTNAME(FT102HPD)
      **
      * Dtl record datastructure
     D DtlRcdIn      E DS                  EXTNAME(FT102DPD) PREFIX(D)
 
      ** Error array
     D @EI             S              1    DIM(40)
 
      ** OK flags
     D OKFILE        E DS                  EXTNAME(FTE102HBPD)
 
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for access programs, short DS
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** User Details
     D SDUSER        E DS                  EXTNAME(MUSER)
                                                                                              CSD015
      ** External DS for SAR Details                                                          CSD015
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD015
     D  SLCD         E                     EXTFLD(LCD)                                        CSD015
                                                                                              CSD015
      ** Midas Functions for Watch List Checking Details File                                 CSD015
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                  CSD015
                                                                                              CSD015
      ** 24x7 Status Dataarea                                                                 CSD015
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSD015
                                                                                              CSD015
      ** External DS for Standing Data Dataarea                                               CSD015
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSD015
     D  SMODE        E                     EXTFLD(MODE)                                       CSD015
 
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
     D  Utxt           C                   'Unauthorised Transactions'
     D  Atxt           C                   'Authorised Transactions'
     D  AllTxt         C                   'All Transactions'
     D  DualTxt        C                   'Part-authorised Transactions'
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work fields
     D Rrn             S              3  0 INZ(1)
     D Error           S              1    INZ('Y')
     D Errorprv        S              1    INZ('N')
     D Exit            S              1    INZ('N')
     D Type            S              2
     D Errcnt          S              3  0 INZ(0)
     D Actcnt          S              3  0 INZ(0)
     D Action          S              1
     D Ix              S              3  0 INZ(0)
     D C               S              2  0
     D E               S              2  0
     D Emptysf         S              1
     D firstwarn       S              1                                         185196
     D warning         S              1                                         185196
     D warncheck       S              1                                         185196
     D allparts        S              1                                         185196
     D Valerrcde       S             10
 
     D UserBnch        S                   Like(DBRN)
     D ActErr          S              1  0
     D ValidCode       S              1
                                                                                              CSD015
      ** Variables for CSD015                                                                 CSD015
     D CSC011          S              1                                                       CSD015
     D CSD015          S              1                                                       CSD015
     D KFuncCode       S              8                                                       CSD015
     D KIden           S             40                                                       CSD015
     D KBranch         S              3                                                       CSD015
     D PFunc           S              8                                                       CSD015
     D POptn           S              7                                                       CSD015
     D PSard           S              6                                                       CSD015
 
      ** Parameters for ZALIGN
     D Zalignok        S              1
     D Zfield          S             16
     D Zadec           S              1  0
     D Zadig           S              2  0
 
      ** *Entry parameters
     D @actn           S              1
     D @cctid          S             15
     D @tranref        S             16
     D @swiftref       S             28
     D @keyp           S              2
     D @ccttype        S              2
     D @FilRef         S             16
 
      ** Key list fields
     D kcctid          S             15
     D ktrnref         S             16
     D kpytp           S              2
 
      ** Parameters for QDCXLATE
     D length          S              5  0
     D wsndst          S             35
     D wsndst1         S             35
     D wordcus         S             35
     D wordcus1        S             35
     D const1          S             10
     D const2          S             10
     D wfilref         S             16
     D wfilref1        S             16
 
      ** Parameters for QCLSCAN
     D lgthfld         S              3  0
     D start           S              3  0
     D lgthsrch        S              3  0
     D translate       S              1
     D trim            S              1
     D wild            S              1
     D result          S              3  0
     D SavUser         S                   Like(INUSER)
     D Display         S              1    Inz('Y')                             188650
                                                                                188775
      ** Parameters for FTVCKIF01                                               188775
     D PRTCD           S                   LIKE(RETCODEIN)                      188775
     D PCCTID          S                   LIKE(CCTID)                          188775
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *********************************************************************
      /EJECT                                                              *
      *********************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   Eval      Exit = 'N'                                   184177
 
     C                   DoW       Exit = 'N'
 
     C                   If        Actcnt > 1                                   188650
     C                   Eval      Actcnt = Actcnt - 1                          188650
     C                   Eval      Display = 'N'                                188650
     C                   Else                                                   188650
     C                   Eval      Actcnt = 0                                   188650
     C                   Eval      Display = 'Y'                                188650
     C                   Endif                                                  188650
 
     C                   If        Actcnt < 1                                   188650
     C                   Exsr      ClrScreen
     C                   Exsr      FillScreen
     C                   Endif                                                  188650
     C                   Exsr      ShowScreen
     C                   Enddo
 
     C                   Return                                                 184177
     C*******************Seton                                        LR        184177
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  FillScreen -  Subroutine to fill screen                      *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *                                                               *
      *                                                               *
      *****************************************************************
 
     C     FillScreen    Begsr
 
      ** Clear subfile
 
     C                   Eval      *IN28 = *ON
     C                   Write     ftm1022bct
     C                   Eval      *IN28 = *OFF
 
     C                   Eval      Rrn = 1
     C                   Eval      kpytp  = type
     C                   Eval      Ix = 0
 
     C                   Select
 
      ** When both of the selection fields are not blank - error
 
     C                   When      sssnddst <> *blanks AND
     C                             ssordcus <> *blanks OR
     C                             sssnddst <> *blanks AND
     C                             ssfilref <> *blanks OR
     C                             ssordcus <> *blanks AND
     C                             ssfilref <> *blanks
 
     C                   Add       1             Ix
     C                   Move      'sssnddst'    FldNameArr(Ix)
     C                   Move      'RFV0061'     MsgIdArr(Ix)
     C                   Eval      oksdord = 'N'
 
     C                   Endsl
 
      ** When CCT id is not blank, position subfile, else read file from
      ** the beginning
 
     C                   Eval      kcctid = *blanks
 
     C                   If        spcctid <> *blanks and sssnddst = *blanks
     C                             and ssordcus = *blanks
 
      ** Ensure no blanks at beginning of position fields
 
     C                   Eval      kcctid = %TRIML(spcctid)
     C                   Else                                                   188651
     C                   Eval      KCctid = *Hival                              188651
 
     C                   Endif
 
     C                   Select
     C                   When      NOT *IN32 and NOT *IN33 and NOT *IN34
 
     C     KPosition     SETLL     FT102HL5
     C     KPYTP         READE     FT102HL5                               40
     C                   When      *IN32
     C     KPosition     Setll     FT102HLA
     C     KPYTP         READE     FT102HLA                               40
     C                   When      *IN33
     C     KPosition     Setll     FT102HL1
     C     KPYTP         READE     FT102HL1                               40
     C                   When      *IN34
     C     KPosition     Setll     FT102HL2
     C     KPYTP         READE     FT102HL2                               40
     C                   EndSl
 
     C                   DoW       *IN40 = *OFF
     C                   Eval      *IN45 = *OFF
 
     C                   Select
 
      ** Select on sender/destination
 
     C                   When      sssnddst <> *blanks AND
     C                             ssordcus =  *blanks AND
     C                             ssfilref =  *blanks
 
     C                   Call      'QDCXLATE'
     C                   Parm      35            length
     C                   Parm      sssnddst      wsndst
     C                   Parm      'QSYSTRNTBL'  const1
     C                   Parm      'QSYS'        const2
 
      ** Ensure no blanks at beginning of search field
 
     C                   Eval      wsndst1 = *blanks
     C                   Eval      wsndst1 = %TRIML(wsndst)
     C                   Eval      wsndst = wsndst1
 
      ** Scan for search string
 
     C                   If        type = 'BI'
 
     C                   Call      'QCLSCAN'
     C                   Parm                    sinst
     C                   Parm      35            lgthfld
     C                   Parm      1             start
     C                   Parm                    wsndst
     C                   Parm      35            lgthsrch
     C                   Parm      '1'           translate
     C                   Parm      '1'           trim
     C                   Parm      '?'           wild
     C                   Parm                    result
 
     C                   Else
 
     C                   Call      'QCLSCAN'
     C                   Parm                    cctdst
     C                   Parm      35            lgthfld
     C                   Parm      1             start
     C                   Parm                    wsndst
     C                   Parm      35            lgthsrch
     C                   Parm      '1'           translate
     C                   Parm      '1'           trim
     C                   Parm      '?'           wild
     C                   Parm                    result
     C                   Endif
 
      ** If string found, write to subfile
 
     C                   If        result >= 1
     C                   Eval      *IN45 = *ON
     C                   Endif
 
      ** Select on ordering customer
 
     C                   When      sssnddst =  *blanks and
     C                             ssordcus <> *blanks and
     C                             ssfilref =  *blanks
 
     C                   Call      'QDCXLATE'
     C                   Parm      35            length
     C                   Parm      ssordcus      wordcus
     C                   Parm      'QSYSTRNTBL'  const1
     C                   Parm      'QSYS'        const2
 
      ** Ensure no blanks beginning of search field
 
     C                   Eval      wordcus1 = *blanks
     C                   Eval      wordcus1 = %TRIML(wordcus)
     C                   Eval      wordcus = wordcus1
 
      ** Scan for search string
 
     C                   Call      'QCLSCAN'
     C                   Parm                    tocus1
     C                   Parm      35            lgthfld
     C                   Parm      1             start
     C                   Parm                    wordcus
     C                   Parm      35            lgthsrch
     C                   Parm      '1'           translate
     C                   Parm      '1'           trim
     C                   Parm      '?'           wild
     C                   Parm                    result
 
      ** If string found, write to subfile
 
     C                   If        result >= 1
     C                   Eval      *IN45 = *ON
     C                   Endif
 
      ** Select on file reference
 
     C                   When      sssnddst =  *blanks and
     C                             ssordcus =  *blanks and
     C                             ssfilref <> *blanks
 
     C                   Call      'QDCXLATE'
     C                   Parm      16            length
     C                   Parm      ssfilref      wfilRef
     C                   Parm      'QSYSTRNTBL'  const1
     C                   Parm      'QSYS'        const2
 
      ** Ensure no blanks beginning of search field
 
     C                   Eval      wfilref1 = *blanks
     C                   Eval      wfilref1 = %TRIML(wfilref)
     C                   Eval      wfilref = wfilref1
 
      ** Scan for search string
 
     C                   Call      'QCLSCAN'
     C                   Parm                    filref
     C                   Parm      16            lgthfld
     C                   Parm      1             start
     C                   Parm                    wfilref
     C                   Parm      16            lgthsrch
     C                   Parm      '1'           translate
     C                   Parm      '1'           trim
     C                   Parm      '?'           wild
     C                   Parm                    result
 
      ** If string found, write to subfile
 
     C                   If        result >= 1
     C                   Eval      *IN45 = *ON
     C                   Endif
 
     C                   Other
 
     C                   Eval      *IN45 = *ON
 
     C                   Endsl
 
     C                   If        CctTyp <> Type
     C                   Eval      *IN45 = *Off
     C                   Endif
 
 
      ** Write to the subfile
 
     C                   If        *IN45 = *ON
     C                   Eval      sfcctid = cctid
     C                   Eval      sffilref = filref
 
     C                   If        type = 'BI'
     C                   Eval      sfsnddst = sinst
     C                   Else
     C                   Eval      sfsnddst = cctdst
     C                   Endif
 
     C                   Eval      sfordcus = tocus1
     C                   Write     ftm1022bsf
     C                   Add       1             rrn
     C                   Endif
 
     C                   Select
     C                   When      NOT *IN32 and NOT *IN33 and NOT *IN34
     C     KPYTP         READE     FT102HL5                               40
     C                   When      *IN32
     C     KPYTP         READE     FT102HLA                               40
     C                   When      *IN33
     C     KPYTP         READE     FT102HL1                               40
     C                   When      *IN34
     C     KPYTP         READE     FT102HL2                               40
     C                   Endsl
 
     C                   Enddo
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      *  ShowScreen -  Subroutine to show screen                      *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *                                                               *
      *                                                               *
      *****************************************************************
 
     C     ShowScreen    Begsr
 
     C*******************If        Rrn = 1                                      188650
     C                   IF        rrn = 1 and Display = 'Y'                    188650
     C                   Eval      *IN26 = *OFF
     C                   Eval      Emptysf = 'Y'
     C                   Else
     C                   Eval      *IN26 = *ON
     C                   Eval      Emptysf = 'N'
     C                   Endif
 
     C                   Eval      *IN27 = *ON
     C                   Eval      *IN29 = *ON
     C                   Eval      Error = 'Y'
 
     C                   If        type = 'BI'
     C                   Eval      *IN31 = *OFF
     C                   Else
     C                   Eval      *IN31 = *ON
     C                   Endif
 
      ** Loop until there are no errors
 
     C                   DoW       Error = 'Y'
 
      ** Move ok flags into array
 
     C                   MoveA     okfile        @Ei
 
      ** Set screen error indicators according to status of ok flags
 
     C                   Eval      C = 1
     C                   Eval      E = 50
 
     C                   DoW       C <=40
 
     C                   If        @Ei(C) = 'N' OR @Ei(C) = 'W'
     C                   Eval      *IN(E) = *ON
     C                   Endif
 
     C                   Add       1             C
     C                   Add       1             E
 
     C                   Enddo
 
      ** Clear message subfile
 
     C                   Call      'ZA0250'
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------
 
      ** Select text at top of screen
     C                   Select
     C                   When      *IN32
     C                   Eval      ScnTxt = UTxt
     C                   When      *IN33
     C                   Eval      ScnTxt = ATxt
     C                   When      *IN34
     C                   Eval      ScnTxt = DualTxt
     C                   Other
     C                   Eval      ScnTxt = AllTxt
     C                   Endsl
 
      ** Display command keys
 
     C                   Write     cmdkey
 
      ** Write error messages
 
     C                   Write     #msgctl
 
      ** Display screen
 
     C                   If        Display = 'Y'                                188650
     C                   Exfmt     ftm1022bct
     C                   Endif                                                  188650
 
      ** Process screen
 
     C                   Exsr      ProcScreen
 
     C                   Enddo
      *
     C                   Endsr
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **--------------------------------------------------------------------------------------------
      /EJECT
      *****************************************************************
      *                                                               *
      *  ProcScreen - Subroutine to process screen                    *
      *                                                               *
      *  Called By: ShowSreen                                         *
      *  Calls:                                                       *
      *                                                               *
      *                                                               *
      *****************************************************************
 
     C     ProcScreen    Begsr
 
     C                   Select
 
      ** When F3 is pressed, exit
 
     C                   When      *IN03 = *ON
     C                   Eval      Error = 'N'
     C                   Eval      Exit  = 'Y'
     C                   Eval      @keyp = '03'
 
      ** When F5 is pressed, refresh
 
     C                   When      *IN05 = *ON
     C                   Eval      Error = 'N'
     C                   Eval      Actcnt = 0                                   188650
 
      ** When F12 is pressed, exit
 
     C                   When      *IN12 = *ON
     C                   Eval      Error = 'N'
     C                   Eval      Exit  = 'Y'
     C                   Eval      @keyp = '12'
 
      ** When F14 is pressed, toggle between incoming/outgoing CCT
 
     C                   When      *IN14 = *ON
     C                   Eval      error = 'N'
 
     C                   If        type = 'BI'
     C                   Eval      type = 'BO'
     C                   Else
     C                   Eval      type = 'BI'
     C                   Endif
 
     C                   Other
 
      ** Validate screen
 
     C                   Exsr      Validate
 
     C                   Endsl
 
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      *  Validate - Subroutine to validate screen                     *
      *                                                               *
      *  Called By: ProcScreen                                        *
      *  Calls:                                                       *
      *                                                               *
      *                                                               *
      *****************************************************************
 
     C     Validate      Begsr
 
     C                   Eval      Ix = 0
     C                   MoveA     '00000000'    *IN(50)
     C                   Eval      Errcnt = 0
     C                   Eval      Actcnt = 0
     C                   Eval      Errorprv = 'N'
     C                   Eval      Action = *blanks
     C                   Move      *ALL'Y'       okfile
     C                   Clear                   FldNameArr
     C                   Clear                   MsgIdArr
     C                   Clear                   MsgDtaArr
 
      ** Validate subfile action code
 
     C                   If        Emptysf = 'N'
     C                   Exsr      ValSubf
     C                   Endif
 
      ** Validate User
     C                   Exsr      ValUser
 
      ** Validate action code
 
     C                   If        ValidCode = 'Y'
     C                   Exsr      ValActcd
     C                   Endif
 
      ** Validate CCT Id
 
     C                   Exsr      ValCctid
 
      ** Validate transaction reference
 
     C                   Exsr      ValTrnrf
 
      ** Validate swift reference
 
     C                   Exsr      ValSwfrf
 
     C                   Select
 
      ** When screen fields are all blank, reload subfile
 
     C                   When      Error = 'Y' and Action = *blanks and
     C                             sactn = *blanks
     C                             and sswfref = *blanks and
     C                             scctid = *blanks and strnref = *blanks
     C                   Eval      Error = 'N'
 
      ** If there are no errors, fill parameters to pass back to controlling
      ** module, exit
 
     C                   When      Error = 'N'
     C                   Eval      Exit = 'Y'
     C                   Eval      RetCodeIn = *blanks
 
     C                   If        sfactn <> *blanks
     C                   Eval      @actn = sfactn
     C                   Eval      @cctid = sfcctid
     C                   Eval      @tranref = *blanks
     C                   Eval      @swiftref = *blanks
     C                   Eval      @filRef = *blanks
     C                   Eval      @keyp = *blanks
 
     C                   Else
 
     C                   If        sactn <> *blanks
     C                   Eval      @actn = sactn
     C                   Else
     C                   Eval      @actn = 'I'
     C                   Endif
 
     C                   Eval      @cctid = scctid
     C                   Eval      @tranref = strnref
     C                   Eval      @swiftref = sswfref
     C                   Eval      @FilRef = ssFilRef
     C                   Eval      @keyp = *blanks
     C                   Endif
 
     C                   If        @actn = 'I' and @cctid = *blanks
 
      ** If the swift reference is not blank then default message type to
      ** 'incoming' since most will be this and no other way to determine
 
     C                   If        @swiftref <> *blanks
     C                   Eval      @ccttype = 'BI'
     C                   Else
     C                   Eval      @ccttype = type
     C                   Endif
 
     C                   Else
     C                   Eval      @ccttype = *blanks
     C                   Endif
 
     C                   Endsl
 
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValSubf - Subroutine to validate subfile action code         *
      *                                                               *
      *  Called By: Validate                                          *
      *  Calls:                                                       *
      *                                                               *
      *                                                               *
      *****************************************************************
 
     C     ValSubf       Begsr
 
      ** Read changes to subfile
 
     C                   ReadC     ftm1022bsf                             41
 
     C                   DoW       *IN41 = *OFF
 
     C                   Select
 
      ** Valid action code
 
     C                   When      sfactn = 'I' or sfactn = 'C' or
     C                             sfactn = 'A' or sfactn = 'D' or
     C                             sfactn = 'E' or sfactn = 'X'
 
     C                   ADD       1             actcnt
 
     C                   If        actcnt = 1
     C                   Eval      rec = rrn
     C                   Eval      action = 'Y'
     C                   Endif
 
      ** More than one action code, error
 
     C*******************If        Actcnt > 1 or Actcnt = 1 and                 188650
     C                   If        Actcnt = 1 and                               188650
     C                             sactn <> *blanks or Actcnt = 1 and
     C                             sactn = *blanks and sswfref <> *blanks
     C                   Eval      *IN52 = *ON
     C                   Endif
 
     C                   Eval      *IN30 = *ON
     C                   Update    ftm1022bsf
     C                   Eval      *IN30 = *OFF
     C                   Eval      *IN52 = *OFF
 
     C                   Readc     ftm1022bsf                             41
 
      ** Invalid action code
 
     C                   When      sfactn <> 'I' and sfactn <> 'C' and
     C                             sfactn <> 'A' and sfactn <> 'D' and
     C                             sfactn <> 'E' and sfactn <> 'X' and
     C                             sfactn <> *blanks
 
     C                   Add       1             errcnt
     C                   Add       1             actcnt
 
     C                   If        Errcnt = 1 and Actcnt = 1
     C                   Eval      rec = Rrn
     C                   Eval      Action = 'Y'
     C                   Endif
 
     C                   Eval      *IN30 = *ON
     C                   Eval      *IN52 = *ON
     C                   Update    ftm1022bsf
     C                   Eval      *IN30 = *OFF
     C                   Eval      *IN52 = *OFF
     C
     C                   Readc     ftm1022bsf                             41
     C                   Other
 
      ** Selection is  blank
 
     C                   Eval      *IN30 = *OFF
     C                   Update    ftm1022bsf
     C                   ReadC     ftm1022bsf                             41
 
     C                   Endsl
 
     C                   Enddo
 
     C                   Select
 
      ** More than one action code, error
 
     C*******************When      actcnt > 1 or actcnt =1 and                  188650
     C                   When      actcnt =1 and                                188650
     C                             sactn <> *blanks or actcnt = 1 and
     C                             sactn = *blanks and sswfref <> *blanks
 
     C                   Add       1             Ix
     C                   Move      'sfactn'      FldNameArr(Ix)
     C                   Move      'RFV0063'     MsgIdArr(Ix)
     C                   Eval      oksfactn = 'N'
 
     C                   ReadC     ftm1022bsf                             41
 
     C                   Eval      *IN30 = *ON
     C                   Eval      *IN52 = *ON
     C                   Update    ftm1022bsf
     C                   Eval      *IN30 = *OFF
     C                   Eval      *IN52 = *OFF
 
     C                   Eval      Error = 'Y'
     C                   Eval      Errorprv = 'Y'
 
      ** If invalid action code, error
 
     C                   When      Errcnt > 0
 
     C                   Add       1             Ix
     C                   Move      'sfactn'      FldNameArr(Ix)
     C                   Move      'RFV0064'     MsgIdArr(Ix)
     C                   Eval      oksfactn = 'N'
 
     C                   Eval      Error = 'Y'
     C                   Eval      Errorprv = 'Y'
 
     C                   Other
 
     C                   ReadC     ftm1022bsf                             41
 
      ** If valid action code, retrieve CCT header details
 
     C                   If        sfactn ='I' or sfactn = 'A'
     C                             or sfactn = 'C' or sfactn ='X'
     C                             or sfactn = 'D'
 
     C     sfcctid       Chain     FT102HL3                           42
 
     C                   If        *IN42 = *OFF
 
      ** If authorised, you cannot action the CCT
 
     C                   If        Auin = 'Y'       Or
     C                             SfActn <> 'X'    And
     C                             AUP1 <> *Blanks
 
     C                   Eval      Error = 'Y'
     C                   Eval      Errorprv = 'Y'
 
     C                   Add       1             Ix
     C                   Move      'sfactn'      FldNameArr(Ix)
     C                   Move      'RFV0091'     MsgIdArr(Ix)
     C                   Eval      oksfactn = 'N'
 
     C                   Eval      *IN30 = *ON
     C                   Eval      *IN52 = *ON
     C                   Update    ftm1022bsf
     C                   Eval      *IN30 = *OFF
     C                   Eval      *IN52 = *OFF
 
     C                   Else
 
      ** If action code is authorise, user must not be the same as input or
      ** amending user on file
 
     C                   If        sfactn = 'X'
 
      * Validate user authorisation threshold
 
     C                   CallB     'FTVTHHD01'
     C                   Parm                    RetCodeIn
     C                   Parm                    HdrRcdIn
 
      * Validate header and detail records
 
     C                   Movel     *Blanks       ValErrCde        10
     C                   Eval      SavUser = INUSER
     C                   CallB     'FTM1026VL'
     C                   Parm                    ValErrCde        10
     C                   Parm                    Sfactn
     C                   Parm                    HdrRcdIn
     C                   Parm                    DtlRcdIn
     C                   Eval      InUser = SavUser
                                                                                188775
      * Check for insufficient funds                                            188775
                                                                                188775
     C                   EVAL      PRTCD = *BLANKS                              188775
                                                                                188775
     C                   IF        CCTTYP = 'BO' AND                            188775
     C                             VALERRCDE <> '*VALERROR'                     188775
                                                                                188775
     C                   CALLB     'FTVCKIF01'                                  188775
     C                   PARM                    PRTCD                          188775
     C                   PARM      SFCCTID       PCCTID                         188775
                                                                                188775
     C                   ENDIF                                                  188775
 
      * If no error and message has been routed from a SWIFT msg                185196
      * check to see if all parts have been processed. If not                   185196
      * then issue warning message - once only - which can be                   185196
      * overridden by pressing <enter>                                          185196
                                                                                185196
     C                   Eval      warncheck = 'Y'                              185196
                                                                                185196
     C                   Select                                                 185196
                                                                                185196
     C                   When      ValErrCde = '*VALERROR'                      185196
     C                   Eval      warncheck = 'N'                              185196
                                                                                188775
     C                   WHEN      PRTCD = '*NOFUNDS'                           188775
     C                   EVAL      WARNCHECK = 'N'                              188775
                                                                                185196
     C                   Endsl                                                  185196
                                                                                185196
     C                   If        warncheck = 'Y'                              185196
     C                   If        firstwarn <> 'Y'                             185196
                                                                                185196
      * Call SR to check if warning message needed only if routed               185196
      * from a SWIFT message.                                                   185196
                                                                                185196
     C                   If        CHMSGR <> 0                                  185196
     C                   Exsr      AllPartsProc                                 185196
     C                   If        allparts = 'N'                               185196
     C                   Eval      warning = 'Y'                                185196
     C                   Endif                                                  185196
     C                   Endif                                                  185196
                                                                                185196
     C                   Endif                                                  185196
     C                   Endif                                                  185196
                                                                                185196
     C                   Select
 
     C                   When      ValErrCde = '*VALERROR'
     C                   Eval      Error = 'Y'
     C                   Eval      Errorprv = 'Y'
 
     C                   Add       1             Ix
     C                   Move      'sfactn'      FldNameArr(Ix)
     C                   Move      'RFV0146'     MsgIdArr(Ix)
     C                   Eval      oksfactn = 'N'
 
     C                   Eval      *IN30 = *ON
     C                   Eval      *IN52 = *ON
     C                   Update    ftm1022bsf
     C                   Eval      RetCodeIn = *Blanks                                        213056
     C                   Eval      *IN30 = *OFF
     C                   Eval      *IN52 = *OFF
                                                                                188775
     C                   WHEN      PRTCD = '*NOFUNDS'                           188775
     C                   EVAL      ERROR = 'Y'                                  188775
     C                   EVAL      ERRORPRV = 'Y'                               188775
                                                                                188775
     C                   ADD       1             IX                             188775
     C                   MOVE      'SFACTN'      FLDNAMEARR(IX)                 188775
     C                   MOVE      'FTM2412'     MSGIDARR(IX)                   188775
     C                   EVAL      OKSFACTN = 'N'                               188775
                                                                                188775
     C                   EVAL      *IN30 = *ON                                  188775
     C                   EVAL      *IN52 = *ON                                  188775
     C                   UPDATE    FTM1022BSF                                   188775
     C                   EVAL      *IN30 = *OFF                                 188775
     C                   EVAL      *IN52 = *OFF                                 188775
                                                                                185196
     C                   When      warning = 'Y'                                185196
     C                   If        firstwarn <> 'Y'                             185196
     C                   Eval      firstwarn  = 'Y'                             185196
                                                                                185196
     C                   Eval      error = 'Y'                                  185196
     C                   Eval      errorprv = 'Y'                               185196
                                                                                185196
     C                   Add       1             Ix                             185196
     C                   Move      'sfactn'      FldNameArr(Ix)                 185196
     C                   Move      'RFV0387'     MsgIdArr(Ix)                   185196
     C                   Eval      oksfactn = 'N'                               185196
                                                                                185196
     C                   Eval      *IN30 = *ON                                  185196
     C                   Eval      *IN52 = *ON                                  185196
     C                   UPDATE    ftm1022bsf                                   185196
     C                   Eval      RetCodeIn = *Blanks                                        213056
     C                   Eval      *IN30 = *OFF                                 185196
     C                   Eval      *IN52 = *OFF                                 185196
     C                   Else                                                   185196
     C                   Eval      error = 'N'                                  185196
     C                   Eval      RetCodeIn = *blanks                          185196
     C                   Eval      firstwarn  = *blanks                         185196
     C                   Endif                                                  185196
 
     C                   When      psuser = inuser  or
     C                             psuser = updusr
 
     C                   Eval      Error = 'Y'
     C                   Eval      Errorprv = 'Y'
 
     C                   Add       1             Ix
     C                   Move      'sfactn'      FldNameArr(Ix)
     C                   Move      'RFV0075'     MsgIdArr(Ix)
     C                   Eval      oksfactn = 'N'
 
     C                   Eval      *IN30 = *ON
     C                   Eval      *IN52 = *ON
     C                   Update    ftm1022bsf
     C                   Eval      RetCodeIn = *Blanks                                        213056
     C                   Eval      *IN30 = *OFF
     C                   Eval      *IN52 = *OFF
 
     C                   When      RetCodeIn = 'TooSmall'
 
     C                   Eval      Error = 'Y'
     C                   Eval      Errorprv = 'Y'
 
     C                   Add       1             Ix
     C                   Move      'sfactn'      FldNameArr(Ix)
     C                   Move      'RFV0142'     MsgIdArr(Ix)
     C                   Eval      oksfactn = 'N'
 
     C                   Eval      *IN30 = *ON
     C                   Eval      *IN52 = *ON
     C                   Update    ftm1022bsf
     C                   Eval      RetCodeIn = *Blanks                                        213056
     C                   Eval      *IN30 = *OFF
     C                   Eval      *IN52 = *OFF
 
     C                   Other
 
      ** No errors in subfile action code
 
     C                   Eval      Error = 'N'
     C                   Endsl
                                                                                              CSD015
      ** If function code is being monitored by compliance watch and Watch                    CSD015
      ** List Checking Applied                                                                CSD015
                                                                                              CSD015
     C                   If        CSD015 = 'Y' and W1EWLC = 'Y'                              CSD015
     C                             AND ERROR <> 'Y'                                           CSD015
                                                                                              CSD015
     C                   If        CSC011 = 'N' or Libr = S1Main                              CSD015
                                                                                              CSD015
     C*                  ReadC     ftm1022bsf                             41                  CSD015
                                                                                              CSD015
     C                   Eval      KIden = CCTID                                              CSD015
     C                   Eval      KBranch = BRCA                                             CSD015
     C                   Eval      W3UNCF = *Blanks                                           CSD015
                                                                                              CSD015
     C     KFuncKey      Chain     SDCWHTL1                           48                      CSD015
                                                                                              CSD015
     C                   If        *IN48 = *Off and W3TREL = 'Y'                              CSD015
     C                             or *IN48 = *On                                             CSD015
                                                                                              CSD015
     C                   Else                                                                 CSD015
                                                                                              CSD015
     C                   Eval      Error = 'Y'                                                CSD015
     C                   Eval      Errorprv = 'Y'                                             CSD015
                                                                                              CSD015
     C                   Add       1             Ix                                           CSD015
     C                   Move      'sfactn'      FldNameArr(Ix)                               CSD015
     C                   Move      'RFV0916'     MsgIdArr(Ix)                                 CSD015
     C                   Eval      oksfactn = 'N'                                             CSD015
                                                                                              CSD015
     C                   Eval      *IN30 = *ON                                                CSD015
     C                   Eval      *IN52 = *ON                                                CSD015
     C                   Update    ftm1022bsf                                                 CSD015
     C                   Eval      RetCodeIn = *Blanks                                        CSD015
     C                   Eval      *IN30 = *OFF                                               CSD015
     C                   Eval      *IN52 = *OFF                                               CSD015
     C                   Endif                                                                CSD015
     C                   Endif                                                                CSD015
     C                   Endif                                                                CSD015
     C                   Endif
     C                   Endif
 
     C                   Else
     C                   Eval      Error = 'N'
     C                   Endif
 
     C                   Else
     C                   Eval      Error = 'N'
     C                   Endif
 
     C                   Endsl
 
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValActcd - Subroutine to validate action code on header      *
      *                                                               *
      *  Called By: Validate                                          *
      *  Calls:                                                       *
      *                                                               *
      *                                                               *
      *****************************************************************
 
     C     ValActcd      Begsr
 
     C                   Select
 
      ** More than one action code, error
 
     C                   When      Action = 'Y' and sactn <> *blanks or
     C                             Action = 'Y' and sactn = *blanks and
     C                             sswfref <> *blanks
 
     C                   Eval      Error = 'Y'
     C                   Eval      Errorprv = 'Y'
 
     C                   Add       1             Ix
     C                   Move      'sactn'       FldNameArr(Ix)
     C                   Move      'RFV0063'     MsgIdArr(Ix)
     C                   Eval      okhdactn = 'N'
 
      ** Invalid action code, error
 
     C                   When      sactn <>'I' and sactn <> 'C' and
     C                             sactn <> 'A' and sactn <> 'D' and
     C                             sactn <> 'E' and sactn <> 'X' and
     C                             sactn <> *blanks
 
     C                   Eval      Error = 'Y'
     C                   Eval      Errorprv = 'Y'
 
     C                   Add       1             Ix
     C                   Move      'sactn'       FldNameArr(Ix)
     C                   Move      'RFV0064'     MsgIdArr(Ix)
     C                   Eval      okhdactn = 'N'
 
      ** No action codes, error
 
     C                   When      sactn = *blanks and sfactn = *blanks
     C                             and sswfref = *blanks
     C                   Eval      error = 'Y'
     C                   Eval      errorprv = 'Y'
 
     C                   Other
 
      ** If valid action code, retrieve CCT header details
 
     C                   If        sactn ='I' or sactn = 'A' or sactn = 'D'
     C                             or sactn = 'C' or sactn ='X'
 
     C     scctid        Chain     FT102HL3                           42
 
     C                   If        *IN42 = *OFF
 
      ** If authorised, you cannot action the CCT
 
     C                   If        auin = 'Y'         OR
     C                             SActn <> 'X'      And
     C                             AUP1 <> *Blanks
     C                   Eval      error = 'Y'
     C                   Eval      errorprv = 'Y'
 
     C                   Add       1             Ix
     C                   Move      'sactn'       FldNameArr(Ix)
     C                   Move      'RFV0091'     MsgIdArr(Ix)
     C                   Eval      okhdactn = 'N'
 
     C                   Else
 
      ** If action code is authorise, user must not be the same as authorise
      ** user on file
 
     C                   If        sactn = 'X'
                                                                                187210
      * Validate user authorisation threshold                                   187210
                                                                                187210
     C                   CallB     'FTVTHHD01'                                  187210
     C                   Parm                    RetCodeIn                      187210
     C                   Parm                    HdrRcdIn                       187210
                                                                                187210
      * Validate header and detail records                                      187210
                                                                                187210
     C                   Movel     *Blanks       ValErrCde        10            187210
     C                   Eval      SavUser = INUSER                             187210
     C                   CallB     'FTM1026VL'                                  187210
     C                   Parm                    ValErrCde        10            187210
     C                   Parm                    Sactn                          187210
     C                   Parm                    HdrRcdIn                       187210
     C                   Parm                    DtlRcdIn                       187210
     C                   Eval      InUser = SavUser                             187210
                                                                                188775
      * Check for insufficient funds                                            188775
                                                                                188775
     C                   EVAL      PRTCD = *BLANKS                              188775
                                                                                188775
     C                   IF        CCTTYP = 'BO' AND                            188775
     C                             VALERRCDE <> '*VALERROR'                     188775
                                                                                188775
     C                   CALLB     'FTVCKIF01'                                  188775
     C                   PARM                    PRTCD                          188775
     C                   PARM      SCCTID        PCCTID                         188775
                                                                                188775
     C                   ENDIF                                                  188775
                                                                                187210
      * If no error and message has been routed from a SWIFT msg                187210
      * check to see if all parts have been processed. If not                   187210
      * then issue warning message - once only - which can be                   187210
      * overridden by pressing <enter>                                          187210
                                                                                187210
     C                   Eval      warncheck = 'Y'                              187210
                                                                                187210
     C                   Select                                                 187210
                                                                                187210
     C                   When      ValErrCde = '*VALERROR'                      187210
     C                   Eval      warncheck = 'N'                              187210
                                                                                188775
     C                   WHEN      PRTCD = '*NOFUNDS'                           188775
     C                   EVAL      WARNCHECK = 'N'                              188775
                                                                                187210
     C                   Endsl                                                  187210
                                                                                187210
     C                   If        warncheck = 'Y'                              187210
     C                   If        firstwarn <> 'Y'                             187210
                                                                                187210
      * Call SR to check if warning message needed only if routed               187210
      * from a SWIFT message.                                                   187210
                                                                                187210
     C                   If        CHMSGR <> 0                                  187210
     C                   Exsr      AllPartsProc                                 187210
     C                   If        allparts = 'N'                               187210
     C                   Eval      warning = 'Y'                                187210
     C                   Endif                                                  187210
     C                   Endif                                                  187210
                                                                                187210
     C                   Endif                                                  187210
     C                   Endif                                                  187210
                                                                                187210
     C                   Select                                                 187210
                                                                                187210
     C                   When      ValErrCde = '*VALERROR'                      187210
     C                   Eval      Error = 'Y'                                  187210
     C                   Eval      Errorprv = 'Y'                               187210
                                                                                187210
     C                   Add       1             Ix                             187210
     C                   Move      'sactn '      FldNameArr(Ix)                 187210
     C                   Move      'RFV0146'     MsgIdArr(Ix)                   187210
     C                   Eval      okhdactn = 'N'                               187210
     C                   Eval      RetCodeIn = *Blanks                                        213056
                                                                                188775
     C                   WHEN      PRTCD = '*NOFUNDS'                           188775
     C                   EVAL      ERROR = 'Y'                                  188775
     C                   EVAL      ERRORPRV = 'Y'                               188775
                                                                                188775
     C                   ADD       1             IX                             188775
     C                   MOVE      'SACTN '      FLDNAMEARR(IX)                 188775
     C                   MOVE      'FTM2412'     MSGIDARR(IX)                   188775
     C                   EVAL      OKHDACTN = 'N'                               188775
     C                   Eval      RetCodeIn = *Blanks                                        213056
                                                                                188775
     C                   When      warning = 'Y'                                187210
     C                   If        firstwarn <> 'Y'                             187210
     C                   Eval      firstwarn  = 'Y'                             187210
                                                                                187210
     C                   Eval      error = 'Y'                                  187210
     C                   Eval      errorprv = 'Y'                               187210
                                                                                187210
     C                   Add       1             Ix                             187210
     C                   Move      'sactn '      FldNameArr(Ix)                 187210
     C                   Move      'RFV0387'     MsgIdArr(Ix)                   187210
     C                   Eval      okhdactn = 'N'                               187210
     C                   Eval      RetCodeIn = *Blanks                                        213056
                                                                                187210
     C                   Else                                                   187210
     C                   Eval      error = 'N'                                  187210
     C                   Eval      RetCodeIn = *blanks                          187210
     C                   Eval      firstwarn  = *blanks                         187210
     C                   Endif                                                  187210
                                                                                187210
     C                   When      psuser = inuser  or                          187210
     C                             psuser = updusr                              187210
                                                                                187210
     C                   Eval      Error = 'Y'                                  187210
     C                   Eval      Errorprv = 'Y'                               187210
                                                                                187210
     C                   Add       1             Ix                             187210
     C                   Move      'sactn '      FldNameArr(Ix)                 187210
     C                   Move      'RFV0075'     MsgIdArr(Ix)                   187210
     C                   Eval      okhdactn = 'N'                               187210
     C                   Eval      RetCodeIn = *Blanks                                        213056
                                                                                187210
     C                   When      RetCodeIn = 'TooSmall'                       187210
                                                                                187210
     C                   Eval      Error = 'Y'                                  187210
     C                   Eval      Errorprv = 'Y'                               187210
                                                                                187210
     C                   Add       1             Ix                             187210
     C                   Move      'sactn '      FldNameArr(Ix)                 187210
     C                   Move      'RFV0142'     MsgIdArr(Ix)                   187210
     C                   Eval      okhdactn = 'N'                               187210
     C                   Eval      RetCodeIn = *Blanks                                        213056
                                                                                187210
     C                   Endsl                                                  187210
                                                                                187210
     C***********        If        psuser = aup1                                187210
     C                   If        psuser = inuser  or                          187210
     C                             psuser = updusr                              187210
 
     C                   Eval      error = 'Y'
     C                   Eval      errorprv = 'Y'
 
     C                   Add       1             Ix
     C                   Move      'sactn'       FldNameArr(Ix)
     C                   Move      'RFV0075'     MsgIdArr(Ix)
     C                   Eval      okhdactn = 'N'
     C                   Eval      RetCodeIn = *Blanks                                        213056
 
      ** No errors in action code
 
     C                   Else
 
     C                   If        Errorprv <> 'Y'
     C                   Eval      Error = 'N'
     C                   Endif
 
     C                   Endif
                                                                                              CSD015
      ** If function code is being monitored by compliance watch and Watch                    CSD015
      ** List Checking Applied                                                                CSD015
                                                                                              CSD015
     C                   If        CSD015 = 'Y' and W1EWLC = 'Y'                              CSD015
     C                             AND ERROR <> 'Y'                                           CSD015
                                                                                              CSD015
     C                   If        CSC011 = 'N' or LIBR = S1MAIN                              CSD015
                                                                                              CSD015
     C                   Eval      KIden = CCTID                                              CSD015
     C                   Eval      KBranch = BRCA                                             CSD015
     C                   Eval      W3UNCF = *Blanks                                           CSD015
     C                                                                                        CSD015
     C     KFuncKey      Chain     SDCWHTL1                           48                      CSD015
                                                                                              CSD015
     C                   If        *IN48 = *Off and W3TREL = 'Y'                              CSD015
     C                             or *IN48 = *On                                             CSD015
     C                   else                                                                 CSD015
                                                                                              CSD015
     C                   Eval      Error = 'Y'                                                CSD015
     C                   Eval      Errorprv = 'Y'                                             CSD015
                                                                                              CSD015
     C                   Add       1             Ix                                           CSD015
     C                   Move      'sactn '      FldNameArr(Ix)                               CSD015
     C                   Move      'RFV0916'     MsgIdArr(Ix)                                 CSD015
     C                   Eval      okhdactn = 'N'                                             CSD015
     C                   Eval      RetCodeIn = *Blanks                                        CSD015
     C                   Endif                                                                CSD015
     C                   Endif                                                                CSD015
     C                   Endif                                                                CSD015
     C                   Endif
     C                   Endif
 
     C                   Else
 
     C                   If        Errorprv <> 'Y'
     C                   Eval      Error = 'N'
     C                   Endif
 
     C                   Endif
 
     C                   Else
 
     C                   If        Errorprv <> 'Y'
     C                   Eval      Error = 'N'
     C                   Endif
 
     C                   Endif
 
     C                   Endsl
 
     C                   Endsr
      /EJECT                                                                    185196
      *****************************************************************         185196
      *                                                               *         185196
      *  AllPartsProc - If message has been routed from a SWIFT       *         185196
      *                 message check that all parts have been        *         185196
      *                 processed.                                    *         185196
      *                                                               *         185196
      *  Called By: ValSubf                                           *         185196
      *  Calls:                                                       *         185196
      *                                                               *         185196
      *                                                               *         185196
      *****************************************************************         185196
                                                                                185196
     C     AllPartsProc  Begsr                                                  185196
                                                                                185196
      ** Get all messages for this RFT                                          185196
     C                   Eval      allparts = 'Y'                               185196
                                                                                185196
      * Setll MEINFTL0 using message unique reference number                    185196
      * For all records with this MUR , is MUR + Part number assigned to this   185196
      * CCTID                                                                   185196
                                                                                185196
     C     CHMSGR        Setll     MEINFTL0                                     185196
     C     CHMSGR        Reade     MEINFTL0                               46    185196
     C     *In46         Doweq     *off                                         185196
     C                   If        FTIPRF <> CCTID                              185196
     C                   Eval      allparts = 'N'                               185196
     C                   Leave                                                  185196
     C                   Endif                                                  185196
                                                                                185196
      ** Now check that each message part matches with a detail record          185196
     C                   Eval      Kcctid = FTIPRF                              185196
     C                   Eval      Kcctmsg = FTMSGR                             185196
     C                   Eval      Kcctmsq = FTKPRT                             185196
                                                                                185196
     C     Kft102dl2     Setll     FT102DL2                               47    185196
                                                                                185196
     C                   If        *In47 = *off                                 185196
     C                   Eval      allparts = 'N'                               185196
     C                   Leave                                                  185196
     C                   Endif                                                  185196
                                                                                185196
     C     CHMSGR        Reade     MEINFTL0                               46    185196
     C                   Enddo                                                  185196
                                                                                185196
     C                   ENDSR                                                  185196
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValUser  - Subroutine to validate User and action Code       *
      *                                                               *
      *  Called By: Validate                                          *
      *  Calls:                                                       *
      *                                                               *
      *                                                               *
      *****************************************************************
     C     ValUser       Begsr
 
     C                   Eval      ValidCode = 'Y'
 
      * Ensure that header action code is valid for the user
 
     C                   If        Sactn <> *Blank
     C                   Call      'ZVACTBU'
     C                   Parm                    Sactn
     C                   Parm                    UserBnch
     C                   Parm                    ActErr
 
     C                   Select
     C                   When      ActErr = 1
     C                   Add       1             Ix
     C                   Move      'sactn'       FldNameArr(Ix)
     C                   Move      'RFV0252'     MsgIdArr(Ix)
     C                   Eval      ValidCode = 'N'
     C                   Eval      okhdactn = 'N'
     C                   Eval      error = 'Y'
     C                   Eval      errorprv = 'Y'
 
     C                   When      ActErr = 2
     C                   Add       1             Ix
     C                   Move      'sactn'       FldNameArr(Ix)
     C                   Move      'RFV0253'     MsgIdArr(Ix)
     C                   Eval      ValidCode = 'N'
     C                   Eval      okhdactn = 'N'
     C                   Eval      error = 'Y'
     C                   Eval      errorprv = 'Y'
 
     C                   Endsl
     C                   EndIf
 
      * Ensure subfile action correct
     C                   If        Sfactn <> *Blank
     C                   Call      'ZVACTBU'
     C                   Parm                    Sfactn
     C                   Parm                    UserBnch
     C                   Parm                    ActErr
 
     C                   Select
     C                   When      ActErr = 1
     C                   Add       1             Ix
     C                   Move      'sfactn'      FldNameArr(Ix)
     C                   Move      'RFV0252'     MsgIdArr(Ix)
     C                   Eval      ValidCode = 'N'
     C                   Eval      oksfactn = 'N'
     C                   Eval      error = 'Y'
     C                   Eval      errorprv = 'Y'
 
     C                   When      ActErr = 2
     C                   Add       1             Ix
     C                   Move      'sfactn'      FldNameArr(Ix)
     C                   Move      'RFV0253'     MsgIdArr(Ix)
     C                   Eval      ValidCode = 'N'
     C                   Eval      oksfactn = 'N'
     C                   Eval      error = 'Y'
     C                   Eval      errorprv = 'Y'
 
     C                   Endsl
     C                   EndIf
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      *  Valcctid - Subroutine to validate CCT id                     *
      *                                                               *
      *  Called By: Validate                                          *
      *  Calls:                                                       *
      *                                                               *
      *                                                               *
      *****************************************************************
 
     C     Valcctid      Begsr
 
     C                   Select
 
      ** CCT Id is mandatory for action code A, E, D, C, X
 
     C                   When      scctid = *blanks
 
     C                   If        sactn = 'A' or sactn = 'E' or
     C                             sactn = 'D' or sactn = 'C' or
     C                             sactn = 'X'
 
     C                   Eval      error = 'Y'
     C                   Eval      errorprv = 'Y'
 
     C                   Add       1             Ix
     C                   Move      'scctid'      FldNameArr(Ix)
     C                   Move      'RFV0092'     MsgIdArr(Ix)
     C                   Eval      okcctd = 'N'
 
     C                   Else
 
     C                   If        Errorprv <> 'Y'
     C                   Eval      Error = 'N'
     C                   Endif
 
     C                   Endif
 
     C                   Other
 
      ** If action code is blank, CCT Id must be blank
 
     C                   If        sactn = *blanks
 
     C                   Eval      error = 'Y'
     C                   Eval      errorprv = 'Y'
 
     C                   Add       1             Ix
     C                   Move      'scctid'      FldNameArr(Ix)
     C                   Move      'RFV0093'     MsgIdArr(Ix)
     C                   Eval      okcctd = 'N'
 
     C                   ELSE
 
     C     scctid        Chain     FT102HL3                           42
 
      ** CCT id not found on file, error
 
     C                   If        *IN42 = *ON
 
     C                   Eval      error = 'Y'
     C                   Eval      errorprv = 'Y'
 
     C                   Add       1             Ix
     C                   Move      'scctid'      FldNameArr(Ix)
     C                   Move      'RFV0094'     MsgIdArr(Ix)
     C                   Eval      okcctd = 'N'
 
     C                   Else
 
     C                   If        Errorprv <> 'Y'
     C                   Eval      Error = 'N'
     C                   Endif
 
     C                   Endif
     C                   Endif
 
     C                   Endsl
 
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValTrnrf - Subroutine to validate transaction reference      *
      *                                                               *
      *  Called By: Validate                                          *
      *  Calls:                                                       *
      *                                                               *
      *                                                               *
      *****************************************************************
 
     C     ValTrnrf      Begsr
 
     C                   Select
 
      ** If CCT id is blank and action code is blank or 'I', transaction
      ** ref must be blank (fil ref must be blank also)
 
     C                   When      scctid = *blanks and strnref <> *blanks
     C                             and sactn = 'I' or
     C                             scctid = *blanks and strnref <> *blanks
     C                             and sactn = *blanks
 
     C                   Eval      Error = 'Y'
     C                   Eval      Errorprv = 'Y'
 
     C                   Add       1             Ix
     C                   Move      'strnref'     FldNameArr(Ix)
     C                   Move      'RFV0069'     MsgIdArr(Ix)
     C                   Eval      oktrrf = 'N'
 
      ** Transaction ref must be blank for acton codes I, C, X
 
     C                   When      scctid <> *blanks and strnref <> *blanks
 
     C                   If        sactn = 'I' or sactn = *blanks or
     C                             sactn = 'X' or sactn = 'C'
 
     C                   Eval      Error = 'Y'
     C                   Eval      Errorprv = 'Y'
 
     C                   Add       1             Ix
     C                   Move      'strnref'     FldNameArr(Ix)
     C                   Move      'RFV0069'     MsgIdArr(Ix)
     C                   Eval      oktrrf = 'N'
 
     C                   Else
 
     C                   Eval      kcctid = scctid
     C                   Eval      ktrnref = strnref
 
     C     kdetail       Chain     FT102Dl0                           43
 
      ** If transaction ref is not on file, error
 
     C                   If        *IN43 = *ON
 
     C                   Eval      Error = 'Y'
     C                   Eval      Errorprv = 'Y'
 
     C                   Add       1             Ix
     C                   Move      'strnref'     FldNameArr(Ix)
     C                   Move      'RFV0070'     MsgIdArr(Ix)
     C                   Eval      oktrrf = 'N'
 
     C                   Else
 
     C                   If        Errorprv <> 'Y'
     C                   Eval      Error = 'N'
     C                   Endif
 
     C                   Endif
     C                   Endif
 
     C                   Other
 
     C                   If        Errorprv <> 'Y'
     C                   Eval      Error = 'N'
     C                   Endif
 
     C                   Endsl
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValSwfrf - Subroutine to validate swift reference            *
      *                                                               *
      *  Called By: Validate                                          *
      *  Calls:                                                       *
      *                                                               *
      *                                                               *
      *****************************************************************
 
     C     ValSwfrf      Begsr
 
     C                   Select
 
      ** '?' can only be entered for action codes, blank and 'I'
 
     C                   When      sswfref = '?'
 
     C                   If        sactn <> *blanks and sactn <> 'I'
 
     C                   Eval      Error = 'Y'
     C                   Eval      Errorprv = 'Y'
 
     C                   Add       1             Ix
     C                   Move      'sswfref'     FldNameArr(Ix)
     C                   Move      'RFV0071'     MsgIdArr(Ix)
     C                   Eval      okswfrf = 'N'
 
     C                   Else
 
     C                   If        Errorprv <> 'Y'
     C                   Eval      Error = 'N'
     C                   Endif
 
     C                   Endif
 
      ** Swift ref can only be entered for action codes, blank and 'I'
 
     C                   When      sswfref <> *blanks
 
     C                   If        sactn <> *blanks and sactn <> 'I'
 
     C                   Eval      Error = 'Y'
     C                   Eval      Errorprv = 'Y'
 
     C                   Add       1             Ix
     C                   Move      'sswfref'     FldNameArr(Ix)
     C                   Move      'RFV0071'     MsgIdArr(Ix)
     C                   Eval      okswfrf = 'N'
 
     C                   Else
 
     C     sswfref       Chain     msixi2l2                           44
 
      ** If swift ref is not on file, error
 
     C                   If        *IN44 = *ON
 
     C                   Eval      error = 'Y'
     C                   Eval      errorprv = 'Y'
 
     C                   Add       1             Ix
     C                   Move      'sswfref'     FldNameArr(Ix)
     C                   Move      'RFV0072'     MsgIdArr(Ix)
     C                   Eval      okswfrf = 'N'
 
     C                   Else
 
     C                   If        errorprv <> 'Y'
     C                   Eval      error = 'N'
     C                   Endif
 
     C                   Endif
     C                   Endif
 
     C                   Endsl
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      *  ClrScreen - Subroutine to clear screen                       *
      *                                                               *
      *  Called By: MAIN                                              *
      *  Calls:                                                       *
      *                                                               *
      *                                                               *
      *****************************************************************
 
     C     ClrScreen     Begsr
 
     C                   Eval      rec = 1
     C                   Eval      sfactn = *blanks
     C                   Eval      sactn = *blanks
     C                   Eval      scctid = *blanks
     C                   Eval      strnref = *blanks
     C                   Eval      sswfref = *blanks
 
     C                   If        *IN05
     C                   Eval      spcctid = *blanks
     C                   Eval      ssfilref = *blanks
     C                   Eval      sssnddst = *blanks
     C                   Eval      ssordcus = *blanks
     C                   Endif
 
     C                   Move      *ALL'Y'       okfile
     C                   Clear                   FldNameArr
     C                   Clear                   MsgIdArr
     C                   Clear                   MsgDtaArr
     C                   MoveA     '00000000'    *IN(50)
 
     C                   If        *INKP
     C                   Select
 
      * All : Show Unauthorised (32)
     C                   When      NOT *IN32 and NOT *IN33 and NOT *IN34
     C                   Eval      *IN32 = *On
 
      * Unauthorised : Show Authorised (33)
     C                   When      *IN32 and NOT *IN33 and NOT *IN34
     C                   Eval      *IN32 = *Off
     C                   Eval      *IN33 = *On
 
      * Authorised : Show Dual Authorisation (34)
     C                   When      NOT *IN32 and *IN33 and NOT *IN34
     C                   Eval      *IN33 = *Off
     C                   Eval      *IN34 = *On
 
      * Dual Authorisation : Show All
     C                   When      NOT *IN32 and NOT *IN33 and *IN34
     C                   Eval      *IN34 = *Off
     C                   Endsl
 
     C                   Endif
 
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
 
     C     *INZSR        Begsr
 
     C     *Entry        Plist
 
      ** OUTPUTS
 
      ** Return Code
     C                   Parm                    RetCodeIn
      ** Action Code
     C                   Parm                    @actn
      ** CCT ID
     C                   Parm                    @cctid
      ** Transaction Reference
     C                   Parm                    @tranref
      ** Swift Reference
     C                   Parm                    @swiftref
      ** Function Keys
     C                   Parm                    @keyp
      ** CCT Type
     C                   Parm                    @ccttype
     C                   Parm                    @FilRef
 
      ** Access Bank Details
 
     C                   Call      'AOBANKR0'
     C                   Parm      '*DBERR '     @rtcd
     C                   Parm      '*FIRST '     @optn
     C     sdbank        Parm      sdbank        dsfdy
 
      ** Database Error
 
     C                   If        @rtcd <> *blanks
     C                   Eval      dbfile = 'SDBANKPD'
     C                   Eval      dbase = 001
     C                   Eval      dbkey = @optn
     C                   Exsr      *PSSR
     C                   Endif
 
      ** Get user default branch
     C                   Call      'AOUSERR0'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm                    PSUser
     C     SDUSER        Parm      SDUSER        DSFDY
 
     C                   IF        @RTCD <> *Blanks
     C                   Eval      DBFILE = 'MUSERDD '
     C                   Eval      DBASE = 002
     C                   Eval      DBKEY = @OPTN
     C                   Exsr      *PSSR
     C                   Else
     C                   Eval      UserBnch = DBRN
     C                   Endif
                                                                                              CSD015
      ** Check if Compliance Watch Enhancement (CSD015) is installed                          CSD015
                                                                                              CSD015
     C                   Eval      CSD015 = 'N'                                               CSD015
                                                                                              CSD015
     C                   CallB     'AOSARDR0'                                                 CSD015
     C                   Parm      *Blanks       PRtCd                                        CSD015
     C                   Parm      '*VERIFY'     POptn                                        CSD015
     C                   Parm      'CSD015'      PSard                                        CSD015
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   If        PRtCd <> *Blanks and                                       CSD015
     C                             PRtCd <> '*NRF'                                            CSD015
     C                   Eval      DBKey = 'CSD015'                                           CSD015
     C                   Eval      DBFile = 'SCSARDPD'                                        CSD015
     C                   Eval      DBase = 003                                                CSD015
     C                   Exsr      *PSSR                                                      CSD015
     C                   EndIf                                                                CSD015
                                                                                              CSD015
     C                   If        PRtCd = *Blanks                                            CSD015
     C                   Eval      CSD015 = 'Y'                                               CSD015
                                                                                              CSD015
     C                   In        SDSTAT                                                     CSD015
                                                                                              CSD015
      ** Check if function code is being monitored by the compliance watch                    CSD015
                                                                                              CSD015
     C                   CallB     'AOWLCCR0'                                                 CSD015
     C                   Parm      *Blanks       PRtCd                                        CSD015
     C                   Parm      '*KEY'        POptn                                        CSD015
     C                   Parm      'CUSTCRTR'    PFunc                                        CSD015
     C     SDWLCC        Parm      SDWLCC        DSFDY                                        CSD015
                                                                                              CSD015
      ** If return code not blank, then issue database error                                  CSD015
                                                                                              CSD015
     C                   If        PRtCd <> *Blanks and PRtCd <> '*NRF'                       CSD015
     C                   Eval      DBKey = 'CUSTCRTR'                                         CSD015
     C                   Eval      DBFile = 'SDWLCCPD'                                        CSD015
     C                   Eval      DBase = 004                                                CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   EndIf                                                                CSD015
                                                                                              CSD015
      ** If return code is blank,                                                             CSD015
                                                                                              CSD015
     C                   If        PRtCd = *Blanks                                            CSD015
     C                   Eval      KFuncCode = 'FT102HPD'                                     CSD015
     C                   EndIf                                                                CSD015
     C                   EndIf                                                                CSD015
                                                                                              CSD015
      ** Check if 24x7 Enhancement (CSC011) is installed                                      CSD015
                                                                                              CSD015
     C                   Eval      CSC011 = 'N'                                               CSD015
                                                                                              CSD015
     C                   CallB     'AOSARDR0'                                                 CSD015
     C                   Parm      *Blanks       PRtCd                                        CSD015
     C                   Parm      '*VERIFY'     POptn                                        CSD015
     C                   Parm      'CSC011'      PSard                                        CSD015
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   If        PRtCd <> *Blanks and PRtCd <> '*NRF'                       CSD015
     C                   Eval      DBKey = 'CSC011'                                           CSD015
     C                   Eval      DBFile = 'SCSARDPD'                                        CSD015
     C                   Eval      DBase = 032                                                CSD015
     C                   Exsr      *PSSR                                                      CSD015
     C                   EndIf                                                                CSD015
                                                                                              CSD015
     C                   If        PRtCd = *Blanks                                            CSD015
     C                   Eval      CSC011 = 'Y'                                               CSD015
     C                   In        SC24X7                                                     CSD015
     C                   Endif                                                                CSD015
 
      ** Key lists
 
      ** Key list for FT102DL0
     C     kdetail       KLIST
     C                   KFLD                    kcctid
     C                   KFLD                    ktrnref
 
      ** Key list for FT102HL5
     C     kposition     KLIST
     C                   KFLD                    kpytp
     C                   KFLD                    kcctid
                                                                                185196
      ** Key list for FT102DL2                                                  185196
                                                                                185196
     C     *Like         Define    CCTID         Kcctid                         185196
     C     *Like         Define    CCTMSG        Kcctmsg                        185196
     C     *Like         Define    CCTMSQ        Kcctmsq                        185196
                                                                                185196
     C     Kft102dl2     KLIST                                                  185196
     C                   KFLD                    Kcctid                         185196
     C                   KFLD                    Kcctmsg                        185196
     C                   KFLD                    Kcctmsq                        185196
                                                                                              CSD015
      ** Key list for SDCWHTL1                                                                CSD015
                                                                                              CSD015
     C     KFuncKey      KLIST                                                                CSD015
     C                   KFLD                    KFuncCode                                    CSD015
     C                   KFLD                    KIden                                        CSD015
     C                   KFLD                    KBranch                                      CSD015
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SE *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     D/COPY FTCPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------
      *
     C                   Eval      PGMQ = '*'
     C                   Eval      type = @ccttype
 
     C                   Endsr                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
