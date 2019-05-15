     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Header browse module')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTM1011BW -  Funds Transfer Browse Function Module           *
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
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 221761             Date 13Apr04               *
      *                 TDA035             Date 02Apr04               *
      *                 213056             Date 09Dec02               *
      *                 CSD015             Date 14Oct02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 188650             Date 07Feb01               *
      *                 188651             Date 06Feb01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 187210             Date 20Nov00               *
      *                 184177             Date 01Nov00               *
      *                 185196             Date 23Oct00               *
      *                 185107             Date 17Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT006  *CREATE    Date 27Sep99               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  221761 - Recompiled due to change made in PF/FT101HPD.       *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  213056 - Initialise RetCodeIn to blanks if error already     *
      *           exists                                              *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  188650 - Allow more than 1 subfile select                    *
      *  188651 - Amend read of header file so displayed in           *
      *           descending order.                                   *
      *  187210 - Correct validation for individual select            *
      *  184177 - Do not clear selection items                        *
      *  185196 - Put out warning message when authorising if routed  *
      *           from SWIFT message and not all parts processed.     *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  CFT006 - Funds Transfer Addition of MT101 and MT102 messages *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
     FFTM1012BDFCF   E             WORKSTN
     F                                     SFILE(FTM1012BSF:RRN)
     FMSIXI2L2  IF   E           K DISK    INFSR(*PSSR)
     FFT101DL0  IF   E           K DISK    INFSR(*PSSR)
     FFT101HL3  IF   E           K DISK    INFSR(*PSSR)
     FFT101HL6  IF   E           K DISK    INFSR(*PSSR) RENAME(FT101HD0:RFT6)
     FFT101HL1  IF   E           K DISK    INFSR(*PSSR) RENAME(FT101HD0:RFTL1)
     FFT101HLB  IF   E           K DISK    INFSR(*PSSR) RENAME(FT101HD0:RFTLB)
     FFT101HL2  IF   E           K DISK    INFSR(*PSSR) RENAME(FT101HD0:RFTL2)
     F* IMM Incoming Msg Control File                                           185196
     FMEINFTL0  IF   E           K DISK    INFSR(*PSSR)                         185196
     F* RFT detail file                                                         185196
     FFT101DL4  IF   E           K DISK    INFSR(*PSSR) RENAME(FT101DD0:RFTL4D) 185196
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
      *       14  Toggle between outgoing/incoming RFT                *
      *       15  Switch between authorised / unauthorised and dual   *
      *                                                               *
      *       24  First time round indicator                          *
      *                                                               *
      *       25  Message subfile                                     *
      *       26  SFLDSP                                              *
      *       27  SFLDSPCTL                                           *
      *       28  SFLCLR                                              *
      *       29  SFLEND                                              *
      *       30  SFLNXTCHG                                           *
      *       31  Toggle between sender/destination                   *
      *                                                               *
      *       40  Read FT101HL6                                       *
      *       41  Readc subfile                                       *
      *       42  Chain FT101HL3                                      *
      *       43  Chain FT101DL0                                      *
      *       44  Chain MSIXI2L2                                      *
      *       45  Write to subfile                                    *
      *       46  Read MEINFTL4                                       *         185196
      *       47  Read FT101DL4                                       *         185196
      *                                                               *
      *       50  Error in Selection fields                           *
      *       51  Error in position fields                            *
      *       52  Error in subfile action code                        *
      *       53  Error in header action code                         *
      *       54  Error in RFT ID                                     *
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      * Header record datastructure
     D HdrRcdIn      E DS                  EXTNAME(FT101HPD)
 
      ** Error array
     D @EI             S              1    DIM(40)
 
      ** OK flags
     D OKFILE        E DS                  EXTNAME(FTE101HBPD)
 
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
     D  DualTxt        C                   'Part Authorised Transactions'
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work fields
     D rrn             S              3  0 INZ(1)
     D error           S              1    INZ('Y')
     D errorprv        S              1    INZ('N')
     D exit            S              1    INZ('N')
     D type            S              2
     D errcnt          S              3  0 INZ(0)
     D actcnt          S              3  0 INZ(0)
     D action          S              1
     D ix              S              3  0
     D c               S              2  0
     D e               S              2  0
     D work1           S              2  0
     D work2           S             35
     D emptysf         S              1
     D firstwarn       S              1                                         185196
     D warning         S              1                                         185196
     D warncheck       S              1                                         185196
     D allparts        S              1                                         185196
 
     D UserBnch        S                   Like(DBRN)
     D ActErr          S              1  0
     D ValidCode       S              1
 
      ** Parameters for ZALIGN
     D zalignok        S              1
     D zfield          S             16
     D zadec           S              1  0
     D zadig           S              2  0
 
      ** *Entry parameters
     D @actn           S              1
     D @rftid          S             15
     D @tranref        S             16
     D @swiftref       S             28
     D @keyp           S              2
     D @rfttype        S              2
 
      ** Key list fields
     D krftid          S             15
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
 
      ** Parameters for QCLSCAN
     D lgthfld         S              3  0
     D start           S              3  0
     D lgthsrch        S              3  0
     D translate       S              1
     D trim            S              1
     D wild            S              1
     D result          S              3  0
                                                                                              CSD015
      ** Variables for CSD015                                                                 CSD015
     D CSC011          S              1                                                       CSD015
     D CSD015          S              1                                                       CSD015
     D PFunc           S              8                                                       CSD015
     D PRtCd           S              7                                                       CSD015
     D POptn           S              7                                                       CSD015
     D PSard           S              6                                                       CSD015
     D KFuncCode       S              8                                                       CSD015
     D KIden           S             40                                                       CSD015
     D KBranch         S              3                                                       CSD015
 
 
     D  SavUser        S                   Like(INUSER)
 
     D Display         S              1    Inz('Y')                             188650
 
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
 
     C                   Dow       exit = 'N'
 
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
      /EJECT                                                              *
      *****************************************************************
      *                                                               *
      *  FillScreen -  Subroutine to fill screen                      *
      *                                                               *
      *  Called By: MAIN                                              *
      *  Calls:                                                       *
      *                                                               *
      *                                                               *
      *****************************************************************
     C     FillScreen    Begsr
 
      ** Clear subfile
 
     C                   Eval      *IN28 = *ON
     C                   Write     ftm1012bct
     C                   Eval      *IN28 = *OFF
 
     C                   Eval      rrn = 1
     C                   Eval      kpytp = type
     C                   Eval      Ix = 0
 
     C                   Select
 
      ** When both of the Selection fields are not blank - error
 
     C                   When      sssnddst <> *BLANKS AND
     C                             ssordcus <> *BLANKS OR
     C                             sssnddst <> *BLANKS AND
     C                             sssndref <> *BLANKS OR
     C                             ssordcus <> *BLANKS AND
     C                             sssndref <> *BLANKS
     C                   Add       1             Ix
     C                   Move      'sssnddst'    FldNameArr(Ix)
     C                   Move      'RFV0061'     MsgIdArr(Ix)
     C                   Eval      oksdord = 'N'
 
     C                   Endsl
 
      ** When RFT id is not blank, position subfile, Else read file from
      ** the beginning
 
     C                   IF        sprftid <> *BLANKS AND sssnddst = *BLANKS
     C                             AND ssordcus = *BLANKS
 
      ** Ensure no blanks at beginning of position fields
 
     C                   Eval      work1 = 0
     C     ' '           Check     sprftid:1     work1
     C                   Subst     sprftid:work1 krftid
 
     C                   Else
     C*******************Eval      krftid = *blanks                             188651
     C                   Eval      krftid = *Hival                              188651
     C                   Endif
 
     C                   Select
     C                   When      NOT *IN32 and NOT *IN33 and NOT *IN34
     C     KPosition     SETLL     FT101HL6
     C     KPYTP         READE     FT101HL6                               40
     C                   When      *IN32
     C     KPosition     Setll     FT101HLB
     C     KPYTP         READE     FT101HLB                               40
     C                   When      *IN33
     C     KPosition     Setll     FT101HL1
     C     KPYTP         READE     FT101HL1                               40
     C                   When      *IN34
     C     KPosition     Setll     FT101HL2
     C     KPYTP         READE     FT101HL2                               40
     C                   Endsl
 
     C                   Dow       *IN40 = *OFF
     C                   Eval      *IN45 = *Off
 
     C                   Select
 
      ** Select on sender/destination
 
     C                   When      sssnddst <> *BLANKS AND
     C                             ssordcus = *BLANKS  AND
     C                             sssndref = *BLANKS
     C                   Call      'QDCXLATE'
     C                   Parm      35            length
     C                   Parm      sssnddst      wsndst
     C                   Parm      'QSYSTRNTBL'  const1
     C                   Parm      'QSYS'        const2
 
      ** Ensure no blanks at beginning of search field
 
     C                   Eval      work1 = 0
     C                   Eval      work2 = wsndst
     C     ' '           Check     work2:1       work1
     C                   Subst     wsndst:work1  wsndst1
     C                   Eval      wsndst = wsndst1
 
      ** Scan for search string
 
     C                   IF        type = 'RI'
 
     C                   Call      'QCLSCAN'
     C                   Parm                    sinst
     C                   Parm      11            lgthfld
     C                   Parm      1             start
     C                   Parm                    wsndst
     C                   Parm      35            lgthsrch
     C                   Parm      '1'           translate
     C                   Parm      '1'           trim
     C                   Parm      '?'           wild
     C                   Parm                    result
 
     C                   Else
 
     C                   Call      'QCLSCAN'
     C*******************Parm                    hacsv1
     C                   Parm                    RFTDST
     C                   Parm      35            lgthfld
     C                   Parm      1             start
     C                   Parm                    wsndst
     C                   Parm      35            lgthsrch
     C                   Parm      '1'           translate
     C                   Parm      '1'           trim
     C                   Parm      '?'           wild
     C                   Parm                    result
     C                   Endif
 
      ** If string found, Write to subfile
 
     C                   IF        result >= 1
     C                   Eval      *IN45 = *ON
     C                   Endif
 
      ** Select on ordering customer
 
     C                   When      sssnddst =  *BLANKS  AND
     C                             ssordcus <> *BLANKS AND
     C                             sssndref =  *BLANKS
 
     C                   Call      'QDCXLATE'
     C                   Parm      35            length
     C                   Parm      ssordcus      wordcus
     C                   Parm      'QSYSTRNTBL'  const1
     C                   Parm      'QSYS'        const2
 
      ** Ensure no blanks beginning of search field
 
     C                   Eval      work1 = 0
     C                   Eval      work2 = wordcus
     C     ' '           Check     work2:1       work1
     C                   Subst     wordcus:work1 wordcus1
     C                   Eval      wordcus = wordcus1
 
      ** Scan for search string
 
     C                   Call      'QCLSCAN'
     C                   Parm                    hocus1
     C                   Parm      35            lgthfld
     C                   Parm      1             start
     C                   Parm                    wordcus
     C                   Parm      35            lgthsrch
     C                   Parm      '1'           translate
     C                   Parm      '1'           trim
     C                   Parm      '?'           wild
     C                   Parm                    result
 
      ** If string found, Write to subfile
 
     C                   IF        result >= 1
     C                   Eval      *IN45 = *ON
     C                   Endif
 
 
      ** Select on senders reference
 
     C                   When      sssnddst =  *BLANKS  AND
     C                             ssordcus =  *BLANKS AND
     C                             sssndref <> *BLANKS
 
     C                   Call      'QDCXLATE'
     C                   Parm      16            length
     C                   Parm      sssndref      wordcus
     C                   Parm      'QSYSTRNTBL'  const1
     C                   Parm      'QSYS'        const2
 
      ** Ensure no blanks beginning of search field
 
     C                   Eval      work1 = 0
     C                   Eval      work2 = wordcus
     C     ' '           Check     work2:1       work1
     C                   Subst     wordcus:work1 wordcus1
     C                   Eval      wordcus = wordcus1
 
      ** Scan for search string
 
     C                   Call      'QCLSCAN'
     C                   Parm                    sndref
     C                   Parm      16            lgthfld
     C                   Parm      1             start
     C                   Parm                    wordcus
     C                   Parm      16            lgthsrch
     C                   Parm      '1'           translate
     C                   Parm      '1'           trim
     C                   Parm      '?'           wild
     C                   Parm                    result
 
      ** If string found, Write to subfile
 
     C                   IF        result >= 1
     C                   Eval      *IN45 = *ON
     C                   Endif
 
     C                   OTHER
 
     C                   Eval      *IN45 = *ON
 
     C                   Endsl
 
     C                   If        Pytp <> type
     C                   Eval      *IN45 = *Off
     C                   Endif
 
 
      ** Write to the subfile
 
     C                   IF        *IN45 = *ON
     C                   Eval      sfrftid = rftid
     C                   Eval      sfsndref = sndref
 
     C                   IF        type = 'RI'
     C                   Eval      sfsnddst = sinst
     C                   Else
     C                   Eval      sfsnddst = rftdst
     C                   Endif
 
     C                   Eval      sfordcus = hocus1
     C                   Write     ftm1012bsf
     C                   Add       1             rrn
     C                   Endif
 
     C                   Select
     C                   When      NOT *IN32 and NOT *IN33 and NOT *IN34
     C     KPYTP         READE     FT101HL6                               40
     C                   When      *IN32
     C     KPYTP         READE     FT101HLB                               40
     C                   When      *IN33
     C     KPYTP         READE     FT101HL1                               40
     C                   When      *IN34
     C     KPYTP         READE     FT101HL2                               40
     C                   Endsl
 
     C                   Enddo
     C                   ENDSR
      /EJECT                                                              *
      *****************************************************************
      *                                                               *
      *  ShowScreen -  Subroutine to show screen                      *
      *                                                               *
      *  Called By: MAIN                                              *
      *  Calls:                                                       *
      *                                                               *
      *                                                               *
      *****************************************************************
     C     ShowScreen    Begsr
 
     C*******************IF        rrn = 1                                      188650
     C                   IF        rrn = 1 and Display = 'Y'                    188650
     C                   Eval      *IN26 = *OFF
     C                   Eval      emptysf = 'Y'
     C                   Else
     C                   Eval      *IN26 = *ON
     C                   Eval      emptysf = 'N'
     C                   Endif
 
     C                   Eval      *IN27 = *ON
     C                   Eval      *IN29 = *ON
     C                   Eval      error = 'Y'
 
     C                   IF        type = 'RI'
     C                   Eval      *IN31 = *OFF
     C                   Else
     C                   Eval      *IN31 = *ON
     C                   Endif
 
      ** Loop until there are no errors
 
     C                   Dow       error = 'Y'
 
      ** Move ok flags into array
 
     C                   MoveA     okfile        @ei
 
      ** Set screen error indicators according to status of ok flags
 
     C                   Eval      c = 1
     C                   Eval      e = 50
 
     C                   Dow       c <=40
 
     C                   IF        @ei(c) = 'N' OR @ei(c) = 'W'
     C                   Eval      *IN(e) = *ON
     C                   Endif
 
     C                   Add       1             c
     C                   Add       1             e
 
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
     C                   EXFMT     ftm1012bct
     C                   Endif                                                  188650
 
      ** Process screen
 
     C                   Exsr      ProcScreen
 
     C                   Enddo
      *
     C                   ENDSR
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **--------------------------------------------------------------------------------------------
      /EJECT                                                              *
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
     C                   Eval      error = 'N'
     C                   Eval      exit  = 'Y'
     C                   Eval      @keyp = '03'
 
      ** When F5 is pressed, refresh
 
     C                   When      *IN05 = *ON
     C                   Eval      error = 'N'
     C                   Eval      Actcnt = 0                                   188650
 
      ** When F12 is pressed, exit
 
     C                   When      *IN12 = *ON
     C                   Eval      error = 'N'
     C                   Eval      exit  = 'Y'
     C                   Eval      @keyp = '12'
 
      ** When F14 is pressed, toggle between incoming/outgoing RFT
 
     C                   When      *IN14 = *ON
     C                   Eval      error = 'N'
 
     C                   IF        type = 'RI'
     C                   Eval      type = 'RO'
     C                   Else
     C                   Eval      type = 'RI'
     C                   Endif
 
     C                   OTHER
 
      ** Validate screen
 
     C                   Exsr      Validate
 
     C                   Endsl
 
     C                   ENDSR
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
     C                   MoveA     '0000000'     *IN(50)
     C                   Eval      errcnt = 0
     C                   Eval      actcnt = 0
     C                   Eval      errorprv = 'N'
     C                   Eval      action = *BLANKS
     C                   Move      *ALL'Y'       okfile
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   MsgDtaArr
 
      ** Validate subfile action code
 
     C                   IF        emptysf = 'N'
     C                   Exsr      ValSubf
     C                   Endif
 
      ** Validate User
     C                   Exsr      ValUser
 
      ** Validate action code
 
     C                   If        ValidCode = 'Y'
     C                   Exsr      ValActcd
     C                   Endif
 
      ** Validate RFT Id
 
     C                   Exsr      ValRftid
 
      ** Validate transaction reference
 
     C                   Exsr      ValTrnrf
 
      ** Validate swift reference
 
     C                   Exsr      ValSwfrf
 
     C                   Select
 
      ** When screen fields are all blank, reload subfile
 
     C                   When      error = 'Y' AND action = *BLANKS AND
     C                             sactn =*BLANKS
     C                             AND sswfref = *BLANKS AND
     C                             srftid = *BLANKS AND strnref = *BLANKS
     C                   Eval      error = 'N'
 
      ** If there are no errors, fill parameters to pass back to controlling
      ** module, exit
 
     C                   When      error = 'N'
     C                   Eval      exit = 'Y'
     C                   Eval      RetCodeIn = *BLANKS
     C                   Move      *ALL'Y'       okfile
     C                   Eval      Ix = 0
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   MsgDtaArr
 
     C                   IF        sfactn <> *BLANKS
     C                   Eval      @actn = sfactn
     C                   Eval      @rftid = sfrftid
     C                   Eval      @tranref = *BLANKS
     C                   Eval      @swiftref = *BLANKS
     C                   Eval      @keyp = *BLANKS
 
     C                   Else
 
     C                   IF        sactn <> *BLANKS
     C                   Eval      @actn = sactn
     C                   Else
     C                   Eval      @actn = 'I'
     C                   Endif
 
     C                   Eval      @rftid = srftid
     C                   Eval      @tranref = strnref
     C                   Eval      @swiftref = sswfref
     C                   Eval      @keyp = *BLANKS
     C                   Endif
 
     C                   IF        @actn = 'I' AND @rftid = *BLANKS
 
      ** If the swift reference is not blank then default message type to
      ** 'incoming' since most will be this and no other way to determine
 
     C                   IF        @swiftref <> *BLANKS
     C                   Eval      @rfttype = 'RI'
     C                   Else
     C                   Eval      @rfttype = type
     C                   Endif
 
     C                   Else
     C                   Eval      @rfttype = *blanks
     C                   Endif
 
     C                   Endsl
 
     C                   ENDSR
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
 
     C                   READC     ftm1012bsf                             41
 
     C                   Dow       *IN41 = *OFF
 
     C                   Select
 
      ** Valid action code
 
     C                   When      sfactn = 'I' OR sfactn = 'C' OR
     C                             sfactn = 'A' OR sfactn = 'D' OR
     C                             sfactn = 'E' OR sfactn = 'X'
 
     C                   Add       1             actcnt
 
     C                   IF        actcnt = 1
     C                   Eval      rec = rrn
     C                   Eval      action = 'Y'
     C                   Endif
 
      ** More than one action code, error
 
     C*******************IF        actcnt > 1 OR actcnt = 1 AND                 188650
     C                   IF        actcnt = 1 AND                               188650
     C                             sactn <> *BLANKS OR actcnt =1 AND
     C                             sactn = *BLANKS AND sswfref <> *BLANKS
     C                   Eval      *IN52 = *ON
     C                   Endif
 
     C                   Eval      *IN30 = *ON
     C                   UPDATE    ftm1012bsf
     C                   Eval      *IN30 = *OFF
     C                   Eval      *IN52 = *OFF
 
     C                   READC     ftm1012bsf                             41
 
      ** Invalid action code
 
     C                   When      sfactn <> 'I' AND sfactn <> 'C' AND
     C                             sfactn <> 'A' AND sfactn <> 'D' AND
     C                             sfactn <> 'E' AND sfactn <> 'X' AND
     C                             sfactn <> *BLANKS
      *
     C                   Add       1             errcnt
     C                   Add       1             actcnt
      *
     C                   IF        errcnt = 1 and actcnt = 1
     C                   Eval      rec = rrn
     C                   Eval      action = 'Y'
     C                   Endif
      *
     C                   Eval      *IN30 = *ON
     C                   Eval      *IN52 = *ON
     C                   UPDATE    ftm1012bsf
     C                   Eval      *IN30 = *OFF
     C                   Eval      *IN52 = *OFF
     C
     C                   READC     ftm1012bsf                             41
     C                   OTHER
 
      ** Selection is  blank
 
     C                   Eval      *IN30 = *OFF
     C                   UPDATE    ftm1012bsf
     C                   READC     ftm1012bsf                             41
 
     C                   Endsl
 
     C                   Enddo
 
     C                   Select
 
      ** More than one action code, error
 
     C*******************When      actcnt > 1 OR actcnt =1 AND                  188650
     C                   When      actcnt =1 AND                                188650
     C                             sactn <> *BLANKS OR actcnt =1 AND
     C                             sactn = *BLANKS AND sswfref <> *BLANKS
 
     C                   Add       1             Ix
     C                   Move      'sfactn'      FldNameArr(Ix)
     C                   Move      'RFV0063'     MsgIdArr(Ix)
     C                   Eval      oksfactn = 'N'
 
     C                   READC     ftm1012bsf                             41
 
     C                   Eval      *IN30 = *ON
     C                   Eval      *IN52 = *ON
     C                   UPDATE    ftm1012bsf
     C                   Eval      *IN30 = *OFF
     C                   Eval      *IN52 = *OFF
 
     C                   Eval      error = 'Y'
     C                   Eval      errorprv = 'Y'
 
      ** If invalid action code, error
 
     C                   When      errcnt > 0
 
     C                   Add       1             Ix
     C                   Move      'sfactn'      FldNameArr(Ix)
     C                   Move      'RFV0064'     MsgIdArr(Ix)
     C                   Eval      oksfactn = 'N'
 
     C                   Eval      error = 'Y'
     C                   Eval      errorprv = 'Y'
 
     C                   OTHER
 
     C                   READC     ftm1012bsf                             41
 
      ** If valid action code, retrieve rft header details
 
     C                   IF        sfactn ='I' OR sfactn = 'A'
     C                             OR sfactn = 'C' OR sfactn ='X'
     C                             OR sfactn = 'D'
 
     C     sfrftid       CHAIN     FT101HL3                           42
 
     C                   IF        *IN42 = *OFF
 
      ** If authorised, you cannot action the RFT
 
     C                   IF        auin = 'Y'       OR
     C                             SfActn <> 'X'    And
     C                             AUP1 <> *Blanks
 
     C                   Eval      error = 'Y'
     C                   Eval      errorprv = 'Y'
 
     C                   Add       1             Ix
     C                   Move      'sfactn'      FldNameArr(Ix)
     C                   Move      'RFV0065'     MsgIdArr(Ix)
     C                   Eval      oksfactn = 'N'
 
     C                   Eval      *IN30 = *ON
     C                   Eval      *IN52 = *ON
     C                   UPDATE    ftm1012bsf
     C                   Eval      *IN30 = *OFF
     C                   Eval      *IN52 = *OFF
 
     C                   Else
 
      ** If action code is authorise, user must not be the same as authorise
      ** user on file
 
     C                   IF        sfactn = 'X'
 
      * Validate user authorisation threshold
     C                   CallB     'FTVTHTH01'
     C                   Parm                    RetCodeIn
     C                   Parm                    HdrRcdIn
 
      * Validate header and detail records
 
     C                   Eval      SavUser = InUser
     C                   CallB     'FTM1016VL'
     C                   Parm                    ValErrCde        10
     C                   Parm                    SfActn
     C                   Parm                    HdrRcdIn
     C                   Eval      Inuser = SavUser
 
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
                                                                                185196
     C                   Endsl                                                  185196
                                                                                185196
     C                   If        warncheck = 'Y'                              185196
     C                   If        firstwarn <> 'Y'                             185196
                                                                                185196
      * Call SR to check if warning message needed only if routed               185196
      * from a SWIFT message.                                                   185196
                                                                                185196
     C                   If        RHMSGR <> 0                                  185196
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
     C                   Eval      error = 'Y'
     C                   Eval      errorprv = 'Y'
 
     C                   Add       1             Ix
     C                   Move      'sfactn'      FldNameArr(Ix)
     C                   Move      'RFV0146'     MsgIdArr(Ix)
     C                   Eval      oksfactn = 'N'
 
     C                   Eval      *IN30 = *ON
     C                   Eval      *IN52 = *ON
     C                   UPDATE    ftm1012bsf
     C                   Eval      RetCodeIn = *Blanks                                        213056
     C                   Eval      *IN30 = *OFF
     C                   Eval      *IN52 = *OFF
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
     C                   UPDATE    ftm1012bsf                                   185196
     C                   Eval      RetCodeIn = *Blanks                                        213056
     C                   Eval      *IN30 = *OFF                                 185196
     C                   Eval      *IN52 = *OFF                                 185196
     C                   Else                                                   185196
     C                   Eval      error = 'N'                                  185196
     C                   Eval      RetCodeIn = *blanks                          185196
     C                   Eval      firstwarn  = *blanks                         185196
     C                   Endif                                                  185196
 
 
     C                   When      psuser = inuser OR
     C                             psuser = updusr
 
     C                   Eval      error = 'Y'
     C                   Eval      errorprv = 'Y'
 
     C                   Add       1             Ix
     C                   Move      'sfactn'      FldNameArr(Ix)
     C                   Move      'RFV0075'     MsgIdArr(Ix)
     C                   Eval      oksfactn = 'N'
 
     C                   Eval      *IN30 = *ON
     C                   Eval      *IN52 = *ON
     C                   UPDATE    ftm1012bsf
     C                   Eval      RetCodeIn = *Blanks                                        213056
     C                   Eval      *IN30 = *OFF
     C                   Eval      *IN52 = *OFF
 
     C                   When      RetCodeIn = 'TooSmall'
 
     C                   Eval      error = 'Y'
     C                   Eval      errorprv = 'Y'
 
     C                   Add       1             Ix
     C                   Move      'sfactn'      FldNameArr(Ix)
     C                   Move      'RFV0142'     MsgIdArr(Ix)
     C                   Eval      oksfactn = 'N'
 
     C                   Eval      *IN30 = *ON
     C                   Eval      *IN52 = *ON
     C                   UPDATE    ftm1012bsf
     C                   Eval      RetCodeIn = *Blanks                                        213056
     C                   Eval      *IN30 = *OFF
     C                   Eval      *IN52 = *OFF
 
     C                   Other
 
      ** No errors in subfile action code
 
     C                   Eval      error = 'N'
     C                   Endsl
                                                                                              CSD015
      ** If function code is being monitored by compliance watch and Watch                    CSD015
      ** List Checking Applied                                                                CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y' and W1EWLC = 'Y'                              CSD015
     C                             AND ERROR <> 'Y'                                           CSD015
                                                                                              CSD015
     C                   If        CSC011 = 'N' or Libr = S1Main                              CSD015
                                                                                              CSD015
     C                   Eval      KIden = RFTID                                              CSD015
     C                   Eval      KBranch = BRCA                                             CSD015
     C                   Eval      W3UNCF = *Blanks                                           CSD015
                                                                                              CSD015
     C     KFuncKey      Chain     SDCWHTL1                           48                      CSD015
                                                                                              CSD015
     C                   If        *IN48 = *Off and W3TREL = 'Y' or                           CSD015
     C                             *IN48 = *On                                                CSD015
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
     C                   Update    ftm1012bsf                                                 CSD015
     C                   Eval      RetCodeIn = *Blanks                                        CSD015
     C                   Eval      *IN30 = *OFF                                               CSD015
     C                   Eval      *IN52 = *OFF                                               CSD015
     C                   Endif                                                                CSD015
     C                   Endif                                                                CSD015
     C                   Endif                                                                CSD015
 
     C                   Endif
     C                   Endif
 
     C                   Else
     C                   Eval      error = 'N'
     C                   Endif
 
     C                   Else
     C                   Eval      error = 'N'
     C                   Endif
 
     C                   Endsl
 
     C                   ENDSR
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
 
     C                   When      action = 'Y' AND sactn <> *BLANKS OR
     C                             action = 'Y' AND sactn = *BLANKS AND
     C                             sswfref <> *BLANKS
 
     C                   Eval      error = 'Y'
     C                   Eval      errorprv = 'Y'
 
     C                   Add       1             Ix
     C                   Move      'sactn'       FldNameArr(Ix)
     C                   Move      'RFV0063'     MsgIdArr(Ix)
     C                   Eval      okhdactn = 'N'
 
      ** Invalid action code, error
 
     C                   When      sactn <>'I' AND sactn <> 'C' AND
     C                             sactn <> 'A' AND sactn <> 'D' AND
     C                             sactn <> 'E' AND sactn <> 'X' AND
     C                             sactn <> *BLANKS
 
     C                   Eval      error = 'Y'
     C                   Eval      errorprv = 'Y'
 
     C                   Add       1             Ix
     C                   Move      'sactn'       FldNameArr(Ix)
     C                   Move      'RFV0064'     MsgIdArr(Ix)
     C                   Eval      okhdactn = 'N'
 
      ** No action codes, error
 
     C                   When      sactn = *BLANKS AND sfactn = *BLANKS
     C                             AND sswfref = *BLANKS
     C                   Eval      error = 'Y'
     C                   Eval      errorprv = 'Y'
 
     C                   OTHER
 
 
      ** If valid action code, retrieve rft header details
 
     C                   IF        sactn ='I' OR sactn = 'A' OR sactn = 'D'
     C                             OR sactn = 'C' OR sactn ='X'
 
     C     srftid        CHAIN     FT101HL3                           42
 
     C                   IF        *IN42 = *OFF
 
      ** If authorised, you cannot action the RFT
 
     C                   IF        auin = 'Y'        Or
     C                             SActn <> 'X'     And
     C                             AUP1 <> *Blanks
 
     C                   Eval      error = 'Y'
     C                   Eval      errorprv = 'Y'
 
     C                   Add       1             Ix
     C                   Move      'sactn'       FldNameArr(Ix)
     C                   Move      'RFV0065'     MsgIdArr(Ix)
     C                   Eval      okhdactn = 'N'
 
     C                   Else
 
      ** If action code is authorise, user must not be the same as authorise
      ** user on file
 
     C                   IF        sactn = 'X'
                                                                                187210
      * Validate user authorisation threshold                                   187210
     C                   CallB     'FTVTHTH01'                                  187210
     C                   Parm                    RetCodeIn                      187210
     C                   Parm                    HdrRcdIn                       187210
                                                                                187210
      * Validate header and detail records                                      187210
                                                                                187210
     C                   Eval      SavUser = InUser                             187210
     C                   CallB     'FTM1016VL'                                  187210
     C                   Parm                    ValErrCde        10            187210
     C                   Parm                    Sactn                          187210
     C                   Parm                    HdrRcdIn                       187210
     C                   Eval      Inuser = SavUser                             187210
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
                                                                                187210
     C                   Endsl                                                  187210
                                                                                187210
     C                   If        warncheck = 'Y'                              187210
     C                   If        firstwarn <> 'Y'                             187210
                                                                                187210
      * Call SR to check if warning message needed only if routed               187210
      * from a SWIFT message.                                                   187210
                                                                                187210
     C                   If        RHMSGR <> 0                                  187210
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
     C                   Eval      error = 'Y'                                  187210
     C                   Eval      errorprv = 'Y'                               187210
                                                                                187210
     C                   Add       1             Ix                             187210
     C                   Move      'sactn '      FldNameArr(Ix)                 187210
     C                   Move      'RFV0146'     MsgIdArr(Ix)                   187210
     C                   Eval      okhdactn = 'N'                               187210
     C                   Eval      RetCodeIn = *Blanks                                        213056
                                                                                187210
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
     C                   Else                                                   187210
     C                   Eval      error = 'N'                                  187210
     C                   Eval      RetCodeIn = *blanks                          187210
     C                   Eval      firstwarn  = *blanks                         187210
     C                   Endif                                                  187210
                                                                                187210
                                                                                187210
     C                   When      psuser = inuser OR                           187210
     C                             psuser = updusr                              187210
                                                                                187210
     C                   Eval      error = 'Y'                                  187210
     C                   Eval      errorprv = 'Y'                               187210
                                                                                187210
     C                   Add       1             Ix                             187210
     C                   Move      'sactn '      FldNameArr(Ix)                 187210
     C                   Move      'RFV0075'     MsgIdArr(Ix)                   187210
     C                   Eval      okhdactn = 'N'                               187210
     C                   Eval      RetCodeIn = *Blanks                                        213056
                                                                                187210
     C                   When      RetCodeIn = 'TooSmall'                       187210
                                                                                187210
     C                   Eval      error = 'Y'                                  187210
     C                   Eval      errorprv = 'Y'                               187210
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
 
     C                   IF        errorprv <> 'Y'
     C                   Eval      error = 'N'
     C                   Endif
 
     C                   Endif
                                                                                              CSD015
      ** If function code is being monitored by compliance watch and Watch                    CSD015
      ** List Checking Applied                                                                CSD015
                                                                                              CSD015
     C                   If        CSD015 = 'Y' and W1EWLC = 'Y'                              CSD015
     C                             AND ERROR <> 'Y'                                           CSD015
                                                                                              CSD015
     C                   If        CSC011 = 'N' or Libr = S1Main                              CSD015
                                                                                              CSD015
     C                   Eval      KIden = RFTID                                              CSD015
     C                   Eval      KBranch = BRCA                                             CSD015
     C                   Eval      W3UNCF = *Blanks                                           CSD015
                                                                                              CSD015
     C     KFuncKey      Chain     SDCWHTL1                           48                      CSD015
                                                                                              CSD015
     C                   If        *IN48 = *Off and W3TREL = 'Y'                              CSD015
     C                             or *IN48 = *On                                             CSD015
     C                   else                                                                 CSD015
                                                                                              CSD015
     C                   Eval      error = 'Y'                                                CSD015
     C                   Eval      errorprv = 'Y'                                             CSD015
                                                                                              CSD015
     C                   Add       1             Ix                                           CSD015
     C                   Move      'sactn'       FldNameArr(Ix)                               CSD015
     C                   Move      'RFV0916'     MsgIdArr(Ix)                                 CSD015
     C                   Eval      okhdactn = 'N'                                             CSD015
     C                   Eval      RetCodeIn = *Blanks                                        CSD015
     C                   Endif                                                                CSD015
     C                   Endif                                                                CSD015
     C                   Endif                                                                CSD015
     C                   Endif
     C                   Endif
 
     C                   Else
 
     C                   IF        errorprv <> 'Y'
     C                   Eval      error = 'N'
     C                   Endif
 
     C                   Endif
 
     C                   Else
 
     C                   IF        errorprv <> 'Y'
     C                   Eval      error = 'N'
     C                   Endif
 
     C                   Endif
 
     C                   Endsl
 
     C                   ENDSR
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
      * Setll MEINFTL0 using message unique reference number                    185196
      * For all records with this MUR , is MUR + Part number assigned to this   185196
      * RFTID                                                                   185196
                                                                                185196
     C     RHMSGR        Setll     MEINFTL0                                     185196
     C     RHMSGR        Reade     MEINFTL0                               46    185196
     C     *In46         Doweq     *off                                         185196
     C                   If        FTIPRF <> RFTID                              185196
     C                   Eval      allparts = 'N'                               185196
     C                   Leave                                                  185196
     C                   Endif                                                  185196
                                                                                185196
      ** Now check that each message part matches with a detail record          185196
     C                   Eval      Krftid = FTIPRF                              185196
     C                   Eval      Krftmsg = FTMSGR                             185196
     C                   Eval      Krftmsq = FTKPRT                             185196
                                                                                185196
     C     Kft101dl4     Setll     FT101DL4                               47    185196
                                                                                185196
     C                   If        *In47 = *off                                 185196
     C                   Eval      allparts = 'N'                               185196
     C                   Leave                                                  185196
     C                   Endif                                                  185196
                                                                                185196
     C     RHMSGR        Reade     MEINFTL0                               46    185196
     C                   Enddo                                                  185196
                                                                                185196
     C                   ENDSR                                                  185196
      /EJECT                                                                    185196
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
      *  ValRftid - Subroutine to validate rft id                     *
      *                                                               *
      *  Called By: Validate                                          *
      *  Calls:                                                       *
      *                                                               *
      *                                                               *
      *****************************************************************
     C     ValRftid      Begsr
 
     C                   Select
 
      ** RFT Id is mandatory for action code A, E, D, C, X
 
     C                   When      srftid = *BLANKS
 
     C                   IF        sactn = 'A' OR sactn = 'E' OR
     C                             sactn = 'D' OR sactn = 'C' OR
     C                             sactn = 'X'
 
     C                   Eval      error = 'Y'
     C                   Eval      errorprv = 'Y'
 
     C                   Add       1             Ix
     C                   Move      'srftid'      FldNameArr(Ix)
     C                   Move      'RFV0066'     MsgIdArr(Ix)
     C                   Eval      okrftd = 'N'
 
     C                   Else
 
     C                   IF        errorprv <> 'Y'
     C                   Eval      error = 'N'
     C                   Endif
 
     C                   Endif
 
     C                   OTHER
 
      ** If action code is blank, RFT Id must be blank
 
     C                   IF        sactn = *BLANKS
 
     C                   Eval      error = 'Y'
     C                   Eval      errorprv = 'Y'
 
     C                   Add       1             Ix
     C                   Move      'srftid'      FldNameArr(Ix)
     C                   Move      'RFV0067'     MsgIdArr(Ix)
     C                   Eval      okrftd = 'N'
 
     C                   Else
 
     C     srftid        CHAIN     FT101HL3                           42
 
      ** RFT id not found on file, error
 
     C                   IF        *IN42 = *ON
 
     C                   Eval      error = 'Y'
     C                   Eval      errorprv = 'Y'
 
     C                   Add       1             Ix
     C                   Move      'srftid'      FldNameArr(Ix)
     C                   Move      'RFV0068'     MsgIdArr(Ix)
     C                   Eval      okrftd = 'N'
 
     C                   Else
 
     C                   IF        errorprv <> 'Y'
     C                   Eval      error = 'N'
     C                   Endif
 
     C                   Endif
     C                   Endif
 
     C                   Endsl
 
     C                   ENDSR
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
 
      ** If RFT id is blank and action code is blank or 'I', transaction
      ** ref must be blank
 
     C                   When      srftid = *BLANKS AND strnref <> *BLANKS
     C                             AND sactn = 'I' OR
     C                             srftid = *BLANKS AND strnref <> *BLANKS
     C                             AND sactn = *BLANKS
 
     C                   Eval      error = 'Y'
     C                   Eval      errorprv = 'Y'
 
     C                   Add       1             Ix
     C                   Move      'strnref'     FldNameArr(Ix)
     C                   Move      'RFV0069'     MsgIdArr(Ix)
     C                   Eval      oktrrf = 'N'
 
 
      ** Transaction ref must be blank for acton codes I, C, X
 
     C                   When      srftid <> *BLANKS AND strnref <> *BLANKS
 
     C                   IF        sactn = 'I' OR sactn = *BLANKS OR
     C                             sactn = 'X' OR sactn = 'C'
 
     C                   Eval      error = 'Y'
     C                   Eval      errorprv = 'Y'
 
     C                   Add       1             Ix
     C                   Move      'strnref'     FldNameArr(Ix)
     C                   Move      'RFV0069'     MsgIdArr(Ix)
     C                   Eval      oktrrf = 'N'
 
     C                   Else
 
     C                   Eval      krftid = srftid
     C                   Eval      ktrnref = strnref
 
     C     kdetail       CHAIN     FT101Dl0                           43
 
      ** If transaction ref is not on file, error
 
     C                   IF        *IN43 = *ON
 
     C                   Eval      error = 'Y'
     C                   Eval      errorprv = 'Y'
 
     C                   Add       1             Ix
     C                   Move      'strnref'     FldNameArr(Ix)
     C                   Move      'RFV0070'     MsgIdArr(Ix)
     C                   Eval      oktrrf = 'N'
 
     C                   Else
 
     C                   IF        errorprv <> 'Y'
     C                   Eval      error = 'N'
     C                   Endif
 
     C                   Endif
     C                   Endif
 
     C                   OTHER
 
     C                   IF        errorprv <> 'Y'
     C                   Eval      error = 'N'
     C                   Endif
 
     C                   Endsl
     C                   ENDSR
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
 
     C                   IF        sactn <> *BLANKS AND sactn <> 'I'
 
     C                   Eval      error = 'Y'
     C                   Eval      errorprv = 'Y'
 
     C                   Add       1             Ix
     C                   Move      'sswfref'     FldNameArr(Ix)
     C                   Move      'RFV0071'     MsgIdArr(Ix)
     C                   Eval      okswfrf = 'N'
 
     C                   Else
 
     C                   IF        errorprv <> 'Y'
     C                   Eval      error = 'N'
     C                   Endif
 
     C                   Endif
 
      ** Swift ref can only be entered for action codes, blank and 'I'
 
     C                   When      sswfref <> *BLANKS
 
     C                   IF        sactn <> *BLANKS AND sactn <> 'I'
 
     C                   Eval      error = 'Y'
     C                   Eval      errorprv = 'Y'
 
     C                   Add       1             Ix
     C                   Move      'sswfref'     FldNameArr(Ix)
     C                   Move      'RFV0071'     MsgIdArr(Ix)
     C                   Eval      okswfrf = 'N'
 
     C                   Else
 
     C     sswfref       CHAIN     msixi2l2                           44
 
      ** If swift ref is not on file, error
 
     C                   IF        *IN44 = *ON
 
     C                   Eval      error = 'Y'
     C                   Eval      errorprv = 'Y'
 
     C                   Add       1             Ix
     C                   Move      'sswfref'     FldNameArr(Ix)
     C                   Move      'RFV0072'     MsgIdArr(Ix)
     C                   Eval      okswfrf = 'N'
 
     C                   Else
 
     C                   IF        errorprv <> 'Y'
     C                   Eval      error = 'N'
     C                   Endif
 
     C                   Endif
     C                   Endif
 
     C                   Endsl
     C                   ENDSR
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
     C*******************Eval      srftid = *blanks                             184177
     C*******************Eval      strnref = *blanks                            184177
 
     C*******************IF        *IN05 = *ON OR *IN14 =*ON
     C                   IF        *IN05 = *ON                                  184177
     C                   Eval      sprftid = *blanks
     C                   Eval      sssndref = *blanks
     C                   Eval      sssnddst = *blanks
     C                   Eval      ssordcus = *blanks
     C                   Endif
 
     C                   IF        *IN24 = *OFF
     C                   Eval      sswfref = *blanks
     C                   Move      *ALL'Y'       okfile
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   MsgDtaArr
     C                   MoveA     '0000000'     *IN(50)
     C                   Endif
 
     C                   Eval      *IN24 = *OFF
 
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
 
     C                   ENDSR
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
 
     C     *Entry        PLIST
 
      ** OUTPUTS
 
      ** Return Code
     C                   Parm                    RetCodeIn
      ** Action Code
     C                   Parm                    @actn
      ** RFT ID
     C                   Parm                    @rftid
      ** Transaction Reference
     C                   Parm                    @tranref
      ** Swift Reference
     C                   Parm                    @swiftref
      ** Function Keys
     C                   Parm                    @keyp
      ** RFT Type
     C                   Parm                    @rfttype
      ** OK file
     C                   Parm                    okfile
      ** Errors
     C                   Parm                    ix
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIdArr
     C                   Parm                    MsgDtaArr
 
      ** Access Bank Details
 
     C                   Call      'AOBANKR0'
     C                   Parm      '*DBERR '     @rtcd
     C                   Parm      '*FIRST '     @optn
     C     sdbank        Parm      sdbank        dsfdy
 
      ** Database Error
 
     C                   IF        @rtcd <> *blanks
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
      ** Check if function code is being monitored by the compliance watch                    CSD015
                                                                                              CSD015
     C                   CallB     'AOWLCCR0'                                                 CSD015
     C                   Parm      *Blanks       PRtCd                                        CSD015
     C                   Parm      '*KEY'        POptn                                        CSD015
     C                   Parm      'TRANSREQ'    PFunc                                        CSD015
     C     SDWLCC        Parm      SDWLCC        DSFDY                                        CSD015
                                                                                              CSD015
      ** If return code not blank, then issue database error                                  CSD015
                                                                                              CSD015
     C                   If        PRtCd <> *Blanks and PRtCd <> '*NRF'                       CSD015
     C                   Eval      DBKey = 'TRANSREQ'                                         CSD015
     C                   Eval      DBFile = 'SDWLCCPD'                                        CSD015
     C                   Eval      DBase = 004                                                CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   EndIf                                                                CSD015
                                                                                              CSD015
      ** If return code is blank                                                              CSD015
                                                                                              CSD015
     C                   If        PRtCd = *Blanks                                            CSD015
     C                   Eval      KFuncCode = 'FT101HPD'                                     CSD015
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
                                                                                              CSD015
     C                   In        SDSTAT                                                     CSD015
 
      ** Key lists
 
      ** Key list for FT101DL0
     C     kdetail       KLIST
     C                   KFLD                    krftid
     C                   KFLD                    ktrnref
 
      ** Key list for FT101HL6
     C     KPosition     KLIST
     C                   KFLD                    kpytp
     C                   KFLD                    krftid
                                                                                185196
      ** Key list for FT101DL4                                                  185196
                                                                                185196
     C     *Like         Define    RFTID         Krftid                         185196
     C     *Like         Define    RFTMSG        Krftmsg                        185196
     C     *Like         Define    RFTMSQ        Krftmsq                        185196
                                                                                185196
     C     Kft101dl4     KLIST                                                  185196
     C                   KFLD                    Krftid                         185196
     C                   KFLD                    Krftmsg                        185196
     C                   KFLD                    Krftmsq                        185196
                                                                                185196
      ** Key list for SDCWHTL1                                                                CSD015
                                                                                              CSD015
     C     KFuncKey      KLIST                                                                CSD015
     C                   KFLD                    KFuncCode                                    CSD015
     C                   KFLD                    KIden                                        CSD015
     C                   KFLD                    KBranch                                      CSD015
                                                                                              CSD015
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
     C                   Eval      type = @rfttype
     C                   Eval      *IN24 = *ON
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
