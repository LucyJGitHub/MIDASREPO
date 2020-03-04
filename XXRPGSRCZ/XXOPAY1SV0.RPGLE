     H DEBUG
     H COPYRIGHT('(c) Finastra International Systems Ltd. 2020')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas FT Retrieve GCMS details for FTOPAY1SN')         *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      ***FTOPAY1SV0*-*Midas*FT*Invisible*Window*for*FTOPAY1SN**********                  JMI113
      *  XXOPAY1SV0 - Midas FT Rtv GCMS details for FTOPAY1SN         *                  JMI113
      *                                                               *
      *  Function:  This program needs to retieve details for the     *
      *     new fields of GCMS Account Master Details Report          *
      *                                                               *
      *  Called By: FTOPAY1SN                                         *
      *                                                               *
      *  (c) Finastra International Systems Ltd. 2020                 *
      *                                                               *
      *  Last Amend No. JMI113             Date 19Feb20               *
      *  Prev Amend No. 254598A            Date 22Jul08               *
      *                 254598             Date 16Jun08               *
      *                 JMI019             Date 06Nov07               *
      *                 JMI019             Date 10Sep07               *
      *                 JMI019  *CREATE    Date 26Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI113 - Midas GCMS Interface. Upgrade to FBM 2.1            *
      *  254598A- Transferred the resized DP32B to DATAF1.            *
      *           Renamed DP32B in DATA2 and restore old length.      *
      *           Transferred DATA2 fields to DATAF1 and reverted     *
      *           size of DATA2 to 1024 bytes. Amended size of DATAI. *
      *  254598 - Increase length of DP32B and DATA2                  *
      *  JMI019 - Corrected return of Null validation                 *
      *         - added Related Pay reference                         *
      *         - ensured DS fields are cleared during population     *
      *  JMI019 - Midas-GCMS Interface                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    ExtName(LDA)
      *
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

     D @NUL            C                   const('123456789')

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)

     D*Data2*********  ds          1024                                                       JMI019
     D*Data2****       ds          1132                                                       JMI019
     D*Data2****       ds          1138                                               254598 254598A
     D Data2           ds          1024                                                      254598A
     D   UPSEQ                        5A
     D   DNWRK                        6A
     D***DP32B**                     42A                                                      254598
     D***DP32B**                     48A                                              254598 254598A
     D   WDP32B                      42A                                                     254598A
     D   DP33B                       42A
     D   DP57                       255A
     D   DSPCCY                       3A
     D   DPYAMA                      14A
     D   DSSMCY                       3A
     D   DSMAMA                      14A
     D   DPRFC                        4A
     D   DBOKC                        2A
     D   DPYST                        2A
     D   DACB1                       35A
     D   DACB2                       35A
     D   DACB3                       35A
     D   DACB4                       35A
     D   DACB5                       35A
     D   DRLPR                       16A                                                      JMI019
     D   DMTPY                        3A                                                      JMI019
     D   DP20                       255A                                                      JMI019
     D***DP59***                    255A                                              JMI019 254598A
     D***DSTR35*                     35A                                              JMI019 254598A

     D*DataI****       ds           101                                                      254598A
     D DataI           ds            99                                                      254598A
     D  DIN001                        1
     D  DIN002                        1
     D  DIN003                        1
     D  DIN004                        1
     D  DIN005                        1
     D  DIN006                        1
     D  DIN007                        1
     D  DIN008                        1
     D  DIN009                        1
     D  DIN010                        1
     D  DIN011                        1
     D  DIN012                        1
     D  DIN013                        1
     D  DIN014                        1
     D  DIN015                        1
     D  DIN016                        1
     D  DIN017                        1
     D  DIN018                        1
     D  DIN019                        1
     D  DIN020                        1
     D  DIN021                        1
     D  DIN022                        1
     D  DIN023                        1
     D  DIN024                        1
     D  DIN025                        1
     D  DIN026                        1
     D  DIN027                        1
     D  DIN028                        1
     D  DIN029                        1
     D  DIN030                        1
     D  DIN031                        1
     D  DIN032                        1
     D  DIN033                        1
     D  DIN034                        1
     D  DIN035                        1
     D  DIN036                        1
     D  DIN037                        1
     D  DIN038                        1
     D  DIN039                        1
     D  DIN040                        1
     D  DIN041                        1
     D  DIN042                        1
     D  DIN043                        1
     D  DIN044                        1
     D  DIN045                        1
     D  DIN046                        1
     D  DIN047                        1
     D  DIN048                        1
     D  DIN049                        1
     D  DIN050                        1
     D  DIN051                        1
     D  DIN052                        1
     D  DIN053                        1
     D  DIN054                        1
     D  DIN055                        1
     D  DIN056                        1
     D  DIN057                        1
     D  DIN058                        1
     D  DIN059                        1
     D  DIN060                        1
     D  Din061                        1
     D  Din062                        1
     D  Din063                        1
     D  Din064                        1
     D  Din065                        1
     D  Din066                        1
     D  Din067                        1
     D  Din068                        1
     D  Din069                        1
     D  Din070                        1
     D  Din071                        1
     D  Din072                        1
     D  Din073                        1
     D  Din074                        1
     D  Din075                        1
     D  Din076                        1
     D  Din077                        1
     D  Din078                        1
     D  Din079                        1
     D  Din080                        1
     D  Din081                        1
     D  Din082                        1
     D  Din083                        1
     D  Din084                        1
     D  Din085                        1
     D  Din086                        1
     D  Din087                        1
     D  Din088                        1
     D  Din089                        1
     D  Din090                        1
     D  Din091                        1
     D  Din092                        1
     D  Din093                        1
     D  Din094                        1
     D  Din095                        1
     D  Din096                        1
     D  Din097                        1
     D  Din098                        1
     D  Din099                        1

     D DataF1          ds          5000
     D   DP32B                       48A                                                     254598A
     D   DP59                       255A                                                     254598A
     D   DSTR35                      35A                                                     254598A
     D DataF2          ds          5000
     D DataF3          ds          5000
     D DataF4          ds          5000

     D SDBANK        E DS                  ExtName(SDBANKPD)
     D SCSARD        E DS                  ExtName(SCSARDPD)
     D*SDGCMS***     E DS                  ExtName(SDGCMSPD)                                 JMI113
     D SDGCMS        E DS                  ExtName(XXGCMSPD)                                 JMI113
     D @FMT          E DS                  ExtName(DSFDY)
     D @FMT2         E DS                  ExtName(DSSDY)

     D @NL             S              1    dim(15)
     D YA1             s              1    dim(15)
     D @STK            s             10    dim(20)

     D/COPY MECPYSRC,ME1100_ILE

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @RUN            S              1
     D @Return         s              7a
     D @Action         s              1a
     D JMI019          S              1    inz('N')
     D JMI113          S              1    inz('N')                             JMI113
     D @RtCd           S              7    inz(' ')
     D @Optn           S              7
     D @Sard           S              6

     D Q               S              5  0
     D C               S              3  0
     D I               S              2  0 inz(0)
     D AMT             S             15
     D WNLAM           S             15
     D WNLNUL          S              1    inz('Y')
     D W32CY           S                   like(TVCCY)
     D W32AM           S                   like(DSMAMA)
     D SNWRK           S                   like(DNWRK)

      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatiCally: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
     C     *entry        PList
     C                   Parm                    @Action
     C                   Parm                    Data2
     C                   Parm                    DataI
     C                   Parm                    DataF1
     C                   Parm                    DataF2
     C                   Parm                    DataF3
     C                   Parm                    DataF4
     C                   Parm                    @Return

     C**********         If        JMI019 = 'Y'                                          JMI113
     C                   If        JMI113 = 'Y'                                          JMI113

     C                   If        UpSeq = '00001'  and
     C                             DNWRK = 'GCMS'

      * Upgrade processing of /COPY FT0040C307
      ** Special rule for GCMS

     C                   If        DP32B <> *Blanks
     C**********         Movel     DP32B         DSTRAN                                       JMI019
     C                   Movel(P)  DP32B         DSTRAN                                       JMI019
     C                   ExSr      RTP32B
     C                   MoveL     W32CY         DSPCCY
     C                   MoveL     W32AM         WNLAM
     C                   ExSr      TSNULL
     C                   If        WNLNUL = 'N'
     C                   Eval      DPYAMA = W32AM
     C                   Else
     C                   Eval      DPYAMA = *blanks
     C                   EndIf
     C                   EndIf
      *
     C                   If        DP33B <> *Blanks
     C**********         MoveL     DP33B         DSTRAN                                       JMI019
     C                   MoveL(P)  DP33B         DSTRAN                                       JMI019
     C                   ExSr      RTP32B
     C                   Eval      DSSMCY = W32CY
     C                   MoveL     W32AM         WNLAM
     C                   ExSr      TSNULL
     C                   If        WNLNUL = 'N'
     C                   Eval      DSMAMA = W32AM
     C                   Else
     C                   Eval      DSMAMA = *blanks
     C                   EndIf
      * DP32B <> *Blanks
     C                   EndIf
      * UpSeq = '00001'
     C                   EndIf

      * Upgrade processing of /COPY FT0040C308

     C                   If        UpSeq = '00002'  and
     C                             DNWRK = 'GCMS'
      *
      ** Default in PROFIT CENTER and PAYMENT SUB-TYPE
      *
     C                   Eval      DPRFC = J0PYPC
     C                   Eval      DBOKC = J0PYBC
     C                   Eval      DPYST = J0PYOP
      *
     C                   If        DP32B <> *blanks
     C**********         MoveL     DP32B         DSTRAN                                       JMI019
     C                   MoveL(P)  DP32B         DSTRAN                                       JMI019
     C                   ExSr      RTP32B
     C                   MoveL     W32CY         DSPCCY
     C                   MoveL     W32AM         WNLAM
     C                   ExSr      TSNULL
     C                   If        WNLNUL = 'N'
     C                   Eval      DPYAMA = W32AM
     C                   Else
     C                   Eval      DPYAMA = *blanks
     C                   EndIf
     C                   EndIf
      *
     C                   If        DP33B <> *blanks
     C**********         MoveL     DP33B         DSTRAN                                       JMI019
     C                   MoveL(P)  DP33B         DSTRAN                                       JMI019
     C                   ExSr      RTP32B
     C                   Eval      DSSMCY = W32CY
     C                   MoveL     W32AM         WNLAM
     C                   ExSr      TSNULL
     C                   If        WNLNUL = 'N'
     C                   Eval      DSMAMA = W32AM
     C                   Else
     C                   Eval      DSMAMA = *blanks
     C                   EndIf
     C                   EndIf
     C                   EndIf

     C                   If        UpSeq = '00003'                                            JMI019
     C                   Eval      SNWRK = DNWRK                                              JMI019
     C                   If        DNWRK = 'GCMS'                                             JMI019
     C                   Eval      DNWRK = 'FONTIS'                                           JMI019
     C                   EndIf                                                                JMI019
     C                   EndIf                                                                JMI019
      *                                                                                       JMI019
     C                   If        UpSeq = '00004'
     C                   Eval      DNWRK = SNWRK
     C                   EndIf
      *
      ** Upgrade /COPY FT0040C313
      *
     C                   If        UpSeq = '00005' and
     C                             DNWRK = 'GCMS'
     C                   If        DP57 <> *blank
     C**********         Movel     DP57          DSTRAN                                       JMI019
     C                   Movel(P)  DP57          DSTRAN                                       JMI019
     C                   MoveL     TMLIN1        DACB1
     C                   MoveL     TMLIN2        DACB2
     C                   MoveL     TMLIN3        DACB3
     C                   MoveL     TMLIN4        DACB4
     C                   MoveL     TMLIN5        DACB5
     C                   EndIf
     C                   EndIf
      *
      * Related Pay Reference                                                                 JMI019
     C                   If        UpSeq = '00006' and                                        JMI019
     C                             DNWRK = 'GCMS'  and                                        JMI019
     C                             DMTPY = '101'                                              JMI019
     C                   If        DP20 <> *blanks                                            JMI019
     C                   MoveL(P)  DP20          DSTRAN                                       JMI019
     C                   MoveL     TTREF         DRLPR                                        JMI019
     C                   EndIf                                                                JMI019
     C                   EndIf                                                                JMI019
      *                                                                                       JMI019
     C                   If        UpSeq = '00007' and                                        JMI019
     C                             DNWRK = 'GCMS'                                             JMI019
     C                   If        DP59 <> *BLANKS                                            JMI019
     C                   MoveL(P)  DP59          DSTRAN                                       JMI019
     C                   ExSr      SLSH35                                                     JMI019
     C                   EndIf                                                                JMI019
     C                   EndIf                                                                JMI019
      *                                                                                       JMI019
      ***JMI019*=*'Y'                                                                         JMI113
      ** JMI113 = 'Y'                                                                         JMI113
      *
     C                   EndIf

     C                   If        SNWRK = *blanks
     C                   Eval      *INLR = *ON
     C                   EndIf
     C                   Return

      **********************************************************************                  JMI019
      /EJECT                                                                                  JMI019
      ** Remove character '/' (for 35 chars)                                                  JMI019
      *****************************************************************                       JMI019
      *  Retrieve the currency and amount in P32B                                             JMI019
                                                                                              JMI019
     C     SLSH35        BegSr                                                                JMI019
      ** Set up subroutine stack name                                                         JMI019
     C                   Eval      Q = Q + 1                                                  JMI019
     C                   MoveL     'SLSH35'      @STK(Q)                                      JMI019
      *                                                                                       JMI019
     C                   Eval      DSTR35 = *BLANKS                                           JMI019
     C                   If        %subst(TMLIN1:1:1) = '/'                                   JMI019
     C                   Eval      DSTR35 = %subst(TMLIN1:2)                                  JMI019
     C                   EndIf                                                                JMI019
      *                                                                                       JMI019
      ** Unwind subroutine stack name                                                         JMI019
     C                   MoveA     *BLANKS       @STK(Q)                                      JMI019
     C                   Eval      Q = Q - 1                                                  JMI019
     C                   EndSr                                                                JMI019
                                                                                              JMI019
      **********************************************************************
      /EJECT
      ** Upgrade the /COPY FT0040C080
      *****************************************************************
      *  Retrieve the currency and amount in P32B

     C     RTP32B        BegSr
      ** Set up subroutine stack name
     C                   Eval      Q = Q + 1
     C                   MoveL     'RTP32D'      @STK(Q)
      ** Inputs
      ** ------
      ** DS for tags  (will NOT be blanked at the end of the S/R)
      **                                  DSTRAN
      ** Outputs
      ** -------
      ** Currency                         W32CY
      ** Amount                           W32AM
      *
     C                   MoveL     *BLANK        W32CY
     C                   MoveL     *BLANK        W32AM
      *
      ** Currency
      *
     C                   MoveL     TTCCY         W32CY
      ** Amount
      *
      ** Format amount field (change ',' decimal point to '.').
      *
     C                   MoveA     TTAMT         YA1
     C                   Eval      C = 1
      *
     C                   DoU       C > 15
      *
     C                   If        YA1(C) = ','
     C                   Move      '.'           YA1(C)
     C                   Eval      C = 16
     C                   Else
     C                   Eval      C = C + 1
     C                   EndIf
      *
     C                   EndDo
      *
     C                   MoveA     YA1           AMT
     C                   MoveL     AMT           W32AM
      *
      ** Unwind subroutine stack name
      *
     C     EXP32B        TAG
     C                   MoveA     *BLANKS       @STK(Q)
     C                   Eval      Q = Q - 1
      *
     C                   EndSr

      *****************************************************************
      /EJECT
      *****************************************************************
      * TSNULL Test if an amount is null
      *****************************************************************
     C     TSNULL        BegSr
      ** Inputs
      ** ------
      ** Amount                           WNLAM
      ** Outputs
      ** -------
      ** Flag Null ? (Y/N)                WNLNUL
      *
     C                   MoveL     'Y'           WNLNUL
      *
     C                   If        WNLAM <> *blank
     C                   MoveA     WNLAM         @NL
     C                   Eval      I = 1
     C                   Do        15            I
     C     @NUL          Check     @NL(I)
     C                   If        %found
     C                   Eval      WNLNUL = 'Y'                                               JMI019
     C                   Eval      WNLNUL = 'N'
     C                   Leave
     C                   EndIf
     C                   EndDo
     C                   EndIf

     C                   MoveL     *BLANK        WNLAM
     C                   MoveL     *BLANK        @NL

     C                   ENDSR

      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      * Called by: Implicitly on program activation                   *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BegSr


     C     *DTAARA       Define                  LDA
     C                   Eval      JMI019 = 'N'
     C                   Call      'AOSARDR0'
     C                   Parm      *BLANKS       @RtCd
     C                   Parm      '*VERIFY'     @Optn
     C                   Parm      'JMI019'      @Sard
     C     SCSARD        Parm      SCSARD        @FMT
      *
     C                   If        @RtCd  = *blanks
     C                   Eval      JMI019 = 'Y'
     C                   ElseIf    @RtCd <> '*NRF   '
     C     *LOCK         In        LDA
     C                   Eval      DBFILE =  'SCSARDPD'
     C                   Eval      DBKEY  =  'JMI019'                           ************
     C                   Eval      DBPGM  =  PSProcPgm                          * DBERR 001*
     C                   Eval      DBASE  =  001                                ************
     C                   Eval      DBMOD  =  PSProcMod
     C                   Out       LDA
     C                   ExSr      *PSSR
     C                   EndIf
                                                                                JMI113
     C                   Eval      JMI113 = 'N'                                 JMI113
     C                   Call      'AOSARDR0'                                   JMI113
     C                   Parm      *BLANKS       @RtCd                          JMI113
     C                   Parm      '*VERIFY'     @Optn                          JMI113
     C                   Parm      'JMI113'      @Sard                          JMI113
     C     SCSARD        Parm      SCSARD        @FMT                           JMI113
      *                                                                         JMI113
     C                   If        @RtCd  = *blanks                             JMI113
     C                   Eval      JMI113 = 'Y'                                 JMI113
     C                   EndIf                                                  JMI113

     C**********         Call      'AOGCMSR0'                                   JMI113
     C                   Call      'XXGCMSR0'                                   JMI113
     C                   PARM      '       '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDGCMS        PARM      SDGCMS        @FMT2
      *
     C                   If        @RTCD <> *blanks
     C     *LOCK         In        LDA
     C**********         Eval      DBFILE = 'SDGCMSPD'                          ************  JMI113
     C                   Eval      DBFILE = 'XXGCMSPD'                          ************  JMI113
     C                   Eval      DBKEY = @OPTN                                * DBERR 002*
     C                   Eval      DBASE = 2                                    ************
     C                   Out       LDA
     C                   ExSr      *PSSR
     C                   EndIf

     C                   EndSr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatiCally if a program error occurs,      *
      *          or directly by the program code using ExSr.          *
      *          This subroutine DUMPs the program just once.         *
      * Called by: (**Calling routines**)                             *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BegSr
      *
     C                   If        @RUN = *BLANK
     C                   Eval      @RUN = 'Y'
     C                   DUMP
     C                   Call      'DBERRCTL'
     C                   EndIf
      *
     C                   Eval      *INU7 = *ON
     C                   Eval      *INU8 = *ON
     C                   Eval      *INLR = *ON
     C                   Return
      *
     C                   EndSr
      *
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Systems Ltd. 2020
