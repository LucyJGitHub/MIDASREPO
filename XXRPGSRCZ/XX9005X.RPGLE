     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*E*I****TEXT('Midas*SD*Invisible*Window*for*SD9005X')*****************                   JMI113
/*EXI *  TEXT('Midas SD GCMS processing for SD9005X')                 *                   JMI113
      *****************************************************************
      *                                                               *
      *  Midas - SD Module                                            *
      *                                                               *
      ***SD9005XV0*-*Midas*SD*Invisible*Window*for*SD9005X*************                   JMI113
      *  XX9005X   - Midas SD GCMS processing for SD9005X             *                   JMI113
      *                                                               *
      *  Function:  This program is used to populate SDGCMSPD         *
      *                                                               *
      ***Called*By:*SD9005X*via*WN0100*********************************                   JMI113
      *  Called By: SD9005X                                           *                   JMI113
      *                                                               *
      ***(c)*Misys*International*Banking*Systems*Ltd.*2007*************                   JMI113
      *  (c) Finastra International Limited 2018                      *                   JMI113
      *                                                               *
      *  Last Amend No. JMI113             Date 17May18               *
      *  Prev Amend No. JMI019  *Create    Date 23Feb07               *
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

     F**********SDGCMSL1  UF A E           K DISK                                         JMI113
     FXXGCMSL1  UF A E           K DISK                                                   JMI113

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
     D  DMSGID                        7A

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

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D @FMT          E DS                  EXTNAME(DSFDY)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @RUN            S              1
     D @Return         s              7a
     D @Action         s              1a
     D*JMI019***       S              1    inz('N')                                       JMI113
     D JMI113          S              1    inz('N')                                       JMI113
     D @RtCd           S              7    inz(' ')
     D @Optn           S              7
     D @Sard           S              6


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

     C**********         If        JMI019 = 'Y' and
     C**********                   UPSEQ = '00001'
     C                   If        UPSEQ = '00001'

      * Upgrade /COPY SD9005XC04

     C                   Eval      J0MAXT = 0
     C                   Eval      J0HREP = 0
     C                   Eval      J0LCD  = 0
     C                   Eval      J0101H = *blanks
     C                   Eval      J0101U = *blanks
     C                   Eval      J0101P = *blanks
     C                   Eval      J09NNH = *blanks
     C                   Eval      J09NNU = *blanks
     C                   Eval      J09NNP = *blanks
     C                   Eval      J0999F = 0
     C                   Eval      J0101T = *blanks
     C                   Eval      J09NNT = *blanks
     C                   Eval      J0PYMR = 0
     C                   Eval      J0PYOP = *blanks
     C                   Eval      J0PYIP = *blanks
     C                   Eval      J0PYSM = 0
     C                   Eval      J0PYBC = *blanks
     C                   Eval      J0PYPC = *blanks
     C                   Eval      J09NNC = *blanks
     C                   Eval      J19NNC = *blanks
     C                   Eval      J0999H = *blanks
     C                   Eval      J0999U = *blanks
     C                   Eval      J0999P = *blanks
     C                   Eval      J0999T = *blanks
     C                   Eval      J0999C = *blanks
     C                   Eval      J0MAX9 = 0
     C                   Eval      J0REP9 = 0

     C                   Eval      J0GKEY = 'GCMS'
     C                   Eval      J0TYLC = 'I'
     C                   Eval      J0942F = 15
     C                   Eval      J0PYPF = 15

     C*****J0GKEY        Chain(e)  SDGCMSP0                                               JMI113
     C**********         If        %found(SDGCMSL1)                                       JMI113
     C     J0GKEY        Chain(e)  XXGCMSP0                                               JMI113
     C                   If        %found(XXGCMSL1)                                       JMI113
     C                   Eval      @Return = '*ERROR'
     C                   Else
     C**********         Write(e)  SDGCMSP0                                               JMI113
     C                   Write(e)  XXGCMSP0                                               JMI113
     C                   If        %error
     C                   Eval      @Return = 'Y2U0004'
     C                   EndIf
     C                   EndIf

      ***JMI019*=*'Y'                                                                     JMI113
      *
     C                   EndIf

     C                   Eval      *INLR = *ON
     C                   Return

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

     C**********         Eval      JMI019 = 'N'                                           JMI113
     C**********         Call      'AOSARDR0'                                             JMI113
     C**********         Parm      *BLANKS       @RtCd                                    JMI113
     C**********         Parm      '*VERIFY'     @Optn                                    JMI113
     C**********         Parm      'JMI019'      @Sard                                    JMI113
     C*****SCSARD        Parm      SCSARD        @FMT                                     JMI113
      **********                                                                          JMI113
     C**********         If        @RtCd  = *blanks                                       JMI113
     C**********         Eval      JMI019 = 'Y'                                           JMI113
     C**********         ElseIf    @RtCd <> '*NRF   '                                     JMI113
     C******LOCK         In        LDA                                                    JMI113
     C**********         Eval      *INU7 = *ON                                            JMI113
     C**********         Eval      *INU8 = *ON                                            JMI113
     C**********         Eval      DBFILE =  'SCSARDPD'                                   JMI113
     C**********         Eval      DBKEY  =  'JMI019'                                     JMI113
     C**********         Eval      DBPGM  =  PSProcPgm                                    JMI113
     C**********         Eval      DBASE  =  001                                          JMI113
     C**********         Eval      DBMOD  =  PSProcMod                                    JMI113
     C**********         Out       LDA                                                    JMI113
     C**********         ExSr      *PSSR                                                  JMI113
     C**********         EndIf                                                            JMI113

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
