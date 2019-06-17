     H DEBUG
*****H*COPYRIGHT('(c)*Misys*International*Banking*Systems*Ltd.*2007')***            JMI113
     H COPYRIGHT('(c) Finastra International Limited 2018')                         JMI113
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*E*I****TEXT('Midas GL Invisible Window for GL3572')******************             JMI113
/*EXI *  TEXT('Midas XX GL Retrieve details for GL3572')              *             JMI113
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      ***GL3572V0**-*Midas*GL*Invisible*Window*for*GL3572**************             JMI113
      *  XX3572 - Midas XX GL Retrieve details for GL3572             *             JMI113
      *                                                               *
      *  Function:  This program needs to retieve details for the     *
      *     new fields of GCMS Account Master Details Report          *
      *                                                               *
      *  Called By: GL3572                                            *
      *                                                               *
      ***(c)*Misys*International*Banking*Systems*Ltd.*2007*************             JMI113
      *  (c) Finastra International Limited 2018                      *             JMI113
      *                                                               *
      *  Last Amend No. JMI113             Date 16May18               *
      *  Prev Amend No. JMI019  *CREATE    Date 23Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI113 - Midas-GCMS Interface. Upgrade to FBM 2.1            *
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

     F**********GLGCACL0  IF   E           K DISK                                        JMI113
     FXXGCACL0  IF   E           K DISK                                                  JMI113

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)

     D Data2           ds          1024
     D  UPSEQ                         5A
     D  DBRCA                         3A
     D**DCNUM***                      6  0                                               JMI113
     D  DCNUM                         6A                                                 JMI113
     D  DCCY                          3A
     D  DACOD                        10  0
     D  DACSQ                         2  0
     D  DEXFL1                      130A
     D  DEXFL2                      130A

     D DataI           ds           101
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
     D DataF2          ds          5000
     D DataF3          ds          5000
     D DataF4          ds          5000

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D @FMT          E DS                  EXTNAME(DSFDY)

     D DEXFLD          DS
     D  Filler1                      28A
     D  DFONA                         1A
     D  Filler2                      18A
     D  DATVD                         7A
     D  Filler3                      15A
     D  DDATV                         7A
     D  Filler4                      21A
     D  DFNSQ                         5  0
     D  Filler5                      10A
     D  DGN42                         1A
     D  Filler6                       7A
     D  DWD42                         7A

     D KACCNO          ds
     D  KBRCA                         3A
     D**KCNUM***                      6  0                                               JMI113
     D  KCNUM                         6A                                                 JMI113
     D  KCCY                          3A
     D  KACOD                        10  0
     D  KACSQ                         2  0

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @RUN            S              1
     D @Return         s              7a
     D @Action         s              1a
     D*JMI019***       S              1    inz('N')                                      JMI113
     D JMI113          S              1    inz('N')                                      JMI113
     D @RtCd           S              7    inz(' ')
     D @Optn           S              7
     D @Sard           S              6

      * Zdate2 parameters

     D ZdateIn         S              5  0
     D ZdateFmt        S              1A
     D ZdateOut        S              6  0
     D ZdateChr        S              7A

     D @Line130        S            130A   inz(*ALL'-')

     D Fill1           C                   'ELECTRONIC BANKING ENABLED: '
     D Fill2           C                   ' ACTIVATION DATE: '
     D Fill3           C                   ' DE-ACT. DATE: '
     D Fill4           C                   ' LAST STMT SEQ. NO.: '
     D Fill5           C                   ' INTERIM: '
     D Fill6           C                   ' FROM: '

      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
     C     *DTAARA       Define                  LDA

     C**********         If        JMI019 = 'Y' and                                      JMI113
     C**********                   UPSEQ = '00001'                                       JMI113
     C                   If        UPSEQ = '00001'                                       JMI113

      * Upgrade processing of /COPY GL3572C021

     C                   Clear                   DEXFL1
     C                   Clear                   DEXFLD
     C                   Eval      DWD42 = *blanks
     C                   Eval      DDATV = *blanks
     C                   Eval      DFNSQ = 0

      * Upgrade processing of /COPY GL3572C029

     C                   Eval      KBRCA = DBRCA
     C                   Eval      KCNUM = DCNUM
     C                   Eval      KCCY  = DCCY
     C                   Eval      KACOD = DACOD
     C                   Eval      KACSQ = DACSQ

     C*****KACCNO        Chain(e)  GLGCACD0                                              JMI113
     C**********         If        %found(GLGCACL0)                                      JMI113
     C     KACCNO        Chain(e)  XXGCACD0                                              JMI113
     C                   If        %found(XXGCACL0)                                      JMI113
     C                   Eval      Din041 = '1'
     C                   else
     C                   Eval      Din041 = '0'
     C                   EndIf

      * Upgrade processing of /COPY GL3572C030

     C                   Eval      ZdateIn = G1WD42
     C                   ExSr      ZDateSr
     C                   Eval      DWD42 = ZdateChr

     C                   Eval      ZdateIn = G1ATVD
     C                   ExSr      ZDateSr
     C                   Eval      DATVD = ZdateChr

     C                   Eval      ZdateIn = G1DATV
     C                   ExSr      ZDateSr
     C                   Eval      DDATV = ZdateChr

     C                   If        Din041 = '1'
     C                   Eval      Filler1 = Fill1
     C                   Eval      Filler2 = Fill2
     C                   Eval      Filler3 = Fill3
     C                   Eval      Filler4 = Fill4
     C                   Eval      Filler5 = Fill5
     C                   Eval      Filler6 = Fill6
     C                   Eval      DFONA = G1FONA
     C                   Eval      DFNSQ = G1FNSQ
     C                   Eval      DGN42 = G1GN42
     C                   Eval      DEXFL1 = @Line130
     C                   Eval      DEXFL2 = DEXFLD
     C                   EndIf

      ***JMI019*=*'Y'                                                                    JMI113
      *
     C                   EndIf

     C                   Eval      *INLR = *ON
     C                   Return

      **********************************************************************
      /EJECT
      *****************************************************************

     C     ZDateSr       BegSr

     C                   Call      'ZDATE2'
     C                   Parm                    ZdateIn
     C                   Parm      BJDFIN        ZdateFmt
     C                   Parm      0             ZdateOut
     C                   Parm      *blanks       ZdateChr

     C                   EndSr

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

     C     *entry        PList
     C                   Parm                    @Action
     C                   Parm                    Data2
     C                   Parm                    DataI
     C                   Parm                    DataF1
     C                   Parm                    DataF2
     C                   Parm                    DataF3
     C                   Parm                    DataF4
     C                   Parm                    @Return

     C**********         Eval      JMI019 = 'N'                                          JMI113
     C**********         Call      'AOSARDR0'                                            JMI113
     C**********         Parm      *BLANKS       @RtCd                                   JMI113
     C**********         Parm      '*VERIFY'     @Optn                                   JMI113
     C**********         Parm      'JMI019'      @Sard                                   JMI113
     C*****SCSARD        Parm      SCSARD        @FMT                                    JMI113
      *                                                                                  JMI113
     C**********         If        @RtCd  = *blanks                                      JMI113
     C**********         Eval      JMI019 = 'Y'                                          JMI113
     C**********         ElseIf    @RtCd <> '*NRF   '                                    JMI113
     C******LOCK         In        LDA                                                   JMI113
     C**********         Eval      *INU7 = *ON                                           JMI113
     C**********         Eval      *INU8 = *ON                                           JMI113
     C**********         Eval      DBFILE =  'SCSARDPD'                                  JMI113
     C**********         Eval      DBKEY  =  'JMI019'                                    JMI113
     C**********         Eval      DBPGM  =  PSProcPgm                                   JMI113
     C**********         Eval      DBASE  =  001                                         JMI113
     C**********         Eval      DBMOD  =  PSProcMod                                   JMI113
     C**********         Out       LDA                                                   JMI113
     C**********         ExSr      *PSSR                                                 JMI113
     C**********         EndIf                                                           JMI113

     C                   Call      'AOBANKR0'
     C                   PARM      '*MSG   '     @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        @FMT

     C                   If        @RtCd <> *blanks
     C     *LOCK         In        LDA
     C                   Eval      DBFILE = 'SDBANKPD'
     C                   Eval      DBASE = 002
     C                   Eval      DBKEY = @Optn
     C                   Eval      DBPGM = PSProcPgm
     C                   Eval      *INU7 = *ON
     C                   Eval      *INU8 = *ON
     C                   Out       LDA
     C                   ExSr      *PSSR
     C                   Endif

     C                   EndSr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      * Called by: (**calling routines**)                             *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BegSr
      *
     C                   If        @RUN = *BLANK
     C                   Eval      @RUN = 'Y'
     C                   DUMP
     C                   CALL      'DBERRCTL'
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
(c) Finastra International Limited 2018
