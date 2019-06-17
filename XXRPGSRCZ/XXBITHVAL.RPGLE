     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL JE Header Val Control Invisible Window')      *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      ***GLBITHVLV0*-*Journal*Entry Header*Validation*Control**********                       JMI111
      *  XXBITHVAL  - Journal Entry Header Validation Control         *
      *              Invisible Window                                 *
      *                                                               *
      *  Function:  This program is being called by GLBITHVAL to      *
      *  check if the entered batch number is not within the          *
      *  Midas/OPICS batch number range defined in the ICD,           *
      *  if CGL019 feature is switched ON.                            *
      *                                                               *
      ***(c)*Misys*International*Banking*Systems*Ltd.*2007*************                       JMI111
      *  (c) Finastra  International Limited 2018                     *                       JMI111
      *                                                               *
      *  Last Amend No. JMI111             Date 18May18               *
      *  Prev Amend No. CGL019  *CREATE    Date 20Apr07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI111 - Midas-OPICS Interface. Upgrade to FBM 2.1           *
      *  CGL019 - OPICS-Midas GL Interface                            *
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

     F*SDOPINPD**IF   E             DISK    INFSR(*pssr)                                      JMI111
     FXXOPINPD  IF   E             DISK    INFSR(*pssr)                                       JMI111

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
     D   D#BTNB                6      8
     D   D#LRBN                9     11
     D   D#URBN               12     14
     D   D#MSG                15     24

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
     C     UPSEQ         IFEQ      '00001'
     C                   EXSR      SR00001
     C                   ENDIF

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

     C*****CGL019        Ifeq      'Y'                                                        JMI111

     C*****1*****        SETLL     SDOPINPD                                                   JMI111
     C***********        Read      SDOPINPD                               01                  JMI111
     C     1             SETLL     XXOPINPD                                                   JMI111
     C                   Read      XXOPINPD                               01                  JMI111

     C                   IF        *IN01 = *ON
     C                   Eval      D#MSG  = '*ERROR'
     C                   Endif

     C                   IF        *IN01 = *OFF
     C                   Move      D#BTNB        UBATNO            3 0
     C     UBATNO        IfGE      OPLRBN
     C     UBATNO        AndLE     OPURBN
     C                   Move      OPLRBN        D#LRBN
     C                   Move      OPURBN        D#URBN
     C                   Eval      D#MSG  = 'GLX0511'
     C                   Endif
     C                   Endif

     C***********        Endif                                                                JMI111

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

      ***Check*switchable*feature*CGL019                                                      JMI111
     C**********         Call      'AOSARDR0'                                                 JMI111
     C**********         Parm      *Blanks       @Rtcd9            7                          JMI111
     C**********         Parm      '*VERIFY'     @Optn             7                          JMI111
     C**********         Parm      'CGL019'      @Sard             6                          JMI111
     C*****SCSARD        Parm      SCSARD        DSFDY                                        JMI111

     C**********         If        @Rtcd = *Blanks                                            JMI111
     C**********         Move      'Y'           CGL019            1                          JMI111
     C**********         Else                                                                 JMI111
     C**********         Move      'N'           CGL019            1                          JMI111
     C**********         Endif                                                                JMI111

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

