     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas XX FT OP Sequence number calculation')           *                       JMI106
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      ***FTJ040V0*-*Midas*FT*Invisible*Window*for*Outgoing*Payments****                       JMI106
      *  XXPREFV0 - Midas XX FT OP Sequence number calculation        *                       JMI106
      *                                                               *
      *  Function:  This program is being called to obtain the        *
      *  relevant sequence number for the settlement type             *
      *  if the settlement type is 01, 02, 08, 10, 12 or 13.          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. JMI106             Date 24May18               *
      *  Prev Amend No. JMI017  *CREATE    Date 29Nov06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI106 - Split FT Sequence Number based on Settlement Type   *
      *           (Upgrade to FB Midas)                               *
      *  JMI017 - Split FT Sequence Number based on Settlement Type   *
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
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
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
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
      ** External Data Structure - SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** Short data structure for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Data Area giving Installation Control Details

     D DATA2           DS          1024
     D   UPSEQ                 1      5
     D   STMT                  6      7  0
     D***DPSEQ**               8     11  0                                                    JMI106
     D   DPSEQ                 8     11                                                       JMI106

     D DATAI           DS            99
     D   DIN01                 1      1
     D   DIN02                 2      2
     D   DIN03                 3      3
     D   DIN04                 4      4
     D   DIN05                 5      5
     D   DIN06                 6      6
     D   DIN07                 7      7
     D   DIN08                 8      8
     D   DIN09                 9      9
     D   DIN10                10     10
     D   DIN11                11     11
     D   DIN12                12     12
     D   DIN13                13     13
     D   DIN14                14     14
     D   DIN15                15     15
     D   DIN16                16     16
     D   DIN17                17     17
     D   DIN18                18     18
     D   DIN19                19     19
     D   DIN20                20     20
     D   DIN21                21     21
     D   DIN22                22     22
     D   DIN23                23     23
     D   DIN24                24     24
     D   DIN25                25     25
     D   DIN26                26     26
     D   DIN27                27     27
     D   DIN28                28     28
     D   DIN29                29     29
     D   DIN30                30     30
     D   DIN31                31     31
     D   DIN32                32     32
     D   DIN33                33     33
     D   DIN34                34     34
     D   DIN35                35     35
     D   DIN36                36     36
     D   DIN37                37     37
     D   DIN38                38     38
     D   DIN39                39     39
     D   DIN40                40     40
     D   DIN41                41     41
     D   DIN42                42     42
     D   DIN43                43     43
     D   DIN44                44     44
     D   DIN45                45     45
     D   DIN46                46     46
     D   DIN47                47     47
     D   DIN48                48     48
     D   DIN49                49     49
     D   DIN50                50     50
     D   DIN51                51     51
     D   DIN52                52     52
     D   DIN53                53     53
     D   DIN54                54     54
     D   DIN55                55     55
     D   DIN56                56     56
     D   DIN57                57     57
     D   DIN58                58     58
     D   DIN59                59     59
     D   DIN60                60     60
     D   DIN61                61     61
     D   DIN62                62     62
     D   DIN63                63     63
     D   DIN64                64     64
     D   DIN65                65     65
     D   DIN66                66     66
     D   DIN67                67     67
     D   DIN68                68     68
     D   DIN69                69     69
     D   DIN70                70     70
     D   DIN71                71     71
     D   DIN72                72     72
     D   DIN73                73     73
     D   DIN74                74     74
     D   DIN75                75     75
     D   DIN76                76     76
     D   DIN77                77     77
     D   DIN78                78     78
     D   DIN79                79     79
     D   DIN80                80     80
     D   DIN81                81     81
     D   DIN82                82     82
     D   DIN83                83     83
     D   DIN84                84     84
     D   DIN85                85     85
     D   DIN86                86     86
     D   DIN87                87     87
     D   DIN88                88     88
     D   DIN89                89     89
     D   DIN90                90     90
     D   DIN91                91     91
     D   DIN92                92     92
     D   DIN93                93     93
     D   DIN94                94     94
     D   DIN95                95     95
     D   DIN96                96     96
     D   DIN97                97     97
     D   DIN98                98     98
     D   DIN99                99     99

     D DATAF1          DS          5000
     D DATAF2          DS          5000
     D DATAF3          DS          5000
     D DATAF4          DS          5000

     D OTPAYDA         DS             4
     D   OTPAY                 1      4  0

     D OTPAYD          DS             4                                                       JMI106
     D   WOTSQ                 1      4  0                                                    JMI106

     D*OTP01DA*********DS**           4                                                       JMI106
     D XXOT01DA        DS             4                                                       JMI106
     D   OTP01                 1      4  0

     D*OTP02DA*********DS**           4                                                       JMI106
     D XXOT02DA        DS             4                                                       JMI106
     D   OTP02                 1      4  0

     D*OTP08DA*********DS**           4                                                       JMI106
     D XXOT08DA        DS             4                                                       JMI106
     D   OTP08                 1      4  0

     D*OTP10DA*********DS**           4                                                       JMI106
     D XXOT10DA        DS             4                                                       JMI106
     D   OTP10                 1      4  0

     D*OTP12DA*********DS**           4                                                       JMI106
     D XXOT12DA        DS             4                                                       JMI106
     D   OTP12                 1      4  0

     D*OTP13DA*********DS**           4                                                       JMI106
     D XXOT13DA        DS             4                                                       JMI106
     D   OTP13                 1      4  0

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @RUN            S              1
     D ACTION          S              1A
     D RETURN          S              7A

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
      ** Read in Installation Data
      *
     C                   SELECT
     C     UPSEQ         WHENEQ    '00001'
     C                   EXSR      SR00001

     C     UPSEQ         WHENEQ    '00002'
     C                   EXSR      SR00002
     C                   ENDSL

     C                   Return

      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR00001 - Processing subroutine for User Process 00001        *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SR00001       BEGSR

      ***switchable*feature*JMI017*is*On*******************************                       JMI106
 B1  C**********         If        JMI017 = 'Y'                                               JMI106
      ** switchable feature JMI106 is On                                                      JMI106
 B1  C                   If        JMI106 = 'Y'                                               JMI106

     C                   If        STMT = 01
     C                             or STMT = 02
     C                             or STMT = 08
     C                             or STMT = 10
     C                             or STMT = 12
     C                             or STMT = 13
     C******LOCK         IN        OTPAYDA                                                    JMI106
     C**********         SUB       1             OTPAY                                        JMI106
     C**********         OUT       OTPAYDA                                                    JMI106
     C     *LOCK         IN        OTPAYD                                                     JMI106
     C                   SUB       1             WOTSQ                                        JMI106
     C                   OUT       OTPAYD                                                     JMI106

     C                   Select

     C                   When      STMT =  01
     C******LOCK         IN        OTP01DA                                                    JMI106
     C**********         Z-ADD     OTP01         DPSEQ                                        JMI106
     C     *LOCK         IN        XXOT01DA                                                   JMI106
     C                   MoveL     OTP01         DPSEQ                                        JMI106
     C                   ADD       1             OTP01
     C**********         OUT       OTP01DA                                                    JMI106
     C                   OUT       XXOT01DA                                                   JMI106

     C                   When      STMT =  02
     C******LOCK         IN        OTP02DA                                                    JMI106
     C**********         Z-ADD     OTP02         DPSEQ                                        JMI106
     C     *LOCK         IN        XXOT02DA                                                   JMI106
     C                   MoveL     OTP02         DPSEQ                                        JMI106
     C                   ADD       1             OTP02
     C**********         OUT       OTP02DA                                                    JMI106
     C                   OUT       XXOT02DA                                                   JMI106

     C                   When      STMT =  08
     C******LOCK         IN        OTP08DA                                                    JMI106
     C**********         Z-ADD     OTP08         DPSEQ                                        JMI106
     C     *LOCK         IN        XXOT08DA                                                   JMI106
     C                   MoveL     OTP08         DPSEQ                                        JMI106
     C                   ADD       1             OTP08
     C**********         OUT       OTP08DA                                                    JMI106
     C                   OUT       XXOT08DA                                                   JMI106

     C                   When      STMT =  10
     C******LOCK         IN        OTP10DA                                                    JMI106
     C**********         Z-ADD     OTP10         DPSEQ                                        JMI106
     C     *LOCK         IN        XXOT10DA                                                   JMI106
     C                   MoveL     OTP10         DPSEQ                                        JMI106
     C                   ADD       1             OTP10
     C**********         OUT       OTP10DA                                                    JMI106
     C                   OUT       XXOT10DA                                                   JMI106

     C                   When      STMT =  12
     C******LOCK         IN        OTP12DA                                                    JMI106
     C**********         Z-ADD     OTP12         DPSEQ                                        JMI106
     C     *LOCK         IN        XXOT12DA                                                   JMI106
     C                   MoveL     OTP12         DPSEQ                                        JMI106
     C                   ADD       1             OTP12
     C**********         OUT       OTP12DA                                                    JMI106
     C                   OUT       XXOT12DA                                                   JMI106

     C                   When      STMT = 13
     C******LOCK         IN        OTP13DA                                                    JMI106
     C**********         Z-ADD     OTP13         DPSEQ                                        JMI106
     C     *LOCK         IN        XXOT13DA                                                   JMI106
     C                   MoveL     OTP13         DPSEQ                                        JMI106
     C                   ADD       1             OTP13
     C**********         OUT       OTP13DA                                                    JMI106
     C                   OUT       XXOT13DA                                                   JMI106

     C                   EndSL

     C                   EndIF
     C                   EndIF

     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR00002 - Processing subroutine for User Process 00002        *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SR00002       BEGSR

      ***switchable*feature*JMI017*is*On*******************************                       JMI106
 B1  C**********         If        JMI017 = 'Y'                                               JMI106
      ** switchable feature JMI106 is On                                                      JMI106
 B1  C                   If        JMI106 = 'Y'                                               JMI106

     C                   If        STMT =  01
     C                             or STMT =  02
     C                             or STMT =  08
     C                             or STMT =  10
     C                             or STMT =  12
     C                             or STMT =  13
     C******LOCK         IN        OTPAYDA                                                    JMI106
     C**********         ADD       1             OTPAY                                        JMI106
     C**********         OUT       OTPAYDA                                                    JMI106
     C     *LOCK         IN        OTPAYD                                                     JMI106
     C                   ADD       1             WOTSQ                                        JMI106
     C                   OUT       OTPAYD                                                     JMI106

     C                   Select

     C                   When      STMT =  01
     C******LOCK         IN        OTP01DA                                                    JMI106
     C     *LOCK         IN        XXOT01DA                                                   JMI106
     C                   SUB       1             OTP01
     C**********         OUT       OTP01DA                                                    JMI106
     C                   OUT       XXOT01DA                                                   JMI106

     C                   When      STMT =  02
     C******LOCK         IN        OTP02DA                                                    JMI106
     C     *LOCK         IN        XXOT02DA                                                   JMI106
     C                   SUB       1             OTP02
     C**********         OUT       OTP02DA                                                    JMI106
     C                   OUT       XXOT02DA                                                   JMI106

     C                   When      STMT =  08
     C******LOCK         IN        OTP08DA                                                    JMI106
     C     *LOCK         IN        XXOT08DA                                                   JMI106
     C                   SUB       1             OTP08
     C**********         OUT       OTP08DA                                                    JMI106
     C                   OUT       XXOT08DA                                                   JMI106

     C                   When      STMT =  10
     C******LOCK         IN        OTP10DA                                                    JMI106
     C     *LOCK         IN        XXOT10DA                                                   JMI106
     C                   SUB       1             OTP10
     C**********         OUT       OTP10DA                                                    JMI106
     C                   OUT       XXOT10DA                                                   JMI106

     C                   When      STMT =  12
     C******LOCK         IN        OTP12DA                                                    JMI106
     C     *LOCK         IN        XXOT12DA                                                   JMI106
     C                   SUB       1             OTP12
     C**********         OUT       OTP12DA                                                    JMI106
     C                   OUT       XXOT12DA                                                   JMI106

     C                   When      STMT =  13
     C******LOCK         IN        OTP13DA                                                    JMI106
     C     *LOCK         IN        XXOT13DA                                                   JMI106
     C                   SUB       1             OTP13
     C**********         OUT       OTP13DA                                                    JMI106
     C                   OUT       XXOT13DA                                                   JMI106

     C                   EndSL

     C                   EndIF
     C                   EndIF

     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *entry        PLIST
     C                   PARM                    ACTION
     C                   PARM                    DATA2
     C                   PARM                    DATAI
     C                   PARM                    DATAF1
     C                   PARM                    DATAF2
     C                   PARM                    DATAF3
     C                   PARM                    DATAF4
     C                   PARM                    RETURN

     C     *DTAARA       DEFINE                  OTPAYDA

     C******DTAARA       DEFINE                  OTP01DA                                      JMI106
     C     *DTAARA       DEFINE                  XXOT01DA                                     JMI106

     C******DTAARA       DEFINE                  OTP02DA                                      JMI106
     C     *DTAARA       DEFINE                  XXOT02DA                                     JMI106

     C******DTAARA       DEFINE                  OTP08DA                                      JMI106
     C     *DTAARA       DEFINE                  XXOT08DA                                     JMI106

     C******DTAARA       DEFINE                  OTP10DA                                      JMI106
     C     *DTAARA       DEFINE                  XXOT10DA                                     JMI106

     C******DTAARA       DEFINE                  OTP12DA                                      JMI106
     C     *DTAARA       DEFINE                  XXOT12DA                                     JMI106

     C******DTAARA       DEFINE                  OTP13DA                                      JMI106
     C     *DTAARA       DEFINE                  XXOT13DA                                     JMI106
     C     *DTAARA       DEFINE    OTPAYDA       OTPAYD                                       JMI106

      ***Check*switchable*feature*JMI017******************************                        JMI106
      ** Check switchable feature JMI106                                                      JMI106
     C                   Call      'AOSARDR0'
     C                   Parm      *Blanks       @Rtcd             7
     C                   Parm      '*VERIFY'     @Optn             7
     C**********         Parm      'JMI017'      @Sard             6                          JMI106
     C                   Parm      'JMI106'      @Sard             6                          JMI106
     C     SCSARD        Parm      SCSARD        DSFDY

     C                   If        @Rtcd = *Blanks
     C**********         Move      'Y'           JMI017            1                          JMI106
     C                   Move      'Y'           JMI106            1                          JMI106
     C                   Else
     C**********         Move      'N'           JMI017                                       JMI106
     C                   Move      'N'           JMI106                                       JMI106
     C                   Endif

     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP

     C                   CALL      'DBERRCTL'

     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

