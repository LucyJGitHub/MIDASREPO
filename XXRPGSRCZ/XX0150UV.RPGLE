     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Invisible Window for GL0150U')                *
      *****************************************************************
      *                                                               *
      *  Midas - GL Module                                            *
      *                                                               *
      ***GL0150UV0*-*Midas*GL*Invisible Window for GL0150U*************         JMI108
      *  XX0150UV  - Midas GL Invisible Window for GL0150U            *         JMI108
      *                                                               *
      ***Function:**This*program*updates records on GLJEIPXA with******         JMI108
      *  Function:  This program updates records on XXJEIPXA with     *         JMI108
      *     batch number so that interface batch number and batch     *
      *     number are store when Account pooling interface batch     *
      *     entry is processed.                                       *
      *                                                               *
      ***Called*By:*GL0150U*via WN0100*********************************         JMI108
      *  Called By: XX0150U                                           *         JMI108
      *                                                               *
      ***(c)*Misys*International*Banking*Systems*Ltd.*2007*************         JMI108
      *  (c) Finastra International Limited 2018                      *         JMI108
      *                                                               *
      *  Last Amend No. JMI108             Date 31May18               *
      *  Prev Amend No. TFJ011  *CREATE    Date 24Jan07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI108 - Account Balance Pooling. Upgrade to FBM 2.1         *
      *  TFJ011 - Account Pooling                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
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

     F***GLJEIPYA  UF   E           K DISK    INFSR(*PSSR)                      JMI108
     FXXJEIPYA  UF   E           K DISK    INFSR(*PSSR)                         JMI108

     F***SDPSTSV2  UF   E           K DISK    INFSR(*PSSR)                      JMI108
     FXXPSTSV2  UF   E           K DISK    INFSR(*PSSR)                         JMI108

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
     D  UPSEQ                         5
     D  WBTNB                         3
     D  BTBTNB                        3
     D  BTBINB                        3  0

     D DataI           ds           101
     D  Din001                        1
     D  Din002                        1
     D  Din003                        1
     D  Din004                        1
     D  Din005                        1
     D  Din006                        1
     D  Din007                        1
     D  Din008                        1
     D  Din009                        1
     D  Din010                        1
     D  Din011                        1
     D  Din012                        1
     D  Din013                        1
     D  Din014                        1
     D  Din015                        1
     D  Din016                        1
     D  Din017                        1
     D  Din018                        1
     D  Din019                        1
     D  Din020                        1
     D  Din021                        1
     D  Din022                        1
     D  Din023                        1
     D  Din024                        1
     D  Din025                        1
     D  Din026                        1
     D  Din027                        1
     D  Din028                        1
     D  Din029                        1
     D  Din030                        1
     D  Din031                        1
     D  Din032                        1
     D  Din033                        1
     D  Din034                        1
     D  Din035                        1
     D  Din036                        1
     D  Din037                        1
     D  Din038                        1
     D  Din039                        1
     D  Din040                        1
     D  Din041                        1
     D  Din042                        1
     D  Din043                        1
     D  Din044                        1
     D  Din045                        1
     D  Din046                        1
     D  Din047                        1
     D  Din048                        1
     D  Din049                        1
     D  Din050                        1
     D  Din051                        1
     D  Din052                        1
     D  Din053                        1
     D  Din054                        1
     D  Din055                        1
     D  Din056                        1
     D  Din057                        1
     D  Din058                        1
     D  Din059                        1
     D  Din060                        1
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

     D @RtCd           S              7    inz(' ')
     D @Optn           S              7
     D @Sard           S              6

     D KBTNB           S                   like(WBTNB)
     D KTBINB          S                   like(BTBINB)

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

     C****************** If        TFJ011 = 'Y' and                             JMI108
     C******************           UPSEQ = '00001'                              JMI108
     C                   If        UPSEQ = '00001'                              JMI108

     C                   Eval      KBTNB  = WBTNB
     C                   Eval      KTBINB = BTBINB

      * Update batch interface extension file

     C**** KGLJ1         Chain     GLJEIPYA                                     JMI108
     C****               If        %found(GLJEIPYA)                             JMI108
     C     KGLJ1         Chain     XXJEIPYA                                     JMI108
     C                   If        %found(XXJEIPYA)                             JMI108
     C                   Eval      JBTNB = BTBTNB
     C****************** Update    GLJEIPDA                                     JMI108
     C                   Update    XXJEIPDA                                     JMI108

      * Update Account pooling status file

     C**** JIBTNB        Chain     SDPSTSV2                                     JMI108
     C****               If        %found(SDPSTSV2)                             JMI108
     C     JIBTNB        Chain     XXPSTSV2                                     JMI108
     C                   If        %found(XXPSTSV2)                             JMI108
     C                   Eval      JBTCH = BTBTNB
     C****************** Update    SDPSTSD0                                     JMI108
     C                   Update    XXPSTSD0                                     JMI108
     C                   EndIf
     C                   EndIf

      ***TFJ011*=*'Y'******                                                     JMI108
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

     C     KGLJ1         KList
     C                   KFld                    KBTNB
     C                   KFld                    KTBINB

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
