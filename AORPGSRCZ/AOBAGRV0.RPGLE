     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Check Bilateral Agreements')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects                                       *
      *                                                               *
      *  AOBAGRV0 - Check Bilateral Agreements Access Objects         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BUG24542           Date 26Jun09               *
      *                 BUG24707           Date 01Jul09               *
      *                 CSW209  *CREATE    Date 01Apr09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  BUG24542 - MT202 is generated instead of MT202COV            *
      *  BUG24707 - MT202 COV is generated even if a Bilateral        *
      *             agreement exist.                                  *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Use of Indicator                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRINIT        -  Program Initialisation Routine              *
      *                                                               *
      *****************************************************************
      /EJECT
     FSDCUSTL7  IF   E           K DISK
      ** Customers by Unique SWIFT ID
     FMEBAGRL1  IF   E           K DISK
      ** Bilateral Agreements Logical File - Retrieval
     FSDCUSTL1  IF   E           K DISK
      ** Customer details retrieval
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D CPY2@           S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
      *
      /EJECT
     D P@MGDA          DS
     D  @MG                    1     50
     D                                     DIM(1) CTDATA PERRCD(1)
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** File information data structure for external file DSFDY
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Externally described DS for Nostro details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D N_SDNOST      E DS                  EXTNAME(SDNOSTPD)
     D                                     PREFIX(N_)
      ** Account details
     D SDACCT        E DS                  EXTNAME(ACCNTAB)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Entry Parameter
      *
     D P@RtCd          S              7A
     D P@BAgr          S             10A
     D P@Brch          S              3A
     D P@Nwrk          S              6A
     D P@Mtyp          S              3A
     D P@SCur          S              3A
     D P@PCur          S              3A
     D P@SSwID         S             11A
     D P@RSwID         S             11A
     D P@Valf          S              8A
     D P@OrBnk         S            256A
     D P@S2RInfo       S            256A
     D P@SndCor        S            256A
     D P@RcvCor        S            256A
 
      *
      ** Parameter for AONOSTR0
      *
     D PRTCD           S              7A
     D POPTN           S              7A
     D PCUST           S              6A
     D PCYCD           S              3A
     D PACCD           S              4A
     D PACSN           S              2A
     D PNONB           S              2A
     D PBRCD           S              3A
     D PCSSN           S             10A
     D PPNOI           S              1A
 
     D WCUST           S              6
     D PIBAN           S             34A
     D PPSTR           S             35A
     D WSWIFT          S             12A
     D W@BIC           S             11A
     D MATCH           S              1A
     D PSWftID         S             11A
     D PSWftID2        S             11A
 
     D BRANCH          S              3A
     D OTHPTY          S             11A
     D CSID            S             12A
     D PNOSD           S              5A
 
     D WSLSH           S              1A
     D WP@SndCor       S            256A
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Execute initialisation
      *
     C                   EXSR      SRInit
      *
      ** If senders correspondent is not blanks
      *
     C                   IF        P@SndCor <> *BLANKS
      *
      ** Check if 1st char of senders correspondent contains a slash
      *
     C                   EVAL      WSLSH = %SUBST(P@SndCor:1:1)
     C                   IF        WSLSH = '/'
     C                   EVAL      WP@SndCor = %SUBST(P@SndCor:2:34)
     C                   ELSE
     C                   EVAL      WP@SndCor = P@SndCor
     C                   ENDIF
 
     C                   EVAL      P@SndCor = WP@SndCor
      *
      ** Retrieve Customer Number
      ** If 2 digits long access nostro table. Use payment currency.
      *
     C                   IF        %LEN(%TRIM(P@SndCor)) = 2
 
     C                   EVAL      PNONB = P@SndCor
     C                   EVAL      PCYCD = P@PCur
 
     C                   ELSE
 
     C                   EVAL      PNOSD = P@SndCor
     C                   EVAL      PCYCD = %SUBST(PNOSD:1:3)
     C                   EVAL      PNONB = %SUBST(PNOSD:4:2)
 
     C                   ENDIF
 
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PCUST
     C                   PARM                    PCYCD
     C                   PARM                    PACCD
     C                   PARM                    PACSN
     C                   PARM                    PNONB
     C                   PARM      P@Brch        PBRCD
     C                   PARM      *BLANKS       PCSSN
     C                   PARM      *BLANKS       PPNOI
     C     SDNOST        PARM      *BLANKS       DSFDY
 
     C                   IF        PRTCD = *BLANKS
     C                   MOVE      A7CUST        WCUST
     C                   ENDIF
      *
      ** If not found, use AOIBANR2 to retrieve account details from IBAN entry
      *
     C                   IF        WCUST = *BLANKS
     C                   MOVEL     P@SndCor      PIBAN
     C                   CALL      'AOIBANR2'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    PIBAN
     C     SDACCT        PARM      *BLANKS       DSSDY
 
     C                   IF        PRTCD = *BLANKS
     C                   MOVE      CNUM          WCUST
     C                   ENDIF
     C                   ENDIF
 
      *
      ** If not found, use AOACCTV1 to retrieve account details
      *
     C                   IF        WCUST = *BLANKS
     C                   MOVEL     P@SndCor      PPSTR
     C                   CALL      'AOACCTV1'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      *BLANKS       POPTN
     C                   PARM                    PPSTR
     C     SDACCT        PARM      *BLANKS       DSSDY
 
     C                   IF        PRTCD = *BLANKS
     C                   IF        POPTN = '*RETAIL' OR
     C                             POPTN = '*NOSTRO' OR
     C**********                   POPTN = 'LEDGER'                                         BUG24542
     C                             POPTN = '*LEDGER' OR                                     BUG24542
     C                             POPTN = '*SWIFT'                                         BUG24542
                                                                                            BUG24542
     C                   IF        POPTN = '*NOSTRO'
     C                   EVAL      N_SDNOST = DSSDY
     C                   MOVEL     N_A7CUST      WCUST
     C                   ELSE
                                                                                            BUG24542
     C                   IF        POPTN = '*SWIFT'                                         BUG24542
     C                   MOVEL     P@SndCor      WSWIFT                                     BUG24542
     C                   ELSE                                                               BUG24542
     C                   EVAL      SDACCT = DSSDY
     C                   MOVEL     CNUM          WCUST
     C                   ENDIF                                                              BUG24542
                                                                                            BUG24542
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
      *
      ** If customer number is retrieved, access customer details
      ** to get the BIC address
      *
     C                   IF        WCUST <> *BLANKS
     C     WCUST         CHAIN     SDCUSTL1
     C                   IF        %FOUND(SDCUSTL1)
     C                   MOVE      BBCSID        WSWIFT
     C                   ENDIF
     C                   ENDIF
      *
      ** Set the return parameter
      *
     C                   IF        P@BAgr = 'MT103'
     C                   CALL      'ME1730'
     C                   PARM                    P@Brch
     C                   PARM                    P@SSwID
     C                   PARM                    P@RSwID
     C                   PARM                    P@OrBnk
     C                   PARM                    P@S2RInfo
     C                   PARM                    P@SndCor
     C                   PARM                    P@RcvCor
     C                   PARM                    PRTCD
 
     C                   MOVE      PRTCD         P@Rtcd
     C                   ENDIF
 
     C                   IF        P@BAgr = 'SCT_C202' OR P@BAgr = 'CCT_C202'
 
     C                   SELECT
     C                   WHEN      P@Mtyp = '102' AND P@BAgr = 'SCT_C202'
     C                   EVAL      P@BAgr = 'CCT_C202'
     C                   WHEN      P@Mtyp = '103' AND P@BAgr = 'CCT_C202'
     C                   EVAL      P@BAgr = 'SCT_C202'
     C                   ENDSL
 
     C                   IF        WSWIFT = *BLANKS
     C                   MOVE      *BLANKS       P@Rtcd
     C                   RETURN
     C                   ENDIF
 
     C                   IF        P@Mtyp = '102' OR P@Mtyp = '103'
     C                   EVAL      P@Rtcd = '*CRTCOV'
     C**********         MOVE      P@SSwID       W@BIC                                      BUG24707
     C                   MOVEL     WSWIFT        W@BIC                                      BUG24707
     C                   ELSE
     C                   EVAL      P@Rtcd = '*CRT202'
     C                   ENDIF
     C                   ENDIF
 
     C**********         IF        W@BIC = *BLANKS                                          BUG24707
     C**********         MOVE      P@RSwID       W@BIC                                      BUG24707
     C**********         ENDIF                                                              BUG24707
      *
      ** Access Bilateral Agreements file
      *
     C                   MOVE      'N'           MATCH
     C                   MOVE      *BLANKS       BRANCH
     C                   MOVE      *BLANKS       OTHPTY
     C     KEY1          CHAIN     MEBAGRL1
     C                   IF        %FOUND(MEBAGRL1)
     C                   MOVE      'Y'           MATCH
     C                   ENDIF
 
     C                   MOVE      *BLANKS       BRANCH
     C                   MOVE      W@BIC         OTHPTY
     C     KEY1          CHAIN     MEBAGRL1
     C                   IF        %FOUND(MEBAGRL1)
     C                   MOVE      'Y'           MATCH
     C                   ENDIF
      *
      ** Retrieve swift address of Parent customer of W@BIC
      *
     C                   MOVE      W@BIC         CSID
     C     CSID          CHAIN     SDCUSTL7
     C                   IF        %FOUND(SDCUSTL7)
     C                   EVAL      WCUST = BBPCNB
     C                   ENDIF
     C     WCUST         CHAIN     SDCUSTL1
     C                   IF        %FOUND(SDCUSTL1)
     C                   EVAL      PSwftID = BBCSID
     C                   ENDIF
     C                   MOVE      *BLANKS       BRANCH
     C                   EVAL      OTHPTY = PSwftID
     C     KEY1          CHAIN     MEBAGRL1
     C                   IF        %FOUND(MEBAGRL1)
     C                   MOVE      'Y'           MATCH
     C                   ENDIF
 
     C                   MOVE      *BLANKS       BRANCH
     C                   MOVEL     W@BIC         OTHPTY
     C                   MOVE      '***'         OTHPTY
     C     KEY1          CHAIN     MEBAGRL1
     C                   IF        %FOUND(MEBAGRL1)
     C                   MOVE      'Y'           MATCH
     C                   ENDIF
 
     C                   IF        PSwftID <> *BLANKS
     C                   MOVEL     PSwftID       PSWftID2
     C                   MOVE      '***'         PSWftID2
     C                   ENDIF
     C                   MOVE      *BLANKS       BRANCH
     C                   EVAL      OTHPTY = PSWftID2
     C     KEY1          CHAIN     MEBAGRL1
     C                   IF        %FOUND(MEBAGRL1)
     C                   MOVE      'Y'           MATCH
     C                   ENDIF
 
     C                   EVAL      BRANCH = P@Brch
     C                   EVAL      OTHPTY = W@BIC
     C     KEY1          CHAIN     MEBAGRL1
     C                   IF        %FOUND(MEBAGRL1)
     C                   MOVE      'Y'           MATCH
     C                   ENDIF
 
     C                   EVAL      BRANCH = P@Brch
     C                   EVAL      OTHPTY = PSwftID
     C     KEY1          CHAIN     MEBAGRL1
     C                   IF        %FOUND(MEBAGRL1)
     C                   MOVE      'Y'           MATCH
     C                   ENDIF
 
     C                   EVAL      BRANCH = P@Brch
     C                   MOVEL     W@BIC         OTHPTY
     C                   MOVE      '***'         OTHPTY
     C     KEY1          CHAIN     MEBAGRL1
     C                   IF        %FOUND(MEBAGRL1)
     C                   MOVE      'Y'           MATCH
     C                   ENDIF
 
     C                   EVAL      BRANCH = P@Brch
     C                   EVAL      OTHPTY = PSwftID2
     C     KEY1          CHAIN     MEBAGRL1
     C                   IF        %FOUND(MEBAGRL1)
     C                   MOVE      'Y'           MATCH
     C                   ENDIF
 
     C                   IF        P@Rtcd = '*CRTCOV'
     C                   IF        MATCH = 'Y'
     C                   EVAL      P@Rtcd = '*CRT202'
     C                   ENDIF
     C                   ELSE
     C                   IF        MATCH = 'Y'
     C                   EVAL      P@Rtcd = '*BA'
     C                   ELSE
     C                   EVAL      P@Rtcd = *BLANKS
     C                   ENDIF
     C                   ENDIF
 
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - Program Initialisation                               *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SrInit        BEGSR
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     Cpy@          Cpy2@
      *
      ** Receive entry parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    P@RtCd
     C                   PARM                    P@BAgr
     C                   PARM                    P@Brch
     C                   PARM                    P@Nwrk
     C                   PARM                    P@Mtyp
     C                   PARM                    P@SCur
     C                   PARM                    P@PCur
     C                   PARM                    P@SSwID
     C                   PARM                    P@RSwID
     C                   PARM                    P@Valf
     C                   PARM                    P@OrBnk
     C                   PARM                    P@S2RInfo
     C                   PARM                    P@SndCor
     C                   PARM                    P@RcvCor
 
     C     KEY1          KLIST
     C                   KFLD                    P@BAgr
     C                   KFLD                    BRANCH
     C                   KFLD                    OTHPTY
 
     C                   MOVEL     *BLANKS       WCUST
 
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2009
